extends CogitoObject
## Cuerpo físico de un utensilio del cinturón tirado en el mundo. Lo crea
## UtensilioMano al soltarlo (G); con F encima se recoge al cinturón.
## Va en un RigidBody3D (CogitoObject solo pide un Node3D).

const GRUPO := "utensilio_suelto"

## El utensilio que lleva dentro.
var utensilio: Node3D


func _ready() -> void:
	super()
	add_to_group(GRUPO)


## Llamado por la BasicInteraction (F).
func interact(_player_interaction_component = null) -> void:
	if utensilio and is_instance_valid(utensilio):
		utensilio.recoger()
