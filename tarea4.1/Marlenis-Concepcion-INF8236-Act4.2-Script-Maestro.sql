-- ============================================================
-- SCRIPT MAESTRO - Sistema de Seguro de Vehiculos
-- UASD - INF-8236-C2 - Actividad 4.2
-- Este archivo elimina la base de datos si existe,
-- la crea nuevamente, construye toda la estructura
-- y carga los datos y ejercicios DML en una sola ejecucion.
-- Motor objetivo: SQL Server
-- ============================================================

USE master;
GO

IF DB_ID(N'SeguroVehiculos') IS NOT NULL
BEGIN
    ALTER DATABASE SeguroVehiculos SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE SeguroVehiculos;
END
GO

CREATE DATABASE SeguroVehiculos;
GO

USE SeguroVehiculos;
GO

SET NOCOUNT ON;
GO

CREATE TABLE Tipo_Vehiculo (
    ID_Tipo         INT             IDENTITY(1,1)   NOT NULL,
    Descripcion     VARCHAR(100)    NOT NULL,
    Tarifa_Base     DECIMAL(12,2)   NOT NULL,
    Activo          BIT             NOT NULL    DEFAULT 1,
    CONSTRAINT PK_Tipo_Vehiculo     PRIMARY KEY (ID_Tipo),
    CONSTRAINT UQ_Tipo_Descripcion  UNIQUE      (Descripcion),
    CONSTRAINT CHK_Tipo_TarifaBase  CHECK       (Tarifa_Base > 0)
);
GO

CREATE TABLE Cliente (
    ID_Cliente          INT             IDENTITY(1,1)   NOT NULL,
    Cedula              VARCHAR(15)     NOT NULL,
    Nombre              VARCHAR(80)     NOT NULL,
    Apellido            VARCHAR(80)     NOT NULL,
    Fecha_Nacimiento    DATE            NOT NULL,
    Telefono            VARCHAR(20)     NULL,
    Email               VARCHAR(120)    NULL,
    Direccion           VARCHAR(200)    NULL,
    Ciudad              VARCHAR(80)     NOT NULL    DEFAULT 'Santo Domingo',
    Fecha_Registro      DATETIME        NOT NULL    DEFAULT GETDATE(),
    Activo              BIT             NOT NULL    DEFAULT 1,
    CONSTRAINT PK_Cliente           PRIMARY KEY (ID_Cliente),
    CONSTRAINT UQ_Cliente_Cedula    UNIQUE      (Cedula),
    CONSTRAINT UQ_Cliente_Email     UNIQUE      (Email),
    CONSTRAINT CHK_Cliente_Edad     CHECK       (DATEDIFF(YEAR, Fecha_Nacimiento, GETDATE()) >= 18)
);
GO

CREATE TABLE Agente (
    ID_Agente               INT             IDENTITY(1,1)   NOT NULL,
    Cedula                  VARCHAR(15)     NOT NULL,
    Nombre                  VARCHAR(80)     NOT NULL,
    Apellido                VARCHAR(80)     NOT NULL,
    Telefono                VARCHAR(20)     NULL,
    Email                   VARCHAR(120)    NULL,
    Fecha_Ingreso           DATE            NOT NULL    DEFAULT CAST(GETDATE() AS DATE),
    Comision_Porcentaje     DECIMAL(5,2)    NOT NULL    DEFAULT 5.00,
    Activo                  BIT             NOT NULL    DEFAULT 1,
    CONSTRAINT PK_Agente            PRIMARY KEY (ID_Agente),
    CONSTRAINT UQ_Agente_Cedula     UNIQUE      (Cedula),
    CONSTRAINT UQ_Agente_Email      UNIQUE      (Email),
    CONSTRAINT CHK_Agente_Comision  CHECK       (Comision_Porcentaje >= 0 AND Comision_Porcentaje <= 100)
);
GO

CREATE TABLE Cobertura (
    ID_Cobertura    INT             IDENTITY(1,1)   NOT NULL,
    Nombre          VARCHAR(100)    NOT NULL,
    Descripcion     VARCHAR(300)    NULL,
    Prima_Base      DECIMAL(12,2)   NOT NULL,
    Deducible       DECIMAL(12,2)   NOT NULL    DEFAULT 0.00,
    Activa          BIT             NOT NULL    DEFAULT 1,
    CONSTRAINT PK_Cobertura         PRIMARY KEY (ID_Cobertura),
    CONSTRAINT UQ_Cobertura_Nombre  UNIQUE      (Nombre),
    CONSTRAINT CHK_Cobertura_Prima  CHECK       (Prima_Base > 0),
    CONSTRAINT CHK_Cobertura_Ded    CHECK       (Deducible >= 0)
);
GO

CREATE TABLE Taller (
    ID_Taller       INT             IDENTITY(1,1)   NOT NULL,
    Nombre          VARCHAR(120)    NOT NULL,
    Direccion       VARCHAR(200)    NULL,
    Telefono        VARCHAR(20)     NULL,
    Email           VARCHAR(120)    NULL,
    Responsable     VARCHAR(150)    NULL,
    Activo          BIT             NOT NULL    DEFAULT 1,
    CONSTRAINT PK_Taller        PRIMARY KEY (ID_Taller),
    CONSTRAINT UQ_Taller_Nombre UNIQUE      (Nombre)
);
GO

