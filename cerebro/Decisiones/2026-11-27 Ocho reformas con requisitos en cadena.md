---
tipo: decision
fecha: 2026-11-27
hora: 22:46
estado: aceptada
area: Diseño
---

# Ocho reformas con requisitos en cadena

**Decisión:** la estancia tiene **8 reformas**, cada una una zona con versión en ruinas y versión reformada. Son datos `datos/estancia/*.tres` (recurso `Reforma`: id, nombre, coste, requiere). Al pagar solo se reconstruye esa zona.

| Reforma | Coste | Requiere |
|---|---|---|
| Desbroce (maleza, pasto seco, cubiertas, escombro → pasto cortado) | 3.000 $ | — |
| Quincho | 12.000 $ | desbroce |
| Tranquera | 6.000 $ | desbroce |
| Aljibe | 8.000 $ | desbroce |
| Mesa para 30 | 15.000 $ | quincho |
| Jardín, caminos y farolas | 18.000 $ | desbroce y aljibe |
| Bodegón | 35.000 $ | quincho |
| Casa criolla | 50.000 $ | mesa |

Lo fijo, que no se reforma: cerco, álamos, monte y cerros, y el ombú.

Los precios son **orientativos**: **pendiente de balancear en playtest**.

**Motivo:** (pendiente de confirmar) — da una progresión en orden y deja ajustar precios sin tocar código.

**Alternativas descartadas:** (pendiente de confirmar)

Relacionado: [[2026-11-27 Historia de la estancia heredada del abuelo]] · [[2026-11-27 Pagar reformas manteniendo F en un cartel de obra]] · [[Mecánicas]] · [[2026-11-27]]
