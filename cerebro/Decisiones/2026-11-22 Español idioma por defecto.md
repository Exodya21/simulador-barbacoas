---
tipo: decision
fecha: 2026-11-22
hora: 20:15
estado: aceptada
area: Diseño
actualizado: 2026-11-23 23:49
---

# El español es el idioma por defecto del juego

**Decisión:** el juego arranca en español; el inglés y el alemán siguen disponibles. Lo hace el autoload `Idioma` (`scripts/idioma.gd`): si el jugador elige otro idioma en Opciones, se respeta su elección. Español aparece el primero en el selector de idioma de Cogito. Commit `ce445c7` en `dev`.

**Motivo:** lo pidió el usuario, y tanto el equipo como el público principal hablan español.

**Alternativas descartadas:** seguir la detección del sistema que trae Cogito: con Windows en inglés, el juego arrancaría en inglés.

**Ajustada por:** [[2026-11-23 Idioma guardado en idioma.cfg]]. En el primer playtest salía en inglés por un `language.cfg` viejo de Cogito.

Relacionado: [[2026-11-22 Traducciones propias en idiomas]] · [[2026-11-22 Cogito como base del proyecto]] · [[GDD]]
