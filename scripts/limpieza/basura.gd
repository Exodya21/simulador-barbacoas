extends StaticBody3D
## Cubo de basura: la comida que entra por arriba desaparece.
## Así se elimina la comida sucia (la que ha caído al suelo).

signal comida_tirada(cuerpo: RigidBody3D, estaba_sucia: bool)

@onready var _boca: Area3D = $Boca
@onready var _aviso: Label3D = $Aviso


func _ready() -> void:
	_boca.body_entered.connect(_al_entrar)
	_aviso.visible = false


func _al_entrar(cuerpo: Node3D) -> void:
	var comida := cuerpo as RigidBody3D
	if comida == null or not comida.has_node("Coccion"):
		return
	var suciedad := comida.get_node_or_null("Suciedad")
	var estaba_sucia: bool = suciedad != null and suciedad.sucia
	comida_tirada.emit(comida, estaba_sucia)
	comida.queue_free()
	_avisar()


func _avisar() -> void:
	_aviso.text = tr("BASURA_tirada")
	_aviso.visible = true
	await get_tree().create_timer(1.2).timeout
	if is_instance_valid(_aviso):
		_aviso.visible = false
