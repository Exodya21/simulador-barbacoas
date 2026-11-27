---
tipo: decision
fecha: 2026-11-27
hora: 22:46
estado: aceptada
area: Diseño
---

# Pagar reformas manteniendo F en un cartel de obra

**Decisión:** delante de cada zona sin reformar hay un **cartel de obra** (`escenas/estancia/cartel_reforma.tscn`) con el nombre, el coste y qué hace falta antes. Se paga **manteniendo F 1,5 s** (HoldInteraction de Cogito). Si no se puede, explica por qué: "Te faltan $ X" o "Antes hay que hacer: …".
- El origen del cartel está en la tabla, a 1,25 m, porque Cogito corta el "mantener" si el origen queda a más de 2 m del jugador.

**Motivo:** mantener la tecla evita pagar sin querer.

**Alternativas descartadas:** un menú o tienda de reformas: más interfaz y menos diegético.

Relacionado: [[2026-11-27 Ocho reformas con requisitos en cadena]] · [[2026-11-23 Limpiar manchas manteniendo F]] · [[Mecánicas]] · [[2026-11-27]]
