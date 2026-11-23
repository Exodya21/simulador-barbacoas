---
tipo: decision
fecha: 2026-11-23
hora: 22:25
estado: aceptada
area: Técnico
actualizado: 2026-11-23 22:25
---

# Godot usa el `.glb` exportado y no importa `.blend`

**Decisión:** el juego carga los modelos desde el `.glb` exportado (por ejemplo `arte/modelos/pinzas.glb`). La importación de `.blend` está desactivada en `project.godot`, porque Godot pedía Blender instalado. Commit `9e14346` en `dev`.

**Motivo:** así no hace falta Blender instalado para abrir el proyecto.

**Alternativas descartadas:** la importación directa de `.blend` en Godot.

Relacionado: [[Stack]] · [[Modelos 3D]] · [[2026-11-23 Modelos propios con scripts de Blender]]
