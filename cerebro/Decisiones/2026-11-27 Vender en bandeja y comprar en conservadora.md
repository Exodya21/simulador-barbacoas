---
tipo: decision
fecha: 2026-11-27
hora: 22:46
estado: aceptada
area: Diseño
---

# Vender en bandeja y comprar en conservadora

**Decisión:** primer bucle de dinero de la estancia:
- **Comprar:** la conservadora (`escenas/estancia/conservadora.tscn`, pulsar F) vende hamburguesas crudas a 400 $.
- **Vender:** la bandeja de venta del mostrador del quincho (`escenas/estancia/bandeja_venta.tscn`). La comida que se deja suelta en ella 0,8 s (no cogida con las pinzas) se vende.
- **Precio** = `precio_venta` (1.500 $ la hamburguesa) × punto del interior (poco hecho 0,75 · al punto 1 · hecho 0,9 · muy hecho 0,5) × cada cara, arriba y abajo (quemada ×0,3, pasada ×0,75, sin sellar ×0,6).
- Cruda o sucia **no se vende** y se queda en la bandeja.
- `TipoAlimento` gana `precio_venta` y `coste_compra`.

Es un **primer paso** hasta los invitados con pedidos de la F2.

**Motivo:** (pendiente de confirmar) — hace falta ganar dinero para pagar las reformas antes de que existan los invitados.

**Alternativas descartadas:** (pendiente de confirmar)

Hecho en `dev`: commit `69fdde1`, subido a `origin/dev` (`d172f22..69fdde1`) el 27-11-2026. **Pendiente:** el playtest del usuario.

Relacionado: [[2026-11-27 Historia de la estancia heredada del abuelo]] · [[2026-11-22 Cocción por caras con superficie e interior]] · [[Core loop]] · [[Roadmap]] · [[2026-11-27]]
