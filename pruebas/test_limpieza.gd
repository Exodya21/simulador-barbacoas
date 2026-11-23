extends PruebaBase
## La comida que cae al suelo se ensucia y deja una mancha de grasa
## resbaladiza que no se va hasta limpiarla; la comida sucia se tira a la basura.


func _ejecutar() -> void:
	change_scene_to_file("res://escenas/patio_prueba.tscn")
	await process_frame
	await process_frame
	await _esperar_fisica(0.5)
	comprobar(get_nodes_in_group("mancha_grasa").is_empty(), "al empezar no hay manchas")

	# En la parrilla y en la mesa no se ensucia.
	var mesa := current_scene.get_node("Hamburguesa3") as RigidBody3D
	comprobar(not mesa.get_node("Suciedad").sucia, "en la mesa la comida está limpia")

	# Cae al suelo: se ensucia y deja una mancha.
	var h := current_scene.get_node("Hamburguesa1") as RigidBody3D
	h.global_position = Vector3(-2.0, 0.6, 1.0)
	await _esperar_fisica(1.5)
	comprobar(h.get_node("Suciedad").sucia, "al caer al suelo la comida se ensucia")
	var manchas := get_nodes_in_group("mancha_grasa")
	comprobar(manchas.size() == 1, "deja una mancha de grasa (%d)" % manchas.size())
	if manchas.is_empty():
		return
	var mancha := manchas[0] as Node3D
	comprobar(mancha.global_position.distance_to(Vector3(-2.0, 0.0, 1.0)) < 0.3, "la mancha queda donde cayó, en el suelo")

	# La mancha no se va sola.
	await _esperar_fisica(2.0)
	comprobar(is_instance_valid(mancha), "la mancha sigue ahí con el tiempo")

	# Resbala: el jugador pierde agarre al pisarla y lo recupera al salir.
	var jugador := get_first_node_in_group("Player")
	var agarre: float = jugador.LERP_SPEED
	jugador.global_position = mancha.global_position + Vector3.UP * 0.1
	await _esperar_fisica(0.3)
	comprobar(jugador.LERP_SPEED < agarre * 0.5, "sobre la mancha el jugador resbala (agarre %.1f → %.1f)" % [agarre, jugador.LERP_SPEED])
	jugador.global_position = mancha.global_position + Vector3(2.5, 0.1, 0)
	await _esperar_fisica(0.3)
	comprobar(is_equal_approx(jugador.LERP_SPEED, agarre), "fuera de la mancha recupera el agarre")

	# Se limpia (lo que hace la interacción de mantener pulsado al terminar).
	comprobar(mancha.has_node("Limpiar"), "la mancha tiene la interacción de limpiar")
	jugador.global_position = mancha.global_position + Vector3.UP * 0.1
	await _esperar_fisica(0.3)
	mancha.interact(null)
	await process_frame
	comprobar(not is_instance_valid(mancha), "al limpiarla desaparece")
	comprobar(is_equal_approx(jugador.LERP_SPEED, agarre), "al limpiarla bajo los pies, el jugador deja de resbalar")
	jugador.global_position = Vector3(0, 0.9, 2)

	# La comida sucia se tira a la basura.
	var basura := current_scene.get_node("Basura") as Node3D
	h.global_position = basura.global_position + Vector3(0, 1.1, 0)
	h.linear_velocity = Vector3.ZERO
	await _esperar_fisica(1.0)
	comprobar(not is_instance_valid(h), "la comida sucia tirada a la basura desaparece")


func _esperar_fisica(segundos: float) -> void:
	for i in int(segundos * Engine.physics_ticks_per_second):
		await physics_frame
