# 🎯 TEMPLATE: Cómo usar esto en Proyectos 5.1 y Final

---

## 📦 Qué Copiar a tu Nuevo Proyecto

Cuando empieces proyecto 5.1 o proyecto final, necesitas estos 3 archivos:

```
proyecto5.1/
├── setup-y-ejecutar.sh              ⬅️ Copiar ESTE
├── GUIA-COMPLETA-DOCKER-MYSQL.md    ⬅️ Copiar ESTE
├── [TU-SCRIPT-MAESTRO].sql          ⬅️ TU ARCHIVO SQL
└── otros archivos del proyecto...
```

---

## 🚀 Opción A: Copia Automática (Terminal)

Si tienes proyecto5.1 creado, ejecuta desde Terminal:

```bash
# Copiar archivos básicos
cp /setup-y-ejecutar.sh ~/Documents/UASD/BaseDatosMACDIA2026/proyecto5.1/

cp /GUIA-COMPLETA-DOCKER-MYSQL.md ~/Documents/UASD/BaseDatosMACDIA2026/proyecto5.1/

# Luego copia tu Script Maestro
cp ~/Documents/UASD/BaseDatosMACDIA2026/proyecto5.1/tu-script-maestro.sql ~/Documents/UASD/BaseDatosMACDIA2026/proyecto5.1/
```

---

## 🔧 Opción B: Copia Manual (Finder)

1. **Abre Finder**
2. **Ve a:** `/`
3. **Copia estos archivos:**
   - `setup-y-ejecutar.sh`
   - `GUIA-COMPLETA-DOCKER-MYSQL.md`
4. **Pégalos en:** `proyecto5.1/` (o `proyecto_final/`)

---

## ✏️ Paso 1: Modificar el Script para tu Proyecto

Si tu Script Maestro tiene otro nombre, edita `setup-y-ejecutar.sh`:

**Abre el archivo y cambia esta línea:**

```bash
# LÍNEA ORIGINAL (Proyecto 4.2)
cat Marlenis-Concepcion-INF8236-Act4.2-Script-Maestro-Actualizado.sql | \

# CAMBIAR A (Proyecto 5.1 - EJEMPLO)
cat Mi-Script-Maestro-Proyecto51.sql | \
```

**Ejemplo completo para proyecto 5.1:**

```bash
#!/bin/bash

# ============================================================
# SCRIPT TODO EN UNO - PROYECTO 5.1
# ============================================================

echo "🚀 INICIANDO SETUP PROYECTO 5.1..."
echo "=========================================="
echo ""

# 1. Eliminar contenedor anterior si existe
echo "1️⃣  Limpiando contenedor anterior..."
docker rm -f mysql_uasd 2>/dev/null || true
echo "   ✅ Limpio"

# 2. Crear contenedor nuevo
echo ""
echo "2️⃣  Creando contenedor MySQL..."
docker run -d --name mysql_uasd \
  -e MYSQL_ROOT_PASSWORD=P@ssw0rd1234 \
  -e MYSQL_DATABASE=SeguroVehiculos \
  -p 3306:3306 \
  mysql:8.0 > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "   ✅ Contenedor creado"
else
    echo "   ❌ Error creando contenedor"
    exit 1
fi

# 3. Esperar a que MySQL inicie
echo ""
echo "3️⃣  Esperando a que MySQL inicie (20 segundos)..."
sleep 20
echo "   ✅ MySQL listo"

# 4. Ejecutar Script Maestro - CAMBIAR EL NOMBRE DEL ARCHIVO AQUÍ
echo ""
echo "4️⃣  Cargando base de datos..."
cat Mi-Script-Maestro-Proyecto51.sql | \  # ⬅️ CAMBIAR ESTE NOMBRE
  docker exec -i mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "   ✅ Base de datos cargada"
else
    echo "   ⚠️  Error durante carga"
fi

# 5. Verificar
echo ""
echo "5️⃣  Verificando datos..."
TABLE_COUNT=$(docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e "SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='SeguroVehiculos';" 2>/dev/null | tail -1)
echo "   📊 Tablas creadas: $TABLE_COUNT"

CLIENT_COUNT=$(docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e "SELECT COUNT(*) FROM Cliente;" 2>/dev/null | tail -1)
echo "   👥 Clientes registrados: $CLIENT_COUNT"

# 6. Tu consulta objetivo
echo ""
echo "6️⃣  Ejecutando consulta objetivo..."
echo "=========================================="
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e \
  "SELECT [tu-consulta-aqui];" 2>&1 | grep -v Warning
echo "=========================================="

echo ""
echo "✅ PROYECTO 5.1 LISTO"
```

---

## 🎯 Paso 2: Ejecutar tu Proyecto

