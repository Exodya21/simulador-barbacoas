---
tipo: tecnico
estado: borrador
actualizado: 2026-11-22
---

# Arquitectura

Fuente: sección 2 del [[Tablero FigJam]] ("Esquema técnico del juego (sistemas)").

> [!info] Idea principal
> Cada sistema es independiente y se comunica con los demás por señales; los datos (alimentos, parrillas, etc.) van en recursos editables. *(El subtítulo se lee a medias; confirmar.)*

## Esquema
```
Motor: Godot 4 + GDScript   (caja negra; la línea 2 no se lee)
        │
Gestor central (autoload)   (caja azul: estado global de la partida)
        │
 ┌──────┬──────────┬────────────┬──────────────┬────────────────────────┬──────────────┐
 Fuego  Cocción   Interacción  ¿? y Pedidos   Puntuación y Progresión  Presentación
```

| Sistema | Color | Detalle |
|---|---|---|
| 🔥 Sistema de fuego | naranja | ⬜ no se lee |
| 🥩 Sistema de cocción | rojo | ⬜ no se lee |
| ✋ Interacción | morado | ⬜ no se lee |
| 🧾 … y Pedidos *(¿Clientes?)* | amarillo | ⬜ no se lee |
| ⭐ Puntuación y Progresión | verde | ⬜ no se lee |
| ✨ Presentación | turquesa | ⬜ no se lee |

Debajo hay una franja común a todos los sistemas, seguramente los datos compartidos (alimentos, parrillas…). No se lee.

Relacionado: [[Stack]], [[Mecánicas]]
