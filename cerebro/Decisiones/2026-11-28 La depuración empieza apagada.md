---
tipo: decision
fecha: 2026-11-28
hora: 00:24
estado: aceptada
area: Herramientas
---

# La depuración empieza apagada

**Sustituye a:** [[2026-11-22 Depuración visible en desarrollo]]

**Decisión:** el autoload `Depuracion` empieza **siempre apagado**, también en las versiones de desarrollo. Los números de la carne (temperaturas y números de las caras) solo se ven al pulsar F3.

Técnico: cambio en `scripts/depuracion.gd`. Antes empezaba encendido en las versiones de desarrollo, y por eso en el editor salían las temperaturas y los números de las caras. `test_cinturon` comprueba que empieza apagado. Hecho en `dev`, sin commit.

**Motivo:** lo pidió el usuario en el segundo playtest del encendido: que los números de la carne solo se vean con F3.

**Alternativas descartadas:** (pendiente de confirmar)

Relacionado: [[2026-11-27 Texto de la comida solo al mirarla y sin números]] · [[Arquitectura]] · [[2026-11-28]]
