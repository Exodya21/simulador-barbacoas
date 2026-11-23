---
tipo: decision
fecha: 2026-11-23
hora: 22:13
estado: aceptada
area: Producción
actualizado: 2026-11-23 22:13
---

# Banderas propias en el selector de idioma

**Decisión:** el selector de idioma usa solo banderas propias y se quitan las de Freepik que traía Cogito. Lo pidió el usuario. Commit `b540a60` en `dev`, "Banderas propias en el selector de idioma (fuera las de Freepik)":
- Nuevas `arte/iconos/bandera_us.png` y `arte/iconos/bandera_de.png`, dibujadas con código (franjas y estrellas), como ya lo era `bandera_es.png`.
- `language_select.gd` y `OptionsTabMenu.tscn` de Cogito apuntan ahora a ellas. Son dos parches a Cogito, anotados en `CREDITS.md`.
- Borradas `freepik_flag_us.png` y `freepik_flag_de.png` de Cogito.
- La prueba de humo comprueba que el menú de opciones carga y que existen las tres banderas. Todas las pruebas pasan.

**Sustituye a:** [[2026-11-22 Riesgo de licencia en las banderas de Cogito]] (el riesgo queda resuelto).

**Motivo:** quitar el riesgo de licencia ya, en vez de esperar a publicar.

**Alternativas descartadas:**
- Buscar la licencia original de las banderas de Cogito: el resultado es incierto.
- Dejar el selector solo con texto.

Relacionado: [[Licencias y Steam]] · [[2026-11-22 Español idioma por defecto]] · [[2026-11-22 Traducciones propias en idiomas]]
