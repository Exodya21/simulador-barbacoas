@tool
class_name Estancia
extends Node3D
## "El fogón de los sueños": la estancia criolla que te deja el abuelo.
##
## Se levanta entera desde código con formas low-poly (scripts/estancia/geo.gd).
## Cada reforma (datos/estancia/*.tres) es una zona hija con dos versiones,
## en ruinas y reformada; al pagar una reforma (autoload Herencia) solo se
## reconstruye esa zona. Lo que no se reforma (cerco, álamos, ombú, cerros)
## es fijo.
##
## Plano (metros; norte = -Z; se entra por el sur, por el camino de álamos):
##   casa criolla (-20, -15) · bodegón (0, -15) · quincho y parrilla (21, -15)
##   mesa para 30 (21, -3) · ombú (-18, 7) · aljibe (6, 9) · limonero (24, 11)
##   tranquera (0, 24) · camino de álamos de z = 24 a z = 56.

const ZONAS: Array[StringName] = [&"desbroce", &"tranquera", &"quincho", &"mesa", &"aljibe", &"jardin", &"bodegon", &"casa"]
const ESCENA_CARTEL := "res://escenas/estancia/cartel_reforma.tscn"
## Altura del centro de la tabla del cartel (su origen).
const ALTO_CARTEL := 1.25

## Mitad del terreno cercado: X de -36 a 36 y Z de -24 a 24.
const MITAD := Vector2(36, 24)
const CASA := Vector3(-20, 0, -15)
const BODEGON := Vector3(0, 0, -15)
const QUINCHO := Vector3(21, 0, -15)
const MESA := Vector3(21, 0, -3)
const ALJIBE := Vector3(6, 0, 9)
const OMBU := Vector3(-18, 0, 7)
const LIMONERO := Vector3(24, 0, 11)
const TRANQUERA_Z := 24.0
const CAMINO_FIN_Z := 56.0

## Dónde va el cartel de obra de cada reforma: posición del pie y giro (grados).
const CARTELES := {
	&"desbroce": [Vector3(-3.6, 0, 19.5), 15.0],
	&"tranquera": [Vector3(3.9, 0, 27.5), 0.0],
	&"quincho": [Vector3(25.0, 0, -8.4), 0.0],
	&"mesa": [Vector3(21.0, 0, 2.4), 0.0],
	&"aljibe": [Vector3(8.4, 0, 10.6), -10.0],
	&"jardin": [Vector3(-2.6, 0, 10.5), 10.0],
	&"bodegon": [Vector3(3.6, 0, -8.4), 0.0],
	&"casa": [Vector3(-20.0, 0, -5.6), 0.0],
}

# Colores propios del escenario (los de la paleta van en Paleta).
const C_PASTO := Color("5f9440")
const C_PASTO_SECO := Color("8a8550")
const C_CAMPO := Color("6f9a48")
const C_TIERRA := Color("b08a5e")
const C_CAL := Color("f1ebdf")
const C_CAL_SUCIA := Color("cbbfa8")
const C_MANCHA := Color("8f8a70")
const C_ZOCALO := Color("8e8577")
const C_TEJA := Color("b3472f")
const C_TEJA_VIEJA := Color("7a4a3c")
const C_TEJA_OSCURA := Color("6b3a2a")
const C_MADERA_OSCURA := Color("5e3b25")
const C_MADERA_VIEJA := Color("6e6152")
const C_LADRILLO_VIEJO := Color("8a4a3a")
const C_BALDOSA := Color("b86b4b")
const C_BALDOSA_SUCIA := Color("85614f")
const C_GALERIA := Color("cdb898")
const C_PAJA := Color("c9a24e")
const C_PAJA_VIEJA := Color("8c7b58")
const C_HIERRO := Color("2d2d30")
const C_OXIDO := Color("6b3d26")
const C_PIEDRA := Color("cfc6b4")
const C_ESCOMBRO := Color("8c8378")
const C_POSTIGO := Color("3f7a4c")
const C_HUECO := Color("1d1a18")
const C_HOJA := Color("3f6e2f")
const C_HOJA_OSCURA := Color("2f5424")
const C_ALAMO := Color("355f27")
const C_SECO := Color("7d6a45")
const C_LAVANDA := Color("8e6bb8")
const C_LIMON := Color("e8d23a")
const C_SANTA_RITA := Color("d6336f")
const C_HAMACA := Color("c0392b")
const C_LUZ := Color("ffd27a")
const C_CERRO := Color("587f3c")

## Ver en el editor la estancia reformada en vez de en ruinas.
@export var vista_editor_reformada := false:
	set(valor):
		vista_editor_reformada = valor
		if is_inside_tree() and Engine.is_editor_hint():
			construir()

var _zonas := {}
var _luces_fuego: Array[OmniLight3D] = []
var _tiempo := 0.0


func _ready() -> void:
	construir()
	if Engine.is_editor_hint():
		return
	var h := _herencia()
	if h:
		h.reforma_hecha.connect(_al_reformar)


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	_tiempo += delta
	for luz in _luces_fuego:
		if is_instance_valid(luz):
			var base: float = luz.get_meta("energia")
			luz.light_energy = base * (0.8 + 0.12 * sin(_tiempo * 13.0 + luz.position.x) + 0.08 * sin(_tiempo * 29.0))


func _herencia() -> Node:
	return get_node_or_null("/root/Herencia")


## Levanta toda la estancia desde cero.
func construir() -> void:
	for hijo in get_children():
		remove_child(hijo)
		hijo.queue_free()
	_zonas.clear()
	_luces_fuego.clear()
	var fijo := Node3D.new()
	fijo.name = "Fijo"
	add_child(fijo)
	_construir_fijo(fijo)
	for id in ZONAS:
		var zona := Node3D.new()
		zona.name = String(id).capitalize()
		add_child(zona)
		_zonas[id] = zona
		construir_zona(id)


func zona(id: StringName) -> Node3D:
	return _zonas.get(id)


func esta_hecha(id: StringName) -> bool:
	if Engine.is_editor_hint():
		return vista_editor_reformada
	var h := _herencia()
	return h != null and h.hecha(id)


## Vuelve a levantar una zona según esté reformada o no.
func construir_zona(id: StringName) -> void:
	var z: Node3D = _zonas[id]
	for hijo in z.get_children():
		z.remove_child(hijo)
		hijo.queue_free()
	var hecha := esta_hecha(id)
	call("_zona_" + String(id), z, hecha)
	if not hecha and not Engine.is_editor_hint() and CARTELES.has(id):
		_poner_cartel(z, id)


func _al_reformar(id: StringName) -> void:
	if _zonas.has(id):
		construir_zona(id)


func _poner_cartel(z: Node3D, id: StringName) -> void:
	var escena := load(ESCENA_CARTEL) as PackedScene
	var cartel := escena.instantiate()
	cartel.set("reforma_id", id)
	cartel.name = "Cartel"
	var datos: Array = CARTELES[id]
	cartel.position = datos[0] + Vector3(0, ALTO_CARTEL, 0)
	cartel.rotation_degrees.y = datos[1]
	z.add_child(cartel)


# --- Ayudantes cortos ----------------------------------------------------------

func _caja(p: Node3D, tam: Vector3, pos: Vector3, c: Color, rot := Vector3.ZERO, solida := true) -> MeshInstance3D:
	return Geo.caja(p, tam, pos, c, rot, solida)


func _poste(p: Node3D, pos: Vector3, alto: float, radio: float, c: Color, solida := true) -> MeshInstance3D:
	return Geo.cilindro(p, radio, radio * 0.9, alto, pos + Vector3(0, alto * 0.5, 0), c, 7, Vector3.ZERO, solida)


func _letrero(p: Node3D, texto: String, pos: Vector3, rot_y: float, tam: int, c: Color) -> Label3D:
	var l := Label3D.new()
	l.text = texto
	l.font_size = tam
	l.pixel_size = 0.004
	l.modulate = c
	l.outline_size = 0
	l.double_sided = false
	l.position = pos
	l.rotation_degrees.y = rot_y
	p.add_child(l)
	return l


func _luz(p: Node3D, pos: Vector3, energia: float, alcance: float, color := C_LUZ, parpadea := false, sombra := false) -> OmniLight3D:
	var luz := OmniLight3D.new()
	luz.position = pos
	luz.light_color = color
	luz.light_energy = energia
	luz.omni_range = alcance
	luz.shadow_enabled = sombra
	p.add_child(luz)
	if parpadea:
		luz.set_meta("energia", energia)
		_luces_fuego.append(luz)
	return luz


