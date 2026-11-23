---
tipo: decision
fecha: 2026-11-23
hora: 23:48
estado: aceptada
area: Técnico
actualizado: 2026-11-23 23:48
---

# Idioma guardado en `idioma.cfg`

**Decisión:** el idioma del jugador se guarda en `user://idioma.cfg`, tanto desde el autoload `Idioma` como desde el selector de Cogito, que queda parcheado. El archivo viejo `user://language.cfg` se ignora. Commit `0eb562b` en `dev`.

**Viene del playtest:** el usuario dijo "Que por defecto sea el idioma español, ahora sale el inglés."

**Causa:** el selector de Cogito había guardado el idioma del sistema (inglés) en `user://language.cfg` antes de que existiera el español. El juego lo respetaba como si lo hubiera elegido el jugador.

**Ajusta a:** [[2026-11-22 Español idioma por defecto]]

**Motivo:** que el juego arranque en español aunque exista ese `language.cfg` viejo.

**Alternativas descartadas:**
- Borrar el `language.cfg` del jugador: sería tocar archivos del usuario.
- Pedirle al jugador que cambie el idioma a mano.

Relacionado: [[2026-11-22 Traducciones propias en idiomas]] · [[2026-11-22 Cogito como base del proyecto]]
