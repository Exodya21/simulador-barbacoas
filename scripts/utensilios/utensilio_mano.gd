class_name UtensilioMano
extends Node3D
## Base de los utensilios que van en el cinturón y se cogen con la mano
## derecha (pinzas, abanico, trapo, chimenea de encendido, pala, magiclick).
##
## Al empezar se cuelga de la cámara del jugador. Solo está `activo` (visible y
## respondiendo a los controles) cuando el autoload Cinturon lo tiene en la
## mano. Cada utensilio usa el clic izquierdo a su manera.
##
## Con **G** (acción `soltar_utensilio`) se suelta el de la mano: cae al suelo
## como objeto y su hueco queda libre. Con **F** encima se recoge al hueco
## seleccionado si está libre (si no, al primero libre). Así se colocan los
## utensilios en el orden que quiera el jugador. Con `empezar_suelto` el
## utensilio empieza en el mundo, donde esté colocado en la escena.

const GRUPO_UTENSILIOS := "utensilio_mano"
const ESCENA_INTERACCION := "res://addons/cogito/Components/Interactions/BasicInteraction.tscn"
const SCRIPT_SUELTO := "res://scripts/utensilios/utensilio_suelto.gd"

## Id del utensilio en el cinturón (Cinturon.huecos).
@export var id: StringName
## Posición y giro respecto a la cámara (abajo a la derecha).
@export var posicion_en_camara := Vector3(0.14, -0.16, -0.10)
@export var giro_en_camara := Vector3(10.0, 6.0, 0.0)
@export_group("Agarre de la mano derecha")
## Punto que rodea el puño, en coordenadas del utensilio.
@export var punto_agarre := Vector3.ZERO
## Dirección del mango dentro del puño (hacia el pulgar), en coordenadas del
## utensilio.
@export var eje_agarre := Vector3.UP
## Hacia dónde sale el antebrazo, en coordenadas de la cámara.
@export var brazo_agarre := Vector3(0.35, -0.6, 1.0)
@export_group("")
## Empieza tirado en el mundo en vez de en el cinturón.
@export var empezar_suelto := false

var activo := false
## True mientras está tirado en el mundo (fuera del cinturón).
var suelto := false
## Cuerpo físico mientras está suelto.
var cuerpo_suelto: RigidBody3D
var _camara: Camera3D


func _ready() -> void:
	add_to_group(GRUPO_UTENSILIOS)
	var cinturon := get_node_or_null("/root/Cinturon")
	if cinturon:
		cinturon.cambiado.connect(func(_i: int) -> void: _actualizar())
	if empezar_suelto:
		suelto = true
		_dejar_en_mundo.call_deferred(global_transform, Vector3.ZERO)
	else:
		_montar_en_camara.call_deferred()
	_actualizar()


func _montar_en_camara() -> void:
	_camara = get_viewport().get_camera_3d()
	if _camara == null:
		return
	reparent(_camara, false)
	position = posicion_en_camara
	rotation_degrees = giro_en_camara


func _actualizar() -> void:
	var cinturon := get_node_or_null("/root/Cinturon")
	var ahora: bool = not suelto and (cinturon == null or cinturon.tiene_en_mano(id))
	visible = ahora or suelto
	if ahora != activo:
		activo = ahora
		al_cambiar_mano(activo)


## Se llama al sacarlo a la mano (true) o al guardarlo o soltarlo (false).
func al_cambiar_mano(_en_mano: bool) -> void:
	pass


## Transformación de la mano derecha que lo agarra, en coordenadas del padre
## del utensilio (la cámara): el eje Y es el mango y el Z el antebrazo.
func transform_mano() -> Transform3D:
	var y := (transform.basis * eje_agarre).normalized()
	var z := brazo_agarre - y * brazo_agarre.dot(y)
	if z.length_squared() < 0.0001:
		z = Vector3.BACK - y * y.z
	z = z.normalized()
	return Transform3D(Basis(y.cross(z), y, z), transform * punto_agarre)


func _unhandled_input(evento: InputEvent) -> void:
	if activo and InputMap.has_action("soltar_utensilio") and evento.is_action_pressed("soltar_utensilio"):
		soltar_al_suelo()
		get_viewport().set_input_as_handled()


## Suelta el utensilio de la mano: cae delante del jugador y su hueco del
## cinturón queda libre.
func soltar_al_suelo() -> bool:
	if suelto:
		return false
	var camara := _camara_actual()
	var donde := global_transform
	var empuje := Vector3.ZERO
	if camara:
		donde.origin = camara.global_position - camara.global_basis.z * 0.55 + Vector3.DOWN * 0.15
		empuje = -camara.global_basis.z * 1.2
	suelto = true
	var cinturon := get_node_or_null("/root/Cinturon")
	if cinturon:
		cinturon.quitar(id)
	_actualizar()
	_dejar_en_mundo(donde, empuje)
	return true