CREATE TABLE Vehiculo (
    ID_Vehiculo         INT             IDENTITY(1,1)   NOT NULL,
    ID_Cliente          INT             NOT NULL,
    ID_Tipo             INT             NOT NULL,
    Placa               VARCHAR(20)     NOT NULL,
    Marca               VARCHAR(60)     NOT NULL,
    Modelo              VARCHAR(60)     NOT NULL,
    Anio                SMALLINT        NOT NULL,
    Color               VARCHAR(40)     NULL,
    Valor_Asegurado     DECIMAL(14,2)   NOT NULL,
    VIN                 VARCHAR(30)     NULL,
    Activo              BIT             NOT NULL    DEFAULT 1,
    CONSTRAINT PK_Vehiculo          PRIMARY KEY (ID_Vehiculo),
    CONSTRAINT UQ_Vehiculo_Placa    UNIQUE      (Placa),
    CONSTRAINT UQ_Vehiculo_VIN      UNIQUE      (VIN),
    CONSTRAINT FK_Vehiculo_Cliente  FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID_Cliente),
    CONSTRAINT FK_Vehiculo_Tipo     FOREIGN KEY (ID_Tipo)    REFERENCES Tipo_Vehiculo(ID_Tipo),
    CONSTRAINT CHK_Vehiculo_Anio    CHECK       (Anio >= 1900 AND Anio <= 2030),
    CONSTRAINT CHK_Vehiculo_Valor   CHECK       (Valor_Asegurado > 0)
);
GO

CREATE TABLE Solicitud_Cotizacion_Poliza (
    ID_Solicitud        INT             IDENTITY(1,1)   NOT NULL,
    ID_Cliente          INT             NOT NULL,
    ID_Vehiculo         INT             NOT NULL,
    ID_Agente           INT             NOT NULL,
    ID_Cobertura        INT             NOT NULL,
    Fecha_Solicitud     DATETIME        NOT NULL    DEFAULT GETDATE(),
    Estado              VARCHAR(20)     NOT NULL    DEFAULT 'Pendiente',
    Observaciones       VARCHAR(500)    NULL,
    Monto_Cotizado      DECIMAL(12,2)   NULL,
    CONSTRAINT PK_Solicitud         PRIMARY KEY (ID_Solicitud),
    CONSTRAINT FK_Solic_Cliente     FOREIGN KEY (ID_Cliente)   REFERENCES Cliente(ID_Cliente),
    CONSTRAINT FK_Solic_Vehiculo    FOREIGN KEY (ID_Vehiculo)  REFERENCES Vehiculo(ID_Vehiculo),
    CONSTRAINT FK_Solic_Agente      FOREIGN KEY (ID_Agente)    REFERENCES Agente(ID_Agente),
    CONSTRAINT FK_Solic_Cobertura   FOREIGN KEY (ID_Cobertura) REFERENCES Cobertura(ID_Cobertura),
    CONSTRAINT CHK_Solic_Estado     CHECK       (Estado IN ('Pendiente', 'Aprobada', 'Rechazada'))
);
GO

CREATE TABLE Poliza (
    ID_Poliza           INT             IDENTITY(1,1)   NOT NULL,
    ID_Solicitud        INT             NOT NULL,
    ID_Cliente          INT             NOT NULL,
    ID_Vehiculo         INT             NOT NULL,
    ID_Agente           INT             NOT NULL,
    ID_Cobertura        INT             NOT NULL,
    Numero_Poliza       VARCHAR(20)     NOT NULL,
    Fecha_Emision       DATE            NOT NULL,
    Fecha_Vencimiento   DATE            NOT NULL,
    Estado_Poliza       VARCHAR(15)     NOT NULL    DEFAULT 'Activa',
    Prima_Anual         DECIMAL(12,2)   NOT NULL,
    Deducible           DECIMAL(12,2)   NOT NULL    DEFAULT 0.00,
    Observaciones       VARCHAR(500)    NULL,
    CONSTRAINT PK_Poliza            PRIMARY KEY (ID_Poliza),
    CONSTRAINT UQ_Poliza_Numero     UNIQUE      (Numero_Poliza),
    CONSTRAINT FK_Poliza_Solicitud  FOREIGN KEY (ID_Solicitud) REFERENCES Solicitud_Cotizacion_Poliza(ID_Solicitud),
    CONSTRAINT FK_Poliza_Cliente    FOREIGN KEY (ID_Cliente)   REFERENCES Cliente(ID_Cliente),
    CONSTRAINT FK_Poliza_Vehiculo   FOREIGN KEY (ID_Vehiculo)  REFERENCES Vehiculo(ID_Vehiculo),
    CONSTRAINT FK_Poliza_Agente     FOREIGN KEY (ID_Agente)    REFERENCES Agente(ID_Agente),
    CONSTRAINT FK_Poliza_Cobertura  FOREIGN KEY (ID_Cobertura) REFERENCES Cobertura(ID_Cobertura),
    CONSTRAINT CHK_Poliza_Estado    CHECK       (Estado_Poliza IN ('Activa', 'Vencida', 'Cancelada')),
    CONSTRAINT CHK_Poliza_Prima     CHECK       (Prima_Anual > 0),
    CONSTRAINT CHK_Poliza_Fechas    CHECK       (Fecha_Vencimiento > Fecha_Emision)
);
GO

CREATE TABLE Factura_Poliza (
    ID_Factura          INT             IDENTITY(1,1)   NOT NULL,
    ID_Poliza           INT             NOT NULL,
    Numero_Factura      VARCHAR(20)     NOT NULL,
    Fecha_Emision       DATETIME        NOT NULL    DEFAULT GETDATE(),
    Monto_Total         DECIMAL(12,2)   NOT NULL,
    Estado_Factura      VARCHAR(15)     NOT NULL    DEFAULT 'Registrada',
    Descripcion         VARCHAR(300)    NULL,
    CONSTRAINT PK_Factura           PRIMARY KEY (ID_Factura),
    CONSTRAINT UQ_Factura_Numero    UNIQUE      (Numero_Factura),
    CONSTRAINT FK_Factura_Poliza    FOREIGN KEY (ID_Poliza) REFERENCES Poliza(ID_Poliza),
    CONSTRAINT CHK_Factura_Estado   CHECK       (Estado_Factura IN ('Registrada', 'Entregada', 'Pagada', 'Anulada')),
    CONSTRAINT CHK_Factura_Monto    CHECK       (Monto_Total > 0)
);
GO

