extends SceneTree
## Prueba de humo: carga la escena principal, la deja correr unos frames y sale.
## Uso: godot --headless --path . --script res://pruebas/humo.gd
## Sale con código 1 si la escena no se puede cargar.

const FRAMES := 120

func _initialize() -> void:
	var ruta: String = ProjectSettings.get_setting("application/run/main_scene")
	var escena := load(ruta) as PackedScene
	if escena == null:
		push_error("No se pudo cargar la escena principal: %s" % ruta)
		quit(1)
		return
	change_scene_to_packed(escena)
	for i in FRAMES:
		await process_frame
	print("HUMO OK: %s corrió %d frames" % [ruta, FRAMES])
	quit(0)
