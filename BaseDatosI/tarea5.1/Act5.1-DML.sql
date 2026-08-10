/*
    ===============================================================
    TAREA 5.1 - DML (Data Manipulation Language)
    Datos de prueba para Sistema de Nomina
    ===============================================================
*/

/* ===============================================================
   DATOS MAESTROS - TABLAS DE REFERENCIA
   =============================================================== */

INSERT INTO Compania (Compania_Codigo, Compania_Descripcion, Compania_Estado)
VALUES ('UAS', 'Universidad Autonoma de Santo Domingo', 'Activo');

INSERT INTO TipoPeriodoNomina (TipoPeriodoNomina_Codigo, TipoPeriodoNomina_Descripcion)
VALUES
('MEN', 'Mensual'),
('QUI', 'Quincenal'),
('DIA', 'Diaria');

INSERT INTO Departamento (Compania_Codigo, Departamento_Codigo, Departamento_Descripcion)
VALUES
('UAS', 'ADM', 'Administracion'),
('UAS', 'FIN', 'Finanzas'),
('UAS', 'DOC', 'Docencia'),
('UAS', 'TIC', 'Tecnologia'),
('UAS', 'RHH', 'Recursos Humanos'),
('UAS', 'OPE', 'Operaciones');

INSERT INTO TipoNomina (Compania_Codigo, TipoNomina_Codigo, TipoNomina_Descripcion, TipoPeriodoNomina_Codigo)
VALUES
('UAS', 'FIX', 'Nomina de empleados fijos', 'MEN'),
('UAS', 'DOC', 'Nomina de docentes', 'MEN'),
('UAS', 'EXT', 'Nomina extraordinaria', 'MEN'),
('UAS', 'HON', 'Honorarios especiales', 'MEN'),
('UAS', 'PRC', 'Practicantes', 'QUI');

INSERT INTO PeriodoNomina
(Compania_Codigo, PeriodoNomina_Codigo, PeriodoNomina_Anio, PeriodoNomina_Descripcion, PeriodoNomina_FechaInicial, PeriodoNomina_FechaFinal, PeriodoNomina_Estado)
VALUES
('UAS', '202601', 2026, 'Nomina enero 2026', '2026-01-01', '2026-01-31', 'Pagado'),
('UAS', '202602', 2026, 'Nomina febrero 2026', '2026-02-01', '2026-02-28', 'Pagado'),
('UAS', '202603', 2026, 'Nomina marzo 2026', '2026-03-01', '2026-03-31', 'Abierto'),
('UAS', '202604', 2026, 'Nomina abril 2026', '2026-04-01', '2026-04-30', 'Abierto'),
('UAS', '202605', 2026, 'Nomina mayo 2026', '2026-05-01', '2026-05-31', 'Abierto'),
('UAS', '202606', 2026, 'Nomina junio 2026', '2026-06-01', '2026-06-30', 'Abierto'),
('UAS', '202607', 2026, 'Nomina julio 2026', '2026-07-01', '2026-07-31', 'Abierto'),
('UAS', '202608', 2026, 'Nomina agosto 2026', '2026-08-01', '2026-08-31', 'Abierto'),
('UAS', '202609', 2026, 'Nomina septiembre 2026', '2026-09-01', '2026-09-30', 'Abierto'),
('UAS', '202610', 2026, 'Nomina octubre 2026', '2026-10-01', '2026-10-31', 'Abierto'),
('UAS', '202611', 2026, 'Nomina noviembre 2026', '2026-11-01', '2026-11-30', 'Abierto'),
('UAS', '202612', 2026, 'Nomina diciembre 2026', '2026-12-01', '2026-12-31', 'Abierto');

/* ===============================================================
   EMPLEADOS (20+)
   =============================================================== */

