extends PruebaBase
## El jugador no choca con la comida: al andar contra una hamburguesa del
## suelo no la empuja (Cogito empuja con un impulso fijo que a 150 g la
## lanzaba lejos). La comida sigue chocando con el entorno y con otra comida.


func _ejecutar() -> void:
	change_scene_to_file("res://escenas/patio_prueba.tscn")
	await process_frame
	await process_frame
	await _esperar_fisica(0.5)
	var jugador := get_first_node_in_group("Player") as CharacterBody3D
	var h := current_scene.get_node("Hamburguesa1") as RigidBody3D
	comprobar(jugador.collision_mask & h.collision_layer == 0, "el cuerpo del jugador no choca con la comida")
	comprobar(h.collision_mask & 1 != 0, "la comida choca con el entorno (parrilla, mesa, suelo)")
	comprobar(h.collision_mask & h.collision_layer != 0, "la comida choca con otra comida")

	# Andar hacia una hamburguesa en el suelo y pasar por encima.
	jugador.global_position = Vector3(-2.0, 0.9, 2.0)
	h.global_basis = Basis()
	h.global_position = Vector3(-2.0, 0.05, 1.2)
	await _esperar_fisica(1.0)
	var antes := h.global_position
	Input.action_press("forward")
	await _esperar_fisica(1.5)
	Input.action_release("forward")
	comprobar(jugador.global_position.z < 1.0, "el jugador ha andado hasta pasar la hamburguesa (z = %.2f)" % jugador.global_position.z)
	await _esperar_fisica(0.5)
	var movida := Vector2(h.global_position.x - antes.x, h.global_position.z - antes.z).length()
	comprobar(movida < 0.05, "la hamburguesa no sale empujada (se movió %.3f m)" % movida)

	# Dos hamburguesas siguen apilándose (no se atraviesan).
	var otra := current_scene.get_node("Hamburguesa2") as RigidBody3D
	otra.global_basis = Basis()
	otra.global_position = h.global_position + Vector3.UP * 0.1
	await _esperar_fisica(1.0)
	comprobar(otra.global_position.y > h.global_position.y + 0.015, "una hamburguesa queda encima de la otra")


func _esperar_fisica(segundos: float) -> void:
	for i in int(segundos * Engine.physics_ticks_per_second):
		await physics_frame
