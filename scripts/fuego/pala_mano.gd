class_name PalaMano
extends UtensilioMano
## Pala de mano para mover el carbón. Va en el cinturón
## (escenas/utensilios/pala_mano.tscn).
##
## Con la pala en la mano, el **clic izquierdo**:
## - **Vacía** → apuntando a la parrilla, coge brasas de ese sitio (con su
##   fuego). Apuntando al saco de carbón, coge carbón crudo.
## - **Cargada** → apuntando a la parrilla, echa lo que lleva donde apuntas.
##   El carbón crudo echado sobre brasas las enfría un poco (RejillaCalor).
## Las brasas de la pala se van apagando poco a poco.

signal cargada(carbon: float, fuego: float)
signal vaciada(rejilla: RejillaCalor, carbon: float)

const CAPAS := (1 << 0) | (1 << 1)

## Carbón que cabe en la pala, en celdas llenas de la rejilla.
@export var capacidad := 1.2
## Radio (m) del que coge y en el que echa.
@export var radio := 0.18
## Distancia máxima (m) desde la cámara.
@export var alcance := 2.2
## Segundos en que se apagan las brasas que lleva.
@export var segundos_apagarse := 90.0

## Carbón que lleva (0 = vacía) y su fuego (0–1).
var carga := 0.0
var fuego_carga := 0.0

var _material_carbon: StandardMaterial3D

@onready var _carbon: Node3D = $Modelo/Carbon


func _ready() -> void:
	if id == &"":
		id = &"pala"
	var primero := _carbon.get_child(0) as MeshInstance3D
	_material_carbon = (primero.mesh.surface_get_material(0) as StandardMaterial3D).duplicate()
	for trozo in _carbon.get_children():
		(trozo as MeshInstance3D).material_override = _material_carbon
	super()
	_pintar()


func al_cambiar_mano(en_mano: bool) -> void:
	if en_mano:
		avisar("PALA_ayuda")


func _physics_process(delta: float) -> void:
	if carga > 0.0 and fuego_carga > 0.0:
		fuego_carga = maxf(0.0, fuego_carga - delta / segundos_apagarse)
		_pintar()
	if activo and not jugador_lleva_algo() and Input.is_action_just_pressed("action_primary"):
		var golpe := rayo_mira(alcance, CAPAS)
		usar(golpe.get("position", Vector3.INF), golpe.get("collider"))


## La acción del clic: `punto` es donde apuntas y `objeto` lo que hay ahí.
func usar(punto: Vector3, objeto: Object = null) -> void:
	var rejilla := rejilla_en(punto) if punto.is_finite() else null
	if carga <= 0.0:
		if objeto is Node and (objeto as Node).is_in_group(SacoCarbon.GRUPO):
			_cargar(capacidad, 0.0)
			avisar("PALA_carbon_crudo")
		elif rejilla:
			var sacado := rejilla.sacar_carbon(punto, capacidad, radio)
			if sacado.carbon > 0.02:
				_cargar(sacado.carbon, sacado.fuego)
			else:
				avisar("PALA_sin_carbon")
		else:
			avisar("PALA_apunta")
	elif rejilla:
		var cabido := rejilla.echar_carbon(punto, carga, fuego_carga, radio)
		carga = maxf(0.0, carga - cabido)
		if carga < 0.02:
			carga = 0.0
		vaciada.emit(rejilla, cabido)
		_pintar()
	else:
		avisar("PALA_lleva_parrilla")


func _cargar(cantidad: float, fuego: float) -> void:
	carga = cantidad
	fuego_carga = fuego
	cargada.emit(carga, fuego_carga)
	_pintar()


func _pintar() -> void:
	if _carbon == null:
		return
	_carbon.visible = carga > 0.0
	var n := _carbon.get_child_count()
	for i in n:
		(_carbon.get_child(i) as Node3D).visible = i < ceili(carga / capacidad * n)
	var f := clampf((fuego_carga - 0.15) / 0.85, 0.0, 1.0)
	_material_carbon.emission_enabled = true
	_material_carbon.emission = Color(0.91, 0.467, 0.18).lerp(Color(0.96, 0.75, 0.29), f * 0.5)
	_material_carbon.emission_energy_multiplier = 2.2 * f * f
