# ⚡ INICIO RÁPIDO - MySQL + Docker en 1 Minuto

---

## 🎯 Lo Esencial

### Para Proyecto 4.2 (AHORA MISMO)

```bash
cd 
./setup-y-ejecutar.sh
```

**Resultado esperado:**
```
✅ PROCESO COMPLETADO EXITOSAMENTE
Promedio_Pagos_RD
17525.000000
```

---

### Para Proyectos 5.1 y Final

1. **Copia 2 archivos a tu carpeta:**
   - `setup-y-ejecutar.sh`
   - `GUIA-COMPLETA-DOCKER-MYSQL.md`

2. **Edita setup-y-ejecutar.sh:**
   ```bash
   # Cambia esta línea (nombre de tu script SQL)
   cat Marlenis-Concepcion-INF8236-Act4.2-Script-Maestro-Actualizado.sql | \
   
   # A tu archivo
   cat mi-script-maestro.sql | \
   ```

3. **Ejecuta:**
   ```bash
   cd tu-carpeta-proyecto
   ./setup-y-ejecutar.sh
   ```

---

## 📋 Archivos de Referencia

| Archivo | Descripción |
|---------|------------|
| **setup-y-ejecutar.sh** | Script automático (RECOMENDADO) |
| **GUIA-COMPLETA-DOCKER-MYSQL.md** | Documentación completa |
| **TEMPLATE-PARA-PROYECTOS.md** | Cómo adaptar a 5.1 y Final |
| **COMANDOS-RAPIDOS.md** | Referencia de comandos |

---

## 🚀 Comando Todo en Uno (sin script)

Si prefieres copiar y pegar un solo comando:

```bash
docker rm -f mysql_uasd 2>/dev/null; docker run -d --name mysql_uasd -e MYSQL_ROOT_PASSWORD=P@ssw0rd1234 -e MYSQL_DATABASE=SeguroVehiculos -p 3306:3306 mysql:8.0; sleep 20; cd ; cat Marlenis-Concepcion-INF8236-Act4.2-Script-Maestro-Actualizado.sql | docker exec -i mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos; docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e "SELECT AVG(Pago_Monto) AS Promedio_Pagos_RD FROM Pago;"
```

---

## 🖥️ Comandos Más Usados

```bash
# Ver todas las tablas
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e "SHOW TABLES;"

# Entrar a MySQL interactivo
docker exec -it mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos

# Ejecutar una consulta rápida
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e "SELECT COUNT(*) FROM Cliente;"

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
   pwd  # Debe mostrar: 
   ```

3. **Lee la guía completa:**
   - `GUIA-COMPLETA-DOCKER-MYSQL.md` → Sección "Solución de Problemas"

---

## 📚 Para Aprender Más

- **Comandos disponibles:** `COMANDOS-RAPIDOS.md`
- **Guía detallada:** `GUIA-COMPLETA-DOCKER-MYSQL.md`
- **Adaptar a tu proyecto:** `TEMPLATE-PARA-PROYECTOS.md`

---

**Estado:** ✅ Funcionando 100%  
**Última prueba:** 26 de Abril, 2026  
**Resultado:** Promedio_Pagos_RD = 17525.000000
