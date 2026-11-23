---
tipo: diseño
estado: borrador
actualizado: 2026-11-23 23:03
---

# Mecánicas

Lista de mecánicas, sacada de la [[Demo jardín con parrilla]]. Cada una se puede convertir en su propia nota cuando se diseñe en detalle.

## Fuego
- Cantidad de **leña en el brasero** (%).
- **Avivar** el fuego.
- **Brasas** que caen bajo el brasero.
- **Pala**: pasar brasas del brasero a la zona de la parrilla.
- **Calor en la parrilla** según brasas y altura.

## Parrilla
- **Altura regulable** con manivela (clic + ratón, rueda, o R / F).
- **Módulos intercambiables** en los huecos izquierdo y derecho (teclas 1–5) → ver [[Referencias visuales#Módulos]].

## Comida
- Añadir comida.
- Dar la vuelta → **minijuego de precisión** con las pinzas (hecho en la F1). Con la comida cogida (clic izquierdo mantenido), el clic derecho abre una barra con una línea que sube y baja, y una zona perfecta aleatoria. Al soltar el clic izquierdo, la línea se para:
  - Perfecto: vuelta perfecta en el sitio.
  - Bien: se escurre de las pinzas y cae del lado bueno con una probabilidad del 80 % junto a la zona perfecta al 30 % en el borde.
  - Mal: sale despedida y **la comida cae al suelo**.
  - → [[2026-11-23 Minijuego de dar la vuelta]] · [[2026-11-23 Coger con clic mantenido]]
- Comida caída al suelo (hecho en la F1): queda **sucia** y hay que tirarla al **cubo de basura**. Deja en el suelo una **mancha de grasa resbaladiza** que no desaparece hasta que se limpia manteniendo F → [[2026-11-23 Comida caída al suelo sucia, mancha y basura]] · [[2026-11-23 Limpiar manchas manteniendo F]] · [[2026-11-23 Resbalar bajando el agarre de Cogito]]
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
- [ ] Fregona o trapo para limpiar las manchas → [[Utensilio para limpiar manchas]]

Relacionado: [[Core loop]]
