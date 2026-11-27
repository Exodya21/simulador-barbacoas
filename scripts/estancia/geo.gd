@tool
class_name Geo
extends RefCounted
## Ayudantes para levantar el escenario low-poly desde código: cajas,
## cilindros, formas "facetadas" (con caras planas y algo de ruido, para
## árboles, piedras y matas), tejados y pasto con MultiMesh.
## Todo es color plano de material; el detalle lo ponen la luz y la sombra.

const SHADER_PASTO := preload("res://shaders/pasto.gdshader")

static var _materiales := {}


## Material de color plano, cacheado por color y acabado.
static func material(color: Color, rugosidad := 0.9, emision := 0.0, doble_cara := false) -> StandardMaterial3D:
	var clave := "%s_%.2f_%.2f_%s" % [color.to_html(), rugosidad, emision, doble_cara]
	if _materiales.has(clave):
		return _materiales[clave]
	var m := StandardMaterial3D.new()
	m.albedo_color = color
	m.roughness = rugosidad
	if emision > 0.0:
		m.emission_enabled = true
		m.emission = color
		m.emission_energy_multiplier = emision
	if doble_cara:
		m.cull_mode = BaseMaterial3D.CULL_DISABLED
	_materiales[clave] = m
	return m


static func malla(padre: Node3D, mesh: Mesh, pos: Vector3, color: Color, rot := Vector3.ZERO, mat: Material = null) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	mi.mesh = mesh
	mi.material_override = mat if mat else material(color)
	mi.position = pos
	mi.rotation_degrees = rot
	padre.add_child(mi)
	return mi


## Caja de tamaño `tam` centrada en `pos`. Si es sólida, lleva su colisión.
static func caja(padre: Node3D, tam: Vector3, pos: Vector3, color: Color, rot := Vector3.ZERO, solida := true) -> MeshInstance3D:
	var bm := BoxMesh.new()
	bm.size = tam
	var mi := malla(padre, bm, pos, color, rot)
	if solida:
		var forma := BoxShape3D.new()
		forma.size = tam
		_cuerpo(mi, forma)
	return mi


## Cilindro (o tronco de cono) de pocos lados. `lados` bajo = más low-poly.
static func cilindro(padre: Node3D, radio_abajo: float, radio_arriba: float, alto: float, pos: Vector3, color: Color, lados := 8, rot := Vector3.ZERO, solida := true) -> MeshInstance3D:
	var cm := CylinderMesh.new()
	cm.bottom_radius = radio_abajo
	cm.top_radius = radio_arriba
	cm.height = alto
	cm.radial_segments = lados
	cm.rings = 1
	var mi := malla(padre, facetar(cm, 0.0, 0), pos, color, rot)
	if solida:
		var forma := CylinderShape3D.new()
		forma.radius = maxf(radio_abajo, radio_arriba)
		forma.height = alto
		_cuerpo(mi, forma)
	return mi


## Bola facetada (copas de árbol, matas, piedras). `ruido` deforma los
## vértices para que no parezca una esfera perfecta.
static func bola(padre: Node3D, radio: float, pos: Vector3, color: Color, escala := Vector3.ONE, ruido := 0.15, semilla := 0, lados := 7) -> MeshInstance3D:
	var sm := SphereMesh.new()
	sm.radius = radio
	sm.height = radio * 2.0
	sm.radial_segments = lados
	sm.rings = maxi(3, lados / 2)
	var mi := malla(padre, facetar(sm, radio * ruido, semilla), pos, color)
	mi.scale = escala
	return mi


## Cuerpo estático con una forma, hijo de la malla (hereda su posición y giro).
static func _cuerpo(mi: MeshInstance3D, forma: Shape3D) -> void:
	var cuerpo := StaticBody3D.new()
	var col := CollisionShape3D.new()
	col.shape = forma
	cuerpo.add_child(col)
	mi.add_child(cuerpo)


## Pared invisible (para cerrar el terreno sin que se vea).
static func muro_invisible(padre: Node3D, tam: Vector3, pos: Vector3) -> void:
	var cuerpo := StaticBody3D.new()
	cuerpo.position = pos
	var col := CollisionShape3D.new()
	var forma := BoxShape3D.new()
	forma.size = tam
	col.shape = forma
	cuerpo.add_child(col)
	padre.add_child(cuerpo)


