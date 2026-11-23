---
tipo: decision
fecha: 2026-11-23
hora: 23:02
estado: aceptada
area: Diseño
actualizado: 2026-11-23 23:49
---

# Comida caída al suelo: sucia, mancha resbaladiza y basura

**Decisión:** la comida que cae al suelo se ensucia, deja en el suelo una mancha de grasa resbaladiza que no desaparece hasta que se limpia, y hay que tirarla a la basura para eliminarla. En palabras del usuario: "si se cae al suelo se ensucia la comida y el suelo también se ensucia y deja manchas resbaladizas de grasa y aceite y no desaparecen hasta que no se limpian, la comida sucia se tiene que tirar a la basura para eliminarla". Commit `5ab9c91` en `dev`.

**Cómo funciona:**
- **Comida sucia:** `SuciedadComponente` (`scripts/limpieza/`) marca como sucia la comida que toca el suelo (grupo "suelo"). El shader de cocción le pinta motas oscuras, y el termómetro de depuración dice "SUCIA · a la basura".
- **Mancha de grasa** (`escenas/limpieza/mancha_grasa.tscn`): cada caída deja una, sin repetirla a menos de 35 cm. La textura, brillante y con salpicaduras, la genera `herramientas/textura_mancha.py`. Al pisarla el jugador resbala → [[2026-11-23 Resbalar bajando el agarre de Cogito]]. Se limpia manteniendo F → [[2026-11-23 Limpiar manchas manteniendo F]].
- **Cubo de basura** (`escenas/limpieza/basura.tscn`), junto a la parrilla: la comida que entra por la boca desaparece y sale el aviso "¡A la basura!".

**Motivo:** lo decidió el usuario. Añade consecuencia a fallar el [[2026-11-23 Minijuego de dar la vuelta|minijuego]] y una tarea más en la barbacoa.

**Alternativas descartadas:**
- Que la comida del suelo se pudiera seguir usando.
- Que las manchas desaparecieran solas.

**Ajustada por:** [[2026-11-23 Solo mancha la comida que ha pasado por la parrilla]]. La comida cruda se ensucia, pero no deja mancha.

Relacionado: [[Mecánicas]] · [[Comida en el suelo y dificultad del minijuego]] · [[Perro callejero]] · [[Modelos 3D]]
