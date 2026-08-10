# 📋 Lista de Comandos - SQL Server + Docker

## 🚀 PRINCIPALES (Recomendados)

### Abrir Docker
```bash
./docker-open.sh
```

### Ejecutar Script Maestro
```bash
./run-script.sh
```

### Ejecutar TODO automático
```bash
./run-docker.sh
```

---

## 🐳 COMANDOS DOCKER

### Estado del Contenedor

```bash
# Ver contenedores corriendo
docker ps

# Ver todos los contenedores (incluyendo detenidos)
docker ps -a

# Ver logs del contenedor
docker logs sqlserver_uasd

# Ver logs en tiempo real
docker logs -f sqlserver_uasd

# Ver estadísticas (CPU, memoria, etc)
docker stats sqlserver_uasd
```

### Iniciar/Detener

```bash
# Detener el contenedor
docker stop sqlserver_uasd

# Iniciar el contenedor (si está detenido)
docker start sqlserver_uasd

# Reiniciar el contenedor
docker restart sqlserver_uasd
```

### Eliminar

```bash
# Eliminar contenedor (debe estar detenido)
docker rm sqlserver_uasd

# Eliminar contenedor forzadamente
docker rm -f sqlserver_uasd

# Eliminar imagen de SQL Server
docker rmi mcr.microsoft.com/mssql/server:2022-latest
```

---

## 💾 COMANDOS SQL SERVER (dentro del Contenedor)

### Conectar directamente a la terminal SQL

```bash
docker exec -it sqlserver_uasd /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd1234
```

Una vez conectado, puedes escribir comandos SQL:

```sql
-- Ver versión
SELECT @@VERSION;

-- Ver bases de datos
SELECT name FROM sys.databases;

-- Seleccionar una BD
USE SeguroVehiculos;

-- Ver tablas
SELECT * FROM INFORMATION_SCHEMA.TABLES;

-- Contar registros en una tabla
SELECT COUNT(*) FROM Cliente;

-- Salir
EXIT
```

### Ejecutar comando SQL directamente

```bash
# Ver versión
docker exec sqlserver_uasd /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd1234 -Q "SELECT @@VERSION;"

# Verificar base de datos existe
docker exec sqlserver_uasd /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd1234 -Q "SELECT name FROM sys.databases;"

# Contar clientes
docker exec sqlserver_uasd /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd1234 -Q "USE SeguroVehiculos; SELECT COUNT(*) as TotalClientes FROM Cliente;"
```

### Ejecutar archivo SQL

```bash
# Ejecutar un archivo SQL
docker exec -i sqlserver_uasd /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd1234 -i /ruta/al/archivo.sql

# Ejecutar con input desde archivo local (recomendado)
cat archivo.sql | docker exec -i sqlserver_uasd /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd1234
```

---

## 📊 CONSULTAS ÚTILES (SQL)

Ejecuta estos comandos dentro de SQL Server:

### Ver estructura de tablas

```sql
USE SeguroVehiculos;

-- Listar todas las tablas
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE';

-- Ver columnas de una tabla
SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Cliente';

-- Ver primary keys
SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'Cliente';
```

### Consultas de datos

```sql
USE SeguroVehiculos;

-- Total de clientes
SELECT COUNT(*) as TotalClientes FROM Cliente;

-- Total de pólizas activas
SELECT COUNT(*) FROM Poliza WHERE Estado_Poliza = 'Activa';

-- Total de siniestros reportados
SELECT COUNT(*) FROM Siniestro WHERE Estado_Siniestro = 'Reportado';

-- Pólizas por estado
SELECT Estado_Poliza, COUNT(*) as Total FROM Poliza GROUP BY Estado_Poliza;

-- Siniestros por tipo
SELECT Tipo_Siniestro, COUNT(*) as Total FROM Siniestro GROUP BY Tipo_Siniestro;

-- Ingresos totales por pagos
SELECT SUM(Monto) as IngresoTotal FROM Pagos;

-- Clientes y sus vehículos
SELECT c.Nombre, c.Apellido, v.Placa, v.Marca, v.Modelo 
FROM Cliente c 
JOIN Vehiculo v ON c.ID_Cliente = v.ID_Cliente;
```

