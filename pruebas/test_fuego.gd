extends PruebaBase
## Fuego: brasas vivas de la rejilla (carbón, fuego, propagación, abanico) y
## el encendido con la chimenea en el patio de prueba.


func _ejecutar() -> void:
	_rejilla_fria()
	_echar_carbon()
	_propagacion_y_reposo()
	_avivar()
	_carbon_crudo_enfria()
	_se_consume()
	await _patio_chimenea_y_abanico()


func _nueva_rejilla() -> RejillaCalor:
	var r := RejillaCalor.new()
	r.empezar_encendida = false
	r.inercia = 0.0
	root.add_child(r)
	return r


func _simular(r: RejillaCalor, segundos: float, paso := 0.1) -> void:
	for i in int(segundos / paso):
		r._physics_process(paso)


func _rejilla_fria() -> void:
	var r := _nueva_rejilla()
	comprobar(r.carbon_total() == 0.0, "sin encender no hay carbón")
	comprobar(r.temperatura_en(Vector3(-0.5, 0, 0)) == r.temperatura_ambiente, "sin brasas la rejilla está a la temperatura del aire")
	r.queue_free()


func _echar_carbon() -> void:
	var r := _nueva_rejilla()
	var cabido := r.echar_carbon(Vector3(-0.5, 0, 0), 4.0, 1.0)
	comprobar(absf(cabido - 4.0) < 0.01, "cabe todo el carbón echado (%.2f)" % cabido)
	comprobar(absf(r.carbon_total() - 4.0) < 0.01, "el carbón total es el echado (%.2f)" % r.carbon_total())
	r._physics_process(0.016)
	var caliente := r.temperatura_en(Vector3(-0.5, 0, 0))
	comprobar(caliente > 150.0, "donde caen las brasas la rejilla se calienta (%.0f °C)" % caliente)
	comprobar(r.temperatura_en(Vector3(0.7, 0, 0)) < 40.0, "lejos de las brasas sigue fría")
	var mucho := r.echar_carbon(Vector3(-0.5, 0, 0), 50.0, 1.0)
	var maximo := 0.0
	for c in r.carbon:
		maximo = maxf(maximo, c)
	comprobar(maximo <= 1.0 and mucho < 50.0, "una celda no pasa de llena (máx. %.2f)" % maximo)
	r.queue_free()


func _propagacion_y_reposo() -> void:
	var r := _nueva_rejilla()
	r.poner_brasas(0, 0, 1.0, 1.0)
	r.poner_brasas(1, 0, 1.0, 0.0)
	r.poner_brasas(3, 0, 1.0, 0.0)
	_simular(r, 60.0)
	comprobar(r.fuego[1] > 0.3, "el fuego pasa a la celda vecina con carbón (%.2f)" % r.fuego[1])
	comprobar(r.fuego[3] < 0.2, "a una celda lejana todavía no llega (%.2f)" % r.fuego[3])
	_simular(r, 300.0)
	comprobar(r.fuego[0] < 0.85 and r.fuego[0] >= r.fuego_reposo - 0.01, "sin avivar baja hacia el reposo (%.2f)" % r.fuego[0])
	r.queue_free()


func _avivar() -> void:
	var r := _nueva_rejilla()
	r.poner_brasas(1, 1, 1.0, 0.7)
	r.poner_brasas(6, 1, 1.0, 0.0)
	var centro := Vector3(-0.5, 0, -0.1)
	var antes := r.temperatura_en(centro)
	for i in 30:
		r.avivar(centro, 0.1)
		r._physics_process(0.1)
	comprobar(r.fuego[9] > 0.9, "abanicar sube el fuego (%.2f)" % r.fuego[9])
	comprobar(r.temperatura_en(centro) > antes, "y la temperatura")
	r.avivar(Vector3(0.5, 0, -0.1), 3.0)
	comprobar(r.fuego[14] == 0.0, "abanicar carbón sin fuego al lado no lo enciende")
	r.queue_free()


