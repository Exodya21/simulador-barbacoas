class_name SacoCarbon
extends CogitoObject
## Saco de carbón. Llena la chimenea de encendido: la del cinturón o una
## suelta cerca del saco (F en el saco, o clic con la chimenea en la mano
## estando al lado). La pala también coge carbón crudo de aquí.
## Va en el nodo raíz (StaticBody3D) de escenas/fuego/saco_carbon.tscn.

const GRUPO := "saco_carbon"
## Distancia máxima (m) a la que llena una chimenea suelta.
const ALCANCE_SUELTA := 2.5


func _ready() -> void:
	super()
	add_to_group(GRUPO)


## Llamado por la BasicInteraction (F): llena la chimenea si está vacía.
func interact(player_interaction_component = null) -> void:
	var clave := "SACO_sin_chimenea"
	for nodo in get_tree().get_nodes_in_group(ChimeneaEncendido.GRUPO_CHIMENEA):
		var chimenea := nodo as ChimeneaEncendido
		if chimenea == null:
			continue
		if chimenea.suelto and chimenea.global_position.distance_to(global_position) > ALCANCE_SUELTA:
			continue
		if chimenea.estado == ChimeneaEncendido.Estado.VACIA:
			chimenea.llenar()
			return
		clave = "SACO_chimenea_no_vacia"
	if player_interaction_component and player_interaction_component.has_method("send_hint"):
		player_interaction_component.send_hint(null, tr(clave))
