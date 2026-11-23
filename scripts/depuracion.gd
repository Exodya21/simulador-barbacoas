extends Node
## Autoload Depuracion: activa o desactiva los valores de depuración con F3.
## En las versiones de desarrollo empieza activada (prototipo de la F1).

signal cambiado(activa: bool)

var activa: bool = OS.is_debug_build()


func _unhandled_input(evento: InputEvent) -> void:
	var tecla := evento as InputEventKey
	if tecla and tecla.pressed and not tecla.echo and tecla.keycode == KEY_F3:
		alternar()


func alternar() -> void:
	activa = not activa
	cambiado.emit(activa)
