extends SceneTree
## Saca una captura desde los ojos del jugador con cada utensilio en la mano
## derecha (y una con las manos libres), para revisar las manos y los agarres.
##   CAPTURA_DIR=/ruta godot --path . --script res://herramientas/captura_manos.gd
func _initialize() -> void:
	root.size = Vector2i(1280, 720)
	change_scene_to_file("res://escenas/patio_prueba.tscn")
	for i in 20:
		await process_frame
	var cinturon: Node = root.get_node("Cinturon")
	var dir := OS.get_environment("CAPTURA_DIR")
	var ids: Array = [&"", &"pinzas", &"abanico", &"trapo", &"chimenea"]
	for id in ids:
		if id == &"":
			cinturon.seleccionar(cinturon.seleccionado)
		else:
			cinturon.sacar(id)
		for i in 30:
			await process_frame
		root.get_texture().get_image().save_png("%s/mano_%s.png" % [dir, id if id != &"" else "libre"])
	# Pala y magiclick: se recogen de la mesa soltando antes dos utensilios.
	for par in [[&"trapo", &"pala"], [&"abanico", &"magiclick"]]:
		cinturon.sacar(par[0])
		for u in get_nodes_in_group("utensilio_mano"):
			if u.id == par[0]:
				u.soltar_al_suelo()
		for u in get_nodes_in_group("utensilio_mano"):
			if u.id == par[1]:
				u.recoger()
		for i in 30:
			await process_frame
		if par[1] == &"magiclick":
			Input.action_press("action_primary")
			for i in 5:
				await process_frame
		root.get_texture().get_image().save_png("%s/mano_%s.png" % [dir, par[1]])
	Input.action_release("action_primary")
	print("CAPTURA OK")
	quit()
