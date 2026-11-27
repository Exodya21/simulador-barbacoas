class_name Pinzas
extends UtensilioMano
## Pinzas de barbacoa en la mano del jugador.
##
## - Apuntas a una comida y **mantienes el clic izquierdo**: las pinzas la
##   cogen y la aprietan mientras sigas apretando. Mientras la llevas, flota
##   sobre el punto al que apuntas (parrilla, mesa…). **Al soltar el clic** la
##   dejas justo ahí.
## - Con la comida cogida, **un clic derecho** abre el minijuego de dar la
##   vuelta: una línea sube y baja por una barra. **Al soltar el clic
##   izquierdo** se para la línea, la comida salta dando un par de vueltas y
##   cae según el resultado:
##   - PERFECTO: cae dada la vuelta, en su sitio.
##   - BIEN: se escurre; cae del lado bueno o no (más probable cuanto más
##     cerca del perfecto).
##   - MAL: sale despedida y cae al suelo.
## Van en el cinturón (UtensilioMano): solo funcionan cuando están en la mano.
## No hacen nada mientras el jugador lleva algo cogido con E (Cogito usa el
## clic para lanzarlo). Al guardarlas sueltan lo que llevaran.

signal cogido(cuerpo: RigidBody3D)
signal soltado(cuerpo: RigidBody3D)
## Al acabar la animación de dar la vuelta (la comida ya está suelta).
signal vuelta_terminada(cuerpo: RigidBody3D, resultado: MinijuegoVuelta.Resultado, dada_la_vuelta: bool)

const GRUPO := "pinzas"
## Capas de física (Cogito): 1 entorno, 2 objetos con los que se interactúa.
const CAPA_ENTORNO := 1 << 0
const CAPA_INTERACTUABLES := 1 << 1
const GRUPO_COMIDA := "comida"
## Distancia horizontal (m) para considerar que una pieza está apilada sobre otra.
const RADIO_PILA := 0.1

## Distancia máxima (m) desde la cámara para coger y para colocar.
@export var alcance := 1.8
## Altura (m) del centro de la comida sobre la superficie a la que apuntas.
@export var altura_sobre_superficie := 0.03
## Rapidez con la que la pieza cogida sigue al punto de colocación (1/s).
@export var seguimiento := 18.0
## Ángulo (grados) de cada brazo abierto y cerrado.
@export var apertura_abierta := 7.0
@export var apertura_cerrada := 0.7
## Velocidad (m/s) con la que sale despedida la comida al fallar el minijuego.
@export var impulso_fallo := 2.6

@export_group("Animación de dar la vuelta")
@export var duracion_vuelta := 0.65
@export var altura_vuelta := 0.22

var sostenido: RigidBody3D
var minijuego: MinijuegoVuelta
var rng := RandomNumberGenerator.new()
## Cuerpos que están dando la vuelta en el aire (animación en curso).
var en_el_aire: Array[RigidBody3D] = []


@onready var _punta: Marker3D = $Punta
@onready var _brazo_arriba: Node3D = $Modelo/Pinzas/BrazoArriba
@onready var _brazo_abajo: Node3D = $Modelo/Pinzas/BrazoAbajo
@onready var _barra: BarraMinijuego = $Interfaz/BarraMinijuego


func _ready() -> void:
	if id == &"":
		id = &"pinzas"
	add_to_group(GRUPO)
	rng.randomize()
	_poner_apertura(apertura_abierta)
	super()


func al_cambiar_mano(en_mano: bool) -> void:
	if not en_mano and sostenido:
		soltar()


