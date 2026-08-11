#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_FILE="$SCRIPT_DIR/Concepcion_Unidad5_Practica4_Modelado.js"
CONTAINER_NAME="mongodb-uasd"
CONTAINER_SCRIPT="/tmp/unidad5-practica4-modelado.js"

if ! docker ps --format '{{.Names}}' | grep -qx "$CONTAINER_NAME"; then
  echo "MongoDB Docker no esta corriendo."
  echo "Primero ejecuta:"
  echo "  docker start $CONTAINER_NAME"
  exit 1
fi

echo "============================================================"
echo " Unidad 5 - Practica No. 4 - Modelado"
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
echo " Base de datos: unidad5_modelado"
echo " Colecciones: usuarios, publicaciones, etiquetas, inscripciones"
echo "============================================================"