CREATE TABLE Pagos (
    ID_Pago         INT             IDENTITY(1,1)   NOT NULL,
    ID_Factura      INT             NOT NULL,
    ID_Cliente      INT             NOT NULL,
    Fecha_Pago      DATETIME        NOT NULL    DEFAULT GETDATE(),
    Monto           DECIMAL(12,2)   NOT NULL,
    Metodo_Pago     VARCHAR(20)     NOT NULL    DEFAULT 'Transferencia',
    Referencia      VARCHAR(50)     NULL,
    Observaciones   VARCHAR(300)    NULL,
    CONSTRAINT PK_Pagos         PRIMARY KEY (ID_Pago),
    CONSTRAINT FK_Pagos_Factura FOREIGN KEY (ID_Factura) REFERENCES Factura_Poliza(ID_Factura),
    CONSTRAINT FK_Pagos_Cliente FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID_Cliente),
    CONSTRAINT CHK_Pagos_Monto  CHECK       (Monto > 0),
    CONSTRAINT CHK_Pagos_Metodo CHECK       (Metodo_Pago IN ('Efectivo', 'Transferencia', 'Tarjeta', 'Cheque'))
);
GO

CREATE TABLE Siniestro (
    ID_Siniestro        INT             IDENTITY(1,1)   NOT NULL,
    ID_Poliza           INT             NOT NULL,
    ID_Vehiculo         INT             NOT NULL,
    Numero_Siniestro    VARCHAR(20)     NOT NULL,
    Fecha_Ocurrencia    DATE            NOT NULL,
    Fecha_Reporte       DATETIME        NOT NULL    DEFAULT GETDATE(),
    Tipo_Siniestro      VARCHAR(20)     NOT NULL,
    Descripcion         VARCHAR(500)    NULL,
    Lugar_Ocurrencia    VARCHAR(200)    NULL,
    Monto_Estimado_Dano DECIMAL(12,2)   NOT NULL    DEFAULT 0.00,
    Estado_Siniestro    VARCHAR(20)     NOT NULL    DEFAULT 'Reportado',
    CONSTRAINT PK_Siniestro             PRIMARY KEY (ID_Siniestro),
    CONSTRAINT UQ_Siniestro_Numero      UNIQUE      (Numero_Siniestro),
    CONSTRAINT FK_Siniestro_Poliza      FOREIGN KEY (ID_Poliza)   REFERENCES Poliza(ID_Poliza),
    CONSTRAINT FK_Siniestro_Vehiculo    FOREIGN KEY (ID_Vehiculo) REFERENCES Vehiculo(ID_Vehiculo),
    CONSTRAINT CHK_Siniestro_Tipo       CHECK       (Tipo_Siniestro IN ('Colision','Robo','Incendio','Inundacion','Vandalismo','Otro')),
    CONSTRAINT CHK_Siniestro_Estado     CHECK       (Estado_Siniestro IN ('Reportado','En Evaluacion','Aprobado','Rechazado','Cerrado')),
    CONSTRAINT CHK_Siniestro_Monto      CHECK       (Monto_Estimado_Dano >= 0)
);
GO

CREATE TABLE Evaluacion_Siniestro (
    ID_Evaluacion       INT             IDENTITY(1,1)   NOT NULL,
    ID_Siniestro        INT             NOT NULL,
    ID_Taller           INT             NOT NULL,
    Fecha_Evaluacion    DATE            NOT NULL    DEFAULT CAST(GETDATE() AS DATE),
    Perito              VARCHAR(150)    NULL,
    Descripcion_Danos   VARCHAR(600)    NULL,
    Monto_Aprobado      DECIMAL(12,2)   NOT NULL    DEFAULT 0.00,
    Observaciones       VARCHAR(400)    NULL,
    Estado_Evaluacion   VARCHAR(15)     NOT NULL    DEFAULT 'Pendiente',
    CONSTRAINT PK_Evaluacion        PRIMARY KEY (ID_Evaluacion),
    CONSTRAINT FK_Eval_Siniestro    FOREIGN KEY (ID_Siniestro) REFERENCES Siniestro(ID_Siniestro),
    CONSTRAINT FK_Eval_Taller       FOREIGN KEY (ID_Taller)    REFERENCES Taller(ID_Taller),
    CONSTRAINT CHK_Eval_Estado      CHECK       (Estado_Evaluacion IN ('Pendiente','Completada','Rechazada')),
    CONSTRAINT CHK_Eval_Monto       CHECK       (Monto_Aprobado >= 0)
);
GO

INSERT INTO Tipo_Vehiculo (Descripcion, Tarifa_Base) VALUES
    ('Automovil Sedan', 5000.00),
    ('SUV / Jeepeta', 7000.00),
    ('Camioneta Pickup', 6500.00),
    ('Motocicleta', 2500.00),
    ('Camion Ligero', 9000.00),
    ('Furgoneta / Minivan', 8000.00),
    ('Automovil Deportivo', 12000.00),
    ('Jeep 4x4', 8500.00),
    ('Camion Pesado', 15000.00),
    ('Vehiculo Electrico', 10000.00);
GO

INSERT INTO Cliente (Cedula, Nombre, Apellido, Fecha_Nacimiento, Telefono, Email, Direccion, Ciudad) VALUES
    ('001-1234567-1','Jose Manuel','Martinez Perez','1985-03-15','809-555-1001','jose.martinez@correo.do','Calle Las Flores 12, Los Prados','Santo Domingo'),
    ('001-2345678-2','Maria Teresa','Garcia Lopez','1990-07-22','809-555-1002','maria.garcia@correo.do','Av. 27 de Febrero 45, Ensanche Naco','Santiago'),
    ('001-3456789-3','Carlos Alberto','Rodriguez Santos','1978-11-05','809-555-1003','carlos.rodriguez@correo.do','C/ Duarte 78, Centro Historico','La Romana'),
    ('001-4567890-4','Ana Mercedes','Perez Mejia','1995-02-18','809-555-1004','ana.perez@correo.do','Urb. Arroyo Hondo, Calle B #3','Santo Domingo'),
    ('001-5678901-5','Luis Fernando','Medina Castro','1988-09-30','809-555-1005','luis.medina@correo.do','C/ Independencia 200, Gazcue','San Pedro de Macoris'),
    ('001-6789012-6','Carmen Rosa','Feliz Diaz','1992-04-12','809-555-1006','carmen.feliz@correo.do','Urb. La Esperanza, Bloque 5','Santiago'),
    ('001-7890123-7','Pedro Antonio','Nunez Reyes','1975-08-08','809-555-1007','pedro.nunez@correo.do','C/ El Conde 99','Santo Domingo'),
    ('001-8901234-8','Altagracia','Jimenez Soto','1983-12-25','809-555-1008','altagracia.jimenez@correo.do','Av. Gregorio Luperon 56','La Vega'),
    ('001-9012345-9','Roberto Emilio','Vargas Taveras','2000-01-14','809-555-1009','roberto.vargas@correo.do','Res. Palmas del Este, Apto 4B','Santo Domingo'),
    ('001-0123456-0','Luz Maria','Capellan Rosario','1997-06-20','809-555-1010','luz.capellan@correo.do','Av. Enriquillo 11, Barrio Nuevo','Barahona');
