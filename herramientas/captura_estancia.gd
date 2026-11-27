extends SceneTree
## Capturas de la estancia desde varios puntos, en ruinas y reformada.
## Necesita pantalla (no va con --headless). Guarda los PNG en la carpeta
## de la variable CAPTURAS (por defecto user://capturas):
##   CAPTURAS=C:/tmp godot --path . --script res://herramientas/captura_estancia.gd

const VISTAS := {
	"entrada": [Vector3(0, 1.7, 44), Vector3(0, 3.2, 22)],
	"panoramica": [Vector3(-2, 16, 36), Vector3(0, 0, -6)],
	"quincho": [Vector3(19, 1.8, -3.5), Vector3(21, 1.4, -16)],
	"casa": [Vector3(-12, 1.8, 1), Vector3(-20, 2.2, -12)],
	"patio": [Vector3(10, 1.8, 18), Vector3(-2, 1.5, -10)],
}


func _initialize() -> void:
	root.size = Vector2i(1600, 900)
	var h: Node = root.get_node("Herencia")
	h.ruta_guardado = "user://captura_estancia.cfg"
	h.reiniciar()
	h.carta_leida = true
	change_scene_to_file("res://escenas/estancia/estancia.tscn")
	for i in 3:
		await process_frame
	var carpeta := OS.get_environment("CAPTURAS")
	if carpeta == "":
		carpeta = ProjectSettings.globalize_path("user://capturas")
	DirAccess.make_dir_recursive_absolute(carpeta)
	var escena := current_scene
	for nodo in ["Jugador", "CinturonHud", "HudEstancia"]:
		var n := escena.get_node_or_null(nodo)
		if n:
			n.queue_free()
	var cam := Camera3D.new()
	cam.fov = 70
	escena.add_child(cam)
	cam.make_current()
	await _fotos(cam, carpeta, "ruina")
	for r in h.CATALOGO:
		h.hechas.append(r.id)
	escena.get_node("Estancia").construir()
	await _fotos(cam, carpeta, "reformada")
	h.reiniciar()
	DirAccess.remove_absolute(ProjectSettings.globalize_path(h.ruta_guardado))
	print("CAPTURAS OK en ", carpeta)
	quit()


func _fotos(cam: Camera3D, carpeta: String, estado: String) -> void:
	for nombre in VISTAS:
		var v: Array = VISTAS[nombre]
		cam.global_position = v[0]
		cam.look_at(v[1])
		for i in 20:
			await process_frame
		root.get_texture().get_image().save_png("%s/%s_%s.png" % [carpeta, estado, nombre])
