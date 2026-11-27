---
tipo: diseño
estado: definido
fuente: Tablero FigJam, sección 5
actualizado: 2026-11-23 23:49
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
| Cubo de basura (de pedal, sin tapa) | — | ✅ generado con `herramientas/blender/basura.py`, 78 caras ([[2026-11-23 Comida caída al suelo sucia, mancha y basura]]); versión más realista pendiente → [[Cubo de basura realista con bolsa]] |
| Trapo viejo | — | ✅ generado con `herramientas/blender/trapo.py`, 130 caras ([[2026-11-23 Trapo viejo como utensilio de limpieza]]) |
| Carne de hamburguesa | — | ✅ generada con `herramientas/blender/hamburguesa.py`, 152 caras, exportada como `.obj`: borde irregular, cantos biselados y centro abombado. La hamburguesa ya no usa modelos del Food Kit. |
| Chimenea de encendido, saco de carbón, abanico y trozos de carbón | — | 🟨 de momento con primitivas low-poly en la escena, sin Blender; el pulido va con "Humo, llamas, chispas + audio" y el nivel bonito de la F2 ([[2026-11-25 Encendido con chimenea y abanico]]) |
| Escenario de la estancia: casa criolla, bodegón, quincho y parrilla de ladrillo, mesa para 30, pérgolas, ombú, aljibe, limonero, tranquera, álamos, cerco, monte y cerros, en ruinas y reformados | plano cenital y fotos del usuario ([[Referencias visuales]]) | 🟨 con primitivas low-poly desde código (`scripts/estancia/estancia.gd` y `geo.gd`), sin Blender ni assets externos, en `dev` sin commit; se puede pasar a Blender pieza a pieza más adelante ([[2026-11-27 Escenario construido desde código con primitivas]]) |
| Cepillo y mocho con balde | — | ⬜ para el futuro → [[Ruta de mejora de la limpieza]] |
| Bolsa de basura y contenedor de la calle | — | ⬜ para más adelante → [[Cubo de basura realista con bolsa]] |
| Kamado / ahumador | parrilla-exterior-ahumador | ⬜ |

Para modelar con Claude: ver [[Skills de Claude#Para más adelante]].

![[figjam-5-modelos-3d.webp]]
