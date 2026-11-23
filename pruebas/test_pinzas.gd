extends PruebaBase
## Pinzas: se cuelgan de la cámara, cogen la comida a la que se apunta, la
## dejan donde se apunta (también en el centro de la parrilla), un clic rápido
## no la dispara, y el minijuego de dar la vuelta anima el salto y aplica el
## resultado.

const R := MinijuegoVuelta.Resultado

var pinzas: Node3D
var camara: Camera3D
var rejilla: Node3D


func _ejecutar() -> void:
	change_scene_to_file("res://escenas/patio_prueba.tscn")
	await process_frame
	await process_frame
	await _esperar_fisica(0.5)
	# Sin tipos de clase propios que usen Cogito: este script se compila antes que sus autoloads.
	pinzas = get_first_node_in_group("pinzas")
	comprobar(pinzas != null, "hay pinzas en el patio")
	if pinzas == null:
		return
	camara = root.get_viewport().get_camera_3d()
	rejilla = current_scene.get_node("Parrilla/RejillaCalor")
	comprobar(pinzas.get_parent() == camara, "las pinzas van colgadas de la cámara del jugador")
	comprobar(pinzas.get_node_or_null("Modelo/Pinzas/BrazoArriba") != null, "el modelo de Blender tiene los dos brazos")

	await _colocar_donde_apuntas()
	await _clic_rapido_no_dispara()
	await _flujo_con_clics()
	await _vuelta_perfecta()
	await _vuelta_bien()
	await _vuelta_mal()


## Pone al jugador delante de la parrilla mirando a un punto de la rejilla.
func _apuntar_a(punto_global: Vector3) -> void:
	var jugador := get_first_node_in_group("Player") as Node3D
	jugador.global_position = rejilla.global_position + Vector3(0, -0.15, 0.95)
	await _esperar_fisica(0.2)
	camara.look_at(punto_global)
	await _esperar_fisica(0.05)


func _poner_en_parrilla(nombre: String, local: Vector3) -> RigidBody3D:
	var h := current_scene.get_node(nombre) as RigidBody3D
	h.global_basis = Basis()
	h.global_position = rejilla.to_global(local + Vector3(0, 0.02, 0))
	h.linear_velocity = Vector3.ZERO
	await _esperar_fisica(0.6)
	return h


func _colocar_donde_apuntas() -> void:
	var h := await _poner_en_parrilla("Hamburguesa2", Vector3(0.6, 0, 0.3))
	await _apuntar_a(h.global_position)
	comprobar(pinzas.alimento_apuntado() == h, "la mira detecta la hamburguesa")
	Input.action_press("action_primary")
	comprobar(pinzas.intentar_coger(), "las pinzas cogen la hamburguesa")
	# Apuntar a una casilla interior de la parrilla (lejos del borde).
	var destino := rejilla.to_global(Vector3(-0.2, 0, -0.25))
	camara.look_at(destino)
	await _esperar_fisica(0.6)
	comprobar(pinzas.sostenido == h, "mientras se mantiene el clic, sigue cogida")
	var flotando := Vector2(h.global_position.x - destino.x, h.global_position.z - destino.z).length()
	comprobar(flotando < 0.05, "la hamburguesa cogida va al punto al que apuntas (a %.3f m)" % flotando)
	Input.action_release("action_primary")
	await _esperar_fisica(0.8)
	comprobar(pinzas.sostenido == null and not h.freeze, "al soltar el clic se suelta y vuelve a tener física")
	var celda: Vector2i = rejilla.celda_en(h.global_position)
	var celda_destino: Vector2i = rejilla.celda_en(destino)
	comprobar(celda == celda_destino, "queda en la casilla interior a la que apuntabas (%s, esperaba %s)" % [celda, celda_destino])
	comprobar(h.global_position.y > rejilla.global_position.y, "queda encima de la rejilla")
	comprobar(h.global_basis.y.y > 0.99, "soltar sin minijuego no le da la vuelta")


func _clic_rapido_no_dispara() -> void:
	var h := await _poner_en_parrilla("Hamburguesa3", Vector3(-0.5, 0, 0.1))
	await _apuntar_a(h.global_position)
	var antes := h.global_position
	Input.action_press("action_primary")
	await physics_frame
	await physics_frame
	comprobar(pinzas.sostenido == h, "un clic coge la hamburguesa")
	Input.action_release("action_primary")
	await physics_frame
	await physics_frame
	comprobar(pinzas.sostenido == null, "al soltar el clic la suelta")
	var max_velocidad := 0.0
	for i in 30:
		await physics_frame
		max_velocidad = maxf(max_velocidad, h.linear_velocity.length())
	comprobar(max_velocidad < 0.5, "un clic rápido no la dispara (velocidad máx. %.2f m/s)" % max_velocidad)
	comprobar(h.global_position.distance_to(antes) < 0.08, "un clic rápido la deja donde estaba (se movió %.3f m)" % h.global_position.distance_to(antes))


