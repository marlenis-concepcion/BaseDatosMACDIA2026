#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONTAINER_NAME="mongodb-uasd"
BACKUP_DIR="$SCRIPT_DIR/backup"
CONTAINER_BACKUP="/tmp/unidad6_backup"

if ! docker ps --format '{{.Names}}' | grep -qx "$CONTAINER_NAME"; then
  echo "MongoDB Docker no esta corriendo."
  echo "Primero ejecuta:"
  echo "  docker start $CONTAINER_NAME"
  exit 1
fi

mkdir -p "$BACKUP_DIR"

echo "============================================================"
echo " Unidad 6 - Backup MongoDB"
echo " Base de datos: unidad6_geo_final"
echo "============================================================"

docker exec "$CONTAINER_NAME" sh -lc "rm -rf '$CONTAINER_BACKUP' && mongodump --db unidad6_geo_final --out '$CONTAINER_BACKUP'"
docker cp "$CONTAINER_NAME:$CONTAINER_BACKUP/unidad6_geo_final" "$BACKUP_DIR/"

echo "Backup copiado en: /PATH/BaseDatosMACDIA2026/BasedeDatosII/Unidad6/PracticaMongoDB/backup/unidad6_geo_final"
echo "Para restaurar:"
echo "docker cp backup/unidad6_geo_final mongodb-uasd:/tmp/unidad6_geo_final"
echo "docker exec mongodb-uasd mongorestore --drop --db unidad6_geo_final_restored /tmp/unidad6_geo_final"
