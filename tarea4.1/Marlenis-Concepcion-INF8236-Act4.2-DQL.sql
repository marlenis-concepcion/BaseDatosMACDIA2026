-- ============================================================
-- SCRIPT DQL - Sistema de Seguro de Vehiculos
-- Universidad Autonoma de Santo Domingo (UASD)
-- Asignatura: Base de Datos I (INF-8236-C2)
-- Actividad: 4.2 - Desarrollo completo en SQL
-- Estudiante: Marlenis Judith Concepcion Cuevas
-- Grupo: 7  |  Fecha: Abril 2026
-- Basado en el script maestro ajustado
-- ============================================================
-- EJECUCION
-- 1. Ejecutar primero el script DDL.
-- 2. Ejecutar despues el script DML.
-- 3. Ejecutar finalmente este script DQL.
-- ------------------------------------------------------------
-- QUE HACE ESTE SCRIPT
-- Este archivo corresponde a la Parte 3 del proyecto.
-- Aqui solo se hacen consultas para validar y analizar los datos.
-- No crea tablas, no inserta registros y no modifica informacion.
--
-- CONTENIDO
-- 1. Consultas basicas
-- 2. Uso de WHERE
-- 3. ORDER BY
-- 4. Funciones de agregacion
-- 5. GROUP BY
-- 6. HAVING
-- 7. JOINs
-- 8. Subconsultas
--
-- RESULTADO ESPERADO
-- Este script devuelve listados, resumenes y cruces de datos
-- para servir como evidencia academica de la parte DQL.
-- ============================================================

USE SeguroVehiculos;
GO

-- ============================================================
-- CONSULTAS BASICAS
-- ============================================================

-- Consulta 1: Listar todos los clientes
-- Muestra todos los datos de la tabla Cliente.
SELECT  C.Cliente_ID,
        C.Cliente_Cedula,
        C.Cliente_Nombre,
        C.Cliente_Apellido,
        C.Cliente_FechaNacimiento,
        C.Cliente_Telefono,
        C.Cliente_Email,
        C.Cliente_Direccion,
        C.Cliente_Ciudad,
        C.Cliente_FechaRegistro,
        C.Cliente_Estatus
FROM    Cliente AS C
ORDER BY C.Cliente_Apellido, C.Cliente_Nombre;
GO

-- Consulta 2: Mostrar todos los vehiculos asegurados
-- Consulta la tabla Vehiculo con todos sus atributos.
SELECT  V.Vehiculo_ID,
        V.Vehiculo_ClienteID,
        V.Vehiculo_TipoVehiculoID,
        V.Vehiculo_Placa,
        V.Vehiculo_Marca,
        V.Vehiculo_Modelo,
        V.Vehiculo_Anio,
        V.Vehiculo_Color,
        V.Vehiculo_ValorAsegurado,
        V.Vehiculo_VIN,
        V.Vehiculo_Estatus
FROM    Vehiculo AS V
ORDER BY V.Vehiculo_Marca, V.Vehiculo_Modelo;
GO

-- ============================================================
-- USO DE WHERE
-- ============================================================

-- Consulta 3: Clientes con polizas activas
-- Filtra los clientes que tienen al menos una poliza con estatus Activa.
SELECT  DISTINCT
        C.Cliente_ID,
        C.Cliente_Cedula,
        C.Cliente_Nombre,
        C.Cliente_Apellido,
        C.Cliente_Ciudad,
        C.Cliente_Estatus
FROM    Cliente AS C
INNER JOIN Poliza AS P ON P.Poliza_ClienteID = C.Cliente_ID
WHERE   P.Poliza_Estatus = 'Activa'
ORDER BY C.Cliente_Apellido, C.Cliente_Nombre;
GO

-- Consulta 4: Vehiculos asegurados despues de un anio especifico
-- Cambia el valor de @AnioReferencia si deseas probar otro anio.
DECLARE @AnioReferencia SMALLINT = 2020;

SELECT  V.Vehiculo_ID,
        V.Vehiculo_Placa,
        V.Vehiculo_Marca,
        V.Vehiculo_Modelo,
        V.Vehiculo_Anio,
        V.Vehiculo_Color,
        V.Vehiculo_ValorAsegurado,
        P.Poliza_Numero
FROM    Vehiculo AS V
INNER JOIN Poliza AS P ON P.Poliza_VehiculoID = V.Vehiculo_ID
WHERE   V.Vehiculo_Anio > @AnioReferencia
ORDER BY V.Vehiculo_Anio DESC, V.Vehiculo_Marca;
GO

-- ============================================================
-- ORDER BY
-- ============================================================