GO

INSERT INTO Agente (Cedula, Nombre, Apellido, Telefono, Email, Fecha_Ingreso, Comision_Porcentaje) VALUES
    ('002-1111111-1','Roberto','Perez Fernandez','809-555-2001','r.perez@seguroveh.do','2018-01-10',6.00),
    ('002-2222222-2','Sandra','Gomez Cruz','809-555-2002','s.gomez@seguroveh.do','2019-03-15',5.50),
    ('002-3333333-3','Miguel','Torres Medina','809-555-2003','m.torres@seguroveh.do','2017-06-20',7.00),
    ('002-4444444-4','Patricia','Reyes Santos','809-555-2004','p.reyes@seguroveh.do','2020-02-01',5.00),
    ('002-5555555-5','Juan Carlos','Alvarez Garcia','809-555-2005','jc.alvarez@seguroveh.do','2016-11-12',8.00),
    ('002-6666666-6','Daniela','Lora Batista','809-555-2006','d.lora@seguroveh.do','2021-07-05',5.00),
    ('002-7777777-7','Eduardo','Herrera Diaz','809-555-2007','e.herrera@seguroveh.do','2015-04-18',9.00),
    ('002-8888888-8','Claudia','Mateo Jimenez','809-555-2008','c.mateo@seguroveh.do','2022-09-01',5.00),
    ('002-9999999-9','Francisco','Polanco Nunez','809-555-2009','f.polanco@seguroveh.do','2019-12-10',6.50),
    ('002-0000000-0','Isabel','Mejia Rosario','809-555-2010','i.mejia@seguroveh.do','2023-01-20',5.00);
GO

INSERT INTO Cobertura (Nombre, Descripcion, Prima_Base, Deducible) VALUES
    ('Cobertura Basica SOAT','Seguro obligatorio de accidentes de transito. Cubre danos a terceros por lesiones.',3000.00,0.00),
    ('Cobertura Terceros Limitada','Protege frente a danos materiales o corporales causados a terceros.',8000.00,2000.00),
    ('Cobertura Danos Propios','Repara danos fisicos al vehiculo asegurado por accidente.',15000.00,5000.00),
    ('Cobertura Robo Total','Indemniza al asegurado en caso de robo o hurto del vehiculo.',20000.00,0.00),
    ('Cobertura Todo Riesgo','Cobertura integral: danos propios, terceros, robo, fenomenos naturales.',35000.00,3000.00),
    ('Cobertura Asistencia Vial 24h','Grua, bateria, cambio de llanta, combustible y asistencia en carretera.',5000.00,0.00),
    ('Cobertura Danos por Fenomenos Naturales','Cubre inundaciones, huracanes, deslizamientos e inundaciones.',12000.00,4000.00),
    ('Cobertura Responsabilidad Civil Amplia','Amplia proteccion ante reclamaciones de terceros por danos fisicos y materiales.',18000.00,2500.00),
    ('Cobertura Cristales y Espejos','Reparacion o reposicion de cristales y espejos del vehiculo.',4000.00,500.00),
    ('Cobertura Accidentes a Pasajeros','Seguro personal para los pasajeros que viajen en el vehiculo asegurado.',6000.00,0.00);
GO

INSERT INTO Taller (Nombre, Direccion, Telefono, Email, Responsable) VALUES
    ('Taller Automotriz El Caribe','Av. John F. Kennedy Km 9, Sto. Dgo.','809-555-3001','elcaribe@talleres.do','Ing. Ramon Perez'),
    ('Servicio Tecnico Rodriguez','C/ Max Henriquez Urena 22, Santiago','809-555-3002','rodriguez@talleres.do','Ing. Carlos Rodriguez'),
    ('Centro Automotriz Los Prados','Urb. Los Prados, Calle 8, Sto. Dgo.','809-555-3003','losprados@talleres.do','Ing. Ana Vargas'),
    ('Taller Especializado Honda','Av. Tiradentes 101, Naco, Sto. Dgo.','809-555-3004','honda@talleres.do','Ing. Luis Jimenez'),
    ('Reparaciones Diaz & Asociados','C/ Pedro Clisante 45, La Romana','809-555-3005','diazasoc@talleres.do','Ing. Miguel Diaz'),
    ('Centro de Colisiones Santiago','Av. 27 de Febrero 200, Santiago','809-555-3006','colsantiago@talleres.do','Ing. Patricia Lora'),
    ('Taller Toyota de las Americas','Av. Las Americas Km 14, Sto. Dgo.','809-555-3007','toyota@talleres.do','Ing. Eduardo Santos'),
    ('Servicio Automotriz Nacional','Av. Luperon 300, Sto. Dgo. Oeste','809-555-3008','san@talleres.do','Ing. Roberto Nunez'),
    ('Taller Expertos en Carroceria','C/ Del Sol 50, San Pedro de Macoris','809-555-3009','carroceria@talleres.do','Ing. Carmen Matos'),
    ('Centro Tecnico Premium','Av. Winston Churchill 55, Piantini','809-555-3010','premium@talleres.do','Ing. Sandra Cruz');
