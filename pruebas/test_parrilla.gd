extends PruebaBase
## Integración: una hamburguesa del patio de prueba sobre la zona caliente de
## la parrilla se cocina por la cara de abajo; al darle la vuelta, cambia la cara.

const C := EstadoCoccion.Cara


func _ejecutar() -> void:
	change_scene_to_file("res://escenas/patio_prueba.tscn")
	await process_frame
	await process_frame
	var escena := current_scene
	# Sin tipos de clase propios: este script se compila antes de que existan
	# los autoloads de Cogito, y CoccionComponente depende de clases que los usan.
	var rejilla: Node3D = escena.get_node("Parrilla/RejillaCalor")
	var hamburguesa := escena.get_node("Hamburguesa1") as RigidBody3D
	var coccion: Node = hamburguesa.get_node("Coccion")
	comprobar(rejilla != null and coccion != null, "la escena tiene rejilla y hamburguesa con cocción")
	await _esperar_fisica(1.0)
	for nombre in ["Hamburguesa1", "Hamburguesa2", "Hamburguesa3"]:
		var h := escena.get_node(nombre) as Node3D
		comprobar(h.global_basis.y.y > 0.95 and h.global_position.y > 0.78, "%s empieza plana sobre la mesa" % nombre)

	# Ponerla sobre la zona directa, un pelo por encima de la rejilla.
	hamburguesa.global_position = rejilla.to_global(Vector3(-0.6, 0.03, 0))
	hamburguesa.linear_velocity = Vector3.ZERO
	await _esperar_fisica(2.0)
	comprobar(coccion.cara_apoyada == C.ABAJO, "apoyada en la rejilla, la cara de abajo toca (cara %d)" % coccion.cara_apoyada)
	comprobar(coccion.temperatura_contacto > 200.0, "en la zona directa la rejilla pasa de 200 °C (%.0f)" % coccion.temperatura_contacto)
	comprobar(coccion.estado.temperatura_superficie[C.ABAJO] > 150.0, "la cara de abajo se calienta (%.0f °C)" % coccion.estado.temperatura_superficie[C.ABAJO])
	comprobar(hamburguesa.global_position.y > rejilla.global_position.y, "la hamburguesa no atraviesa la rejilla")

	Voltear.voltear(hamburguesa, Vector3.RIGHT)
	await _esperar_fisica(1.5)
	comprobar(coccion.cara_apoyada == C.ARRIBA, "tras dar la vuelta, toca la que era la cara de arriba (cara %d)" % coccion.cara_apoyada)

	# Fuera de la parrilla deja de cocinarse.
	hamburguesa.global_position = Vector3(0, 0.3, 4)
	await _esperar_fisica(1.0)
	comprobar(coccion.cara_apoyada == -1, "en el suelo no toca ninguna rejilla")


func _esperar_fisica(segundos: float) -> void:
	for i in int(segundos * Engine.physics_ticks_per_second):
		await physics_frame