---

## 🔄 DOCKER COMPOSE

```bash
# Levantar servicios
docker-compose up -d

# Ver servicios activos
docker-compose ps

# Ver logs
docker-compose logs -f

# Detener servicios
docker-compose stop

# Detener y eliminar servicios
docker-compose down

# Detener y eliminar todo (incluyendo volúmenes)
docker-compose down -v

# Ejecutar comando en un servicio
docker-compose exec sqlserver sqlcmd -S localhost -U sa -P P@ssw0rd1234
```

---

## 🔧 COMANDOS DE VERIFICACIÓN

### Verificar que Docker está corriendo

```bash
docker --version
docker ps
```

### Verificar que SQL Server está accesible

```bash
docker exec sqlserver_uasd /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd1234 -Q "SELECT @@VERSION;"
```

### Ver información del contenedor

```bash
docker inspect sqlserver_uasd
```

### Ver puertos mapeados

```bash
docker port sqlserver_uasd
```

---

## 📋 SECUENCIA DE USO RECOMENDADA

### Primera vez:

```bash
# 1. Abrir Docker
./docker-open.sh

# 2. Ejecutar script maestro
./run-script.sh

# 3. Verificar que funcionó
docker exec sqlserver_uasd /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd1234 -Q "USE SeguroVehiculos; SELECT COUNT(*) FROM Cliente;"
```

### Usar la BD después:

```bash
# 1. Verificar si está corriendo
docker ps

# 2. Si no está, iniciar
docker start sqlserver_uasd

# 3. Conectar desde Azure Data Studio o SSMS
# Server: localhost,1433
# User: sa
# Password: P@ssw0rd1234
```

### Limpiar cuando termines:

```bash
# Detener
docker stop sqlserver_uasd

# Eliminar
docker rm sqlserver_uasd
```

---

## ⚙️ CREDENCIALES

```
Server:   localhost,1433
User:     sa
Password: P@ssw0rd1234
Database: SeguroVehiculos
```

---

## 🆘 SOLUCIÓN DE PROBLEMAS

### Puerto 1433 ya está en uso

```bash
# Buscar qué está usando el puerto
lsof -i :1433

# O cambiar puerto en el comando docker run:
docker run -d -p 1434:1433 ...
# Luego conectar a: localhost,1434
```

### SQL Server no responde

```bash
# Ver logs
docker logs sqlserver_uasd

# Esperar más tiempo
sleep 30

# Reiniciar
docker restart sqlserver_uasd
```

### Error de permisos en scripts

```bash
chmod +x *.sh
./docker-open.sh
```

### Ver qué anda mal

```bash
# Logs detallados
docker logs -f sqlserver_uasd

# Entrar en el contenedor
docker exec -it sqlserver_uasd bash

# Ver procesos dentro del contenedor
docker exec sqlserver_uasd ps aux
```

---

## 📱 CONECTARSE DESDE APLICACIONES

### Azure Data Studio (Recomendado)

1. Descargar: https://learn.microsoft.com/en-us/sql/azure-data-studio/
2. New Connection
3. Llenar:
   - **Server:** localhost,1433
   - **User:** sa
   - **Password:** P@ssw0rd1234
   - **Database:** SeguroVehiculos

### VS Code (con extensión SQL Server)

1. Instalar extensión "SQL Server" de Microsoft
2. Mismo proceso que Azure Data Studio

### DBeaver (Gratuito)

1. Descargar: https://dbeaver.io/
2. New Database Connection → SQL Server
3. Mismo proceso

---

**Última actualización:** 2026-04-26  
**Autor:** Marlenis Concepción  
**Curso:** UASD INF-8236-C2
