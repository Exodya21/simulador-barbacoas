---
tipo: decision
fecha: 2026-11-22
hora: 20:15
estado: aceptada
area: Técnico
actualizado: 2026-11-22 20:16
---

# Las traducciones propias van en `idiomas/`, fuera de `addons/`

**Decisión:** nuestras traducciones viven en la carpeta `idiomas/`. La primera es `idiomas/cogito_es.po`, con los 221 textos de Cogito en español.

**Motivo:** actualizar Cogito no las borra, y se ve claro qué es nuestro.

**Alternativas descartadas:** meter `cogito_es.po` dentro de `addons/cogito/Localization/`.

**Nota:** el selector de idioma sí necesita un parche dentro de Cogito (`addons/cogito/Localization/scripts/language_select.gd`). Está anotado en `CREDITS.md` como parche que hay que volver a aplicar si se actualiza Cogito.

Relacionado: [[2026-11-22 Español idioma por defecto]] · [[2026-11-22 Carpetas en español]] · [[2026-11-22 Cogito como base del proyecto]] · [[Repositorio y ramas]]
