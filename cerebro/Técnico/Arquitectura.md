---
tipo: tecnico
estado: definido
fuente: Tablero FigJam, sección 2
actualizado: 2026-11-23 23:15
---

# Arquitectura

Cada sistema es una **escena/nodo independiente** en Godot que se comunica por **señales**. Los datos (alimentos, parrillas, recetas) viven en **Resources editables** sin tocar código.

```mermaid
flowchart TD
  M["Motor: Godot 4.x · GDScript (+ C# opcional)<br/>Física Jolt · Renderer Forward+ · Export PC / Web"] --> G["GameManager (autoload)<br/>Estado de partida, ronda, reloj, eventos globales"]
  G --> F[🔥 Fuego]
  G --> C[🥩 Cocción]
  G --> I[✋ Física e Interacción]
  G --> P[🧑‍🤝‍🧑 Invitados y Pedidos]
  G --> S[⭐ Puntuación y Progresión]
  G --> V[✨ Presentación]
```

## Sistemas

### 🔥 Sistema de Fuego
- Combustible: carbón, leña, gas
- Temperatura por zonas (rejilla de celdas de calor) → hecho en la F1: `RejillaCalor`, 8×4 celdas ([[2026-11-22 Rejilla de calor por celdas]])
- Brasas vivas (F2, commit `cba34da` en `dev`): cada celda tiene `carbon` y `fuego`; calor = fuego × min(1, carbón × 2). Funciones `echar_carbon`, `avivar`, `encender_dos_zonas`, `carbon_total` y `calor_medio`; export `empezar_encendida`. Brasas visibles con un MultiMesh y el shader `shaders/brasas.gdshader`; la rejilla se dibuja con barras (`crear_barras`) → [[2026-11-25 Encendido con chimenea y abanico]]
- Objetos de encendido: `chimenea_encendido`, `saco_carbon` y `abanico`. Primero (commit `cba34da`) eran objetos de Cogito en `escenas/fuego/` que leían F ellos mismos ([[2026-11-25 Chimenea y abanico leen F mientras se llevan]], sustituida). Desde el 27-11-2026 (commit `d172f22` en `dev`) la chimenea y el abanico son utensilios de mano en `escenas/utensilios/` que se usan con el clic izquierdo → [[2026-11-27 Los utensilios de la mano se usan con el clic izquierdo]]
- Cinturón (commit `d172f22` en `dev`): autoload `Cinturon` (`scripts/utensilios/cinturon.gd`) con 4 huecos, barra `scripts/interfaz/cinturon_hud.gd` y base `UtensilioMano` (`scripts/utensilios/utensilio_mano.gd`) de la que heredan los cuatro utensilios; se esconden los huecos rápidos de Cogito → [[2026-11-27 Cinturón de utensilios con 4 huecos]]
- Encendido, apagado, viento
- Llamaradas cuando gotea grasa

### 🥩 Sistema de Cocción
- Cada alimento: temperatura interna y superficie por cara → hecho en la F1: `EstadoCoccion` y `TipoAlimento` ([[2026-11-22 Cocción por caras con superficie e interior]])
- Estados: crudo → sellado → al punto → pasado → quemado
- Shader que mezcla texturas según cocción
- Tablas de cocción por tipo de carne

### ✋ Física e Interacción
- Primera persona (plantilla [[Juegos de referencia#Cogito|Cogito]])
- Pinzas, espátula, salero, tapa
- RigidBody + Jolt para coger, girar, tirar
- Raycast para apuntar

### 🧑‍🤝‍🧑 Invitados y Pedidos
- Cola de pedidos con punto deseado
- Paciencia / humor de cada invitado
- NPCs low-poly con animaciones simples
- Idea para más adelante: un perro callejero como NPC → [[Perro callejero]]

### ⭐ Puntuación y Progresión
- Nota por punto, tiempo y presentación
- Dinero → nuevas parrillas, utensilios, recetas (idea: [[Ruta de mejora de la limpieza]], trapo → cepillo → mocho)
- Modo carrera + modo libre (sandbox)
- Estancia (commit `69fdde1` en `dev`): autoload `Herencia` (`scripts/estancia/herencia.gd`) con el dinero, las reformas hechas y la carta leída, guardado en `user://estancia.cfg`; con F3 activa, F4 da 10.000 $. Reformas como Resources `Reforma` en `datos/estancia/*.tres`; cartel de obra, conservadora y bandeja de venta en `escenas/estancia/`; HUD `scripts/estancia/hud_estancia.gd`. `TipoAlimento` gana `precio_venta` y `coste_compra` → [[2026-11-27 Ocho reformas con requisitos en cadena]] · [[2026-11-27 Vender en bandeja y comprar en conservadora]]
- Escenario: `Estancia` (`scripts/estancia/estancia.gd`, @tool) y `Geo` (`scripts/estancia/geo.gd`) lo levantan desde código; escena principal `escenas/estancia/estancia.tscn` → [[2026-11-27 Escenario construido desde código con primitivas]] · [[2026-11-27 La estancia es la escena principal]]

### ✨ Presentación
- VFX: GPUParticles3D (humo, brasas, chispas)
- Audio: chisporroteo según temperatura
- HUD: termómetro, pedidos, tutorial

## Capa de datos
- 📦 **Datos** (Resources `.tres`): alimentos, parrillas, combustibles, recetas, niveles
- 💾 **Guardado**: JSON / ConfigFile

Relacionado: [[Stack]], [[Core loop]], [[Skills de Claude]]

![[figjam-2-arquitectura.webp]]
