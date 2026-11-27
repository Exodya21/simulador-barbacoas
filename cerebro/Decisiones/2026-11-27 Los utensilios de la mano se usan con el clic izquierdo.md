---
tipo: decision
fecha: 2026-11-27
hora: 21:58
estado: aceptada
area: Diseño
---

# Los utensilios de la mano se usan con el clic izquierdo

**Sustituye a:** [[2026-11-25 Chimenea y abanico leen F mientras se llevan]]

**Decisión:** la chimenea de encendido y el abanico dejan de ser objetos sueltos que se cogen con E y se usan con F. Pasan a ser utensilios del [[2026-11-27 Cinturón de utensilios con 4 huecos|cinturón]] y se usan con el **clic izquierdo**, como las pinzas.
- **Abanico:** mantener el clic apuntando a la parrilla aviva las brasas de ese punto.
- **Chimenea:** clic junto al saco la llena (o F en el saco); clic la enciende; sigue prendiendo aunque la guardes en el cinturón; lista, clic apuntando a la parrilla vuelca las brasas **donde apuntas** (antes, bajo la chimenea).
- Las escenas pasan a `escenas/utensilios/`. Se quitan los textos de la interacción con F de la chimenea.
- `test_fuego` reescrita para la chimenea y el abanico del cinturón (30 comprobaciones).

Hecho en `dev`, **sin commit**, pendiente de que el usuario lo pruebe. Decidido por Claude al hacer el cinturón que pidió el usuario.

**Motivo:** así todo lo que va en la mano se usa igual.

**Alternativas descartadas:** seguir cogiéndolos con E y usándolos con F, como en [[2026-11-25 Chimenea y abanico leen F mientras se llevan]].

Relacionado: [[2026-11-25 Encendido con chimenea y abanico]] · [[2026-11-23 Coger con clic mantenido]] · [[Mecánicas]] · [[Arquitectura]] · [[2026-11-27]]
