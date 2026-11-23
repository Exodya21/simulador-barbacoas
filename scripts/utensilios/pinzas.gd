class_name Pinzas
extends Node3D
## Pinzas de barbacoa en la mano del jugador.
##
## - Apuntas a una comida y **mantienes el clic izquierdo**: las pinzas la
##   cogen y la aprietan mientras sigas apretando. Al soltar el clic, la sueltas.
## - Con la comida cogida, **un clic derecho** abre el minijuego de dar la
##   vuelta: una línea sube y baja por una barra. **Al soltar el clic
##   izquierdo** se para la línea:
##   - PERFECTO: la comida da la vuelta perfecta.
##   - BIEN: se te cae de las pinzas; puede caer del lado bueno o no
##     (más probable cuanto más cerca del perfecto).
##   - MAL: se te cae al suelo.
## Al empezar se cuelgan de la cámara del jugador. No hacen nada mientras el
## jugador lleva algo en la mano con E (Cogito usa el clic para lanzarlo).

signal cogido(cuerpo: RigidBody3D)
signal soltado(cuerpo: RigidBody3D)
signal vuelta_terminada(cuerpo: RigidBody3D, resultado: MinijuegoVuelta.Resultado, dada_la_vuelta: bool)

const GRUPO := "pinzas"
## Capa de física de los objetos con los que se interactúa (Cogito: capa 2).
const CAPA_INTERACTUABLES := 1 << 1

## Distancia máxima (m) desde la cámara para coger.
@export var alcance := 1.8
## Posición de las pinzas respecto a la cámara (abajo a la derecha).
@export var posicion_en_camara := Vector3(0.14, -0.16, -0.10)
@export var giro_en_camara := Vector3(10.0, 6.0, 0.0)
## Rapidez con la que la pieza cogida sigue a la punta (1/s).
@export var seguimiento := 25.0
## Ángulo (grados) de cada brazo abierto y cerrado.
@export var apertura_abierta := 7.0
@export var apertura_cerrada := 0.7
## Velocidad (m/s) con la que sale despedida la comida al fallar el minijuego.
@export var impulso_fallo := 2.6

var sostenido: RigidBody3D
var minijuego: MinijuegoVuelta
var rng := RandomNumberGenerator.new()

var _capa_original := 0
var _camara: Camera3D

@onready var _punta: Marker3D = $Punta
@onready var _brazo_arriba: Node3D = $Modelo/Pinzas/BrazoArriba
@onready var _brazo_abajo: Node3D = $Modelo/Pinzas/BrazoAbajo
@onready var _barra: BarraMinijuego = $Interfaz/BarraMinijuego


func _ready() -> void:
	add_to_group(GRUPO)
	rng.randomize()
	_poner_apertura(apertura_abierta)
	_montar_en_camara.call_deferred()


func _montar_en_camara() -> void:
	_camara = get_viewport().get_camera_3d()
	if _camara == null:
		return
	reparent(_camara, false)
	position = posicion_en_camara
	rotation_degrees = giro_en_camara


func _physics_process(delta: float) -> void:
	if sostenido and not is_instance_valid(sostenido):
		_olvidar_sostenido()
	if not _jugador_lleva_algo():
		_leer_controles()
	if minijuego:
		minijuego.avanzar(delta)
	if sostenido:
		var mezcla := 1.0 - exp(-seguimiento * delta)
		sostenido.global_position = sostenido.global_position.lerp(_punta.global_position, mezcla)


func _leer_controles() -> void:
	var apretando := Input.is_action_pressed("action_primary")
	if Input.is_action_just_pressed("action_primary") and sostenido == null:
		intentar_coger()
	if sostenido and Input.is_action_just_pressed("action_secondary") and minijuego == null:
		abrir_minijuego()
	if sostenido and not apretando:
		if minijuego:
			terminar_minijuego()
		else:
			soltar()


## Alimento (cuerpo con cocción) bajo la mira, o null.
func alimento_apuntado() -> RigidBody3D:
	var camara := _camara if _camara else get_viewport().get_camera_3d()
	if camara == null:
		return null
	var origen := camara.global_position
	var consulta := PhysicsRayQueryParameters3D.create(origen, origen - camara.global_basis.z * alcance, CAPA_INTERACTUABLES)
	var golpe := get_world_3d().direct_space_state.intersect_ray(consulta)
	var cuerpo := golpe.get("collider") as RigidBody3D
	if cuerpo and cuerpo.has_node("Coccion"):
		return cuerpo
	return null


func intentar_coger() -> bool:
	var objetivo := alimento_apuntado()
	if objetivo == null:
		return false
	coger(objetivo)
	return true