## Bombilla encendida (guirnaldas, farolas).
func _bombilla(p: Node3D, pos: Vector3, radio := 0.05) -> void:
	var sm := SphereMesh.new()
	sm.radius = radio
	sm.height = radio * 2.0
	sm.radial_segments = 6
	sm.rings = 3
	Geo.malla(p, sm, pos, C_LUZ, Vector3.ZERO, Geo.material(C_LUZ, 0.5, 4.0))


## Guirnalda de bombillas colgando entre dos puntos.
func _guirnalda(p: Node3D, a: Vector3, b: Vector3, flecha: float, separacion := 0.6) -> void:
	var tramos := maxi(2, int(a.distance_to(b) / separacion))
	var puntos := Geo.curva_colgante(a, b, flecha, tramos)
	for i in range(puntos.size() - 1):
		Geo.barra(p, puntos[i], puntos[i + 1], 0.015, C_HIERRO)
	for i in range(1, puntos.size() - 1):
		_bombilla(p, puntos[i] + Vector3(0, -0.07, 0))


## Llamas: conos que brillan y una luz que parpadea.
func _fuego(p: Node3D, pos: Vector3, tam := 1.0) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = int(pos.x * 100.0)
	for i in 5:
		var off := Vector3(rng.randf_range(-0.25, 0.25), 0, rng.randf_range(-0.15, 0.15)) * tam
		var alto := rng.randf_range(0.3, 0.6) * tam
		var color := Paleta.BRASA if i % 2 == 0 else Paleta.LLAMA
		var cm := CylinderMesh.new()
		cm.top_radius = 0.0
		cm.bottom_radius = 0.12 * tam
		cm.height = alto
		cm.radial_segments = 5
		cm.rings = 1
		var mi := Geo.malla(p, cm, pos + off + Vector3(0, alto * 0.5, 0), color, Vector3.ZERO, Geo.material(color, 0.6, 3.0))
		mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_luz(p, pos + Vector3(0, 0.6, 0.3), 2.5 * tam, 7.0, Color("ff9a3c"), true, true)


## Humo que sube de una chimenea.
func _humo(p: Node3D, pos: Vector3) -> void:
	var humo := CPUParticles3D.new()
	humo.position = pos
	humo.amount = 26
	humo.lifetime = 7.0
	humo.preprocess = 7.0
	humo.direction = Vector3.UP
	humo.spread = 12.0
	humo.gravity = Vector3(0.25, 0.35, 0)
	humo.initial_velocity_min = 0.4
	humo.initial_velocity_max = 0.7
	humo.scale_amount_min = 0.6
	humo.scale_amount_max = 1.2
	var curva := Curve.new()
	curva.add_point(Vector2(0, 0.4))
	curva.add_point(Vector2(1, 2.6))
	humo.scale_amount_curve = curva
	var rampa := Gradient.new()
	rampa.set_color(0, Color(0.85, 0.82, 0.8, 0.35))
	rampa.set_color(1, Color(0.85, 0.82, 0.8, 0.0))
	humo.color_ramp = rampa
	var quad := QuadMesh.new()
	quad.size = Vector2(1.2, 1.2)
	var bocanada := GradientTexture2D.new()
	bocanada.fill = GradientTexture2D.FILL_RADIAL
	bocanada.fill_from = Vector2(0.5, 0.5)
	bocanada.fill_to = Vector2(0.5, 0.0)
	var degradado := Gradient.new()
	degradado.set_color(0, Color(1, 1, 1, 1))
	degradado.set_color(1, Color(1, 1, 1, 0))
	bocanada.gradient = degradado
	var mat := StandardMaterial3D.new()
	mat.albedo_texture = bocanada
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.billboard_mode = BaseMaterial3D.BILLBOARD_PARTICLES
	mat.vertex_color_use_as_albedo = true
	quad.material = mat
	humo.mesh = quad
	p.add_child(humo)


## Tablones clavados en cruz tapando un hueco (puertas y ventanas en ruinas).
func _tapiado(p: Node3D, centro: Vector3, ancho: float, alto: float, rot_y := 0.0) -> void:
	var base := Node3D.new()
	base.position = centro
	base.rotation_degrees.y = rot_y
	p.add_child(base)
	var largo := sqrt(ancho * ancho + alto * alto)
	var ang := rad_to_deg(atan2(alto, ancho))
	_caja(base, Vector3(largo, 0.16, 0.04), Vector3(0, 0, 0.04), C_MADERA_VIEJA, Vector3(0, 0, ang), false)
	_caja(base, Vector3(largo, 0.16, 0.04), Vector3(0, 0, 0.07), C_MADERA_VIEJA, Vector3(0, 0, -ang), false)
	_caja(base, Vector3(ancho + 0.2, 0.18, 0.04), Vector3(0, alto * 0.3, 0.09), C_MADERA_VIEJA, Vector3(0, 0, 3), false)


## Montón de escombro (cascotes y ladrillos sueltos).
func _escombro(p: Node3D, centro: Vector3, radio: float, semilla: int, color := C_ESCOMBRO) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = semilla
	for i in 7:
		var off := Vector3(rng.randf_range(-radio, radio), 0, rng.randf_range(-radio, radio))
		var r := rng.randf_range(0.2, 0.45) * radio
		Geo.bola(p, r, centro + off + Vector3(0, r * 0.4, 0), color.lerp(C_LADRILLO_VIEJO, rng.randf() * 0.5), Vector3(1, 0.6, 1), 0.3, semilla + i, 5)
	for i in 6:
		var off := Vector3(rng.randf_range(-radio, radio) * 1.4, 0.06, rng.randf_range(-radio, radio) * 1.4)
		_caja(p, Vector3(0.24, 0.07, 0.12), centro + off, C_LADRILLO_VIEJO, Vector3(rng.randf_range(-20, 20), rng.randf() * 180.0, 0), false)


## Árbol genérico de copa redonda.
func _arbol(p: Node3D, pos: Vector3, alto: float, semilla: int, color := C_HOJA, seco := false) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = semilla
	Geo.cilindro(p, 0.22 * alto / 6.0 + 0.1, 0.12, alto * 0.55, pos + Vector3(0, alto * 0.275, 0), C_MADERA_OSCURA, 6)
	var copas := 3 if seco else 4
	for i in copas:
		var off := Vector3(rng.randf_range(-1, 1), rng.randf_range(-0.3, 0.5), rng.randf_range(-1, 1)) * alto * 0.18
		var r := alto * rng.randf_range(0.2, 0.28) * (0.7 if seco else 1.0)
		var c := color.lerp(C_HOJA_OSCURA, rng.randf() * 0.6)
		Geo.bola(p, r, pos + Vector3(0, alto * 0.7, 0) + off, c, Vector3.ONE, 0.22, semilla + i, 7)


## Álamo: alto y fino.
func _alamo(p: Node3D, pos: Vector3, semilla: int) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = semilla
	var alto := rng.randf_range(9.0, 12.0)
	Geo.cilindro(p, 0.2, 0.12, 2.0, pos + Vector3(0, 1.0, 0), C_MADERA_OSCURA, 6)
	Geo.bola(p, 1.0, pos + Vector3(0, alto * 0.55, 0), C_ALAMO.lerp(C_HOJA_OSCURA, rng.randf() * 0.5), Vector3(1.4, alto * 0.42, 1.4), 0.12, semilla, 8)


## Losas de piedra a lo largo de un camino.
func _camino_losas(p: Node3D, puntos: PackedVector3Array, semilla: int) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = semilla
	var transformadas: Array[Transform3D] = []
	var colores: Array[Color] = []
	for i in range(puntos.size() - 1):
		var a := puntos[i]
		var b := puntos[i + 1]
		var dir := (b - a).normalized()
		var giro := atan2(dir.x, dir.z)
		var pasos := int(a.distance_to(b) / 0.75)
		for k in pasos:
			var pos := a.lerp(b, float(k) / pasos)
			for lado: float in [-0.38, 0.38]:
				var lat := Vector3(dir.z, 0, -dir.x) * (lado + rng.randf_range(-0.08, 0.08))
				var bas := Basis(Vector3.UP, giro + rng.randf_range(-0.25, 0.25)).scaled(Vector3(rng.randf_range(0.8, 1.1), 1, rng.randf_range(0.8, 1.1)))
				transformadas.append(Transform3D(bas, pos + lat + Vector3(0, 0.02, 0)))
				colores.append(C_PIEDRA.lerp(C_ESCOMBRO, rng.randf() * 0.4))
	var bm := BoxMesh.new()
	bm.size = Vector3(0.62, 0.05, 0.6)
	Geo.multi(p, bm, transformadas, colores, false)


