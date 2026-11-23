class_name CoccionComponente
extends Node3D
## Componente de cocción. Va como hijo del cuerpo físico del alimento.
##
## Cada paso de física mira si el alimento está apoyado en una RejillaCalor,
## qué cara toca la rejilla y a qué temperatura, y avanza su EstadoCoccion.
## Pasa el grado de cada cara al shader de cocción y, en depuración, enseña
## un termómetro con los valores encima del alimento.

@export var tipo: TipoAlimento
## Malla con el shader shaders/coccion.gdshader.
@export var malla: GeometryInstance3D
## Distancia máxima (m) del centro del alimento a la rejilla para contar como apoyado.
@export var margen_contacto := 0.05
@export var temperatura_ambiente := 20.0
## Temperatura (°C) de rejilla a partir de la que cuenta como "parrilla encendida".
@export var temperatura_parrilla_encendida := 80.0

var estado: EstadoCoccion
var cara_apoyada := -1
var temperatura_contacto := 0.0
## True cuando ha estado apoyado en una parrilla encendida: ya suelta grasa
## y, si cae al suelo, lo mancha (SuciedadComponente).
var paso_por_parrilla := false

var _cuerpo: Node3D
var _etiqueta: Label3D


func _ready() -> void:
	_cuerpo = get_parent() as Node3D
	estado = EstadoCoccion.new(tipo)
	_crear_etiqueta()


func _physics_process(delta: float) -> void:
	var rejilla := _rejilla_debajo()
	if rejilla:
		cara_apoyada = cara_hacia_abajo()
		temperatura_contacto = rejilla.temperatura_en(_cuerpo.global_position)
		if temperatura_contacto >= temperatura_parrilla_encendida:
			paso_por_parrilla = true
	else:
		cara_apoyada = -1
		temperatura_contacto = temperatura_ambiente
	estado.avanzar(delta, cara_apoyada, temperatura_contacto, temperatura_ambiente)
	_actualizar_malla()
	if _etiqueta.visible:
		_etiqueta.text = texto_depuracion()


## Cara del alimento que mira hacia el suelo.
func cara_hacia_abajo() -> int:
	var mejor := 0
	var mejor_alineacion := -INF
	for i in EstadoCoccion.NORMALES.size():
		var normal_global := (_cuerpo.global_basis * EstadoCoccion.NORMALES[i]).normalized()
		var alineacion := normal_global.dot(Vector3.DOWN)
		if alineacion > mejor_alineacion:
			mejor_alineacion = alineacion
			mejor = i
	return mejor


## Grado de cocción que corresponde a la temperatura del interior:
## 0 a la temperatura inicial, 2 (dorado) cuando el interior está hecho.
func grado_interior() -> float:
	var t := inverse_lerp(tipo.temperatura_inicial, tipo.punto_hecho, estado.temperatura_interna)
	return clampf(t, 0.0, 1.2) * 2.0


func texto_depuracion() -> String:
	var lineas := PackedStringArray()
	lineas.append("Interior %.0f °C · %s" % [estado.temperatura_interna, estado.punto_interior()])
	lineas.append("arriba %s (%.1f) · abajo %s (%.1f)" % [
		estado.estado_cara(EstadoCoccion.Cara.ARRIBA), estado.grado[EstadoCoccion.Cara.ARRIBA],
		estado.estado_cara(EstadoCoccion.Cara.ABAJO), estado.grado[EstadoCoccion.Cara.ABAJO]])
	if cara_apoyada >= 0:
		lineas.append("rejilla %.0f °C" % temperatura_contacto)
	var suciedad := _cuerpo.get_node_or_null("Suciedad")
	if suciedad and suciedad.sucia:
		lineas.append(tr("COMIDA_sucia"))
	return "\n".join(lineas)


func _rejilla_debajo() -> RejillaCalor:
	for nodo in get_tree().get_nodes_in_group(RejillaCalor.GRUPO):
		var rejilla := nodo as RejillaCalor
		if rejilla and rejilla.esta_sobre(_cuerpo.global_position, margen_contacto):
			return rejilla
	return null


func _actualizar_malla() -> void:
	if not malla:
		return
	malla.set_instance_shader_parameter("grado_arriba", estado.grado[EstadoCoccion.Cara.ARRIBA])
	malla.set_instance_shader_parameter("grado_abajo", estado.grado[EstadoCoccion.Cara.ABAJO])
	malla.set_instance_shader_parameter("grado_lados", estado.grado_lados())
	malla.set_instance_shader_parameter("grado_interior", grado_interior())


func _crear_etiqueta() -> void:
	_etiqueta = Label3D.new()
	_etiqueta.name = "Termometro"
	_etiqueta.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	_etiqueta.no_depth_test = true
	_etiqueta.fixed_size = true
	_etiqueta.pixel_size = 0.0008
	_etiqueta.font_size = 28
	_etiqueta.outline_size = 8
	_etiqueta.top_level = true
	add_child(_etiqueta)
	var dep := get_node_or_null("/root/Depuracion")
	_etiqueta.visible = dep.activa if dep else false
	if dep:
		dep.cambiado.connect(func(activa: bool) -> void: _etiqueta.visible = activa)


func _process(_delta: float) -> void:
	# La etiqueta no gira con el alimento: siempre encima.
	if _etiqueta and _cuerpo:
		_etiqueta.global_position = _cuerpo.global_position + Vector3.UP * 0.12
