/*
    ===============================================================
    TAREA 5.1 - DQL (Data Query Language)
    Consultas de ejemplo y análisis del Sistema de Nomina
    ===============================================================
*/

/* ===============================================================
   CONSULTAS BASICAS DE INFORMACION
   =============================================================== */

-- 1. Listado de empleados activos con sus departamentos
SELECT
    E.Empleado_Codigo,
    CONCAT(E.Empleado_Nombre, ' ', E.Empleado_Apellido) AS NombreCompleto,
    E.Empleado_Cargo,
    D.Departamento_Descripcion,
    E.Empleado_SueldoBase
FROM Empleado E
INNER JOIN Departamento D ON E.Compania_Codigo = D.Compania_Codigo
    AND E.Departamento_Codigo = D.Departamento_Codigo
WHERE E.Empleado_Estado = 'Activo'
ORDER BY E.Empleado_Codigo;

-- 2. Conteo de empleados por departamento
SELECT
    D.Departamento_Descripcion,
    COUNT(E.Empleado_ID) AS TotalEmpleados,
    AVG(E.Empleado_SueldoBase) AS SalarioPromedio,
    MIN(E.Empleado_SueldoBase) AS SalarioMinimo,
    MAX(E.Empleado_SueldoBase) AS SalarioMaximo
FROM Departamento D
LEFT JOIN Empleado E ON D.Compania_Codigo = E.Compania_Codigo
    AND D.Departamento_Codigo = E.Departamento_Codigo
WHERE D.Compania_Codigo = 'UAS'
GROUP BY D.Departamento_Codigo, D.Departamento_Descripcion
ORDER BY TotalEmpleados DESC;

-- 3. Resumen de transacciones por periodo
SELECT
    P.PeriodoNomina_Codigo,
    P.PeriodoNomina_Descripcion,
    P.PeriodoNomina_Estado,
    COUNT(T.TransaccionNomina_ID) AS TotalTransacciones,
    SUM(T.TransaccionNomina_Monto) AS MontoBrutoTotal,
    ROUND(AVG(T.TransaccionNomina_Monto), 2) AS PromedioBruto
FROM PeriodoNomina P
LEFT JOIN TransaccionNomina T ON P.Compania_Codigo = T.Compania_Codigo
    AND P.PeriodoNomina_Codigo = T.PeriodoNomina_Codigo
WHERE P.Compania_Codigo = 'UAS'
GROUP BY P.PeriodoNomina_Codigo, P.PeriodoNomina_Descripcion, P.PeriodoNomina_Estado
ORDER BY P.PeriodoNomina_Anio DESC, P.PeriodoNomina_Codigo DESC;

/* ===============================================================
   CONSULTAS DE ANALISIS FINANCIERO
   =============================================================== */

-- 4. Proyección anual de costos de nomina
SELECT
    E.Empleado_Codigo,
    CONCAT(E.Empleado_Nombre, ' ', E.Empleado_Apellido) AS NombreCompleto,
    E.Empleado_SueldoBase,
    (E.Empleado_SueldoBase * 12) AS SalarioAnual,
    ROUND((E.Empleado_SueldoBase * 12) * 0.0287, 2) AS AFP_Anual,
    ROUND((E.Empleado_SueldoBase * 12) * 0.0304, 2) AS ARS_Anual,
    ROUND((E.Empleado_SueldoBase * 12) * 0.05, 2) AS ISR_Estimado_Anual
FROM Empleado E
WHERE E.Compania_Codigo = 'UAS' AND E.Empleado_Estado = 'Activo'
ORDER BY E.Empleado_SueldoBase DESC;

