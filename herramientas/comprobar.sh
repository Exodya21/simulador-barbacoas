#!/usr/bin/env bash
# Importa el proyecto y pasa la prueba de humo en modo headless.
# Falla si Godot devuelve error o si aparece algún SCRIPT ERROR / Parse Error.
# Uso: GODOT=/ruta/a/godot herramientas/comprobar.sh
set -uo pipefail
GODOT="${GODOT:-godot}"
cd "$(dirname "$0")/.."

"$GODOT" --headless --path . --import > /tmp/godot-import.log 2>&1
salida=$("$GODOT" --headless --path . --script res://pruebas/humo.gd 2>&1)
codigo=$?
echo "$salida"
if [ $codigo -ne 0 ] || echo "$salida" | grep -qE "SCRIPT ERROR|Parse Error|Failed to load"; then
  echo "❌ Comprobación fallida"
  exit 1
fi
echo "✅ Proyecto OK"
