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

	# Por defecto se limpia con el trapo viejo: lento (4 s).
	comprobar(mancha.has_node("Limpiar"), "la mancha tiene la interacción de limpiar")
	var limpiar: Node = mancha.get_node("Limpiar")
	comprobar(mancha.utensilio != null and mancha.utensilio.nombre == "UTENSILIO_trapo", "el utensilio por defecto es el trapo")
	comprobar(is_equal_approx(limpiar.hold_time, 4.0), "con el trapo hay que mantener 4 s (%.1f)" % limpiar.hold_time)
	comprobar(limpiar.interaction_text == "INTERACT_limpiar_trapo", "el aviso dice que se limpia con el trapo")

	# Mientras se mantiene, el trapo frota y la mancha se desvanece.
	var trapo: Node3D = mancha.get_node("Utensilio")
	comprobar(not trapo.visible, "sin limpiar, el trapo no se ve")
	var posiciones: Array[Vector3] = []
	for i in 30:
		limpiar.is_being_held.emit(4.0 - i * 0.05, 1.0 / 60.0)
		posiciones.append(trapo.position)
		await process_frame
	comprobar(trapo.visible, "al mantener, el trapo aparece frotando")
	comprobar(posiciones[0].distance_to(posiciones[15]) > 0.03, "el trapo se mueve en círculos")
	comprobar(mancha.get_node("Malla").material_override.albedo_color.a < 0.9, "la mancha se va desvaneciendo")
	await _esperar_fisica(0.3)
	comprobar(not trapo.visible and is_equal_approx(mancha.get_node("Malla").material_override.albedo_color.a, 1.0), "si se suelta antes de tiempo, la mancha vuelve entera")

	# Ruta de mejora: un utensilio mejor (p. ej. un mocho) limpia más rápido.
	var mocho := UtensilioLimpieza.new()
	mocho.nombre = "UTENSILIO_prueba"
	mocho.segundos_por_mancha = 1.0
	var equipo := root.get_node("Equipo")
	equipo.poner_limpieza(mocho)
	comprobar(is_equal_approx(limpiar.hold_time, 1.0), "al cambiar de utensilio cambia el tiempo de limpieza")
	equipo.poner_limpieza(equipo.TRAPO)

	# Al terminar, la mancha desaparece (lo que hace la HoldInteraction al acabar).
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
