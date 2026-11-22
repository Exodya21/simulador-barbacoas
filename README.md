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

- Motor: **Godot 4.7.2** + GDScript (base: Cogito 1.2.0, MIT, pensado para 4.6.3)
- Modelado: Blender
- Assets: CC0 (Kenney, Quaternius, Poly Haven)

## Abrir el proyecto

1. Instalar **Godot 4.7.2** (versión estándar, no .NET). Todo el equipo con la misma versión: otra versión reescribe los `.import`.
2. En Godot: *Importar* → elegir `project.godot` de este repo. La primera importación tarda un poco.
3. F5 abre `escenas/patio_prueba.tscn`: patio gris con parrilla, mesa y una caja que se puede coger (E).
   Las demos de Cogito siguen en `addons/cogito/DemoScenes/` (abrir `COGITO_0_MainMenu.tscn` y pulsar F6).

## Estructura

| Carpeta | Contenido |
|---|---|
| `addons/` | Cogito y sus plugins (no tocar salvo parches anotados en `CREDITS.md`) |
| `escenas/` | Escenas del juego |
| `scripts/` | Código propio (GDScript) |
| `datos/` | Resources `.tres`: alimentos, parrillas, recetas… |
| `pruebas/` | Pruebas automáticas |
| `herramientas/` | Scripts de apoyo |
| `licencias/` | Licencias de terceros para distribuir con el juego |

## Comprobar que el proyecto funciona

```bash
GODOT=/ruta/a/godot herramientas/comprobar.sh
```

Importa el proyecto en modo headless y corre la escena principal 120 frames. Falla si hay errores de script.

## Créditos

Todo asset o código de terceros va en [`CREDITS.md`](CREDITS.md) con su licencia antes de entrar al repo.
