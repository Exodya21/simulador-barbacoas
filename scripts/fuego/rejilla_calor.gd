@tool
class_name RejillaCalor
extends Node3D
## Rejilla de zonas de calor de la parrilla, con brasas vivas debajo.
##
## Divide la superficie de la parrilla en celdas. Debajo de cada celda hay:
## - **carbón**: cuánto carbón queda (0 = nada, 1 = celda llena). Se gasta
##   mientras arde.
## - **fuego**: lo encendido que está ese carbón (0 = apagado, 1 = al rojo).
##   Sin avivar baja poco a poco hasta un valor de reposo (las brasas se
##   cubren de ceniza); el abanico lo sube. El fuego pasa despacio a las celdas
##   vecinas que tienen carbón.
## El calor de cada celda sale de su fuego y su carbón. La temperatura de la
## rejilla depende del calor de la celda y de las vecinas (se reparte un poco)
## y de la altura de la rejilla sobre las brasas.
##
## El origen del nodo es el centro de la superficie de la rejilla (donde se
## apoya la comida). X es el ancho y Z el fondo.

const GRUPO := "rejilla_calor"
const BRASAS_POR_CELDA := 6

## Tamaño de la superficie en metros (ancho X, fondo Z).
@export var tamano := Vector2(1.6, 0.8)
## Número de celdas (columnas en X, filas en Z).
@export var celdas := Vector2i(8, 4)
## Si está activado, empieza con brasas encendidas en dos zonas (directa a la
## izquierda e indirecta a la derecha). Si no, empieza fría y sin carbón: hay
## que encenderla con la chimenea.
@export var empezar_encendida := true
## Temperatura del aire, en °C.
@export var temperatura_ambiente := 20.0
## Temperatura de la rejilla sobre una celda llena de brasas al rojo a la
## altura de referencia, en °C.
@export var temperatura_maxima := 260.0
## Altura de la rejilla sobre las brasas, en metros. Más alto = menos calor.
@export_range(0.05, 0.6, 0.01) var altura := 0.15
## Altura a la que se da la temperatura máxima.
@export var altura_referencia := 0.15
## Segundos que tarda una celda en acercarse a su temperatura (inercia del
## metal y de las brasas). 0 = cambia al momento.
@export var inercia := 8.0
## Luz que da el color de las brasas; su energía sigue al calor medio.
@export var luz: OmniLight3D
## Energía de la luz con toda la parrilla al rojo.
@export var energia_luz_maxima := 1.6
## Dibuja la rejilla como barras de metal (se ven las brasas entre ellas).
@export var crear_barras := false
## Separación (m) entre barras.
@export var separacion_barras := 0.04

@export_group("Brasas")
## Segundos que tarda en gastarse la mitad del carbón de una celda al rojo.
@export var vida_media_carbon := 420.0
## Fuego al que bajan solas las brasas sin avivar.
@export_range(0.0, 1.0, 0.01) var fuego_reposo := 0.7
## Segundos que tardan en bajar hacia el fuego de reposo.
@export var segundos_enfriar := 150.0
## Fuego que gana por segundo una celda con carbón junto a una vecina al rojo.
@export var propagacion := 0.012
## Fuego que gana por segundo una celda al avivarla de lleno con el abanico.
@export var fuerza_avivar := 0.35
## Cuánto más rápido se gasta el carbón mientras se aviva.
@export var gasto_extra_avivado := 1.5

## Calor efectivo de cada celda, de 0 a 1, fila a fila (fuego y carbón juntos).
var brasas: PackedFloat32Array
## Carbón que queda en cada celda, de 0 a 1.
var carbon: PackedFloat32Array
## Lo encendido que está el carbón de cada celda, de 0 a 1.
var fuego: PackedFloat32Array

var _temperaturas: PackedFloat32Array
## Lo avivada que está cada celda ahora mismo (baja sola al dejar de abanicar).
var _avivado: PackedFloat32Array
var _malla_depuracion: MultiMeshInstance3D
var _malla_brasas: MultiMeshInstance3D
var _reloj_depuracion := 0.0
var _reloj_brasas := 0.0