## Todo con clics simulados: mantener izquierdo, clic derecho, soltar izquierdo.
func _flujo_con_clics() -> void:
	var h := await _poner_en_parrilla("Hamburguesa2", Vector3(0.2, 0, 0.0))
	await _apuntar_a(h.global_position)
	Input.action_press("action_primary")
	await physics_frame
	await physics_frame
	comprobar(pinzas.sostenido == h, "mantener el clic izquierdo apuntando la coge")
	Input.action_press("action_secondary")
	await physics_frame
	await physics_frame
	Input.action_release("action_secondary")
	comprobar(pinzas.minijuego != null, "un clic derecho con la comida cogida abre la barra")
	comprobar(pinzas.sostenido == h, "con la barra abierta sigue cogida")
	pinzas.minijuego.posicion = pinzas.minijuego.centro
	pinzas.minijuego.velocidad = 0.0
	Input.action_release("action_primary")
	await physics_frame
	await physics_frame
	comprobar(pinzas.sostenido == null and pinzas.minijuego == null, "soltar el clic izquierdo para la línea")
	comprobar(h in pinzas.en_el_aire, "la hamburguesa salta dando vueltas")
	var alto_salto := 0.0
	var base_y := h.global_position.y
	var resultado: Array = []
	pinzas.vuelta_terminada.connect(func(c, r, v): resultado.append([c, r, v]), CONNECT_ONE_SHOT)
	for i in 60:
		await physics_frame
		alto_salto = maxf(alto_salto, h.global_position.y - base_y)
		if not resultado.is_empty():
			break
	comprobar(alto_salto > 0.1, "sube en el aire (%.2f m)" % alto_salto)
	comprobar(not resultado.is_empty(), "la animación termina en menos de 1 s")
	comprobar(h.global_basis.y.y < -0.99, "parada en la zona perfecta, cae dada la vuelta")
	await _esperar_fisica(0.5)
	comprobar(rejilla.celda_en(h.global_position) != Vector2i(-1, -1), "cae en la parrilla, no fuera")


func _terminar_en(h: RigidBody3D, donde: Callable) -> Array:
	Input.action_release("action_primary")
	pinzas.coger(h)
	pinzas.abrir_minijuego()
	comprobar(pinzas.minijuego != null, "el clic derecho abre el minijuego")
	pinzas.minijuego.posicion = donde.call(pinzas.minijuego)
	var r: int = pinzas.terminar_minijuego()
	var fin: Array = await pinzas.vuelta_terminada
	return [r, fin[2]]


func _vuelta_perfecta() -> void:
	var h := await _poner_en_parrilla("Hamburguesa2", Vector3(0.0, 0, 0.1))
	var r := await _terminar_en(h, func(m): return m.centro)
	comprobar(r[0] == R.PERFECTO, "parar en el centro de la zona da perfecto")
	comprobar(h.global_basis.y.y < -0.99, "con perfecto la hamburguesa da la vuelta")
	comprobar(pinzas.sostenido == null and not h.freeze, "tras la animación queda suelta")


func _vuelta_bien() -> void:
	var vueltas := 0
	var intentos := 12
	for i in intentos:
		var h := await _poner_en_parrilla("Hamburguesa3", Vector3(-0.3, 0, -0.1))
		var r := await _terminar_en(h, func(m): return m.centro + m.ancho_bien * 0.25)
		comprobar(r[0] == R.BIEN, "parar cerca de la zona da bien")
		var dada: bool = h.global_basis.y.y < 0.0
		comprobar(dada == r[1], "cae del lado que dice la tirada")
		if dada:
			vueltas += 1
	comprobar(vueltas > 0 and vueltas < intentos, "con bien unas veces cae del lado bueno y otras no (%d de %d)" % [vueltas, intentos])


func _vuelta_mal() -> void:
	var h := await _poner_en_parrilla("Hamburguesa1", Vector3(0.0, 0, 0.1))
	var r := await _terminar_en(h, func(m): return 0.0 if m.centro > 0.5 else 1.0)
	comprobar(r[0] == R.MAL, "parar lejos de la zona da mal")
	var horizontal := Vector2(h.linear_velocity.x, h.linear_velocity.z).length()
	comprobar(horizontal > 1.5, "con mal sale despedida (%.1f m/s)" % horizontal)
	await _esperar_fisica(2.0)
	comprobar(h.global_position.y < 0.3, "con mal acaba en el suelo (y = %.2f)" % h.global_position.y)


func _esperar_fisica(segundos: float) -> void:
	for i in int(segundos * Engine.physics_ticks_per_second):
		await physics_frame
