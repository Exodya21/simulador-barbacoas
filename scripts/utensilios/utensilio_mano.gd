class_name UtensilioMano
extends Node3D
## Base de los utensilios que van en el cinturón y se sacan a la mano
## (pinzas, abanico, trapo, chimenea de encendido).
##
## Al empezar se cuelga de la cámara del jugador. Solo está `activo` (visible y
## respondiendo a los controles) cuando el autoload Cinturon lo tiene en la
## mano. Cada utensilio usa el clic izquierdo a su manera.

const GRUPO_UTENSILIOS := "utensilio_mano"

## Id del utensilio en el cinturón (Cinturon.huecos).
@export var id: StringName
## Posición y giro respecto a la cámara (abajo a la derecha).
@export var posicion_en_camara := Vector3(0.14, -0.16, -0.10)
@export var giro_en_camara := Vector3(10.0, 6.0, 0.0)

var activo := false
var _camara: Camera3D


func _ready() -> void:
	add_to_group(GRUPO_UTENSILIOS)
	_montar_en_camara.call_deferred()
	var cinturon := get_node_or_null("/root/Cinturon")
	if cinturon:
		cinturon.cambiado.connect(func(_i: int) -> void: _actualizar())
	_actualizar()


func _montar_en_camara() -> void:
	_camara = get_viewport().get_camera_3d()
	if _camara == null:
		return
	reparent(_camara, false)
	position = posicion_en_camara
	rotation_degrees = giro_en_camara


func _actualizar() -> void:
	var cinturon := get_node_or_null("/root/Cinturon")
	var ahora: bool = cinturon == null or cinturon.tiene_en_mano(id)
	visible = ahora
	if ahora != activo:
		activo = ahora
		al_cambiar_mano(activo)


## Se llama al sacarlo a la mano (true) o al guardarlo en el cinturón (false).
func al_cambiar_mano(_en_mano: bool) -> void:
	pass


func _camara_actual() -> Camera3D:
	return _camara if _camara else get_viewport().get_camera_3d()


## Choque del rayo que sale del centro de la pantalla, hasta `alcance` metros.
func rayo_mira(alcance: float, mascara: int, excluir: Array[RID] = []) -> Dictionary:
	var camara := _camara_actual()
	if camara == null:
		return {}
	var origen := camara.global_position
	var consulta := PhysicsRayQueryParameters3D.create(origen, origen - camara.global_basis.z * alcance, mascara)
	consulta.exclude = excluir
	return get_world_3d().direct_space_state.intersect_ray(consulta)


## Rejilla de calor sobre la que cae un punto (a menos de `margen` m), o null.
func rejilla_en(punto: Vector3, margen := 0.15) -> RejillaCalor:
	for nodo in get_tree().get_nodes_in_group(RejillaCalor.GRUPO):
		var rejilla := nodo as RejillaCalor
		if rejilla and rejilla.esta_sobre(punto, margen):
			return rejilla
	return null


## True si el jugador lleva algo cogido con E (Cogito usa el clic para lanzarlo).
func jugador_lleva_algo() -> bool:
	if _camara == null:
		return false
	for nodo in get_tree().get_nodes_in_group("Player"):
		var componente := nodo.find_child("PlayerInteractionComponent", true, false)
		if componente and componente.get("is_carrying"):
			return true
	return false


## Aviso abajo a la izquierda, como los de Cogito.
func avisar(clave: String) -> void:
	var jugador := get_tree().get_first_node_in_group("Player")
	var pic = jugador.get("player_interaction_component") if jugador else null
	if pic and pic.has_method("send_hint"):
		pic.send_hint(null, tr(clave))
