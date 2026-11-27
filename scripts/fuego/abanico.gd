class_name Abanico
extends UtensilioMano
## Abanico para avivar las brasas. Va en el cinturón (escenas/utensilios/abanico.tscn).
##
## Con el abanico en la mano, **mantener el clic izquierdo** abanica: si
## apuntas a la parrilla, las brasas de ese sitio suben de fuego (y gastan
## carbón antes).

signal abanicando(rejilla: RejillaCalor)

const CAPAS := (1 << 0) | (1 << 1)

## Abanicadas por segundo (vaivén del modelo).
@export var vaivenes_por_segundo := 3.0
## Radio (m) de brasas que aviva.
@export var radio := 0.3
## Distancia máxima (m) desde la cámara a la que llega.
@export var alcance := 2.2

var abanicando_ahora := false
var _fase := 0.0

@onready var _modelo: Node3D = $Modelo


func _ready() -> void:
	if id == &"":
		id = &"abanico"
	super()


func al_cambiar_mano(en_mano: bool) -> void:
	if en_mano:
		avisar("ABANICO_ayuda")


func _physics_process(delta: float) -> void:
	abanicando_ahora = activo and not jugador_lleva_algo() and Input.is_action_pressed("action_primary")
	if abanicando_ahora:
		var golpe := rayo_mira(alcance, CAPAS)
		abanicar(delta, golpe.get("position", Vector3.INF))
	else:
		_modelo.rotation.x = lerpf(_modelo.rotation.x, 0.0, minf(1.0, delta * 10.0))


## Un paso de abanicar: mueve el modelo y, si `punto` cae sobre una rejilla,
## aviva sus brasas. Devuelve la rejilla avivada o null.
func abanicar(delta: float, punto: Vector3) -> RejillaCalor:
	_fase += delta * TAU * vaivenes_por_segundo
	_modelo.rotation.x = sin(_fase) * 0.6
	if not punto.is_finite():
		return null
	var rejilla := rejilla_en(punto)
	if rejilla:
		rejilla.avivar(punto, delta, radio)
		abanicando.emit(rejilla)
	return rejilla
