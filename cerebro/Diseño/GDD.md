---
tipo: diseño
estado: aprobado
actualizado: 2026-11-22 21:43
---

# GDD · Simulador de Barbacoas

> [!success] GDD aprobado (22-11-2026)
> Las cinco preguntas abiertas (público, plataforma, cooperativo, estilo visual y negocio) se cerraron el 22-11-2026 → [[2026-11-22 GDD aprobado]]. Con esto se cumple el hito de la F0 **"GDD aprobado"**.

## En una frase
Un simulador de barbacoa en **primera persona** y **low-poly**: enciendes el fuego, controlas las brasas y sacas cada pieza en su punto para que tus invitados se vayan contentos.

## Pilares
1. **El fuego manda.** El calor depende de las brasas, la zona y la altura de la parrilla. Nada se cocina por temporizador.
2. **Leer la comida.** El punto se sabe por el color, el sonido y el termómetro, no por una barra.
3. **Tacto físico.** Coger, girar y mover con pinzas tiene que sentirse bien (física Jolt, base de Cogito).
4. **Ambiente de patio.** Tarde de verano, luz cálida, humo: relajante, no estresante. La presión llega por los pedidos, no por el caos.

## Público
- **Principal:** jugadores de simuladores de oficio y cocina (tipo "cooking sim" y "job sim") en PC, 16–40 años, que juegan sesiones de 20–60 min.
- **Secundario:** streamers y público casual atraído por lo visual (llamaradas, comida quemada, momentos graciosos).
- **Clasificación esperada: no es PEGI 3.** El juego tendrá **alcohol, palabrotas y violencia**. Estimación orientativa: **PEGI 12–16 / ESRB T**, según lo explícito que sea cada cosa. La clasificación oficial sale de los cuestionarios al publicar.
  - Descriptores previstos: *Lenguaje soez*, *Violencia*, *Alcohol* y *Compras dentro del juego* (por las microtransacciones, ver [[#Negocio]]).
  - En Steam hay que declararlo en la **encuesta de contenido para adultos** de la página de la tienda → [[Licencias y Steam]].
  - Por concretar: qué tipo de violencia hay y cuánta (cómica o realista, contra quién), porque es lo que más mueve la clasificación.

## Plataforma
- **Steam, Windows** como objetivo de lanzamiento. **Linux** sale casi gratis con Godot.
- **Steam Deck Verified** como meta de F4 (controles con mando, rendimiento modesto).
- **Demo web en itch.io** para enseñar el prototipo por enlace (F5).
- macOS: solo si sobra tiempo (requiere firma y notarización).

## Modos
| Modo | Qué es | Fase |
|---|---|---|
| **Carrera** | Días de barbacoa con invitados, pedidos y puntuación. El dinero desbloquea parrillas, utensilios, recetas y escenarios. | F3 |
| **Libre (sandbox)** | Todo desbloqueado, sin pedidos ni reloj. Para experimentar y para streamers. | F3 |
| Tutorial | Primera barbacoa guiada dentro del modo carrera. | F4 |
| Cooperativo local u online | **Después de la 1.0**, como actualización. No entra en la 1.0. | Post-1.0 |

## Core loop
Preparar el fuego → recibir pedidos → colocar la comida → gestionar → retirar en su punto → servir y puntuar. Detalle: [[Core loop]], [[Mecánicas]], [[Arquitectura]].

## Estilo visual
- **Low-poly de color plano:** sin texturas detalladas, los materiales son un color de la paleta. El detalle viene de la luz, el humo y las partículas.
- **Luz cálida de atardecer** como escena por defecto; día y noche como variantes.
- **La cocción es la excepción:** un shader mezcla crudo → sellado → hecho → quemado por cada cara del alimento.
- Modelos de comida de Kenney y Quaternius (CC0); parrillas y utensilios propios en Blender → [[Modelos 3D]].

### Paleta (aprobada)
Está en el código del juego como `scripts/paleta.gd` (rama `dev`). Decisión: [[2026-11-22 Paleta low-poly]] · GDD: [[2026-11-22 GDD en borrador]].

| Grupo | Color | Hex |
|---|---|---|
| Fuego | Brasa | `#E8772E` |
| Fuego | Llama | `#F5C04A` |
| Fuego | Carbón | `#2B2A2E` |
| Fuego | Ceniza | `#9A948C` |
| Patio | Metal de la parrilla | `#5A5F66` |
| Patio | Ladrillo | `#B5533C` |
| Patio | Madera | `#8A5A3B` |
| Patio | Césped | `#6FA34B` |
| Patio | Mantel | `#F3E6CF` |
| Cielo | Día | `#6C9BD2` |
| Cielo | Atardecer | `#F2A07B` |
| Cocción | Crudo | `#D9556B` |
| Cocción | Sellado | `#B0603A` |
| Cocción | Hecho | `#8B4A2B` |
| Cocción | Quemado | `#2E1E17` |

## Contenido de la 1.0
- 15–20 alimentos y recetas (marinados, salsas).
- 3 parrillas: carbón/leña, gas, kamado/ahumador.
- 3 escenarios: patio, playa, camping.
- Utensilios: pinzas, espátula, salero, tapa, pala de brasas.

## Controles
Ratón para mirar · WASD caminar · Mayús correr · Clic o E usar · 1–5 módulos · R/F manivela · P pala · Esc menú. Mando completo (Cogito ya lo soporta).

## Negocio
- Precio orientativo: **9,99–14,99 €**.
- **DLC gratuitos** tras el lanzamiento: escenarios, parrillas, recetas…
- **Microtransacciones en el futuro**, después del lanzamiento. Qué se vende y cuándo está por definir. Hay que tenerlas en cuenta desde ya:
  - En Steam van por el sistema de compras de Steamworks, y la tienda marca el juego con *compras dentro del juego*.
  - Suman el descriptor *Compras dentro del juego* a la clasificación por edades → [[#Público]].
  - El guardado y el inventario deben poder registrar compras y contenido desbloqueado.

## Fuera de alcance (1.0)
Multijugador (llega después de la 1.0) · Restaurante o gestión de local · Comida fotorrealista · Historia con diálogos.

## Riesgos
| Riesgo | Plan |
|---|---|
| Girar comida no es divertido | F1 es solo eso: si el prototipo gris no divierte, no se pasa de fase. |
| La física de pinzas es frustrante | Asistencia de agarre (imán suave) y opción de "clic para girar". |
| Licencias de assets | Todo asset pasa por `CREDITS.md` antes de entrar → [[Licencias y Steam]]. |

Relacionado: [[Roadmap]], [[Stack]], [[Referencias visuales]]
