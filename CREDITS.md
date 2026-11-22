# Créditos y licencias

Lista de todo el código y los assets de terceros que lleva el juego, con su origen y licencia.
**Regla:** nada entra en el repo sin una fila aquí. Ante la duda, no se usa.

Leyenda: **CC0** = libre sin créditos · **CC-BY** = crédito obligatorio en el juego · **MIT** = incluir el aviso de copyright.

## Motor y código

| Qué | Autor | Versión | Licencia | Dónde | Notas |
|---|---|---|---|---|---|
| Godot Engine | Juan Linietsky, Ariel Manzur y contribuidores | 4.6.3 | MIT | — | Incluir su aviso de copyright y el de sus librerías (`Engine.get_copyright_info()`) en la pantalla de créditos o junto al ejecutable. |
| COGITO | Philip Drobar (Phazorknight) y contribuidores | 1.2.0 (commit `a2d7afa`, 14-11-2026) | MIT | `addons/cogito/` | codeberg.org/Phazorknight/Cogito · licencia en `licencias/cogito-MIT.txt` |
| Godot State Charts | Jan Thomä (derkork) y contribuidores | incluida en Cogito 1.2.0 | MIT | `addons/godot_state_charts/` | `licencias/godot_state_charts-MIT.txt` |
| Input Helper | Nathan Hoad | incluida en Cogito 1.2.0 | MIT | `addons/input_helper/` | `licencias/input_helper-MIT.txt` |

Código que Cogito adapta (todo MIT o equivalente, según su wiki): First Person Controller Advanced (Like475), EasyMenus (SavoVuksan), QuickAudio (Bryce Dixon), GodotStairs (elvisish), quest-system (shomykohai), FloatableBody (ueshita), minijuego de ganzúa (thelastflapjack, Hexadots).

## Assets que vienen con Cogito (`addons/cogito/Assets/`)

| Qué | Autor | Licencia | Crédito obligatorio |
|---|---|---|---|
| Modelos 3D | Kenney / Philip Drobar | CC0 / MIT | No (MIT: aviso) |
| Prototype Textures | Kenney | CC0 | No |
| Animaciones de NPC (Universal Animation Library) | Quaternius | CC0 | No |
| HDRI `kloofendal_48d_partly_cloudy_puresky` | Greg Zaal (Poly Haven) | CC0 | No |
| Fuente Montserrat | Julieta Ulanovsky y otros | SIL Open Font License 1.1 | No (no vender la fuente suelta) |
| Sonidos varios | Kenney / freesound.org | CC0 o MIT | No |
| `435666__mirkosukovic__alarm-siren.wav` | mirkosukovic (freesound 435666) | **CC-BY 4.0** | **Sí** |
| `241842_poyekhali_running-water.ogg` | Poyekhali (freesound 241842) | **CC-BY 3.0** | **Sí** |
| `651743__department64__underwater-deep-water-loop.ogg` | Department64 (freesound 651743) | **CC-BY 4.0** | **Sí** |
| Modelo `just_a_screw` | XialiMu.Bell (Sketchfab) | **CC-BY 4.0** | **Sí** |
| `524306_bertsz_flame_ignite.ogg` | Bertsz (freesound 524306) | CC0 | No |
| `666290_ekrcoaster_water_hot_surface_short.ogg` | Ekrcoaster (freesound 666290) | CC0 | No |
| `537275` Dirt Sliding | Laughingfish78 | CC0 | No |
| `672201__romankolachnik__water_footsteps_02.wav` | RomanKolachnik | CC0 | No |
| `Spray.ogg`, `SodaOpen.ogg`, `SodaOpen_EnergyDrinkEffect.ogg` | RibhavAgrawal, OxidVideos, VoiceBosch (Pixabay) | Pixabay Content License | No (no redistribuir sueltos) |

> [!warning] Quitado del repo
> `641848_newlocknew_fireburn.ogg` (crepitar de fuego, freesound 641848) es **CC-BY-NC 4.0** (no comercial): **no se puede vender en Steam**. Se ha borrado y se ha quitado su referencia en `addons/cogito/Components/Properties/CogitoProperties.tscn` (`audio_burning` queda vacío). El sonido de fuego del juego será propio o CC0.

Los assets CC-BY de Cogito solo los usan sus escenas de demo. Si el juego final no los usa, se borran antes de publicar y se quitan de esta tabla.

## Assets propios del juego

| Qué | Autor | Licencia | Dónde |
|---|---|---|---|
| Escena de prueba `escenas/patio_prueba.tscn` (cajas grises) | Equipo | Propia | `escenas/` |

## Pendiente de añadir (F0 → F1)

| Qué | Fuente | Licencia |
|---|---|---|
| Food Kit | Kenney (kenney.nl/assets/food-kit) | CC0 |
| Low Poly Food Pack | Quaternius | CC0 |
| Furniture Kit, Nature Kit | Kenney | CC0 |
| HDRI de atardecer | Poly Haven | CC0 |
| Parrilla, brasero, utensilios | Modelado propio en Blender | Propia |