func _carbon_crudo_enfria() -> void:
	var r := _nueva_rejilla()
	r.poner_brasas(2, 2, 0.5, 1.0)
	r.echar_carbon(Vector3(-0.3, 0, 0.1), 0.5, 0.0, 0.05)
	var i := 2 * 8 + 2
	comprobar(r.fuego[i] < 0.6 and r.carbon[i] > 0.9, "echar carbón crudo sobre brasas las enfría (fuego %.2f)" % r.fuego[i])
	r.queue_free()


func _se_consume() -> void:
	var r := _nueva_rejilla()
	r.vida_media_carbon = 5.0
	r.poner_brasas(0, 0, 1.0, 1.0)
	_simular(r, 10.0)
	comprobar(r.carbon[0] < 0.5 and r.carbon[0] > 0.0, "el carbón se gasta mientras arde (%.2f)" % r.carbon[0])
	_simular(r, 120.0)
	comprobar(r.carbon[0] == 0.0 and r.fuego[0] == 0.0, "al acabarse el carbón se apaga")
	comprobar(r.temperatura_celda(0, 0) == r.temperatura_ambiente, "y la rejilla vuelve a la temperatura del aire")
	r.queue_free()


func _patio_chimenea_y_abanico() -> void:
	change_scene_to_file("res://escenas/patio_prueba.tscn")
	await process_frame
	await process_frame
	# Sin tipos propios: Cogito aún no ha cargado sus autoloads al compilar esto.
	var rejilla: Node3D = current_scene.get_node("Parrilla/RejillaCalor")
	var chimenea := current_scene.get_node("ChimeneaEncendido") as RigidBody3D
	var saco: Node3D = current_scene.get_node("SacoCarbon")
	var abanico := current_scene.get_node("Abanico") as RigidBody3D
	comprobar(rejilla.carbon_total() == 0.0, "el patio empieza con la parrilla fría y sin carbón")
	comprobar(chimenea.estado == 0, "la chimenea empieza vacía")

	chimenea.usar()
	comprobar(chimenea.estado == 1, "F en la chimenea junto al saco la llena")
	chimenea.segundos_prender = 0.5
	chimenea.usar()
	comprobar(chimenea.estado == 2, "F en la chimenea llena la enciende")
	await _esperar_fisica(1.0)
	comprobar(chimenea.estado == 3, "al rato el carbón está al rojo")

	chimenea.usar()
	comprobar(chimenea.estado == 3 and rejilla.carbon_total() == 0.0, "lejos de la parrilla no vuelca")

	chimenea.freeze = true
	var punto: Vector3 = rejilla.to_global(Vector3(-0.4, 0.3, 0))
	chimenea.global_position = punto
	chimenea.usar()
	comprobar(chimenea.estado == 0, "sobre la parrilla vuelca y queda vacía")
	comprobar(rejilla.carbon_total() > 5.0, "las brasas caen en la rejilla (%.1f)" % rejilla.carbon_total())
	await _esperar_fisica(12.0)
	var t: float = rejilla.temperatura_en(punto)
	comprobar(t > 150.0, "la rejilla se calienta donde se volcó (%.0f °C)" % t)
	comprobar(rejilla.temperatura_en(rejilla.to_global(Vector3(0.75, 0, 0.35))) < 60.0, "la otra punta sigue fría: zona indirecta")

	chimenea.global_position = saco.global_position + Vector3(0.5, 0, 0)
	saco.interact(null)
	comprobar(chimenea.estado == 1, "F en el saco llena la chimenea vacía de al lado")

	# Abanico: las brasas en reposo suben al abanicarlas.
	var c: Vector2i = rejilla.celda_en(punto)
	rejilla.poner_brasas(c.x, c.y, 1.0, 0.7)
	abanico.freeze = true
	abanico.global_position = punto
	for i in 20:
		abanico.abanicar(0.1)
	var fuego: float = rejilla.fuego[c.y * 8 + c.x]
	comprobar(fuego > 0.9, "abanicar sobre la parrilla aviva las brasas (%.2f)" % fuego)


func _esperar_fisica(segundos: float) -> void:
	for i in int(segundos * Engine.physics_ticks_per_second):
		await physics_frame
