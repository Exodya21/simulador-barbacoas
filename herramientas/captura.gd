extends SceneTree
## Saca una captura de la parrilla con tres hamburguesas (zona directa,
## transición e indirecta) tras ~1 min de juego. Necesita pantalla, o xvfb:
##   CAPTURA=/tmp/parrilla.png xvfb-run -a godot --rendering-driver opengl3 \
##     --path . --script res://herramientas/captura.gd
func _initialize() -> void:
	root.size = Vector2i(1280, 720)
	change_scene_to_file("res://escenas/patio_prueba.tscn")
	await process_frame
	await process_frame
	var r: Node3D = current_scene.get_node("Parrilla/RejillaCalor")
	var hs := ["Hamburguesa1", "Hamburguesa2", "Hamburguesa3"]
	var xs := [-0.6, -0.1, 0.55]
	for i in 3:
		var h := current_scene.get_node(hs[i]) as RigidBody3D
		h.global_position = r.to_global(Vector3(xs[i], 0.03, 0.1))
	Engine.time_scale = 8.0
	for i in 60 * 8:
		await physics_frame
	Engine.time_scale = 1.0
	var cam := Camera3D.new()
	current_scene.add_child(cam)
	cam.global_position = r.global_position + Vector3(0.0, 0.55, 0.85)
	cam.look_at(r.global_position + Vector3(0, 0, -0.05))
	cam.fov = 55
	cam.make_current()
	for i in 10:
		await process_frame
	var img := root.get_texture().get_image()
	img.save_png(OS.get_environment("CAPTURA"))
	print("CAPTURA OK")
	quit()
