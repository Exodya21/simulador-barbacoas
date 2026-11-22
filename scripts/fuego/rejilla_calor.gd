@tool
class_name RejillaCalor
extends Node3D
## Rejilla de zonas de calor de la parrilla.
##
## Divide la superficie de la parrilla en celdas. Cada celda tiene una cantidad
## de brasas debajo (0 = nada, 1 = lleno). La temperatura de cada celda depende
## de sus brasas y de las vecinas (el calor se reparte un poco) y de la altura
## de la rejilla sobre las brasas.
##
## El origen del nodo es el centro de la superficie de la rejilla (donde se
## apoya la comida). X es el ancho y Z el fondo.

const GRUPO := "rejilla_calor"

## Tamaño de la superficie en metros (ancho X, fondo Z).
@export var tamano := Vector2(1.6, 0.8)
## Número de celdas (columnas en X, filas en Z).
@export var celdas := Vector2i(8, 4)
## Brasas por celda, de 0 a 1, fila a fila. Si está vacío se rellena con dos
## zonas: directa a la izquierda e indirecta a la derecha.
@export var brasas: PackedFloat32Array
## Temperatura del aire, en °C.
@export var temperatura_ambiente := 20.0
## Temperatura de la rejilla sobre una celda llena de brasas a la altura de
## referencia, en °C.
@export var temperatura_maxima := 260.0
## Altura de la rejilla sobre las brasas, en metros. Más alto = menos calor.
@export_range(0.05, 0.6, 0.01) var altura := 0.15
## Altura a la que se da la temperatura máxima.
@export var altura_referencia := 0.15
## Segundos que tarda una celda en acercarse a su temperatura (inercia del
## metal y de las brasas). 0 = cambia al momento.
@export var inercia := 8.0

var _temperaturas: PackedFloat32Array
var _malla_depuracion: MultiMeshInstance3D
var _reloj_depuracion := 0.0


func _ready() -> void:
	add_to_group(GRUPO)
	_asegurar_datos()
	if not Engine.is_editor_hint():
		_crear_depuracion()


## Prepara las brasas y temperaturas si aún no lo están (también fuera del árbol).
func _asegurar_datos() -> void:
	if brasas.size() != celdas.x * celdas.y:
		brasas = brasas_dos_zonas(celdas)
	if _temperaturas.size() != celdas.x * celdas.y:
		_temperaturas.resize(celdas.x * celdas.y)
		for i in _temperaturas.size():
			_temperaturas[i] = _temperatura_objetivo(i % celdas.x, i / celdas.x)


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	_asegurar_datos()
	var mezcla := 1.0 if inercia <= 0.0 else 1.0 - exp(-delta / inercia)
	for i in _temperaturas.size():
		var objetivo := _temperatura_objetivo(i % celdas.x, i / celdas.x)
		_temperaturas[i] += (objetivo - _temperaturas[i]) * mezcla
	_reloj_depuracion -= delta
	if _malla_depuracion and _malla_depuracion.visible and _reloj_depuracion <= 0.0:
		_reloj_depuracion = 0.2
		_pintar_depuracion()


## Dos zonas como en una parrilla real: la mitad izquierda llena de brasas
## (directa), una franja de transición y la derecha casi sin brasas (indirecta).
static func brasas_dos_zonas(n: Vector2i) -> PackedFloat32Array:
	var resultado := PackedFloat32Array()
	resultado.resize(n.x * n.y)
	for z in n.y:
		for x in n.x:
			var t := float(x) / maxi(1, n.x - 1)
			var valor := 1.0 if t < 0.45 else (0.6 if t < 0.65 else 0.35)
			resultado[z * n.x + x] = valor
	return resultado


## Celda que hay bajo un punto (en coordenadas globales), o (-1, -1) si cae fuera.
func celda_en(posicion_global: Vector3) -> Vector2i:
	var local := to_local(posicion_global)
	var tam_celda := Vector2(tamano.x / celdas.x, tamano.y / celdas.y)
	var x := floori((local.x + tamano.x * 0.5) / tam_celda.x)
	var z := floori((local.z + tamano.y * 0.5) / tam_celda.y)
	if x < 0 or z < 0 or x >= celdas.x or z >= celdas.y:
		return Vector2i(-1, -1)
	return Vector2i(x, z)