-- Consulta 5: Listar pagos ordenados por monto descendente
-- Ordena los pagos del monto mayor al menor.
SELECT  P.Pago_ID,
        P.Pago_Fecha,
        C.Cliente_Nombre + ' ' + C.Cliente_Apellido AS Cliente,
        P.Pago_Monto,
        P.Pago_Metodo,
        P.Pago_Referencia,
        P.Pago_Estatus
FROM    Pago AS P
INNER JOIN Cliente AS C ON C.Cliente_ID = P.Pago_ClienteID
ORDER BY P.Pago_Monto DESC;
GO

-- Consulta 6: Listar clientes ordenados alfabeticamente
-- Ordena por apellido y luego por nombre.
SELECT  C.Cliente_ID,
        C.Cliente_Cedula,
        C.Cliente_Apellido,
        C.Cliente_Nombre,
        C.Cliente_Ciudad,
        C.Cliente_Telefono
FROM    Cliente AS C
ORDER BY C.Cliente_Apellido ASC, C.Cliente_Nombre ASC;
GO

-- ============================================================
-- FUNCIONES DE AGREGACION
-- ============================================================

-- Consulta 7: Total de pagos realizados
-- Suma todos los pagos registrados.
SELECT  SUM(P.Pago_Monto) AS Total_Pagos_Realizados_RD
FROM    Pago AS P;
GO

-- Consulta 8: Cantidad total de polizas
-- Cuenta el numero total de polizas.
SELECT  COUNT(*) AS Cantidad_Total_Polizas
FROM    Poliza;
GO

-- Consulta 9: Promedio de pagos
-- Calcula el promedio general de los pagos.
SELECT  AVG(P.Pago_Monto) AS Promedio_Pagos_RD
FROM    Pago AS P;
GO

-- Consulta 10: Pago minimo y maximo
-- Obtiene el pago mas bajo y el mas alto.
SELECT  MIN(P.Pago_Monto) AS Pago_Minimo_RD,
        MAX(P.Pago_Monto) AS Pago_Maximo_RD
FROM    Pago AS P;
GO

-- ============================================================
-- GROUP BY
-- ============================================================

-- Consulta 11: Cantidad de polizas por cliente
-- Agrupa por cliente y cuenta cuantas polizas tiene cada uno.
SELECT  C.Cliente_ID,
        C.Cliente_Nombre + ' ' + C.Cliente_Apellido AS Cliente,
        COUNT(P.Poliza_ID) AS Cantidad_Polizas
FROM    Cliente AS C
INNER JOIN Poliza AS P ON P.Poliza_ClienteID = C.Cliente_ID
GROUP BY C.Cliente_ID, C.Cliente_Nombre, C.Cliente_Apellido
ORDER BY Cantidad_Polizas DESC, Cliente;
GO

-- Consulta 12: Total pagado por cliente
-- Suma los pagos agrupados por cliente.
SELECT  C.Cliente_ID,
        C.Cliente_Nombre + ' ' + C.Cliente_Apellido AS Cliente,
        SUM(P.Pago_Monto) AS Total_Pagado_RD
FROM    Cliente AS C
INNER JOIN Pago AS P ON P.Pago_ClienteID = C.Cliente_ID
GROUP BY C.Cliente_ID, C.Cliente_Nombre, C.Cliente_Apellido
ORDER BY Total_Pagado_RD DESC, Cliente;
GO

-- ============================================================
-- HAVING
-- ============================================================

-- Consulta 13: Clientes con mas de 2 polizas
-- Filtra los clientes cuyo conteo de polizas sea mayor que 2.
-- Con los datos actuales puede devolver cero filas.
SELECT  C.Cliente_ID,
        C.Cliente_Nombre + ' ' + C.Cliente_Apellido AS Cliente,
        COUNT(P.Poliza_ID) AS Cantidad_Polizas
FROM    Cliente AS C
INNER JOIN Poliza AS P ON P.Poliza_ClienteID = C.Cliente_ID
GROUP BY C.Cliente_ID, C.Cliente_Nombre, C.Cliente_Apellido
HAVING  COUNT(P.Poliza_ID) > 2
ORDER BY Cantidad_Polizas DESC, Cliente;
GO

-- Consulta 14: Clientes cuyo total de pagos sea mayor a un monto
-- Cambia el valor de @MontoMinimo si deseas probar otro umbral.
DECLARE @MontoMinimo DECIMAL(12,2) = 18000.00;

SELECT  C.Cliente_ID,
        C.Cliente_Nombre + ' ' + C.Cliente_Apellido AS Cliente,
        SUM(P.Pago_Monto) AS Total_Pagado_RD
FROM    Cliente AS C
INNER JOIN Pago AS P ON P.Pago_ClienteID = C.Cliente_ID
GROUP BY C.Cliente_ID, C.Cliente_Nombre, C.Cliente_Apellido
HAVING  SUM(P.Pago_Monto) > @MontoMinimo
ORDER BY Total_Pagado_RD DESC, Cliente;
GO

