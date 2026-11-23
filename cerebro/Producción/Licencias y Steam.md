---
tipo: produccion
estado: definido
fuente: Tablero FigJam, sección 7
actualizado: 2026-11-23 22:13
---

# ¿Qué podemos usar legalmente para vender en Steam?

Comprobado en noviembre de 2026 en los repositorios y páginas oficiales. **No es asesoría legal.** Guardar captura o copia de cada licencia en el momento de descargar, porque los términos pueden cambiar.

## ✅ Sí — uso comercial libre
| Qué | Licencia | Condiciones |
|---|---|---|
| Godot Engine | MIT | Incluir el aviso de copyright de Godot (y de sus librerías: FreeType, ENet, mbedTLS…) en los créditos o en un archivo de licencias. Sin royalties. |
| Cogito (codeberg.org/Phazorknight/Cogito) | MIT | Incluir su licencia MIT y dar crédito. Revisar los assets incluidos: algunos son CC-BY. El sonido de fuego CC-BY-NC ya se quitó → [[2026-11-22 Quitar sonido de fuego NC de Cogito]]. ✅ Resuelto: sus banderas de Freepik (`freepik_flag_*.png`) se borraron y el selector de idioma usa banderas propias → [[2026-11-23 Banderas propias]] |
| Godot Demo Projects | MIT | Se puede copiar código. Revisar los assets sueltos de cada demo. |
| GodotSteam (movido a Codeberg) | MIT | Para logros, Steam Deck y Steamworks. |
| Kenney | CC0 | Sin créditos obligatorios. No usar el logo de Kenney. |
| Quaternius | CC0 | Sin créditos obligatorios. No revender los modelos sueltos como pack. |
| Poly Haven | CC0 | HDRIs, texturas y modelos. |
| Blender | GPL | Lo que modeles es 100% tuyo. |

## ⚠️ Sí, con condiciones
| Qué | Condiciones |
|---|---|
| Poly Pizza | Cada modelo tiene su licencia. CC0 = libre. CC-BY = poner autor, licencia y enlace en los créditos. Mirar la ficha de cada modelo. |
| Sketchfab | Filtrar por "Downloadable" y licencia. CC0 o CC-BY sí. Evitar NC (no comercial), ND y "Editorial". "Metal Grill": el campo dice CC BY 4.0 → dar crédito. |
| Mixamo (Adobe) | Gratis y sin royalties en juegos. Los personajes y animaciones deben ir dentro del juego; no redistribuir los `.fbx` sueltos (ni en mods ni en packs). |
| Freesound | CC0 sí; CC-BY sí con crédito al autor; CC-BY-NC **no** (es no comercial). Usar el filtro de licencia. |
| Sonniss GDC Bundle | Royalty-free, sin créditos. No revender los sonidos tal cual ni usarlos para entrenar IA. Leer la licencia del año descargado. |
| CGTrader / tiendas de pago | "Royalty Free" permite juegos comerciales. No sirve la licencia "Editorial". Guardar la factura. |

## ❌ No usar en el juego
| Qué | Motivo |
|---|---|
| Kitchen of the Damned | El repo no tiene LICENSE → todos los derechos reservados. Además usa audio sacado de YouTube. |
| Kitchen Chaos (port Godot) | Sin licencia declarada; basado en los assets y el diseño del curso de Code Monkey. |
| Cooking Time (itch.io) | Sin licencia declarada; el repositorio enlazado ya no existe. |
| Womp "BBQ Grill" | Es CC0, pero no se puede descargar (solo en el navegador con Womp Pro). |
| Cualquier asset sin licencia clara | Música de YouTube, assets "NC" o marcas reales (logos de Weber, Coca-Cola…). |
| [[Referencias visuales]] de esta bóveda | Imágenes de terceros: solo referencia interna. |

## 📋 Checklist para publicar en Steam
- [ ] 1. `CREDITS.md` con cada asset, autor, URL y licencia
- [ ] 2. Pantalla de créditos en el juego (CC-BY + MIT)
- [ ] 3. Archivo de licencias de terceros junto al ejecutable
- [ ] 4. Declarar en Steamworks si se usa contenido generado con IA
- [ ] Rellenar en Steamworks la encuesta de contenido para adultos (alcohol, palabrotas y violencia) → [[2026-11-22 GDD aprobado]]
- [ ] Compras dentro del juego: configurar las compras de Steamworks (microtransacciones) y declarar el descriptor de compras en la clasificación → [[2026-11-22 GDD aprobado]]
- [ ] 5. Ante la duda, no usar el asset o pedir permiso por escrito al autor

![[figjam-7-licencias-steam.webp]]
