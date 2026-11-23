extends PruebaBase
## Lógica del minijuego de dar la vuelta (MinijuegoVuelta).

const R := MinijuegoVuelta.Resultado


func _ejecutar() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 1234

	# La zona perfecta cae en un sitio aleatorio, siempre dentro de la barra.
	var centros := {}
	for i in 50:
		var m := MinijuegoVuelta.new(rng)
		comprobar(m.centro - m.ancho_bien * 0.5 >= 0.0 and m.centro + m.ancho_bien * 0.5 <= 1.0, "la zona bien cabe entera en la barra (centro %.2f)" % m.centro)
		centros[snappedf(m.centro, 0.05)] = true
	comprobar(centros.size() >= 6, "la zona perfecta no sale siempre en el mismo sitio (%d sitios)" % centros.size())

	# La línea sube y baja sin salirse.
	var m := MinijuegoVuelta.new(rng)
	var minimo := 1.0
	var maximo := 0.0
	var subio := false
	var bajo := false
	var anterior := m.posicion
	for i in 600:
		m.avanzar(1.0 / 60.0)
		minimo = minf(minimo, m.posicion)
		maximo = maxf(maximo, m.posicion)
		subio = subio or m.posicion > anterior
		bajo = bajo or m.posicion < anterior
		anterior = m.posicion
	comprobar(minimo >= 0.0 and maximo <= 1.0, "la línea no se sale de la barra")
	comprobar(subio and bajo and maximo > 0.95, "la línea sube hasta arriba y vuelve a bajar")

	# Resultados según dónde se pare.
	m.centro = 0.5
	comprobar(m.resultado(0.5) == R.PERFECTO, "en el centro de la zona: perfecto")
	comprobar(m.resultado(0.5 + m.ancho_perfecto * 0.4) == R.PERFECTO, "dentro de la zona perfecta: perfecto")
	comprobar(m.resultado(0.5 + m.ancho_bien * 0.4) == R.BIEN, "fuera de la perfecta pero cerca: bien")
	comprobar(m.resultado(0.95) == R.MAL, "lejos: mal")
	comprobar(m.resultado(0.05) == R.MAL, "lejos por abajo: mal")

	# Probabilidad de caer del lado bueno con "bien": más cerca, más probable.
	var cerca := m.probabilidad_vuelta(0.5 + m.ancho_perfecto * 0.6)
	var lejos := m.probabilidad_vuelta(0.5 + m.ancho_bien * 0.49)
	comprobar(cerca > lejos, "más cerca del perfecto, más probabilidad (%.2f > %.2f)" % [cerca, lejos])
	comprobar(cerca <= m.probabilidad_max and lejos >= m.probabilidad_min, "la probabilidad va entre el mínimo y el máximo")
	comprobar(m.probabilidad_vuelta(0.5) == 1.0 and m.probabilidad_vuelta(0.95) == 0.0, "perfecto siempre da la vuelta; mal nunca")

	# La tirada respeta la probabilidad (aprox.).
	var aciertos := 0
	var pos := 0.5 + m.ancho_bien * 0.3
	var p := m.probabilidad_vuelta(pos)
	for i in 2000:
		if m.sale_dada_la_vuelta(pos):
			aciertos += 1
	comprobar(absf(aciertos / 2000.0 - p) < 0.05, "la tirada sale del lado bueno ~%.0f %% de las veces (%.0f %%)" % [p * 100, aciertos / 20.0])
