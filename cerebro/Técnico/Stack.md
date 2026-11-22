---
tipo: tecnico
estado: decidido
fuente: Tablero FigJam, sección 3
actualizado: 2026-11-22 19:56
---

# Stack

Criterio: **gratis, sin royalties, ligero, buena comunidad y que un equipo pequeño pueda sacar el juego adelante.**

## ✅ Recomendado
| Pieza | Elección | Por qué |
|---|---|---|
| 🎮 Motor | **Godot 4.7.2** (versión fija de todo el equipo; Cogito 1.2.0 está hecho para 4.6.3 → [[2026-11-22 Godot 4.7.2 versión fija]]) | Gratis, licencia MIT, sin royalties. Física Jolt integrada, partículas GPU, shaders visuales. Exporta a Windows, Linux, Mac y Web. |
| 🧠 Lenguaje | **GDScript** | Rápido de aprender y pensado para Godot. C# como opción si venís de Unity. |
| 🧊 Modelado | **Blender 4.x** | Gratis. Exportar en glTF/GLB, que Godot importa directamente con materiales. |
| 🎨 Texturas y materiales | **Poly Haven** (CC0), **Material Maker** o **ArmorPaint** | Para low-poly: paleta de colores plana + un shader de cocción. |
| 🔊 Audio | **AudioStreamPlayer3D** + **Freesound** (CC0/CC-BY) + pack gratuito **Sonniss GDC** | Chisporroteo modulado por temperatura. |
| 🗂️ Gestión | **Git + GitHub** (Git LFS aplazado → [[2026-11-22 Sin Git LFS por ahora]]), tareas en **GitHub Projects** | Diseño y roadmap en el [[Tablero FigJam]] y en esta bóveda. → [[Repositorio y ramas]] |
| 🚀 Publicación | Demo en **itch.io** (gratis) → **Steam** con **GodotSteam** (logros, Steam Deck) | Build web para compartir por enlace. |

## Alternativas descartadas
| Opción | Motivo |
|---|---|
| 🌐 Three.js + React Three Fiber + Rapier | 100% navegador y compartible por URL, pero sin editor visual: más código. (La [[Demo jardín con parrilla]] está hecha con Three.js.) |
| 🧱 Unity 6 | Más assets y tutoriales de "cooking sim" en la Asset Store, pero motor propietario y más pesado. |
| 🎬 Unreal Engine 5 | Carne fotorrealista y Nanite/Lumen, pero curva alta y demasiado para un equipo pequeño. |

Licencias de cada pieza: [[Licencias y Steam]]. Decisión: [[2026-11-22 Stack Godot 4 y Steam]].

Más decisiones: [[2026-11-22 Godot 4.7.2 versión fija]] (sustituye a [[2026-11-22 Godot 4.6.3 versión fija]]) · [[2026-11-22 Cogito como base del proyecto]] · [[2026-11-22 Sin Git LFS por ahora]] (Git LFS queda aplazado hasta que entren `.glb` y audio propios).

![[figjam-3-stack.webp]]
