extends Node
## Autoload Depuracion: activa o desactiva los valores de depuración con F3.
## Empieza apagada: los números (temperaturas, caras de la comida, rejilla)
## solo se ven al pulsar F3.

signal cambiado(activa: bool)

var activa := false


func _unhandled_input(evento: InputEvent) -> void:
	var tecla := evento as InputEventKey
	if tecla and tecla.pressed and not tecla.echo and tecla.keycode == KEY_F3:
		alternar()


func alternar() -> void:
	activa = not activa
	cambiado.emit(activa)
