class_name MinijuegoVuelta
extends RefCounted
## Lógica del minijuego de dar la vuelta (sin nodos, se puede probar sola).
##
## Una línea sube y baja por una barra (posición de 0 abajo a 1 arriba).
## En un punto aleatorio de la barra está la zona PERFECTA, y alrededor la
## zona BIEN. Al parar la línea:
## - PERFECTO: la comida da la vuelta perfecta.
## - BIEN: se cae de las pinzas; la probabilidad de caer del lado bueno va de
##   `probabilidad_max` (junto a la zona perfecta) a `probabilidad_min` (en el borde).
## - MAL: se cae al suelo.

enum Resultado { PERFECTO, BIEN, MAL }

## Ancho de la zona perfecta y de la zona bien (fracción de la barra).
var ancho_perfecto := 0.07
var ancho_bien := 0.30
## Barridos completos (abajo → arriba) por segundo.
var velocidad := 0.9
var probabilidad_max := 0.8
var probabilidad_min := 0.3

var centro := 0.5
var posicion := 0.0
var _sentido := 1.0
var _rng: RandomNumberGenerator


func _init(rng: RandomNumberGenerator = null) -> void:
	_rng = rng if rng else RandomNumberGenerator.new()
	if rng == null:
		_rng.randomize()
	empezar()


## Nueva ronda: zona perfecta en un sitio aleatorio y la línea abajo.
func empezar() -> void:
	var margen := ancho_bien * 0.5
	centro = _rng.randf_range(margen, 1.0 - margen)
	posicion = 0.0
	_sentido = 1.0


## Mueve la línea: sube hasta arriba, baja hasta abajo, y vuelta a empezar.
func avanzar(dt: float) -> void:
	posicion += _sentido * velocidad * dt
	while posicion > 1.0 or posicion < 0.0:
		if posicion > 1.0:
			posicion = 2.0 - posicion
		else:
			posicion = -posicion
		_sentido = -_sentido


func resultado(pos: float = posicion) -> Resultado:
	var distancia := absf(pos - centro)
	if distancia <= ancho_perfecto * 0.5:
		return Resultado.PERFECTO
	if distancia <= ancho_bien * 0.5:
		return Resultado.BIEN
	return Resultado.MAL


## Probabilidad de caer del lado bueno con un resultado BIEN en `pos`.
func probabilidad_vuelta(pos: float = posicion) -> float:
	match resultado(pos):
		Resultado.PERFECTO:
			return 1.0
		Resultado.MAL:
			return 0.0
	var distancia := absf(pos - centro)
	var t := inverse_lerp(ancho_perfecto * 0.5, ancho_bien * 0.5, distancia)
	return lerpf(probabilidad_max, probabilidad_min, clampf(t, 0.0, 1.0))


## Tira el dado: true si la comida acaba dada la vuelta.
func sale_dada_la_vuelta(pos: float = posicion) -> bool:
	return _rng.randf() < probabilidad_vuelta(pos)
