---
tipo: changelog
actualizado: 2026-11-22 22:02
---

# 📜 Changelog

Registro de todo lo que cambia en el proyecto, de lo más reciente a lo más antiguo. Lo escribe **el Documentador**, el agente de Claude definido en `.claude/agents/documentador.md`. Cada decisión tiene además su nota en `Decisiones/`.

## 2026-11-22
- **22:02** · Documentación · Roadmap corregido: el paso 2 de "Próximos pasos esta semana" ya dice que Cogito está probado en el editor con Godot 4.7.2 → [[Roadmap]]
- **22:01** · Producción · Las tareas sueltas de la F0 (vídeos de YouTube, tipo de violencia y licencia de las banderas de Freepik) pasan a la F1 → [[Roadmap]]
- **22:01** · Decisión · F0 cerrada: se cumple el hito "GDD aprobado y repo funcionando"; la siguiente fase es la F1 → [[2026-11-22 F0 cerrada]]
- **22:01** · Documentación · Nueva nota de referencias: parrilla real y juegos de barbacoa de Steam; Roadmap y 00 Inicio con la F0 cerrada (commit `5f9339e`) → [[Referencias de parrilla y juegos]] · [[Roadmap]] · [[00 Inicio]]
- **21:43** · Documentación · Roadmap (F0: GDD y estilo visual hechos, hito "GDD aprobado"), 00 Inicio y Licencias y Steam (encuesta de contenido para adultos y compras dentro del juego) al día → [[Roadmap]] · [[00 Inicio]] · [[Licencias y Steam]]
- **21:43** · Diseño · GDD aprobado: cerradas sus 5 preguntas abiertas, sin ❓ → [[GDD]]
- **21:43** · Decisión · La paleta low-poly pasa de propuesta a aceptada, aprobada en el GDD → [[2026-11-22 Paleta low-poly]]
- **21:43** · Decisión · GDD aprobado: PEGI 12–16 / ESRB T (no PEGI 3), plataforma y estilo como se propusieron, cooperativo tras la 1.0, DLC gratuitos y microtransacciones futuras; sustituye a [[2026-11-22 GDD en borrador]] → [[2026-11-22 GDD aprobado]]
- **20:16** · Documentación · Completadas las alternativas descartadas del riesgo de licencia de las banderas de Cogito → [[2026-11-22 Riesgo de licencia en las banderas de Cogito]]
- **20:15** · Decisión · Riesgo de licencia: las banderas de Cogito parecen de Freepik (pide atribución); confirmar o sustituir antes de publicar → [[2026-11-22 Riesgo de licencia en las banderas de Cogito]]
- **20:15** · Decisión · Las traducciones propias van en `idiomas/`, fuera de `addons/` → [[2026-11-22 Traducciones propias en idiomas]]
- **20:15** · Decisión · El español es el idioma por defecto del juego; inglés y alemán siguen disponibles → [[2026-11-22 Español idioma por defecto]]
- **20:15** · Técnico · Rama `dev` (ce445c7): español por defecto (autoload `Idioma`, `idiomas/cogito_es.po`, parche del selector de idioma) y la caja del patio se puede coger sin el atributo "fuerza"; la prueba de humo pasa → [[2026-11-22 Español idioma por defecto]]
- **19:55** · Técnico · Rama `dev` (b8ba691): proyecto pasado a Godot 4.7.2, con 260 `.import` reescritos y README y `CREDITS.md` al día; la prueba de humo headless pasa → [[2026-11-22 Godot 4.7.2 versión fija]]
- **19:55** · Decisión · La versión fija pasa de Godot 4.6.3 a 4.7.2, a petición del usuario; sustituye a [[2026-11-22 Godot 4.6.3 versión fija]] → [[2026-11-22 Godot 4.7.2 versión fija]]
- **19:40** · Documentación · Completados los motivos y alternativas de las decisiones de paleta, GDD, sonido de fuego NC y carpetas en español; el Stack ya dice "Git LFS aplazado" en Gestión → [[2026-11-22 Paleta low-poly]] · [[2026-11-22 GDD en borrador]] · [[2026-11-22 Quitar sonido de fuego NC de Cogito]] · [[2026-11-22 Carpetas en español]] · [[Stack]]
- **19:38** · Decisión · Propuesta del GDD: Steam Windows + Linux, Steam Deck en F4, demo en itch.io, modos Carrera y Libre, 9,99–14,99 € (pendiente de aprobar) → [[2026-11-22 GDD en borrador]]
- **19:38** · Decisión · Propuesta de paleta low-poly de 15 colores planos, en `scripts/paleta.gd` (pendiente de aprobar) → [[2026-11-22 Paleta low-poly]]
- **19:38** · Decisión · Las carpetas del código propio van en español; `addons/` se queda como lo deja Godot → [[2026-11-22 Carpetas en español]]
- **19:38** · Decisión · Sin Git LFS por ahora; se revisa cuando entren `.glb` y audio propios → [[2026-11-22 Sin Git LFS por ahora]]
- **19:38** · Decisión · Se quita el sonido de fuego de Cogito por ser CC-BY-NC (no comercial) → [[2026-11-22 Quitar sonido de fuego NC de Cogito]]
- **19:38** · Decisión · Cogito entra copiando su proyecto entero (`project.godot` + `addons/`) como base → [[2026-11-22 Cogito como base del proyecto]]
- **19:38** · Decisión · Godot 4.6.3 como versión fija del proyecto → [[2026-11-22 Godot 4.6.3 versión fija]]
- **19:38** · Herramientas · Entorno cloud personal "simulador-barbacoas" con salida a codeberg.org y a las descargas de GitHub, para bajar Cogito y Godot → [[Stack]]
- **19:38** · Documentación · Borrador del GDD y Roadmap, 00 Inicio y Stack al día (commit "F0: borrador del GDD y estado del roadmap") → [[GDD]] · [[Roadmap]]
- **19:38** · Técnico · Rama `dev` (ca37e56): proyecto Godot 4.6.3 con Cogito 1.2.0, patio de prueba como escena principal, paleta, prueba de humo headless (pasa) y `CREDITS.md` + `licencias/` → [[Roadmap]] · [[Licencias y Steam]]
- **19:26** · Decisión · La configuración de Claude (`.claude/` y `CLAUDE.md`) es igual en `main`, `dev` y `documentacion`; la bóveda sigue solo en `documentacion` → [[2026-11-22 Configuración de Claude en las tres ramas]]
- **19:21** · Decisión · El Documentador hace él mismo commit y push de `cerebro/`, solo en la rama `documentacion` (con `git worktree` si se trabaja en otra rama) → [[2026-11-22 Documentador sube solo a documentacion]]
- **19:15** · Decisión · Se crea **el Documentador**, el agente que lleva este Changelog y apunta cada decisión → [[2026-11-22 Agente Documentador]]
- **19:12** · Decisión · Cada nota guarda fecha y hora de su último cambio, tanto en Obsidian como desde Claude → [[2026-11-22 Fecha y hora automáticas]]
- **19:01** · Decisión · Las 26 skills de Claude del proyecto se guardan dentro del repo, en `.claude/skills/` → [[2026-11-22 Skills de Claude dentro del repo]]
- **18:25** · Documentación · Volcado completo de las 8 secciones del tablero FigJam en la bóveda → [[Tablero FigJam]]
- **18:20** · Diseño · Definidos el core loop, los sistemas y el roadmap a partir del tablero FigJam → [[Core loop]] · [[Roadmap]]
- **18:04** · Documentación · Creada la bóveda de Obsidian `cerebro` con notas, referencias visuales y la demo web → [[00 Inicio]]
- **18:04** · Decisión · Motor Godot 4 y venta en Steam → [[2026-11-22 Stack Godot 4 y Steam]]
- **17:53** · Decisión · Repositorio en GitHub con las ramas `main`, `dev` y `documentacion` → [[2026-11-22 Repositorio y ramas]]
- **17:53** · Técnico · Inicio del proyecto: README, `.gitignore` y `.gitattributes`