INSERT INTO Empleado
(Compania_Codigo, Empleado_Codigo, Empleado_Nombre, Empleado_Apellido, Empleado_NumeroCedula, Empleado_FechaNacimiento, Empleado_FechaIngreso, Empleado_Sexo, Empleado_EstadoCivil, Empleado_Telefono, Empleado_Direccion, Departamento_Codigo, Empleado_Cargo, Empleado_SueldoBase, Empleado_Estado)
VALUES
('UAS', 'E00001', 'Marlenis Judith', 'Concepcion Cuevas', '001-000001-1', '1990-05-10', '2024-02-01', 'F', 'C', '809-555-1001', 'Santo Domingo', 'ADM', 'Analista de datos', 42000.00, 'Activo'),
('UAS', 'E00002', 'Roberto Byas', 'De la Cruz', '001-000002-2', '1988-08-14', '2023-07-15', 'M', 'C', '809-555-1002', 'Santo Domingo Este', 'FIN', 'Director financiero', 55000.00, 'Activo'),
('UAS', 'E00003', 'Victor', 'Perez Padilla', '001-000003-3', '1985-11-25', '2022-01-10', 'M', 'C', '809-555-1003', 'Santo Domingo Norte', 'DOC', 'Docente investigador', 78000.00, 'Activo'),
('UAS', 'E00004', 'Manicaotex', 'Mueses', '001-000004-4', '1987-02-20', '2021-09-01', 'M', 'S', '809-555-1004', 'Santiago', 'TIC', 'Arquitecto de datos', 120000.00, 'Activo'),
('UAS', 'E00005', 'Rosmery', 'Alberto Martinez', '001-000005-5', '1982-12-05', '2020-03-05', 'F', 'C', '809-555-1005', 'Santo Domingo', 'ADM', 'Coordinadora academica', 250000.00, 'Activo'),
('UAS', 'E00006', 'Ana', 'Martinez', '001-000006-6', '1994-10-30', '2025-04-21', 'F', 'S', '809-555-1006', 'Bani', 'FIN', 'Auxiliar contable', 32000.00, 'Activo'),
('UAS', 'E00007', 'Carlos', 'Rodriguez Sanchez', '001-000007-7', '1992-03-12', '2024-01-15', 'M', 'C', '809-555-1007', 'Santiago', 'TIC', 'Programador senior', 95000.00, 'Activo'),
('UAS', 'E00008', 'Maria', 'Garcia Lopez', '001-000008-8', '1989-07-08', '2023-05-20', 'F', 'U', '809-555-1008', 'San Cristobal', 'DOC', 'Docente catedrática', 85000.00, 'Activo'),
('UAS', 'E00009', 'Juan', 'Hernandez Perez', '001-000009-9', '1986-09-15', '2022-11-10', 'M', 'D', '809-555-1009', 'La Romana', 'FIN', 'Contador', 48000.00, 'Activo'),
('UAS', 'E00010', 'Patricia', 'Gonzalez Torres', '001-000010-0', '1991-04-22', '2024-03-01', 'F', 'C', '809-555-1010', 'Higuey', 'RHH', 'Especialista RRHH', 45000.00, 'Activo'),
('UAS', 'E00011', 'Fernando', 'Vargas Castro', '001-000011-1', '1987-06-30', '2023-08-15', 'M', 'C', '809-555-1011', 'Azua', 'OPE', 'Supervisor de operaciones', 52000.00, 'Activo'),
('UAS', 'E00012', 'Carmen', 'Flores Diaz', '001-000012-2', '1993-01-18', '2024-02-10', 'F', 'S', '809-555-1012', 'La Vega', 'ADM', 'Secretaria ejecutiva', 38000.00, 'Activo'),
('UAS', 'E00013', 'Miguel', 'Cabrera Nunez', '001-000013-3', '1990-11-25', '2023-09-01', 'M', 'C', '809-555-1013', 'Monte Plata', 'TIC', 'Desarrollador web', 72000.00, 'Activo'),
('UAS', 'E00014', 'Isabel', 'Ramirez Santos', '001-000014-4', '1988-05-14', '2022-07-20', 'F', 'V', '809-555-1014', 'Jarabacoa', 'DOC', 'Docente asistente', 65000.00, 'Activo'),
('UAS', 'E00015', 'Antonio', 'Lopez Guerrero', '001-000015-5', '1984-12-08', '2021-10-05', 'M', 'C', '809-555-1015', 'Puerto Plata', 'FIN', 'Analista financiero', 58000.00, 'Activo'),
('UAS', 'E00016', 'Rosa', 'Morales Gutierrez', '001-000016-6', '1995-02-19', '2025-01-15', 'F', 'S', '809-555-1016', 'Santiago', 'RHH', 'Asistente RRHH', 35000.00, 'Activo'),
('UAS', 'E00017', 'Pedro', 'Silva Romero', '001-000017-7', '1989-08-27', '2023-04-10', 'M', 'C', '809-555-1017', 'San Pedro de Macoris', 'OPE', 'Coordinador logistica', 50000.00, 'Activo'),
('UAS', 'E00018', 'Lucia', 'Medina Rivera', '001-000018-8', '1991-10-03', '2024-05-01', 'F', 'C', '809-555-1018', 'Samana', 'ADM', 'Recepcionista', 28000.00, 'Activo'),
('UAS', 'E00019', 'Ricardo', 'Acosta Jimenez', '001-000019-9', '1986-03-20', '2022-06-15', 'M', 'D', '809-555-1019', 'Constanza', 'TIC', 'Especialista soporte IT', 68000.00, 'Activo'),
('UAS', 'E00020', 'Angelica', 'Fuentes Reyes', '001-000020-0', '1993-09-11', '2024-07-20', 'F', 'C', '809-555-1020', 'Monte Cristi', 'DOC', 'Docente contratado', 70000.00, 'Activo'),
('UAS', 'E00021', 'Andres', 'Hernandez Lima', '001-000021-1', '1988-07-14', '2023-02-01', 'M', 'S', '809-555-1021', 'Valverde', 'FIN', 'Auxiliar administrativo', 32000.00, 'Activo'),
('UAS', 'E00022', 'Beatriz', 'Santana Cruz', '001-000022-2', '1992-04-09', '2024-08-15', 'F', 'U', '809-555-1022', 'Barahona', 'RHH', 'Coordinadora de nomina', 55000.00, 'Activo');

