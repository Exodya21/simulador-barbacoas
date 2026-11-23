---
tipo: idea
fecha: 2026-11-23
estado: cruda
actualizado: 2026-11-23 23:15
---

# Ruta de mejora de la limpieza

> Para el futuro, no ahora.

**Qué es:** el jugador empieza con el trapo viejo y puede comprar en la tienda un **cepillo** y después un **mocho con balde**, cada uno más rápido que el anterior. En palabras del usuario: "apunta que la ruta de mejora para un futuro sea que se pueda comprar un cepillo y un mocho con balde y que cada uno limpie más rápido la grasa".

| Utensilio | Tiempo por mancha (orientativo, por ajustar) |
|---|---|
| Trapo viejo (por defecto) | 4 s |
| Cepillo | 2,5 s |
| Mocho con balde | 1,2 s |

**Cómo se haría:** bastará con un `.tres` nuevo de `UtensilioLimpieza` por cada utensilio y cambiarlo en el autoload `Equipo` → [[2026-11-23 Trapo viejo como utensilio de limpieza]].

**Por qué molaría:** empezar con una herramienta mala hace que cada mejora de la tienda se note.

**Cómo encaja con el [[Core loop]]:** es parte de la progresión. Entra en la tienda de mejoras de la F3 del [[Roadmap]] y en Puntuación y Progresión de la [[Arquitectura]] (dinero → utensilios).

Relacionado: [[Utensilio para limpiar manchas]] · [[Mecánicas]] · [[Modelos 3D]]
