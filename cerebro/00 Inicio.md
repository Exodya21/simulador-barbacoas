---
tipo: indice
actualizado: 2026-11-24 00:13
---

# 🔥 Simulador de Barbacoas — Cerebro

Simulador de barbacoas 3D en **primera persona**, estilo **low-poly**, hecho con **Godot 4** para vender en **Steam**.

## Estado actual
- [x] Proyecto decidido y stack elegido → [[Stack]]
- [x] Repositorio en GitHub con ramas `main` / `dev` / `documentacion` → [[Repositorio y ramas]]
- [x] Demo web de referencia del ambiente y las mecánicas → [[Demo jardín con parrilla]]
- [x] Contenido completo del tablero FigJam volcado → [[Tablero FigJam]]
- [x] Core loop definido → [[Core loop]]
- [x] **F0 · Preproducción**, cerrada el 22-11-2026: repo Godot + Cogito, créditos, [[GDD]] aprobado y [[Referencias de parrilla y juegos]] → [[Roadmap#F0 · Preproducción — semanas 1–2]]
- [x] **F1 · Prototipo gris**, cerrada el 24-11-2026: rejilla de calor, hamburguesa con cocción por caras, pinzas con minijuego de dar la vuelta, limpieza y playtest del usuario. ¿Es divertido girar una hamburguesa? Sí → [[2026-11-24 F1 cerrada]] · [[Roadmap#F1 · Prototipo gris — semanas 3–6]]
- [ ] **F2 · Vertical slice** (semanas 7–12), 👉 **en curso** desde el 25-11-2026: 1 nivel completo y bonito de 10 min. Primer bloque, encendido de carbón y brasas, hecho en `dev` a falta del playtest del usuario → [[2026-11-25 Encendido con chimenea y abanico]] · [[Roadmap#F2 · Vertical slice — semanas 7–12]]
- [ ] Próximos pasos de esta semana → [[Roadmap#👉 Próximos pasos esta semana]]

## Mapa
**Diseño**
- [[GDD]]
- [[Core loop]]
- [[Mecánicas]]
- [[Juegos de referencia]]
- [[Modelos 3D]]

**Técnico**
- [[Stack]]
- [[Arquitectura]]
- [[Repositorio y ramas]]
- [[Skills de Claude]]

**Producción**
- [[Roadmap]]
- [[Licencias y Steam]]

**Referencias**
- [[Referencias visuales]]
- [[Referencias de parrilla y juegos]]
- [[Demo jardín con parrilla]]
- [[Tablero FigJam]]

**Registro**
- 📜 [[Changelog]]: todo lo que cambia, con fecha y hora. Lo escribe **el Documentador**.
- Decisiones → carpeta `Decisiones/` (una nota por decisión, plantilla [[Plantilla decisión]])
- Sesiones de trabajo → carpeta `Sesiones/` (plantilla [[Plantilla sesión]])
- Ideas sueltas → carpeta `Ideas/` (plantilla [[Plantilla idea]])

## Cómo usar este cerebro
- Todo lo que se decida se apunta en `Decisiones/` con fecha y motivo.
- Claude lee esta nota al empezar cada sesión y deja un resumen en `Sesiones/`.
- Esta bóveda vive en la rama `documentacion` del repo; nunca se mezcla con `main` ni `dev`.
- **Fecha y hora automáticas:** cada nota guarda `actualizado: AAAA-MM-DD HH:MM` en sus propiedades al cambiarla.
  - Cambios hechos en Obsidian → plugin *Update time on edit* (ya configurado; la primera vez Obsidian pide **confiar en el autor y activar los complementos**).
  - Cambios hechos por Claude → hook `.claude/hooks/actualizar-fecha.py` (hora de Madrid).
  - Las plantillas de `Plantillas/` no se fechan.
