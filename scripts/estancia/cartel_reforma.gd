extends CogitoObject
## Cartel de obra delante de cada zona sin reformar. Dice qué se arregla,
## cuánto cuesta y qué hace falta antes. Manteniendo F se paga la reforma
## (HoldInteraction de Cogito, que llama a `interact` al acabar).
## Lo pone Estancia; el origen del nodo es el centro de la tabla (a 1,25 m
## del suelo), porque Cogito corta el "mantener" si el origen queda lejos.

const C_TABLA := Color("e9d8a6")
const C_TEXTO := Color("2b2a2e")
const C_AVISO := Color("b3472f")

## Reforma que paga (datos/estancia/<id>.tres). Se pone antes de añadirlo.
var reforma_id: StringName

var _texto: Label3D
var _aviso: Label3D
var _pagar: Node


func _ready() -> void:
	super()
	_pagar = $Pagar
	_construir()
	var h := _herencia()
	if h:
		h.dinero_cambiado.connect(func(_d: int) -> void: _actualizar())
		h.reforma_hecha.connect(func(_id: StringName) -> void: _actualizar())
	_actualizar()


func _herencia() -> Node:
	return get_node_or_null("/root/Herencia")


func _construir() -> void:
	for x in [-0.55, 0.55]:
		Geo.caja(self, Vector3(0.09, 1.7, 0.09), Vector3(x, -0.4, -0.05), Color("6e6152"), Vector3.ZERO, false)
	Geo.caja(self, Vector3(1.35, 0.95, 0.05), Vector3(0, 0, 0), C_TABLA, Vector3.ZERO, false)
	# Franjas de obra arriba del cartel.
	for i in 5:
		var franja := Geo.caja(self, Vector3(0.2, 0.12, 0.052), Vector3(-0.54 + i * 0.27, 0.41, 0), Color("e8772e") if i % 2 == 0 else Color("2b2a2e"), Vector3.ZERO, false)
		franja.rotation_degrees.z = 25
	_texto = _etiqueta(Vector3(0, 0.03, 0.03), 30, C_TEXTO)
	_aviso = _etiqueta(Vector3(0, 0.75, 0.03), 34, C_AVISO)
	_aviso.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
	_aviso.outline_size = 8
	_aviso.visible = false


func _etiqueta(pos: Vector3, tam: int, color: Color) -> Label3D:
	var l := Label3D.new()
	l.position = pos
	l.font_size = tam
	l.pixel_size = 0.0025
	l.modulate = color
	l.outline_size = 0
	l.width = 480
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.double_sided = false
	add_child(l)
	return l


func _actualizar() -> void:
	var h := _herencia()
	if h == null or _texto == null:
		return
	var r: Reforma = h.reforma(reforma_id)
	if r == null:
		return
	display_name = r.nombre
	var lineas := PackedStringArray([tr("CARTEL_obra"), tr(r.nombre).to_upper(), h.formatear(r.coste)])
	var antes: Array[StringName] = h.faltan(reforma_id)
	if not antes.is_empty():
		var nombres := PackedStringArray()
		for req in antes:
			nombres.append(tr(h.reforma(req).nombre))
		lineas.append(tr("CARTEL_antes") % ", ".join(nombres))
	_texto.text = "\n".join(lineas)
	_pagar.interaction_text = "INTERACT_reformar"


## Lo llama el HoldInteraction al acabar de mantener F.
func interact(_player_interaction_component = null) -> void:
	var h := _herencia()
	if h == null:
		return
	var motivo: String = h.motivo(reforma_id)
	if not h.reformar(reforma_id):
		_avisar(motivo)


func _avisar(texto: String) -> void:
	_aviso.text = texto
	_aviso.visible = true
	await get_tree().create_timer(2.5).timeout
	if is_instance_valid(_aviso):
		_aviso.visible = false