func _physics_process(delta: float) -> void:
	if sostenido and not is_instance_valid(sostenido):
		sostenido = null
		_cerrar_minijuego()
		_poner_apertura(apertura_abierta)
	if not activo:
		return
	if not jugador_lleva_algo():
		_leer_controles()
	if minijuego:
		minijuego.avanzar(delta)
	if sostenido:
		var mezcla := 1.0 - exp(-seguimiento * delta)
		sostenido.global_position = sostenido.global_position.lerp(punto_de_colocacion(), mezcla)


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
	var golpe := _rayo_mira(CAPA_INTERACTUABLES, [])
	var cuerpo := golpe.get("collider") as RigidBody3D
	if cuerpo and cuerpo.has_node("Coccion") and not cuerpo in en_el_aire:
		return cuerpo
	return null


## Dónde quedaría la comida cogida: sobre la superficie a la que apuntas
## (dentro del alcance) o, si no apuntas a nada, en la punta de las pinzas.
func punto_de_colocacion() -> Vector3:
	var excluir: Array[RID] = []
	if sostenido:
		excluir.append(sostenido.get_rid())
		# Lo que va apilado encima no cuenta como suelo: si no, la pieza de
		# abajo intentaría subir a través de la de arriba.
		for encima in apiladas_encima(sostenido):
			excluir.append(encima.get_rid())
	var golpe := _rayo_mira(CAPA_ENTORNO | CAPA_INTERACTUABLES, excluir)
	if not golpe.is_empty():
		return golpe.position + Vector3.UP * altura_sobre_superficie
	return _punta.global_position


## Piezas de comida apoyadas encima de `cuerpo` (en su vertical y más arriba).
func apiladas_encima(cuerpo: RigidBody3D) -> Array[RigidBody3D]:
	var resultado: Array[RigidBody3D] = []
	for nodo in get_tree().get_nodes_in_group(GRUPO_COMIDA):
		var otro := nodo as RigidBody3D
		if otro == null or otro == cuerpo:
			continue
		var d := otro.global_position - cuerpo.global_position
		if Vector2(d.x, d.z).length() < RADIO_PILA and d.y > -0.005:
			resultado.append(otro)
	return resultado


func _rayo_mira(mascara: int, excluir: Array[RID]) -> Dictionary:
	var camara := _camara_actual()
	if camara == null:
		return {}
	var origen := camara.global_position
	var consulta := PhysicsRayQueryParameters3D.create(origen, origen - camara.global_basis.z * alcance, mascara)
	consulta.exclude = excluir
	return get_world_3d().direct_space_state.intersect_ray(consulta)


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
	_congelar(cuerpo)
	_poner_apertura(apertura_cerrada)
	cogido.emit(cuerpo)


## Suelta la comida donde apuntas, tal cual, sin dar la vuelta.
func soltar() -> RigidBody3D:
	var cuerpo := sostenido
	if cuerpo == null or not is_instance_valid(cuerpo):
		sostenido = null
		return null
	cuerpo.global_position = punto_de_colocacion()
	sostenido = null
	_cerrar_minijuego()
	_poner_apertura(apertura_abierta)
	_liberar(cuerpo)
	soltado.emit(cuerpo)
	return cuerpo


func abrir_minijuego() -> void:
	if sostenido == null:
		return
	minijuego = MinijuegoVuelta.new(rng)
	if _barra:
		_barra.abrir(minijuego)


## Para la línea donde esté, lanza la animación de dar la vuelta y devuelve
## el resultado. La comida queda suelta al acabar la animación
## (señal vuelta_terminada).
func terminar_minijuego() -> MinijuegoVuelta.Resultado:
	var juego := minijuego
	var resultado := juego.resultado()
	var cuerpo := sostenido
	if cuerpo == null or not is_instance_valid(cuerpo):
		_cerrar_minijuego()
		return resultado
	var dada_la_vuelta := false
	match resultado:
		MinijuegoVuelta.Resultado.PERFECTO:
			dada_la_vuelta = true
		MinijuegoVuelta.Resultado.BIEN:
			dada_la_vuelta = juego.sale_dada_la_vuelta()
	cuerpo.global_position = punto_de_colocacion()
	sostenido = null
	_cerrar_minijuego()
	_poner_apertura(apertura_abierta)
	_avisar(resultado, dada_la_vuelta)
	_animar_vuelta(cuerpo, resultado, dada_la_vuelta)
	return resultado


