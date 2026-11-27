---
tipo: decision
fecha: 2026-11-27
hora: 22:46
estado: aceptada
area: Arte
---

# Escenario construido desde código con primitivas

**Decisión:** la estancia se levanta entera **desde código con formas low-poly** (cajas, cilindros, bolas facetadas, tejados, pasto con MultiMesh…), sin modelar en Blender ni usar packs.
- `scripts/estancia/estancia.gd` (@tool, clase `Estancia`) construye el plano de 72×48 m según el plano cenital del usuario: casa criolla, bodegón con pérgola, quincho y parrilla, mesa para 30, ombú, aljibe, limonero, tranquera y camino de álamos.
- `scripts/estancia/geo.gd` (clase `Geo`) reúne los ayudantes de geometría. Shader nuevo `shaders/pasto.gdshader` (pasto que se mece con el viento).
- Se ve en el editor; la propiedad `vista_editor_reformada` enseña la versión reformada.
- No entra ningún asset externo: nada nuevo para `CREDITS.md`.

**Motivo:** cada zona se rehace al reformarla, se ajusta cambiando números, se ve en el editor y no hay licencias.

**Alternativas descartadas:**
- Modelar en Blender: más lento para un escenario entero. Se puede hacer luego pieza a pieza.
- Packs CC0 de Kenney o Quaternius: no tienen casas criollas, quinchos ni aljibes y no encajan en el estilo.

Relacionado: [[Modelos 3D]] · [[2026-11-23 Modelos propios con scripts de Blender]] · [[2026-11-27 Historia de la estancia heredada del abuelo]] · [[2026-11-27]]
