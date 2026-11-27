---
tipo: diseño
estado: borrador
actualizado: 2026-11-27 22:33
---

# Mecánicas

Lista de mecánicas, sacada de la [[Demo jardín con parrilla]]. Cada una se puede convertir en su propia nota cuando se diseñe en detalle.

## Fuego
- Cantidad de **leña en el brasero** (%).
- **Avivar** el fuego.
- **Brasas** que caen bajo el brasero.
- **Pala**: pasar brasas del brasero a la zona de la parrilla.
- **Calor en la parrilla** según brasas y altura.
- **Encendido con chimenea** (F2): llenar la chimenea junto al saco de carbón, encenderla, esperar 45 s a que esté al rojo y volcar las brasas donde apuntas en la parrilla. Desde el 27-11-2026 es un utensilio del cinturón (tecla 4) que se usa con el clic izquierdo; sigue prendiendo aunque se guarde (antes se cogía con E y se usaba con F) → [[2026-11-25 Encendido con chimenea y abanico]] · [[2026-11-27 Los utensilios de la mano se usan con el clic izquierdo]]
- **Abanico** (F2, tecla 2 del cinturón): manteniendo el clic izquierdo apuntando a la parrilla aviva las brasas de ese punto que se van apagando, a cambio de gastar el carbón más rápido.
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
- Texto de la comida (F2, en `dev` sin commit): solo al mirarla o llevarla con las pinzas; enseña el término y cómo están las dos caras, sin temperaturas ni números (los números, solo con F3) → [[2026-11-27 Texto de la comida solo al mirarla y sin números]]
- Servir a la mesa.

## Cinturón de utensilios
- F2, en `dev` sin commit: 4 huecos, 1 pinzas · 2 abanico · 3 trapo · 4 chimenea de encendido. Las teclas 1–4 sacan el utensilio a la mano; pulsar la del que llevas lo guarda (manos libres para coger con E); la rueda pasa al siguiente. Se empieza con las pinzas. Las manchas solo se limpian con el trapo en la mano → [[2026-11-27 Cinturón de utensilios con 4 huecos]]

## Ambiente
- Hora del día: día / atardecer / noche.
- Sonido.
- Zonas: parrilla, mesa, jardín.

## Controles (primera persona)
Ratón mirar · WASD caminar · Mayús correr · Clic o E usar · 1–5 cambiar módulo · R/F manivela · P pala · Esc menú.

> [!note] Desde el 27-11-2026 las teclas 1–4 y la rueda del ratón son del cinturón de utensilios ([[2026-11-27 Cinturón de utensilios con 4 huecos]]), así que "1–5 cambiar módulo" de la demo tendrá que ir a otras teclas.

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
- [ ] Servir en la mesa con las pinzas, pieza a pieza, con reacción del invitado → [[Referencias visuales]]
- [ ] Servir por tandas: la carne recién salida de la parrilla puntúa más → [[Referencias visuales]]
- [ ] Embutidos (chorizo, morcilla) que sueltan grasa y provocan llamaradas; la morcilla revienta si se pasa → [[Referencias visuales]]
- [ ] Pieza de cocción larga en el kamado o el ahumador (pernil a baja temperatura) que se vigila durante la partida → [[Referencias visuales]]
- [ ] La comida hecha se enfría si no se sirve; una zona templada o una lámpara de calor la mantiene → [[Referencias visuales]]
- [ ] Entrantes (patatas, aros de cebolla, pan, pizza a la parrilla) mientras se espera la carne → [[Referencias visuales]]
- [ ] El plato del invitado se llena pieza a pieza: pide "una más" o dice "ya basta" → [[Referencias visuales]]
- [ ] Escenario o DLC gratuito de parrilla argentina con fútbol en la tele e invitados que reaccionan al partido; sin jugadores, escudos ni marcas reales → [[Referencias visuales]]

Relacionado: [[Core loop]]
