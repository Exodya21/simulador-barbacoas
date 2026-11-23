---
tipo: decision
fecha: 2026-11-23
hora: 22:25
estado: aceptada
area: Arte
actualizado: 2026-11-23 22:25
---

# Modelos propios generados con scripts de Blender (bpy) dentro del repo

**Decisión:** los modelos propios se generan con scripts de Blender (`bpy`) guardados en el repo, en `herramientas/blender/`. El primero es `herramientas/blender/pinzas.py`: exporta `arte/modelos/pinzas.glb` y guarda `pinzas.blend`. Blender no está instalado en el entorno cloud, pero el módulo `bpy` 5.3.0 de PyPI funciona sin interfaz. Commit `9e14346` en `dev`.

**Motivo:** los modelos se pueden regenerar y retocar cambiando números, y Claude puede modelar sin interfaz.

**Alternativas descartadas:**
- Modelar a mano en la interfaz de Blender: no se puede desde el entorno cloud y no queda receta.
- Comprar o bajar un modelo: no había ninguno de pinzas con licencia clara a mano.

Relacionado: [[Modelos 3D]] · [[Stack]] · [[Skills de Claude]] · [[2026-11-23 Godot usa glb y no importa blend]]
