class_name VoltearInteraccion
extends InteractionComponent
## Interacción de Cogito para dar la vuelta a un alimento (tecla F por defecto).
## Levanta un poco la pieza y la gira 180° sobre el eje horizontal que el
## jugador tiene a su derecha, como al voltearla con las pinzas.

## Altura (m) a la que se levanta la pieza antes de girarla.
@export var elevacion := 0.03


func interact(player_interaction_component: PlayerInteractionComponent) -> void:
	var cuerpo := get_parent() as RigidBody3D
	if cuerpo == null:
		return
	voltear(cuerpo, _eje_del_jugador(player_interaction_component))
	was_interacted_with.emit(interaction_text, input_map_action)


func voltear(cuerpo: RigidBody3D, eje: Vector3) -> void:
	cuerpo.linear_velocity = Vector3.ZERO
	cuerpo.angular_velocity = Vector3.ZERO
	cuerpo.global_position += Vector3.UP * elevacion
	cuerpo.global_rotate(eje.normalized(), PI)


func _eje_del_jugador(pic: Node3D) -> Vector3:
	if pic:
		var derecha := pic.global_basis.x
		derecha.y = 0.0
		if derecha.length() > 0.01:
			return derecha.normalized()
	return Vector3.RIGHT