func _ready() -> void:
	add_to_group(GRUPO)
	_asegurar_datos()
	if crear_barras:
		_crear_barras()
	if not Engine.is_editor_hint():
		_crear_brasas()
		_crear_depuracion()


## Prepara los datos si aún no lo están (también fuera del árbol).
func _asegurar_datos() -> void:
	var n := celdas.x * celdas.y
	if carbon.size() != n:
		carbon.resize(n)
		fuego.resize(n)
		_avivado.resize(n)
		carbon.fill(0.0)
		fuego.fill(0.0)
		_avivado.fill(0.0)
		if empezar_encendida:
			_poner_dos_zonas()
	if brasas.size() != n:
		brasas.resize(n)
		_calcular_brasas()
	if _temperaturas.size() != n:
		_temperaturas.resize(n)
		_igualar_temperaturas()


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	_asegurar_datos()
	_simular_brasas(delta)
	var mezcla := 1.0 if inercia <= 0.0 else 1.0 - exp(-delta / inercia)
	for i in _temperaturas.size():
		var objetivo := _temperatura_objetivo(i % celdas.x, i / celdas.x)
		_temperaturas[i] += (objetivo - _temperaturas[i]) * mezcla
	_reloj_brasas -= delta
	if _reloj_brasas <= 0.0:
		_reloj_brasas = 0.1
		_pintar_brasas()
	_reloj_depuracion -= delta
	if _malla_depuracion and _malla_depuracion.visible and _reloj_depuracion <= 0.0:
		_reloj_depuracion = 0.2
		_pintar_depuracion()


# --- Simulación de las brasas ---

func _simular_brasas(delta: float) -> void:
	var fuego_antes := fuego.duplicate()
	var gasto := log(2.0) / maxf(vida_media_carbon, 0.01)
	var enfriar := 1.0 - exp(-delta / maxf(segundos_enfriar, 0.01))
	for i in carbon.size():
		_avivado[i] = maxf(0.0, _avivado[i] - delta * 2.0)
		if carbon[i] <= 0.0:
			fuego[i] = 0.0
			continue
		var f := fuego_antes[i]
		# El fuego pasa a las celdas vecinas que tienen carbón, hasta el reposo
		# (más arriba solo se llega abanicando).
		var vecina := _fuego_vecino_maximo(fuego_antes, i % celdas.x, i / celdas.x)
		var tope := minf(vecina, fuego_reposo)
		if f < tope:
			f = minf(tope, f + propagacion * vecina * (1.0 + 4.0 * _avivado[i]) * delta)
		# Sin avivar baja hacia el reposo (nunca sube sola por encima).
		if f > fuego_reposo and _avivado[i] <= 0.0:
			f += (fuego_reposo - f) * enfriar
		fuego[i] = clampf(f, 0.0, 1.0)
		# El carbón se gasta mientras arde, más deprisa si se aviva.
		carbon[i] -= carbon[i] * gasto * fuego[i] * (1.0 + gasto_extra_avivado * _avivado[i]) * delta
		if carbon[i] < 0.01:
			carbon[i] = 0.0
			fuego[i] = 0.0
	_calcular_brasas()


func _fuego_vecino_maximo(valores: PackedFloat32Array, x: int, z: int) -> float:
	var maximo := 0.0
	for d: Vector2i in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
		var v := Vector2i(x, z) + d
		if v.x >= 0 and v.y >= 0 and v.x < celdas.x and v.y < celdas.y:
			maximo = maxf(maximo, valores[v.y * celdas.x + v.x])
	return maximo


## Calor de cada celda: el fuego, que baja cuando queda menos de media celda de carbón.
func _calcular_brasas() -> void:
	for i in carbon.size():
		brasas[i] = fuego[i] * clampf(carbon[i] * 2.0, 0.0, 1.0)


