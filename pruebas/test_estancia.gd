extends PruebaBase
## Estancia del abuelo: empieza en ruinas con los ahorros del abuelo; las
## reformas cuestan dinero y piden las anteriores; al pagar se reconstruye su
## zona y se quita el cartel; la conservadora cobra la carne; la bandeja vende
## la comida hecha y rechaza la cruda y la sucia; todo se guarda.

const RUTA := "user://prueba_estancia.cfg"


func _ejecutar() -> void:
	# Sin tipos propios: los autoloads no existen al compilar este script.
	var h: Node = root.get_node("Herencia")
	h.ruta_guardado = RUTA
	h.reiniciar()
	change_scene_to_file("res://escenas/estancia/estancia.tscn")
	await process_frame
	await process_frame
	var escena := current_scene
	var estancia: Node3D = escena.get_node("Estancia")

	# Empieza todo en ruinas, con un cartel por reforma y 2.000 $.
	comprobar(h.dinero == 2000, "se empieza con los 2.000 $ del abuelo (%d)" % h.dinero)
	comprobar(h.hechas.is_empty(), "no hay ninguna reforma hecha")
	var ids: Array = estancia.ZONAS
	comprobar(ids.size() == 8, "hay 8 zonas que reformar")
	for id in ids:
		comprobar(estancia.zona(id) != null, "existe la zona %s" % id)
		comprobar(estancia.zona(id).has_node("Cartel"), "la zona %s tiene su cartel de obra" % id)
		comprobar(h.reforma(id) != null, "la reforma %s tiene datos" % id)
	comprobar(escena.get_node("Parrilla/RejillaCalor") != null, "la parrilla del abuelo funciona aunque el quincho esté en ruinas")
	comprobar(h.formatear(1234567) == "$ 1.234.567", "los pesos llevan punto de miles (%s)" % h.formatear(1234567))

	# No llega el dinero y falta lo de antes.
	comprobar(not h.reformar(&"desbroce"), "con 2.000 $ no llega para desbrozar (3.000 $)")
	comprobar(h.dinero == 2000, "si no se paga, no se cobra nada")
	h.ganar(20000)
	comprobar(not h.reformar(&"quincho"), "el quincho pide desbrozar antes")
	comprobar(h.motivo(&"quincho") != "", "el cartel explica por qué no se puede")

	# Desbrozar: se cobra, se guarda y la zona se rehace sin cartel.
	var zona_antes: Node3D = estancia.zona(&"desbroce")
	var hijos_antes := zona_antes.get_child_count()
	comprobar(h.reformar(&"desbroce"), "con 22.000 $ se puede desbrozar")
	comprobar(h.dinero == 19000, "desbrozar cuesta 3.000 $ (%d)" % h.dinero)
	await process_frame
	comprobar(not estancia.zona(&"desbroce").has_node("Cartel"), "la zona desbrozada ya no tiene cartel")
	comprobar(estancia.zona(&"desbroce").get_child_count() < hijos_antes, "sin maleza ni basura la zona tiene menos cosas")
	comprobar(not h.reformar(&"desbroce"), "no se puede pagar dos veces la misma reforma")
	comprobar(h.reformar(&"quincho"), "después de desbrozar ya se puede arreglar el quincho")
	await process_frame
	comprobar(not estancia.zona(&"quincho").has_node("Cartel"), "el quincho reformado no tiene cartel")

	# Guardar y cargar.
	h.cargar()
	comprobar(h.hecha(&"desbroce") and h.hecha(&"quincho"), "las reformas se guardan")
	comprobar(h.dinero == 7000, "el dinero se guarda (%d)" % h.dinero)

	# Conservadora: cobra la carne y la pone encima.
	var conservadora: Node = escena.get_node("Conservadora")
	var pieza: RigidBody3D = null
	if h.gastar(400):
		pieza = conservadora.comprar()
	comprobar(h.dinero == 6600, "la hamburguesa cuesta 400 $ (%d)" % h.dinero)
	comprobar(pieza != null and pieza.has_node("Coccion"), "la conservadora saca una hamburguesa cruda")
	h.dinero = 100
	conservadora.interact()
	comprobar(h.dinero == 100, "sin dinero no se compra carne")

	# Bandeja: cruda no se vende; al punto sí; sucia no.
	await physics_frame
	var bandeja: Node = escena.get_node("BandejaVenta")
	var cruda := escena.get_node("Hamburguesa1") as RigidBody3D
	comprobar(bandeja.precio(cruda) == 0, "una hamburguesa cruda no vale nada")
	var hecha := escena.get_node("Hamburguesa2") as RigidBody3D
	var estado = hecha.get_node("Coccion").estado
	estado.temperatura_interna = 62.0
	estado.grado[0] = 2.0
	estado.grado[1] = 2.0
	var p: int = bandeja.precio(hecha)
	comprobar(p == 1500, "al punto y dorada por las dos caras vale 1.500 $ (%d)" % p)
	estado.grado[1] = 4.2
	comprobar(bandeja.precio(hecha) < p, "quemada por debajo vale menos")
	estado.grado[1] = 2.0
	var dinero_antes: int = h.dinero
	bandeja.intentar_vender(hecha)
	comprobar(h.dinero == dinero_antes + 1500, "venderla suma 1.500 $ (%d)" % (h.dinero - dinero_antes))
	await process_frame
	comprobar(not is_instance_valid(hecha), "la hamburguesa vendida desaparece")
	var sucia := escena.get_node("Hamburguesa3") as RigidBody3D
	var e3 = sucia.get_node("Coccion").estado
	e3.temperatura_interna = 62.0
	sucia.get_node("Suciedad").sucia = true
	dinero_antes = h.dinero
	bandeja.intentar_vender(sucia)
	comprobar(h.dinero == dinero_antes and is_instance_valid(sucia), "la sucia no se vende y se queda")

	# La venta de verdad: dejarla en la bandeja un rato.
	e3 = cruda.get_node("Coccion").estado
	e3.temperatura_interna = 62.0
	e3.grado[0] = 2.0
	e3.grado[1] = 2.0
	cruda.global_position = bandeja.global_position + Vector3(0, 0.08, 0)
	cruda.linear_velocity = Vector3.ZERO
	dinero_antes = h.dinero
	for i in 90:
		await physics_frame
	comprobar(h.dinero > dinero_antes, "dejar una hamburguesa hecha en la bandeja la vende sola")

	h.reiniciar()
	DirAccess.remove_absolute(ProjectSettings.globalize_path(RUTA))
	h.ruta_guardado = h.RUTA_GUARDADO
	h.cargar()
