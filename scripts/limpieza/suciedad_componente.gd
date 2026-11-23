class_name SuciedadComponente
extends Node
## Ensucia la comida cuando cae al suelo y deja una mancha de grasa donde cae.
## Va como hijo del RigidBody3D del alimento (que necesita contact_monitor).
##
## La comida sucia no se limpia: hay que tirarla a la basura.
## El suelo es cualquier cuerpo del grupo "suelo".

const GRUPO_SUELO := "suelo"
const MANCHA := preload("res://escenas/limpieza/mancha_grasa.tscn")
## No se crea otra mancha a menos de esta distancia (m) de la última.
const DISTANCIA_ENTRE_MANCHAS := 0.35

signal ensuciada

@export var malla: GeometryInstance3D

var sucia := false
var _ultima_mancha := Vector3.INF
var _cuerpo: RigidBody3D


func _ready() -> void:
	_cuerpo = get_parent() as RigidBody3D
	_cuerpo.contact_monitor = true
	_cuerpo.max_contacts_reported = maxi(_cuerpo.max_contacts_reported, 4)
	_cuerpo.body_entered.connect(_al_tocar)


func _al_tocar(otro: Node) -> void:
	if otro.is_in_group(GRUPO_SUELO):
		ensuciar()


func ensuciar() -> void:
	if not sucia:
		sucia = true
		if malla:
			malla.set_instance_shader_parameter("suciedad", 1.0)
		ensuciada.emit()
	_dejar_mancha()


func _dejar_mancha() -> void:
	var punto := _cuerpo.global_position
	var espacio := _cuerpo.get_world_3d().direct_space_state
	var consulta := PhysicsRayQueryParameters3D.create(punto + Vector3.UP * 0.2, punto + Vector3.DOWN * 1.0)
	consulta.exclude = [_cuerpo.get_rid()]
	var golpe := espacio.intersect_ray(consulta)
	if golpe.is_empty():
		return
	var suelo: Vector3 = golpe.position
	if suelo.distance_to(_ultima_mancha) < DISTANCIA_ENTRE_MANCHAS:
		return
	_ultima_mancha = suelo
	var mancha := MANCHA.instantiate() as Node3D
	_cuerpo.get_tree().current_scene.add_child(mancha)
	mancha.global_position = suelo
