# ✅ SOLUCIÓN PARA MAC - MYSQL EN ARM64

## 🔴 Problema: SQL Server no soporta ARM64

Tu Mac tiene procesador **Apple Silicon (ARM64)** pero SQL Server solo tiene imagen para x86_64.

**Error:**
```
WARNING: The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8)
```

---

## 🟢 Solución: USAR MYSQL 8.0

MySQL **SÍ tiene soporte nativo** para ARM64 en Mac.

---

## 🚀 PASO 1: ABRIR MYSQL EN DOCKER

```bash
docker run -d \
    --name mysql_uasd \
    -e MYSQL_ROOT_PASSWORD=P@ssw0rd1234 \
    -e MYSQL_DATABASE=SeguroVehiculos \
    -p 3306:3306 \
    mysql:8.0
```

O copia y pega simplificado:
```bash
docker run -d --name mysql_uasd -e MYSQL_ROOT_PASSWORD=P@ssw0rd1234 -e MYSQL_DATABASE=SeguroVehiculos -p 3306:3306 mysql:8.0
```

---

## ⏳ PASO 2: ESPERAR A QUE INICIE

```bash
sleep 15
```

---

## ✅ PASO 3: VERIFICAR QUE FUNCIONA

```bash
docker ps
```

Deberías ver algo como:
```
CONTAINER ID   IMAGE       COMMAND                  STATUS
xyz123         mysql:8.0   "docker-entrypoint..."   Up 10 seconds
```

---

## 🚀 PASO 4: EJECUTAR EL SCRIPT MAESTRO

### Opción A: Script automático (más fácil)
```bash
./run-script-mysql.sh
```

### Opción B: Comando manual
```bash
cat Marlenis-Concepcion-INF8236-Act4.2-DDL.sql | docker exec -i mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos
```

---

## 🔍 PASO 5: HACER CONSULTAS

### Modo interactivo:
```bash
docker exec -it mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos
```

Luego escribes:
```sql
SELECT * FROM Cliente;
SELECT COUNT(*) FROM Poliza;
EXIT;
```

### Consulta rápida:
```bash
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e "SELECT COUNT(*) FROM Cliente;"
```

---

## 📋 CREDENCIALES MYSQL

```
Host:     localhost
Port:     3306
User:     root
Password: P@ssw0rd1234
Database: SeguroVehiculos
```

---

## 📊 DIFERENCIAS SQL SERVER vs MYSQL

| Característica | SQL Server | MySQL |
|---|---|---|
| **Identidad (Auto-increment)** | `IDENTITY(1,1)` | `AUTO_INCREMENT` |
| **Sintaxis DateTime** | `DATETIME`, `GETDATE()` | `DATETIME`, `NOW()` |
| **Comentarios** | `--` o `/* */` | `--` o `/* */` |
| **GO Statement** | Requerido | ⚠️ No se usa en MySQL |

---

## ⚙️ COMANDOS ÚTILES MYSQL

```bash
# Ver contenedores
docker ps

# Ver logs
docker logs mysql_uasd

# Detener MySQL
docker stop mysql_uasd

# Iniciar MySQL (si está detenido)
docker start mysql_uasd

# Eliminar MySQL
docker rm mysql_uasd

# Conectar interactivamente
docker exec -it mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos
```

---

## 🔄 MIGRACIÓN DE SQL SERVER A MYSQL

Si tienes scripts SQL Server, necesitas hacer estos cambios:

```sql
-- SQL SERVER
CREATE DATABASE SeguroVehiculos;
GO
USE SeguroVehiculos;
GO
CREATE TABLE Tipo_Vehiculo (
    ID_Tipo INT IDENTITY(1,1) PRIMARY KEY,
    ...
);
GO
```

```sql
-- MYSQL (cambios necesarios)
CREATE DATABASE SeguroVehiculos;
USE SeguroVehiculos;

CREATE TABLE Tipo_Vehiculo (
    ID_Tipo INT AUTO_INCREMENT PRIMARY KEY,
    ...
);

-- QUITAR todos los GO;
-- Cambiar GETDATE() por NOW()
-- Cambiar CAST(GETDATE() AS DATE) por CURDATE()
```

---

## ✅ SECUENCIA RÁPIDA (copiar y pegar)

```bash
# 1. Abrir MySQL
docker run -d --name mysql_uasd -e MYSQL_ROOT_PASSWORD=P@ssw0rd1234 -e MYSQL_DATABASE=SeguroVehiculos -p 3306:3306 mysql:8.0

# 2. Esperar 15 segundos
sleep 15

# 3. Verificar
docker ps

# 4. Ejecutar script
./run-script-mysql.sh

# 5. Hacer consultas
docker exec -it mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos
```

---

## ✨ VENTAJAS DE MYSQL EN MAC

✅ Nativo en ARM64 (rápido)
✅ Menos recursos que SQL Server
✅ Fácil de usar
✅ Ampliamente soportado
✅ Gratis y open source

---

## 🔗 CONECTAR DESDE OTRAS APLICACIONES

### Azure Data Studio
- Host: `localhost`
- Port: `3306`
- User: `root`
- Password: `P@ssw0rd1234`
- Database: `SeguroVehiculos`

### DBeaver
- Same credentials as above

### VS Code (SQL Tools extension)
- Connection type: `MySQL`
- Same credentials

---

**✅ Esta solución funciona perfectamente en Mac con Apple Silicon**

---

**Última actualización:** 2026-04-26  
**Autor:** Marlenis Concepción  
**Curso:** UASD INF-8236-C2
