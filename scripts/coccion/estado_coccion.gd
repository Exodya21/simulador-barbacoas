class_name EstadoCoccion
extends RefCounted
## Lógica de cocción por caras, sin nodos (se puede probar sola).
##
## Cada cara tiene su temperatura de superficie y su grado de cocción.
## El interior se calienta despacio hacia la media de las caras, así que la
## pieza sigue haciéndose un poco después de retirarla del fuego.

enum Cara { ARRIBA, ABAJO, DERECHA, IZQUIERDA, DELANTE, DETRAS }

## Normal local de cada cara, en el orden de Cara.
const NORMALES: Array[Vector3] = [
	Vector3.UP, Vector3.DOWN, Vector3.RIGHT, Vector3.LEFT, Vector3.FORWARD, Vector3.BACK,
]
const NOMBRES_GRADO := ["crudo", "sellado", "dorado", "pasado", "quemado"]
## Una cara al aire tiende a la mezcla entre el aire y el interior.
const CALOR_INTERIOR_EN_CARA := 0.6

var tipo: TipoAlimento
var temperatura_superficie := PackedFloat32Array()
var grado := PackedFloat32Array()
var temperatura_interna: float


func _init(p_tipo: TipoAlimento) -> void:
	tipo = p_tipo
	temperatura_interna = tipo.temperatura_inicial
	temperatura_superficie.resize(6)
	temperatura_superficie.fill(tipo.temperatura_inicial)
	grado.resize(6)
	grado.fill(0.0)


## Avanza `dt` segundos. `cara_contacto` es la cara apoyada en la rejilla
## (-1 si no toca la rejilla) y `t_contacto` la temperatura de la rejilla ahí.
func avanzar(dt: float, cara_contacto: int, t_contacto: float, t_ambiente: float) -> void:
	var al_aire := lerpf(t_ambiente, temperatura_interna, CALOR_INTERIOR_EN_CARA)
	var objetivo_interior := 0.0
	var suma_pesos := 0.0
	for i in 6:
		var apoyada := i == cara_contacto
		var objetivo := t_contacto if apoyada else al_aire
		var rapidez := tipo.calentamiento if apoyada else tipo.enfriamiento
		temperatura_superficie[i] += (objetivo - temperatura_superficie[i]) * (1.0 - exp(-rapidez * dt))
		var exceso := temperatura_superficie[i] - tipo.temperatura_dorado
		if exceso > 0.0:
			var rango := tipo.temperatura_referencia - tipo.temperatura_dorado
			grado[i] += dt * (exceso / rango) / tipo.segundos_por_grado
		objetivo_interior += temperatura_superficie[i] * tipo.peso_caras[i]
		suma_pesos += tipo.peso_caras[i]
	objetivo_interior /= suma_pesos
	temperatura_interna += (objetivo_interior - temperatura_interna) * (1.0 - exp(-tipo.conduccion * dt))


## Nombre del estado de una cara: crudo, sellado, dorado, pasado o quemado.
func estado_cara(cara: int) -> String:
	return NOMBRES_GRADO[clampi(floori(grado[cara]), 0, NOMBRES_GRADO.size() - 1)]


## Punto del interior según su temperatura.
func punto_interior() -> String:
	if temperatura_interna >= tipo.punto_pasado:
		return "muy hecho"
	if temperatura_interna >= tipo.punto_hecho:
		return "hecho"
	if temperatura_interna >= tipo.punto_al_punto:
		return "al punto"
	if temperatura_interna >= tipo.punto_poco_hecho:
		return "poco hecho"
	return "crudo"


## Grado medio de las cuatro caras laterales.
func grado_lados() -> float:
	return (grado[Cara.DERECHA] + grado[Cara.IZQUIERDA] + grado[Cara.DELANTE] + grado[Cara.DETRAS]) * 0.25
