extends Node
## Autoload Equipo: los utensilios que tiene el jugador.
## Por ahora solo el de limpieza: el trapo viejo, sucio y roto.
## Ruta de mejora (futuro, se comprarán): cepillo y mocho con balde,
## cada uno con su .tres en datos/limpieza/ y más rápido que el anterior.

signal limpieza_cambiada(utensilio: UtensilioLimpieza)

const TRAPO := preload("res://datos/limpieza/trapo.tres")

var limpieza: UtensilioLimpieza = TRAPO


func poner_limpieza(utensilio: UtensilioLimpieza) -> void:
	limpieza = utensilio
	limpieza_cambiada.emit(utensilio)
