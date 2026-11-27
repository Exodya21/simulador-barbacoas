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
	_comprobar_menu_opciones()

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
	# Arranca en español aunque quede el language.cfg viejo de Cogito con "en".
	_comprobar(TranslationServer.get_locale().begins_with("es") or FileAccess.get_file_as_string("user://idioma.cfg").strip_edges() != "es", "el juego no arranca en español (%s)" % TranslationServer.get_locale())
	# El autoload Idioma pone español si no hay idioma guardado.
	TranslationServer.set_locale("es")
	_comprobar(TranslationServer.translate("BTN_Resume") == "Continuar", "falta la traducción al español (BTN_Resume)")
	_comprobar(TranslationServer.translate("INTERACT_carry") == "Llevar", "falta la traducción al español (INTERACT_carry)")


func _comprobar_caja() -> void:
	# La caja está en el patio de prueba (la escena principal es la estancia).
	var patio: Node = load("res://escenas/patio_prueba.tscn").instantiate()
	var caja := patio.get_node_or_null("CajaComida/CarryableComponent")
	_comprobar(caja != null, "no se encuentra CajaComida/CarryableComponent en el patio")
	if caja:
		_comprobar(caja.attribute_check == 0, "la caja sigue pidiendo fuerza para cogerla")
	patio.free()


func _comprobar_menu_opciones() -> void:
	# El menú de opciones de Cogito usa nuestras banderas (sin las de Freepik).
	_comprobar(load("res://addons/cogito/EasyMenus/Scenes/OptionsTabMenu.tscn") != null, "el menú de opciones no carga")
	for codigo in ["es", "us", "de"]:
		_comprobar(load("res://arte/iconos/bandera_%s.png" % codigo) != null, "falta la bandera %s" % codigo)