## Convierte una malla primitiva en otra con caras planas (normales por
## triángulo) y, si `ruido` > 0, con los vértices desplazados al azar.
## Los vértices repetidos en la costura se mueven igual, así no se abren.
static func facetar(mesh: PrimitiveMesh, ruido: float, semilla: int) -> ArrayMesh:
	var arrays := mesh.get_mesh_arrays()
	var verts: PackedVector3Array = arrays[Mesh.ARRAY_VERTEX]
	var normales_orig: PackedVector3Array = arrays[Mesh.ARRAY_NORMAL]
	var indices: PackedInt32Array = arrays[Mesh.ARRAY_INDEX]
	var rng := RandomNumberGenerator.new()
	var desplazados := {}
	var out_v := PackedVector3Array()
	var out_n := PackedVector3Array()
	for i in range(0, indices.size(), 3):
		var tri: Array[Vector3] = []
		var media_n := Vector3.ZERO
		for k in 3:
			var idx := indices[i + k]
			var v := verts[idx]
			media_n += normales_orig[idx]
			if ruido > 0.0:
				var clave := Vector3i(roundi(v.x * 1000.0), roundi(v.y * 1000.0), roundi(v.z * 1000.0))
				if not desplazados.has(clave):
					rng.seed = hash(clave) ^ semilla
					desplazados[clave] = Vector3(rng.randf_range(-1, 1), rng.randf_range(-0.6, 0.6), rng.randf_range(-1, 1)) * ruido
				v += desplazados[clave]
			tri.append(v)
		var n := (tri[1] - tri[0]).cross(tri[2] - tri[0]).normalized()
		if n.dot(media_n) < 0.0:
			n = -n
		for k in 3:
			out_v.append(tri[k])
			out_n.append(n)
	return _array_mesh(out_v, out_n)


## Malla a partir de triángulos sueltos (cada 3 vértices, uno), con caras
## planas cuya normal apunta hacia fuera de `centro`.
static func poligonos(vertices: PackedVector3Array, centro: Vector3) -> ArrayMesh:
	var out_n := PackedVector3Array()
	out_n.resize(vertices.size())
	for i in range(0, vertices.size(), 3):
		var a := vertices[i]
		var b := vertices[i + 1]
		var c := vertices[i + 2]
		var n := (b - a).cross(c - a).normalized()
		if n.dot((a + b + c) / 3.0 - centro) < 0.0:
			n = -n
		out_n[i] = n
		out_n[i + 1] = n
		out_n[i + 2] = n
	return _array_mesh(vertices, out_n)


static func _array_mesh(v: PackedVector3Array, n: PackedVector3Array) -> ArrayMesh:
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = v
	arrays[Mesh.ARRAY_NORMAL] = n
	var am := ArrayMesh.new()
	am.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	return am


static func _quad(v: PackedVector3Array, a: Vector3, b: Vector3, c: Vector3, d: Vector3) -> void:
	v.append_array([a, b, c, a, c, d])


## Tejado a cuatro aguas (casa criolla, quincho). Base `ancho` × `fondo`
## en y = 0, cumbrera a lo largo de X a `alto`.
static func tejado_cuatro_aguas(ancho: float, fondo: float, alto: float) -> ArrayMesh:
	var w := ancho * 0.5
	var d := fondo * 0.5
	var r := maxf(w - d, 0.05)
	var v := PackedVector3Array()
	var c1 := Vector3(-r, alto, 0)
	var c2 := Vector3(r, alto, 0)
	_quad(v, Vector3(-w, 0, d), Vector3(w, 0, d), c2, c1)
	_quad(v, Vector3(w, 0, -d), Vector3(-w, 0, -d), c1, c2)
	v.append_array([Vector3(w, 0, d), Vector3(w, 0, -d), c2])
	v.append_array([Vector3(-w, 0, -d), Vector3(-w, 0, d), c1])
	return poligonos(v, Vector3(0, -alto, 0))


## Tejado a dos aguas con la cumbrera a lo largo de X, con los hastiales
## (los triángulos de pared de los lados) incluidos.
static func tejado_dos_aguas(ancho: float, fondo: float, alto: float) -> ArrayMesh:
	var w := ancho * 0.5
	var d := fondo * 0.5
	var v := PackedVector3Array()
	_quad(v, Vector3(-w, 0, d), Vector3(w, 0, d), Vector3(w, alto, 0), Vector3(-w, alto, 0))
	_quad(v, Vector3(w, 0, -d), Vector3(-w, 0, -d), Vector3(-w, alto, 0), Vector3(w, alto, 0))
	return poligonos(v, Vector3(0, -alto, 0))


## Hastial (triángulo de pared) en el plano X = 0, para cerrar un tejado a dos aguas.
static func hastial(fondo: float, alto: float) -> ArrayMesh:
	var d := fondo * 0.5
	var v := PackedVector3Array([Vector3(0, 0, -d), Vector3(0, 0, d), Vector3(0, alto, 0)])
	var am := poligonos(v, Vector3(-1, 0, 0))
	return am


