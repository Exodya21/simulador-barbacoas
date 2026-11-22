---
tipo: decision
fecha: 2026-11-22
hora: 22:24
estado: aceptada
area: Diseño
actualizado: 2026-11-22 22:24
---

# Modelo de cocción por caras con temperatura de superficie e interior

**Decisión:** cada cara del alimento tiene su temperatura de superficie y su grado: 0 crudo, 1 sellado, 2 dorado, 3 pasado y 4 quemado. El interior va despacio hacia la media de las caras, así que sigue subiendo en reposo. Lo hacen `EstadoCoccion` y `TipoAlimento` (`scripts/coccion/`), con los datos en `datos/alimentos/hamburguesa.tres`. Ritmo actual de la hamburguesa: unos 40 s por cara hasta dorar, y se quema hacia los 75–80 s si no se le da la vuelta. Commit `0a44ab6` en `dev`.

**Motivo:** responde al pilar "Leer la comida" del [[GDD]], y la carne sigue haciéndose en reposo, como en las referencias reales → [[Referencias de parrilla y juegos]].

**Alternativas descartadas:**
- Un temporizador por cara: contradice el pilar "El fuego manda".
- Simular el calor por vóxeles: cuesta demasiado para la F1.

Relacionado: [[Arquitectura]] · [[Mecánicas]] · [[Roadmap]] · [[2026-11-22 Rejilla de calor por celdas]]
