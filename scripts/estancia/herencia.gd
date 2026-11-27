extends Node
## Autoload Herencia: la estancia que te dejó el abuelo y el dinero para
## arreglarla. Lleva el dinero, qué reformas están hechas y la carta del
## abuelo, y lo guarda en user://estancia.cfg.
##
## El dinero entra vendiendo comida (bandeja de venta) y sale comprando carne
## (conservadora) y pagando reformas (carteles de obra).
## Depuración (F3 activa): F4 da 10.000 $.

signal dinero_cambiado(dinero: int)
signal reforma_hecha(id: StringName)
## Mensaje corto para el HUD ("+$ 1.350 · Hamburguesa al punto").
signal aviso(texto: String)

const RUTA_GUARDADO := "user://estancia.cfg"
## Los ahorros que deja el abuelo en la carta.
const DINERO_INICIAL := 2000
const DINERO_DEPURACION := 10000
const CATALOGO: Array[Reforma] = [
	preload("res://datos/estancia/desbroce.tres"),
	preload("res://datos/estancia/quincho.tres"),
	preload("res://datos/estancia/tranquera.tres"),
	preload("res://datos/estancia/aljibe.tres"),
	preload("res://datos/estancia/mesa.tres"),
	preload("res://datos/estancia/jardin.tres"),
	preload("res://datos/estancia/bodegon.tres"),
	preload("res://datos/estancia/casa.tres"),
]

var dinero := DINERO_INICIAL
var hechas: Array[StringName] = []
var carta_leida := false
## Se cambia en las pruebas para no pisar la partida del jugador.
var ruta_guardado := RUTA_GUARDADO


func _ready() -> void:
	cargar()


func _unhandled_input(evento: InputEvent) -> void:
	var tecla := evento as InputEventKey
	if tecla and tecla.pressed and not tecla.echo and tecla.keycode == KEY_F4:
		var depuracion := get_node_or_null("/root/Depuracion")
		if depuracion and depuracion.activa:
			ganar(DINERO_DEPURACION, tr("AVISO_depuracion"))


func reforma(id: StringName) -> Reforma:
	for r in CATALOGO:
		if r.id == id:
			return r
	return null


func hecha(id: StringName) -> bool:
	return id in hechas


## Reformas que faltan por hacer antes de poder hacer esta.
func faltan(id: StringName) -> Array[StringName]:
	var r := reforma(id)
	var lista: Array[StringName] = []
	if r:
		for req in r.requiere:
			if not hecha(req):
				lista.append(req)
	return lista


func puede_reformar(id: StringName) -> bool:
	var r := reforma(id)
	return r != null and not hecha(id) and faltan(id).is_empty() and dinero >= r.coste


## Por qué no se puede hacer una reforma (texto para el jugador), o "".
func motivo(id: StringName) -> String:
	var r := reforma(id)
	if r == null or hecha(id):
		return ""
	var antes := faltan(id)
	if not antes.is_empty():
		var nombres := PackedStringArray()
		for req in antes:
			nombres.append(tr(reforma(req).nombre))
		return tr("AVISO_antes") % ", ".join(nombres)
	if dinero < r.coste:
		return tr("AVISO_falta_dinero") % formatear(r.coste - dinero)
	return ""


func reformar(id: StringName) -> bool:
	if not puede_reformar(id):
		return false
	var r := reforma(id)
	dinero -= r.coste
	hechas.append(id)
	guardar()
	dinero_cambiado.emit(dinero)
	reforma_hecha.emit(id)
	aviso.emit(tr("AVISO_reforma_hecha") % tr(r.nombre))
	return true


func ganar(cantidad: int, motivo_texto := "") -> void:
	dinero += cantidad
	guardar()
	dinero_cambiado.emit(dinero)
	var texto := "+" + formatear(cantidad)
	if motivo_texto != "":
		texto += " · " + motivo_texto
	aviso.emit(texto)


## Paga `cantidad` si llega. Devuelve si se ha pagado.
func gastar(cantidad: int) -> bool:
	if dinero < cantidad:
		return false
	dinero -= cantidad
	guardar()
	dinero_cambiado.emit(dinero)
	return true


func leer_carta() -> void:
	carta_leida = true
	guardar()


## Partida nueva: estancia en ruinas, los ahorros del abuelo y la carta sin leer.
func reiniciar() -> void:
	dinero = DINERO_INICIAL
	hechas.clear()
	carta_leida = false
	guardar()
	dinero_cambiado.emit(dinero)


func guardar() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("estancia", "dinero", dinero)
	cfg.set_value("estancia", "hechas", PackedStringArray(hechas))
	cfg.set_value("estancia", "carta_leida", carta_leida)
	cfg.save(ruta_guardado)


func cargar() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(ruta_guardado) != OK:
		dinero = DINERO_INICIAL
		hechas.clear()
		carta_leida = false
		return
	dinero = cfg.get_value("estancia", "dinero", DINERO_INICIAL)
	hechas.clear()
	for id in cfg.get_value("estancia", "hechas", PackedStringArray()):
		if reforma(StringName(id)):
			hechas.append(StringName(id))
	carta_leida = cfg.get_value("estancia", "carta_leida", false)


## 20000 → "$ 20.000" (pesos, con punto de miles como en Argentina).
static func formatear(cantidad: int) -> String:
	var signo := "-" if cantidad < 0 else ""
	var s := str(absi(cantidad))
	var partes := PackedStringArray()
	while s.length() > 3:
		partes.insert(0, s.right(3))
		s = s.left(s.length() - 3)
	partes.insert(0, s)
	return "%s$ %s" % [signo, ".".join(partes)]
