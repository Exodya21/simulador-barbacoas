---
tipo: decision
fecha: 2026-11-27
hora: 21:58
estado: aceptada
area: Diseño
---

# El texto de la comida solo sale al mirarla y sin números

**Decisión:** el texto de cada pieza de comida (`CoccionComponente`) solo se ve cuando la miras (el rayo de interacción de Cogito la tiene delante) o cuando la llevas con las pinzas.
- Enseña el **término** ("Muy hecho") y cómo están **las dos caras** ("arriba pasado · abajo dorado").
- No enseña la temperatura del interior ni los números de las caras. Está traducido (claves `PUNTO_*` y `CARA_*`).
- Con la depuración (F3) sigue saliendo el texto completo con números, pero también solo al mirar. Antes, con F3, salía siempre sobre todas las piezas.
- También se quita la temperatura de la rejilla del texto del jugador; sale solo con F3. Esto no lo pidió el usuario: lo decidió Claude al hacer el cambio.

Hecho en `dev`, **sin commit**, pendiente de que el usuario lo pruebe.

**Motivo:** lo pidió el usuario en el primer playtest del encendido: "Que el texto de la carne solo se muestre al pasar por encima. Que no se vea la temperatura del interior pero sí en qué término está, y que tampoco se vean los números de cómo están hechas las caras."

**Alternativas descartadas:** dejarlo como estaba, con texto sobre todas las piezas y con números.

Relacionado: [[2026-11-22 Depuración visible en desarrollo]] · [[2026-11-22 Cocción por caras con superficie e interior]] · [[Mecánicas]] · [[2026-11-27]]
