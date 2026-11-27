extends PruebaBase
## Cinturón: cuatro huecos con pinzas, abanico, trapo y chimenea; solo el de la
## mano funciona; las manchas solo se limpian con el trapo en la mano; el texto
## de la comida solo sale al mirarla y sin números.


func _ejecutar() -> void:
	change_scene_to_file("res://escenas/patio_prueba.tscn")
	await process_frame
	await process_frame
	# Sin tipos propios: Cogito aún no ha cargado sus autoloads al compilar esto.
	var cinturon: Node = root.get_node("Cinturon")
	cinturon.reiniciar()
	await process_frame
	comprobar(cinturon.huecos == [&"pinzas", &"abanico", &"trapo", &"chimenea"], "el cinturón empieza con pinzas, abanico, trapo y chimenea")
	comprobar(cinturon.en_mano() == &"pinzas", "se empieza con las pinzas en la mano")
	var utensilios := {}
	for u in get_nodes_in_group("utensilio_mano"):
		utensilios[u.id] = u
	comprobar(utensilios.size() == 4, "hay cuatro utensilios en el patio (%d)" % utensilios.size())
	var camara := root.get_viewport().get_camera_3d()
	for id in utensilios:
		comprobar(utensilios[id].get_parent() == camara, "%s va colgado de la cámara" % id)
	_solo_uno_activo(utensilios, &"pinzas")

	cinturon.seleccionar(1)
	_solo_uno_activo(utensilios, &"abanico")
	cinturon.seleccionar(1)
	comprobar(cinturon.en_mano() == &"", "pulsar otra vez la tecla del que llevas lo guarda")
	_solo_uno_activo(utensilios, &"")
	cinturon.pasar(1)
	comprobar(cinturon.en_mano() == &"pinzas", "con las manos libres la rueda saca el primero")
	cinturon.pasar(-1)
	comprobar(cinturon.en_mano() == &"chimenea", "la rueda hacia atrás da la vuelta al último")

	# Guardar las pinzas suelta lo que llevan.
	cinturon.sacar(&"pinzas")
	var pinzas: Node = utensilios[&"pinzas"]
	var h := current_scene.get_node("Hamburguesa1") as RigidBody3D
	pinzas.coger(h)
	cinturon.sacar(&"trapo")
	comprobar(pinzas.sostenido == null and not h.freeze, "al guardar las pinzas sueltan la comida")

	# Manchas: solo con el trapo en la mano.
	var mancha: Node = load("res://escenas/limpieza/mancha_grasa.tscn").instantiate()
	current_scene.add_child(mancha)
	mancha.global_position = Vector3(-2, 0, 1)
	var limpiar: Node = mancha.get_node("Limpiar")
	comprobar(not limpiar.is_disabled, "con el trapo en la mano se puede limpiar")
	cinturon.sacar(&"pinzas")
	comprobar(limpiar.is_disabled and mancha.display_name == "MANCHA_grasa_sin_trapo", "sin el trapo en la mano no se puede limpiar y la mancha lo dice")
	mancha.queue_free()

	# Texto de la comida: solo al mirarla, con el término y sin números.
	var coccion: Node = h.get_node("Coccion")
	var etiqueta: Label3D = coccion.get_node("Termometro")
	await _frames_fisica(3)
	comprobar(not etiqueta.visible, "sin mirar la comida no se ve su texto")
	Input.action_press("action_primary")  # las pinzas sueltan al soltar el clic
	pinzas.coger(h)
	await _frames_fisica(3)
	comprobar(etiqueta.visible, "llevándola con las pinzas se ve su texto")
	var depuracion: Node = root.get_node("Depuracion")
	if depuracion.activa:
		depuracion.alternar()
	await _frames_fisica(3)
	var texto := etiqueta.text
	comprobar(not texto.contains("°") and not texto.contains("(") and not texto.contains("Interior"), "sin depuración no hay temperaturas ni números: «%s»" % texto.replace("\n", " / "))
	comprobar(texto.begins_with("Crudo"), "enseña el término: «%s»" % texto.get_slice("\n", 0))
	pinzas.soltar()
	Input.action_release("action_primary")


func _solo_uno_activo(utensilios: Dictionary, id: StringName) -> void:
	for otro in utensilios:
		var u: Node3D = utensilios[otro]
		var debe: bool = otro == id
		comprobar(u.activo == debe and u.visible == debe, "%s %s" % [otro, "en la mano" if debe else "guardado"])


func _frames_fisica(n: int) -> void:
	for i in n:
		await physics_frame
