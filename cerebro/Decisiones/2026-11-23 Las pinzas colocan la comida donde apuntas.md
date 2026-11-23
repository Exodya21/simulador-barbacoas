---
tipo: decision
fecha: 2026-11-23
hora: 23:48
estado: aceptada
area: Diseño
actualizado: 2026-11-23 23:48
---

# Las pinzas colocan la comida donde apuntas

**Decisión:** la comida que llevas con las pinzas va al punto al que apuntas, sobre la superficie y hasta 1,8 m, y se queda ahí al soltar. Así se llega a cualquier casilla de la parrilla. La comida ya no se mueve hacia el jugador, no choca con nada mientras se lleva y al soltarla no conserva velocidad. Commit `0eb562b` en `dev`.

**Viene del primer playtest del usuario:**
- "Con la pinza no es posible poner la comida en las casillas interiores de la barbacoa, solo las que están al borde. Debería funcionar que, con la pinza cogiendo algo, donde esté apuntando, cuando se suelte tiene que ponerse en donde estaba apuntando."
- "Parece que cuando se le da 1 clic con la pinza a una comida sale disparada; eso no tiene que suceder."

**Causa del disparo:** al cogerla, la comida saltaba a la punta de las pinzas, a 40 cm de la cámara, y se metía en la cápsula del jugador. Al soltarla, la física la expulsaba.

**Completa a:** [[2026-11-23 Coger con clic mantenido]]

**Motivo:** con la comida en la punta de las pinzas solo se llegaba al borde de la parrilla, y además salía disparada.

**Alternativas descartadas:**
- Alargar las pinzas.
- Acercar al jugador.

Relacionado: [[Mecánicas]] · [[2026-11-23 Animación de salto al dar la vuelta]]
