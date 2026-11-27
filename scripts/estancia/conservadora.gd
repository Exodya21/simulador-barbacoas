extends CogitoObject
## Conservadora con hielo: pulsando F se compra una pieza cruda (se paga con
## el dinero de la Herencia) y aparece encima, lista para la parrilla.

const HERENCIA := preload("res://scripts/estancia/herencia.gd")

## Lo que se compra (de momento, solo hamburguesas).
@export var alimento: PackedScene = preload("res://escenas/alimentos/hamburguesa.tscn")
@export var tipo: TipoAlimento = preload("res://datos/alimentos/hamburguesa.tres")

var _aviso: Label3D
@onready var _comprar: Node = $Comprar


func _ready() -> void:
	super()
	Geo.caja(self, Vector3(0.75, 0.42, 0.46), Vector3(0, 0.21, 0), Color("2f6fa3"), Vector3.ZERO, false)
	Geo.caja(self, Vector3(0.78, 0.09, 0.49), Vector3(0, 0.46, 0), Color("f4f1ea"), Vector3.ZERO, false)
	Geo.caja(self, Vector3(0.4, 0.04, 0.06), Vector3(0, 0.53, 0), Color("f4f1ea"), Vector3.ZERO, false)
	_aviso = Label3D.new()
	_aviso.position = Vector3(0, 0.9, 0)
	_aviso.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	_aviso.no_depth_test = true
	_aviso.fixed_size = true
	_aviso.pixel_size = 0.001
	_aviso.font_size = 40
	_aviso.outline_size = 10
	_aviso.visible = false
	add_child(_aviso)
	_comprar.interaction_text = tr("INTERACT_comprar") % [tr(tipo.nombre), HERENCIA.formatear(tipo.coste_compra)]


## Lo llama el BasicInteraction al pulsar F.
func interact(_player_interaction_component = null) -> void:
	var h := get_node_or_null("/root/Herencia")
	if h == null or not h.gastar(tipo.coste_compra):
		_avisar(tr("AVISO_sin_dinero_carne"))
		return
	comprar()


## Saca una pieza cruda encima de la conservadora.
func comprar() -> RigidBody3D:
	var pieza := alimento.instantiate() as RigidBody3D
	get_parent().add_child(pieza)
	pieza.global_position = global_position + Vector3(0, 0.75, 0)
	return pieza


func _avisar(texto: String) -> void:
	_aviso.text = texto
	_aviso.visible = true
	await get_tree().create_timer(1.6).timeout
	if is_instance_valid(_aviso):
		_aviso.visible = false
