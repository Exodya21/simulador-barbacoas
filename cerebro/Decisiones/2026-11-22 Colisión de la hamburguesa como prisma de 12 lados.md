---
tipo: decision
fecha: 2026-11-22
hora: 22:24
estado: aceptada
area: Técnico
actualizado: 2026-11-22 22:24
---

# Colisión de la hamburguesa como prisma convexo de 12 lados

**Decisión:** la colisión de la hamburguesa (`escenas/alimentos/hamburguesa.tscn`) es un prisma convexo de 12 lados. Commit `0a44ab6` en `dev`.

**Motivo:** Jolt maneja mal los cilindros muy finos (2,5 cm), y la pieza se quedaba de canto.

**Alternativas descartadas:** `CylinderShape3D` y una caja.

Relacionado: [[Arquitectura]] · [[2026-11-22 Dar la vuelta con interacción propia]]
