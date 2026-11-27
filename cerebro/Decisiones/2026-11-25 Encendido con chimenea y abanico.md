---
tipo: decision
fecha: 2026-11-25
hora: 22:25
estado: aceptada
area: Diseño
---

# Encendido con chimenea y abanico

**Decisión:** el carbón se enciende de dos maneras, que conviven (el usuario eligió "Las dos"):
- **Chimenea de encendido**, lo normal: se llena junto al saco de carbón, se enciende, se espera a que esté al rojo (45 s) y se vuelca donde quieras de la parrilla (7 celdas en un círculo de 0,4 m bajo ella). Así el jugador elige las zonas de calor.
- **Abanico**: manteniendo F sobre la parrilla aviva las brasas que se van apagando (el fuego sube hasta el máximo, pero el carbón se gasta 2,5 veces más rápido mientras). Solo aviva carbón que ya arde o que tiene una vecina encendida.

Las brasas pasan a estar **vivas** en la `RejillaCalor`: cada celda tiene carbón (se gasta al arder) y fuego; sin avivar, el fuego baja a un reposo; pasa a las celdas vecinas con carbón; el carbón crudo echado encima las enfría; y al acabarse el carbón se apaga. El patio de prueba empieza frío y sin carbón.

Hecho en la rama `dev` (copia aparte `BARBACOA-dev`): commit `cba34da`, "F2: encendido de carbón con chimenea, saco y abanico, y brasas vivas". El usuario pidió hacer el commit sin probarlo antes. El 27-11-2026 se subió a `origin/dev` (`7893a8f..cba34da`), también a petición del usuario. **Primer playtest del usuario (27-11-2026):** no dijo nada en contra del encendido en sí. Sus comentarios llevaron al cinturón y al texto de la comida, y cambian cómo se usan la chimenea y el abanico. Siguen las dos maneras de encender, pero ahora son utensilios del cinturón que se usan con el clic izquierdo, y la chimenea vuelca las brasas donde apuntas → [[2026-11-27 Cinturón de utensilios con 4 huecos]] · [[2026-11-27 Los utensilios de la mano se usan con el clic izquierdo]]. **Pendiente:** que el usuario pruebe estos cambios.

**Motivo:** la chimenea es como se hace en la vida real y deja al jugador decidir dónde va el calor; el abanico da algo que hacer cuando las brasas bajan.

**Alternativas descartadas:**
- Solo chimenea, sin abanico.
- Pastillas de encendido + abanico, repartiendo el carbón con pala: más manual.

Relacionado: [[2026-11-22 Rejilla de calor por celdas]] · [[2026-11-25 F2 empieza por el encendido de carbón]] · [[2026-11-25 Chimenea y abanico leen F mientras se llevan]] · [[Mecánicas]] · [[Arquitectura]] · [[Roadmap]]
