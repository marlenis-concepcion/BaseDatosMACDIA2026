# 📋 Comandos para Ejecutar Cada Script

## 🚀 OPCIÓN FÁCIL: Ejecutar TODO de una vez

```bash
./run-all.sh
```

Esto corre en orden:
1. ✅ DDL (crear tablas)
2. ✅ DML (insertar/actualizar datos)
3. ✅ DQL (consultas SELECT)

---

## 📝 OPCIÓN INDIVIDUAL: Ejecutar cada script por separado

### 1️⃣ DDL (CREATE - Crear tablas)

```bash
cat Marlenis-Concepcion-INF8236-Act4.2-DDL.sql | docker exec -i sqlserver_uasd /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd1234
```

O:
```bash
./run-script.sh < Marlenis-Concepcion-INF8236-Act4.2-DDL.sql
```

---

### 2️⃣ DML (INSERT, UPDATE, DELETE - Datos)

```bash
cat Marlenis-Concepcion-INF8236-Act4.2-DML.sql | docker exec -i sqlserver_uasd /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd1234
```

---

### 3️⃣ DQL (SELECT - Consultas)

```bash
cat Marlenis-Concepcion-INF8236-Act4.2-DQL.sql | docker exec -i sqlserver_uasd /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd1234
```

---

### 4️⃣ Script Maestro (TODO JUNTO - create + insert + delete)

```bash
cat Marlenis-Concepcion-INF8236-Act4.2-Script-Maestro-20-Registros.sql | docker exec -i sqlserver_uasd /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd1234
```

O:
```bash
./run-script.sh
```

---

## 🔍 MODO CONSULTAS INTERACTIVO

Para escribir consultas SQL en vivo:

```bash
./run-queries.sh
```

Luego puedes escribir:
```sql
USE SeguroVehiculos;
GO

SELECT * FROM Cliente;
GO

SELECT COUNT(*) as TotalClientes FROM Cliente;
GO

SELECT * FROM Poliza WHERE Estado_Poliza = 'Activa';
GO

EXIT
```

---

## 💻 Equivalente sin script (conectar directo)

```bash
docker exec -it sqlserver_uasd /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd1234
```

---

## 📊 CONSULTAS RÁPIDAS (sin entrar en modo interactivo)

### Contar registros

```bash
docker exec sqlserver_uasd /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd1234 -Q "USE SeguroVehiculos; SELECT COUNT(*) as TotalClientes FROM Cliente;"
```

### Ver todos los clientes

```bash
docker exec sqlserver_uasd /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd1234 -Q "USE SeguroVehiculos; SELECT * FROM Cliente;"
```

### Ver pólizas activas

```bash
docker exec sqlserver_uasd /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd1234 -Q "USE SeguroVehiculos; SELECT * FROM Poliza WHERE Estado_Poliza = 'Activa';"
```

### Ver siniestros reportados

```bash
docker exec sqlserver_uasd /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd1234 -Q "USE SeguroVehiculos; SELECT * FROM Siniestro WHERE Estado_Siniestro = 'Reportado';"
```

### Ingresos totales por pagos

```bash
docker exec sqlserver_uasd /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd1234 -Q "USE SeguroVehiculos; SELECT SUM(Monto) as IngresoTotal FROM Pagos;"
```

---

## 🎯 SECUENCIA RECOMENDADA

### Primera vez (setup completo):

```bash
# 1. Abrir Docker
./docker-open.sh

# 2. Esperar 25 segundos

# 3. Ejecutar TODO
./run-all.sh

# 4. Verificar
docker exec sqlserver_uasd /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd1234 -Q "USE SeguroVehiculos; SELECT COUNT(*) FROM Cliente;"
```

### Después (solo consultas):

```bash
# Entrar en modo interactivo
./run-queries.sh

# O ejecutar una consulta específica
docker exec sqlserver_uasd /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd1234 -Q "USE SeguroVehiculos; SELECT * FROM Cliente;"
```

---

## 📋 ATAJO RÁPIDO

Crear alias en tu terminal (agrega al `~/.zshrc` o `~/.bash_profile`):

```bash
alias sqltool="docker exec -it sqlserver_uasd /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd1234"
alias sqlquery="docker exec sqlserver_uasd /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd1234 -Q"
```

Luego puedes usar:
```bash
sqltool                    # Modo interactivo
sqlquery "USE SeguroVehiculos; SELECT * FROM Cliente;"
```

---

## ❌ Si algo falla

```bash
# Ver estado del contenedor
docker ps

# Ver logs
docker logs sqlserver_uasd

# Reiniciar Docker
docker restart sqlserver_uasd

# Conectar para verificar manualmente
docker exec -it sqlserver_uasd /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd1234
```

---

**Última actualización:** 2026-04-26  
**Autor:** Marlenis Concepción