```bash
# Navega a tu carpeta de proyecto
cd ~/Documents/UASD/BaseDatosMACDIA2026/proyecto5.1

# Ejecuta el script
./setup-y-ejecutar.sh
```

---

## 📋 Paso 3: Verificar que Funciona

Deberías ver:
```
🚀 INICIANDO SETUP PROYECTO 5.1...
==========================================

1️⃣  Limpiando contenedor anterior...
   ✅ Limpio

2️⃣  Creando contenedor MySQL...
   ✅ Contenedor creado

3️⃣  Esperando a que MySQL inicie (20 segundos)...
   ✅ MySQL listo

4️⃣  Cargando base de datos...
   ✅ Base de datos cargada

5️⃣  Verificando datos...
   📊 Tablas creadas: [número]
   👥 Clientes registrados: [número]

6️⃣  Ejecutando consulta objetivo...
==========================================
[Tu resultado]
==========================================

✅ PROYECTO 5.1 LISTO
```

---

## 🔍 Ejemplos Rápidos para Adaptar

### Si tu proyecto 5.1 tiene Script Maestro llamado "mi-bd-proyecto5.sql"

**Cambio en setup-y-ejecutar.sh:**
```bash
cat mi-bd-proyecto5.sql | \
  docker exec -i mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos > /dev/null 2>&1
```

### Si tu consulta objetivo es diferente

**Cambio en setup-y-ejecutar.sh:**
```bash
# ORIGINAL
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e \
  "SELECT AVG(Pago_Monto) AS Promedio_Pagos_RD FROM Pago;" 2>&1 | grep -v Warning

# NUEVA (Ejemplo: contar clientes)
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e \
  "SELECT COUNT(*) AS Total_Clientes FROM Cliente;" 2>&1 | grep -v Warning
```

---

## 💡 Quick Tips

### Si quieres cambiar el nombre de la BD

En lugar de `SeguroVehiculos`, cambiar a `MiBD`:

1. Edita `setup-y-ejecutar.sh` donde dice:
```bash
-e MYSQL_DATABASE=MiBD \
```

2. Cambia todas las referencias a SeguroVehiculos:
```bash
docker exec -i mysql_uasd mysql -u root -pP@ssw0rd1234 MiBD
```

### Si necesitas cambiar la contraseña

Cambia `P@ssw0rd1234` por tu contraseña en:
1. `setup-y-ejecutar.sh` (línea de docker run)
2. Todos los comandos docker exec

### Si quieres tener múltiples proyectos corriendo

Cambia el nombre del contenedor:

```bash
# Para proyecto 5.1
docker run -d --name mysql_proyecto51 ...

# Para proyecto final
docker run -d --name mysql_final ...
```

---

## 📚 Referencia Rápida de Archivos

| Archivo | Propósito | Copiar a 5.1 | Copiar a Final |
|---------|-----------|--------------|----------------|
| setup-y-ejecutar.sh | Script de ejecución | ✅ Sí | ✅ Sí |
| GUIA-COMPLETA-DOCKER-MYSQL.md | Documentación | ✅ Sí | ✅ Sí |
| [Tu-Script-Maestro].sql | Base de datos | ✅ Sí | ✅ Sí |
| COMANDOS-RAPIDOS.md | Referencia | ⚠️ Opcional | ⚠️ Opcional |

---

## ✅ Checklist para Nuevo Proyecto

- [ ] Carpeta del proyecto creada (proyecto5.1/ o proyecto_final/)
- [ ] Script Maestro listo (tu SQL)
- [ ] setup-y-ejecutar.sh copiado y editado
- [ ] Nombre del archivo SQL actualizado en setup-y-ejecutar.sh
- [ ] Consulta objetivo actualizada en setup-y-ejecutar.sh
- [ ] Script es ejecutable: `chmod +x setup-y-ejecutar.sh`
- [ ] Ejecuté: `./setup-y-ejecutar.sh`
- [ ] Obtengo resultado esperado

---

## 🎓 Resumen del Flujo

```
Proyecto 4.2 (LISTO)
    ↓
    ├─ Copiar setup-y-ejecutar.sh
    ├─ Copiar GUIA-COMPLETA-DOCKER-MYSQL.md
    └─ Editar para nuevo proyecto
    ↓
Proyecto 5.1 (NUEVO)
    ├─ setup-y-ejecutar.sh (adaptado)
    ├─ Tu-Script-Maestro-5.1.sql
    └─ GUIA-COMPLETA-DOCKER-MYSQL.md
    ↓
./setup-y-ejecutar.sh (EJECUTAR)
    ↓
✅ BASE DE DATOS LISTA
```

---

**Autor:** Marlenis Judith Concepcion Cuevas  
**Curso:** UASD INF-8236-C2  
**Uso:** Proyectos 4.2, 5.1 y Final  
**Última actualización:** 26 de Abril, 2026
