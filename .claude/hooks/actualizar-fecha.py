#!/usr/bin/env python3
"""Hook PostToolUse: pone 'actualizado: AAAA-MM-DD HH:MM' (hora de Madrid)
en el frontmatter de cada nota de cerebro/ que Claude crea o edita.
Ignora la carpeta Plantillas. Nunca bloquea: ante cualquier error, sale sin hacer nada."""
import json
import re
import sys
from datetime import datetime
from pathlib import Path
from zoneinfo import ZoneInfo

try:
    data = json.load(sys.stdin)
    ruta = Path(data.get("tool_input", {}).get("file_path", "")).resolve()
    # La bóveda es la carpeta 'cerebro' más cercana (vale también para la
    # copia aparte de la rama documentacion creada con git worktree).
    cerebro = next((p for p in ruta.parents if p.name == "cerebro"), None)
    if ruta.suffix != ".md" or cerebro is None:
        sys.exit(0)
    partes = ruta.relative_to(cerebro).parts
    if "Plantillas" in partes or ".obsidian" in partes:
        sys.exit(0)
    texto = ruta.read_text(encoding="utf-8")
    ahora = datetime.now(ZoneInfo("Europe/Madrid")).strftime("%Y-%m-%d %H:%M")
    linea = f"actualizado: {ahora}"
    m = re.match(r"---\n(.*?\n)?---\n", texto, re.S)
    if m:
        cuerpo = m.group(1) or ""
        if re.search(r"^actualizado:.*$", cuerpo, re.M):
            nuevo_fm = re.sub(r"^actualizado:.*$", linea, cuerpo, count=1, flags=re.M)
        else:
            nuevo_fm = cuerpo + linea + "\n"
        nuevo = "---\n" + nuevo_fm + "---\n" + texto[m.end():]
    else:
        nuevo = f"---\n{linea}\n---\n" + texto
    if nuevo != texto:
        ruta.write_text(nuevo, encoding="utf-8")
except Exception:
    pass
sys.exit(0)
