-- ============================================================
-- SCRIPT DML - Sistema de Seguro de Vehiculos
-- Universidad Autonoma de Santo Domingo (UASD)
-- Asignatura: Base de Datos I (INF-8236-C2)
-- Actividad: 4.2 - Desarrollo completo en SQL
-- Estudiante: Marlenis Judith Concepcion Cuevas
-- Grupo: 7  |  Fecha: Abril 2026
-- Basado en el script maestro ajustado
-- ============================================================
-- Ejecutar PRIMERO el script DDL antes que este script.
-- Cada tabla recibe 20 registros.
-- ------------------------------------------------------------
-- QUE HACE ESTE SCRIPT
-- Este archivo carga los datos del sistema ya creado por el DDL.
-- Inserta 20 registros en cada tabla y sigue el orden correcto
-- de dependencias entre catalogos, tablas maestras y tablas
-- transaccionales.
-- Este script no crea estructura; solo inserta datos.
-- Este archivo corresponde a la Parte 2 del proyecto.
--
-- CUANDO SE EJECUTA
-- Este es el segundo script, despues del DDL.
--
-- QUE INSERTA
-- 1. Catalogos base como tipos de vehiculo y coberturas.
-- 2. Clientes, agentes, talleres y vehiculos.
-- 3. Solicitudes, polizas, facturas y pagos.
-- 4. Siniestros y evaluaciones de siniestros.
--
-- QUE NO HACE
-- No crea tablas.
-- No realiza consultas de analisis.
--
-- RESULTADO ESPERADO
-- Todas las tablas quedan pobladas con 20 registros.
-- ============================================================

USE SeguroVehiculos;
GO

-- 20 tipos de vehiculo del catalogo general.
INSERT INTO TipoVehiculo (
    TipoVehiculo_Descripcion,
    TipoVehiculo_TarifaBase
) VALUES
    ('Automovil Sedan', 5000.00),
    ('SUV Compacta', 7000.00),
    ('Camioneta Pickup', 6500.00),
    ('Motocicleta', 2500.00),
    ('Camion Ligero', 9000.00),
    ('Minivan Familiar', 8000.00),
    ('Automovil Deportivo', 12000.00),
    ('Jeep 4x4', 8500.00),
    ('Camion Pesado', 15000.00),
    ('Vehiculo Electrico', 10000.00),
    ('Hatchback', 4800.00),
    ('Coupe', 7600.00),
    ('Taxi Ejecutivo', 6200.00),
    ('Microbus', 11000.00),
    ('Furgon Comercial', 9800.00),
    ('Crossover', 7300.00),
    ('Vehiculo Hibrido', 9200.00),
    ('Van Escolar', 10500.00),
    ('Camion de Reparto', 11500.00),
    ('Todo Terreno Premium', 13500.00);
GO

-- 20 clientes registrados en el sistema.
INSERT INTO Cliente (
    Cliente_Cedula,
    Cliente_Nombre,
    Cliente_Apellido,
    Cliente_FechaNacimiento,
    Cliente_Telefono,
    Cliente_Email,
    Cliente_Direccion,
    Cliente_Ciudad
) VALUES
    ('001-1000001-1','Jose Manuel','Martinez Perez','1985-03-15','809-555-1001','cliente01@seguroveh.do','Calle Las Flores 12','Santo Domingo'),
    ('001-1000002-2','Maria Teresa','Garcia Lopez','1990-07-22','809-555-1002','cliente02@seguroveh.do','Av. 27 de Febrero 45','Santiago'),
    ('001-1000003-3','Carlos Alberto','Rodriguez Santos','1978-11-05','809-555-1003','cliente03@seguroveh.do','Calle Duarte 78','La Romana'),
    ('001-1000004-4','Ana Mercedes','Perez Mejia','1995-02-18','809-555-1004','cliente04@seguroveh.do','Arroyo Hondo Calle B 3','Santo Domingo'),
    ('001-1000005-5','Luis Fernando','Medina Castro','1988-09-30','809-555-1005','cliente05@seguroveh.do','Independencia 200','San Pedro de Macoris'),
    ('001-1000006-6','Carmen Rosa','Feliz Diaz','1992-04-12','809-555-1006','cliente06@seguroveh.do','Urb. La Esperanza Bloque 5','Santiago'),
    ('001-1000007-7','Pedro Antonio','Nunez Reyes','1975-08-08','809-555-1007','cliente07@seguroveh.do','Calle El Conde 99','Santo Domingo'),
    ('001-1000008-8','Altagracia','Jimenez Soto','1983-12-25','809-555-1008','cliente08@seguroveh.do','Av. Luperon 56','La Vega'),
    ('001-1000009-9','Roberto Emilio','Vargas Taveras','2000-01-14','809-555-1009','cliente09@seguroveh.do','Res. Palmas del Este 4B','Santo Domingo'),
    ('001-1000010-0','Luz Maria','Capellan Rosario','1997-06-20','809-555-1010','cliente10@seguroveh.do','Av. Enriquillo 11','Barahona'),
    ('001-1000011-1','Miguel Angel','Santos Diaz','1986-05-11','809-555-1011','cliente11@seguroveh.do','Urb. Real 9','Santiago'),
    ('001-1000012-2','Daniela Sofia','Morillo Reyes','1991-08-19','809-555-1012','cliente12@seguroveh.do','Calle Central 18','Moca'),
    ('001-1000013-3','Francisco Javier','Peralta Cruz','1982-10-02','809-555-1013','cliente13@seguroveh.do','Av. Restauracion 33','Puerto Plata'),
    ('001-1000014-4','Yolanda Esther','De La Rosa Pena','1987-04-17','809-555-1014','cliente14@seguroveh.do','Calle Primera 7','San Cristobal'),
    ('001-1000015-5','Ramon Ernesto','Lora Batista','1979-01-09','809-555-1015','cliente15@seguroveh.do','Sector Villa Verde 21','La Romana'),
    ('001-1000016-6','Patricia Elena','Mejia Gomez','1993-09-23','809-555-1016','cliente16@seguroveh.do','Los Alamos 15','Bonao'),
    ('001-1000017-7','Juan Carlos','Peguero Santana','1984-02-28','809-555-1017','cliente17@seguroveh.do','Av. Libertad 90','Santo Domingo'),
    ('001-1000018-8','Claudia Beatriz','Taveras Fernandez','1996-11-14','809-555-1018','cliente18@seguroveh.do','Jardines Metropolitanos 2','Santiago'),
    ('001-1000019-9','Eduardo Luis','Acosta Rosario','1981-07-03','809-555-1019','cliente19@seguroveh.do','Residencial Coral 8','Higuey'),
    ('001-1000020-0','Isabel Cristina','Cabrera Polanco','1994-12-01','809-555-1020','cliente20@seguroveh.do','Calle Principal 101','San Francisco de Macoris');
