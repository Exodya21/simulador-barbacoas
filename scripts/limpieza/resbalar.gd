class_name Resbalar
extends RefCounted
## Hace resbalar al jugador de Cogito mientras pisa una o más manchas.
##
## El jugador avanzado de Cogito acelera y frena con `LERP_SPEED` (y su copia
## `current_lerp_speed`). Al pisar una mancha se baja; al salir de la última
## se devuelve el valor original. Se guarda en metadatos del jugador para que
## varias manchas solapadas no se pisen entre ellas.

const META_CUENTA := "manchas_pisadas"
const META_ORIGINAL := "agarre_original"


static func entrar(jugador: Node, agarre: float) -> void:
	if not "LERP_SPEED" in jugador:
		return
	var cuenta: int = jugador.get_meta(META_CUENTA, 0)
	if cuenta == 0:
		jugador.set_meta(META_ORIGINAL, jugador.LERP_SPEED)
	jugador.set_meta(META_CUENTA, cuenta + 1)
	jugador.LERP_SPEED = agarre
	if "current_lerp_speed" in jugador:
		jugador.current_lerp_speed = agarre


static func salir(jugador: Node) -> void:
	if not jugador.has_meta(META_CUENTA):
		return
	var cuenta: int = jugador.get_meta(META_CUENTA) - 1
	if cuenta > 0:
		jugador.set_meta(META_CUENTA, cuenta)
		return
	var original: float = jugador.get_meta(META_ORIGINAL, 10.0)
	jugador.remove_meta(META_CUENTA)
	jugador.remove_meta(META_ORIGINAL)
	jugador.LERP_SPEED = original
	if "current_lerp_speed" in jugador:
		jugador.current_lerp_speed = original


static func resbalando(jugador: Node) -> bool:
	return jugador.has_meta(META_CUENTA)
