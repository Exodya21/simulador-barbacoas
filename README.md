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
3. F5 abre `escenas/patio_prueba.tscn`: patio gris con la parrilla y tres hamburguesas en la mesa.

### Controles del prototipo (F1)

| Tecla | Acción |
|---|---|
| E | Coger / soltar (llevar) una hamburguesa con la mano |
| Clic izquierdo **mantenido** | **Pinzas:** coger la hamburguesa a la que apuntas y apretarla; al soltar el clic, la sueltas |
| Clic derecho (con la hamburguesa cogida) | Abre el **minijuego de dar la vuelta**: una línea sube y baja por una barra. **Suelta el clic izquierdo** para pararla |
| F mantenida (mirando una mancha) | Limpiar la mancha de grasa con el trapo viejo (4 s) |
| F3 | Mostrar u ocultar la depuración: rejilla de calor (azul frío → rojo caliente) y termómetro de cada pieza |

Resultado del minijuego, según dónde pares la línea (la zona verde cambia de sitio cada vez):
- **Perfecto** (zona verde): vuelta perfecta.
- **Bien** (zona amarilla): se te escurre de las pinzas; cae del lado bueno con un 80 % de probabilidad junto a la zona verde y un 30 % en el borde.
- **Mal** (fuera): sale despedida al suelo.

**Suciedad:** si la comida cae al suelo, se ensucia (motas oscuras) y deja una **mancha de grasa resbaladiza**: al pisarla el jugador patina. La mancha no se va sola: se limpia manteniendo F con el **trapo viejo, sucio y roto** que el jugador lleva por defecto (lento: 4 s). Los utensilios de limpieza son datos (`datos/limpieza/*.tres`); más adelante se podrán comprar un cepillo y un mocho con balde que limpien más rápido. La comida sucia hay que **tirarla al cubo de basura** (junto a la parrilla): suéltala encima de la boca, con las pinzas o con la mano.

La parrilla tiene **zona directa** a la izquierda (~260 °C), transición en el centro e **indirecta** a la derecha (~100 °C, no dora pero sigue haciendo el interior).
   Las demos de Cogito siguen en `addons/cogito/DemoScenes/` (abrir `COGITO_0_MainMenu.tscn` y pulsar F6).

## Estructura

| Carpeta | Contenido |
|---|---|
| `addons/` | Cogito y sus plugins (no tocar salvo parches anotados en `CREDITS.md`) |
| `escenas/` | Escenas del juego |
| `scripts/` | Código propio (GDScript): `fuego/` (rejilla de calor), `coccion/` (cocción por caras) |
| `shaders/` | Shaders propios (cocción crudo → quemado) |
| `datos/` | Resources `.tres`: alimentos, parrillas, recetas… |
| `idiomas/` | Traducciones (`.po`). El juego arranca en español; el idioma se cambia en Opciones |
| `arte/` | Imágenes y modelos propios |
| `pruebas/` | Pruebas automáticas |
| `herramientas/` | Scripts de apoyo |
| `licencias/` | Licencias de terceros para distribuir con el juego |

## Comprobar que el proyecto funciona

```bash
GODOT=/ruta/a/godot herramientas/comprobar.sh
```

Importa el proyecto en modo headless, pasa la prueba de humo y todas las pruebas `pruebas/test_*.gd` (cocción, rejilla de calor y una hamburguesa real sobre la parrilla). Falla si alguna prueba falla o hay errores de script.

`herramientas/captura.gd` saca una captura de la parrilla (necesita pantalla o `xvfb-run`).

## Modelos 3D

Los modelos propios se generan con scripts de Blender en `herramientas/blender/`, así se pueden rehacer y retocar. Se exportan a `arte/modelos/*.glb` (lo que usa Godot) y se guarda también el `.blend`. Godot no importa los `.blend` (desactivado en el proyecto).

```bash
blender --background --python herramientas/blender/pinzas.py
blender --background --python herramientas/blender/basura.py
blender --background --python herramientas/blender/trapo.py
```

Sin Blender instalado vale el módulo de PyPI: `pip install bpy==5.3.0` (Python 3.13) y `python herramientas/blender/pinzas.py`.

## Créditos

Todo asset o código de terceros va en [`CREDITS.md`](CREDITS.md) con su licencia antes de entrar al repo.
