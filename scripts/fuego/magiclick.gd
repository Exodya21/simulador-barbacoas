class_name Magiclick
extends UtensilioMano
## Magiclick (encendedor de cañón largo). Es la única forma de prender la
## chimenea de encendido. Va en el cinturón (escenas/utensilios/magiclick.tscn).
##
## Mientras **mantienes el clic izquierdo** sale la llama por la punta. Al
## hacer clic apuntando a la chimenea llena (suelta en el suelo o la mesa), la
## prende.

signal prendida(chimenea: ChimeneaEncendido)

const CAPAS := (1 << 0) | (1 << 1)

## Distancia máxima (m) desde la cámara a la que llega la llama.
@export var alcance := 1.6

var llama_encendida := false

@onready var _llama: Node3D = $Modelo/Llama


func _ready() -> void:
	if id == &"":
		id = &"magiclick"
	super()
	_poner_llama(false)


func al_cambiar_mano(en_mano: bool) -> void:
	if en_mano:
		avisar("MAGICLICK_ayuda")
	else:
		_poner_llama(false)


func _physics_process(_delta: float) -> void:
	var apretado := activo and not jugador_lleva_algo() and Input.is_action_pressed("action_primary")
	_poner_llama(apretado)
	if activo and not jugador_lleva_algo() and Input.is_action_just_pressed("action_primary"):
		prender(chimenea_apuntada())


## Chimenea a la que apunta el jugador (suelta en el mundo), o null.
func chimenea_apuntada() -> ChimeneaEncendido:
	var golpe := rayo_mira(alcance, CAPAS)
	var nodo: Node = golpe.get("collider")
	while nodo != null:
		if nodo is ChimeneaEncendido:
			return nodo
		var dentro = nodo.get("utensilio")
		if dentro is ChimeneaEncendido:
			return dentro
		nodo = nodo.get_parent()
	return null


## Intenta prender la chimenea. Devuelve true si la ha prendido.
func prender(chimenea: ChimeneaEncendido) -> bool:
	if chimenea == null:
		avisar("MAGICLICK_apunta_chimenea")
		return false
	match chimenea.estado:
		ChimeneaEncendido.Estado.VACIA:
			avisar("MAGICLICK_chimenea_vacia")
		ChimeneaEncendido.Estado.LLENA:
			if chimenea.encender():
				prendida.emit(chimenea)
				return true
		_:
			avisar("MAGICLICK_ya_encendida")
	return false


func _poner_llama(si: bool) -> void:
	llama_encendida = si
	if _llama:
		_llama.visible = si