GO

-- 20 agentes de seguros.
INSERT INTO Agente (
    Agente_Cedula,
    Agente_Nombre,
    Agente_Apellido,
    Agente_Telefono,
    Agente_Email,
    Agente_FechaIngreso,
    Agente_ComisionPorcentaje
) VALUES
    ('002-2000001-1','Roberto','Perez Fernandez','809-555-2001','agente01@seguroveh.do','2018-01-10',6.00),
    ('002-2000002-2','Sandra','Gomez Cruz','809-555-2002','agente02@seguroveh.do','2019-03-15',5.50),
    ('002-2000003-3','Miguel','Torres Medina','809-555-2003','agente03@seguroveh.do','2017-06-20',7.00),
    ('002-2000004-4','Patricia','Reyes Santos','809-555-2004','agente04@seguroveh.do','2020-02-01',5.00),
    ('002-2000005-5','Juan Carlos','Alvarez Garcia','809-555-2005','agente05@seguroveh.do','2016-11-12',8.00),
    ('002-2000006-6','Daniela','Lora Batista','809-555-2006','agente06@seguroveh.do','2021-07-05',5.00),
    ('002-2000007-7','Eduardo','Herrera Diaz','809-555-2007','agente07@seguroveh.do','2015-04-18',9.00),
    ('002-2000008-8','Claudia','Mateo Jimenez','809-555-2008','agente08@seguroveh.do','2022-09-01',5.00),
    ('002-2000009-9','Francisco','Polanco Nunez','809-555-2009','agente09@seguroveh.do','2019-12-10',6.50),
    ('002-2000010-0','Isabel','Mejia Rosario','809-555-2010','agente10@seguroveh.do','2023-01-20',5.00),
    ('002-2000011-1','Victor','Morales Castillo','809-555-2011','agente11@seguroveh.do','2018-08-08',6.00),
    ('002-2000012-2','Teresa','Vidal Sanchez','809-555-2012','agente12@seguroveh.do','2020-06-14',5.75),
    ('002-2000013-3','Oscar','Rosario Ramirez','809-555-2013','agente13@seguroveh.do','2017-10-02',7.25),
    ('002-2000014-4','Maribel','Cuevas Tejada','809-555-2014','agente14@seguroveh.do','2021-04-11',5.00),
    ('002-2000015-5','Kelvin','Dominguez Marte','809-555-2015','agente15@seguroveh.do','2016-09-19',8.50),
    ('002-2000016-6','Raquel','Suarez Perdomo','809-555-2016','agente16@seguroveh.do','2022-01-07',5.00),
    ('002-2000017-7','Jorge','Contreras Gil','809-555-2017','agente17@seguroveh.do','2019-05-23',6.25),
    ('002-2000018-8','Noelia','Matos Grullon','809-555-2018','agente18@seguroveh.do','2023-03-28',5.00),
    ('002-2000019-9','Ricardo','Sosa Martinez','809-555-2019','agente19@seguroveh.do','2018-12-17',6.80),
    ('002-2000020-0','Melissa','Acosta Feliz','809-555-2020','agente20@seguroveh.do','2024-02-05',5.00);
GO

