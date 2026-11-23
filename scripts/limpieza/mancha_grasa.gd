extends CogitoObject
## Mancha de grasa y aceite en el suelo. Va en el nodo raíz de
## escenas/limpieza/mancha_grasa.tscn (un StaticBody3D fino en la capa de
## "objetos sin física" de Cogito: el rayo de interacción la ve, el jugador
## y la comida la atraviesan).
##
## - Resbala: mientras el jugador la pisa, frena y gira mucho peor.
## - No desaparece sola: hay que limpiarla manteniendo la tecla de
##   interactuar (HoldInteraction de Cogito, que llama a `interact` al acabar).
## - Se limpia con el utensilio que tenga el jugador (autoload Equipo; por
##   defecto el trapo viejo). Mientras se limpia, el utensilio aparece
##   frotando en círculos y la mancha se va desvaneciendo.

const GRUPO := "mancha_grasa"
## Agarre del jugador sobre la mancha (LERP_SPEED de Cogito; normal = 10).
const AGARRE_RESBALADIZO := 1.2
## Si deja de llegar la señal de "manteniendo" este tiempo (s), se ha soltado.
const PAUSA_SOLTADO := 0.15
## Vueltas por segundo al frotar.
const VUELTAS_POR_SEGUNDO := 1.6

signal limpiada

var utensilio: UtensilioLimpieza
var frotando := false

var _material: StandardMaterial3D
var _modelo_utensilio: Node3D
var _desde_ultimo_frote := 0.0
var _angulo := 0.0

@onready var _zona: Area3D = $ZonaResbaladiza
@onready var _malla: MeshInstance3D = $Malla
@onready var _limpiar: Node = $Limpiar


func _ready() -> void:
	super()
	add_to_group(GRUPO)
	_zona.body_entered.connect(_al_entrar)
	_zona.body_exited.connect(_al_salir)
	# Cada mancha distinta: giro y tamaño al azar, y su propio material para
	# poder desvanecerla sin tocar las demás.
	_malla.rotation.y = randf() * TAU
	_malla.scale *= randf_range(0.8, 1.25)
	_material = (_malla.mesh.surface_get_material(0) as StandardMaterial3D).duplicate()
	_malla.material_override = _material
	_limpiar.is_being_held.connect(_al_frotar)
	var equipo := get_node_or_null("/root/Equipo")
	if equipo:
		equipo.limpieza_cambiada.connect(poner_utensilio)
		poner_utensilio(equipo.limpieza)


func poner_utensilio(nuevo: UtensilioLimpieza) -> void:
	utensilio = nuevo
	if utensilio == null:
		return
	_limpiar.hold_time = utensilio.segundos_por_mancha
	_limpiar.interaction_text = utensilio.texto_interaccion
	if _modelo_utensilio:
		_modelo_utensilio.queue_free()
		_modelo_utensilio = null
	if utensilio.modelo:
		_modelo_utensilio = utensilio.modelo.instantiate() as Node3D
		_modelo_utensilio.name = "Utensilio"
		_modelo_utensilio.visible = false
		add_child(_modelo_utensilio)


## Llamado por la HoldInteraction al terminar de limpiar.
func interact(_player_interaction_component = null) -> void:
	limpiar()


func limpiar() -> void:
	for cuerpo in _zona.get_overlapping_bodies():
		_al_salir(cuerpo)
	limpiada.emit()
	queue_free()


## Cada frame que el jugador mantiene la tecla: el utensilio frota y la
## mancha se desvanece según lo que falta.
func _al_frotar(tiempo_restante: float, delta: float) -> void:
	frotando = true
	_desde_ultimo_frote = 0.0
	var total := maxf(_limpiar.hold_time, 0.01)
	_material.albedo_color.a = clampf(tiempo_restante / total, 0.15, 1.0)
	if _modelo_utensilio:
		_modelo_utensilio.visible = true
		_angulo += delta * TAU * VUELTAS_POR_SEGUNDO
		var radio := utensilio.radio_frotado if utensilio else 0.08
		_modelo_utensilio.position = Vector3(cos(_angulo) * radio, 0.012, sin(_angulo) * radio)
		_modelo_utensilio.rotation.y = -_angulo * 0.5


func _process(delta: float) -> void:
	if not frotando:
		return
	_desde_ultimo_frote += delta
	if _desde_ultimo_frote > PAUSA_SOLTADO:
		_dejar_de_frotar()


## Soltó la tecla antes de acabar: la mancha vuelve entera.
func _dejar_de_frotar() -> void:
	frotando = false
	_material.albedo_color.a = 1.0
	if _modelo_utensilio:
		_modelo_utensilio.visible = false


func _al_entrar(cuerpo: Node3D) -> void:
	if cuerpo.is_in_group("Player"):
		Resbalar.entrar(cuerpo, AGARRE_RESBALADIZO)


func _al_salir(cuerpo: Node3D) -> void:
	if cuerpo.is_in_group("Player"):
		Resbalar.salir(cuerpo)