# --- Lo fijo -----------------------------------------------------------------

func _construir_fijo(p: Node3D) -> void:
	# Suelo: un campo grande con colisión y el camino de tierra.
	_caja(p, Vector3(400, 0.2, 400), Vector3(0, -0.1, 0), C_CAMPO)
	var tierra := PlaneMesh.new()
	tierra.size = Vector2(5.5, CAMINO_FIN_Z - TRANQUERA_Z + 14)
	Geo.malla(p, tierra, Vector3(0, 0.012, (TRANQUERA_Z + CAMINO_FIN_Z + 14) * 0.5 - 7), C_TIERRA)
	_cerco(p)
	# Álamos a los lados del camino y por detrás del terreno.
	var n := 0
	var z := TRANQUERA_Z + 3.0
	while z < CAMINO_FIN_Z + 8:
		_alamo(p, Vector3(-8.0, 0, z), 100 + n)
		_alamo(p, Vector3(8.0, 0, z), 200 + n)
		z += 5.0
		n += 1
	for i in 13:
		_alamo(p, Vector3(-36 + i * 6.0, 0, -MITAD.y - 4.0), 300 + i)
	for i in 8:
		_alamo(p, Vector3(-MITAD.x - 4.0, 0, -21 + i * 6.0), 400 + i)
		_alamo(p, Vector3(MITAD.x + 4.0, 0, -21 + i * 6.0), 500 + i)
	# Monte y cerros a lo lejos.
	var rng := RandomNumberGenerator.new()
	rng.seed = 7
	for i in 40:
		var ang := rng.randf() * TAU
		var dist := rng.randf_range(55.0, 95.0)
		var pos := Vector3(cos(ang) * dist, 0, sin(ang) * dist * 0.8)
		if absf(pos.x) < 14 and pos.z > 20:
			continue
		_arbol(p, pos, rng.randf_range(6.0, 10.0), 600 + i)
	for i in 9:
		var ang := TAU * i / 9.0 + 0.3
		var dist := rng.randf_range(170.0, 190.0)
		Geo.bola(p, rng.randf_range(35.0, 60.0), Vector3(cos(ang) * dist, -8.0, sin(ang) * dist), C_CERRO.lerp(C_HOJA_OSCURA, rng.randf() * 0.5), Vector3(1.8, 0.35, 1.2), 0.08, 700 + i, 10)
	# Pasto de fuera del cerco (dentro lo pone el desbroce).
	Geo.pasto(p, Rect2(-70, -55, 140, 125), 1.6, 0.35, Color("5d8c3c"), Color("8a9a4a"), [Rect2(-3, TRANQUERA_Z, 6, 40)], 11, Rect2(-MITAD.x, -MITAD.y, MITAD.x * 2, MITAD.y * 2))
	_ombu(p)


## Alambrado de postes y alambre alrededor del terreno y del camino, con
## paredes invisibles para que no se salga.
func _cerco(p: Node3D) -> void:
	var tramos: Array = [
		[Vector3(-MITAD.x, 0, -MITAD.y), Vector3(MITAD.x, 0, -MITAD.y)],
		[Vector3(-MITAD.x, 0, -MITAD.y), Vector3(-MITAD.x, 0, MITAD.y)],
		[Vector3(MITAD.x, 0, -MITAD.y), Vector3(MITAD.x, 0, MITAD.y)],
		[Vector3(-MITAD.x, 0, MITAD.y), Vector3(-3.2, 0, MITAD.y)],
		[Vector3(3.2, 0, MITAD.y), Vector3(MITAD.x, 0, MITAD.y)],
		[Vector3(-6, 0, TRANQUERA_Z), Vector3(-6, 0, CAMINO_FIN_Z)],
		[Vector3(6, 0, TRANQUERA_Z), Vector3(6, 0, CAMINO_FIN_Z)],
	]
	var rng := RandomNumberGenerator.new()
	rng.seed = 3
	for tramo in tramos:
		var a: Vector3 = tramo[0]
		var b: Vector3 = tramo[1]
		var postes := maxi(1, int(a.distance_to(b) / 3.0))
		for i in postes + 1:
			var pos := a.lerp(b, float(i) / postes)
			var inclinado := Vector3(rng.randf_range(-4, 4), 0, rng.randf_range(-4, 4))
			Geo.cilindro(p, 0.07, 0.06, 1.4, pos + Vector3(0, 0.7, 0), C_MADERA_VIEJA, 5, inclinado, false)
		for alto in [0.45, 0.8, 1.15]:
			Geo.barra(p, a + Vector3(0, alto, 0), b + Vector3(0, alto, 0), 0.012, C_HIERRO)
		var medio := (a + b) * 0.5 + Vector3(0, 1.5, 0)
		var largo := a.distance_to(b)
		var tam := Vector3(0.3, 3.0, largo) if absf(a.x - b.x) < 0.01 else Vector3(largo, 3.0, 0.3)
		Geo.muro_invisible(p, tam, medio)
	Geo.muro_invisible(p, Vector3(12, 3, 0.3), Vector3(0, 1.5, CAMINO_FIN_Z))


## Ombú: el árbol del abuelo. Siempre en pie, con raíces enormes.
func _ombu(p: Node3D) -> void:
	var o := OMBU
	Geo.cilindro(p, 1.5, 0.9, 3.4, o + Vector3(0, 1.7, 0), Color("6b4a2e"), 9)
	for i in 6:
		var ang := TAU * i / 6.0 + 0.4
		var dir := Vector3(cos(ang), 0, sin(ang))
		var raiz := Geo.caja(p, Vector3(0.5, 0.45, 2.6), o + dir * 1.9 + Vector3(0, 0.12, 0), Color("6b4a2e"), Vector3(0, rad_to_deg(-ang) + 90.0, 0), false)
		raiz.rotate_object_local(Vector3.RIGHT, deg_to_rad(-9))
	for i in 4:
		var ang := TAU * i / 4.0
		var dir := Vector3(cos(ang), 0, sin(ang))
		Geo.barra(p, o + Vector3(0, 3.0, 0), o + dir * 3.2 + Vector3(0, 5.2, 0), 0.45, Color("6b4a2e"))
	var rng := RandomNumberGenerator.new()
	rng.seed = 42
	for i in 8:
		var ang := TAU * i / 8.0
		var dist := 3.0 if i % 2 == 0 else 2.0
		var pos := o + Vector3(cos(ang) * dist, rng.randf_range(5.6, 6.8), sin(ang) * dist)
		Geo.bola(p, rng.randf_range(2.3, 3.0), pos, C_HOJA.lerp(C_HOJA_OSCURA, rng.randf() * 0.7), Vector3(1.2, 0.8, 1.2), 0.2, 50 + i, 8)
	Geo.bola(p, 3.2, o + Vector3(0, 7.4, 0), C_HOJA, Vector3(1.2, 0.7, 1.2), 0.2, 60, 8)


# --- Zonas que se reforman ------------------------------------------------------

## Rectángulos (XZ) sin pasto: los edificios.
func _sin_pasto() -> Array[Rect2]:
	return [
		Rect2(CASA.x - 8.6, CASA.z - 4.8, 17.2, 12.2),
		Rect2(BODEGON.x - 6.4, BODEGON.z - 4.8, 12.8, 9.6),
		Rect2(QUINCHO.x - 6.7, QUINCHO.z - 4.7, 13.4, 9.4),
		Rect2(ALJIBE.x - 1.0, ALJIBE.z - 1.0, 2.0, 2.0),
		Rect2(OMBU.x - 1.6, OMBU.z - 1.6, 3.2, 3.2),
	]


