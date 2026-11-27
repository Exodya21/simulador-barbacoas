class_name CinturonHud
extends CanvasLayer
## Barra del cinturón abajo en el centro de la pantalla: un hueco por
## utensilio, con su tecla y su nombre. El que va en la mano se resalta.
## Esconde los huecos rápidos de Cogito (la cruceta 1–4), que no usamos.

const TAM_HUECO := Vector2(110, 62)
const COLOR_FONDO := Color(0.17, 0.165, 0.18, 0.72)   # Paleta: Carbón
const COLOR_BORDE := Color(0.604, 0.580, 0.549, 0.9)  # Paleta: Ceniza
const COLOR_MANO := Color(0.910, 0.467, 0.180, 1.0)   # Paleta: Brasa
const NOMBRES := {
	&"pinzas": "CINTURON_pinzas",
	&"abanico": "CINTURON_abanico",
	&"trapo": "CINTURON_trapo",
	&"chimenea": "CINTURON_chimenea",
}

var _huecos: Array[PanelContainer] = []
var _nombres: Array[Label] = []
var _fila: HBoxContainer


func _ready() -> void:
	layer = 4
	_construir()
	var cinturon := get_node_or_null("/root/Cinturon")
	if cinturon:
		cinturon.cambiado.connect(func(_i: int) -> void: actualizar())
	actualizar()
	_esconder_huecos_cogito.call_deferred()


func _construir() -> void:
	var raiz := Control.new()
	raiz.name = "Cinturon"
	raiz.set_anchors_preset(Control.PRESET_FULL_RECT)
	raiz.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(raiz)
	_fila = HBoxContainer.new()
	_fila.name = "Fila"
	_fila.add_theme_constant_override("separation", 10)
	_fila.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_fila.set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM, Control.PRESET_MODE_KEEP_SIZE)
	_fila.alignment = BoxContainer.ALIGNMENT_CENTER
	raiz.add_child(_fila)
	for i in 4:
		var hueco := PanelContainer.new()
		hueco.custom_minimum_size = TAM_HUECO
		hueco.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var caja := Control.new()
		caja.mouse_filter = Control.MOUSE_FILTER_IGNORE
		hueco.add_child(caja)
		var tecla := Label.new()
		tecla.text = str(i + 1)
		tecla.position = Vector2(6, 2)
		tecla.add_theme_font_size_override("font_size", 18)
		tecla.add_theme_color_override("font_color", COLOR_BORDE)
		caja.add_child(tecla)
		var nombre := Label.new()
		nombre.set_anchors_preset(Control.PRESET_FULL_RECT)
		nombre.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		nombre.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		nombre.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		nombre.add_theme_font_size_override("font_size", 18)
		caja.add_child(nombre)
		_fila.add_child(hueco)
		_huecos.append(hueco)
		_nombres.append(nombre)
	# Encima de las barras de vida de Cogito.
	_fila.offset_top = -TAM_HUECO.y - 140
	_fila.offset_bottom = -140
	_fila.offset_left = -(TAM_HUECO.x * 4 + 30) * 0.5
	_fila.offset_right = (TAM_HUECO.x * 4 + 30) * 0.5


func actualizar() -> void:
	var cinturon := get_node_or_null("/root/Cinturon")
	for i in _huecos.size():
		var id: StringName = cinturon.huecos[i] if cinturon else &""
		var en_mano: bool = cinturon != null and cinturon.seleccionado == i
		_nombres[i].text = tr(NOMBRES.get(id, "")) if id != &"" else ""
		var estilo := StyleBoxFlat.new()
		estilo.bg_color = COLOR_FONDO
		estilo.border_color = COLOR_MANO if en_mano else COLOR_BORDE
		estilo.set_border_width_all(4 if en_mano else 1)
		estilo.set_corner_radius_all(6)
		_huecos[i].add_theme_stylebox_override("panel", estilo)
		_huecos[i].modulate.a = 1.0 if en_mano else 0.8


## Los huecos rápidos de Cogito (cruceta 1–4) se solapan con el cinturón.
func _esconder_huecos_cogito() -> void:
	var huecos := get_tree().root.find_child("QuickSlots", true, false)
	if huecos is CanvasItem:
		(huecos as CanvasItem).visible = false


func _notification(que: int) -> void:
	if que == NOTIFICATION_TRANSLATION_CHANGED and _nombres.size() > 0:
		actualizar()