-- 20 coberturas disponibles para emitir polizas.
INSERT INTO Cobertura (
    Cobertura_Nombre,
    Cobertura_Descripcion,
    Cobertura_PrimaBase,
    Cobertura_Deducible
) VALUES
    ('Cobertura Basica SOAT','Seguro obligatorio de accidentes de transito.',3000.00,0.00),
    ('Cobertura Terceros Limitada','Protege frente a danos materiales a terceros.',8000.00,2000.00),
    ('Cobertura Danos Propios','Repara danos fisicos al vehiculo asegurado.',15000.00,5000.00),
    ('Cobertura Robo Total','Indemniza en caso de robo total del vehiculo.',20000.00,0.00),
    ('Cobertura Todo Riesgo','Cobertura integral para danos, robo y terceros.',35000.00,3000.00),
    ('Cobertura Asistencia Vial 24h','Grua, combustible y auxilio vial.',5000.00,0.00),
    ('Cobertura Fenomenos Naturales','Cubre inundaciones y huracanes.',12000.00,4000.00),
    ('Cobertura Responsabilidad Civil Amplia','Amplia proteccion ante reclamaciones de terceros.',18000.00,2500.00),
    ('Cobertura Cristales y Espejos','Reparacion o reposicion de cristales.',4000.00,500.00),
    ('Cobertura Accidentes a Pasajeros','Proteccion para pasajeros del vehiculo.',6000.00,0.00),
    ('Cobertura Perdida Parcial','Cubre danos parciales por colision.',14000.00,3500.00),
    ('Cobertura Equipo Especial','Protege accesorios y equipos adicionales.',7000.00,1000.00),
    ('Cobertura Taxi Premium','Plan para vehiculos de servicio publico.',16000.00,2500.00),
    ('Cobertura Flotilla Comercial','Proteccion para unidades comerciales.',22000.00,4500.00),
    ('Cobertura Viajes Nacionales','Asistencia y cobertura en rutas nacionales.',6500.00,1000.00),
    ('Cobertura Cero Deducible','Plan premium sin deducible.',28000.00,0.00),
    ('Cobertura Hibridos y Electricos','Plan especializado para movilidad sostenible.',19000.00,2000.00),
    ('Cobertura Escolar','Cobertura para transporte escolar.',17500.00,3000.00),
    ('Cobertura Mercancia','Proteccion de vehiculos de reparto y carga.',21000.00,5000.00),
    ('Cobertura Todoterreno Plus','Plan especial para vehiculos todo terreno.',26000.00,3500.00);
GO

-- 20 talleres autorizados por la aseguradora.
INSERT INTO Taller (
    Taller_Nombre,
    Taller_Direccion,
    Taller_Telefono,
    Taller_Email,
    Taller_Responsable
) VALUES
    ('Taller Automotriz El Caribe','Av. John F. Kennedy Km 9, Santo Domingo','809-555-3001','taller01@seguroveh.do','Ing. Ramon Perez'),
    ('Servicio Tecnico Rodriguez','Calle Max Henriquez Urena 22, Santiago','809-555-3002','taller02@seguroveh.do','Ing. Carlos Rodriguez'),
    ('Centro Automotriz Los Prados','Los Prados Calle 8, Santo Domingo','809-555-3003','taller03@seguroveh.do','Ing. Ana Vargas'),
    ('Taller Especializado Honda','Av. Tiradentes 101, Naco','809-555-3004','taller04@seguroveh.do','Ing. Luis Jimenez'),
    ('Reparaciones Diaz y Asociados','Calle Pedro Clisante 45, La Romana','809-555-3005','taller05@seguroveh.do','Ing. Miguel Diaz'),
    ('Centro de Colisiones Santiago','Av. 27 de Febrero 200, Santiago','809-555-3006','taller06@seguroveh.do','Ing. Patricia Lora'),
    ('Taller Toyota de las Americas','Av. Las Americas Km 14, Santo Domingo','809-555-3007','taller07@seguroveh.do','Ing. Eduardo Santos'),
    ('Servicio Automotriz Nacional','Av. Luperon 300, Santo Domingo Oeste','809-555-3008','taller08@seguroveh.do','Ing. Roberto Nunez'),
    ('Expertos en Carroceria','Calle Del Sol 50, San Pedro de Macoris','809-555-3009','taller09@seguroveh.do','Ing. Carmen Matos'),
    ('Centro Tecnico Premium','Av. Winston Churchill 55, Piantini','809-555-3010','taller10@seguroveh.do','Ing. Sandra Cruz'),
    ('Taller Integral Norte','Av. Circunvalacion Norte 14, Santiago','809-555-3011','taller11@seguroveh.do','Ing. Victor De Leon'),
    ('Mecanica Avanzada Oriental','Autopista San Isidro Km 5','809-555-3012','taller12@seguroveh.do','Ing. Luisina Paredes'),
    ('Taller El Motor Seguro','Calle Restauracion 28, Puerto Plata','809-555-3013','taller13@seguroveh.do','Ing. Kelvin Ramos'),
    ('Centro de Reparacion Higuey','Av. Altagracia 19, Higuey','809-555-3014','taller14@seguroveh.do','Ing. Maria Almonte'),
    ('Taller Express La Vega','Calle Duarte 15, La Vega','809-555-3015','taller15@seguroveh.do','Ing. Julio Garcia'),
    ('Colisiones del Cibao','Av. Imbert 40, Moca','809-555-3016','taller16@seguroveh.do','Ing. Noelia Santos'),
    ('Taller Sureste Especializado','Calle Club Rotario 11, San Cristobal','809-555-3017','taller17@seguroveh.do','Ing. Francisco Peguero'),
    ('Centro de Diagnostico Bonao','Av. Libertad 88, Bonao','809-555-3018','taller18@seguroveh.do','Ing. Raul Tejada'),
    ('Auto Repair Premium Este','Boulevard Turistico 33, Punta Cana','809-555-3019','taller19@seguroveh.do','Ing. Melissa Perez'),
    ('Garage Todo Terreno Plus','Autopista Duarte Km 12, Santo Domingo','809-555-3020','taller20@seguroveh.do','Ing. Jorge Castillo');
