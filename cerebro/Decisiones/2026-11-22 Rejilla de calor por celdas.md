---
tipo: decision
fecha: 2026-11-22
hora: 22:24
estado: aceptada
area: Técnico
actualizado: 2026-11-22 22:24
---

# Rejilla de calor por celdas con brasas por celda

**Decisión:** la parrilla es una rejilla de 8×4 celdas (`RejillaCalor`, en `scripts/fuego/`). Cada celda tiene su cantidad de brasas y reparte un poco de calor a sus vecinas.
- La zona directa queda a la izquierda (~260 °C), luego una transición y la zona indirecta a la derecha (~100 °C). La indirecta no dora, pero sigue haciendo el interior.
- La altura de la rejilla cambia el calor; la manivela vendrá después.
- El metal tiene inercia térmica.

Commit `0a44ab6` en `dev`.

**Motivo:** en la F2 las brasas se podrán mover con la pala celda a celda, y las zonas directa e indirecta salen solas.

**Alternativas descartadas:**
- Dos zonas fijas: no deja repartir las brasas.
- Simular las partículas de las brasas: es demasiado para la F1.

Relacionado: [[Arquitectura]] · [[Mecánicas]] · [[Roadmap]] · [[2026-11-22 Cocción por caras con superficie e interior]]
