---
tipo: decision
fecha: 2026-11-27
hora: 21:58
estado: aceptada
area: Diseño
---

# Cinturón de utensilios con 4 huecos

**Decisión:** el personaje lleva un **cinturón** con 4 huecos donde guarda sus utensilios. Se empieza con los cuatro: **1 pinzas, 2 abanico, 3 trapo, 4 chimenea de encendido**.
- Las teclas 1–4 sacan el utensilio a la mano. Pulsar la del que llevas lo guarda y deja las manos libres (por ejemplo, para coger cosas con E). La rueda del ratón pasa al siguiente.
- Se empieza con las pinzas en la mano. Al guardarlas sueltan lo que llevan.
- Barra en pantalla abajo en el centro, con los colores de la paleta; el utensilio de la mano lleva el borde naranja brasa.
- Se esconden los huecos rápidos de Cogito (la cruceta 1–4), que se solapaban con la barra.
- El **trapo** también va al cinturón: las manchas solo se limpian con el trapo en la mano (se sigue manteniendo F). Sin él, la mancha no ofrece limpiar y su nombre dice "Mancha de grasa · saca el trapo (3)". Mientras frota, el trapo de la mano se esconde.
- El orden de los huecos (de más a menos usado) lo eligió Claude, no el usuario.

Técnico: autoload nuevo `Cinturon` (`scripts/utensilios/cinturon.gd`), barra `scripts/interfaz/cinturon_hud.gd` y base nueva `UtensilioMano` (`scripts/utensilios/utensilio_mano.gd`): los cuatro utensilios cuelgan de la cámara y solo funcionan en la mano. Las pinzas heredan de ella. Prueba nueva `test_cinturon` (29 comprobaciones). Hecho en `dev`: commit `d172f22` ("F2: cinturón de utensilios y texto de la comida solo al mirarla"), subido a `origin/dev` el 27-11-2026 a petición del usuario para probarlo. **Pendiente:** su prueba en el editor.

**Ajustada el 28-11-2026 (segundo playtest, en `dev` sin commit):** la rueda funciona en las dos direcciones ([[2026-11-28 El cinturón lee la rueda del ratón directamente]]); G suelta el utensilio, F lo recoge y Mayús + 1–4 lo cambia de hueco ([[2026-11-28 Soltar y recoger utensilios con G y F]]); sigue con 4 huecos y la pala y el magiclick empiezan sueltos ([[2026-11-28 Pala y magiclick empiezan sueltos]]).

**Motivo:** lo pidió el usuario en el primer playtest del encendido: "Que el personaje tenga un cinturón y que la pinza y el abanico los pueda guardar en ese cinturón, que de manera inicial tengamos una interfaz con 4 espacios y que inicialmente tengamos el abanico, la pinza, el trapo y la chimenea de encendido."

**Alternativas descartadas:** usar el inventario y los objetos de mano (wieldables) de Cogito: es más pesado y está pensado para armas. El cinturón propio es más simple y controlado.

**Cambia a:** [[2026-11-23 Trapo viejo como utensilio de limpieza]] (ahora hay que llevar el trapo en la mano) · [[2026-11-25 Encendido con chimenea y abanico]] (la chimenea y el abanico van al cinturón) → [[2026-11-27 Los utensilios de la mano se usan con el clic izquierdo]]

Relacionado: [[Mecánicas]] · [[Arquitectura]] · [[2026-11-23 Controles de las pinzas]] · [[2026-11-27]]
