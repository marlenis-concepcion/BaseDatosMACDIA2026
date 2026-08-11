#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_FILE="$SCRIPT_DIR/Concepcion_Unidad6_Practica5_GeoFinal.js"
CONTAINER_NAME="mongodb-uasd"
CONTAINER_SCRIPT="/tmp/unidad6-practica5-geofinal.js"

if ! docker ps --format '{{.Names}}' | grep -qx "$CONTAINER_NAME"; then
  echo "MongoDB Docker no esta corriendo."
  echo "Primero ejecuta:"
  echo "  docker start $CONTAINER_NAME"
  exit 1
fi

echo "============================================================"
echo " Unidad 6 - Practica No. 5 - GeoJSON y Proyecto Final"
echo " Estudiante: Marlenis Concepcion"
echo " Docente: Bismark Montero"
echo " Conexion: mongodb://127.0.0.1:*******"
echo "============================================================"
echo

docker cp "$SCRIPT_FILE" "$CONTAINER_NAME:$CONTAINER_SCRIPT"
docker exec "$CONTAINER_NAME" mongosh --quiet "$CONTAINER_SCRIPT"

echo
echo "============================================================"
echo " Practica ejecutada. Ya puedes tomar captura de esta consola."
echo " En Compass conecta con: mongodb://127.0.0.1:*******"
echo " Base de datos: unidad6_geo_final"
echo " Colecciones: usuarios, posts, tags, lugares"
echo "============================================================"
