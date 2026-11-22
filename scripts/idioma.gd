extends Node
## Autoload: el juego arranca en español.
## Si el jugador ya eligió idioma en Opciones (user://language.cfg, lo escribe
## el selector de Cogito), se respeta su elección.

const IDIOMA_POR_DEFECTO := "es"
const ARCHIVO := "user://language.cfg"


func _ready() -> void:
	var codigo := IDIOMA_POR_DEFECTO
	if FileAccess.file_exists(ARCHIVO):
		var guardado := FileAccess.get_file_as_string(ARCHIVO).strip_edges()
		if not guardado.is_empty():
			codigo = guardado
	else:
		var archivo := FileAccess.open(ARCHIVO, FileAccess.WRITE)
		if archivo:
			archivo.store_line(codigo)
	TranslationServer.set_locale(codigo)
