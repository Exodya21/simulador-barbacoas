---
tipo: produccion
estado: definido
fuente: Tablero FigJam, sección 6
actualizado: 2026-11-23 23:15
---

# Roadmap

**~30 semanas, equipo de 2–3 personas.** Las semanas son orientativas.

> [!important] Regla de oro
> No pasar de fase sin cumplir el hito. Si el prototipo gris no divierte, se itera ahí antes de producir arte.

| Fase | Semanas | Hito |
|---|---|---|
| F0 · Preproducción ✅ | 1–2 | GDD aprobado y repo funcionando |
| F1 · Prototipo gris | 3–6 | ¿Es divertido girar una hamburguesa? |
| F2 · Vertical slice | 7–12 | 1 nivel completo y bonito de 10 min |
| F3 · Producción de contenido | 13–20 | Alpha con todo el contenido |
| F4 · Pulido y QA | 21–25 | Beta estable |
| F5 · Lanzamiento | 26–30 | 1.0 publicada 🎉 |

## F0 · Preproducción — semanas 1–2
- [x] GDD de 1 página (público, plataforma, modos) → [[GDD]] aprobado ([[2026-11-22 GDD aprobado]])
- [x] Referencias: parrilla real y juegos de cocina → [[Referencias de parrilla y juegos]] · [[Referencias visuales]] (quedan vídeos concretos de YouTube por guardar a mano)
- [x] Elegir estilo visual low-poly + paleta → [[GDD#Estilo visual]], aprobado ([[2026-11-22 Paleta low-poly]])
- [x] Crear repo Godot 4 + importar Cogito → Godot 4.7.2 + Cogito 1.2.0 en `dev` ([[2026-11-22 Godot 4.7.2 versión fija]]), escena `escenas/patio_prueba.tscn`
- [x] Lista de assets y licencias → `CREDITS.md` en `dev` · [[Modelos 3D]], [[Licencias y Steam]]

🏁 **Hito:** GDD aprobado y repo funcionando → ✅ **F0 cerrada el 22-11-2026** → [[2026-11-22 F0 cerrada]]
- [x] GDD aprobado → [[2026-11-22 GDD aprobado]]
- [x] Repo funcionando → Godot 4.7.2 + Cogito en `dev`, probado en el editor por el usuario

## F1 · Prototipo gris — semanas 3–6
🚧 **En curso** desde el 22-11-2026 (commit `0a44ab6` en `dev`).
- [x] Parrilla con rejilla de zonas de calor → `RejillaCalor`, 8×4 celdas ([[2026-11-22 Rejilla de calor por celdas]])
- [x] 1 alimento (hamburguesa) con cocción por caras → [[2026-11-22 Cocción por caras con superficie e interior]]
- [x] Pinzas: coger, girar, mover → pinzas modeladas en Blender: mantener el clic izquierdo coge y soltarlo suelta ([[2026-11-23 Coger con clic mantenido]]); la vuelta se da con un minijuego de precisión ([[2026-11-23 Minijuego de dar la vuelta]])
- [x] Termómetro y valores de depuración → versión de depuración con F3 ([[2026-11-22 Depuración visible en desarrollo]]); el termómetro como utensilio queda para más adelante
- [ ] Playtest interno

Arrastrado de la F0 (no bloquea el hito) → [[2026-11-22 F0 cerrada]]:
- [ ] Guardar vídeos de YouTube de parrilla y gameplay (búsquedas en [[Referencias de parrilla y juegos]]) → **en parte**: guardado el vídeo elegido por el usuario, sin revisar
- [ ] Concretar el tipo de violencia (clasificación) → [[2026-11-22 GDD aprobado]]
- [x] ~~Revisar la licencia de las banderas de Freepik de Cogito~~ → sustituidas por banderas propias ([[2026-11-23 Banderas propias]])

🏁 **Hito:** ¿es divertido girar una hamburguesa?

## F2 · Vertical slice — semanas 7–12
- [ ] Encendido de carbón y brasas
- [ ] 5 alimentos (filete, chorizo, pollo, maíz, pimiento)
- [ ] Shader crudo → hecho → quemado
- [ ] Humo, llamas, chispas + audio
- [ ] 3 invitados con pedidos y puntuación

🏁 **Hito:** 1 nivel completo y bonito de 10 min

## F3 · Producción de contenido — semanas 13–20
- [ ] 15–20 alimentos y recetas (marinados, salsas)
- [ ] 3 parrillas: carbón, gas, kamado/ahumador
- [ ] 3 escenarios (patio, playa, camping)
- [ ] Modo carrera + modo libre
- [ ] Tienda de mejoras y desbloqueos (idea: [[Ruta de mejora de la limpieza]])

🏁 **Hito:** Alpha con todo el contenido

## F4 · Pulido y QA — semanas 21–25
- [ ] Tutorial y onboarding
- [ ] UI/HUD final y accesibilidad
- [ ] Optimización (Steam Deck / PCs modestos)
- [ ] Playtests externos y balanceo
- [ ] Corrección de bugs

🏁 **Hito:** Beta estable

## F5 · Lanzamiento — semanas 26–30
- [ ] Página de Steam y wishlists
- [ ] Demo en itch.io / Steam Next Fest
- [ ] Tráiler y capturas
- [ ] Lanzamiento 1.0
- [ ] Parches y feedback de la comunidad

🏁 **Hito:** 1.0 publicada 🎉

## 👉 Próximos pasos esta semana
- [ ] 1. Instalar Godot 4 y Blender
- [x] 2. Clonar Cogito y probar su demo (importado y probado en modo headless; probado en el editor con Godot 4.7.2)
- [ ] 3. Descargar Kenney Food Kit
- [x] 4. Escribir el GDD de 1 página (aprobado → [[GDD]])
- [x] 5. Prototipar la rejilla de calor con cubos (hecho en la F1 → [[2026-11-22 Rejilla de calor por celdas]])

## Ya hecho (fuera del plan)
- [x] Demo web del concepto → [[Demo jardín con parrilla]]
- [x] Repositorio y documentación → [[Repositorio y ramas]]

![[figjam-6-hoja-de-ruta.webp]]
