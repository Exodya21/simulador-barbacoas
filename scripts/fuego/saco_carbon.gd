class_name SacoCarbon
extends CogitoObject
## Saco de carbón. La chimenea de encendido se llena a su lado (F con la
## chimenea cerca, o F en la chimenea junto al saco).
## Va en el nodo raíz (StaticBody3D) de escenas/fuego/saco_carbon.tscn.

const GRUPO := "saco_carbon"


func _ready() -> void:
	super()
	add_to_group(GRUPO)


## Llamado por la BasicInteraction (F): llena la chimenea vacía más cercana.
func interact(player_interaction_component = null) -> void:
	for nodo in get_tree().get_nodes_in_group(ChimeneaEncendido.GRUPO):
		var chimenea := nodo as ChimeneaEncendido
		if chimenea and chimenea.estado == ChimeneaEncendido.Estado.VACIA \
				and chimenea.global_position.distance_to(global_position) <= chimenea.distancia_saco:
			chimenea.llenar()
			return
	if player_interaction_component and player_interaction_component.has_method("send_hint"):
		player_interaction_component.send_hint(null, tr("SACO_trae_chimenea"))