## Desbroce: maleza, pasto seco y basura por todo el terreno, o pasto cortado.
func _zona_desbroce(z: Node3D, hecha: bool) -> void:
	var area := Rect2(-MITAD.x, -MITAD.y, MITAD.x * 2, MITAD.y * 2)
	var suelo := PlaneMesh.new()
	suelo.size = area.size
	Geo.malla(z, suelo, Vector3(0, 0.006, 0), C_PASTO if hecha else C_PASTO_SECO)
	var entrada := PlaneMesh.new()
	entrada.size = Vector2(4.0, 6.0)
	Geo.malla(z, entrada, Vector3(0, 0.014, TRANQUERA_Z - 3.0), C_TIERRA)
	if hecha:
		Geo.pasto(z, area, 9.0, 0.13, Color("5f9a3c"), Color("8fbf55"), _sin_pasto(), 21)
		return
	Geo.pasto(z, area, 7.0, 0.6, Color("7d7f3e"), Color("b3a25c"), _sin_pasto(), 22)
	var rng := RandomNumberGenerator.new()
	rng.seed = 23
	# Matas y cardos.
	var matas: Array[Transform3D] = []
	var colores: Array[Color] = []
	var excluir := _sin_pasto()
	for i in 320:
		var p2 := Vector2(rng.randf_range(-MITAD.x + 1, MITAD.x - 1), rng.randf_range(-MITAD.y + 1, MITAD.y - 1))
		var dentro := false
		for r in excluir:
			if r.has_point(p2):
				dentro = true
				break
		if dentro or (absf(p2.x) < 2.0 and p2.y > 14.0):
			continue
		var esc := rng.randf_range(0.35, 1.0)
		var bas := Basis(Vector3.UP, rng.randf() * TAU).scaled(Vector3(esc, esc * rng.randf_range(0.35, 0.6), esc))
		matas.append(Transform3D(bas, Vector3(p2.x, esc * 0.12, p2.y)))
		colores.append(Color("3e4a22").lerp(Color("5c4a2c"), rng.randf()))
	var sm := SphereMesh.new()
	sm.radius = 0.6
	sm.height = 1.0
	sm.radial_segments = 6
	sm.rings = 3
	Geo.multi(z, Geo.facetar(sm, 0.15, 5), matas, colores)
	# Basura: cubiertas viejas, tablones, un bidón oxidado y escombro.
	for i in 7:
		var tor := TorusMesh.new()
		tor.inner_radius = 0.2
		tor.outer_radius = 0.38
		tor.rings = 8
		tor.ring_segments = 5
		var pos := Vector3(rng.randf_range(-30, 30), 0.1, rng.randf_range(-6, 20))
		Geo.malla(z, tor, pos, Color("222222"), Vector3(rng.randf_range(-10, 10), 0, rng.randf_range(-10, 10)))
	for i in 12:
		var pos := Vector3(rng.randf_range(-32, 32), 0.05, rng.randf_range(-8, 21))
		_caja(z, Vector3(rng.randf_range(1.2, 2.4), 0.05, 0.2), pos, C_MADERA_VIEJA, Vector3(rng.randf_range(-5, 5), rng.randf() * 180.0, 0), false)
	Geo.cilindro(z, 0.3, 0.3, 0.9, Vector3(-6.0, 0.3, 14.0), C_OXIDO, 9, Vector3(90, 30, 0))
	Geo.cilindro(z, 0.3, 0.3, 0.9, Vector3(13.0, 0.45, 15.0), C_OXIDO, 9)
	_escombro(z, Vector3(-9, 0, 16), 0.9, 31)
	_escombro(z, Vector3(27, 0, 18), 0.8, 32)
	_escombro(z, Vector3(-30, 0, 0), 1.0, 33)


## Tranquera de la entrada con el arco y el cartel "El fogón de los sueños".
func _zona_tranquera(z: Node3D, hecha: bool) -> void:
	var tz := TRANQUERA_Z
	var c_poste := C_MADERA_OSCURA if hecha else C_MADERA_VIEJA
	for x in [-2.9, 2.9]:
		_caja(z, Vector3(0.45, 3.4, 0.45), Vector3(x, 1.7, tz), c_poste, Vector3(0, 0, 0 if hecha else (2.0 if x < 0 else -3.0)))
	if hecha:
		_hoja_tranquera(z, Vector3(-2.6, 0, tz), 1.0, 80.0, Vector3.ZERO, Paleta.MADERA)
		_hoja_tranquera(z, Vector3(2.6, 0, tz), -1.0, -80.0, Vector3.ZERO, Paleta.MADERA)
		var puntos := PackedVector3Array()
		for i in 13:
			var t := i / 12.0
			puntos.append(Vector3(lerpf(-2.9, 2.9, t), 3.35 + sin(t * PI) * 1.0, tz))
		for i in 12:
			Geo.barra(z, puntos[i], puntos[i + 1], 0.09, C_HIERRO)
			Geo.barra(z, puntos[i] + Vector3(0, -0.25, 0) * sin(i / 12.0 * PI), puntos[i + 1] + Vector3(0, -0.25, 0) * sin((i + 1) / 12.0 * PI), 0.04, C_HIERRO)
		_caja(z, Vector3(3.5, 0.72, 0.08), Vector3(0, 4.62, tz), Color("2a2a2a"), Vector3.ZERO, false)
		var texto := "El fogón de los sueños"
		_letrero(z, texto, Vector3(0, 4.62, tz + 0.05), 0.0, 60, Color("f3e6cf"))
		_letrero(z, texto, Vector3(0, 4.62, tz - 0.05), 180.0, 60, Color("f3e6cf"))
	else:
		# Una hoja tirada en el suelo y la otra colgando torcida; el arco roto
		# y el cartel caído contra el poste, casi sin letras.
		_hoja_tranquera(z, Vector3(-2.3, 0.08, tz - 1.4), 1.0, 25.0, Vector3(-86, 0, 0), C_MADERA_VIEJA)
		_hoja_tranquera(z, Vector3(2.6, 0, tz), -1.0, -35.0, Vector3(0, 0, -6), C_MADERA_VIEJA)
		for i in 5:
			var t0 := i / 12.0
			var t1 := (i + 1) / 12.0
			Geo.barra(z, Vector3(lerpf(-2.9, 2.9, t0), 3.35 + sin(t0 * PI), tz), Vector3(lerpf(-2.9, 2.9, t1), 3.35 + sin(t1 * PI) - (0.15 if i == 4 else 0.0), tz), 0.09, C_OXIDO)
		var cartel := Node3D.new()
		cartel.position = Vector3(4.3, 0.75, tz + 0.5)
		cartel.rotation_degrees = Vector3(0, -15, 78)
		z.add_child(cartel)
		_caja(cartel, Vector3(3.5, 0.72, 0.08), Vector3.ZERO, Color("3a3734"), Vector3.ZERO, false)
		_letrero(cartel, "El fog n de l s  ueños", Vector3(0, 0, 0.05), 0.0, 60, Color("8a8378"))
		_escombro(z, Vector3(-3.6, 0, tz + 0.8), 0.4, 41, C_OXIDO)


## Una hoja de la tranquera: tablas horizontales con su diagonal. Gira en la
## bisagra `bisagra`; `sentido` = 1 se abre hacia +X y -1 hacia -X.
func _hoja_tranquera(z: Node3D, bisagra: Vector3, sentido: float, giro_y: float, rot_extra: Vector3, color: Color) -> void:
	var hoja := Node3D.new()
	hoja.position = bisagra
	hoja.rotation_degrees = rot_extra + Vector3(0, giro_y, 0)
	z.add_child(hoja)
	var largo := 2.5
	for alto in [0.35, 0.75, 1.15, 1.55]:
		_caja(hoja, Vector3(largo, 0.16, 0.07), Vector3(sentido * largo * 0.5, alto, 0), color)
	_caja(hoja, Vector3(0.14, 1.5, 0.08), Vector3(sentido * (largo - 0.07), 0.95, 0), color, Vector3.ZERO, false)
	_caja(hoja, Vector3(0.14, 1.5, 0.08), Vector3(sentido * 0.07, 0.95, 0), color, Vector3.ZERO, false)
	Geo.barra(hoja, Vector3(sentido * 0.1, 0.3, 0.06), Vector3(sentido * (largo - 0.1), 1.6, 0.06), 0.12, color)


