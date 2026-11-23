class_name TipoAlimento
extends Resource
## Datos de un tipo de alimento: cómo se calienta y cuándo está en su punto.
## Se edita como .tres en datos/alimentos/ sin tocar código.

## Clave de traducción del nombre (ver idiomas/).
@export var nombre := "ALIMENTO_sin_nombre"

@export_group("Superficie")
## Por encima de esta temperatura (°C) la superficie empieza a dorarse.
@export var temperatura_dorado := 110.0
## A esta temperatura de superficie (°C) se avanza un grado de cocción
## cada `segundos_por_grado`.
@export var temperatura_referencia := 220.0
## Segundos para pasar de un grado al siguiente a la temperatura de referencia.
## Grados: 0 crudo · 1 sellado · 2 dorado · 3 pasado · 4 quemado.
@export var segundos_por_grado := 25.0
## Rapidez con la que la cara apoyada coge la temperatura de la rejilla (1/s).
@export var calentamiento := 0.5
## Rapidez con la que una cara al aire se enfría (1/s).
@export var enfriamiento := 0.15

@export_group("Interior")
## Temperatura del alimento al sacarlo de la nevera (°C).
@export var temperatura_inicial := 5.0
## Rapidez con la que el interior sigue a la superficie (1/s).
@export var conduccion := 0.008
## Peso de cada cara en el calor que llega al interior, en el orden de
## EstadoCoccion.Cara: arriba, abajo, derecha, izquierda, delante, detrás.
@export var peso_caras := PackedFloat32Array([0.45, 0.45, 0.025, 0.025, 0.025, 0.025])

@export_group("Punto interior (°C)")
@export var punto_poco_hecho := 52.0
@export var punto_al_punto := 60.0
@export var punto_hecho := 70.0
@export var punto_pasado := 77.0