GO

INSERT INTO Vehiculo (ID_Cliente, ID_Tipo, Placa, Marca, Modelo, Anio, Color, Valor_Asegurado, VIN) VALUES
    (1,1,'A123456','Toyota','Corolla',2020,'Plateado',1200000.00,'JT2BF22K1W0000001'),
    (1,2,'B234567','Honda','CR-V',2022,'Blanco',1850000.00,'5J6RE4H70NL000002'),
    (2,2,'C345678','Hyundai','Tucson',2021,'Gris',1750000.00,'KM8J3CA46MU000003'),
    (2,3,'D456789','Toyota','Hilux',2019,'Negro',2100000.00,'MR0GX32G400000004'),
    (3,2,'E567890','Kia','Sportage',2022,'Rojo',1680000.00,'U5YPG811MNL000005'),
    (3,3,'F678901','Nissan','Frontier',2020,'Azul',1900000.00,'1N6BD0CT7LN000006'),
    (4,1,'G789012','Honda','Civic',2018,'Blanco',980000.00,'2HGFC2F53JH000007'),
    (5,8,'H890123','Ford','Explorer',2021,'Negro',2300000.00,'1FMSK7FH5MGA00008'),
    (6,4,'I901234','Yamaha','MT-15',2023,'Amarillo',320000.00,'ME1RG0545P0000009'),
    (7,2,'J012345','Mitsubishi','Outlander',2022,'Gris',1950000.00,'JA4J2VA68NZ000010'),
    (8,3,'K123456','Chevrolet','Silverado',2020,'Blanco',2400000.00,'1GCRCPEH1LZ000011'),
    (9,10,'L234567','Tesla','Model 3',2023,'Blanco',3100000.00,'5YJ3E1EA4PF000012');
GO

INSERT INTO Solicitud_Cotizacion_Poliza (ID_Cliente, ID_Vehiculo, ID_Agente, ID_Cobertura, Fecha_Solicitud, Estado, Observaciones, Monto_Cotizado) VALUES
    (1,1,1,5,'2025-01-05','Aprobada','Cliente solicita cobertura Todo Riesgo para su Corolla',35000.00),
    (1,2,2,3,'2025-01-08','Aprobada','Cotizacion para CR-V, cobertura danos propios',15000.00),
    (1,1,3,8,'2025-02-10','Aprobada','Solicita Responsabilidad Civil amplia para Corolla',18000.00),
    (2,3,1,5,'2025-01-12','Aprobada','Todo Riesgo para Tucson nuevo',35000.00),
    (2,4,4,2,'2025-02-14','Aprobada','Terceros para la Hilux de trabajo',8000.00),
    (2,3,5,7,'2025-03-01','Aprobada','Cobertura fenomenos naturales adicional',12000.00),
    (3,5,6,3,'2025-01-20','Aprobada','Danos propios para el Sportage',15000.00),
    (3,6,7,4,'2025-02-20','Aprobada','Robo total para la Frontier',20000.00),
    (4,7,8,1,'2025-03-05','Aprobada','SOAT para el Civic',3000.00),
    (4,7,9,6,'2025-03-10','Aprobada','Asistencia vial para el Civic',5000.00),
    (5,8,10,5,'2025-02-25','Aprobada','Todo Riesgo para el Explorer',35000.00),
    (5,8,1,7,'2025-03-15','Aprobada','Fenomenos naturales para el Explorer',12000.00),
    (6,9,2,1,'2025-04-01','Aprobada','SOAT para la moto',3000.00),
    (6,9,3,9,'2025-04-05','Aprobada','Cobertura cristales para la moto',4000.00),
    (7,10,4,4,'2025-03-20','Aprobada','Robo total para el Outlander',20000.00),
    (7,10,5,2,'2025-04-10','Aprobada','Terceros para el Outlander',8000.00),
    (8,11,6,3,'2025-02-01','Aprobada','Danos propios para la Silverado',15000.00),
    (8,11,7,5,'2025-03-25','Aprobada','Todo Riesgo para la Silverado',35000.00),
    (9,12,8,10,'2025-04-15','Aprobada','Accidentes pasajeros para el Tesla',6000.00),
    (9,12,9,5,'2025-05-01','Aprobada','Todo Riesgo para el Tesla',35000.00);
GO

INSERT INTO Poliza (ID_Solicitud, ID_Cliente, ID_Vehiculo, ID_Agente, ID_Cobertura, Numero_Poliza, Fecha_Emision, Fecha_Vencimiento, Estado_Poliza, Prima_Anual, Deducible) VALUES
    (1,1,1,1,5,'POL-2025-0001','2025-01-10','2026-01-10','Activa',35000.00,3000.00),
    (2,1,2,2,3,'POL-2025-0002','2025-01-15','2026-01-15','Activa',15000.00,5000.00),
    (3,1,1,3,8,'POL-2025-0003','2025-02-15','2026-02-15','Activa',18000.00,2500.00),
    (4,2,3,1,5,'POL-2025-0004','2025-01-18','2026-01-18','Activa',35000.00,3000.00),
    (5,2,4,4,2,'POL-2025-0005','2025-02-20','2026-02-20','Activa',8000.00,2000.00),
    (6,2,3,5,7,'POL-2025-0006','2025-03-05','2026-03-05','Activa',12000.00,4000.00),
    (7,3,5,6,3,'POL-2025-0007','2025-01-25','2026-01-25','Activa',15000.00,5000.00),
    (8,3,6,7,4,'POL-2025-0008','2025-02-25','2026-02-25','Activa',20000.00,0.00),
    (9,4,7,8,1,'POL-2025-0009','2025-03-10','2026-03-10','Activa',3000.00,0.00),
    (10,4,7,9,6,'POL-2025-0010','2025-03-15','2026-03-15','Activa',5000.00,0.00),
    (11,5,8,10,5,'POL-2025-0011','2025-03-01','2026-03-01','Activa',35000.00,3000.00),
    (12,5,8,1,7,'POL-2025-0012','2025-03-20','2026-03-20','Activa',12000.00,4000.00),
    (13,6,9,2,1,'POL-2025-0013','2024-04-05','2025-04-05','Vencida',3000.00,0.00),
    (14,6,9,3,9,'POL-2025-0014','2024-04-10','2025-04-10','Vencida',4000.00,500.00),
    (15,7,10,4,4,'POL-2025-0015','2025-03-25','2026-03-25','Activa',20000.00,0.00),
    (16,7,10,5,2,'POL-2025-0016','2025-04-15','2026-04-15','Activa',8000.00,2000.00),
    (17,8,11,6,3,'POL-2025-0017','2024-02-05','2025-02-05','Vencida',15000.00,5000.00),
    (18,8,11,7,5,'POL-2025-0018','2024-03-28','2025-03-28','Vencida',35000.00,3000.00),
    (19,9,12,8,10,'POL-2025-0019','2025-04-20','2026-04-20','Activa',6000.00,0.00),
    (20,9,12,9,5,'POL-2025-0020','2025-05-05','2026-05-05','Activa',35000.00,3000.00);
