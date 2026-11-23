extends PruebaBase
## Pinzas: se cuelgan de la cámara, cogen la hamburguesa a la que se apunta,
## la llevan en la punta, y el minijuego de dar la vuelta aplica su resultado.

const R := MinijuegoVuelta.Resultado

var pinzas: Node3D
var camara: Camera3D


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
	comprobar(pinzas.get_parent() == camara, "las pinzas van colgadas de la cámara del jugador")
	comprobar(pinzas.get_node_or_null("Modelo/Pinzas/BrazoArriba") != null, "el modelo de Blender tiene los dos brazos")
	comprobar(not current_scene.get_node("Hamburguesa1").has_node("Voltear"), "ya no se puede dar la vuelta con F")

	await _coger_y_soltar()
	await _flujo_con_clics()
	await _vuelta_perfecta()
	await _vuelta_bien()
	await _vuelta_mal()


func _poner_delante(nombre: String) -> RigidBody3D:
	var h := current_scene.get_node(nombre) as RigidBody3D
	h.freeze = true
	h.global_position = camara.global_position - camara.global_basis.z * 0.9
	h.global_basis = Basis()
	await _esperar_fisica(0.1)
	return h


func _coger_y_soltar() -> void:
	var h := await _poner_delante("Hamburguesa2")
	comprobar(pinzas.alimento_apuntado() == h, "la mira detecta la hamburguesa")
	Input.action_press("action_primary")  # mantener el clic = apretar las pinzas
	comprobar(pinzas.intentar_coger(), "las pinzas cogen la hamburguesa")
	comprobar(pinzas.sostenido == h, "la hamburguesa queda sostenida")
	await _esperar_fisica(0.5)
	var distancia := h.global_position.distance_to(pinzas.get_node("Punta").global_position)
	comprobar(distancia < 0.03, "la hamburguesa sigue a la punta de las pinzas (a %.3f m)" % distancia)
	comprobar(pinzas.sostenido == h, "mientras se mantiene el clic, sigue cogida")
	var altura := h.global_position.y
	Input.action_release("action_primary")
	await _esperar_fisica(0.05)
	comprobar(pinzas.sostenido == null and not h.freeze, "al soltar el clic se suelta y vuelve a tener física")
	comprobar(h.collision_layer != 0, "al soltarla recupera su capa de colisión")
	comprobar(h.global_basis.y.y > 0.99, "soltar sin minijuego no le da la vuelta")
	await _esperar_fisica(0.3)
	comprobar(h.global_position.y < altura, "al soltarla cae")


## Todo con clics simulados: mantener izquierdo, clic derecho, soltar izquierdo.
func _flujo_con_clics() -> void:
	var h := await _poner_delante("Hamburguesa2")
	Input.action_press("action_primary")
	await physics_frame
	await physics_frame
	comprobar(pinzas.sostenido == h, "mantener el clic izquierdo apuntando la coge")
	Input.action_release("action_primary")
	Input.action_press("action_primary")  # sigue apretado (sin perder el estado)
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
	comprobar(pinzas.sostenido == null and pinzas.minijuego == null, "soltar el clic izquierdo para la línea y suelta")
	comprobar(h.global_basis.y.y < -0.99, "parada en la zona perfecta, da la vuelta")
	await _esperar_fisica(0.5)


func _terminar_en(h: RigidBody3D, donde: Callable) -> int:
	Input.action_release("action_primary")
	pinzas.coger(h)
	pinzas.abrir_minijuego()
	comprobar(pinzas.minijuego != null, "el clic derecho abre el minijuego")
	pinzas.minijuego.posicion = donde.call(pinzas.minijuego)
	return pinzas.terminar_minijuego()


func _vuelta_perfecta() -> void:
	var h := await _poner_delante("Hamburguesa2")
	var resultado := _terminar_en(h, func(m): return m.centro)
	comprobar(resultado == R.PERFECTO, "parar en el centro de la zona da perfecto")
	comprobar(h.global_basis.y.y < -0.99, "con perfecto la hamburguesa da la vuelta")
	comprobar(pinzas.sostenido == null and pinzas.minijuego == null, "tras el minijuego las pinzas quedan libres")
	await _esperar_fisica(1.0)


func _vuelta_bien() -> void:
	# Con "bien" a veces cae del lado bueno y a veces no: probar varias veces.
	var vueltas := 0
	var intentos := 12
	for i in intentos:
		var h := await _poner_delante("Hamburguesa3")
		var resultado := _terminar_en(h, func(m): return m.centro + m.ancho_bien * 0.25)
		comprobar(resultado == R.BIEN, "parar cerca de la zona da bien")
		comprobar(pinzas.sostenido == null, "con bien se cae de las pinzas")
		if h.global_basis.y.y < 0.0:
			vueltas += 1
	comprobar(vueltas > 0 and vueltas < intentos, "con bien unas veces cae del lado bueno y otras no (%d de %d)" % [vueltas, intentos])


func _vuelta_mal() -> void:
	var h := await _poner_delante("Hamburguesa1")
	var resultado := _terminar_en(h, func(m): return 0.0 if m.centro > 0.5 else 1.0)
	comprobar(resultado == R.MAL, "parar lejos de la zona da mal")
	var horizontal := Vector2(h.linear_velocity.x, h.linear_velocity.z).length()
	comprobar(horizontal > 1.5, "con mal sale despedida (%.1f m/s)" % horizontal)
	await _esperar_fisica(2.0)
	comprobar(h.global_position.y < 0.3, "con mal acaba en el suelo (y = %.2f)" % h.global_position.y)


func _esperar_fisica(segundos: float) -> void:
	for i in int(segundos * Engine.physics_ticks_per_second):
		await physics_frame