## Quincho con techo de paja, la pared de la parrilla, el brasero y el
## mostrador de venta. La parrilla de verdad (RejillaCalor) está en la escena:
## es la parrilla del abuelo, que sigue en pie aunque todo lo demás no.
func _zona_quincho(z: Node3D, hecha: bool) -> void:
	var q := QUINCHO
	_caja(z, Vector3(13, 0.15, 9), q + Vector3(0, 0.075, 0), C_BALDOSA if hecha else C_BALDOSA_SUCIA)
	var ladrillo := Paleta.LADRILLO if hecha else C_LADRILLO_VIEJO
	var madera := C_MADERA_OSCURA if hecha else C_MADERA_VIEJA
	# Pared del fondo con el hueco de la parrilla.
	var pared_z := q.z - 4.05
	_caja(z, Vector3(12.4, 2.7, 0.9), Vector3(q.x, 1.35, pared_z), ladrillo)
	_caja(z, Vector3(4.2, 1.6, 0.04), Vector3(20, 1.6, pared_z + 0.46), C_HUECO, Vector3.ZERO, false)
	# Mesada de obra a la izquierda de la parrilla (para la carne).
	_caja(z, Vector3(2.4, 0.8, 1.0), Vector3(16.6, 0.4, -17.6), ladrillo)
	_caja(z, Vector3(2.6, 0.06, 1.1), Vector3(16.6, 0.83, -17.6), Paleta.MADERA if hecha else C_MADERA_VIEJA)
	var techo := Geo.tejado_cuatro_aguas(14.6, 10.6, 2.8)
	if hecha:
		for x in [-6.2, 0.0, 6.2]:
			_poste(z, q + Vector3(x, 0.15, 4.2), 2.7, 0.14, madera)
		for zz in [-1.0, 1.6]:
			_poste(z, q + Vector3(-6.2, 0.15, zz), 2.7, 0.14, madera)
			_poste(z, q + Vector3(6.2, 0.15, zz), 2.7, 0.14, madera)
		_caja(z, Vector3(12.8, 0.22, 0.22), q + Vector3(0, 2.85, 4.2), madera, Vector3.ZERO, false)
		_caja(z, Vector3(0.22, 0.22, 8.6), q + Vector3(-6.2, 2.85, 0), madera, Vector3.ZERO, false)
		_caja(z, Vector3(0.22, 0.22, 8.6), q + Vector3(6.2, 2.85, 0), madera, Vector3.ZERO, false)
		Geo.malla(z, techo, q + Vector3(0, 2.95, 0), C_PAJA, Vector3.ZERO, Geo.material(C_PAJA, 1.0, 0.0, true))
		# Campana y chimenea encima de la parrilla, con humo.
		var campana := CylinderMesh.new()
		campana.top_radius = 0.45
		campana.bottom_radius = 1.7
		campana.height = 1.0
		campana.radial_segments = 4
		campana.rings = 1
		Geo.malla(z, Geo.facetar(campana, 0.0, 0), Vector3(20, 2.35, -17.95), C_HIERRO, Vector3(0, 45, 0))
		_caja(z, Vector3(0.7, 3.8, 0.7), Vector3(20, 4.6, -18.4), ladrillo)
		_caja(z, Vector3(0.95, 0.15, 0.95), Vector3(20, 6.55, -18.4), C_HIERRO, Vector3.ZERO, false)
		_humo(z, Vector3(20, 6.8, -18.4))
		# Brasero con leña encendida.
		_caja(z, Vector3(1.3, 0.9, 1.0), Vector3(23.6, 0.45, -17.6), ladrillo)
		Geo.cilindro(z, 0.42, 0.5, 0.35, Vector3(23.6, 1.07, -17.6), C_HIERRO, 6, Vector3.ZERO, false)
		for i in 3:
			Geo.cilindro(z, 0.07, 0.07, 0.8, Vector3(23.6, 1.15, -17.6 + (i - 1) * 0.15), Paleta.MADERA, 6, Vector3(0, 0, 90 + (i - 1) * 12), false)
		_fuego(z, Vector3(23.6, 1.2, -17.6), 0.9)
		# Leña apilada.
		for fila in 3:
			for i in 6 - fila:
				Geo.cilindro(z, 0.12, 0.12, 1.1, Vector3(26.6, 0.27 + fila * 0.21, -13.8 + i * 0.25 + fila * 0.12), Paleta.MADERA.lerp(C_MADERA_OSCURA, (i % 3) * 0.3), 6, Vector3(0, 0, 90), false)
		# Asador criollo (la cruz) clavado junto al brasero.
		Geo.barra(z, Vector3(25.6, 0.0, -16.6), Vector3(25.2, 2.3, -17.2), 0.09, C_HIERRO)
		Geo.barra(z, Vector3(24.7, 1.5, -16.9), Vector3(25.9, 1.6, -16.9), 0.07, C_HIERRO)
		Geo.bola(z, 0.45, Vector3(25.36, 1.35, -16.88), Color("a0522d"), Vector3(1.0, 1.5, 0.35), 0.15, 77, 6)
		# Mostrador de venta, de cara a la mesa.
		_caja(z, Vector3(3.0, 0.96, 0.7), Vector3(18, 0.48 + 0.15, -10.8), Paleta.MADERA)
		_caja(z, Vector3(3.2, 0.06, 0.8), Vector3(18, 1.14, -10.8), C_MADERA_OSCURA, Vector3.ZERO, false)
		_luz(z, Vector3(20, 2.4, -14), 1.2, 9.0, C_LUZ)
	else:
		# Techo hundido por un lado, un poste menos y un trozo caído.
		for x in [-6.2, 0.0]:
			_poste(z, q + Vector3(x, 0.15, 4.2), 2.7, 0.14, madera)
		_poste(z, q + Vector3(-6.2, 0.15, -1.0), 2.7, 0.14, madera)
		Geo.cilindro(z, 0.14, 0.13, 2.7, q + Vector3(5.0, 0.3, 4.6), madera, 7, Vector3(0, 30, 90))
		var t := Geo.malla(z, techo, q + Vector3(-0.6, 2.55, 0), C_PAJA_VIEJA, Vector3(0, 0, 6), Geo.material(C_PAJA_VIEJA, 1.0, 0.0, true))
		t.scale = Vector3(0.88, 1.0, 1.0)
		_caja(z, Vector3(4.6, 0.3, 4.0), q + Vector3(5.0, 1.1, 2.0), C_PAJA_VIEJA, Vector3(35, 0, -12), false)
		# Campana en el suelo, chimenea partida y ladrillos sueltos.
		var campana := CylinderMesh.new()
		campana.top_radius = 0.45
		campana.bottom_radius = 1.7
		campana.height = 1.0
		campana.radial_segments = 4
		campana.rings = 1
		Geo.malla(z, Geo.facetar(campana, 0.0, 0), Vector3(17.4, 0.55, -13.8), C_OXIDO, Vector3(70, 20, 15))
		_caja(z, Vector3(0.7, 1.0, 0.7), Vector3(20, 3.2, -18.4), ladrillo, Vector3.ZERO, false)
		_escombro(z, Vector3(22.5, 0.15, -16.4), 0.6, 51, C_LADRILLO_VIEJO)
		# Brasero partido, lleno de ceniza.
		_caja(z, Vector3(1.3, 0.5, 1.0), Vector3(23.6, 0.25, -17.6), ladrillo)
		_caja(z, Vector3(1.0, 0.04, 0.7), Vector3(23.6, 0.52, -17.6), Paleta.CENIZA, Vector3.ZERO, false)
		# Leña desparramada.
		var rng := RandomNumberGenerator.new()
		rng.seed = 52
		for i in 7:
			Geo.cilindro(z, 0.11, 0.11, 1.0, Vector3(rng.randf_range(24.5, 27.0), 0.26, rng.randf_range(-15, -11.5)), C_MADERA_VIEJA, 6, Vector3(0, rng.randf() * 180.0, 90), false)
		# Mostrador improvisado: un tablón sobre dos bidones.
		Geo.cilindro(z, 0.3, 0.3, 0.92, Vector3(16.9, 0.61, -10.8), C_OXIDO, 9)
		Geo.cilindro(z, 0.3, 0.3, 0.92, Vector3(19.1, 0.61, -10.8), C_OXIDO, 9)
		_caja(z, Vector3(3.0, 0.06, 0.7), Vector3(18, 1.1, -10.8), C_MADERA_VIEJA)