-- ============================================================
-- JOINs
-- ============================================================

-- Consulta 15: INNER JOIN entre clientes y polizas
-- Muestra los clientes con sus polizas relacionadas.
SELECT  C.Cliente_Cedula,
        C.Cliente_Nombre + ' ' + C.Cliente_Apellido AS Cliente,
        P.Poliza_Numero,
        P.Poliza_FechaEmision,
        P.Poliza_FechaVencimiento,
        P.Poliza_Estatus,
        P.Poliza_PrimaAnual
FROM    Cliente AS C
INNER JOIN Poliza AS P ON P.Poliza_ClienteID = C.Cliente_ID
ORDER BY C.Cliente_Apellido, P.Poliza_Numero;
GO

-- Consulta 16: LEFT JOIN para mostrar clientes sin polizas
-- Incluye todos los clientes, aunque no tengan polizas.
-- Con los datos actuales todos los clientes tienen poliza.
SELECT  C.Cliente_ID,
        C.Cliente_Nombre + ' ' + C.Cliente_Apellido AS Cliente,
        C.Cliente_Ciudad,
        P.Poliza_Numero,
        P.Poliza_Estatus
FROM    Cliente AS C
LEFT JOIN Poliza AS P ON P.Poliza_ClienteID = C.Cliente_ID
ORDER BY C.Cliente_Apellido, C.Cliente_Nombre;
GO

-- Consulta 17: RIGHT JOIN para mostrar todas las polizas
-- Incluye todas las polizas aunque no tengan cliente asociado.
-- En este modelo normalmente todas las polizas deben tener cliente.
SELECT  P.Poliza_Numero,
        P.Poliza_Estatus,
        P.Poliza_PrimaAnual,
        C.Cliente_Nombre + ' ' + C.Cliente_Apellido AS Cliente,
        C.Cliente_Cedula
FROM    Cliente AS C
RIGHT JOIN Poliza AS P ON P.Poliza_ClienteID = C.Cliente_ID
ORDER BY P.Poliza_Numero;
GO

-- Consulta 18: FULL JOIN para combinar toda la informacion
-- Une clientes y polizas mostrando todos los registros posibles.
SELECT  C.Cliente_ID,
        C.Cliente_Nombre + ' ' + C.Cliente_Apellido AS Cliente,
        C.Cliente_Cedula,
        P.Poliza_Numero,
        P.Poliza_Estatus,
        P.Poliza_PrimaAnual
FROM    Cliente AS C
FULL JOIN Poliza AS P ON P.Poliza_ClienteID = C.Cliente_ID
ORDER BY C.Cliente_ID, P.Poliza_Numero;
GO

-- ============================================================
-- SUBCONSULTAS
-- ============================================================

-- Consulta 19: Clientes con pagos mayores al promedio
-- Compara cada pago contra el promedio general.
SELECT  DISTINCT
        C.Cliente_ID,
        C.Cliente_Nombre,
        C.Cliente_Apellido,
        C.Cliente_Ciudad,
        P.Pago_Monto
FROM    Cliente AS C
INNER JOIN Pago AS P ON P.Pago_ClienteID = C.Cliente_ID
WHERE   P.Pago_Monto > (
            SELECT AVG(Pago_Monto)
            FROM Pago
        )
ORDER BY P.Pago_Monto DESC, C.Cliente_Apellido;
GO

-- Consulta 20: Vehiculos con mayor numero de siniestros
-- Identifica los vehiculos con mas incidencias usando una subconsulta.
SELECT  V.Vehiculo_ID,
        V.Vehiculo_Placa,
        V.Vehiculo_Marca,
        V.Vehiculo_Modelo,
        COUNT(S.Siniestro_ID) AS Total_Siniestros
FROM    Vehiculo AS V
LEFT JOIN Siniestro AS S ON S.Siniestro_VehiculoID = V.Vehiculo_ID
GROUP BY V.Vehiculo_ID, V.Vehiculo_Placa, V.Vehiculo_Marca, V.Vehiculo_Modelo
HAVING  COUNT(S.Siniestro_ID) = (
            SELECT MAX(Conteo.Total_Siniestros)
            FROM (
                SELECT COUNT(S2.Siniestro_ID) AS Total_Siniestros
                FROM Vehiculo AS V2
                LEFT JOIN Siniestro AS S2 ON S2.Siniestro_VehiculoID = V2.Vehiculo_ID
                GROUP BY V2.Vehiculo_ID
            ) AS Conteo
        )
ORDER BY Total_Siniestros DESC, V.Vehiculo_Placa;
GO
