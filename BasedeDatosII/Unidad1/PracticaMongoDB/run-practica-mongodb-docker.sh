#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_FILE="$SCRIPT_DIR/40225495809_Concepcion_PracticaMongoDB_mongosh.js"
CONTAINER_NAME="mongodb-uasd"
CONTAINER_SCRIPT="/tmp/practica-mongodb-uasd.js"

if ! docker ps --format '{{.Names}}' | grep -qx "$CONTAINER_NAME"; then
  echo "MongoDB Docker no esta corriendo."
  echo "Primero ejecuta:"
  echo "  docker start $CONTAINER_NAME"
  exit 1
fi

echo "============================================================"
echo " Practica MongoDB - Base de Datos II"
echo " Estudiante: Marlenis Concepcion"
echo " Matricula: 40225495809"
echo " Docente: Bismark Montero"
echo " Conexion: mongodb://127.0.0.1:37017"
echo "============================================================"
echo

docker cp "$SCRIPT_FILE" "$CONTAINER_NAME:$CONTAINER_SCRIPT"
docker exec "$CONTAINER_NAME" mongosh --quiet "$CONTAINER_SCRIPT"

echo
echo "============================================================"
echo " Practica ejecutada. Ya puedes tomar captura de esta consola."
echo " En Compass conecta con: mongodb://127.0.0.1:37017"
echo " Base de datos: maestria_nosql"
echo " Coleccion: estudiantes"
echo "============================================================"
