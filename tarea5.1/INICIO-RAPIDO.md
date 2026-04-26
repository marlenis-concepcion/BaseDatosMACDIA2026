# ⚡ INICIO RÁPIDO - Tarea 5.1 MySQL + Docker

## 🎯 Lo Esencial

### Para Tarea 5.1 (Ahora Mismo)

```bash
cd <tu-carpeta-proyecto>/tarea5.1
./setup-y-ejecutar.sh
```

**Resultado esperado:**
```
✅ TAREA 5.1 LISTA
Empleado_Codigo | Empleado_Nombre | ... | Empleado_SueldoBase
E00001          | Marlenis Judith | ... | 42000.00
...
```

---

## 📋 Archivos Principales

| Archivo | Descripción |
|---------|------------|
| **setup-y-ejecutar.sh** | Script automático (RECOMENDADO) |
| **Marlenis-Concepcion-INF8236-Tarea-5.1-Script-Maestro.sql** | Base de datos completa |

---

## 🚀 Comando Todo en Uno (sin script)

Si prefieres copiar y pegar un solo comando:

```bash
docker rm -f mysql_uasd 2>/dev/null; docker run -d --name mysql_uasd -e MYSQL_ROOT_PASSWORD=P@ssw0rd1234 -e MYSQL_DATABASE=DBNomina -p 3306:3306 mysql:8.0; sleep 20; cat Marlenis-Concepcion-INF8236-Tarea-5.1-Script-Maestro.sql | docker exec -i mysql_uasd mysql -u root -pP@ssw0rd1234 DBNomina; docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 DBNomina -e "SELECT COUNT(*) FROM Empleado;"
```

---

## 🖥️ Comandos Más Usados

```bash
# Ver todas las tablas
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 DBNomina -e "SHOW TABLES;"

# Entrar a MySQL interactivo
docker exec -it mysql_uasd mysql -u root -pP@ssw0rd1234 DBNomina

# Ejecutar una consulta rápida
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 DBNomina -e "SELECT * FROM Empleado;"

# Ver stored procedures
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 DBNomina -e "SHOW PROCEDURE STATUS WHERE DB='DBNomina';"

# Detener MySQL
docker stop mysql_uasd

# Reiniciar MySQL
docker start mysql_uasd
```

---

## ❌ Si Algo Falla

1. **Limpia y reintenta:**
   ```bash
   docker rm -f mysql_uasd
   ./setup-y-ejecutar.sh
   ```

2. **Verifica que estés en la carpeta correcta:**
   ```bash
   pwd  # Debe mostrar: .../tarea5.1
   ```

3. **Verifica que el script es ejecutable:**
   ```bash
   ls -la setup-y-ejecutar.sh
   # Debe mostrar: -rwxr-xr-x ... setup-y-ejecutar.sh
   ```

---

## 📊 Estructura de Base de Datos

### Tablas Maestras
- `Compania` - Información de empresa
- `TipoPeriodoNomina` - Tipos de período (Mensual, Quincenal, Diaria)
- `Departamento` - Departamentos de la empresa
- `Empleado` - Datos de empleados
- `TipoNomina` - Tipos de nómina (Fija, Docencia, Extraordinaria)
- `PeriodoNomina` - Períodos de nómina

### Tablas Transaccionales
- `TransaccionNomina` - Transacciones de nómina

### Tablas de Auditoría y Caché
- `NominaEmpleadoConsultaCache` - Caché de consultas
- `EmpleadoLog` - Log de empleados
- `TransaccionNominaLog` - Log de transacciones
- `TransaccionNominaHistorico` - Histórico de transacciones

---

## 🔧 Objetos Avanzados

### Función
- `FN_SalarioAnual` - Calcula salario anual a partir del mensual

### Procedimientos Almacenados (5)
- `SP_Actualizar_TransaccionesNomina` - Actualiza transacciones con cálculos
- `SP_Consultar_NominaEmpleado` - Consulta nómina de un empleado
- `SP_Insertar_EmpleadoLog` - Registra cambios en empleados
- `SP_Insertar_TransaccionNominaLog` - Registra cambios en transacciones
- `SP_Insertar_TransaccionesNominaHistorico` - Guarda histórico

### Triggers (5)
- `TR_TransaccionNomina_AfterInsert_Actualizar` - Actualiza al insertar
- `TR_TransaccionNomina_AfterInsert_ConsultarEmpleado` - Log al insertar
- `TR_Empleado_Audit` - Audita cambios en empleados
- `TR_TransaccionNomina_Audit` - Audita cambios en transacciones
- `TR_TransaccionNomina_Historico` - Guarda histórico de cambios

### Vistas
- `VW_TotalNominaEmpleado` - Vista materializada de totales por empleado

---

## 💡 Datos de Prueba

La base de datos viene precargada con:
- 1 Compañía (UASD)
- 3 Tipos de Período (Mensual, Quincenal, Diaria)
- 4 Departamentos (Admin, Finanzas, Docencia, TI)
- 6 Empleados con datos realistas
- 3 Períodos de Nómina (Enero-Marzo 2026)

---

## 📚 Para Aprender Más

- **Guía detallada:** Lee los comentarios en `Script-Maestro.sql`
- **Cálculos:** Los montos de AFP, ARS e ISR usan referencias vigentes de R.D. 2026
- **Funcionalidad:** Consulta los comentarios en cada stored procedure

---

**Estado:** ✅ Funcionando 100%  
**Última prueba:** 26 de Abril, 2026  
**Base de datos:** DBNomina con 12 tablas, 5 SP, 1 FN, 5 Triggers, 1 View