## Pasto: matas de hojas en cruz repartidas por `area` (XZ), saltándose los
## rectángulos de `excluir`. Se mueve con el viento (shaders/pasto.gdshader).
static func pasto(padre: Node3D, area: Rect2, densidad: float, alto: float, color_a: Color, color_b: Color, excluir: Array[Rect2], semilla: int, excluir_dentro: Rect2 = Rect2()) -> MultiMeshInstance3D:
	var rng := RandomNumberGenerator.new()
	rng.seed = semilla
	var cantidad := int(area.get_area() * densidad)
	var transformadas: Array[Transform3D] = []
	var colores: Array[Color] = []
	for i in cantidad:
		var p := Vector2(rng.randf_range(area.position.x, area.end.x), rng.randf_range(area.position.y, area.end.y))
		if excluir_dentro.has_area() and excluir_dentro.has_point(p):
			continue
		var fuera := false
		for r in excluir:
			if r.has_point(p):
				fuera = true
				break
		if fuera:
			continue
		var esc := rng.randf_range(0.6, 1.3)
		var b := Basis(Vector3.UP, rng.randf() * TAU).scaled(Vector3(esc, esc * alto * rng.randf_range(0.7, 1.3), esc))
		transformadas.append(Transform3D(b, Vector3(p.x, 0.0, p.y)))
		colores.append(color_a.lerp(color_b, rng.randf()))
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.use_colors = true
	mm.mesh = _mata_pasto()
	mm.instance_count = transformadas.size()
	for i in transformadas.size():
		mm.set_instance_transform(i, transformadas[i])
		mm.set_instance_color(i, colores[i])
	var mmi := MultiMeshInstance3D.new()
	mmi.multimesh = mm
	mmi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	var mat := ShaderMaterial.new()
	mat.shader = SHADER_PASTO
	mmi.material_override = mat
	padre.add_child(mmi)
	return mmi


## Tres hojas finas en abanico, de 1 m de alto (se escala por instancia).
static func _mata_pasto() -> ArrayMesh:
	var v := PackedVector3Array()
	var uv := PackedVector2Array()
	for i in 3:
		var ang := TAU * i / 3.0
		var lado := Vector3(cos(ang), 0, sin(ang)) * 0.035
		var punta := Vector3(cos(ang + 1.2), 0, sin(ang + 1.2)) * 0.08 + Vector3(0, 1, 0)
		v.append_array([-lado, lado, punta])
		uv.append_array([Vector2(0, 0), Vector2(1, 0), Vector2(0.5, 1)])
	var n := PackedVector3Array()
	n.resize(v.size())
	n.fill(Vector3.UP)
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = v
	arrays[Mesh.ARRAY_NORMAL] = n
	arrays[Mesh.ARRAY_TEX_UV] = uv
	var am := ArrayMesh.new()
	am.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	return am


## Muchas copias de una misma malla con color propio (matas, flores, piedras).
static func multi(padre: Node3D, mesh: Mesh, transformadas: Array[Transform3D], colores: Array[Color], sombra := true) -> MultiMeshInstance3D:
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.use_colors = true
	mm.mesh = mesh
	mm.instance_count = transformadas.size()
	for i in transformadas.size():
		mm.set_instance_transform(i, transformadas[i])
		mm.set_instance_color(i, colores[i])
	var mmi := MultiMeshInstance3D.new()
	mmi.multimesh = mm
	var mat := StandardMaterial3D.new()
	mat.vertex_color_use_as_albedo = true
	mat.roughness = 0.9
	mmi.material_override = mat
	if not sombra:
		mmi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	padre.add_child(mmi)
	return mmi


## Cadena colgante (guirnaldas, hamaca): puntos de una catenaria simple
## entre `a` y `b` que baja `flecha` metros en el centro.
static func curva_colgante(a: Vector3, b: Vector3, flecha: float, tramos: int) -> PackedVector3Array:
	var puntos := PackedVector3Array()
	for i in tramos + 1:
		var t := float(i) / tramos
		var p := a.lerp(b, t)
		p.y -= flecha * 4.0 * t * (1.0 - t)
		puntos.append(p)
	return puntos


## Barra fina de `a` a `b` (cables, hierros, varillas).
static func barra(padre: Node3D, a: Vector3, b: Vector3, grosor: float, color: Color, solida := false) -> MeshInstance3D:
	var largo := a.distance_to(b)
	var bm := BoxMesh.new()
	bm.size = Vector3(grosor, grosor, largo)
	var mi := MeshInstance3D.new()
	mi.mesh = bm
	mi.material_override = material(color)
	padre.add_child(mi)
	var medio := (a + b) * 0.5
	var arriba := Vector3.UP if absf((b - a).normalized().dot(Vector3.UP)) < 0.99 else Vector3.RIGHT
	mi.transform = Transform3D(Basis.looking_at(b - a, arriba), medio)
	if solida:
		var forma := BoxShape3D.new()
		forma.size = bm.size
		_cuerpo(mi, forma)
	return mi
