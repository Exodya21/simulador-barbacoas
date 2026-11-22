---
tipo: decision
fecha: 2026-11-22
hora: 19:38
estado: aceptada
area: Arte
actualizado: 2026-11-22 21:43
---

# Paleta low-poly

**Decisión:** paleta aprobada en el [[GDD]] → [[2026-11-22 GDD aprobado]]. Color plano sin texturas; la cocción es la excepción (shader). Está en el código como `scripts/paleta.gd` (clase `Paleta`, rama `dev`).

| Color | Hex |
|---|---|
| Brasa | `#E8772E` |
| Llama | `#F5C04A` |
| Carbón | `#2B2A2E` |
| Ceniza | `#9A948C` |
| Metal | `#5A5F66` |
| Ladrillo | `#B5533C` |
| Madera | `#8A5A3B` |
| Césped | `#6FA34B` |
| Mantel | `#F3E6CF` |
| Cielo día | `#6C9BD2` |
| Atardecer | `#F2A07B` |
| Carne cruda | `#D9556B` |
| Sellada | `#B0603A` |
| Hecha | `#8B4A2B` |
| Quemada | `#2E1E17` |

**Motivo:** con color plano se produce rápido en un equipo pequeño y el estilo sigue siendo coherente. Los tonos cálidos (brasa, ladrillo, atardecer) refuerzan el pilar "ambiente de patio", y la gama de cocción hace que el punto se lea por el color.

**Alternativas descartadas:**
- Texturas PBR realistas: cuestan mucho y chocan con los assets CC0 low-poly.
- Una paleta fría o neutra: no transmite calor ni fuego.

Relacionado: [[GDD]] · [[2026-11-22 GDD aprobado]] · [[Roadmap]] · [[Modelos 3D]]