## Mesa larga para 30 bajo una pérgola con guirnaldas.
func _zona_mesa(z: Node3D, hecha: bool) -> void:
	var m := MESA
	if hecha:
		_caja(z, Vector3(13, 0.08, 1.2), m + Vector3(0, 0.76, 0), Paleta.MADERA)
		Geo.malla(z, _plano(Vector2(13.1, 0.95)), m + Vector3(0, 0.805, 0), Paleta.MANTEL)
		for i in 6:
			var x := -6.0 + i * 2.4
			for lado in [-0.45, 0.45]:
				_caja(z, Vector3(0.1, 0.72, 0.1), m + Vector3(x, 0.36, lado), C_MADERA_OSCURA, Vector3.ZERO, false)
		for lado in [-0.95, 0.95]:
			_caja(z, Vector3(13, 0.07, 0.38), m + Vector3(0, 0.45, lado), Paleta.MADERA)
			for i in 5:
				_caja(z, Vector3(0.08, 0.42, 0.3), m + Vector3(-6.0 + i * 3.0, 0.21, lado), C_MADERA_OSCURA, Vector3.ZERO, false)
		# 30 platos, vasos y unas botellas de vino.
		for i in 15:
			var x := -6.0 + i * (12.0 / 14.0)
			for lado in [-0.32, 0.32]:
				Geo.cilindro(z, 0.14, 0.12, 0.025, m + Vector3(x, 0.825, lado), Color("f4f1ea"), 10, Vector3.ZERO, false)
				Geo.cilindro(z, 0.035, 0.03, 0.1, m + Vector3(x + 0.22, 0.86, lado * 0.7), Color("dfe8ea"), 6, Vector3.ZERO, false)
		for x in [-4.5, -1.0, 2.5, 5.5]:
			Geo.cilindro(z, 0.045, 0.045, 0.3, m + Vector3(x, 0.96, 0), Color("2d4a2a"), 6, Vector3.ZERO, false)
		# Pérgola con guirnaldas de luces.
		var esquinas := [Vector3(-7.5, 0, -3.5), Vector3(7.5, 0, -3.5), Vector3(-7.5, 0, 3.5), Vector3(7.5, 0, 3.5)]
		for e in esquinas:
			_poste(z, m + e, 3.2, 0.1, C_MADERA_OSCURA)
		var arriba := Vector3(0, 3.1, 0)
		_guirnalda(z, m + esquinas[0] + arriba, m + esquinas[3] + arriba, 0.7)
		_guirnalda(z, m + esquinas[1] + arriba, m + esquinas[2] + arriba, 0.7)
		_guirnalda(z, m + esquinas[0] + arriba, m + esquinas[1] + arriba, 0.5)
		_guirnalda(z, m + esquinas[2] + arriba, m + esquinas[3] + arriba, 0.5)
		_guirnalda(z, QUINCHO + Vector3(-6.2, 2.8, 4.2), m + esquinas[0] + arriba, 0.6)
		_guirnalda(z, QUINCHO + Vector3(6.2, 2.8, 4.2), m + esquinas[1] + arriba, 0.6)
		for x in [-5.0, 0.0, 5.0]:
			_luz(z, m + Vector3(x, 2.5, 0), 0.9, 7.0)
	else:
		# Media mesa en pie, la otra media en el suelo y un banco volcado.
		_caja(z, Vector3(6, 0.08, 1.2), m + Vector3(-3.5, 0.76, 0), C_MADERA_VIEJA)
		for x in [-6.0, -1.0]:
			for lado in [-0.45, 0.45]:
				_caja(z, Vector3(0.1, 0.72, 0.1), m + Vector3(x, 0.36, lado), C_MADERA_VIEJA, Vector3.ZERO, false)
		_caja(z, Vector3(6, 0.08, 1.2), m + Vector3(3.6, 0.38, 0.2), C_MADERA_VIEJA, Vector3(0, 6, 9))
		_caja(z, Vector3(6, 0.07, 0.38), m + Vector3(-3.0, 0.2, 1.3), C_MADERA_VIEJA, Vector3(80, 0, 0))
		_poste(z, m + Vector3(-7.5, 0, -3.5), 3.2, 0.1, C_MADERA_VIEJA)
		Geo.cilindro(z, 0.1, 0.09, 3.2, m + Vector3(5.5, 0.1, 3.8), C_MADERA_VIEJA, 7, Vector3(0, 70, 90))


func _plano(tam: Vector2) -> PlaneMesh:
	var pm := PlaneMesh.new()
	pm.size = tam
	return pm


## Aljibe de ladrillo con su arco de hierro y la roldana.
func _zona_aljibe(z: Node3D, hecha: bool) -> void:
	var a := ALJIBE
	if hecha:
		Geo.cilindro(z, 1.0, 1.0, 1.0, a + Vector3(0, 0.5, 0), Paleta.LADRILLO, 14)
		Geo.cilindro(z, 1.1, 1.1, 0.12, a + Vector3(0, 1.06, 0), C_PIEDRA, 14, Vector3.ZERO, false)
		Geo.cilindro(z, 0.82, 0.82, 0.02, a + Vector3(0, 1.13, 0), C_HUECO, 14, Vector3.ZERO, false)
		for x in [-0.95, 0.95]:
			Geo.barra(z, a + Vector3(x, 1.1, 0), a + Vector3(x, 2.3, 0), 0.06, C_HIERRO)
		var puntos := PackedVector3Array()
		for i in 9:
			var t := i / 8.0
			puntos.append(a + Vector3(lerpf(-0.95, 0.95, t), 2.3 + sin(t * PI) * 0.55, 0))
		for i in 8:
			Geo.barra(z, puntos[i], puntos[i + 1], 0.06, C_HIERRO)
		Geo.cilindro(z, 0.12, 0.12, 0.06, a + Vector3(0, 2.7, 0), C_HIERRO, 8, Vector3(90, 0, 0), false)
		Geo.barra(z, a + Vector3(0, 2.62, 0), a + Vector3(0, 1.55, 0), 0.015, Color("b9a27a"))
		Geo.cilindro(z, 0.13, 0.1, 0.22, a + Vector3(0, 1.45, 0), Color("6f5a3a"), 8, Vector3.ZERO, false)
	else:
		Geo.cilindro(z, 1.0, 1.0, 0.6, a + Vector3(0, 0.3, 0), C_LADRILLO_VIEJO, 14)
		_caja(z, Vector3(2.4, 0.05, 0.25), a + Vector3(0, 0.63, -0.3), C_MADERA_VIEJA, Vector3(0, 10, 0), false)
		_caja(z, Vector3(2.4, 0.05, 0.25), a + Vector3(0, 0.63, 0.25), C_MADERA_VIEJA, Vector3(0, -6, 0), false)
		_escombro(z, a + Vector3(1.2, 0, 0.6), 0.5, 61, C_LADRILLO_VIEJO)
		Geo.barra(z, a + Vector3(-1.6, 0.05, 1.3), a + Vector3(0.2, 0.05, 2.1), 0.06, C_OXIDO)
		Geo.barra(z, a + Vector3(0.2, 0.05, 2.1), a + Vector3(1.4, 0.05, 1.6), 0.06, C_OXIDO)


## Jardín: caminos de losas, lavanda, farolas, el limonero y un banco bajo el ombú.
func _zona_jardin(z: Node3D, hecha: bool) -> void:
	if hecha:
		_camino_losas(z, PackedVector3Array([Vector3(0, 0, 21), Vector3(0, 0, 8), Vector3(0, 0, -10.2)]), 71)
		_camino_losas(z, PackedVector3Array([Vector3(-0.5, 0, 8.5), Vector3(-6, 0, 5), Vector3(-11, 0, -1), Vector3(-14, 0, -7.2)]), 72)
		_camino_losas(z, PackedVector3Array([Vector3(0.5, 0, 8.5), Vector3(7, 0, 5), Vector3(12, 0, 1), Vector3(14.5, 0, -1.6)]), 73)
		# Lavanda a los dos lados del camino del centro.
		var flores: Array[Transform3D] = []
		var colores: Array[Color] = []
		var rng := RandomNumberGenerator.new()
		rng.seed = 74
		var zz := 6.5
		while zz > -9.0:
			for x in [-1.25, 1.25]:
				for k in 3:
					var pos := Vector3(x + rng.randf_range(-0.2, 0.2), 0.25, zz + rng.randf_range(-0.3, 0.3))
					flores.append(Transform3D(Basis().scaled(Vector3(0.22, 0.32, 0.22)), pos))
					colores.append(C_LAVANDA.lerp(Color("6e4f99"), rng.randf()))
			zz -= 1.4
		# Canteros con flores delante de la galería.
		for i in 28:
			var pos := Vector3(-27.5 + i * 0.55, 0.18, -7.0 + rng.randf_range(-0.15, 0.15))
			flores.append(Transform3D(Basis().scaled(Vector3(0.16, 0.2, 0.16)), pos))
			colores.append([C_SANTA_RITA, Color("e9c46a"), Color("f4f1ea")][i % 3])
		var sm := SphereMesh.new()
		sm.radius = 1.0
		sm.height = 2.0
		sm.radial_segments = 6
		sm.rings = 3
		Geo.multi(z, Geo.facetar(sm, 0.1, 9), flores, colores)
		# Farolas.
		for pos in [Vector3(2.2, 0, 10.5), Vector3(-9.5, 0, -2.5), Vector3(12.5, 0, 3.0), Vector3(2.2, 0, 20.0)]:
			_poste(z, pos, 3.0, 0.06, C_HIERRO)
			_caja(z, Vector3(0.32, 0.42, 0.32), pos + Vector3(0, 3.15, 0), C_LUZ, Vector3.ZERO, false).material_override = Geo.material(C_LUZ, 0.5, 3.0)
			_caja(z, Vector3(0.42, 0.06, 0.42), pos + Vector3(0, 3.39, 0), C_HIERRO, Vector3.ZERO, false)
			_luz(z, pos + Vector3(0, 3.0, 0), 1.3, 9.0)
		# Limonero con limones.
		_arbol(z, LIMONERO, 4.2, 81, Color("4a8a32"))
		for i in 14:
			var ang := TAU * i / 14.0
			Geo.bola(z, 0.09, LIMONERO + Vector3(cos(ang) * 1.05, 2.9 + sin(i * 1.7) * 0.4, sin(ang) * 1.05), C_LIMON, Vector3.ONE, 0.0, 0, 5)
		# Banco bajo el ombú.
		_caja(z, Vector3(2.0, 0.08, 0.45), OMBU + Vector3(2.6, 0.45, 2.6), Paleta.MADERA, Vector3(0, -45, 0))
		_caja(z, Vector3(2.0, 0.4, 0.08), OMBU + Vector3(2.75, 0.75, 2.75), Paleta.MADERA, Vector3(-10, -45, 0), false)
	else:
		_arbol(z, LIMONERO, 3.6, 81, C_SECO, true)
		Geo.cilindro(z, 0.06, 0.06, 3.0, Vector3(2.2, 0.08, 10.5), C_OXIDO, 6, Vector3(0, 40, 88), false)
		_caja(z, Vector3(1.0, 0.08, 0.45), OMBU + Vector3(2.4, 0.2, 2.8), C_MADERA_VIEJA, Vector3(15, -30, 10), false)


