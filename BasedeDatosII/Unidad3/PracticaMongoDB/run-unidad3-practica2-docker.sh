#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATASET_FILE="$SCRIPT_DIR/dataset/empleados.json"
SCRIPT_FILE="$SCRIPT_DIR/Concepcion_Unidad3_Practica2_Empleado.js"
CONTAINER_NAME="mongodb-uasd"
CONTAINER_DATASET="/tmp/unidad3-empleados.json"
CONTAINER_SCRIPT="/tmp/unidad3-practica2-empleado.js"

if ! docker ps --format '{{.Names}}' | grep -qx "$CONTAINER_NAME"; then
  echo "MongoDB Docker no esta corriendo."
  echo "Primero ejecuta:"
  echo "  docker start $CONTAINER_NAME"
  exit 1
fi

echo "============================================================"
echo " Unidad 3 - Practica No. 2 - Empleado"
echo " Estudiante: Marlenis Concepcion"
echo " Docente: Bismark Montero"
echo " Conexion: mongodb://127.0.0.1:*******"
echo "============================================================"
echo

docker cp "$DATASET_FILE" "$CONTAINER_NAME:$CONTAINER_DATASET"
docker cp "$SCRIPT_FILE" "$CONTAINER_NAME:$CONTAINER_SCRIPT"

echo "Importando dataset con mongoimport..."
docker exec "$CONTAINER_NAME" mongoimport \
  --db empresa \
  --collection empleados \
  --drop \
  --jsonArray \
  --file "$CONTAINER_DATASET"

echo
echo "Ejecutando sentencias de insercion y consultas..."
docker exec "$CONTAINER_NAME" mongosh --quiet "$CONTAINER_SCRIPT"

echo
echo "============================================================"
echo " Practica ejecutada. Ya puedes tomar captura de esta consola."
echo " En Compass conecta con: mongodb://127.0.0.1:*******"
echo " Base de datos: empresa"
echo " Coleccion: empleados"
echo "============================================================"
