---
tipo: tecnico
estado: definido
fuente: Tablero FigJam, sección 8
actualizado: 2026-11-22
---

# Skills de Claude para el proyecto

Pack instalado el 22-11-2026: **gamedev-skills/awesome-gamedev-agent-skills** (~10K ⭐ en GitHub · Apache-2.0 · Godot 4.7). Se instalaron sus 80 skills en `~/.claude/skills`; estas son las que usaremos en cada parte del juego.

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

## 📦 Instaladas, pero NO las usaremos
- **Otros motores:** Unity (9) · Unreal (6) · Roblox (8) · Phaser · PixiJS · Three.js · Bevy · Defold · LÖVE · Pygame · Ebitengine
- **Otros géneros:** platformer · rpg · roguelike · tower-defense · card-game · puzzle · visual-novel · fps-shooter · survival-crafting · procedural-gen · level-design
- **Godot que no aplica:** godot-2d-movement · godot-tilemap · godot-multiplayer · godot-csharp (solo si usamos C#)
- Se pueden desinstalar con `npx skills remove -g <nombre>`

## Para más adelante
- 🧊 **RobLe3/cc-blender-skill**, cuando toque modelar. ~30 skills para modelar, texturizar y exportar glTF en Blender con Claude (parrilla low-poly, utensilios, props). Requiere conectar Blender por MCP. Repo pequeño (182 ⭐): revisarlo antes. Claude lo recordará al empezar a modelar. → [[Modelos 3D]]

## ❌ Descartadas
| Qué | Motivo |
|---|---|
| ityes22/game-design-document | Solo 7 ⭐. El GDD lo hacemos con `game-docs` o directamente con Claude. |
| Otras skills de Steam (steam-store-launch-ops, steam-launch-readiness…) | Menos de 400 instalaciones; `steam-publish` ya lo cubre. |
| Plugin oficial de Unity | Bueno, pero hemos elegido Godot. |

![[figjam-8-skills-claude.webp]]
