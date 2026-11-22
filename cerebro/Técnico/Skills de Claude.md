---
tipo: tecnico
estado: definido
fuente: Tablero FigJam, sección 8
actualizado: 2026-11-22 19:27
---

# Skills de Claude para el proyecto

Pack elegido: **gamedev-skills/awesome-gamedev-agent-skills** (~10K ⭐ en GitHub · Apache-2.0 · Godot 4.7), más `godot-gdscript-patterns` de **wshobson/agents** (MIT).

> [!info] Dónde están instaladas
> Las 26 skills que usamos están **dentro del repo**, en `.claude/skills/`, en las tres ramas (`main`, `dev` y `documentacion`, 22-11-2026) → [[2026-11-22 Configuración de Claude en las tres ramas]]. Al estar en git, Claude las carga automáticamente en cualquier sesión y ordenador que abra el proyecto. Las 80 del pack que se instalaron antes en `~/.claude/skills` se perdían al cerrar la sesión en la nube.
> Versiones copiadas: awesome-gamedev-agent-skills `c6ca6c4` · wshobson/agents `12bcec7`. Licencias en `.claude/skills/LICENSE-*`.

> [!tip] Cómo se usan
> No hay que hacer nada especial. Claude carga la skill adecuada cuando le pides algo. Ej.: "haz el shader de cocción de la carne en Godot" → `godot-shaders` + `shader-programming`.

## ✅ Instaladas — las que usaremos
| Área | Skills |
|---|---|
| 🧱 Base de Godot | `godot-gdscript` · `godot-nodes-scenes` · `godot-signals-groups` · `godot-resources` · `godot-3d-essentials` + `godot-gdscript-patterns` (wshobson/agents, instalada el 22/11) |
| ✋ Física de pinzas y comida | `godot-physics` (Jolt, RigidBody, raycasts) · `physics-tuning` |
| 🔥 Shader de cocción y VFX | `godot-shaders` · `shader-programming` (crudo → hecho → quemado, humo, brasas) |
| 🖥️ HUD y sonido | `godot-ui-control` · `game-ui-ux` · `godot-audio` · `audio-design` |
| 🎮 Diseño y sensación | `game-feel` · `prototype-fast` · `game-docs` (GDD) · `camera-systems` · `input-systems` · `save-systems` · `game-ai` (invitados) |
| 🚀 Calidad y publicación | `performance-optimization` · `godot-gdscript-headless-testing` · `godot-export` · `itch-publish` · `steam-publish` |

## 📦 Del pack, pero NO las usaremos (no copiadas al repo)
- **Otros motores:** Unity (9) · Unreal (6) · Roblox (8) · Phaser · PixiJS · Three.js · Bevy · Defold · LÖVE · Pygame · Ebitengine
- **Otros géneros:** platformer · rpg · roguelike · tower-defense · card-game · puzzle · visual-novel · fps-shooter · survival-crafting · procedural-gen · level-design
- **Godot que no aplica:** godot-2d-movement · godot-tilemap · godot-multiplayer · godot-csharp (solo si usamos C#)
- No están en el repo. Si alguna hiciera falta, se copia desde el pack a `.claude/skills/`.

## Para más adelante
- 🧊 **RobLe3/cc-blender-skill**, cuando toque modelar. ~30 skills para modelar, texturizar y exportar glTF en Blender con Claude (parrilla low-poly, utensilios, props). Requiere conectar Blender por MCP. Repo pequeño (182 ⭐): revisarlo antes. Claude lo recordará al empezar a modelar. → [[Modelos 3D]]

## ❌ Descartadas
| Qué | Motivo |
|---|---|
| ityes22/game-design-document | Solo 7 ⭐. El GDD lo hacemos con `game-docs` o directamente con Claude. |
| Otras skills de Steam (steam-store-launch-ops, steam-launch-readiness…) | Menos de 400 instalaciones; `steam-publish` ya lo cubre. |
| Plugin oficial de Unity | Bueno, pero hemos elegido Godot. |

![[figjam-8-skills-claude.webp]]