GO

INSERT INTO Factura_Poliza (ID_Poliza, Numero_Factura, Fecha_Emision, Monto_Total, Estado_Factura, Descripcion) VALUES
    (1,'FAC-2025-0001','2025-01-10',35000.00,'Pagada','Prima anual POL-2025-0001 - Todo Riesgo Corolla'),
    (2,'FAC-2025-0002','2025-01-15',15000.00,'Pagada','Prima anual POL-2025-0002 - Danos Propios CR-V'),
    (3,'FAC-2025-0003','2025-02-15',18000.00,'Pagada','Prima anual POL-2025-0003 - Resp. Civil Corolla'),
    (4,'FAC-2025-0004','2025-01-18',35000.00,'Pagada','Prima anual POL-2025-0004 - Todo Riesgo Tucson'),
    (5,'FAC-2025-0005','2025-02-20',8000.00,'Pagada','Prima anual POL-2025-0005 - Terceros Hilux'),
    (6,'FAC-2025-0006','2025-03-05',12000.00,'Pagada','Prima anual POL-2025-0006 - Fen. Naturales Tucson'),
    (7,'FAC-2025-0007','2025-01-25',15000.00,'Pagada','Prima anual POL-2025-0007 - Danos Propios Sportage'),
    (8,'FAC-2025-0008','2025-02-25',20000.00,'Pagada','Prima anual POL-2025-0008 - Robo Total Frontier'),
    (9,'FAC-2025-0009','2025-03-10',3000.00,'Pagada','Prima anual POL-2025-0009 - SOAT Civic'),
    (10,'FAC-2025-0010','2025-03-15',5000.00,'Pagada','Prima anual POL-2025-0010 - Asistencia Vial Civic'),
    (11,'FAC-2025-0011','2025-03-01',35000.00,'Pagada','Prima anual POL-2025-0011 - Todo Riesgo Explorer'),
    (12,'FAC-2025-0012','2025-03-20',12000.00,'Pagada','Prima anual POL-2025-0012 - Fen. Naturales Explorer'),
    (13,'FAC-2024-0013','2024-04-05',3000.00,'Pagada','Prima anual POL-2025-0013 - SOAT Moto (vencida)'),
    (14,'FAC-2024-0014','2024-04-10',4000.00,'Pagada','Prima anual POL-2025-0014 - Cristales Moto (vencida)'),
    (15,'FAC-2025-0015','2025-03-25',20000.00,'Pagada','Prima anual POL-2025-0015 - Robo Total Outlander'),
    (16,'FAC-2025-0016','2025-04-15',8000.00,'Entregada','Prima anual POL-2025-0016 - Terceros Outlander'),
    (17,'FAC-2024-0017','2024-02-05',15000.00,'Pagada','Prima anual POL-2025-0017 - Danos Propios Silverado'),
    (18,'FAC-2024-0018','2024-03-28',35000.00,'Pagada','Prima anual POL-2025-0018 - Todo Riesgo Silverado'),
    (19,'FAC-2025-0019','2025-04-20',6000.00,'Registrada','Prima anual POL-2025-0019 - Pasajeros Tesla'),
    (20,'FAC-2025-0020','2025-05-05',35000.00,'Registrada','Prima anual POL-2025-0020 - Todo Riesgo Tesla');
GO

INSERT INTO Pagos (ID_Factura, ID_Cliente, Fecha_Pago, Monto, Metodo_Pago, Referencia) VALUES
    (1,1,'2025-01-11',35000.00,'Transferencia','TRF-0001-2025'),
    (2,1,'2025-01-16',15000.00,'Tarjeta','TAR-0002-2025'),
    (3,1,'2025-02-16',18000.00,'Transferencia','TRF-0003-2025'),
    (4,2,'2025-01-19',35000.00,'Cheque','CHQ-0004-2025'),
    (5,2,'2025-02-21',8000.00,'Efectivo','EFE-0005-2025'),
    (6,2,'2025-03-06',12000.00,'Transferencia','TRF-0006-2025'),
    (7,3,'2025-01-26',15000.00,'Tarjeta','TAR-0007-2025'),
    (8,3,'2025-02-26',20000.00,'Transferencia','TRF-0008-2025'),
    (9,4,'2025-03-11',3000.00,'Efectivo','EFE-0009-2025'),
    (10,4,'2025-03-16',5000.00,'Transferencia','TRF-0010-2025'),
    (11,5,'2025-03-02',35000.00,'Cheque','CHQ-0011-2025'),
    (12,5,'2025-03-21',12000.00,'Transferencia','TRF-0012-2025'),
    (13,6,'2024-04-06',3000.00,'Efectivo','EFE-0013-2024'),
    (14,6,'2024-04-11',4000.00,'Tarjeta','TAR-0014-2024'),
    (15,7,'2025-03-26',20000.00,'Transferencia','TRF-0015-2025'),
    (16,7,'2025-04-16',8000.00,'Cheque','CHQ-0016-2025'),
    (17,8,'2024-02-06',15000.00,'Transferencia','TRF-0017-2024'),
    (18,8,'2024-03-29',35000.00,'Tarjeta','TAR-0018-2024'),
    (19,9,'2025-04-21',6000.00,'Transferencia','TRF-0019-2025'),
    (20,9,'2025-05-06',35000.00,'Transferencia','TRF-0020-2025'),
    (1,1,'2025-07-11',10000.00,'Transferencia','TRF-0021-2025'),
    (4,2,'2025-07-19',10000.00,'Tarjeta','TAR-0022-2025'),
    (11,5,'2025-09-02',8000.00,'Efectivo','EFE-0023-2025'),
    (7,3,'2025-07-26',5000.00,'Transferencia','TRF-0024-2025'),
    (15,7,'2025-09-26',5000.00,'Cheque','CHQ-0025-2025');