GO

-- 20 vehiculos vinculados a clientes y tipos de vehiculo.
INSERT INTO Vehiculo (
    Vehiculo_ClienteID,
    Vehiculo_TipoVehiculoID,
    Vehiculo_Placa,
    Vehiculo_Marca,
    Vehiculo_Modelo,
    Vehiculo_Anio,
    Vehiculo_Color,
    Vehiculo_ValorAsegurado,
    Vehiculo_VIN
) VALUES
    (1,1,'A100001','Toyota','Corolla',2020,'Plateado',1200000.00,'VIN000000000000000000000000001'),
    (2,2,'A100002','Honda','CR-V',2022,'Blanco',1850000.00,'VIN000000000000000000000000002'),
    (3,3,'A100003','Toyota','Hilux',2021,'Negro',2100000.00,'VIN000000000000000000000000003'),
    (4,4,'A100004','Yamaha','MT-15',2023,'Azul',320000.00,'VIN000000000000000000000000004'),
    (5,5,'A100005','JAC','X200',2020,'Blanco',1450000.00,'VIN000000000000000000000000005'),
    (6,6,'A100006','Kia','Carnival',2021,'Gris',1950000.00,'VIN000000000000000000000000006'),
    (7,7,'A100007','Ford','Mustang',2022,'Rojo',2800000.00,'VIN000000000000000000000000007'),
    (8,8,'A100008','Jeep','Wrangler',2021,'Verde',2600000.00,'VIN000000000000000000000000008'),
    (9,9,'A100009','Isuzu','FTR',2019,'Blanco',3500000.00,'VIN000000000000000000000000009'),
    (10,10,'A100010','Tesla','Model 3',2023,'Blanco',3100000.00,'VIN000000000000000000000000010'),
    (11,11,'A100011','Hyundai','i20',2020,'Gris',950000.00,'VIN000000000000000000000000011'),
    (12,12,'A100012','Honda','Civic Coupe',2019,'Negro',1250000.00,'VIN000000000000000000000000012'),
    (13,13,'A100013','Hyundai','Sonata Taxi',2018,'Amarillo',890000.00,'VIN000000000000000000000000013'),
    (14,14,'A100014','Mercedes-Benz','Sprinter',2021,'Blanco',2900000.00,'VIN000000000000000000000000014'),
    (15,15,'A100015','Renault','Master',2022,'Azul',2400000.00,'VIN000000000000000000000000015'),
    (16,16,'A100016','Nissan','Qashqai',2022,'Gris',1700000.00,'VIN000000000000000000000000016'),
    (17,17,'A100017','Toyota','Prius',2023,'Blanco',2100000.00,'VIN000000000000000000000000017'),
    (18,18,'A100018','Toyota','Hiace',2020,'Blanco',2300000.00,'VIN000000000000000000000000018'),
    (19,19,'A100019','Mitsubishi','Canter',2021,'Rojo',2750000.00,'VIN000000000000000000000000019'),
    (20,20,'A100020','Land Rover','Defender',2024,'Negro',4200000.00,'VIN000000000000000000000000020');
GO