## True si el punto está encima de la rejilla y a menos de `margen` metros de ella.
func esta_sobre(posicion_global: Vector3, margen: float) -> bool:
	var local := to_local(posicion_global)
	return celda_en(posicion_global) != Vector2i(-1, -1) and local.y >= -0.01 and local.y <= margen


## Temperatura de la rejilla bajo un punto, en °C. Fuera de la rejilla, la del aire.
func temperatura_en(posicion_global: Vector3) -> float:
	var c := celda_en(posicion_global)
	if c.x < 0:
		return temperatura_ambiente
	return temperatura_celda(c.x, c.y)


func temperatura_celda(x: int, z: int) -> float:
	_asegurar_datos()
	return _temperaturas[z * celdas.x + x]


func poner_brasas(x: int, z: int, cantidad: float) -> void:
	_asegurar_datos()
	brasas[z * celdas.x + x] = clampf(cantidad, 0.0, 1.0)


func _temperatura_objetivo(x: int, z: int) -> float:
	var factor_altura := clampf(altura_referencia / altura, 0.25, 1.6)
	return temperatura_ambiente + (temperatura_maxima - temperatura_ambiente) * _brasas_repartidas(x, z) * factor_altura


## Brasas de la celda mezcladas con las de sus cuatro vecinas.
func _brasas_repartidas(x: int, z: int) -> float:
	var suma := brasas[z * celdas.x + x] * 0.6
	var peso := 0.6
	for d: Vector2i in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
		var v := Vector2i(x, z) + d
		if v.x >= 0 and v.y >= 0 and v.x < celdas.x and v.y < celdas.y:
			suma += brasas[v.y * celdas.x + v.x] * 0.1
			peso += 0.1
	return suma / peso


# --- Depuración: un cuadro de color por celda (azul frío → rojo caliente) ---

func _crear_depuracion() -> void:
	var tam_celda := Vector2(tamano.x / celdas.x, tamano.y / celdas.y)
	var plano := PlaneMesh.new()
	plano.size = tam_celda * 0.9
	var material := StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.vertex_color_use_as_albedo = true
	material.no_depth_test = false
	plano.material = material
	var multi := MultiMesh.new()
	multi.transform_format = MultiMesh.TRANSFORM_3D
	multi.use_colors = true
	multi.mesh = plano
	multi.instance_count = celdas.x * celdas.y
	for z in celdas.y:
		for x in celdas.x:
			var centro := Vector3(
				-tamano.x * 0.5 + (x + 0.5) * tam_celda.x, 0.005,
				-tamano.y * 0.5 + (z + 0.5) * tam_celda.y)
			multi.set_instance_transform(z * celdas.x + x, Transform3D(Basis(), centro))
	_malla_depuracion = MultiMeshInstance3D.new()
	_malla_depuracion.name = "DepuracionCalor"
	_malla_depuracion.multimesh = multi
	_malla_depuracion.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(_malla_depuracion)
	var dep := get_node_or_null("/root/Depuracion")
	_malla_depuracion.visible = dep.activa if dep else false
	if dep:
		dep.cambiado.connect(func(activa: bool) -> void: _malla_depuracion.visible = activa)
	_pintar_depuracion()


func _pintar_depuracion() -> void:
	var multi := _malla_depuracion.multimesh
	for i in _temperaturas.size():
		var t := inverse_lerp(temperatura_ambiente, temperatura_maxima, _temperaturas[i])
		var color := Color(0.2, 0.4, 1.0).lerp(Color(1.0, 0.85, 0.1), clampf(t * 2.0, 0.0, 1.0))
		if t > 0.5:
			color = Color(1.0, 0.85, 0.1).lerp(Color(1.0, 0.1, 0.05), clampf((t - 0.5) * 2.0, 0.0, 1.0))
		color.a = 0.45
		multi.set_instance_color(i, color)
