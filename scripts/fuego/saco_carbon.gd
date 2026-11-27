class_name SacoCarbon
extends CogitoObject
## Saco de carbón. Llena la chimenea de encendido del cinturón: F en el saco,
## o clic con la chimenea en la mano estando al lado.
## Va en el nodo raíz (StaticBody3D) de escenas/fuego/saco_carbon.tscn.

const GRUPO := "saco_carbon"


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
		if chimenea.estado == ChimeneaEncendido.Estado.VACIA:
			chimenea.llenar()
			return
		clave = "SACO_chimenea_no_vacia"
	if player_interaction_component and player_interaction_component.has_method("send_hint"):
		player_interaction_component.send_hint(null, tr(clave))
