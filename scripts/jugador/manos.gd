class_name Manos
extends Node3D
## Manos del jugador, low-poly, colgadas de la cámara.
##
## - **Derecha**: agarra el utensilio que va en la mano (UtensilioMano
##   .transform_mano()). Sin utensilio, descansa abajo a la derecha.
## - **Izquierda**: descansa abajo a la izquierda. Su marcador `Sujecion` es
##   donde irá el vaso de fernet (el eje Y del marcador es el «arriba» del vaso).
##
## Las mallas se construyen por código (puño cerrado alrededor del eje Y,
## antebrazo hacia +Z y manga). Va en escenas/jugador/manos.tscn.

const COLOR_PIEL := Color(0.79, 0.6, 0.45)
const COLOR_MANGA := Color(0.33, 0.37, 0.42)

## Posición de reposo de cada mano respecto a la cámara.
@export var reposo_derecha := Vector3(0.3, -0.31, -0.48)
@export var reposo_izquierda := Vector3(-0.3, -0.31, -0.48)
## Tamaño de las manos.
@export var escala := 0.82
## Rapidez con la que la mano derecha va a su sitio (1/s).
@export var rapidez := 22.0

var derecha: Node3D
var izquierda: Node3D
var sujecion: Marker3D
var _camara: Camera3D
var _material_piel: StandardMaterial3D
var _material_manga: StandardMaterial3D


func _ready() -> void:
	_material_piel = _material(COLOR_PIEL)
	_material_manga = _material(COLOR_MANGA)
	derecha = _construir_mano("ManoDerecha", 1.0)
	izquierda = _construir_mano("ManoIzquierda", -1.0)
	sujecion = Marker3D.new()
	sujecion.name = "Sujecion"
	sujecion.position = Vector3(-0.005, 0.0, -0.005)
	izquierda.add_child(sujecion)
	derecha.transform = _reposo(reposo_derecha, 1.0)
	izquierda.transform = _reposo(reposo_izquierda, -1.0)
	_montar_en_camara.call_deferred()


func _montar_en_camara() -> void:
	_camara = get_viewport().get_camera_3d()
	if _camara == null:
		return
	reparent(_camara, false)
	transform = Transform3D.IDENTITY


func _process(delta: float) -> void:
	if derecha == null:
		return
	var objetivo := objetivo_derecha()
	var paso := minf(1.0, delta * rapidez)
	derecha.transform = derecha.transform.interpolate_with(objetivo, paso)


## Dónde debe ir la mano derecha ahora (coordenadas de la cámara).
func objetivo_derecha() -> Transform3D:
	var u := utensilio_en_mano()
	if u and u.get_parent() == get_parent():
		return u.transform_mano()
	return _reposo(reposo_derecha, 1.0)


## El utensilio que lleva la mano derecha, o null.
func utensilio_en_mano() -> UtensilioMano:
	for nodo in get_tree().get_nodes_in_group(UtensilioMano.GRUPO_UTENSILIOS):
		var u := nodo as UtensilioMano
		if u and u.activo and not u.suelto:
			return u
	return null


func _reposo(donde: Vector3, lado: float) -> Transform3D:
	var y := Vector3(-0.25 * lado, 1.0, -0.35).normalized()
	var brazo := Vector3(0.4 * lado, -0.55, 1.0)
	var z := (brazo - y * brazo.dot(y)).normalized()
	return Transform3D(Basis(y.cross(z), y, z), donde)


## Puño cerrado alrededor del eje Y local; el antebrazo sale hacia +Z. `lado`
## es 1 para la derecha y −1 para la izquierda (espejo en X).
func _construir_mano(nombre: String, lado: float) -> Node3D:
	var raiz := Node3D.new()
	raiz.name = nombre
	add_child(raiz)
	var mano := Node3D.new()
	mano.name = "Modelo"
	mano.scale = Vector3.ONE * escala
	raiz.add_child(mano)
	var s := lado
	# Palma (dorso hacia +X en la derecha) y nudillos.
	_caja(mano, "Palma", Vector3(0.03 * s, 0.0, 0.018), Vector3(0.026, 0.086, 0.085))
	# Cuatro dedos que rodean el mango por delante y por el otro lado.
	for i in 4:
		var y := 0.0315 - i * 0.021
		var largo := 0.019 if i < 3 else 0.016
		_caja(mano, "Dedo%dA" % i, Vector3(0.008 * s, y, -0.024), Vector3(0.05, largo, 0.022))
		_caja(mano, "Dedo%dB" % i, Vector3(-0.022 * s, y, -0.004), Vector3(0.02, largo, 0.034))
	# Pulgar por encima del índice, hacia el otro lado.
	_caja(mano, "Pulgar", Vector3(0.004 * s, 0.047, 0.004), Vector3(0.044, 0.018, 0.022))
	# Antebrazo y manga.
	_cilindro(mano, "Antebrazo", Vector3(0.03 * s, -0.004, 0.15), 0.027, 0.2, _material_piel)
	_cilindro(mano, "Manga", Vector3(0.03 * s, -0.004, 0.42), 0.04, 0.38, _material_manga)
	return raiz


func _caja(padre: Node3D, nombre: String, donde: Vector3, tam: Vector3) -> void:
	var malla := BoxMesh.new()
	malla.size = tam
	malla.material = _material_piel
	var mi := MeshInstance3D.new()
	mi.name = nombre
	mi.mesh = malla
	mi.position = donde
	mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	padre.add_child(mi)


func _cilindro(padre: Node3D, nombre: String, donde: Vector3, radio: float, largo: float, material: Material) -> void:
	var malla := CylinderMesh.new()
	malla.top_radius = radio
	malla.bottom_radius = radio
	malla.height = largo
	malla.radial_segments = 7
	malla.rings = 1
	malla.material = material
	var mi := MeshInstance3D.new()
	mi.name = nombre
	mi.mesh = malla
	mi.position = donde
	mi.rotation.x = PI * 0.5
	mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	padre.add_child(mi)


func _material(color: Color) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = color
	m.roughness = 0.85
	return m