-- 20 solicitudes de cotizacion.
INSERT INTO SolicitudCotizacionPoliza (
    SolicitudCotizacionPoliza_ClienteID,
    SolicitudCotizacionPoliza_VehiculoID,
    SolicitudCotizacionPoliza_AgenteID,
    SolicitudCotizacionPoliza_CoberturaID,
    SolicitudCotizacionPoliza_FechaSolicitud,
    SolicitudCotizacionPoliza_Estatus,
    SolicitudCotizacionPoliza_Observaciones,
    SolicitudCotizacionPoliza_MontoCotizado
) VALUES
    (1,1,1,5,'2025-01-05','Aprobada','Solicitud aprobada para sedan de uso familiar.',35000.00),
    (2,2,2,3,'2025-01-08','Aprobada','Solicitud aprobada para SUV de uso personal.',15000.00),
    (3,3,3,2,'2025-01-10','Aprobada','Solicitud aprobada para pickup de trabajo.',8000.00),
    (4,4,4,1,'2025-01-12','Aprobada','Solicitud aprobada para motocicleta urbana.',3000.00),
    (5,5,5,14,'2025-01-15','Aprobada','Solicitud aprobada para camion ligero comercial.',22000.00),
    (6,6,6,10,'2025-01-18','Aprobada','Solicitud aprobada para minivan familiar.',6000.00),
    (7,7,7,16,'2025-01-20','Aprobada','Solicitud aprobada para vehiculo deportivo.',28000.00),
    (8,8,8,20,'2025-01-22','Aprobada','Solicitud aprobada para jeep todoterreno.',26000.00),
    (9,9,9,19,'2025-01-25','Aprobada','Solicitud aprobada para camion de carga pesada.',21000.00),
    (10,10,10,17,'2025-01-28','Aprobada','Solicitud aprobada para vehiculo electrico.',19000.00),
    (11,11,11,11,'2025-02-02','Aprobada','Solicitud aprobada para hatchback compacto.',14000.00),
    (12,12,12,8,'2025-02-05','Aprobada','Solicitud aprobada para coupe con RC amplia.',18000.00),
    (13,13,13,13,'2025-02-08','Aprobada','Solicitud aprobada para taxi ejecutivo.',16000.00),
    (14,14,14,18,'2025-02-12','Aprobada','Solicitud aprobada para microbus escolar.',17500.00),
    (15,15,15,15,'2025-02-15','Aprobada','Solicitud aprobada para furgon de reparto.',6500.00),
    (16,16,16,7,'2025-02-18','Aprobada','Solicitud aprobada para crossover con proteccion natural.',12000.00),
    (17,17,17,17,'2025-02-20','Aprobada','Solicitud aprobada para vehiculo hibrido.',19000.00),
    (18,18,18,18,'2025-02-22','Aprobada','Solicitud aprobada para van escolar.',17500.00),
    (19,19,19,19,'2025-02-25','Aprobada','Solicitud aprobada para camion de reparto.',21000.00),
    (20,20,20,20,'2025-02-28','Aprobada','Solicitud aprobada para todo terreno premium.',26000.00);
GO

-- 20 polizas emitidas a partir de las solicitudes.
INSERT INTO Poliza (
    Poliza_SolicitudCotizacionPolizaID,
    Poliza_ClienteID,
    Poliza_VehiculoID,
    Poliza_AgenteID,
    Poliza_CoberturaID,
    Poliza_Numero,
    Poliza_FechaEmision,
    Poliza_FechaVencimiento,
    Poliza_Estatus,
    Poliza_PrimaAnual,
    Poliza_Deducible,
    Poliza_Observaciones
) VALUES
    (1,1,1,1,5,'POL-2025-0001','2025-01-10','2026-01-10','Activa',35000.00,3000.00,'Poliza emitida sin novedades.'),
    (2,2,2,2,3,'POL-2025-0002','2025-01-13','2026-01-13','Activa',15000.00,5000.00,'Poliza emitida para uso particular.'),
    (3,3,3,3,2,'POL-2025-0003','2025-01-15','2026-01-15','Activa',8000.00,2000.00,'Poliza emitida para vehiculo de trabajo.'),
    (4,4,4,4,1,'POL-2025-0004','2025-01-17','2026-01-17','Activa',3000.00,0.00,'Poliza basica de motocicleta.'),
    (5,5,5,5,14,'POL-2025-0005','2025-01-20','2026-01-20','Activa',22000.00,4500.00,'Poliza comercial para camion ligero.'),
    (6,6,6,6,10,'POL-2025-0006','2025-01-23','2026-01-23','Activa',6000.00,0.00,'Poliza de pasajeros para minivan.'),
    (7,7,7,7,16,'POL-2025-0007','2025-01-25','2026-01-25','Activa',28000.00,0.00,'Poliza premium sin deducible.'),
    (8,8,8,8,20,'POL-2025-0008','2025-01-27','2026-01-27','Activa',26000.00,3500.00,'Poliza todoterreno con cobertura extendida.'),
    (9,9,9,9,19,'POL-2025-0009','2025-01-30','2026-01-30','Activa',21000.00,5000.00,'Poliza para unidad de carga.'),
    (10,10,10,10,17,'POL-2025-0010','2025-02-02','2026-02-02','Activa',19000.00,2000.00,'Poliza para vehiculo electrico.'),
    (11,11,11,11,11,'POL-2025-0011','2025-02-05','2026-02-05','Activa',14000.00,3500.00,'Poliza para hatchback urbano.'),
    (12,12,12,12,8,'POL-2025-0012','2025-02-08','2026-02-08','Activa',18000.00,2500.00,'Poliza con responsabilidad civil amplia.'),
    (13,13,13,13,13,'POL-2025-0013','2025-02-10','2026-02-10','Activa',16000.00,2500.00,'Poliza especializada para taxi.'),
    (14,14,14,14,18,'POL-2025-0014','2025-02-15','2026-02-15','Activa',17500.00,3000.00,'Poliza para transporte escolar.'),
    (15,15,15,15,15,'POL-2025-0015','2025-02-18','2026-02-18','Activa',6500.00,1000.00,'Poliza para rutas nacionales.'),
    (16,16,16,16,7,'POL-2025-0016','2025-02-20','2026-02-20','Vencida',12000.00,4000.00,'Poliza vencida pendiente de renovacion.'),
    (17,17,17,17,17,'POL-2025-0017','2025-02-22','2026-02-22','Activa',19000.00,2000.00,'Poliza para vehiculo hibrido.'),
    (18,18,18,18,18,'POL-2025-0018','2025-02-25','2026-02-25','Cancelada',17500.00,3000.00,'Poliza cancelada por solicitud del cliente.'),
    (19,19,19,19,19,'POL-2025-0019','2025-02-27','2026-02-27','Activa',21000.00,5000.00,'Poliza de mercancia y reparto.'),
    (20,20,20,20,20,'POL-2025-0020','2025-03-01','2026-03-01','Activa',26000.00,3500.00,'Poliza premium para todo terreno.');