-- 5. Costo total de nomina por tipo de nomina
SELECT
    TN.TipoNomina_Codigo,
    TN.TipoNomina_Descripcion,
    COUNT(DISTINCT T.Empleado_ID) AS EmpleadosImpactados,
    COUNT(T.TransaccionNomina_ID) AS TotalTransacciones,
    SUM(T.TransaccionNomina_Monto) AS MontoBrutoTotal,
    ROUND(AVG(T.TransaccionNomina_Monto), 2) AS PromedioMonto,
    ROUND(SUM(T.TransaccionNomina_MontoAFP), 2) AS TotalAFP,
    ROUND(SUM(T.TransaccionNomina_MontoARS), 2) AS TotalARS,
    ROUND(SUM(T.TransaccionNomina_MontoISR), 2) AS TotalISR
FROM TipoNomina TN
LEFT JOIN TransaccionNomina T ON TN.Compania_Codigo = T.Compania_Codigo
    AND TN.TipoNomina_Codigo = T.TipoNomina_Codigo
WHERE TN.Compania_Codigo = 'UAS'
GROUP BY TN.TipoNomina_Codigo, TN.TipoNomina_Descripcion
ORDER BY MontoBrutoTotal DESC;

/* ===============================================================
   CONSULTAS DE AUDITORIA Y SEGUIMIENTO
   =============================================================== */

-- 6. Transacciones por empleado en periodo activo
SELECT
    E.Empleado_Codigo,
    CONCAT(E.Empleado_Nombre, ' ', E.Empleado_Apellido) AS NombreCompleto,
    T.TransaccionNomina_Numero,
    T.PeriodoNomina_Codigo,
    T.TransaccionNomina_Fecha,
    T.TransaccionNomina_Monto AS MontoBruto,
    T.TransaccionNomina_MontoAFP,
    T.TransaccionNomina_MontoARS,
    T.TransaccionNomina_MontoISR,
    T.TransaccionNomina_SueldonNeto AS MontoNeto,
    T.TransaccionNomina_Estado
FROM Empleado E
LEFT JOIN TransaccionNomina T ON E.Empleado_ID = T.Empleado_ID
WHERE E.Compania_Codigo = 'UAS'
    AND E.Empleado_Estado = 'Activo'
    AND T.PeriodoNomina_Codigo = '202603'
ORDER BY E.Empleado_Codigo, T.TransaccionNomina_Fecha DESC;

-- 7. Movimiento en log de empleados
SELECT
    EmpleadoLog_ID,
    CONCAT(NombreCompleto, ' - ', Empleado_Codigo) AS Empleado,
    Accion,
    Empleado_Estado AS EstadoEmpleado,
    FechaEvento,
    UsuarioBD
FROM EmpleadoLog
ORDER BY FechaEvento DESC
LIMIT 20;

-- 8. Movimiento en log de transacciones
SELECT
    TransaccionNominaLog_ID,
    TransaccionNomina_Numero,
    Accion,
    MontoBruto,
    MontoNeto,
    Estado,
    FechaEvento
FROM TransaccionNominaLog
ORDER BY FechaEvento DESC
LIMIT 20;

/* ===============================================================
   CONSULTAS DE VALIDACION DE DATOS
   =============================================================== */

-- 9. Empleados sin transacciones en el periodo actual
SELECT
    E.Empleado_Codigo,
    CONCAT(E.Empleado_Nombre, ' ', E.Empleado_Apellido) AS NombreCompleto,
    E.Empleado_Cargo,
    E.Empleado_SueldoBase
FROM Empleado E
WHERE E.Compania_Codigo = 'UAS'
    AND E.Empleado_Estado = 'Activo'
    AND E.Empleado_ID NOT IN (
        SELECT DISTINCT T.Empleado_ID
        FROM TransaccionNomina T
        WHERE T.PeriodoNomina_Codigo = '202603'
    )
ORDER BY E.Empleado_Codigo;

-- 10. Transacciones con estado pendiente o anulada
SELECT
    T.TransaccionNomina_Numero,
    E.Empleado_Codigo,
    CONCAT(E.Empleado_Nombre, ' ', E.Empleado_Apellido) AS NombreCompleto,
    T.PeriodoNomina_Codigo,
    T.TransaccionNomina_Fecha,
    T.TransaccionNomina_Estado,
    T.TransaccionNomina_Monto
