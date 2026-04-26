# 📋 GUÍA COMPLETA - Ejecutar Consulta en Docker (Mac)

## 🎯 OBJETIVO

Ejecutar esta consulta en MySQL dentro de Docker:
```sql
SELECT AVG(Pago_Monto) AS Promedio_Pagos_RD FROM Pago;
```

---

## 📋 TABLA DE CONTENIDOS

1. [Paso 0: Verificaciones previas](#paso-0-verificaciones-previas)
2. [Paso 1: Abrir Docker Desktop](#paso-1-abrir-docker-desktop)
3. [Paso 2: Crear contenedor MySQL](#paso-2-crear-contenedor-mysql)
4. [Paso 3: Cargar la BD completa](#paso-3-cargar-la-bd-completa)
5. [Paso 4: Ejecutar la consulta](#paso-4-ejecutar-la-consulta)
6. [Paso 5: Ver resultados](#paso-5-ver-resultados)

---

## PASO 0: Verificaciones previas

### ¿Tengo Docker?

Abre Terminal y ejecuta:
```bash
docker --version
```

**Esperado:** `Docker version 29.1.3` o superior

**Si dice "command not found":**
- Descarga Docker Desktop: https://www.docker.com/products/docker-desktop
- Instálalo y reinicia

---

## PASO 1: Abrir Docker Desktop

### En tu Mac:

1. Haz clic en **Finder** (ícono de cara en el dock)
2. Ve a **Aplicaciones**
3. Busca **Docker.app**
4. Haz doble clic para abrirlo

**O desde Terminal:**
```bash
open -a Docker
```

**Indicador:** Verás el ícono de Docker en la barra superior (arriba a la derecha) con un punto verde = CORRIENDO

---

## PASO 2: Crear contenedor MySQL

Abre **Terminal** y copia/pega esto:

```bash
docker run -d --name mysql_uasd -e MYSQL_ROOT_PASSWORD=P@ssw0rd1234 -e MYSQL_DATABASE=SeguroVehiculos -p 3306:3306 mysql:8.0
```

### Qué hace:
- `docker run` = crear e iniciar contenedor
- `--name mysql_uasd` = nombre del contenedor
- `-e MYSQL_ROOT_PASSWORD=P@ssw0rd1234` = contraseña (root)
- `-e MYSQL_DATABASE=SeguroVehiculos` = BD (se crea automáticamente)
- `-p 3306:3306` = puerto (por defecto MySQL)
- `mysql:8.0` = imagen de MySQL

### Resultado esperado:
```
0b5026d419efdd7a8c88324b85fcf97934ea0d7474fe71eb0fdd59cc0f55a1f3
```

(Es el ID del contenedor - eso está bien)

---

## PASO 3: Cargar la BD completa

### Espera 15 segundos:
```bash
sleep 15
```

Esto da tiempo a MySQL para iniciar completamente.

### Carga los datos:
```bash
cd 
```

Luego ejecuta:
```bash
./run-all-mysql.sh
```

**Resultado esperado:**
```
1️⃣  CREANDO TABLAS...
   ✅ Completado

2️⃣  INSERTANDO DATOS...
   ✅ Completado

3️⃣  EJECUTANDO CONSULTAS...
   ✅ Completado

✅ TODO COMPLETADO CORRECTAMENTE
```

---

## PASO 4: Ejecutar la consulta

### OPCIÓN A: Consulta rápida (SIN entrar en MySQL)

```bash
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e "SELECT AVG(Pago_Monto) AS Promedio_Pagos_RD FROM Pago;"
```

**Resultado esperado:**
```
+---------------------+
| Promedio_Pagos_RD   |
+---------------------+
| 15416.66666666      |
+---------------------+
```

---

### OPCIÓN B: Modo interactivo (ENTRAR en MySQL)

```bash
docker exec -it mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos
```

Verás algo como:
```
MySQL [SeguroVehiculos]>
```

Luego escribes tu consulta:
```sql
SELECT AVG(Pago_Monto) AS Promedio_Pagos_RD FROM Pago;
```

Presionas **Enter**

**Resultado:**
```
+---------------------+
| Promedio_Pagos_RD   |
+---------------------+
| 15416.66666666      |
+---------------------+
```

Para salir:
```sql
EXIT
```

---

## PASO 5: Ver resultados

### Si usaste OPCIÓN A:
Ya viste el resultado arriba ✅

### Si usaste OPCIÓN B:
El resultado apareció en la pantalla. Para salir, escribiste `EXIT`

---

## 🎯 SECUENCIA RÁPIDA (Copiar y pegar)

### Terminal 1: Abre Docker
```bash
open -a Docker
```

Espera 30 segundos a que Docker inicie

### Terminal 2: Crear todo
```bash
# 1. Crear contenedor
docker run -d --name mysql_uasd -e MYSQL_ROOT_PASSWORD=P@ssw0rd1234 -e MYSQL_DATABASE=SeguroVehiculos -p 3306:3306 mysql:8.0

# 2. Esperar
sleep 15

# 3. Ir a carpeta
cd 

# 4. Cargar datos
./run-all-mysql.sh

# 5. Ejecutar consulta
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e "SELECT AVG(Pago_Monto) AS Promedio_Pagos_RD FROM Pago;"
```

---

## 📊 MÁS CONSULTAS (Opcional)

Una vez en MySQL interactivo, puedes ejecutar:

```sql
-- Total de clientes
SELECT COUNT(*) as Total_Clientes FROM Cliente;

-- Total de pagos
SELECT COUNT(*) as Total_Pagos FROM Pago;

-- Suma de todos los pagos
SELECT SUM(Pago_Monto) as Total_Pagado FROM Pago;

-- Monto máximo pagado
SELECT MAX(Pago_Monto) as Monto_Maximo FROM Pago;

-- Monto mínimo pagado
SELECT MIN(Pago_Monto) as Monto_Minimo FROM Pago;

-- Salir
EXIT
```

---

## 🆘 SOLUCIÓN DE PROBLEMAS

### ❌ "Docker: command not found"
**Solución:** Instala Docker Desktop desde https://www.docker.com/products/docker-desktop

### ❌ "Table 'SeguroVehiculos.Pago' doesn't exist"
**Solución:** Espera más tiempo a que MySQL inicie. Luego ejecuta:
```bash
sleep 20
./run-all-mysql.sh
```

### ❌ "Port 3306 already in use"
**Solución:** Ya hay otro MySQL. Elimina el anterior:
```bash
docker rm -f mysql_uasd
```

Luego vuelve a crear:
```bash
docker run -d --name mysql_uasd -e MYSQL_ROOT_PASSWORD=P@ssw0rd1234 -e MYSQL_DATABASE=SeguroVehiculos -p 3306:3306 mysql:8.0
```

### ❌ "Permission denied" en ./run-all-mysql.sh
**Solución:**
```bash
chmod +x /*.sh
./run-all-mysql.sh
```

### ❌ "Cannot connect to MySQL"
**Solución:** Verifica que Docker está corriendo:
```bash
docker ps
```

Si no muestra nada, abre Docker Desktop de nuevo.

---

## 📝 COMANDOS ÚTILES

### Ver si Docker está corriendo
```bash
docker ps
```

### Ver logs de MySQL
```bash
docker logs mysql_uasd
```

### Detener MySQL
```bash
docker stop mysql_uasd
```

### Iniciar MySQL (si está detenido)
```bash
docker start mysql_uasd
```

### Eliminar MySQL completamente
```bash
docker rm -f mysql_uasd
```

---

## ✅ CHECKLIST FINAL

- [ ] Docker Desktop abierto
- [ ] Contenedor MySQL creado
- [ ] Base de datos cargada
- [ ] Consulta ejecutada correctamente
- [ ] Resultado visible en pantalla

---

## 📌 RESUMEN

| Paso | Comando | Tiempo |
|------|---------|--------|
| 1 | `open -a Docker` | 30 seg |
| 2 | `docker run -d ...` | 5 seg |
| 3 | `sleep 15` | 15 seg |
| 4 | `./run-all-mysql.sh` | 10 seg |
| 5 | `docker exec mysql_uasd ...` | 2 seg |
| **TOTAL** | | **~1 minuto** |

---

**Autor:** Marlenis Concepción  
**Curso:** UASD INF-8236-C2  
**Actividad:** 4.2  
**Última actualización:** 2026-04-26
