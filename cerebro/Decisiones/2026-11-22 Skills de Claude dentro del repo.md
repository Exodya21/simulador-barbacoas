---
tipo: decision
fecha: 2026-11-22
hora: 19:01
estado: aceptada
area: Herramientas
actualizado: 2026-11-22 19:15
---

# Skills de Claude dentro del repo

**Decisión:** las 26 skills de Claude que usará el proyecto se guardan en `.claude/skills/` dentro del repositorio: 25 de awesome-gamedev-agent-skills y `godot-gdscript-patterns`.

**Motivo:** las sesiones de Claude en la nube se borran al cerrarse, así que lo instalado en `~/.claude/skills` se perdía. Dentro del repo, Claude las carga solo en cualquier sesión y ordenador.

**Alternativas descartadas:** instalar las 80 del pack de forma global, que se perdían y además traían muchas que no aplican, como las de otros motores y otros géneros.

Relacionado: [[Skills de Claude]]
