---
tipo: decision
fecha: 2026-11-23
hora: 23:48
estado: aceptada
area: Diseño
actualizado: 2026-11-23 23:50
---

# Solo mancha la comida que ha pasado por la parrilla encendida

**Decisión:** solo deja mancha de grasa al caer la comida que ha pasado por la parrilla encendida. `CoccionComponente.paso_por_parrilla` se activa al apoyar la comida en una rejilla a 80 °C o más. La comida cruda que cae se ensucia igual, pero no suelta grasa. Commit `0eb562b` en `dev`.

**Ajusta a:** [[2026-11-23 Comida caída al suelo sucia, mancha y basura]] (no la sustituye).

**Motivo:** lo pidió el usuario en el playtest: "Las comidas que no han pasado por la barbacoa encendida, si se caen al suelo, no deben mancharlo."

**Alternativas descartadas:**
- Que toda la comida que cae manche: la carne cruda casi no suelta grasa, así que no es creíble, y llenaría el suelo de manchas desde el primer minuto.
- Que la mancha dependa del grado de cocción (cuanto más hecha, más grasa): es más fino, pero de momento no hace falta. Queda como posible ajuste.

Relacionado: [[Mecánicas]] · [[2026-11-22 Rejilla de calor por celdas]]
