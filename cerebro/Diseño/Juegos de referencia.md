---
tipo: diseño
estado: definido
fuente: Tablero FigJam, sección 4
actualizado: 2026-11-22
---

# Juegos y plantillas de referencia

No existe un simulador de barbacoa open source listo para usar. **Estrategia:** usar Cogito como "esqueleto" (jugador en primera persona + interacción con objetos) y construir encima nuestros sistemas de fuego y cocción, tomando ideas de los proyectos de cocina.

## Cogito
⭐ **BASE RECOMENDADA**: Godot 4, licencia MIT.
Plantilla de immersive-sim en primera persona: controlador FPS, coger/soltar/lanzar objetos con física, interacciones, inventario, puertas, guardado y menús.
Reusamos el jugador y las interacciones, y metemos la parrilla en su mundo.
github.com/Phazorknight/Cogito (ahora en codeberg.org/Phazorknight/Cogito)

## Se puede copiar
- 🧪 **Godot Demo Projects** (MIT, oficial): demos de física 3D, partículas, materiales e iluminación para copiar sistemas sueltos (humo, fuego, rigid bodies). github.com/godotengine/godot-demo-projects

## Solo inspiración — ❌ no reutilizar
| Proyecto | Motivo |
|---|---|
| 🍳 Kitchen of the Damned (Godot) | El repo **no tiene licencia** (todos los derechos reservados) y usa sonidos sacados de YouTube. No copiar código ni assets. |
| 🍔 Kitchen Chaos — port a Godot 4.3 | Solo para aprender: sin licencia declarada y basado en assets del curso de Code Monkey. |
| 🥘 Cooking Time (itch.io, Godot) | Solo como referencia de UX: sin licencia declarada y el repo enlazado ya no existe. |

Más detalle: [[Licencias y Steam]].

![[figjam-4-juegos-base.webp]]
