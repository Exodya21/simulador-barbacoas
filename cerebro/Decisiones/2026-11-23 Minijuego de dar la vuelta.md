---
tipo: decision
fecha: 2026-11-23
hora: 22:45
estado: aceptada
area: Diseño
actualizado: 2026-11-23 23:49
---

# Minijuego de dar la vuelta

**Decisión:** dar la vuelta a la comida es un minijuego de precisión y solo se hace con las pinzas. Lo pidió el usuario: "un minijuego de precisión con una barra que tenga una línea que va subiendo y bajando, y que el punto exacto para dar una vuelta perfecta sea aleatorio en la barra". Commit `3dfc4cf` en `dev`.

**Cómo se juega:**
- Con la comida cogida y el clic izquierdo mantenido, un clic derecho abre la barra. Al soltar el clic izquierdo, la línea se para.
- La línea va y viene por la barra a 0,9 barridos por segundo.
- La zona perfecta ocupa el 7 % de la barra y la zona bien el 30 %. Su centro es aleatorio en cada ronda.
- La barra sale a la derecha de la pantalla: zona verde (perfecto), zona amarilla (bien) y línea blanca. Debajo aparece el aviso "Suelta el clic izquierdo para dar la vuelta". Al terminar, el resultado se enseña en grande un momento.

**Resultados:**
- **Perfecto:** vuelta perfecta en el sitio.
- **Bien:** la comida se escurre de las pinzas con un bamboleo. Cae del lado bueno o del mismo lado, según una probabilidad que depende de lo cerca que quedes del perfecto: 80 % junto a la zona perfecta y 30 % en el borde.
- **Mal:** sale despedida hacia un lado y hacia el jugador, y acaba en el suelo.

**Código:**
- `MinijuegoVuelta` (`scripts/utensilios/minijuego_vuelta.gd`) es la lógica pura.
- `BarraMinijuego` (`scripts/utensilios/barra_minijuego.gd`) es la barra en pantalla.
- `Voltear` sigue siendo la lógica común de dar la vuelta.
- Los textos están en español, inglés y alemán.
- Pruebas: `test_minijuego` (62 comprobaciones) y `test_pinzas` (63). Todas pasan.

**Sustituye a:** [[2026-11-22 Dar la vuelta con interacción propia]] (se quitan la tecla F y `voltear_interaccion.gd`) y, en lo que toca a dar la vuelta, a [[2026-11-23 Controles de las pinzas]].

**Motivo:** lo pidió el usuario, y da tensión y habilidad a la acción central de la F1.

**Alternativas descartadas:**
- La vuelta instantánea.
- Una probabilidad fija del 50 % o del 70 % con "bien": el usuario eligió la que depende de la distancia.

**Completada por:** [[2026-11-23 Animación de salto al dar la vuelta]]

Relacionado: [[Mecánicas]] · [[Roadmap]] · [[2026-11-23 Coger con clic mantenido]] · [[Comida en el suelo y dificultad del minijuego]]