## Bodegón de ladrillo con el pasaje de la pérgola hacia la casa.
func _zona_bodegon(z: Node3D, hecha: bool) -> void:
	var b := BODEGON
	var frente := b.z + 4.5
	_caja(z, Vector3(12.2, 0.3, 9.2), b + Vector3(0, 0.15, 0), C_ZOCALO)
	if hecha:
		_caja(z, Vector3(12, 3.6, 9), b + Vector3(0, 1.8, 0), Paleta.LADRILLO)
		Geo.malla(z, Geo.tejado_dos_aguas(13.0, 10.2, 2.4), b + Vector3(0, 3.6, 0), C_TEJA_OSCURA, Vector3.ZERO, Geo.material(C_TEJA_OSCURA, 0.9, 0.0, true))
		Geo.malla(z, Geo.hastial(9.0, 2.0), b + Vector3(6.0, 3.6, 0), Paleta.LADRILLO)
		Geo.malla(z, Geo.hastial(9.0, 2.0), b + Vector3(-6.0, 3.6, 0), Paleta.LADRILLO, Vector3(0, 180, 0))
		# Puerta doble, ventanas con reja, farolitos y el cartel.
		_caja(z, Vector3(2.5, 3.0, 0.1), Vector3(b.x, 1.5, frente + 0.03), C_MADERA_OSCURA, Vector3.ZERO, false)
		_caja(z, Vector3(2.1, 2.7, 0.06), Vector3(b.x, 1.45, frente + 0.1), Paleta.MADERA, Vector3.ZERO, false)
		_caja(z, Vector3(0.04, 2.7, 0.08), Vector3(b.x, 1.45, frente + 0.12), C_MADERA_OSCURA, Vector3.ZERO, false)
		for x in [-4.0, 4.0]:
			_ventana(z, Vector3(b.x + x, 1.8, frente), C_MADERA_OSCURA, true)
		for x in [-1.7, 1.7]:
			_caja(z, Vector3(0.22, 0.32, 0.18), Vector3(b.x + x, 2.7, frente + 0.1), C_LUZ, Vector3.ZERO, false).material_override = Geo.material(C_LUZ, 0.5, 3.0)
			_luz(z, Vector3(b.x + x, 2.6, frente + 0.6), 0.8, 5.0)
		_caja(z, Vector3(2.6, 0.5, 0.06), Vector3(b.x, 3.3, frente + 0.06), C_MADERA_OSCURA, Vector3.ZERO, false)
		_letrero(z, "BODEGÓN", Vector3(b.x, 3.3, frente + 0.1), 0.0, 70, Paleta.MANTEL)
		for x in [-5.2, 5.2]:
			Geo.cilindro(z, 0.38, 0.38, 0.95, Vector3(b.x + x, 0.47, frente + 0.8), Color("7a4e2d"), 10)
			Geo.cilindro(z, 0.4, 0.4, 0.05, Vector3(b.x + x, 0.75, frente + 0.8), C_HIERRO, 10, Vector3.ZERO, false)
		# Pérgola con enredadera entre el bodegón y la casa.
		for pos in [Vector3(-11.6, 0, -17.2), Vector3(-6.4, 0, -17.2), Vector3(-11.6, 0, -12.8), Vector3(-6.4, 0, -12.8)]:
			_poste(z, pos, 2.8, 0.09, C_MADERA_OSCURA)
		for zz in [-17.2, -15.0, -12.8]:
			_caja(z, Vector3(5.6, 0.12, 0.12), Vector3(-9, 2.85, zz), C_MADERA_OSCURA, Vector3.ZERO, false)
		var rng := RandomNumberGenerator.new()
		rng.seed = 91
		for i in 9:
			var pos := Vector3(rng.randf_range(-11.5, -6.5), 3.0, rng.randf_range(-17.0, -13.0))
			Geo.bola(z, rng.randf_range(0.6, 0.9), pos, C_HOJA.lerp(C_HOJA_OSCURA, rng.randf()), Vector3(1.3, 0.45, 1.3), 0.25, 92 + i, 6)
		for i in 10:
			var pos := Vector3(rng.randf_range(-11.5, -6.5), 2.75, rng.randf_range(-17.0, -13.0))
			Geo.bola(z, 0.12, pos, C_LAVANDA, Vector3(1, 1.6, 1), 0.1, 0, 5)
	else:
		# Esquina derecha derrumbada: pared baja, el techo caído dentro y escombro.
		_caja(z, Vector3(8, 3.6, 9), b + Vector3(-2, 1.8, 0), C_LADRILLO_VIEJO)
		_caja(z, Vector3(4, 2.1, 9), b + Vector3(4, 1.05, 0), C_LADRILLO_VIEJO)
		_caja(z, Vector3(1.6, 0.8, 9), b + Vector3(2.8, 2.5, 0), C_LADRILLO_VIEJO, Vector3(0, 0, 25), false)
		Geo.malla(z, Geo.tejado_dos_aguas(8.6, 10.2, 2.4), b + Vector3(-1.9, 3.6, 0), C_TEJA_VIEJA, Vector3.ZERO, Geo.material(C_TEJA_VIEJA, 0.9, 0.0, true))
		Geo.malla(z, Geo.hastial(9.0, 2.0), b + Vector3(-6.0, 3.6, 0), C_LADRILLO_VIEJO, Vector3(0, 180, 0))
		_caja(z, Vector3(4.4, 0.15, 5.2), b + Vector3(4.2, 2.4, -1.0), C_TEJA_VIEJA, Vector3(18, 0, -14), false)
		_escombro(z, Vector3(b.x + 6.8, 0, frente + 0.6), 1.0, 93)
		_escombro(z, Vector3(b.x + 5.0, 0, frente + 1.2), 0.6, 94, C_LADRILLO_VIEJO)
		_caja(z, Vector3(2.5, 3.0, 0.1), Vector3(b.x, 1.5, frente + 0.03), C_MADERA_VIEJA, Vector3.ZERO, false)
		_tapiado(z, Vector3(b.x, 1.5, frente + 0.06), 2.3, 2.6)
		_ventana(z, Vector3(b.x - 4.0, 1.8, frente), C_MADERA_VIEJA, false)
		# Pérgola caída.
		_poste(z, Vector3(-11.6, 0, -17.2), 2.8, 0.09, C_MADERA_VIEJA)
		_poste(z, Vector3(-6.4, 0, -12.8), 2.8, 0.09, C_MADERA_VIEJA)
		_caja(z, Vector3(5.6, 0.12, 0.12), Vector3(-9, 1.4, -15.0), C_MADERA_VIEJA, Vector3(0, 20, 28), false)
		_caja(z, Vector3(5.6, 0.12, 0.12), Vector3(-9, 0.1, -13.5), C_MADERA_VIEJA, Vector3(0, -15, 0), false)