GO

INSERT INTO Siniestro (ID_Poliza, ID_Vehiculo, Numero_Siniestro, Fecha_Ocurrencia, Tipo_Siniestro, Descripcion, Lugar_Ocurrencia, Monto_Estimado_Dano, Estado_Siniestro) VALUES
    (1,1,'SIN-2025-0001','2025-03-10','Colision','Choque trasero en semaforo','Av. 27 de Febrero, Sto. Dgo.',85000.00,'Cerrado'),
    (1,1,'SIN-2025-0002','2025-05-18','Vandalismo','Rayones y espejos rotos en parqueo','Centro Comercial Sambil',12000.00,'Cerrado'),
    (3,1,'SIN-2025-0003','2025-07-22','Inundacion','Motor danado por paso de agua profunda','Av. Charles de Gaulle, Sto. Dgo',150000.00,'Aprobado'),
    (1,1,'SIN-2025-0004','2025-09-30','Colision','Impacto lateral en rotonda','Av. Maximo Gomez, Sto. Dgo.',95000.00,'En Evaluacion'),
    (2,2,'SIN-2025-0005','2025-04-05','Robo','Robo de catalogo de repuestos','Urb. Naco, Sto. Dgo.',45000.00,'Aprobado'),
    (2,2,'SIN-2025-0006','2025-06-15','Colision','Choque frontal por fallo de frenos','Autopista Duarte Km 35',220000.00,'Cerrado'),
    (4,3,'SIN-2025-0007','2025-02-14','Inundacion','Danos por aguacero e inundacion','Santiago, Zona Industrial',78000.00,'Cerrado'),
    (5,4,'SIN-2025-0008','2025-08-20','Colision','Choque con poste de alumbrado','Autopista El Coral, La Romana',115000.00,'Aprobado'),
    (7,5,'SIN-2025-0009','2025-03-28','Vandalismo','Cristal trasero destruido','Estacionamiento UASD, Sto. Dgo.',25000.00,'Cerrado'),
    (7,5,'SIN-2025-0010','2025-11-05','Colision','Impacto por accidente multiple','Av. Tiradentes, Sto. Dgo.',135000.00,'Reportado'),
    (8,6,'SIN-2025-0011','2025-05-30','Robo','Robo total del vehiculo en carretera','Carretera Sanchez Km 50',190000.00,'Aprobado'),
    (9,7,'SIN-2025-0012','2025-06-10','Colision','Raspado lateral en estacionamiento','Centro Comercial Las Americas',18000.00,'Cerrado'),
    (11,8,'SIN-2025-0013','2025-07-08','Inundacion','Anegamiento del motor por lluvia','Av. Bolivar, Sto. Dgo.',165000.00,'En Evaluacion'),
    (13,9,'SIN-2024-0014','2024-05-20','Colision','Accidente con vehiculo pesado','Av. Independencia, Sto. Dgo.',8000.00,'Cerrado'),
    (15,10,'SIN-2025-0015','2025-04-12','Vandalismo','Espejo y faros destruidos','Calle El Conde, Sto. Dgo.',22000.00,'Aprobado'),
    (17,11,'SIN-2024-0016','2024-03-15','Colision','Choque en autopista a baja velocidad','Autopista Las Americas Km 8',55000.00,'Cerrado'),
    (19,12,'SIN-2025-0017','2025-06-01','Colision','Rayado de carroceria en estacionamiento','Res. Palmas del Este',9000.00,'Cerrado'),
    (4,3,'SIN-2025-0018','2025-09-10','Robo','Robo parcial de accesorios internos','Barrio Universitario, Santiago',38000.00,'Reportado'),
    (6,3,'SIN-2025-0019','2025-10-22','Inundacion','Inundacion de motor y cableado electrico','Urb. El Milleron, Santiago',200000.00,'En Evaluacion'),
    (7,5,'SIN-2025-0020','2025-12-01','Incendio','Cortocircuito en el motor del vehiculo','Autopista 6 de Noviembre, Sto Dgo',300000.00,'Reportado');
GO

