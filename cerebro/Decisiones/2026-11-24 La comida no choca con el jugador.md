---
tipo: decision
fecha: 2026-11-24
hora: 00:00
estado: aceptada
area: Técnico
actualizado: 2026-11-24 00:01
---

# La comida no choca con el jugador

**Decisión:** la comida pasa a la capa de física 2 (interactuables), que el cuerpo del jugador no toca. Con su máscara 1|2 sigue chocando con el entorno (parrilla, mesa y suelo) y con otra comida. El rayo de interacción de Cogito y las pinzas la siguen viendo. Commit `48e1e8f` en `dev`, "F1: el jugador ya no empuja la comida".

**Comentario del usuario:** "parece que hay colisiones con el cuerpo del jugador y la comida en el suelo, las empuja mucho, no debería hacerlo".

**Causa:** el jugador de Cogito da un impulso fijo a cualquier RigidBody que toca (`PLAYER_PUSH_FORCE = 1,3`). A una hamburguesa de 150 g la lanzaba a más de 6 m.

**Prueba:** `test_jugador_comida` (6 comprobaciones). El jugador anda por encima de una hamburguesa en el suelo sin moverla, y dos hamburguesas se apilan. Con las capas antiguas la prueba falla, porque la hamburguesa salía a 6,5 m. Todas las pruebas pasan.

**Motivo:** el empujón de Cogito es desproporcionado para piezas tan ligeras, y la comida del suelo no debe moverse sola.

**Alternativas descartadas:**
- Bajar `PLAYER_PUSH_FORCE` en el jugador: afectaría a todos los objetos y aun así movería la comida.
- Hacer la comida más pesada: falsearía su física al cogerla y al lanzarla.
- Parchear el código de empuje de Cogito.

**Consecuencia:** el jugador atraviesa la comida del suelo en vez de tropezar con ella.

Relacionado: [[2026-11-22 Cogito como base del proyecto]] · [[2026-11-23 Resbalar bajando el agarre de Cogito]] · [[2026-11-23 Comida caída al suelo sucia, mancha y basura]] · [[Arquitectura]]
