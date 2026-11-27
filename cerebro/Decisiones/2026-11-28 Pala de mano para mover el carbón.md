---
tipo: decision
fecha: 2026-11-28
hora: 00:24
estado: aceptada
area: Diseño
---

# Pala de mano para mover el carbón

**Decisión:** nuevo utensilio, la **pala de mano** (id «pala»), para mover el carbón.
- Con la pala vacía, un clic en la parrilla coge brasas de ese sitio con su fuego: hasta 1,2 celdas de carbón en un radio de 0,18 m. Un clic en el saco coge carbón crudo.
- Con la pala cargada, un clic en la parrilla echa lo que lleva donde apuntas. Fuera de la parrilla no lo tira.
- Las brasas de la pala se apagan en 90 s.
- Se ven trozos de carbón en la pala, que brillan según su fuego.

Técnico: `scripts/fuego/pala_mano.gd`, `escenas/utensilios/pala_mano.tscn` y función nueva `RejillaCalor.sacar_carbon`. Comprobado en `test_fuego`. Empieza suelta, fuera del cinturón → [[2026-11-28 Pala y magiclick empiezan sueltos]]. Hecho en `dev`, sin commit.

**Motivo:** lo pidió el usuario en el segundo playtest del encendido: una pala de mano para mover el carbón. Ya estaba en [[Mecánicas]] ("pasar brasas del brasero a la zona de la parrilla").

**Alternativas descartadas:** (pendiente de confirmar)

Relacionado: [[2026-11-25 Encendido con chimenea y abanico]] · [[2026-11-22 Rejilla de calor por celdas]] · [[Arquitectura]] · [[2026-11-28]]
