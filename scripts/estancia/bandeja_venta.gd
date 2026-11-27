extends Node3D
## Bandeja de venta en el mostrador del quincho: la comida que se deja en ella
## (suelta, no con las pinzas cogiéndola) se vende al rato y el dinero va a
## la Herencia para las reformas.
##
## Precio = precio_venta del alimento × punto del interior × cómo están las
## caras de arriba y abajo. Cruda o sucia no se vende: se queda en la bandeja.

## Segundos que tiene que estar quieta en la bandeja para venderse.
const ESPERA := 0.8
## Lo que vale cada punto del interior (1 = perfecto).
const POR_PUNTO := {
	"crudo": 0.0,
	"poco hecho": 0.75,
	"al punto": 1.0,
	"hecho": 0.9,
	"muy hecho": 0.5,
}

const HERENCIA := preload("res://scripts/estancia/herencia.gd")

signal vendida(comida: RigidBody3D, precio: int)

var _esperando := {}

@onready var _zona: Area3D = $Zona
@onready var _aviso: Label3D = $Aviso


func _ready() -> void:
	_construir()
	_aviso.visible = false


func _construir() -> void:
	Geo.caja(self, Vector3(0.7, 0.03, 0.5), Vector3(0, 0.015, 0), Color("8a5a3b"), Vector3.ZERO, false)
	for lado in [-1.0, 1.0]:
		Geo.caja(self, Vector3(0.7, 0.05, 0.03), Vector3(0, 0.04, lado * 0.25), Color("5e3b25"), Vector3.ZERO, false)
		Geo.caja(self, Vector3(0.03, 0.05, 0.5), Vector3(lado * 0.35, 0.04, 0), Color("5e3b25"), Vector3.ZERO, false)
	# Pizarrita con "Venta".
	var pizarra := Geo.caja(self, Vector3(0.45, 0.3, 0.03), Vector3(0.6, 0.2, -0.15), Color("2b2a2e"), Vector3(0, -20, 0), false)
	var l := Label3D.new()
	l.text = tr("VENTA_pizarra")
	l.font_size = 40
	l.pixel_size = 0.002
	l.outline_size = 0
	l.modulate = Color("f3e6cf")
	l.double_sided = false
	l.position = Vector3(0, 0, 0.02)
	pizarra.add_child(l)


func _physics_process(delta: float) -> void:
	var dentro := {}
	for cuerpo in _zona.get_overlapping_bodies():
		var comida := cuerpo as RigidBody3D
		if comida == null or not comida.has_node("Coccion") or comida.freeze:
			continue
		dentro[comida] = true
		_esperando[comida] = _esperando.get(comida, 0.0) + delta
		if _esperando[comida] >= ESPERA:
			_esperando[comida] = -INF  # no volver a intentarlo hasta que salga
			intentar_vender(comida)
	for comida in _esperando.keys():
		if not dentro.has(comida):
			_esperando.erase(comida)


## Precio de una pieza en este momento (0 si no se puede vender).
static func precio(comida: Node) -> int:
	var coccion := comida.get_node_or_null("Coccion")
	if coccion == null or coccion.estado == null:
		return 0
	var suciedad := comida.get_node_or_null("Suciedad")
	if suciedad and suciedad.sucia:
		return 0
	var estado: EstadoCoccion = coccion.estado
	var factor: float = POR_PUNTO.get(estado.punto_interior(), 0.0)
	for cara in [EstadoCoccion.Cara.ARRIBA, EstadoCoccion.Cara.ABAJO]:
		var g: float = estado.grado[cara]
		if g >= 4.0:
			factor *= 0.3  # quemada
		elif g >= 3.0:
			factor *= 0.75  # pasada
		elif g < 1.0:
			factor *= 0.6  # sin sellar
	return int(round(estado.tipo.precio_venta * factor / 50.0)) * 50


func intentar_vender(comida: RigidBody3D) -> void:
	var coccion := comida.get_node("Coccion")
	var suciedad := comida.get_node_or_null("Suciedad")
	if suciedad and suciedad.sucia:
		_avisar(tr("VENTA_sucia"))
		return
	var p := precio(comida)
	if p <= 0:
		_avisar(tr("VENTA_cruda"))
		return
	var estado: EstadoCoccion = coccion.estado
	var motivo := "%s %s" % [tr(estado.tipo.nombre), coccion.nombre_punto(estado.punto_interior())]
	var h := get_node_or_null("/root/Herencia")
	if h:
		h.ganar(p, motivo)
	vendida.emit(comida, p)
	_esperando.erase(comida)
	comida.queue_free()
	_avisar("+" + HERENCIA.formatear(p))


func _avisar(texto: String) -> void:
	_aviso.text = texto
	_aviso.visible = true
	await get_tree().create_timer(1.6).timeout
	if is_instance_valid(_aviso):
		_aviso.visible = false
