class_name Voltear
extends RefCounted
## Dar la vuelta a una pieza: la levanta un poco y la gira 180° sobre un eje
## horizontal. Lo usan la tecla F (VoltearInteraccion) y las pinzas.


static func voltear(cuerpo: RigidBody3D, eje: Vector3, elevacion := 0.03) -> void:
	cuerpo.linear_velocity = Vector3.ZERO
	cuerpo.angular_velocity = Vector3.ZERO
	cuerpo.global_position += Vector3.UP * elevacion
	cuerpo.global_rotate(eje.normalized(), PI)


## Eje horizontal a la derecha de un nodo (la cámara o el jugador).
static func eje_horizontal(nodo: Node3D) -> Vector3:
	if nodo:
		var derecha := nodo.global_basis.x
		derecha.y = 0.0
		if derecha.length() > 0.01:
			return derecha.normalized()
	return Vector3.RIGHT
