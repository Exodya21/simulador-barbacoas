---
tipo: decision
fecha: 2026-11-28
hora: 00:24
estado: aceptada
area: Arte
---

# Mano derecha para los utensilios e izquierda para el fernet

**Decisión:** el jugador ve sus dos manos en primera persona. La **derecha** hace todas las interacciones con objetos y la **izquierda** queda para el vaso de fernet, que se hará más adelante.
- Manos low-poly hechas desde el código con cajas y cilindros: puño cerrado, antebrazo y manga. Piel `#C99A73`, manga `#545E6B`, escala 0,82.
- La mano derecha va al agarre del utensilio que llevas. Cada `UtensilioMano` tiene tres exports nuevos: `punto_agarre`, `eje_agarre` (el mango, en coordenadas del utensilio) y `brazo_agarre` (hacia dónde sale el antebrazo, en coordenadas de la cámara), y la función `transform_mano()`.
- Sin utensilio, la mano derecha descansa abajo a la derecha.
- La izquierda descansa abajo a la izquierda y tiene un `Marker3D` «Sujecion» para el futuro vaso de fernet.

Técnico: `scripts/jugador/manos.gd` y `escenas/jugador/manos.tscn`, puestas en el patio de prueba y en la estancia. Herramienta nueva `herramientas/captura_manos.gd`, que saca capturas con cada utensilio en la mano. Hecho en `dev`, sin commit (el usuario no lo ha pedido).

**Motivo:** lo pidió el usuario en el segundo playtest del encendido, tras probar el commit `d172f22`.

**Alternativas descartadas:**
- Un modelo hecho en Blender con huesos: se deja para más adelante (se puede hacer con la skill de Blender).
- Montar los utensilios en un hueso de la mano en vez de en la cámara: obligaba a recolocar todos los utensilios.

Relacionado: [[2026-11-27 Cinturón de utensilios con 4 huecos]] · [[Modelos 3D]] · [[Arquitectura]] · [[2026-11-28]]
