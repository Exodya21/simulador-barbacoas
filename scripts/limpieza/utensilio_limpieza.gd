class_name UtensilioLimpieza
extends Resource
## Un utensilio para limpiar manchas de grasa. Se edita como .tres en
## datos/limpieza/. Por defecto el jugador tiene el trapo viejo; más adelante
## se podrán comprar mejores (cepillo, mocho con balde) que limpian más rápido.

## Clave de traducción del nombre.
@export var nombre := "UTENSILIO_sin_nombre"
## Texto de la interacción al mirar una mancha (clave de traducción).
@export var texto_interaccion := "INTERACT_limpiar"
## Segundos que hay que mantener la tecla para limpiar una mancha.
@export var segundos_por_mancha := 4.0
## Modelo que aparece frotando la mancha mientras se limpia.
@export var modelo: PackedScene
## Radio (m) de los círculos que hace al frotar.
@export var radio_frotado := 0.08
