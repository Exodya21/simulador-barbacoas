---
tipo: diseño
estado: definido
fuente: Tablero FigJam, sección 5
actualizado: 2026-11-23 22:25
---

# Modelos 3D y assets gratuitos

Prioridad a **CC0** (uso comercial, sin atribución). Mismo estilo **low-poly** para que todo encaje. Formato preferido: **glTF/GLB**.

## Fuentes
| Qué | Fuente | Licencia | Contenido |
|---|---|---|---|
| 🍖 Comida | **Kenney — Food Kit** | CC0 | 200 alimentos low-poly: carnes, salchichas, verduras, pan… En FBX, OBJ y glTF. kenney.nl/assets/food-kit |
| 🥓 Comida | **Quaternius — Low Poly Food Pack** | CC0 | 100+ alimentos (hamburguesa, bacon…). FBX, OBJ y .blend. quaternius.com · opengameart.org |
| 🍕 Cocina | **Poly Pizza** | CC0 *(revisar cada modelo)* | Buscador de modelos low-poly. Bundle "Restaurant Bits": 100+ objetos de cocina y restaurante. poly.pizza |
| 🔥 Parrillas | ⚠️ **Ojo con las licencias** | — | Womp "BBQ Grill" es CC0 pero **no se puede descargar** (solo en su web). Sketchfab "Metal Grill": el campo de licencia dice CC BY 4.0 (dar crédito). **Mejor: modelar la parrilla en Blender.** |
| 🌳 Entorno (patio y jardín) | **Kenney Furniture Kit** y **Nature Kit**, **Quaternius Ultimate Nature** | CC0 | Mesas, sillas, árboles, vallas, césped |
| 🌅 Iluminación y texturas | **Poly Haven** | CC0 | HDRIs de exterior (atardecer de barbacoa), texturas de madera, metal, ladrillo y props. polyhaven.com |
| 🧑 Invitados | **Quaternius Ultimate Modular Characters** + animaciones de **Mixamo** | CC0 + gratis | Animaciones para comer, esperar, aplaudir |
| 🛠️ Si falta algo | Modelar en **Blender** (una parrilla low-poly es una tarde) o comprar packs baratos en **CGTrader** | Royalty-free (~10 $) | Revisar la licencia |

> [!important] Licencias
> **CC0** = libre sin créditos · **CC-BY** = poner créditos en el juego · Evitar licencias "Editorial", "No AI" o "no comercial".
> Guardar un **`CREDITS.md`** con el origen y la licencia de cada asset. → [[Licencias y Steam]]

## Lista de modelos propios (Blender)
Basada en las [[Referencias visuales]].

| Modelo | Referencia | Estado |
|---|---|---|
| Parrilla de obra con campana | parrilla-obra-doble-cadenas | ⬜ |
| Brasero / canasto de leña | brasero-cadenas, brasero-avivando-fuego | ⬜ |
| Parrilla con cadenas y manivela | parrilla-manivela-canasto | ⬜ |
| Módulos: parrilla, disco/wok, espetos, plancha, sartenes | modulos-parrilla | ⬜ |
| Utensilios: pinzas | — | ✅ generadas con `herramientas/blender/pinzas.py` → `arte/modelos/pinzas.glb` ([[2026-11-23 Modelos propios con scripts de Blender]]) |
| Utensilios: espátula, salero, tapa, pala | — | ⬜ |
| Kamado / ahumador | parrilla-exterior-ahumador | ⬜ |

Para modelar con Claude: ver [[Skills de Claude#Para más adelante]].

![[figjam-5-modelos-3d.webp]]