## Lo recoge del mundo al cinturón y a la mano. False si no hay hueco.
func recoger() -> bool:
	if not suelto:
		return false
	var cinturon := get_node_or_null("/root/Cinturon")
	if cinturon and cinturon.guardar(id) == cinturon.NINGUNO:
		avisar("CINTURON_lleno")
		return false
	var cuerpo := cuerpo_suelto
	suelto = false
	cuerpo_suelto = null
	_montar_en_camara()
	if cuerpo:
		cuerpo.queue_free()
	_actualizar()
	return true


func _dejar_en_mundo(donde: Transform3D, empuje: Vector3) -> void:
	var escena := get_tree().current_scene
	if escena == null:
		return
	var cuerpo := RigidBody3D.new()
	cuerpo.name = "%sSuelto" % String(id).capitalize()
	cuerpo.set_script(load(SCRIPT_SUELTO))
	cuerpo.set("utensilio", self)
	cuerpo.set("display_name", "CINTURON_%s" % id)
	cuerpo.collision_layer = 1 << 1
	cuerpo.collision_mask = (1 << 0) | (1 << 1)
	cuerpo.mass = 0.6
	cuerpo.continuous_cd = true
	var caja := _caja_modelo()
	var forma := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = caja.size.max(Vector3.ONE * 0.04)
	forma.shape = shape
	forma.position = caja.get_center()
	cuerpo.add_child(forma)
	var interaccion: Node = load(ESCENA_INTERACCION).instantiate()
	interaccion.set("interaction_text", "UTENSILIO_recoger")
	cuerpo.add_child(interaccion)
	escena.add_child(cuerpo)
	cuerpo.global_transform = donde.orthonormalized()
	cuerpo.linear_velocity = empuje
	cuerpo_suelto = cuerpo
	_camara = null
	if get_parent():
		reparent(cuerpo, false)
	else:
		cuerpo.add_child(self)
	transform = Transform3D.IDENTITY
	visible = true


## Caja que envuelve todas las mallas del utensilio, en sus coordenadas.
func _caja_modelo() -> AABB:
	var caja := AABB()
	var primera := true
	for malla in find_children("*", "MeshInstance3D", true, false):
		var mi := malla as MeshInstance3D
		if mi.mesh == null:
			continue
		var relativo := _relativo_a_mi(mi)
		var trozo := relativo * mi.mesh.get_aabb()
		caja = trozo if primera else caja.merge(trozo)
		primera = false
	if primera:
		caja = AABB(Vector3(-0.05, -0.05, -0.05), Vector3(0.1, 0.1, 0.1))
	return caja


func _relativo_a_mi(nodo: Node3D) -> Transform3D:
	var t := Transform3D.IDENTITY
	var n: Node = nodo
	while n != null and n != self:
		if n is Node3D:
			t = (n as Node3D).transform * t
		n = n.get_parent()
	return t


func _camara_actual() -> Camera3D:
	return _camara if _camara else get_viewport().get_camera_3d()


## Choque del rayo que sale del centro de la pantalla, hasta `alcance` metros.
func rayo_mira(alcance: float, mascara: int, excluir: Array[RID] = []) -> Dictionary:
	var camara := _camara_actual()
	if camara == null:
		return {}
	var origen := camara.global_position
	var consulta := PhysicsRayQueryParameters3D.create(origen, origen - camara.global_basis.z * alcance, mascara)
	consulta.exclude = excluir
	return get_world_3d().direct_space_state.intersect_ray(consulta)


## Rejilla de calor sobre la que cae un punto (a menos de `margen` m), o null.
func rejilla_en(punto: Vector3, margen := 0.15) -> RejillaCalor:
	for nodo in get_tree().get_nodes_in_group(RejillaCalor.GRUPO):
		var rejilla := nodo as RejillaCalor
		if rejilla and rejilla.esta_sobre(punto, margen):
			return rejilla
	return null


## True si el jugador lleva algo cogido con E (Cogito usa el clic para lanzarlo).
func jugador_lleva_algo() -> bool:
	if _camara == null:
		return false
	for nodo in get_tree().get_nodes_in_group("Player"):
		var componente := nodo.find_child("PlayerInteractionComponent", true, false)
		if componente and componente.get("is_carrying"):
			return true
	return false


## Aviso abajo a la izquierda, como los de Cogito.
func avisar(clave: String) -> void:
	var jugador := get_tree().get_first_node_in_group("Player")
	var pic = jugador.get("player_interaction_component") if jugador else null
	if pic and pic.has_method("send_hint"):
		pic.send_hint(null, tr(clave))