INSERT INTO Evaluacion_Siniestro (ID_Siniestro, ID_Taller, Fecha_Evaluacion, Perito, Descripcion_Danos, Monto_Aprobado, Estado_Evaluacion) VALUES
    (1,1,'2025-03-12','Ing. Ramon Perez','Danos en paragolpes trasero y maleta',82000.00,'Completada'),
    (2,2,'2025-05-20','Ing. Carlos Rodriguez','Rayones profundos en carroceria y espejo izq.',11500.00,'Completada'),
    (3,3,'2025-07-25','Ing. Ana Vargas','Motor anegado, danos en sistema electrico',145000.00,'Completada'),
    (4,1,'2025-10-02','Ing. Ramon Perez','Danos en puerta, guardafango y vidrio lateral',92000.00,'Pendiente'),
    (5,4,'2025-04-08','Ing. Luis Jimenez','Guantera forzada y sistema de audio robado',43000.00,'Completada'),
    (6,5,'2025-06-18','Ing. Miguel Diaz','Dano total frontal, airbag desplegado',215000.00,'Completada'),
    (7,6,'2025-02-16','Ing. Patricia Lora','Alfombras, puertas y sistema electrico danados',75000.00,'Completada'),
    (8,7,'2025-08-22','Ing. Eduardo Santos','Rueda delantera, brazo de suspension y parachoques',112000.00,'Completada'),
    (9,9,'2025-03-30','Ing. Carmen Matos','Cristal trasero fracturado completamente',24000.00,'Completada'),
    (10,1,'2025-11-07','Ing. Ramon Perez','Evaluacion en proceso - colision multiple',0.00,'Pendiente'),
    (11,8,'2025-06-02','Ing. Roberto Nunez','Robo total confirmado; vehiculo no recuperado',190000.00,'Completada'),
    (12,3,'2025-06-12','Ing. Ana Vargas','Raspado superficial en puerta trasera derecha',17500.00,'Completada'),
    (13,4,'2025-07-10','Ing. Luis Jimenez','Motor con agua, modulos electronicos danados',160000.00,'Pendiente'),
    (14,2,'2024-05-22','Ing. Carlos Rodriguez','Guardafango y farola danadados por impacto',7800.00,'Completada'),
    (15,10,'2025-04-14','Ing. Sandra Cruz','Espejo retrovisor y faros delanteros repuestos',21500.00,'Completada'),
    (16,5,'2024-03-17','Ing. Miguel Diaz','Choque menor; danos en paragolpes y capota',53000.00,'Completada'),
    (17,3,'2025-06-03','Ing. Ana Vargas','Raspado de carroceria lado conductor',8500.00,'Completada'),
    (18,6,'2025-09-12','Ing. Patricia Lora','Accesorios sustraidos: pantalla y volante',36000.00,'Pendiente'),
    (19,6,'2025-10-25','Ing. Patricia Lora','Evaluacion de danos electricos por inundacion',0.00,'Pendiente'),
    (20,8,'2025-12-03','Ing. Roberto Nunez','Incendio parcial, danos en motor y capota',290000.00,'Pendiente');
GO

UPDATE Cliente
SET Direccion = 'Av. Abraham Lincoln 45, Torre Empresarial P-3, Piantini',
    Ciudad = 'Santo Domingo'
WHERE ID_Cliente = 1;
GO

UPDATE Poliza
SET Estado_Poliza = 'Vencida',
    Observaciones = 'Poliza vencida sin renovacion por el cliente. Fecha real de vencimiento: 2026-02-15.'
WHERE Numero_Poliza = 'POL-2025-0003';
GO

UPDATE Poliza
SET ID_Cobertura = 5,
    Prima_Anual = 35000.00,
    Observaciones = 'Mejora de plan: Terceros -> Todo Riesgo solicitado por el cliente.'
WHERE Numero_Poliza = 'POL-2025-0005';
GO

UPDATE Pagos
SET Monto = 5500.00,
    Observaciones = 'Correccion de monto segun recibo fisico No. RC-2025-0010.'
WHERE ID_Pago = 10;
GO

UPDATE Vehiculo
SET Color = 'Gris Metalico',
    Valor_Asegurado = 1050000.00
WHERE ID_Vehiculo = 7;
GO

INSERT INTO Cliente (Cedula, Nombre, Apellido, Fecha_Nacimiento, Telefono, Email, Ciudad, Activo)
VALUES ('999-0000001-1','Cliente','Inactivo Prueba','1980-06-01','000-000-0000','inactivo.prueba@test.com','Santo Domingo',0);
GO

INSERT INTO Solicitud_Cotizacion_Poliza (ID_Cliente, ID_Vehiculo, ID_Agente, ID_Cobertura, Fecha_Solicitud, Estado, Monto_Cotizado)
VALUES (4, 7, 1, 1, '2025-12-01', 'Aprobada', 3000.00);

INSERT INTO Poliza (ID_Solicitud, ID_Cliente, ID_Vehiculo, ID_Agente, ID_Cobertura, Numero_Poliza, Fecha_Emision, Fecha_Vencimiento, Estado_Poliza, Prima_Anual)
VALUES (21, 4, 7, 1, 1, 'POL-TEST-CANCEL', '2025-12-05', '2026-12-05', 'Cancelada', 3000.00);
GO

INSERT INTO Siniestro (ID_Poliza, ID_Vehiculo, Numero_Siniestro, Fecha_Ocurrencia, Tipo_Siniestro, Descripcion, Monto_Estimado_Dano, Estado_Siniestro)
VALUES (1, 1, 'SIN-DUP-0001', '2025-03-10', 'Colision', 'REGISTRO DUPLICADO - Mismo evento que SIN-2025-0001', 85000.00, 'Reportado');
GO

INSERT INTO Pagos (ID_Factura, ID_Cliente, Fecha_Pago, Monto, Metodo_Pago, Referencia, Observaciones)
VALUES (9, 4, '2025-12-20', 999.00, 'Efectivo', 'ERR-0099', 'PAGO ERRONEO - insertar para prueba DELETE');
GO

INSERT INTO Taller (Nombre, Direccion, Responsable)
VALUES ('Taller de Prueba - ELIMINAR', 'Calle Test 00', 'Prueba');
GO

DELETE FROM Cliente
WHERE Activo = 0
  AND Cedula = '999-0000001-1';
GO

DELETE FROM Poliza
WHERE Numero_Poliza = 'POL-TEST-CANCEL';

DELETE FROM Solicitud_Cotizacion_Poliza
WHERE ID_Solicitud = 21;
GO

DELETE FROM Siniestro
WHERE Numero_Siniestro = 'SIN-DUP-0001';
GO

DELETE FROM Pagos
WHERE Referencia = 'ERR-0099';
GO

DELETE FROM Taller
WHERE Nombre = 'Taller de Prueba - ELIMINAR';
GO

PRINT '============================================================';
PRINT 'Script maestro ejecutado correctamente.';
PRINT 'Base de datos recreada: SeguroVehiculos';
PRINT 'Estructura, datos y ejercicios DML cargados.';
PRINT '============================================================';
GO
