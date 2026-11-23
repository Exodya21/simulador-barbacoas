---
tipo: decision
fecha: 2026-11-23
hora: 23:02
estado: aceptada
area: Técnico
actualizado: 2026-11-23 23:02
---

# Resbalar bajando el agarre de Cogito sin parchearlo

**Decisión:** al pisar una mancha de grasa, `Resbalar` baja el agarre del jugador de Cogito (`LERP_SPEED` de 10 a 1,2) y lo devuelve al salir. Funciona con varias manchas solapadas. El código de Cogito no se toca. Commit `5ab9c91` en `dev`.

**Motivo:** no tocar el código de Cogito.

**Alternativas descartadas:**
- Empujar al jugador con fuerzas.
- Parchear el controlador del jugador de Cogito.

Relacionado: [[2026-11-23 Comida caída al suelo sucia, mancha y basura]] · [[2026-11-22 Cogito como base del proyecto]] · [[Arquitectura]]
