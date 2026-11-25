class_name Abanico
extends CogitoObject
## Abanico para avivar las brasas. Va en el nodo raíz (RigidBody3D) de
## escenas/fuego/abanico.tscn.
##
## Se coge con E. Llevándolo en la mano, **mantener F** abanica: si está sobre
## la parrilla, las brasas de debajo suben de fuego (y gastan carbón antes).

signal abanicando(rejilla: RejillaCalor)

## Abanicadas por segundo (vaivén del modelo).
@export var vaivenes_por_segundo := 3.0
## Radio (m) de brasas que aviva.
@export var radio := 0.3
## Altura máxima (m) sobre la rejilla a la que todavía aviva.
@export var altura_maxima := 1.2

var abanicando_ahora := false
var _fase := 0.0

@onready var _modelo: Node3D = $Modelo
@onready var _llevar: Node = $CarryableComponent


func _ready() -> void:
	super()
	_llevar.carry_state_changed.connect(_al_coger)


func _physics_process(delta: float) -> void:
	abanicando_ahora = _llevar.is_being_carried and Input.is_action_pressed("interact")
	if abanicando_ahora:
		abanicar(delta)
	else:
		_modelo.rotation.x = lerpf(_modelo.rotation.x, 0.0, minf(1.0, delta * 10.0))


## Un paso de abanicar: mueve el modelo y aviva la rejilla de debajo si la hay.
func abanicar(delta: float) -> RejillaCalor:
	_fase += delta * TAU * vaivenes_por_segundo
	_modelo.rotation.x = sin(_fase) * 0.6
	var rejilla := rejilla_debajo()
	if rejilla:
		rejilla.avivar(global_position, delta, radio)
		abanicando.emit(rejilla)
	return rejilla


func rejilla_debajo() -> RejillaCalor:
	for nodo in get_tree().get_nodes_in_group(RejillaCalor.GRUPO):
		var rejilla := nodo as RejillaCalor
		if rejilla == null or rejilla.celda_en(global_position).x < 0:
			continue
		var altura := rejilla.to_local(global_position).y
		if altura > -0.05 and altura < altura_maxima:
			return rejilla
	return null


func _al_coger(cogido: bool) -> void:
	var pic = _llevar.player_interaction_component
	if cogido and pic and pic.has_method("send_hint"):
		pic.send_hint(null, tr("ABANICO_ayuda"))
