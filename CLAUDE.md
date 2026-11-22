# Simulador de Barbacoas

Simulador de barbacoas 3D en primera persona, low-poly, con Godot 4, para Steam. La memoria del proyecto es la bóveda de Obsidian `cerebro/`, que vive **solo en la rama `documentacion`**. Empieza leyendo su portada:
- En `documentacion`: `cerebro/00 Inicio.md`.
- En `main` o `dev`: `git fetch origin documentacion && git show "origin/documentacion:cerebro/00 Inicio.md"`.

Este `CLAUDE.md` y la carpeta `.claude/` (skills, agente, hooks) son iguales en las tres ramas. Si cambias uno, cópialo a las otras dos.

## El Documentador (obligatorio)
- Cada vez que termines un cambio en el proyecto, o que se tome, cambie o descarte una decisión, llama al subagente **`documentador`**. Pásale qué se hizo o decidió, el motivo y las alternativas descartadas.
- Él escribe el `cerebro/Changelog.md`, la nota en `cerebro/Decisiones/` y la nota del día en `cerebro/Sesiones/`.
- **El Documentador sube él mismo sus cambios, y solo a la rama `documentacion`.** Si estás en otra rama, usa una copia aparte (`git worktree`) de `documentacion`.
- Tú no hagas commit de `cerebro/` en ninguna rama que no sea `documentacion`. En `main` y `dev`, `cerebro/` no se toca.

## Convenciones
- Responde al usuario en español.
- La bóveda vive en la rama `documentacion`; no la mezcles con `main` ni `dev`.
- El campo `actualizado:` de las notas lo pone un hook (`.claude/hooks/actualizar-fecha.py`); no lo edites a mano.
