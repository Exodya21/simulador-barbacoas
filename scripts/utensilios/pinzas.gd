class_name Pinzas
extends Node3D
## Pinzas de barbacoa en la mano del jugador.
##
## - Clic izquierdo (action_primary): coger el alimento al que apuntas, o
##   soltar el que tienes cogido.
## - Clic derecho (action_secondary): dar la vuelta al alimento cogido, o al
##   que apuntas si no tienes ninguno.
## Al empezar se cuelgan de la cámara del jugador. No hacen nada mientras el
## jugador lleva algo en la mano con E (Cogito usa el clic para lanzarlo).

signal cogido(cuerpo: RigidBody3D)
signal soltado(cuerpo: RigidBody3D)

const GRUPO := "pinzas"
## Capa de física de los objetos con los que se interactúa (Cogito: capa 2).
const CAPA_INTERACTUABLES := 1 << 1

## Distancia máxima (m) desde la cámara para coger o voltear.
@export var alcance := 1.8
## Posición de las pinzas respecto a la cámara (abajo a la derecha).
@export var posicion_en_camara := Vector3(0.14, -0.16, -0.10)
@export var giro_en_camara := Vector3(10.0, 6.0, 0.0)
## Rapidez con la que la pieza cogida sigue a la punta (1/s).
@export var seguimiento := 25.0
## Ángulo (grados) de cada brazo abierto y cerrado.
@export var apertura_abierta := 7.0
@export var apertura_cerrada := 0.7

var sostenido: RigidBody3D
var _capa_original := 0
var _camara: Camera3D

@onready var _punta: Marker3D = $Punta
@onready var _brazo_arriba: Node3D = $Modelo/Pinzas/BrazoArriba
@onready var _brazo_abajo: Node3D = $Modelo/Pinzas/BrazoAbajo


func _ready() -> void:
	add_to_group(GRUPO)
	_poner_apertura(apertura_abierta)
	_montar_en_camara.call_deferred()


func _montar_en_camara() -> void:
	_camara = get_viewport().get_camera_3d()
	if _camara == null:
		return
	reparent(_camara, false)
	position = posicion_en_camara
	rotation_degrees = giro_en_camara


func _physics_process(delta: float) -> void:
	if not _jugador_lleva_algo():
		if Input.is_action_just_pressed("action_primary"):
			if sostenido:
				soltar()
			else:
				intentar_coger()
		if Input.is_action_just_pressed("action_secondary"):
			if sostenido:
				voltear_sostenido()
			else:
				var objetivo := alimento_apuntado()
				if objetivo:
					Voltear.voltear(objetivo, Voltear.eje_horizontal(_camara))
	if sostenido:
		if not is_instance_valid(sostenido):
			sostenido = null
			_poner_apertura(apertura_abierta)
			return
		var mezcla := 1.0 - exp(-seguimiento * delta)
		sostenido.global_position = sostenido.global_position.lerp(_punta.global_position, mezcla)


## Alimento (cuerpo con cocción) bajo la mira, o null.
func alimento_apuntado() -> RigidBody3D:
	var camara := _camara if _camara else get_viewport().get_camera_3d()
	if camara == null:
		return null
	var origen := camara.global_position
	var consulta := PhysicsRayQueryParameters3D.create(origen, origen - camara.global_basis.z * alcance, CAPA_INTERACTUABLES)
	var golpe := get_world_3d().direct_space_state.intersect_ray(consulta)
	var cuerpo := golpe.get("collider") as RigidBody3D
	if cuerpo and cuerpo.has_node("Coccion"):
		return cuerpo
	return null


func intentar_coger() -> bool:
	var objetivo := alimento_apuntado()
	if objetivo == null:
		return false
	coger(objetivo)
	return true


func coger(cuerpo: RigidBody3D) -> void:
	if sostenido:
		soltar()
	sostenido = cuerpo
	_capa_original = cuerpo.collision_layer
	cuerpo.collision_layer = 0  # que no empuje al jugador mientras la llevamos
	cuerpo.freeze_mode = RigidBody3D.FREEZE_MODE_KINEMATIC
	cuerpo.freeze = true
	_poner_apertura(apertura_cerrada)
	cogido.emit(cuerpo)


func soltar() -> void:
	if sostenido == null:
		return
	var cuerpo := sostenido
	sostenido = null
	if is_instance_valid(cuerpo):
		cuerpo.collision_layer = _capa_original
		cuerpo.freeze = false
		cuerpo.linear_velocity = Vector3.ZERO
		cuerpo.angular_velocity = Vector3.ZERO
	_poner_apertura(apertura_abierta)
	soltado.emit(cuerpo)


func voltear_sostenido() -> void:
	if sostenido:
		sostenido.global_rotate(Voltear.eje_horizontal(_camara), PI)


func _poner_apertura(grados: float) -> void:
	if _brazo_arriba == null or _brazo_abajo == null:
		return
	var radianes := deg_to_rad(grados)
	var tween := create_tween().set_parallel()
	tween.tween_property(_brazo_arriba, "rotation:x", radianes, 0.08)
	tween.tween_property(_brazo_abajo, "rotation:x", -radianes, 0.08)


func _jugador_lleva_algo() -> bool:
	if _camara == null:
		return false
	for nodo in get_tree().get_nodes_in_group("Player"):
		var componente := nodo.find_child("PlayerInteractionComponent", true, false)
		if componente and componente.get("is_carrying"):
			return true
	return false
