extends PruebaBase
## Lógica de cocción por caras (EstadoCoccion) y rejilla de calor (RejillaCalor).

const C := EstadoCoccion.Cara
const PASO := 1.0 / 60.0


func _ejecutar() -> void:
	_cara_apoyada_se_hace_y_la_otra_no()
	_dar_la_vuelta_hace_la_otra_cara()
	_sin_vigilar_se_quema()
	_en_reposo_el_interior_sigue_subiendo()
	_a_temperatura_baja_no_se_dora()
	_rejilla_dos_zonas()


func _hamburguesa() -> EstadoCoccion:
	return EstadoCoccion.new(load("res://datos/alimentos/hamburguesa.tres"))


func _cocinar(e: EstadoCoccion, segundos: float, cara: int, t: float) -> void:
	for i in int(segundos / PASO):
		e.avanzar(PASO, cara, t, 20.0)


func _cara_apoyada_se_hace_y_la_otra_no() -> void:
	var e := _hamburguesa()
	_cocinar(e, 45.0, C.ABAJO, 240.0)
	comprobar(e.grado[C.ABAJO] >= 1.5 and e.grado[C.ABAJO] < 3.0, "45 s a 240 °C: la cara de abajo debería estar sellada o dorada (grado %.2f)" % e.grado[C.ABAJO])
	comprobar(e.grado[C.ARRIBA] < 0.05, "la cara de arriba no debería cocinarse (grado %.2f)" % e.grado[C.ARRIBA])
	comprobar(e.temperatura_interna > 20.0, "el interior debería calentarse (%.1f °C)" % e.temperatura_interna)
	comprobar(e.punto_interior() != "hecho", "con una sola cara 45 s el interior no puede estar hecho")


func _dar_la_vuelta_hace_la_otra_cara() -> void:
	var e := _hamburguesa()
	for vuelta in 3:
		_cocinar(e, 40.0, C.ABAJO, 240.0)
		_cocinar(e, 40.0, C.ARRIBA, 240.0)
	comprobar(e.estado_cara(C.ARRIBA) != "crudo" and e.estado_cara(C.ABAJO) != "crudo", "dando vueltas se hacen las dos caras")
	comprobar(absf(e.grado[C.ARRIBA] - e.grado[C.ABAJO]) < 0.5, "dando vueltas por igual, las dos caras quedan parecidas")
	comprobar(e.temperatura_interna >= 52.0, "tras 4 min con vueltas el interior debería estar al menos poco hecho (%.1f °C)" % e.temperatura_interna)


func _sin_vigilar_se_quema() -> void:
	var e := _hamburguesa()
	_cocinar(e, 150.0, C.ABAJO, 240.0)
	comprobar(e.estado_cara(C.ABAJO) == "quemado", "150 s sin dar la vuelta debería quemarse (grado %.2f)" % e.grado[C.ABAJO])


func _en_reposo_el_interior_sigue_subiendo() -> void:
	var e := _hamburguesa()
	_cocinar(e, 60.0, C.ABAJO, 240.0)
	_cocinar(e, 60.0, C.ARRIBA, 240.0)
	var al_retirar := e.temperatura_interna
	_cocinar(e, 10.0, -1, 20.0)
	comprobar(e.temperatura_interna > al_retirar, "en reposo el interior sigue subiendo un poco (%.1f → %.1f °C)" % [al_retirar, e.temperatura_interna])


func _a_temperatura_baja_no_se_dora() -> void:
	var e := _hamburguesa()
	_cocinar(e, 60.0, C.ABAJO, 90.0)
	comprobar(e.grado[C.ABAJO] == 0.0, "por debajo de la temperatura de dorado no se dora")


func _rejilla_dos_zonas() -> void:
	var r := RejillaCalor.new()
	r.inercia = 0.0
	root.add_child(r)
	var izquierda := r.temperatura_en(Vector3(-0.7, 0, 0))
	var derecha := r.temperatura_en(Vector3(0.7, 0, 0))
	comprobar(izquierda > 200.0, "la zona directa (izquierda) debería pasar de 200 °C (%.0f)" % izquierda)
	comprobar(derecha < 120.0, "la zona indirecta (derecha) debería ser suave (%.0f)" % derecha)
	comprobar(r.temperatura_en(Vector3(2, 0, 0)) == r.temperatura_ambiente, "fuera de la rejilla hace la temperatura del aire")
	comprobar(r.esta_sobre(Vector3(0, 0.02, 0), 0.05), "un punto 2 cm sobre la rejilla está apoyado")
	comprobar(not r.esta_sobre(Vector3(0, 0.3, 0), 0.05), "un punto 30 cm por encima no está apoyado")
	r.altura = 0.3
	r._physics_process(0.016)
	comprobar(r.temperatura_en(Vector3(-0.7, 0, 0)) < izquierda, "subir la rejilla baja la temperatura")
	r.queue_free()