FROM TransaccionNomina T
INNER JOIN Empleado E ON T.Empleado_ID = E.Empleado_ID
WHERE T.TransaccionNomina_Estado IN ('Pendiente', 'Anulada')
ORDER BY T.TransaccionNomina_Fecha DESC;

/* ===============================================================
   CONSULTAS DE ESTADISTICAS Y METRICAS
   =============================================================== */

-- 11. Distribucion salarial en la organizacion
SELECT
    CASE
        WHEN E.Empleado_SueldoBase < 40000 THEN 'Bajo (< 40K)'
        WHEN E.Empleado_SueldoBase < 75000 THEN 'Medio (40-75K)'
        WHEN E.Empleado_SueldoBase < 150000 THEN 'Alto (75-150K)'
        ELSE 'Premium (>150K)'
    END AS RangoSalarial,
    COUNT(E.Empleado_ID) AS CantidadEmpleados,
    ROUND(AVG(E.Empleado_SueldoBase), 2) AS SalarioPromedio,
    MIN(E.Empleado_SueldoBase) AS SalarioMinimo,
    MAX(E.Empleado_SueldoBase) AS SalarioMaximo,
    SUM(E.Empleado_SueldoBase) AS MontoBrutoTotal
FROM Empleado E
WHERE E.Compania_Codigo = 'UAS' AND E.Empleado_Estado = 'Activo'
GROUP BY RangoSalarial
ORDER BY SalarioPromedio;

-- 12. Variacion de transacciones por mes
SELECT
    SUBSTR(P.PeriodoNomina_Codigo, 5, 2) AS Mes,
    SUBSTR(P.PeriodoNomina_Codigo, 1, 4) AS Anio,
    COUNT(T.TransaccionNomina_ID) AS TotalTransacciones,
    SUM(T.TransaccionNomina_Monto) AS MontoBrutoTotal,
    ROUND(AVG(T.TransaccionNomina_Monto), 2) AS PromedioMonto,
    COUNT(DISTINCT T.Empleado_ID) AS EmpleadosProcesados
FROM PeriodoNomina P
LEFT JOIN TransaccionNomina T ON P.Compania_Codigo = T.Compania_Codigo
    AND P.PeriodoNomina_Codigo = T.PeriodoNomina_Codigo
WHERE P.Compania_Codigo = 'UAS'
GROUP BY P.PeriodoNomina_Codigo, P.PeriodoNomina_Anio
ORDER BY P.PeriodoNomina_Codigo;

/* ===============================================================
   CONSULTAS DE DIAGNOSTICO
   =============================================================== */

-- 13. Estado general del sistema
SELECT
    'Total Empleados' AS Concepto, COUNT(*) AS Valor
FROM Empleado
WHERE Compania_Codigo = 'UAS' AND Empleado_Estado = 'Activo'
UNION ALL
SELECT 'Total Periodos', COUNT(*)
FROM PeriodoNomina
WHERE Compania_Codigo = 'UAS'
UNION ALL
SELECT 'Total Transacciones', COUNT(*)
FROM TransaccionNomina
WHERE Compania_Codigo = 'UAS'
UNION ALL
SELECT 'Total Registros Log Empleado', COUNT(*)
FROM EmpleadoLog
UNION ALL
SELECT 'Total Registros Log Transacciones', COUNT(*)
FROM TransaccionNominaLog;

-- 14. Verificacion de consistencia
SELECT
    'Empleados sin cedula' AS Inconsistencia, COUNT(*) AS Cantidad
FROM Empleado
WHERE Empleado_NumeroCedula IS NULL
UNION ALL
SELECT 'Empleados sin salario', COUNT(*)
FROM Empleado
WHERE Empleado_SueldoBase IS NULL AND Empleado_Estado = 'Activo'
UNION ALL
SELECT 'Transacciones sin empleado', COUNT(*)
FROM TransaccionNomina
WHERE Empleado_ID NOT IN (SELECT Empleado_ID FROM Empleado);
