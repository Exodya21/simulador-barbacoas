extends CanvasLayer
## HUD de la estancia: el dinero arriba a la derecha, los avisos (ventas,
## reformas) abajo y, la primera vez, la carta del abuelo.

const HERENCIA := preload("res://scripts/estancia/herencia.gd")
const C_PAPEL := Color("f3e6cf")
const C_TINTA := Color("3b2a1e")

var _dinero: Label
var _aviso: Label
var _carta: PanelContainer
var _tween_aviso: Tween


func _ready() -> void:
	layer = 5
	_dinero = Label.new()
	_dinero.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	_dinero.offset_left = -360
	_dinero.offset_right = -32
	_dinero.offset_top = 24
	_dinero.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_dinero.add_theme_font_size_override("font_size", 34)
	_dinero.add_theme_color_override("font_color", C_PAPEL)
	_dinero.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.8))
	_dinero.add_theme_constant_override("outline_size", 8)
	add_child(_dinero)

	_aviso = Label.new()
	_aviso.set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM)
	_aviso.offset_left = -600
	_aviso.offset_right = 600
	_aviso.offset_top = -260
	_aviso.offset_bottom = -200
	_aviso.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_aviso.add_theme_font_size_override("font_size", 30)
	_aviso.add_theme_color_override("font_color", Color("ffd27a"))
	_aviso.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.85))
	_aviso.add_theme_constant_override("outline_size", 8)
	_aviso.modulate.a = 0.0
	add_child(_aviso)

	var h := get_node_or_null("/root/Herencia")
	if h:
		h.dinero_cambiado.connect(_poner_dinero)
		h.aviso.connect(avisar)
		_poner_dinero(h.dinero)
		if not h.carta_leida:
			_mostrar_carta()


func _poner_dinero(dinero: int) -> void:
	_dinero.text = HERENCIA.formatear(dinero)


func avisar(texto: String) -> void:
	_aviso.text = texto
	if _tween_aviso:
		_tween_aviso.kill()
	_tween_aviso = create_tween()
	_tween_aviso.tween_property(_aviso, "modulate:a", 1.0, 0.2)
	_tween_aviso.tween_interval(2.5)
	_tween_aviso.tween_property(_aviso, "modulate:a", 0.0, 0.6)


## Carta del abuelo: la historia en cuatro líneas. Se cierra con F o Intro.
func _mostrar_carta() -> void:
	_carta = PanelContainer.new()
	var estilo := StyleBoxFlat.new()
	estilo.bg_color = C_PAPEL
	estilo.border_color = Color("8a5a3b")
	estilo.set_border_width_all(4)
	estilo.set_corner_radius_all(6)
	estilo.set_content_margin_all(40)
	_carta.add_theme_stylebox_override("panel", estilo)
	_carta.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	_carta.custom_minimum_size = Vector2(980, 0)
	_carta.offset_left = -490
	_carta.offset_right = 490
	_carta.grow_vertical = Control.GROW_DIRECTION_BOTH
	var caja := VBoxContainer.new()
	caja.add_theme_constant_override("separation", 18)
	_carta.add_child(caja)
	var texto := Label.new()
	texto.text = tr("CARTA_texto")
	texto.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	texto.custom_minimum_size = Vector2(900, 0)
	texto.add_theme_font_size_override("font_size", 26)
	texto.add_theme_color_override("font_color", C_TINTA)
	caja.add_child(texto)
	var pie := Label.new()
	pie.text = tr("CARTA_cerrar")
	pie.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	pie.add_theme_font_size_override("font_size", 20)
	pie.add_theme_color_override("font_color", Color("8a5a3b"))
	caja.add_child(pie)
	add_child(_carta)


func carta_abierta() -> bool:
	return _carta != null and is_instance_valid(_carta)


func cerrar_carta() -> void:
	if not carta_abierta():
		return
	_carta.queue_free()
	_carta = null
	var h := get_node_or_null("/root/Herencia")
	if h:
		h.leer_carta()


func _unhandled_input(evento: InputEvent) -> void:
	if carta_abierta() and (evento.is_action_pressed("interact") or evento.is_action_pressed("ui_accept")):
		cerrar_carta()
		get_viewport().set_input_as_handled()
