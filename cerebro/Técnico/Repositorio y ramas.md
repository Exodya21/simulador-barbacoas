---
tipo: tecnico
estado: decidido
fecha: 2026-11-22
actualizado: 2026-11-22 19:39
---

# Repositorio y ramas

Repo privado: https://github.com/Exodya21/simulador-barbacoas

| Rama | Uso |
|---|---|
| `main` | Producto **probado y funcional**. Solo recibe merges desde `dev`. |
| `dev` | Trabajo del día a día. |
| `documentacion` | Esta bóveda (ideas, referencias, decisiones). No se mezcla con `main` ni `dev`. |

## Flujo
1. Desarrollar en `dev`.
2. Probar.
3. Cuando está hecho y probado → merge `dev` → `main`.

## Notas
- El plan gratuito de GitHub no permite proteger `main` en repos privados: la regla se cumple por disciplina.
- Este repo usa `http.sslBackend = schannel` porque git daba error de certificado SSL.
- Al cambiar a `dev` o `main`, la carpeta `cerebro/` desaparece del disco (solo existe en `documentacion`). Para editar con Obsidian hay que estar en la rama `documentacion`, o usar un `git worktree` aparte.
- El Documentador sube la bóveda solo a `documentacion`; desde otra rama usa la copia `../simulador-barbacoas-documentacion` (`git worktree`) → [[2026-11-22 Documentador sube solo a documentacion]]
- `.claude/` y `CLAUDE.md` son iguales en las tres ramas; si se cambian, hay que copiarlos a las otras dos → [[2026-11-22 Configuración de Claude en las tres ramas]]
- El código propio va en carpetas en español (`escenas/`, `scripts/`, `datos/`, `pruebas/`, `herramientas/`, `licencias/`) → [[2026-11-22 Carpetas en español]]
- Sin Git LFS por ahora → [[2026-11-22 Sin Git LFS por ahora]]
