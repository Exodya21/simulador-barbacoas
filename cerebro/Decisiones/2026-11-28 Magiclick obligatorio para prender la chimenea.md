---
tipo: decision
fecha: 2026-11-28
hora: 00:24
estado: aceptada
area: Diseño
---

# Magiclick obligatorio para prender la chimenea

**Decisión:** nuevo utensilio, el **magiclick** (id «magiclick»), y es **obligatorio** para prender el carbón de la chimenea.
- Mientras se mantiene el clic sale una llama con luz.
- Un clic apuntando a la chimenea llena, suelta en el suelo o en la mesa, la prende.
- La chimenea llena ya no se enciende con su propio clic: avisa de que hay que soltarla (G) y prenderla con el magiclick.
- El saco llena la chimenea del cinturón o una suelta a menos de 2,5 m.

Técnico: `scripts/fuego/magiclick.gd` y `escenas/utensilios/magiclick.tscn`; cambian `chimenea_encendido.gd` y `saco_carbon.gd`. Textos nuevos `CHIMENEA_falta_magiclick` y `MAGICLICK_*`, y cambia `CHIMENEA_ayuda_encender`. Comprobado en `test_fuego`. Empieza suelto, fuera del cinturón → [[2026-11-28 Pala y magiclick empiezan sueltos]]. Hecho en `dev`, sin commit.

**Motivo:** lo pidió el usuario en el segundo playtest del encendido: un magiclick, obligatorio para prender el carbón de la chimenea.

**Alternativas descartadas:** prender la chimenea con el magiclick mientras está en el cinturón: poco realista.

**Cambia a:** [[2026-11-27 Los utensilios de la mano se usan con el clic izquierdo]] (la chimenea ya no se enciende con su propio clic) · [[2026-11-25 Encendido con chimenea y abanico]]

Relacionado: [[2026-11-28 Soltar y recoger utensilios con G y F]] · [[Mecánicas]] · [[Arquitectura]] · [[2026-11-28]]
