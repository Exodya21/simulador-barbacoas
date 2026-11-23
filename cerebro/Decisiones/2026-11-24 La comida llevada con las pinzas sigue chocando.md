---
tipo: decision
fecha: 2026-11-24
hora: 00:09
estado: aceptada
area: Técnico
actualizado: 2026-11-24 00:09
---

# La comida llevada con las pinzas sigue chocando

**Decisión:** la pieza que se lleva con las pinzas solo se congela (pasa a cinemática) y conserva sus colisiones, así que empuja a la comida que toca en vez de atravesarla. Además, el punto de colocación ignora las piezas apiladas encima de la que se lleva (`apiladas_encima`; las hamburguesas van en el grupo "comida"). Commit `7893a8f` en `dev`, "F1: coger la hamburguesa de abajo de una pila ya no atraviesa la de arriba".

**Comentario del usuario:** "cuando pongo una hamburguesa encima de otra y cojo la de abajo, ésta traspasa a la que tiene encima, no debería de traspasarla".

**Causa:**
- Las pinzas quitaban todas las colisiones a la pieza que se llevaba, para que no chocara con el jugador. Eso ya no hace falta desde [[2026-11-24 La comida no choca con el jugador]].
- El punto de colocación caía encima de la pieza apilada, así que al coger la de abajo mirando a la pila, la pieza subía a través de la de arriba.

**Prueba:** `test_pila` (5 comprobaciones), que reproducía el fallo antes del arreglo. Pasan las 8 pruebas.

**Sustituye a:** la parte de [[2026-11-23 Las pinzas colocan la comida donde apuntas]] que decía que, mientras se lleva, la comida no choca con nada. El resto de esa decisión sigue vigente.

**Motivo:** la comida no debe atravesar otra comida, y el jugador ya no choca con la comida porque están en capas distintas.

**Alternativas descartadas:** seguir quitando las colisiones y corregir solo el punto de colocación: la pieza aún podría atravesar otras al moverla por la parrilla.

**Consecuencia:** al llevar una pieza o darle la vuelta, puede empujar a las vecinas, como en una parrilla real.

Relacionado: [[Mecánicas]] · [[2026-11-23 Coger con clic mantenido]] · [[2026-11-23 Animación de salto al dar la vuelta]]
