extends PruebaBase
## Hamburguesas apiladas: al coger con las pinzas la de abajo, no atraviesa
## a la de arriba (la levanta o la tira, pero nunca pasa a través de ella).


func _ejecutar() -> void:
	change_scene_to_file("res://escenas/patio_prueba.tscn")
	await process_frame
	await process_frame
	await _esperar_fisica(0.5)
	var pinzas: Node3D = get_first_node_in_group("pinzas")
	var camara := root.get_viewport().get_camera_3d()
	var rejilla: Node3D = current_scene.get_node("Parrilla/RejillaCalor")
	rejilla.encender_dos_zonas()  # el patio empieza frío
	var abajo := current_scene.get_node("Hamburguesa1") as RigidBody3D
	var arriba := current_scene.get_node("Hamburguesa2") as RigidBody3D

	# Pila en la zona indirecta: una encima de otra.
	abajo.global_basis = Basis()
	arriba.global_basis = Basis()
	abajo.global_position = rejilla.to_global(Vector3(0.5, 0.02, 0.0))
	arriba.global_position = abajo.global_position + Vector3.UP * 0.06
	await _esperar_fisica(1.0)
	comprobar(arriba.global_position.y > abajo.global_position.y + 0.015, "al empezar, una está encima de la otra")

	# Mirar a la de abajo de lado (al canto) y cogerla.
	var jugador := get_first_node_in_group("Player") as Node3D
	jugador.global_position = rejilla.global_position + Vector3(0.5, -0.15, 0.9)
	await _esperar_fisica(0.2)
	camara.look_at(abajo.global_position)
	await _esperar_fisica(0.05)
	pinzas.coger(abajo)
	Input.action_press("action_primary")

	# Seguir mirando a la pila un momento (el caso que reportó el usuario):
	# la de abajo no puede subir a través de la de arriba.
	var atravesada := false
	for i in 60:
		await physics_frame
		var sep := Vector2(arriba.global_position.x - abajo.global_position.x, arriba.global_position.z - abajo.global_position.z).length()
		if sep < 0.09 and arriba.global_position.y < abajo.global_position.y + 0.012:
			atravesada = true
	comprobar(not atravesada, "mirando a la pila, la de abajo no atraviesa a la de arriba")

	# Llevarla a otro sitio de la parrilla, vigilando que no la atraviese.
	var destino := rejilla.to_global(Vector3(-0.3, 0, 0.2))
	camara.look_at(destino)
	atravesada = false
	for i in 90:
		await physics_frame
		var separacion := Vector2(arriba.global_position.x - abajo.global_position.x, arriba.global_position.z - abajo.global_position.z).length()
		if separacion < 0.09 and arriba.global_position.y < abajo.global_position.y + 0.012:
			atravesada = true
	comprobar(not atravesada, "la de abajo no atraviesa a la de arriba al llevarla")
	Input.action_release("action_primary")
	await _esperar_fisica(1.0)
	var separacion := Vector2(arriba.global_position.x - abajo.global_position.x, arriba.global_position.z - abajo.global_position.z).length()
	comprobar(separacion > 0.09 or arriba.global_position.y > abajo.global_position.y + 0.015, "al final no quedan una dentro de otra")
	comprobar(arriba.global_position.y > rejilla.global_position.y - 0.05, "la de arriba no se ha hundido en la parrilla")


func _esperar_fisica(segundos: float) -> void:
	for i in int(segundos * Engine.physics_ticks_per_second):
		await physics_frame
