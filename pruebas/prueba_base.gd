class_name PruebaBase
extends SceneTree
## Base de las pruebas headless: lleva la cuenta de fallos y sale con código 1
## si alguno falla. Cada prueba extiende esta clase y define `_ejecutar()`.

var fallos := 0
var comprobaciones := 0


func _initialize() -> void:
	await _ejecutar()
	var nombre: String = get_script().resource_path.get_file()
	if fallos > 0:
		printerr("PRUEBA FALLA: %s · %d de %d comprobaciones fallidas" % [nombre, fallos, comprobaciones])
		quit(1)
	else:
		print("PRUEBA OK: %s · %d comprobaciones" % [nombre, comprobaciones])
		quit(0)


func _ejecutar() -> void:
	pass


func comprobar(condicion: bool, mensaje: String) -> void:
	comprobaciones += 1
	if not condicion:
		fallos += 1
		printerr("  ✗ " + mensaje)
