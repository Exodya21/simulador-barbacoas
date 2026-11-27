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
	comprobar(utensilios.size() == 6, "hay seis utensilios en el patio (%d)" % utensilios.size())
	var camara := root.get_viewport().get_camera_3d()
	for id in cinturon.huecos:
		comprobar(utensilios[id].get_parent() == camara, "%s va colgado de la cámara" % id)
	for id in [&"pala", &"magiclick"]:
		comprobar(utensilios[id].suelto and utensilios[id].visible, "%s empieza suelto en la mesa" % id)
	var depuracion: Node = root.get_node("Depuracion")
	comprobar(not depuracion.activa, "los números de depuración empiezan escondidos (F3)")
	cinturon.seleccionar(1)
	cinturon._unhandled_input(_rueda(MOUSE_BUTTON_WHEEL_DOWN))
	comprobar(cinturon.seleccionado == 2, "rueda abajo pasa al siguiente")
	cinturon._unhandled_input(_rueda(MOUSE_BUTTON_WHEEL_UP))
	cinturon._unhandled_input(_rueda(MOUSE_BUTTON_WHEEL_UP))
	comprobar(cinturon.seleccionado == 0, "rueda arriba vuelve al anterior")
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

	# Manos: la derecha agarra el utensilio de la mano; la izquierda, libre.
	var manos: Node3D = current_scene.find_child("Manos", true, false)
	comprobar(manos != null and manos.get_parent() == camara, "las manos van colgadas de la cámara")
	comprobar(manos.sujecion != null, "la mano izquierda tiene sitio para el vaso")
	cinturon.sacar(&"abanico")
	for i in 30:
		await process_frame
	var objetivo: Transform3D = utensilios[&"abanico"].transform_mano()
	comprobar(manos.derecha.transform.origin.distance_to(objetivo.origin) < 0.01, "la mano derecha agarra el abanico")
	cinturon.seleccionar(cinturon.seleccionado)
	for i in 30:
		await process_frame
	comprobar(manos.derecha.transform.origin.distance_to(manos.reposo_derecha) < 0.01, "sin utensilio la mano derecha descansa")

	# Soltar, recoger y colocar a gusto.
	cinturon.sacar(&"trapo")
	var trapo: Node3D = utensilios[&"trapo"]
	comprobar(trapo.soltar_al_suelo(), "G suelta el trapo")
	comprobar(cinturon.huecos[2] == &"" and cinturon.en_mano() == &"", "su hueco queda libre y la mano vacía")
	comprobar(trapo.suelto and trapo.visible and not trapo.activo and trapo.cuerpo_suelto != null, "el trapo queda en el mundo como objeto")
	await _frames_fisica(30)
	comprobar(trapo.cuerpo_suelto.global_position.y < camara.global_position.y - 0.5, "y cae")
	cinturon.seleccionar(0)
	comprobar(utensilios[&"pala"].recoger(), "la pala se recoge")
	comprobar(cinturon.huecos[2] == &"pala", "y va al primer hueco libre si el elegido está ocupado")
	comprobar(not trapo.recoger(), "con el cinturón lleno el trapo no cabe")
	cinturon.mover(2, 0)
	comprobar(cinturon.huecos[0] == &"pala" and cinturon.huecos[2] == &"pinzas" and cinturon.en_mano() == &"pala", "Mayús + número mueve el de la mano a otro hueco")
	utensilios[&"pala"].soltar_al_suelo()
	cinturon.seleccionar(0)
	comprobar(cinturon.en_mano() == &"", "se puede elegir un hueco vacío")
	comprobar(trapo.recoger() and cinturon.huecos[0] == &"trapo", "al recoger va al hueco vacío elegido")
	comprobar(trapo.get_parent() == camara and trapo.activo, "y vuelve a la mano")
	cinturon.reiniciar()
	utensilios[&"pala"].cuerpo_suelto.queue_free()
	await process_frame

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
	if depuracion.activa:
		depuracion.alternar()
	await _frames_fisica(3)
	var texto := etiqueta.text
	comprobar(not texto.contains("°") and not texto.contains("(") and not texto.contains("Interior"), "sin depuración no hay temperaturas ni números: «%s»" % texto.replace("\n", " / "))
	comprobar(texto.begins_with("Crudo"), "enseña el término: «%s»" % texto.get_slice("\n", 0))
	pinzas.soltar()
	Input.action_release("action_primary")


func _rueda(boton: MouseButton) -> InputEventMouseButton:
	var e := InputEventMouseButton.new()
	e.button_index = boton
	e.pressed = true
	return e


func _solo_uno_activo(utensilios: Dictionary, id: StringName) -> void:
	for otro in utensilios:
		var u: Node3D = utensilios[otro]
		if u.suelto:
			continue
		var debe: bool = otro == id
		comprobar(u.activo == debe and u.visible == debe, "%s %s" % [otro, "en la mano" if debe else "guardado"])


func _frames_fisica(n: int) -> void:
	for i in n:
		await physics_frame
