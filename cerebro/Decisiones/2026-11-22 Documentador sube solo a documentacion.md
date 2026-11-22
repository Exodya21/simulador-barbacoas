---
tipo: decision
fecha: 2026-11-22
hora: 19:21
estado: aceptada
area: Herramientas
---

# El Documentador sube solo a la rama `documentacion`

**Decisión:** todo lo que escribe el Documentador se sube **solo** a la rama `documentacion`, y el propio Documentador hace el commit y el push de `cerebro/`. Si se está trabajando en otra rama (`dev`, `main`), usa una copia aparte de `documentacion` con `git worktree` (carpeta `../simulador-barbacoas-documentacion`) y nunca toca `cerebro/` en esas ramas. El hook de fecha se ajustó para funcionar también en esa copia.

**Motivo:** lo ha pedido el usuario; mantener la documentación separada del código, en línea con la decisión de tener tres ramas (`main` / `dev` / `documentacion`).

**Alternativas descartadas:** que quien llama al Documentador haga el commit en la rama en la que esté, porque podía acabar subiendo la bóveda a `dev` o `main`.

**Amplía:** [[2026-11-22 Agente Documentador]]

Relacionado: [[2026-11-22 Agente Documentador]] · [[2026-11-22 Repositorio y ramas]] · [[Repositorio y ramas]] · [[2026-11-22 Fecha y hora automáticas]] · [[Changelog]]
