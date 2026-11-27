---
tipo: diseño
estado: borrador
actualizado: 2026-11-27 22:29
---

# Mecánicas

Lista de mecánicas, sacada de la [[Demo jardín con parrilla]]. Cada una se puede convertir en su propia nota cuando se diseñe en detalle.

## Fuego
- Cantidad de **leña en el brasero** (%).
- **Avivar** el fuego.
- **Brasas** que caen bajo el brasero.
- **Pala**: pasar brasas del brasero a la zona de la parrilla.
- **Calor en la parrilla** según brasas y altura.
- **Encendido con chimenea** (F2, en `dev` a falta de playtest): llenar la chimenea junto al saco de carbón, encenderla, esperar 45 s a que esté al rojo y volcarla donde quieras de la parrilla. Todo con F, mirándola o llevándola (se coge con E) → [[2026-11-25 Encendido con chimenea y abanico]]
- **Abanico** (F2): manteniendo F sobre la parrilla aviva las brasas que se van apagando, a cambio de gastar el carbón más rápido.
- **Brasas vivas** (F2): el carbón se gasta, el fuego baja a un reposo si no se aviva, se pasa a las celdas vecinas con carbón, el carbón crudo enfría las brasas y al acabarse se apaga.

## Parrilla
- **Altura regulable** con manivela (clic + ratón, rueda, o R / F).
- **Módulos intercambiables** en los huecos izquierdo y derecho (teclas 1–5) → ver [[Referencias visuales#Módulos]].

## Comida
- Añadir comida.
- Dar la vuelta → **minijuego de precisión** con las pinzas (hecho en la F1). Con la comida cogida (clic izquierdo mantenido), el clic derecho abre una barra con una línea que sube y baja, y una zona perfecta aleatoria. Al soltar el clic izquierdo, la línea se para:
  - Perfecto: vuelta perfecta en el sitio.
  - Bien: se escurre de las pinzas y cae del lado bueno con una probabilidad del 80 % junto a la zona perfecta al 30 % en el borde.
  - Mal: sale despedida y **la comida cae al suelo**.
  - Al soltar, la comida da un **salto con dos vueltas** (0,65 s) y cae según el resultado → [[2026-11-23 Animación de salto al dar la vuelta]]
  - → [[2026-11-23 Minijuego de dar la vuelta]] · [[2026-11-23 Coger con clic mantenido]]
- Mover con las pinzas: la comida va al punto al que apuntas (hasta 1,8 m) y se queda ahí al soltar → [[2026-11-23 Las pinzas colocan la comida donde apuntas]]
- Comida caída al suelo (hecho en la F1): queda **sucia** y hay que tirarla al **cubo de basura**. Si ha pasado por la parrilla encendida, deja en el suelo una **mancha de grasa resbaladiza** ([[2026-11-23 Solo mancha la comida que ha pasado por la parrilla]]) que no desaparece hasta que se limpia manteniendo F con el **trapo viejo**, 4 s por mancha ([[2026-11-23 Trapo viejo como utensilio de limpieza]]) → [[2026-11-23 Comida caída al suelo sucia, mancha y basura]] · [[2026-11-23 Limpiar manchas manteniendo F]] · [[2026-11-23 Resbalar bajando el agarre de Cogito]]
- Servir a la mesa.

## Ambiente
- Hora del día: día / atardecer / noche.
- Sonido.
- Zonas: parrilla, mesa, jardín.

## Controles (primera persona)
Ratón mirar · WASD caminar · Mayús correr · Clic o E usar · 1–5 cambiar módulo · R/F manivela · P pala · Esc menú.

## Del core loop y la arquitectura (tablero)
- Combustibles: carbón, leña, gas. Zonas de calor directa (fuerte) e indirecta (suave).
- Acciones sobre la comida: girar, mover, salar, tapar, controlar llamaradas (la grasa que gotea las provoca).
- Saber el punto: termómetro, color, sonido; reposo al retirar.
- Cocción por cara: crudo → sellado → al punto → pasado → quemado.
- Invitados con pedido, punto deseado y paciencia; propinas, estrellas, desbloqueos.
- Utensilios: pinzas, espátula, salero, tapa.
→ [[Core loop]], [[Arquitectura]]

## Ideas por explorar
- [x] Puntos de cocción por alimento → definido en [[Arquitectura#🥩 Sistema de Cocción]].
- [x] Comensales con pedidos → [[Arquitectura#🧑‍🤝‍🧑 Invitados y Pedidos]].
- [ ] Clima: el viento ya está en el sistema de fuego; ¿lluvia?
- [ ] ¿Cómo encajan la manivela y los módulos de la demo con el core loop del tablero?
- [x] ¿Qué pasa con la comida que cae al suelo (sucia, se tira, penaliza la nota)? → resuelto: [[2026-11-23 Comida caída al suelo sucia, mancha y basura]]
- [ ] ¿La velocidad de la línea del minijuego sube con la dificultad o con el tipo de comida? → [[Comida en el suelo y dificultad del minijuego]]
- [ ] Perro callejero que se pasea, pilla comida al vuelo y roba si no le das (para más adelante) → [[Perro callejero]]
- [x] Trapo para limpiar las manchas → hecho: [[2026-11-23 Trapo viejo como utensilio de limpieza]]
- [ ] Comprar cepillo y mocho con balde, cada uno más rápido (para el futuro) → [[Ruta de mejora de la limpieza]]
- [ ] Cubo de basura realista que necesita bolsa, y sacar la bolsa llena al contenedor de la calle (para más adelante) → [[Cubo de basura realista con bolsa]]
- [ ] Cortar una pieza para comprobar el punto → [[Referencias visuales]]
- [ ] Marcas de parrilla en la cara que ha tocado las varillas → [[Referencias visuales]]
- [ ] Bandeja para llevar varias piezas a la mesa (pedido para compartir frente a plato individual) → [[Referencias visuales]]
- [ ] Guarniciones: patatas, ensalada, pimientos asados en la parrilla → [[Referencias visuales]]
- [ ] Mesa de acompañamientos y salsas en el patio, que el jugador repone (sencilla: el GDD deja fuera la gestión de restaurante) → [[Referencias visuales]]

Relacionado: [[Core loop]]
