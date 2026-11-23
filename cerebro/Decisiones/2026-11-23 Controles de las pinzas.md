---
tipo: decision
fecha: 2026-11-23
hora: 22:25
estado: sustituida
area: Diseño
actualizado: 2026-11-23 22:46
---

# Controles de las pinzas: clic izquierdo coger o soltar, clic derecho dar la vuelta

**Sustituida por:** [[2026-11-23 Coger con clic mantenido]] (coger y soltar) · [[2026-11-23 Minijuego de dar la vuelta]] (dar la vuelta)

**Decisión:** las pinzas (`scripts/utensilios/pinzas.gd`, `escenas/utensilios/pinzas.tscn`) van colgadas de la cámara.
- Clic izquierdo coge o suelta la hamburguesa a la que apuntas, hasta 1,8 m. Mientras se sostiene es cinemática y no tiene capa de colisión, para no empujar al jugador.
- Clic derecho le da la vuelta, con la lógica común de `Voltear` (`scripts/coccion/voltear.gd`), la misma que usa la tecla F.
- Los brazos se cierran al coger.
- No actúan mientras se lleva algo con E, porque Cogito usa el clic para lanzar.

Commit `9e14346` en `dev`.

**Motivo:** son los botones que Cogito deja libres cuando no llevas un arma, y son las dos acciones de la F1.

**Alternativas descartadas:** hacerlas un arma (wieldable) de Cogito con inventario: es más trabajo y no hace falta para la pregunta de la F1.

Relacionado: [[Roadmap]] · [[Mecánicas]] · [[2026-11-22 Dar la vuelta con interacción propia]] · [[2026-11-22 Cogito como base del proyecto]]
