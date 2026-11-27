---
tipo: produccion
estado: definido
fuente: Tablero FigJam, sección 6
actualizado: 2026-11-24 00:13
---

# Roadmap

**~30 semanas, equipo de 2–3 personas.** Las semanas son orientativas.

> [!important] Regla de oro
> No pasar de fase sin cumplir el hito. Si el prototipo gris no divierte, se itera ahí antes de producir arte.

| Fase | Semanas | Hito |
|---|---|---|
| F0 · Preproducción ✅ | 1–2 | GDD aprobado y repo funcionando |
| F1 · Prototipo gris ✅ | 3–6 | ¿Es divertido girar una hamburguesa? |
| F2 · Vertical slice 👉 en curso | 7–12 | 1 nivel completo y bonito de 10 min |
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
Empezada el 22-11-2026 (commit `0a44ab6` en `dev`) y ✅ **cerrada el 24-11-2026** → [[2026-11-24 F1 cerrada]]
- [x] Parrilla con rejilla de zonas de calor → `RejillaCalor`, 8×4 celdas ([[2026-11-22 Rejilla de calor por celdas]])
- [x] 1 alimento (hamburguesa) con cocción por caras → [[2026-11-22 Cocción por caras con superficie e interior]]
- [x] Pinzas: coger, girar, mover → pinzas modeladas en Blender: mantener el clic izquierdo coge y soltarlo suelta ([[2026-11-23 Coger con clic mantenido]]); la vuelta se da con un minijuego de precisión ([[2026-11-23 Minijuego de dar la vuelta]])
- [x] Termómetro y valores de depuración → versión de depuración con F3 ([[2026-11-22 Depuración visible en desarrollo]]); el termómetro como utensilio queda para más adelante
- [x] Playtest interno → dos rondas de comentarios del usuario, todos arreglados (último arreglo: commit `7893a8f` en `dev`)

Arrastrado de la F0 (no bloquea el hito) → [[2026-11-22 F0 cerrada]]:
- [ ] Guardar vídeos de YouTube de parrilla y gameplay → pasa a la F2
- [ ] Concretar el tipo de violencia (clasificación) → pasa a la F2
- [x] ~~Revisar la licencia de las banderas de Freepik de Cogito~~ → sustituidas por banderas propias ([[2026-11-23 Banderas propias]])

🏁 **Hito:** ¿es divertido girar una hamburguesa? → ✅ **sí, según el playtest del usuario. F1 cerrada el 24-11-2026** → [[2026-11-24 F1 cerrada]]

## F2 · Vertical slice — semanas 7–12
👉 **En curso**, empezada el 25-11-2026 por el encendido de carbón → [[2026-11-25 F2 empieza por el encendido de carbón]]
- [ ] Encendido de carbón y brasas → **hecho en `dev` (commit `cba34da`, subido a `origin/dev` el 27-11-2026), a falta del playtest del usuario**, que dirá qué hay que acabar y mejorar: brasas vivas en la `RejillaCalor`, chimenea de encendido, saco de carbón y abanico; prueba nueva `test_fuego` (29 comprobaciones) → [[2026-11-25 Encendido con chimenea y abanico]]
  - Primer playtest del usuario (27-11-2026): nada en contra del encendido. Hechos sus comentarios en `dev` (commit `d172f22`, subido a `origin/dev` el 27-11-2026), **pendientes de que los pruebe**: cinturón de 4 utensilios (pinzas, abanico, trapo, chimenea) que se usan con el clic izquierdo y texto de la comida solo al mirarla y sin números; 10 pruebas en verde → [[2026-11-27 Cinturón de utensilios con 4 huecos]] · [[2026-11-27 Los utensilios de la mano se usan con el clic izquierdo]] · [[2026-11-27 Texto de la comida solo al mirarla y sin números]]
  - Segundo playtest del usuario (28-11-2026, tras probar `d172f22`). Hechos sus comentarios en `dev` (commit `63bf953`, subido a `origin/dev` el 28-11-2026), **pendientes de que los pruebe**: manos (derecha para los utensilios, izquierda para el fernet), números de la carne solo con F3, soltar y recoger utensilios (G, F, Mayús + 1–4), rueda en las dos direcciones, pala de mano y magiclick obligatorio para prender la chimenea; prueba de humo arreglada; 11 pruebas en verde → [[2026-11-28 Mano derecha para los utensilios e izquierda para el fernet]] · [[2026-11-28 La depuración empieza apagada]] · [[2026-11-28 Soltar y recoger utensilios con G y F]] · [[2026-11-28 El cinturón lee la rueda del ratón directamente]] · [[2026-11-28 Pala de mano para mover el carbón]] · [[2026-11-28 Magiclick obligatorio para prender la chimenea]] · [[2026-11-28 Pala y magiclick empiezan sueltos]]
- [ ] Nivel: la estancia heredada del abuelo → **hecho en `dev` (commit `69fdde1`, subido a `origin/dev` el 27-11-2026), a falta del playtest del usuario**: escena principal `escenas/estancia/estancia.tscn` levantada desde código con primitivas low-poly, 8 reformas con cartel de obra (mantener F), conservadora para comprar carne, bandeja de venta con precio según el punto, autoload `Herencia` (dinero y guardado), carta del abuelo y HUD de dinero; prueba nueva `test_estancia` (52), 11 pruebas en verde → [[2026-11-27 Historia de la estancia heredada del abuelo]] · [[2026-11-27 Escenario construido desde código con primitivas]] · [[2026-11-27 Ocho reformas con requisitos en cadena]] · [[2026-11-27 Pagar reformas manteniendo F en un cartel de obra]] · [[2026-11-27 Vender en bandeja y comprar en conservadora]] · [[2026-11-27 La parrilla del abuelo funciona desde el principio]] · [[2026-11-27 La estancia es la escena principal]]
  - Pendiente: balancear los precios de las reformas y la venta en playtest, y que el usuario apruebe los cambios del [[GDD]].
- [ ] 5 alimentos (filete, chorizo, pollo, maíz, pimiento)
- [ ] Shader crudo → hecho → quemado
- [ ] Humo, llamas, chispas + audio
- [ ] 3 invitados con pedidos y puntuación

Arrastrado de la F0 y la F1 (no bloquea el hito) → [[2026-11-24 F1 cerrada]]:
- [ ] Guardar vídeos de YouTube de parrilla y gameplay (búsquedas en [[Referencias de parrilla y juegos]]) → **en parte**: guardado el vídeo elegido por el usuario, sin revisar
- [ ] Concretar el tipo de violencia (clasificación) → [[2026-11-22 GDD aprobado]]

🏁 **Hito:** 1 nivel completo y bonito de 10 min

## F3 · Producción de contenido — semanas 13–20
- [ ] 15–20 alimentos y recetas (marinados, salsas)
- [ ] 3 parrillas: carbón, gas, kamado/ahumador
- [ ] 3 escenarios (patio, playa, camping) → la estancia pasa a ser el escenario principal; playa y camping quedan por decidir ([[2026-11-27 Historia de la estancia heredada del abuelo]], pendiente de aprobar)
- [ ] Modo carrera + modo libre → carrera = reformar la estancia con el dinero de vender comida (primer paso ya en la F2)
- [ ] Tienda de mejoras y desbloqueos (idea: [[Ruta de mejora de la limpieza]]) → las reformas ya se pagan en carteles de obra ([[2026-11-27 Pagar reformas manteniendo F en un cartel de obra]])

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