GO

-- 20 facturas asociadas a las polizas.
INSERT INTO FacturaPoliza (
    FacturaPoliza_PolizaID,
    FacturaPoliza_Numero,
    FacturaPoliza_FechaEmision,
    FacturaPoliza_MontoTotal,
    FacturaPoliza_Estatus,
    FacturaPoliza_Descripcion
) VALUES
    (1,'FAC-2025-0001','2025-01-10',35000.00,'Pagada','Factura anual de la poliza POL-2025-0001.'),
    (2,'FAC-2025-0002','2025-01-13',15000.00,'Pagada','Factura anual de la poliza POL-2025-0002.'),
    (3,'FAC-2025-0003','2025-01-15',8000.00,'Pagada','Factura anual de la poliza POL-2025-0003.'),
    (4,'FAC-2025-0004','2025-01-17',3000.00,'Pagada','Factura anual de la poliza POL-2025-0004.'),
    (5,'FAC-2025-0005','2025-01-20',22000.00,'Pagada','Factura anual de la poliza POL-2025-0005.'),
    (6,'FAC-2025-0006','2025-01-23',6000.00,'Pagada','Factura anual de la poliza POL-2025-0006.'),
    (7,'FAC-2025-0007','2025-01-25',28000.00,'Pagada','Factura anual de la poliza POL-2025-0007.'),
    (8,'FAC-2025-0008','2025-01-27',26000.00,'Pagada','Factura anual de la poliza POL-2025-0008.'),
    (9,'FAC-2025-0009','2025-01-30',21000.00,'Pagada','Factura anual de la poliza POL-2025-0009.'),
    (10,'FAC-2025-0010','2025-02-02',19000.00,'Pagada','Factura anual de la poliza POL-2025-0010.'),
    (11,'FAC-2025-0011','2025-02-05',14000.00,'Pagada','Factura anual de la poliza POL-2025-0011.'),
    (12,'FAC-2025-0012','2025-02-08',18000.00,'Pagada','Factura anual de la poliza POL-2025-0012.'),
    (13,'FAC-2025-0013','2025-02-10',16000.00,'Pagada','Factura anual de la poliza POL-2025-0013.'),
    (14,'FAC-2025-0014','2025-02-15',17500.00,'Pagada','Factura anual de la poliza POL-2025-0014.'),
    (15,'FAC-2025-0015','2025-02-18',6500.00,'Pagada','Factura anual de la poliza POL-2025-0015.'),
    (16,'FAC-2025-0016','2025-02-20',12000.00,'Pagada','Factura anual de la poliza POL-2025-0016.'),
    (17,'FAC-2025-0017','2025-02-22',19000.00,'Pagada','Factura anual de la poliza POL-2025-0017.'),
    (18,'FAC-2025-0018','2025-02-25',17500.00,'Pagada','Factura anual de la poliza POL-2025-0018.'),
    (19,'FAC-2025-0019','2025-02-27',21000.00,'Pagada','Factura anual de la poliza POL-2025-0019.'),
    (20,'FAC-2025-0020','2025-03-01',26000.00,'Pagada','Factura anual de la poliza POL-2025-0020.');
GO

