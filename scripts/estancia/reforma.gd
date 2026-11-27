class_name Reforma
extends Resource
## Una reforma de la estancia del abuelo: qué zona arregla, cuánto cuesta y
## qué hay que haber hecho antes. Se edita como .tres en datos/estancia/.

## Zona que reforma (nodo hijo de Estancia con el mismo nombre).
@export var id: StringName
## Clave de traducción del nombre (REFORMA_<id> en idiomas/).
@export var nombre := ""
## Precio en pesos.
@export var coste := 0
## Reformas que tienen que estar hechas antes.
@export var requiere: Array[StringName] = []