## Echa carbón alrededor de un punto (coordenadas globales), repartido en un
## círculo de `radio` metros con más carbón en el centro. `cantidad` es el
## total en celdas llenas; `fuego_nuevo` lo encendido que llega (1 = al rojo,
## 0 = crudo). Devuelve el carbón que ha cabido.
func echar_carbon(posicion_global: Vector3, cantidad: float, fuego_nuevo: float, radio := 0.35) -> float:
	_asegurar_datos()
	var pesos := _pesos_circulo(posicion_global, radio)
	var total_pesos := 0.0
	for p: float in pesos.values():
		total_pesos += p
	if total_pesos <= 0.0:
		return 0.0
	var cabido := 0.0
	for i: int in pesos:
		var anadido := minf(cantidad * pesos[i] / total_pesos, 1.0 - carbon[i])
		if anadido <= 0.0:
			continue
		# El carbón nuevo se mezcla con el que había: si llega crudo, enfría.
		fuego[i] = (fuego[i] * carbon[i] + fuego_nuevo * anadido) / (carbon[i] + anadido)
		carbon[i] += anadido
		cabido += anadido
	_calcular_brasas()
	return cabido


## Saca hasta `cantidad` de carbón alrededor de un punto (para la pala).
## Devuelve {"carbon": lo sacado, "fuego": fuego medio de lo sacado}.
func sacar_carbon(posicion_global: Vector3, cantidad: float, radio := 0.2) -> Dictionary:
	_asegurar_datos()
	var pesos := _pesos_circulo(posicion_global, radio)
	var disponible := 0.0
	for i: int in pesos:
		disponible += carbon[i] * pesos[i]
	if disponible <= 0.0:
		return {"carbon": 0.0, "fuego": 0.0}
	var parte := minf(1.0, cantidad / disponible)
	var sacado := 0.0
	var fuego_sacado := 0.0
	for i: int in pesos:
		var quitado: float = carbon[i] * pesos[i] * parte
		carbon[i] -= quitado
		sacado += quitado
		fuego_sacado += fuego[i] * quitado
		if carbon[i] <= 0.001:
			carbon[i] = 0.0
			fuego[i] = 0.0
	_calcular_brasas()
	return {"carbon": sacado, "fuego": fuego_sacado / sacado if sacado > 0.0 else 0.0}


## Aviva las brasas alrededor de un punto durante `delta` segundos: sube el
## fuego de las celdas con carbón que ya tienen algo de fuego (o una vecina
## encendida), y lo gasta antes.
func avivar(posicion_global: Vector3, delta: float, radio := 0.3) -> void:
	_asegurar_datos()
	var pesos := _pesos_circulo(posicion_global, radio)
	for i: int in pesos:
		if carbon[i] <= 0.0:
			continue
		var vecina := _fuego_vecino_maximo(fuego, i % celdas.x, i / celdas.x)
		if fuego[i] < 0.02 and vecina < 0.02:
			continue
		var w: float = pesos[i]
		_avivado[i] = maxf(_avivado[i], w)
		fuego[i] = minf(1.0, fuego[i] + fuerza_avivar * w * delta)
	_calcular_brasas()


## Peso (0–1) de cada celda dentro de un círculo alrededor de un punto.
func _pesos_circulo(posicion_global: Vector3, radio: float) -> Dictionary:
	var local := _a_local(posicion_global)
	var tam_celda := Vector2(tamano.x / celdas.x, tamano.y / celdas.y)
	var pesos := {}
	for z in celdas.y:
		for x in celdas.x:
			var centro := Vector2(-tamano.x * 0.5 + (x + 0.5) * tam_celda.x, -tamano.y * 0.5 + (z + 0.5) * tam_celda.y)
			var d := centro.distance_to(Vector2(local.x, local.z))
			if d < radio:
				pesos[z * celdas.x + x] = 1.0 - d / radio * 0.6
	return pesos


## Enciende la parrilla con dos zonas como en una parrilla real: la mitad
## izquierda llena de brasas (directa), una franja de transición y la derecha
## casi sin brasas (indirecta). Con `al_momento`, la rejilla ya está caliente.
func encender_dos_zonas(al_momento := true) -> void:
	_asegurar_datos()
	_poner_dos_zonas()
	_calcular_brasas()
	if al_momento:
		_igualar_temperaturas()