## Ventana en una fachada que mira a +Z: hueco, marco y, si está bien, reja;
## si no, tapiada con tablones.
func _ventana(z: Node3D, centro: Vector3, marco: Color, bien: bool, ancho := 1.2, alto := 1.5) -> void:
	_caja(z, Vector3(ancho + 0.2, alto + 0.2, 0.06), centro + Vector3(0, 0, 0.02), marco, Vector3.ZERO, false)
	_caja(z, Vector3(ancho, alto, 0.06), centro + Vector3(0, 0, 0.04), C_HUECO, Vector3.ZERO, false)
	if bien:
		for i in 4:
			var x := -ancho * 0.5 + ancho * (i + 1) / 5.0
			_caja(z, Vector3(0.03, alto, 0.03), centro + Vector3(x, 0, 0.09), C_HIERRO, Vector3.ZERO, false)
		_caja(z, Vector3(ancho, 0.03, 0.03), centro + Vector3(0, 0, 0.09), C_HIERRO, Vector3.ZERO, false)
	else:
		_tapiado(z, centro + Vector3(0, 0, 0.05), ancho, alto)


## Casa criolla encalada con techo de tejas y galería.
func _zona_casa(z: Node3D, hecha: bool) -> void:
	var c := CASA
	var frente := c.z + 4.5
	_caja(z, Vector3(16.2, 0.35, 9.2), c + Vector3(0, 0.175, 0), C_ZOCALO)
	_caja(z, Vector3(16, 3.2, 9), c + Vector3(0, 1.6, 0), C_CAL if hecha else C_CAL_SUCIA)
	var teja := C_TEJA if hecha else C_TEJA_VIEJA
	Geo.malla(z, Geo.tejado_cuatro_aguas(17.2, 10.2, 2.4), c + Vector3(0, 3.2, 0), teja, Vector3.ZERO, Geo.material(teja, 0.85, 0.0, true))
	_caja(z, Vector3(0.6, 1.4, 0.6), c + Vector3(4, 5.0, -1.5), C_CAL if hecha else C_CAL_SUCIA, Vector3.ZERO, false)
	# Suelo de la galería.
	_caja(z, Vector3(16, 0.15, 2.9), Vector3(c.x, 0.075, frente + 1.45), C_GALERIA if hecha else C_MANCHA)
	var postes_x := [-7.6, -3.8, 0.0, 3.8, 7.6]
	if hecha:
		for x in postes_x:
			_poste(z, Vector3(c.x + x, 0.15, frente + 2.6), 2.6, 0.11, C_MADERA_OSCURA)
		_caja(z, Vector3(16.4, 0.2, 0.2), Vector3(c.x, 2.8, frente + 2.6), C_MADERA_OSCURA, Vector3.ZERO, false)
		_caja(z, Vector3(16.6, 0.12, 3.4), Vector3(c.x, 2.98, frente + 1.6), C_TEJA, Vector3(8, 0, 0), false)
		# Fachada: puerta, ventanas con reja y postigos verdes abiertos.
		_caja(z, Vector3(1.3, 2.3, 0.08), Vector3(c.x, 1.15 + 0.35, frente + 0.03), Paleta.MADERA, Vector3.ZERO, false)
		Geo.bola(z, 0.05, Vector3(c.x + 0.45, 1.45, frente + 0.1), Color("d4a93c"), Vector3.ONE, 0.0, 0, 5)
		for x in [-4.6, 4.6]:
			_ventana(z, Vector3(c.x + x, 1.75, frente), C_MADERA_OSCURA, true)
			for lado in [-1.0, 1.0]:
				_caja(z, Vector3(0.6, 1.6, 0.05), Vector3(c.x + x + lado * 0.95, 1.75, frente + 0.05), C_POSTIGO, Vector3.ZERO, false)
		# Hamaca paraguaya entre los dos primeros postes.
		var puntos := Geo.curva_colgante(Vector3(c.x - 7.4, 2.1, frente + 2.5), Vector3(c.x - 4.0, 2.1, frente + 2.5), 1.1, 10)
		for i in range(puntos.size() - 1):
			Geo.barra(z, puntos[i], puntos[i + 1], 0.09, C_HAMACA)
		for i in range(2, puntos.size() - 2, 2):
			Geo.barra(z, puntos[i], puntos[i] + Vector3(0, -0.3, 0), 0.02, Color("e67e22"))
		# Dos sillones con una mesita y un cactus.
		for x in [2.6, 5.6]:
			_caja(z, Vector3(0.9, 0.45, 0.8), Vector3(c.x + x, 0.38, frente + 1.3), Color("c8a06a"))
			_caja(z, Vector3(0.9, 0.8, 0.12), Vector3(c.x + x, 0.75, frente + 0.95), Color("c8a06a"), Vector3(-8, 0, 0), false)
		_caja(z, Vector3(0.6, 0.4, 0.5), Vector3(c.x + 4.1, 0.35, frente + 1.35), C_MADERA_OSCURA)
		Geo.cilindro(z, 0.07, 0.07, 0.25, Vector3(c.x + 4.1, 0.68, frente + 1.35), Color("6a994e"), 6, Vector3.ZERO, false)
		# Santa Rita trepando por el último poste.
		Geo.barra(z, Vector3(c.x + 7.75, 0.15, frente + 2.75), Vector3(c.x + 7.7, 2.85, frente + 2.7), 0.06, C_HOJA_OSCURA)
		var rng := RandomNumberGenerator.new()
		rng.seed = 101
		for i in 12:
			var pos := Vector3(c.x + 7.6 + rng.randf_range(-0.6, 0.6), rng.randf_range(1.0, 3.0), frente + 2.7 + rng.randf_range(-0.3, 0.3))
			Geo.bola(z, rng.randf_range(0.12, 0.2), pos, C_SANTA_RITA if i % 3 else C_HOJA, Vector3.ONE, 0.2, i, 5)
		_luz(z, Vector3(c.x, 2.5, frente + 1.4), 0.9, 7.0)
	else:
		# Techo con agujeros, galería medio caída, ventanas y puerta tapiadas.
		var pendiente := rad_to_deg(atan2(2.4, 5.1))
		for hueco in [[-4.0, 0.35, 1.6], [1.5, 0.55, 1.2], [5.0, 0.25, 1.0]]:
			var f: float = hueco[1]
			var pos := Vector3(c.x + hueco[0], 3.2 + 2.4 * f + 0.03, c.z + 5.1 - 5.1 * f)
			_caja(z, Vector3(hueco[2], 0.05, 0.9), pos, C_HUECO, Vector3(pendiente, 0, 0), false)
		for mancha in [[-6.0, 1.0, 1.6], [2.5, 2.2, 1.0], [6.5, 0.6, 1.3]]:
			_caja(z, Vector3(mancha[2], mancha[2] * 0.7, 0.02), Vector3(c.x + mancha[0], mancha[1], frente + 0.01), C_MANCHA, Vector3.ZERO, false)
		for x in [-7.6, -3.8, 0.0]:
			_poste(z, Vector3(c.x + x, 0.15, frente + 2.6), 2.6, 0.11, C_MADERA_VIEJA)
		_caja(z, Vector3(8.4, 0.12, 3.4), Vector3(c.x - 4.0, 2.98, frente + 1.6), C_TEJA_VIEJA, Vector3(8, 0, 0), false)
		_caja(z, Vector3(8.4, 0.12, 3.4), Vector3(c.x + 4.4, 1.55, frente + 1.7), C_TEJA_VIEJA, Vector3(8, 0, -19))
		Geo.cilindro(z, 0.11, 0.1, 2.6, Vector3(c.x + 5.5, 0.3, frente + 3.6), C_MADERA_VIEJA, 7, Vector3(0, 20, 90))
		_caja(z, Vector3(1.3, 2.3, 0.08), Vector3(c.x, 1.5, frente + 0.03), C_MADERA_VIEJA, Vector3.ZERO, false)
		_tapiado(z, Vector3(c.x, 1.5, frente + 0.05), 1.3, 2.3)
		for x in [-4.6, 4.6]:
			_ventana(z, Vector3(c.x + x, 1.75, frente), C_MADERA_VIEJA, false)
		_caja(z, Vector3(0.6, 1.6, 0.05), Vector3(c.x - 3.6, 0.2, frente + 1.0), C_MADERA_VIEJA.lerp(C_POSTIGO, 0.4), Vector3(-88, 25, 0), false)
		_escombro(z, Vector3(c.x + 6.5, 0.15, frente + 1.6), 0.6, 102, C_TEJA_VIEJA)