## Salto con un par de vueltas en el aire; cae como diga el minijuego.
func _animar_vuelta(cuerpo: RigidBody3D, resultado: MinijuegoVuelta.Resultado, dada_la_vuelta: bool) -> void:
	en_el_aire.append(cuerpo)
	var eje := Voltear.eje_horizontal(_camara_actual())
	var base := cuerpo.global_position
	var giro_inicial := cuerpo.global_basis
	# Dos vueltas enteras, más media si acaba dada la vuelta.
	var angulo_total := TAU * 2.0 + (PI if dada_la_vuelta else 0.0)
	var mal := resultado == MinijuegoVuelta.Resultado.MAL
	# Con MAL se escapa a mitad del salto.
	var hasta := 0.45 if mal else 1.0
	var tween := create_tween()
	tween.tween_method(func(t: float) -> void:
		if not is_instance_valid(cuerpo):
			return
		cuerpo.global_position = base + Vector3.UP * altura_vuelta * 4.0 * t * (1.0 - t)
		cuerpo.global_basis = Basis(eje, angulo_total * t) * giro_inicial,
		0.0, hasta, duracion_vuelta * hasta)
	await tween.finished
	en_el_aire.erase(cuerpo)
	if not is_instance_valid(cuerpo):
		return
	if not mal:
		cuerpo.global_position = base
		cuerpo.global_basis = (Basis(eje, angulo_total) * giro_inicial).orthonormalized()
	_liberar(cuerpo)
	match resultado:
		MinijuegoVuelta.Resultado.BIEN:
			# Se escurre de las pinzas: cae con un pequeño bamboleo.
			cuerpo.angular_velocity = eje * rng.randf_range(-2.0, 2.0)
		MinijuegoVuelta.Resultado.MAL:
			_lanzar_al_suelo(cuerpo, eje)
	vuelta_terminada.emit(cuerpo, resultado, dada_la_vuelta)


## La comida sale despedida hacia un lado y cae al suelo.
func _lanzar_al_suelo(cuerpo: RigidBody3D, eje: Vector3) -> void:
	var lado := eje if rng.randf() < 0.5 else -eje
	var hacia_jugador := Vector3.ZERO
	var camara := _camara_actual()
	if camara:
		hacia_jugador = camara.global_basis.z
		hacia_jugador.y = 0.0
		hacia_jugador = hacia_jugador.normalized()
	cuerpo.linear_velocity = (lado + hacia_jugador * 0.6).normalized() * impulso_fallo + Vector3.UP * 1.2
	cuerpo.angular_velocity = Vector3(rng.randf_range(-12, 12), rng.randf_range(-6, 6), rng.randf_range(-12, 12))


## Mientras se lleva o vuela, la comida no tiene física propia (la mueven las
## pinzas), pero sigue chocando: empuja a la comida que toca en vez de
## atravesarla. Con el jugador no choca nunca (capas distintas).
func _congelar(cuerpo: RigidBody3D) -> void:
	cuerpo.freeze_mode = RigidBody3D.FREEZE_MODE_KINEMATIC
	cuerpo.freeze = true


## Devuelve la física, sin velocidad (no sale disparada).
func _liberar(cuerpo: RigidBody3D) -> void:
	cuerpo.freeze = false
	cuerpo.linear_velocity = Vector3.ZERO
	cuerpo.angular_velocity = Vector3.ZERO


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


func _poner_apertura(grados: float) -> void:
	if _brazo_arriba == null or _brazo_abajo == null:
		return
	var radianes := deg_to_rad(grados)
	var tween := create_tween().set_parallel()
	tween.tween_property(_brazo_arriba, "rotation:x", radianes, 0.08)
	tween.tween_property(_brazo_abajo, "rotation:x", -radianes, 0.08)

