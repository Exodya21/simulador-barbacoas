#!/usr/bin/env bash
# Importa el proyecto, pasa la prueba de humo y todas las pruebas pruebas/test_*.gd
# en modo headless. Falla si alguna prueba falla o aparece un SCRIPT ERROR.
# Uso: GODOT=/ruta/a/godot herramientas/comprobar.sh
set -uo pipefail
GODOT="${GODOT:-godot}"
cd "$(dirname "$0")/.."

"$GODOT" --headless --path . --import > /tmp/godot-import.log 2>&1
fallo=0
for prueba in pruebas/humo.gd pruebas/test_*.gd; do
  salida=$("$GODOT" --headless --path . --script "res://$prueba" 2>&1)
  codigo=$?
  echo "$salida" | grep -E "HUMO|PRUEBA|✗|SCRIPT ERROR|Parse Error|Failed to load" || true
  if [ $codigo -ne 0 ] || echo "$salida" | grep -qE "SCRIPT ERROR|Parse Error|Failed to load"; then
    echo "❌ $prueba"
    fallo=1
  fi
done
if [ $fallo -ne 0 ]; then
  echo "❌ Comprobación fallida"
  exit 1
fi
echo "✅ Proyecto OK"
