---
tipo: decision
fecha: 2026-11-22
hora: 19:38
estado: aceptada
area: Técnico
actualizado: 2026-11-22 19:38
---

# Integrar Cogito copiando el proyecto entero como base

**Decisión:** Cogito 1.2.0 (commit `a2d7afa` de Codeberg, 14-11-2026) entra copiando el proyecto entero: su `project.godot` (renombrado a "Simulador de Barbacoas", versión 0.0.1) y sus `addons/` (Cogito, Godot State Charts e Input Helper, todo MIT). Las demos de Cogito se quedan de momento en `addons/cogito/DemoScenes/` para aprender; se borrarán antes de publicar.

**Motivo:** así se conservan su input map, autoloads, capas de física, Jolt y plugins, y funciona a la primera.

**Alternativas descartadas:**
- Copiar solo `addons/` y rehacer a mano los ajustes: es fácil romper algo.
- Submódulo git: Cogito no es un addon suelto, necesita su `project.godot`, y no lo podríamos parchear.

Relacionado: [[Stack]] · [[Arquitectura]] · [[Juegos de referencia]] · [[2026-11-22 Godot 4.6.3 versión fija]] · [[2026-11-22 Quitar sonido de fuego NC de Cogito]]
