class_name ChimeneaEncendido
extends CogitoObject
## Chimenea de encendido: un cilindro de chapa para prender el carbón.
## Va en el nodo raíz (RigidBody3D) de escenas/fuego/chimenea_encendido.tscn.
##
## Uso (E la coge y la suelta, como cualquier objeto de Cogito; F hace la
## acción, tanto mirándola como llevándola en la mano):
## 1. **Vacía** → F junto al saco de carbón: se llena.
## 2. **Llena** → F: se enciende.
## 3. **Prendiendo** → hay que esperar a que el carbón se ponga al rojo.
## 4. **Lista** → llevarla sobre la parrilla y F: vuelca las brasas donde
##    está, y vuelve a quedar vacía.

signal object_state_updated(texto: String)
signal estado_cambiado(estado: Estado)
signal volcada(rejilla: RejillaCalor, carbon: float)

enum Estado { VACIA, LLENA, PRENDIENDO, LISTA }

const GRUPO := "chimenea_encendido"
const TEXTOS := {
	Estado.VACIA: "CHIMENEA_llenar",
	Estado.LLENA: "CHIMENEA_encender",
	Estado.PRENDIENDO: "CHIMENEA_esperar",
	Estado.LISTA: "CHIMENEA_volcar",
}

## Carbón que cabe, en celdas llenas de la rejilla.
@export var capacidad := 7.0
## Segundos que tarda el carbón en ponerse al rojo.
@export var segundos_prender := 45.0
## Radio (m) en el que se reparten las brasas al volcar.
@export var radio_volcado := 0.4
## Distancia máxima (m) al saco de carbón para llenarla.
@export var distancia_saco := 1.3
## Altura máxima (m) sobre la rejilla para poder volcar.
@export var altura_volcado := 1.2

var estado := Estado.VACIA
## De 0 a 1 mientras prende; 1 cuando está lista.
var progreso := 0.0

var _material_carbon: StandardMaterial3D
var _pic: Node

@onready var _carbon: MeshInstance3D = $Carbon
@onready var _luz: OmniLight3D = $Luz
@onready var _llevar: Node = $CarryableComponent


func _ready() -> void:
	super()
	add_to_group(GRUPO)
	_material_carbon = (_carbon.mesh.surface_get_material(0) as StandardMaterial3D).duplicate()
	_carbon.material_override = _material_carbon
	_llevar.carry_state_changed.connect(_al_coger)
	_poner_estado(estado)


func _physics_process(delta: float) -> void:
	if estado == Estado.PRENDIENDO:
		progreso = minf(1.0, progreso + delta / maxf(segundos_prender, 0.01))
		if progreso >= 1.0:
			_poner_estado(Estado.LISTA)
			_avisar("CHIMENEA_lista")
		_pintar()
	# Llevándola en la mano, Cogito no pasa la F a la chimenea: la leemos aquí.
	if _llevar.is_being_carried and Input.is_action_just_pressed("interact"):
		usar(_llevar.player_interaction_component)


## Llamado por la BasicInteraction (F) al mirarla.
func interact(player_interaction_component = null) -> void:
	usar(player_interaction_component)


## La acción de F según el estado.
func usar(player_interaction_component = null) -> void:
	if player_interaction_component:
		_pic = player_interaction_component
	match estado:
		Estado.VACIA:
			if saco_cercano() == null:
				_avisar("CHIMENEA_falta_saco")
			else:
				llenar()
		Estado.LLENA:
			encender()
		Estado.PRENDIENDO:
			_avisar("CHIMENEA_prendiendo")
		Estado.LISTA:
			var rejilla := rejilla_debajo()
			if rejilla == null:
				_avisar("CHIMENEA_lleva_parrilla")
			else:
				volcar(rejilla)


func llenar() -> bool:
	if estado != Estado.VACIA:
		return false
	progreso = 0.0
	_poner_estado(Estado.LLENA)
	return true


func encender() -> bool:
	if estado != Estado.LLENA:
		return false
	progreso = 0.0
	_poner_estado(Estado.PRENDIENDO)
	_avisar("CHIMENEA_encendida")
	return true


## Vuelca las brasas sobre la rejilla, centradas bajo la chimenea.
func volcar(rejilla: RejillaCalor) -> float:
	if estado != Estado.LISTA or rejilla == null:
		return 0.0
	var cabido := rejilla.echar_carbon(global_position, capacidad, 1.0, radio_volcado)
	progreso = 0.0
	_poner_estado(Estado.VACIA)
	volcada.emit(rejilla, cabido)
	_avisar("CHIMENEA_volcada")
	return cabido


## Saco de carbón a menos de `distancia_saco`, o null.
func saco_cercano() -> Node3D:
	for nodo in get_tree().get_nodes_in_group(SacoCarbon.GRUPO):
		var saco := nodo as Node3D
		if saco and saco.global_position.distance_to(global_position) <= distancia_saco:
			return saco
	return null


## Rejilla que hay justo debajo de la chimenea, o null.
func rejilla_debajo() -> RejillaCalor:
	for nodo in get_tree().get_nodes_in_group(RejillaCalor.GRUPO):
		var rejilla := nodo as RejillaCalor
		if rejilla == null or rejilla.celda_en(global_position).x < 0:
			continue
		var altura := rejilla.to_local(global_position).y
		if altura > -0.05 and altura < altura_volcado:
			return rejilla
	return null


func _poner_estado(nuevo: Estado) -> void:
	estado = nuevo
	_pintar()
	object_state_updated.emit(TEXTOS[estado])
	estado_cambiado.emit(estado)


func _pintar() -> void:
	_carbon.visible = estado != Estado.VACIA
	var brillo := progreso if estado == Estado.PRENDIENDO else (1.0 if estado == Estado.LISTA else 0.0)
	_material_carbon.emission_energy_multiplier = 3.0 * brillo * brillo
	_luz.light_energy = 1.2 * brillo
	_luz.visible = brillo > 0.02


func _al_coger(cogida: bool) -> void:
	if cogida:
		_pic = _llevar.player_interaction_component
		match estado:
			Estado.VACIA:
				_avisar("CHIMENEA_ayuda_llenar")
			Estado.LISTA:
				_avisar("CHIMENEA_lleva_parrilla")


func _avisar(clave: String) -> void:
	if _pic == null or not is_instance_valid(_pic):
		var jugador := get_tree().get_first_node_in_group("Player")
		_pic = jugador.get("player_interaction_component") if jugador else null
	if _pic and _pic.has_method("send_hint"):
		_pic.send_hint(null, tr(clave))
