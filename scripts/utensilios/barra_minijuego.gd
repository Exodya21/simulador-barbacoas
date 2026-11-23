class_name BarraMinijuego
extends Control
## Barra vertical del minijuego de dar la vuelta. Dibuja la zona BIEN, la
## zona PERFECTA y la línea que sube y baja, y enseña el resultado un momento.
## Solo pinta: la lógica está en MinijuegoVuelta y la maneja Pinzas.

const COLOR_FONDO := Color(0.17, 0.16, 0.18, 0.85)      # Paleta.CARBON
const COLOR_BIEN := Color(0.96, 0.75, 0.29, 0.9)        # Paleta.LLAMA
const COLOR_PERFECTO := Color(0.44, 0.64, 0.29, 1.0)    # Paleta.CESPED
const COLOR_LINEA := Color(1, 1, 1, 1)
const COLOR_BORDE := Color(0.95, 0.9, 0.81, 1.0)        # Paleta.MANTEL

var minijuego: MinijuegoVuelta

@onready var _barra: Control = $Barra
@onready var _aviso: Label = $Aviso
@onready var _resultado: Label = $Resultado


func _ready() -> void:
	_barra.draw.connect(_pintar_barra)
	_resultado.visible = false
	cerrar()


func abrir(p_minijuego: MinijuegoVuelta) -> void:
	minijuego = p_minijuego
	_barra.visible = true
	_aviso.visible = true
	_resultado.visible = false


func cerrar() -> void:
	_barra.visible = false
	_aviso.visible = false


## Enseña el texto del resultado durante `segundos`.
func mostrar_resultado(texto: String, color: Color, segundos := 1.2) -> void:
	_resultado.text = texto
	_resultado.modulate = color
	_resultado.visible = true
	await get_tree().create_timer(segundos).timeout
	if is_instance_valid(_resultado):
		_resultado.visible = false


func _process(_delta: float) -> void:
	if _barra.visible:
		_barra.queue_redraw()


func _pintar_barra() -> void:
	if minijuego == null:
		return
	var r := Rect2(Vector2.ZERO, _barra.size)
	_barra.draw_rect(r, COLOR_FONDO)
	_barra.draw_rect(_zona(minijuego.ancho_bien), COLOR_BIEN)
	_barra.draw_rect(_zona(minijuego.ancho_perfecto), COLOR_PERFECTO)
	var y := _y(minijuego.posicion)
	_barra.draw_line(Vector2(-8, y), Vector2(r.size.x + 8, y), COLOR_LINEA, 4.0)
	_barra.draw_rect(r, COLOR_BORDE, false, 3.0)


func _zona(ancho: float) -> Rect2:
	var arriba := _y(minijuego.centro + ancho * 0.5)
	var abajo := _y(minijuego.centro - ancho * 0.5)
	return Rect2(0, arriba, _barra.size.x, abajo - arriba)


## La posición 0 es abajo del todo y 1 arriba del todo.
func _y(posicion: float) -> float:
	return _barra.size.y * (1.0 - clampf(posicion, 0.0, 1.0))