-- 20 pagos aplicados a las facturas.
INSERT INTO Pago (
    Pago_FacturaPolizaID,
    Pago_ClienteID,
    Pago_Fecha,
    Pago_Monto,
    Pago_Metodo,
    Pago_Referencia,
    Pago_Estatus,
    Pago_Observaciones
) VALUES
    (1,1,'2025-01-11',35000.00,'Transferencia','PAG-2025-0001','Aplicado','Pago completo de la factura FAC-2025-0001.'),
    (2,2,'2025-01-14',15000.00,'Tarjeta','PAG-2025-0002','Aplicado','Pago completo de la factura FAC-2025-0002.'),
    (3,3,'2025-01-16',8000.00,'Cheque','PAG-2025-0003','Aplicado','Pago completo de la factura FAC-2025-0003.'),
    (4,4,'2025-01-18',3000.00,'Efectivo','PAG-2025-0004','Aplicado','Pago completo de la factura FAC-2025-0004.'),
    (5,5,'2025-01-21',22000.00,'Transferencia','PAG-2025-0005','Aplicado','Pago completo de la factura FAC-2025-0005.'),
    (6,6,'2025-01-24',6000.00,'Tarjeta','PAG-2025-0006','Aplicado','Pago completo de la factura FAC-2025-0006.'),
    (7,7,'2025-01-26',28000.00,'Transferencia','PAG-2025-0007','Aplicado','Pago completo de la factura FAC-2025-0007.'),
    (8,8,'2025-01-28',26000.00,'Cheque','PAG-2025-0008','Aplicado','Pago completo de la factura FAC-2025-0008.'),
    (9,9,'2025-01-31',21000.00,'Transferencia','PAG-2025-0009','Aplicado','Pago completo de la factura FAC-2025-0009.'),
    (10,10,'2025-02-03',19000.00,'Tarjeta','PAG-2025-0010','Aplicado','Pago completo de la factura FAC-2025-0010.'),
    (11,11,'2025-02-06',14000.00,'Efectivo','PAG-2025-0011','Aplicado','Pago completo de la factura FAC-2025-0011.'),
    (12,12,'2025-02-09',18000.00,'Transferencia','PAG-2025-0012','Aplicado','Pago completo de la factura FAC-2025-0012.'),
    (13,13,'2025-02-11',16000.00,'Tarjeta','PAG-2025-0013','Aplicado','Pago completo de la factura FAC-2025-0013.'),
    (14,14,'2025-02-16',17500.00,'Cheque','PAG-2025-0014','Aplicado','Pago completo de la factura FAC-2025-0014.'),
    (15,15,'2025-02-19',6500.00,'Transferencia','PAG-2025-0015','Aplicado','Pago completo de la factura FAC-2025-0015.'),
    (16,16,'2025-02-21',12000.00,'Efectivo','PAG-2025-0016','Aplicado','Pago completo de la factura FAC-2025-0016.'),
    (17,17,'2025-02-23',19000.00,'Transferencia','PAG-2025-0017','Aplicado','Pago completo de la factura FAC-2025-0017.'),
    (18,18,'2025-02-26',17500.00,'Tarjeta','PAG-2025-0018','Aplicado','Pago completo de la factura FAC-2025-0018.'),
    (19,19,'2025-02-28',21000.00,'Cheque','PAG-2025-0019','Aplicado','Pago completo de la factura FAC-2025-0019.'),
    (20,20,'2025-03-02',26000.00,'Transferencia','PAG-2025-0020','Aplicado','Pago completo de la factura FAC-2025-0020.');
GO

-- 20 siniestros reportados.
INSERT INTO Siniestro (
    Siniestro_PolizaID,
    Siniestro_VehiculoID,
    Siniestro_Numero,
    Siniestro_FechaOcurrencia,
    Siniestro_FechaReporte,
    Siniestro_Tipo,
    Siniestro_Descripcion,
    Siniestro_LugarOcurrencia,
    Siniestro_MontoEstimadoDano,
    Siniestro_Estatus
) VALUES
    (1,1,'SIN-2025-0001','2025-03-10','2025-03-11','Colision','Choque leve en la parte trasera del vehiculo.','Av. 27 de Febrero, Santo Domingo',85000.00,'Cerrado'),
    (2,2,'SIN-2025-0002','2025-03-14','2025-03-15','Robo','Sustraccion de accesorios externos del vehiculo.','Ensanche Naco, Santo Domingo',45000.00,'Aprobado'),
    (3,3,'SIN-2025-0003','2025-03-18','2025-03-19','Colision','Impacto lateral en estacionamiento comercial.','La Romana',92000.00,'Cerrado'),
    (4,4,'SIN-2025-0004','2025-03-21','2025-03-22','Otro','Caida de la motocicleta por deslizamiento.','Av. Independencia, Santo Domingo',18000.00,'Cerrado'),
    (5,5,'SIN-2025-0005','2025-03-25','2025-03-26','Incendio','Conato de incendio en area del motor.','San Pedro de Macoris',110000.00,'En Evaluacion'),
    (6,6,'SIN-2025-0006','2025-03-28','2025-03-29','Vandalismo','Rotura de cristales y rayones de carroceria.','Santiago',30000.00,'Cerrado'),
    (7,7,'SIN-2025-0007','2025-04-02','2025-04-03','Colision','Colision multiple en autopista.','Autopista Duarte',175000.00,'Aprobado'),
    (8,8,'SIN-2025-0008','2025-04-05','2025-04-06','Inundacion','Entrada de agua al motor y al interior.','Bonao',130000.00,'En Evaluacion'),
    (9,9,'SIN-2025-0009','2025-04-08','2025-04-09','Colision','Impacto frontal con danos en cabina.','San Cristobal',210000.00,'Aprobado'),
    (10,10,'SIN-2025-0010','2025-04-11','2025-04-12','Vandalismo','Rayado general y espejo roto.','Piantini, Santo Domingo',22000.00,'Cerrado'),
    (11,11,'SIN-2025-0011','2025-04-14','2025-04-15','Colision','Golpe en defensa delantera.','Santo Domingo Este',40000.00,'Cerrado'),
    (12,12,'SIN-2025-0012','2025-04-17','2025-04-18','Robo','Robo parcial de radio y bateria.','Santiago',35000.00,'Aprobado'),
    (13,13,'SIN-2025-0013','2025-04-20','2025-04-21','Colision','Accidente leve durante servicio de taxi.','Puerto Plata',60000.00,'Cerrado'),
    (14,14,'SIN-2025-0014','2025-04-23','2025-04-24','Inundacion','Afectacion electrica por inundacion urbana.','San Cristobal',125000.00,'Aprobado'),
    (15,15,'SIN-2025-0015','2025-04-26','2025-04-27','Otro','Danos por carga mal asegurada.','La Romana',28000.00,'Cerrado'),
    (16,16,'SIN-2025-0016','2025-04-29','2025-04-30','Colision','Choque por alcance en semaforo.','Santo Domingo',78000.00,'Cerrado'),
    (17,17,'SIN-2025-0017','2025-05-02','2025-05-03','Incendio','Dano electrico en bateria hibrida.','Santiago',145000.00,'En Evaluacion'),
    (18,18,'SIN-2025-0018','2025-05-05','2025-05-06','Vandalismo','Rotura de ventanas de la unidad escolar.','Moca',26000.00,'Rechazado'),
    (19,19,'SIN-2025-0019','2025-05-08','2025-05-09','Colision','Golpe lateral durante reparto de mercancia.','Higuey',97000.00,'Aprobado'),
    (20,20,'SIN-2025-0020','2025-05-11','2025-05-12','Robo','Intento de robo con danos en puertas.','Punta Cana',88000.00,'En Evaluacion');