/* ===============================================================
   TRANSACCIONES DE NOMINA (20+)
   =============================================================== */

INSERT INTO TransaccionNomina
(Compania_Codigo, TransaccionNomina_Numero, TransaccionNomina_Fecha, Empleado_ID, TipoNomina_Codigo, PeriodoNomina_Codigo, TransaccionNomina_Comentario, TransaccionNomina_Monto)
VALUES
('UAS', 1, '2026-01-31', 1, 'FIX', '202601', 'Nomina enero empleado E00001', 42000.00),
('UAS', 2, '2026-01-31', 2, 'FIX', '202601', 'Nomina enero empleado E00002', 55000.00),
('UAS', 3, '2026-01-31', 3, 'DOC', '202601', 'Nomina enero empleado E00003', 78000.00),
('UAS', 4, '2026-01-31', 4, 'FIX', '202601', 'Nomina enero empleado E00004', 120000.00),
('UAS', 5, '2026-01-31', 5, 'FIX', '202601', 'Nomina enero empleado E00005', 250000.00),
('UAS', 6, '2026-02-28', 1, 'FIX', '202602', 'Nomina febrero empleado E00001', 42000.00),
('UAS', 7, '2026-02-28', 2, 'FIX', '202602', 'Nomina febrero empleado E00002', 55000.00),
('UAS', 8, '2026-02-28', 3, 'DOC', '202602', 'Nomina febrero empleado E00003', 78000.00),
('UAS', 9, '2026-02-28', 4, 'FIX', '202602', 'Nomina febrero empleado E00004', 120000.00),
('UAS', 10, '2026-02-28', 5, 'FIX', '202602', 'Nomina febrero empleado E00005', 250000.00),
('UAS', 11, '2026-03-31', 1, 'FIX', '202603', 'Nomina marzo empleado E00001', 42000.00),
('UAS', 12, '2026-03-31', 2, 'FIX', '202603', 'Nomina marzo empleado E00002', 55000.00),
('UAS', 13, '2026-03-31', 3, 'DOC', '202603', 'Nomina marzo empleado E00003', 78000.00),
('UAS', 14, '2026-03-31', 4, 'FIX', '202603', 'Nomina marzo empleado E00004', 120000.00),
('UAS', 15, '2026-03-31', 5, 'FIX', '202603', 'Nomina marzo empleado E00005', 250000.00),
('UAS', 16, '2026-03-31', 6, 'FIX', '202603', 'Nomina marzo empleado E00006', 32000.00),
('UAS', 17, '2026-03-31', 7, 'FIX', '202603', 'Nomina marzo empleado E00007', 95000.00),
('UAS', 18, '2026-03-31', 8, 'DOC', '202603', 'Nomina marzo empleado E00008', 85000.00),
('UAS', 19, '2026-03-31', 9, 'FIX', '202603', 'Nomina marzo empleado E00009', 48000.00),
('UAS', 20, '2026-03-31', 10, 'FIX', '202603', 'Nomina marzo empleado E00010', 45000.00),
('UAS', 21, '2026-03-31', 11, 'FIX', '202603', 'Nomina marzo empleado E00011', 52000.00),
('UAS', 22, '2026-03-31', 12, 'FIX', '202603', 'Nomina marzo empleado E00012', 38000.00);