func coger(cuerpo: RigidBody3D) -> void:
	if sostenido:
		soltar()
	sostenido = cuerpo
	_capa_original = cuerpo.collision_layer
	cuerpo.collision_layer = 0  # que no empuje al jugador mientras la llevamos
	cuerpo.freeze_mode = RigidBody3D.FREEZE_MODE_KINEMATIC
	cuerpo.freeze = true
	_poner_apertura(apertura_cerrada)
	cogido.emit(cuerpo)


## Suelta la comida tal cual, sin dar la vuelta.
func soltar() -> RigidBody3D:
	var cuerpo := sostenido
	_cerrar_minijuego()
	_olvidar_sostenido()
	if cuerpo and is_instance_valid(cuerpo):
		cuerpo.collision_layer = _capa_original
		cuerpo.freeze = false
		cuerpo.linear_velocity = Vector3.ZERO
		cuerpo.angular_velocity = Vector3.ZERO
		soltado.emit(cuerpo)
	return cuerpo


func abrir_minijuego() -> void:
	if sostenido == null:
		return
	minijuego = MinijuegoVuelta.new(rng)
	if _barra:
		_barra.abrir(minijuego)


## Para la línea donde esté y aplica el resultado. Devuelve el resultado.
func terminar_minijuego() -> MinijuegoVuelta.Resultado:
	var juego := minijuego
	var resultado := juego.resultado()
	var dada_la_vuelta := false
	var eje := Voltear.eje_horizontal(_camara)
	var cuerpo := soltar()
	if cuerpo == null:
		return resultado
	match resultado:
		MinijuegoVuelta.Resultado.PERFECTO:
			Voltear.voltear(cuerpo, eje, 0.0)
			dada_la_vuelta = true
		MinijuegoVuelta.Resultado.BIEN:
			dada_la_vuelta = juego.sale_dada_la_vuelta()
			if dada_la_vuelta:
				Voltear.voltear(cuerpo, eje, 0.0)
			# Se escurre de las pinzas: un pequeño bamboleo al caer.
			cuerpo.angular_velocity = eje * rng.randf_range(-3.0, 3.0)
		MinijuegoVuelta.Resultado.MAL:
			_lanzar_al_suelo(cuerpo, eje)
	_avisar(resultado, dada_la_vuelta)
	vuelta_terminada.emit(cuerpo, resultado, dada_la_vuelta)
	return resultado


## La comida sale despedida hacia un lado y cae al suelo.
func _lanzar_al_suelo(cuerpo: RigidBody3D, eje: Vector3) -> void:
	var lado := eje if rng.randf() < 0.5 else -eje
	var hacia_jugador := Vector3.ZERO
	if _camara:
		hacia_jugador = _camara.global_basis.z
		hacia_jugador.y = 0.0
		hacia_jugador = hacia_jugador.normalized()
	cuerpo.linear_velocity = (lado + hacia_jugador * 0.6).normalized() * impulso_fallo + Vector3.UP * 1.2
	cuerpo.angular_velocity = Vector3(rng.randf_range(-12, 12), rng.randf_range(-6, 6), rng.randf_range(-12, 12))


func _avisar(resultado: MinijuegoVuelta.Resultado, dada_la_vuelta: bool) -> void:
	if _barra == null:
		return
	match resultado:
		MinijuegoVuelta.Resultado.PERFECTO:
			_barra.mostrar_resultado(tr("MINIJUEGO_perfecto"), BarraMinijuego.COLOR_PERFECTO)
		MinijuegoVuelta.Resultado.BIEN:
			var clave := "MINIJUEGO_bien_vuelta" if dada_la_vuelta else "MINIJUEGO_bien_sin_vuelta"
			_barra.mostrar_resultado(tr(clave), BarraMinijuego.COLOR_BIEN)
		MinijuegoVuelta.Resultado.MAL:
			_barra.mostrar_resultado(tr("MINIJUEGO_mal"), Color(1.0, 0.35, 0.3))


func _cerrar_minijuego() -> void:
	minijuego = null
	if _barra:
		_barra.cerrar()


func _olvidar_sostenido() -> void:
	sostenido = null
	_cerrar_minijuego()
	_poner_apertura(apertura_abierta)


func _poner_apertura(grados: float) -> void:
	if _brazo_arriba == null or _brazo_abajo == null:
		return
	var radianes := deg_to_rad(grados)
	var tween := create_tween().set_parallel()
	tween.tween_property(_brazo_arriba, "rotation:x", radianes, 0.08)
	tween.tween_property(_brazo_abajo, "rotation:x", -radianes, 0.08)


func _jugador_lleva_algo() -> bool:
	if _camara == null:
		return false
	for nodo in get_tree().get_nodes_in_group("Player"):
		var componente := nodo.find_child("PlayerInteractionComponent", true, false)
		if componente and componente.get("is_carrying"):
			return true
	return false
