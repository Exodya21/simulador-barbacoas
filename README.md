# Simulador de Barbacoas

Simulador de barbacoas 3D en primera persona, estilo low-poly, hecho con **Godot 4** y pensado para publicarse en **Steam**.

## Ramas

| Rama | Para qué sirve |
|---|---|
| `main` | Producto **probado y funcional**. Solo recibe merges desde `dev` cuando algo está terminado y testeado. |
| `dev` | Rama de trabajo del día a día. Aquí se desarrolla y se prueba antes de pasar a `main`. |
| `documentacion` | Referencias, ideas y el "cerebro" del proyecto (bóveda de Obsidian). No se mezcla con `main` ni con `dev`. |

## Flujo de trabajo

1. Trabajar en `dev` (o en ramas cortas que salgan de `dev` y vuelvan a ella).
2. Cuando una funcionalidad está hecha y probada → merge de `dev` a `main`.
3. Ideas, decisiones y referencias → rama `documentacion`.

## Stack

- Motor: Godot 4 + GDScript (base: Cogito, MIT)
- Modelado: Blender
- Assets: CC0 (Kenney, Quaternius, Poly Haven)
