---
tipo: decision
fecha: 2026-11-22
hora: 19:26
estado: aceptada
area: Herramientas
actualizado: 2026-11-22 19:26
---

# Configuración de Claude igual en las tres ramas

**Decisión:** la configuración de Claude (carpeta `.claude/` con las 26 skills, el agente Documentador, el hook de fecha y `settings.json`, más `CLAUDE.md`) es igual en las tres ramas `main`, `dev` y `documentacion`. Se copió a `dev` (commit `27a9e8e`) y a `main` (commit `dfbbc62`) sin la bóveda `cerebro/`, que sigue solo en `documentacion`. `CLAUDE.md` explica cómo leer la portada de la bóveda desde `main`/`dev` (`git show origin/documentacion:cerebro/00 Inicio.md`) y pide que, si se cambia `.claude/` o `CLAUDE.md`, se copie a las otras dos ramas.

**Motivo:** lo ha pedido el usuario; así el Documentador y las skills funcionan trabajando en cualquier rama.

**Alternativas descartadas:** tener la configuración solo en `documentacion`, porque al trabajar en `dev` no habría Documentador ni skills.

Relacionado: [[2026-11-22 Documentador sube solo a documentacion]] · [[2026-11-22 Skills de Claude dentro del repo]] · [[2026-11-22 Repositorio y ramas]] · [[Repositorio y ramas]] · [[Skills de Claude]]