GO

-- 20 evaluaciones tecnicas de siniestros.
INSERT INTO EvaluacionSiniestro (
    EvaluacionSiniestro_SiniestroID,
    EvaluacionSiniestro_TallerID,
    EvaluacionSiniestro_Fecha,
    EvaluacionSiniestro_Perito,
    EvaluacionSiniestro_DescripcionDanos,
    EvaluacionSiniestro_MontoAprobado,
    EvaluacionSiniestro_Observaciones,
    EvaluacionSiniestro_Estatus
) VALUES
    (1,1,'2025-03-12','Ing. Ramon Perez','Danos en defensa y compuerta trasera.',82000.00,'Evaluacion completada y aprobada.','Completada'),
    (2,2,'2025-03-16','Ing. Carlos Rodriguez','Faltante de espejos y accesorios laterales.',42000.00,'Se aprueba reposicion parcial.','Completada'),
    (3,3,'2025-03-20','Ing. Ana Vargas','Guardafango y puerta lateral afectados.',90000.00,'Se recomienda reparacion inmediata.','Completada'),
    (4,4,'2025-03-23','Ing. Luis Jimenez','Danos menores en carenado y luces.',16000.00,'Caso cerrado sin observaciones.','Completada'),
    (5,5,'2025-03-27','Ing. Miguel Diaz','Motor y cableado con dano por incendio.',98000.00,'Se mantiene seguimiento tecnico.','Pendiente'),
    (6,6,'2025-03-30','Ing. Patricia Lora','Cristales laterales y pintura afectados.',28000.00,'Reparacion finalizada.','Completada'),
    (7,7,'2025-04-04','Ing. Eduardo Santos','Frente del vehiculo con dano estructural.',165000.00,'Monto aprobado para reparacion mayor.','Completada'),
    (8,8,'2025-04-07','Ing. Roberto Nunez','Sistema electrico afectado por agua.',0.00,'Esperando piezas y diagnostico final.','Pendiente'),
    (9,9,'2025-04-10','Ing. Carmen Matos','Cabina y chasis delantero con danos.',205000.00,'Se aprueba reparacion integral.','Completada'),
    (10,10,'2025-04-13','Ing. Sandra Cruz','Danos superficiales de carroceria y espejo.',21000.00,'Trabajo completado en el taller.','Completada'),
    (11,11,'2025-04-16','Ing. Victor De Leon','Defensa y faros delanteros comprometidos.',37000.00,'Evaluacion cerrada.','Completada'),
    (12,12,'2025-04-19','Ing. Luisina Paredes','Radio y bateria sustraidos del interior.',32000.00,'Se autoriza reposicion de piezas.','Completada'),
    (13,13,'2025-04-22','Ing. Kelvin Ramos','Danos en defensa delantera y capota.',56000.00,'Caso concluido satisfactoriamente.','Completada'),
    (14,14,'2025-04-25','Ing. Maria Almonte','Afectacion electrica por agua en tablero.',118000.00,'Se aprueba reparacion electrica.','Completada'),
    (15,15,'2025-04-28','Ing. Julio Garcia','Dano en puerta trasera y area de carga.',24000.00,'Reparacion realizada y entregada.','Completada'),
    (16,16,'2025-05-01','Ing. Noelia Santos','Golpe frontal leve con piezas reemplazables.',74000.00,'Caso cerrado.','Completada'),
    (17,17,'2025-05-04','Ing. Francisco Peguero','Sistema de bateria hibrida con sobrecalentamiento.',0.00,'Esperando validacion de fabrica.','Pendiente'),
    (18,18,'2025-05-07','Ing. Raul Tejada','Ventanas rotas con signos de vandalismo.',0.00,'Siniestro rechazado por exclusiones del plan.','Rechazada'),
    (19,19,'2025-05-10','Ing. Melissa Perez','Golpe lateral y deformacion de panel.',93000.00,'Monto aprobado para enderezado y pintura.','Completada'),
    (20,20,'2025-05-13','Ing. Jorge Castillo','Puertas forzadas y cerraduras afectadas.',0.00,'Inspeccion abierta para segunda revision.','Pendiente');
GO

-- Mensaje final para confirmar que la carga termino bien.
PRINT '============================================================';
PRINT 'DML ejecutado correctamente.';
PRINT 'Cada tabla recibio 20 registros.';
PRINT '============================================================';
GO
