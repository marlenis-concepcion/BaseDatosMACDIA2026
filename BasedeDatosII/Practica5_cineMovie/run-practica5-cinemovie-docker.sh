#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONTAINER_NAME="${CONTAINER_NAME:-mongodb-uasd}"
if ! command -v docker >/dev/null 2>&1; then
  echo "Docker no está instalado. También puede ejecutar el archivo .js con mongosh."
  exit 1
fi
if ! docker ps --format '{{.Names}}' | grep -Fxq "$CONTAINER_NAME"; then
  echo "Inicie MongoDB con: docker start $CONTAINER_NAME"
  exit 1
fi
mkdir -p "$SCRIPT_DIR/evidencias"
docker cp "$SCRIPT_DIR/Concepcion_Practica5_cineMovie.js" "$CONTAINER_NAME:/tmp/practica5-cinemovie.js"
docker exec "$CONTAINER_NAME" mongosh --quiet /tmp/practica5-cinemovie.js | tee "$SCRIPT_DIR/evidencias/ejecucion.txt"
