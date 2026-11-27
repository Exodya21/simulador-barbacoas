class_name ChimeneaEncendido
extends UtensilioMano
## Chimenea de encendido: un cilindro de chapa para prender el carbón.
## Va en el cinturón (escenas/utensilios/chimenea_encendido.tscn).
##
## Con la chimenea en la mano, el **clic izquierdo** hace la acción:
## 1. **Vacía** → junto al saco de carbón, se llena (también con F en el saco).
## 2. **Llena** → se enciende.
## 3. **Prendiendo** → hay que esperar a que el carbón se ponga al rojo. Sigue
##    prendiendo aunque la guardes en el cinturón.
## 4. **Lista** → apuntando a la parrilla, vuelca las brasas donde apuntas y
##    vuelve a quedar vacía.

signal estado_cambiado(estado: Estado)
signal volcada(rejilla: RejillaCalor, carbon: float)

enum Estado { VACIA, LLENA, PRENDIENDO, LISTA }

const GRUPO_CHIMENEA := "chimenea_encendido"
const CAPAS := (1 << 0) | (1 << 1)

## Carbón que cabe, en celdas llenas de la rejilla.
@export var capacidad := 7.0
## Segundos que tarda el carbón en ponerse al rojo.
@export var segundos_prender := 45.0
## Radio (m) en el que se reparten las brasas al volcar.
@export var radio_volcado := 0.4
## Distancia máxima (m) del jugador al saco de carbón para llenarla.
@export var distancia_saco := 2.0
## Distancia máxima (m) desde la cámara para volcar.
@export var alcance := 2.2

var estado := Estado.VACIA
## De 0 a 1 mientras prende; 1 cuando está lista.
var progreso := 0.0

var _material_carbon: StandardMaterial3D

@onready var _carbon: MeshInstance3D = $Modelo/Carbon
@onready var _luz: OmniLight3D = $Modelo/Luz
@onready var _modelo: Node3D = $Modelo


func _ready() -> void:
	if id == &"":
		id = &"chimenea"
	add_to_group(GRUPO_CHIMENEA)
	_material_carbon = (_carbon.mesh.surface_get_material(0) as StandardMaterial3D).duplicate()
	_carbon.material_override = _material_carbon
	super()
	_pintar()


func al_cambiar_mano(en_mano: bool) -> void:
	if not en_mano:
		return
	match estado:
		Estado.VACIA:
			avisar("CHIMENEA_ayuda_llenar")
		Estado.LLENA:
			avisar("CHIMENEA_ayuda_encender")
		Estado.LISTA:
			avisar("CHIMENEA_lleva_parrilla")


func _physics_process(delta: float) -> void:
	if estado == Estado.PRENDIENDO:
		progreso = minf(1.0, progreso + delta / maxf(segundos_prender, 0.01))
		if progreso >= 1.0:
			_poner_estado(Estado.LISTA)
			avisar("CHIMENEA_lista")
		_pintar()
	if activo and not jugador_lleva_algo() and Input.is_action_just_pressed("action_primary"):
		usar()


## La acción del clic según el estado. `punto` es donde apuntas (si no se da,
## se lanza el rayo desde la cámara).
func usar(punto := Vector3.INF) -> void:
	match estado:
		Estado.VACIA:
			if saco_cercano() == null:
				avisar("CHIMENEA_falta_saco")
			else:
				llenar()
		Estado.LLENA:
			encender()
		Estado.PRENDIENDO:
			avisar("CHIMENEA_prendiendo")
		Estado.LISTA:
			if not punto.is_finite():
				punto = rayo_mira(alcance, CAPAS).get("position", Vector3.INF)
			var rejilla := rejilla_en(punto) if punto.is_finite() else null
			if rejilla == null:
				avisar("CHIMENEA_lleva_parrilla")
			else:
				volcar(rejilla, punto)


func llenar() -> bool:
	if estado != Estado.VACIA:
		return false
	progreso = 0.0
	_poner_estado(Estado.LLENA)
	avisar("CHIMENEA_llena")
	return true


func encender() -> bool:
	if estado != Estado.LLENA:
		return false
	progreso = 0.0
	_poner_estado(Estado.PRENDIENDO)
	avisar("CHIMENEA_encendida")
	return true


## Vuelca las brasas sobre la rejilla, centradas en `punto`.
func volcar(rejilla: RejillaCalor, punto: Vector3) -> float:
	if estado != Estado.LISTA or rejilla == null:
		return 0.0
	var cabido := rejilla.echar_carbon(punto, capacidad, 1.0, radio_volcado)
	progreso = 0.0
	_poner_estado(Estado.VACIA)
	volcada.emit(rejilla, cabido)
	avisar("CHIMENEA_volcada")
	_animar_volcado()
	return cabido


## Saco de carbón a menos de `distancia_saco` del jugador, o null.
func saco_cercano() -> Node3D:
	var camara := _camara_actual()
	var desde := camara.global_position if camara else global_position
	for nodo in get_tree().get_nodes_in_group(SacoCarbon.GRUPO):
		var saco := nodo as Node3D
		if saco and saco.global_position.distance_to(desde) <= distancia_saco:
			return saco
	return null


func _poner_estado(nuevo: Estado) -> void:
	estado = nuevo
	_pintar()
	estado_cambiado.emit(estado)


func _pintar() -> void:
	if _carbon == null:
		return
	_carbon.visible = estado != Estado.VACIA
	var brillo := progreso if estado == Estado.PRENDIENDO else (1.0 if estado == Estado.LISTA else 0.0)
	_material_carbon.emission_energy_multiplier = 3.0 * brillo * brillo
	_luz.light_energy = 0.6 * brillo
	_luz.visible = brillo > 0.02


## Inclina la chimenea hacia delante y vuelve, como al vaciarla.
func _animar_volcado() -> void:
	var tween := create_tween()
	tween.tween_property(_modelo, "rotation:x", -1.6, 0.18)
	tween.tween_property(_modelo, "rotation:x", 0.0, 0.3).set_delay(0.15)
