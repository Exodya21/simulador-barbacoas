---
tipo: decision
fecha: 2026-11-22
hora: 19:38
estado: aceptada
area: Producción
actualizado: 2026-11-22 19:40
---

# Quitar el sonido de fuego no comercial de Cogito

**Decisión:** se borra `641848_newlocknew_fireburn.ogg` de Cogito y su referencia en `CogitoProperties.tscn` (`audio_burning` queda vacío). El sonido de fuego del juego será propio o CC0. Los otros assets CC-BY de Cogito (alarm-siren, running-water, underwater loop y el modelo just_a_screw) se acreditan en `CREDITS.md` y se borrarán si el juego no los usa.

**Motivo:** su licencia es CC-BY-NC 4.0 (no comercial): no se puede vender en Steam.

**Alternativas descartadas:**
- Dejarlo solo en las demos: se distribuiría igual dentro del ejecutable.
- Pedir permiso comercial al autor: es lento e incierto, y hay sonidos CC0 de sobra.

Relacionado: [[Licencias y Steam]] · [[2026-11-22 Cogito como base del proyecto]]
