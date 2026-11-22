---
tipo: decision
fecha: 2026-11-22
hora: 19:12
estado: aceptada
area: Herramientas
actualizado: 2026-11-22 19:15
---

# Fecha y hora automáticas en cada cambio

**Decisión:** cada nota guarda `actualizado: AAAA-MM-DD HH:MM` en sus propiedades cuando se cambia. En Obsidian lo hace el plugin *Update time on edit*. En los cambios de Claude lo hace el hook `.claude/hooks/actualizar-fecha.py`, con la hora de Madrid. Las plantillas no se fechan.

**Motivo:** saber siempre cuándo se tocó cada nota por última vez, sin depender de acordarse de hacerlo a mano.

**Alternativas descartadas:** solo una regla escrita para que Claude lo hiciera a mano, menos fiable que el hook.

Relacionado: [[00 Inicio]]
