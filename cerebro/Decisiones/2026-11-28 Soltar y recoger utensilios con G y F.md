---
tipo: decision
fecha: 2026-11-28
hora: 00:24
estado: aceptada
area: Diseño
---

# Soltar y recoger utensilios con G y F

**Decisión:** el jugador puede soltar los utensilios del cinturón y colocarlos donde quiera.
- **G** (acción nueva `soltar_utensilio`) suelta el utensilio de la mano. Cae delante del jugador como cuerpo físico y su hueco del cinturón queda libre.
- **F** sobre un utensilio suelto lo recoge al hueco seleccionado si está libre; si no, al primer hueco libre, y pasa a la mano. Si el cinturón está lleno, sale el aviso «suelta algo con G».
- **Mayús + 1–4** mueve el utensilio de la mano a ese hueco, cambiándolo por el que hubiera.
- La chimenea sigue prendiéndose aunque esté en el suelo.

Técnico: el utensilio suelto es un `RigidBody3D` con el script nuevo `scripts/utensilios/utensilio_suelto.gd`, una caja de colisión calculada del modelo y una `BasicInteraction` «Guardar en el cinturón». El cinturón gana las funciones `quitar`, `guardar` y `mover`. La G ya la usaba Cogito para `inventory_drop_item`, pero solo dentro de su inventario, que no usamos. Comprobado en `test_cinturon`. Hecho en `dev`, sin commit.

**Motivo:** lo pidió el usuario en el segundo playtest del encendido: poder soltar las cosas del cinturón y colocarlas como quiera.

**Alternativas descartadas:** (pendiente de confirmar)

Relacionado: [[2026-11-27 Cinturón de utensilios con 4 huecos]] · [[2026-11-28 Pala y magiclick empiezan sueltos]] · [[Mecánicas]] · [[Arquitectura]] · [[2026-11-28]]