func _poner_dos_zonas() -> void:
	var calor := brasas_dos_zonas(celdas)
	for i in calor.size():
		carbon[i] = 1.0 if calor[i] >= 1.0 else calor[i] * 0.5
		fuego[i] = 1.0


func _igualar_temperaturas() -> void:
	for i in _temperaturas.size():
		_temperaturas[i] = _temperatura_objetivo(i % celdas.x, i / celdas.x)


## Calor de cada celda en dos zonas: directa a la izquierda, transición e
## indirecta a la derecha.
static func brasas_dos_zonas(n: Vector2i) -> PackedFloat32Array:
	var resultado := PackedFloat32Array()
	resultado.resize(n.x * n.y)
	for z in n.y:
		for x in n.x:
			var t := float(x) / maxi(1, n.x - 1)
			var valor := 1.0 if t < 0.45 else (0.6 if t < 0.65 else 0.35)
			resultado[z * n.x + x] = valor
	return resultado


# --- Consultas ---

## Celda que hay bajo un punto (en coordenadas globales), o (-1, -1) si cae fuera.
func celda_en(posicion_global: Vector3) -> Vector2i:
	var local := _a_local(posicion_global)
	var tam_celda := Vector2(tamano.x / celdas.x, tamano.y / celdas.y)
	var x := floori((local.x + tamano.x * 0.5) / tam_celda.x)
	var z := floori((local.z + tamano.y * 0.5) / tam_celda.y)
	if x < 0 or z < 0 or x >= celdas.x or z >= celdas.y:
		return Vector2i(-1, -1)
	return Vector2i(x, z)


## True si el punto está encima de la rejilla y a menos de `margen` metros de ella.
func esta_sobre(posicion_global: Vector3, margen: float) -> bool:
	var local := _a_local(posicion_global)
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


## Pone a mano el carbón y el fuego de una celda (pruebas y depuración).
func poner_brasas(x: int, z: int, cantidad: float, fuego_celda := 1.0) -> void:
	_asegurar_datos()
	var i := z * celdas.x + x
	carbon[i] = clampf(cantidad, 0.0, 1.0)
	fuego[i] = clampf(fuego_celda, 0.0, 1.0) if carbon[i] > 0.0 else 0.0
	_calcular_brasas()


## Carbón total que queda, en celdas llenas.
func carbon_total() -> float:
	_asegurar_datos()
	var suma := 0.0
	for c in carbon:
		suma += c
	return suma


## Calor medio de toda la parrilla, de 0 a 1.
func calor_medio() -> float:
	_asegurar_datos()
	var suma := 0.0
	for b in brasas:
		suma += b
	return suma / maxi(1, brasas.size())


func _temperatura_objetivo(x: int, z: int) -> float:
	var factor_altura := clampf(altura_referencia / altura, 0.25, 1.6)
	return temperatura_ambiente + (temperatura_maxima - temperatura_ambiente) * _brasas_repartidas(x, z) * factor_altura


## Calor de la celda mezclado con el de sus cuatro vecinas.
func _brasas_repartidas(x: int, z: int) -> float:
	var suma := brasas[z * celdas.x + x] * 0.6
	var peso := 0.6
	for d: Vector2i in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
		var v := Vector2i(x, z) + d
		if v.x >= 0 and v.y >= 0 and v.x < celdas.x and v.y < celdas.y:
			suma += brasas[v.y * celdas.x + v.x] * 0.1
			peso += 0.1
	return suma / peso


# --- Barras de la rejilla: de delante a atrás, con un marco alrededor ---

