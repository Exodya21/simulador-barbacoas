extends SceneTree
## Prueba de humo: carga la escena principal, la deja correr unos frames,
## comprueba lo básico y sale.
## Uso: godot --headless --path . --script res://pruebas/humo.gd
## Sale con código 1 si algo falla.

const FRAMES := 120

var fallos := 0


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

	_comprobar_idioma()
	_comprobar_caja()

	if fallos > 0:
		printerr("HUMO FALLA: %d comprobaciones fallidas" % fallos)
		quit(1)
		return
	print("HUMO OK: %s corrió %d frames" % [ruta, FRAMES])
	quit(0)


func _comprobar(condicion: bool, mensaje: String) -> void:
	if not condicion:
		fallos += 1
		printerr("  ✗ " + mensaje)


func _comprobar_idioma() -> void:
	# El autoload Idioma pone español si no hay idioma guardado.
	TranslationServer.set_locale("es")
	_comprobar(TranslationServer.translate("BTN_Resume") == "Continuar", "falta la traducción al español (BTN_Resume)")
	_comprobar(TranslationServer.translate("INTERACT_carry") == "Llevar", "falta la traducción al español (INTERACT_carry)")


func _comprobar_caja() -> void:
	var caja := current_scene.get_node_or_null("CajaComida/CarryableComponent")
	_comprobar(caja != null, "no se encuentra CajaComida/CarryableComponent")
	if caja:
		_comprobar(caja.attribute_check == 0, "la caja sigue pidiendo fuerza para cogerla")
