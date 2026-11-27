extends Node
## Autoload Cinturon: los utensilios que el jugador lleva colgados.
##
## Tiene `HUECOS` huecos; en cada uno va el id de un utensilio (o vacío). Solo
## uno va en la mano: con las teclas 1–4 (acciones quickslot_1..4) se saca el
## de ese hueco, y pulsando otra vez la del que ya llevas se guarda y quedas con
## las manos libres. La rueda del ratón pasa al siguiente o al anterior.
## Los utensilios (UtensilioMano) escuchan `cambiado` y se enseñan o se guardan.
## La barra de abajo de la pantalla es CinturonHud.

signal cambiado(seleccionado: int)

const HUECOS := 4
const NINGUNO := -1
## Utensilios con los que se empieza, por orden de hueco.
const INICIALES: Array[StringName] = [&"pinzas", &"abanico", &"trapo", &"chimenea"]
const ACCIONES := ["quickslot_1", "quickslot_2", "quickslot_3", "quickslot_4"]

var huecos: Array[StringName] = []
## Hueco del utensilio que va en la mano, o NINGUNO.
var seleccionado := 0


func _ready() -> void:
	reiniciar()


## Vuelve al cinturón inicial, con el primer utensilio en la mano.
func reiniciar() -> void:
	huecos.clear()
	huecos.resize(HUECOS)
	for i in HUECOS:
		huecos[i] = INICIALES[i] if i < INICIALES.size() else &""
	seleccionado = 0
	cambiado.emit(seleccionado)


func _unhandled_input(evento: InputEvent) -> void:
	for i in ACCIONES.size():
		if InputMap.has_action(ACCIONES[i]) and evento.is_action_pressed(ACCIONES[i]):
			seleccionar(i)
			return
	if evento.is_action_pressed("quickslot_next_wieldable"):
		pasar(1)
	elif evento.is_action_pressed("quickslot_prev_wieldable"):
		pasar(-1)


## Saca el utensilio del hueco `i`. Si ya está en la mano, lo guarda.
func seleccionar(i: int) -> void:
	if i < 0 or i >= HUECOS:
		return
	seleccionado = NINGUNO if i == seleccionado else i
	cambiado.emit(seleccionado)


## Pasa al hueco siguiente (+1) o anterior (−1) que tenga algo.
func pasar(paso: int) -> void:
	var i := seleccionado
	if i == NINGUNO:
		i = -1 if paso > 0 else HUECOS
	for intento in HUECOS:
		i = posmod(i + paso, HUECOS)
		if huecos[i] != &"":
			seleccionado = i
			cambiado.emit(seleccionado)
			return


## Id del utensilio que va en la mano, o &"" si las manos están libres.
func en_mano() -> StringName:
	return huecos[seleccionado] if seleccionado != NINGUNO else &""


func tiene_en_mano(id: StringName) -> bool:
	return en_mano() == id


## Hueco donde está un utensilio, o NINGUNO.
func hueco_de(id: StringName) -> int:
	return huecos.find(id)


## Saca a la mano un utensilio por su id (si está en el cinturón).
func sacar(id: StringName) -> void:
	var i := hueco_de(id)
	if i != NINGUNO and i != seleccionado:
		seleccionar(i)