func _crear_barras() -> void:
	var material := StandardMaterial3D.new()
	material.albedo_color = Color("#5A5F66")
	material.metallic = 0.6
	material.roughness = 0.5
	var barra := BoxMesh.new()
	barra.size = Vector3(0.012, 0.012, tamano.y)
	barra.material = material
	var marco := BoxMesh.new()
	marco.size = Vector3(tamano.x, 0.016, 0.016)
	marco.material = material
	var num := maxi(2, int(tamano.x / separacion_barras))
	var multi := MultiMesh.new()
	multi.transform_format = MultiMesh.TRANSFORM_3D
	multi.mesh = barra
	multi.instance_count = num
	for k in num:
		var x := -tamano.x * 0.5 + tamano.x * (k + 0.5) / num
		multi.set_instance_transform(k, Transform3D(Basis(), Vector3(x, -0.008, 0)))
	var barras := MultiMeshInstance3D.new()
	barras.name = "Barras"
	barras.multimesh = multi
	add_child(barras)
	for signo in [-1.0, 1.0]:
		var lado := MeshInstance3D.new()
		lado.name = "Marco"
		lado.mesh = marco
		lado.position = Vector3(0, -0.008, signo * tamano.y * 0.5)
		add_child(lado)


# --- Brasas visibles: trozos de carbón low-poly bajo la rejilla ---

func _crear_brasas() -> void:
	var trozo := SphereMesh.new()
	trozo.radius = 0.035
	trozo.height = 0.05
	trozo.radial_segments = 5
	trozo.rings = 2
	var material := ShaderMaterial.new()
	material.shader = preload("res://shaders/brasas.gdshader")
	trozo.material = material
	var multi := MultiMesh.new()
	multi.transform_format = MultiMesh.TRANSFORM_3D
	multi.use_colors = true
	multi.mesh = trozo
	multi.instance_count = celdas.x * celdas.y * BRASAS_POR_CELDA
	_malla_brasas = MultiMeshInstance3D.new()
	_malla_brasas.name = "Brasas"
	_malla_brasas.multimesh = multi
	_malla_brasas.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(_malla_brasas)
	_pintar_brasas()


## Cada celda muestra tantos trozos como carbón le queda; brillan según el
## fuego y se vuelven grises de ceniza cuando se acaban.
func _pintar_brasas() -> void:
	if _malla_brasas == null:
		return
	var multi := _malla_brasas.multimesh
	var tam_celda := Vector2(tamano.x / celdas.x, tamano.y / celdas.y)
	var azar := RandomNumberGenerator.new()
	var fondo := -altura - 0.03
	for celda in carbon.size():
		var x := celda % celdas.x
		var z := celda / celdas.x
		var visibles := ceili(carbon[celda] * BRASAS_POR_CELDA)
		azar.seed = celda * 7919 + 17
		for k in BRASAS_POR_CELDA:
			var i := celda * BRASAS_POR_CELDA + k
			var desplazamiento := Vector3(
				azar.randf_range(-0.45, 0.45) * tam_celda.x, azar.randf_range(0.0, 0.02),
				azar.randf_range(-0.45, 0.45) * tam_celda.y)
			var giro := Basis.from_euler(Vector3(azar.randf() * TAU, azar.randf() * TAU, azar.randf() * TAU))
			var escala := azar.randf_range(0.8, 1.3) * (0.6 + 0.4 * clampf(carbon[celda] * 2.0, 0.0, 1.0))
			if k >= visibles:
				escala = 0.0
			var centro := Vector3(-tamano.x * 0.5 + (x + 0.5) * tam_celda.x, fondo, -tamano.y * 0.5 + (z + 0.5) * tam_celda.y)
			multi.set_instance_transform(i, Transform3D(giro.scaled(Vector3.ONE * escala), centro + desplazamiento))
			# r = fuego, g = ceniza, b = fase del parpadeo.
			var ceniza := clampf(1.0 - carbon[celda] * 2.5, 0.0, 0.8)
			multi.set_instance_color(i, Color(fuego[celda], ceniza, azar.randf(), 1.0))
	if luz:
		luz.light_energy = energia_luz_maxima * calor_medio()
		luz.visible = luz.light_energy > 0.02


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


## Punto global en coordenadas de la rejilla (también fuera del árbol, en pruebas).
func _a_local(posicion_global: Vector3) -> Vector3:
	if is_inside_tree():
		return to_local(posicion_global)
	return transform.affine_inverse() * posicion_global
