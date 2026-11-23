extends PruebaBase
## Pinzas: se cuelgan de la cámara, cogen la hamburguesa a la que se apunta,
## la llevan en la punta, le dan la vuelta y la sueltan.


func _ejecutar() -> void:
	change_scene_to_file("res://escenas/patio_prueba.tscn")
	await process_frame
	await process_frame
	await _esperar_fisica(0.5)
	# Sin tipos de clase propios: este script se compila antes que los autoloads de Cogito.
	var pinzas: Node3D = get_first_node_in_group("pinzas")
	comprobar(pinzas != null, "hay pinzas en el patio")
	if pinzas == null:
		return
	var camara := root.get_viewport().get_camera_3d()
	comprobar(pinzas.get_parent() == camara, "las pinzas van colgadas de la cámara del jugador")
	comprobar(pinzas.get_node_or_null("Modelo/Pinzas/BrazoArriba") != null, "el modelo de Blender tiene los dos brazos")

	# Poner una hamburguesa quieta delante de la cámara y apuntarle.
	var hamburguesa := current_scene.get_node("Hamburguesa2") as RigidBody3D
	hamburguesa.freeze = true
	hamburguesa.global_position = camara.global_position - camara.global_basis.z * 0.9
	await _esperar_fisica(0.1)
	comprobar(pinzas.alimento_apuntado() == hamburguesa, "la mira detecta la hamburguesa")
	comprobar(pinzas.intentar_coger(), "las pinzas cogen la hamburguesa")
	comprobar(pinzas.sostenido == hamburguesa, "la hamburguesa queda sostenida")

	await _esperar_fisica(0.5)
	var punta: Node3D = pinzas.get_node("Punta")
	var distancia := hamburguesa.global_position.distance_to(punta.global_position)
	comprobar(distancia < 0.03, "la hamburguesa sigue a la punta de las pinzas (a %.3f m)" % distancia)

	var arriba_antes := hamburguesa.global_basis.y
	pinzas.voltear_sostenido()
	comprobar(hamburguesa.global_basis.y.dot(arriba_antes) < -0.9, "las pinzas le dan la vuelta")

	var altura := hamburguesa.global_position.y
	pinzas.soltar()
	comprobar(pinzas.sostenido == null and not hamburguesa.freeze, "al soltarla vuelve a tener física")
	comprobar(hamburguesa.collision_layer != 0, "al soltarla recupera su capa de colisión")
	await _esperar_fisica(0.3)
	comprobar(hamburguesa.global_position.y < altura, "al soltarla cae")


func _esperar_fisica(segundos: float) -> void:
	for i in int(segundos * Engine.physics_ticks_per_second):
		await physics_frame
