extends CogitoObject
## Mancha de grasa y aceite en el suelo. Va en el nodo raíz de
## escenas/limpieza/mancha_grasa.tscn (un StaticBody3D fino en la capa de
## "objetos sin física" de Cogito: el rayo de interacción la ve, el jugador
## y la comida la atraviesan).
##
## - Resbala: mientras el jugador la pisa, frena y gira mucho peor.
## - No desaparece sola: hay que limpiarla manteniendo la tecla de
##   interactuar (HoldInteraction de Cogito, que llama a `interact` al acabar).

const GRUPO := "mancha_grasa"
## Agarre del jugador sobre la mancha (LERP_SPEED de Cogito; normal = 10).
const AGARRE_RESBALADIZO := 1.2

signal limpiada

@onready var _zona: Area3D = $ZonaResbaladiza


func _ready() -> void:
	super()
	add_to_group(GRUPO)
	_zona.body_entered.connect(_al_entrar)
	_zona.body_exited.connect(_al_salir)
	# Cada mancha distinta: giro y tamaño al azar.
	var malla := $Malla as Node3D
	malla.rotation.y = randf() * TAU
	malla.scale *= randf_range(0.8, 1.25)


## Llamado por la HoldInteraction al terminar de limpiar.
func interact(_player_interaction_component = null) -> void:
	limpiar()


func limpiar() -> void:
	for cuerpo in _zona.get_overlapping_bodies():
		_al_salir(cuerpo)
	limpiada.emit()
	queue_free()


func _al_entrar(cuerpo: Node3D) -> void:
	if cuerpo.is_in_group("Player"):
		Resbalar.entrar(cuerpo, AGARRE_RESBALADIZO)


func _al_salir(cuerpo: Node3D) -> void:
	if cuerpo.is_in_group("Player"):
		Resbalar.salir(cuerpo)
