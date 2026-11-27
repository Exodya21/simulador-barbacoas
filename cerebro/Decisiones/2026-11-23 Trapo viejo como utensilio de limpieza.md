---
tipo: decision
fecha: 2026-11-23
hora: 23:15
estado: aceptada
area: Diseño
actualizado: 2026-11-23 23:15
---

# Trapo viejo como utensilio de limpieza por defecto

**Decisión:** por defecto, el jugador limpia la grasa con un trapo viejo, sucio y roto. En palabras del usuario: "que por defecto para limpiar tenga un trapo viejo sucio y roto para limpiar la grasa". Se sigue limpiando manteniendo F, pero ahora cuesta 4 s por mancha (antes eran 2 s), porque el trapo viejo es lento. Commit `5a8d947` en `dev`.

**Cómo funciona:**
- El trapo está modelado en Blender con `herramientas/blender/trapo.py`: 130 caras, con agujeros, bordes deshilachados y dos manchones de grasa.
- `UtensilioLimpieza` es un Resource con el tiempo por mancha y el modelo. El del trapo es `datos/limpieza/trapo.tres`.
- El autoload `Equipo` guarda el utensilio de limpieza del jugador. Por defecto es el trapo, y está preparado para cambiarlo por otro.
- La mancha toma del utensilio el tiempo y el texto ("Limpiar con el trapo"). Mientras se mantiene F, el trapo frota en círculos y la mancha se va desvaneciendo. Si se suelta antes, la mancha vuelve entera.
- `test_limpieza` pasa a 21 comprobaciones; todas las pruebas pasan.

**Completa a:** [[2026-11-23 Limpiar manchas manteniendo F]] (se sigue limpiando con F). Resuelve la parte del trapo de la idea [[Utensilio para limpiar manchas]].

**Ajustada el 27-11-2026:** el trapo va al hueco 3 del cinturón y solo se limpia con él en la mano (sigue siendo mantener F) → [[2026-11-27 Cinturón de utensilios con 4 huecos]]

**Motivo:** lo pidió el usuario. Empezar con una herramienta mala hace que las mejoras de la tienda se noten → [[Ruta de mejora de la limpieza]].

**Alternativas descartadas:** limpiar sin utensilio, que era como estaba, con F durante 2 s.

Relacionado: [[Mecánicas]] · [[Modelos 3D]] · [[2026-11-23 Comida caída al suelo sucia, mancha y basura]] · [[2026-11-23 Modelos propios con scripts de Blender]]
