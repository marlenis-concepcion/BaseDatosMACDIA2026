#!/bin/bash

# Script para abrir MySQL en Docker en Mac (ARM64)

CONTAINER_NAME="mysql_uasd"
MYSQL_PASSWORD="P@ssw0rd1234"
MYSQL_DB="SeguroVehiculos"

echo "=========================================="
echo "Abriendo MySQL en Docker (ARM64 compatible)..."
echo "=========================================="
echo ""

# 1. Detener y eliminar contenedor existente si está corriendo
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "Deteniendo contenedor existente..."
    docker stop $CONTAINER_NAME 2>/dev/null || true
    docker rm $CONTAINER_NAME 2>/dev/null || true
fi

# 2. Ejecutar MySQL en Docker
echo "Creando contenedor MySQL..."
docker run -d \
    --name $CONTAINER_NAME \
    -e MYSQL_ROOT_PASSWORD=$MYSQL_PASSWORD \
    -e MYSQL_DATABASE=$MYSQL_DB \
    -p 3306:3306 \
    mysql:8.0

echo "Esperando a que MySQL inicie (15 segundos)..."
sleep 15

# 3. Verificar conexión
echo "Verificando conexión a MySQL..."
docker exec $CONTAINER_NAME mysql -u root -p$MYSQL_PASSWORD -e "SELECT VERSION();" || {
    echo "❌ Error: No se puede conectar a MySQL"
    echo "Intentando de nuevo..."
    sleep 10
    docker exec $CONTAINER_NAME mysql -u root -p$MYSQL_PASSWORD -e "SELECT VERSION();" || exit 1
}

echo ""
echo "=========================================="
echo "✓ MySQL está corriendo y listo"
echo "=========================================="
echo ""
echo "Información de conexión:"
echo "  Host: localhost"
echo "  Port: 3306"
echo "  User: root"
echo "  Password: $MYSQL_PASSWORD"
echo "  Database: $MYSQL_DB"
echo ""
echo "Ahora puedes ejecutar tu script SQL:"
echo ""
echo "  ./run-script-mysql.sh"
echo ""
echo "O conectar interactivamente:"
echo "  docker exec -it $CONTAINER_NAME mysql -u root -p$MYSQL_PASSWORD $MYSQL_DB"
echo ""
echo "Para ver logs:"
echo "  docker logs $CONTAINER_NAME"
echo ""
echo "Para detener:"
echo "  docker stop $CONTAINER_NAME"
