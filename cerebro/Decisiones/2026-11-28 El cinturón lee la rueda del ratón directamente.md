---
tipo: decision
fecha: 2026-11-28
hora: 00:24
estado: aceptada
area: Técnico
---

# El cinturón lee la rueda del ratón directamente

**Decisión:** el cinturón lee la rueda del ratón directamente (arriba = anterior, abajo = siguiente), sin depender de las acciones de entrada. En `project.godot` la acción de «anterior» vuelve a la rueda hacia arriba.

**Causa del fallo:** la rueda solo funcionaba en una dirección. Un botón de Cogito para restaurar las teclas guarda el mismo objeto de evento en las dos acciones, y las dos quedaron en la rueda hacia abajo. Pasaba en `project.godot` y en el `options.cfg` guardado del usuario, que pisa al proyecto. No se ha tocado el `options.cfg` del usuario: leyendo la rueda directamente, da igual lo que tenga guardado.

Comprobado en `test_cinturon`. Hecho en `dev`, sin commit.

**Motivo:** lo pidió el usuario en el segundo playtest del encendido (que la rueda funcione en las dos direcciones); leerla directamente evita que un `options.cfg` estropeado vuelva a romperla.

**Alternativas descartadas:** arreglar solo las acciones de `project.godot`: el `options.cfg` del usuario las seguiría pisando.

Relacionado: [[2026-11-27 Cinturón de utensilios con 4 huecos]] · [[2026-11-22 Cogito como base del proyecto]] · [[Arquitectura]] · [[2026-11-28]]
