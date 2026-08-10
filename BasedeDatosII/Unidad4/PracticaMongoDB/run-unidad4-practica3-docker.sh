#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATASET_FILE="$SCRIPT_DIR/dataset/ventas-retail.json"
SCRIPT_FILE="$SCRIPT_DIR/Concepcion_Unidad4_Practica3_Retail.js"
CONTAINER_NAME="mongodb-uasd"
CONTAINER_DATASET="/tmp/unidad4-ventas-retail.json"
CONTAINER_SCRIPT="/tmp/unidad4-practica3-retail.js"

if ! docker ps --format '{{.Names}}' | grep -qx "$CONTAINER_NAME"; then
  echo "MongoDB Docker no esta corriendo."
  echo "Primero ejecuta:"
  echo "  docker start $CONTAINER_NAME"
  exit 1
fi

echo "============================================================"
echo " Unidad 4 - Practica No. 3 - Retail"
echo " Estudiante: Marlenis Concepcion"
echo " Docente: Bismark Montero"
echo " Conexion: mongodb://127.0.0.1:*******"
echo "============================================================"
echo

docker cp "$DATASET_FILE" "$CONTAINER_NAME:$CONTAINER_DATASET"
docker cp "$SCRIPT_FILE" "$CONTAINER_NAME:$CONTAINER_SCRIPT"

echo "Importando dataset retail..."
docker exec "$CONTAINER_NAME" mongoimport \
  --db retail \
  --collection ventas \
  --drop \
  --jsonArray \
  --file "$CONTAINER_DATASET"

echo
echo "Ejecutando cinco consultas avanzadas..."
docker exec "$CONTAINER_NAME" mongosh --quiet "$CONTAINER_SCRIPT"

echo
echo "============================================================"
echo " Practica ejecutada. Ya puedes tomar captura de esta consola."
echo " En Compass conecta con: mongodb://127.0.0.1:*******"
echo " Base de datos: retail"
echo " Coleccion: ventas"
echo "============================================================"
