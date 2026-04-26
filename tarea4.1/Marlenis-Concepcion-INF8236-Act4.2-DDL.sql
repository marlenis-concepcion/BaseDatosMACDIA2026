-- ============================================================
-- SCRIPT DDL - Sistema de Seguro de Vehiculos
-- Universidad Autonoma de Santo Domingo (UASD)
-- Facultad de Ciencias - Escuela de Informatica
-- Asignatura: Base de Datos I (INF-8236-C2)
-- Actividad: 4.2 - Desarrollo completo en SQL
-- Estudiante: Marlenis Judith Concepcion Cuevas
-- Grupo: 7
-- Fecha: Abril 2026
-- Basado en el script maestro ajustado
-- ------------------------------------------------------------
-- QUE HACE ESTE SCRIPT
-- Este archivo crea la estructura completa de la base de datos.
-- Elimina SeguroVehiculos si ya existe, la vuelve a crear y
-- construye todas las tablas con sus restricciones.
-- Este script no carga datos.
-- Este archivo corresponde a la Parte 1 del proyecto.
--
-- CUANDO SE EJECUTA
-- Este es el primer script que debes correr.
--
-- QUE CREA
-- 1. La base de datos SeguroVehiculos.
-- 2. Las tablas principales del sistema.
-- 3. Las relaciones entre tablas.
-- 4. Las reglas de integridad y los campos de estatus.
--
-- QUE NO HACE
-- No inserta registros.
-- No hace consultas de verificacion.
--
-- RESULTADO ESPERADO
-- La base queda vacia, pero completamente estructurada.
-- ============================================================

-- Se usa master para poder eliminar y recrear la base.
USE master;
GO

-- Si la base ya existe, se fuerza el cierre y se elimina.
IF DB_ID(N'SeguroVehiculos') IS NOT NULL
BEGIN
    ALTER DATABASE SeguroVehiculos SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE SeguroVehiculos;
END
GO

-- Se crea nuevamente la base principal del proyecto.
CREATE DATABASE SeguroVehiculos;
GO

-- A partir de aqui todo se crea dentro de SeguroVehiculos.
USE SeguroVehiculos;
GO

SET NOCOUNT ON;
GO

-- Catalogo de tipos de vehiculo.
CREATE TABLE TipoVehiculo (
    TipoVehiculo_ID              INT             IDENTITY(1,1) NOT NULL,
    TipoVehiculo_Descripcion     VARCHAR(100)    NOT NULL,
    TipoVehiculo_TarifaBase     DECIMAL(12,2)   NOT NULL,
    TipoVehiculo_Estatus         VARCHAR(15)     NOT NULL DEFAULT 'Activo',
    CONSTRAINT PK_TipoVehiculo PRIMARY KEY (TipoVehiculo_ID),
    CONSTRAINT UQ_TipoVehiculo_Descripcion UNIQUE (TipoVehiculo_Descripcion),
    CONSTRAINT CHK_TipoVehiculo_Tarifa CHECK (TipoVehiculo_TarifaBase > 0),
    CONSTRAINT CHK_TipoVehiculo_Estatus CHECK (TipoVehiculo_Estatus IN ('Activo', 'Inactivo'))
);
GO

-- Datos generales de los clientes.
CREATE TABLE Cliente (
    Cliente_ID                    INT             IDENTITY(1,1) NOT NULL,
    Cliente_Cedula                VARCHAR(15)     NOT NULL,
    Cliente_Nombre                VARCHAR(80)     NOT NULL,
    Cliente_Apellido              VARCHAR(80)     NOT NULL,
    Cliente_FechaNacimiento      DATE            NOT NULL,
    Cliente_Telefono              VARCHAR(20)     NOT NULL,
    Cliente_Email                 VARCHAR(120)    NOT NULL,
    Cliente_Direccion             VARCHAR(200)    NOT NULL,
    Cliente_Ciudad                VARCHAR(80)     NOT NULL DEFAULT 'Santo Domingo',
    Cliente_FechaRegistro        DATETIME        NOT NULL DEFAULT GETDATE(),
    Cliente_Estatus               VARCHAR(15)     NOT NULL DEFAULT 'Activo',
    CONSTRAINT PK_Cliente PRIMARY KEY (Cliente_ID),
    CONSTRAINT UQ_Cliente_Cedula UNIQUE (Cliente_Cedula),
    CONSTRAINT UQ_Cliente_Email UNIQUE (Cliente_Email),
    CONSTRAINT CHK_Cliente_Edad CHECK (DATEDIFF(YEAR, Cliente_FechaNacimiento, GETDATE()) >= 18),
    CONSTRAINT CHK_Cliente_Estatus CHECK (Cliente_Estatus IN ('Activo', 'Inactivo'))
);
GO

-- Datos de los agentes de seguros.
CREATE TABLE Agente (
    Agente_ID                     INT             IDENTITY(1,1) NOT NULL,
    Agente_Cedula                 VARCHAR(15)     NOT NULL,
    Agente_Nombre                 VARCHAR(80)     NOT NULL,
    Agente_Apellido               VARCHAR(80)     NOT NULL,
    Agente_Telefono               VARCHAR(20)     NOT NULL,
    Agente_Email                  VARCHAR(120)    NOT NULL,
    Agente_FechaIngreso          DATE            NOT NULL,
    Agente_ComisionPorcentaje    DECIMAL(5,2)    NOT NULL DEFAULT 5.00,
    Agente_Estatus                VARCHAR(15)     NOT NULL DEFAULT 'Activo',
    CONSTRAINT PK_Agente PRIMARY KEY (Agente_ID),
    CONSTRAINT UQ_Agente_Cedula UNIQUE (Agente_Cedula),
    CONSTRAINT UQ_Agente_Email UNIQUE (Agente_Email),
    CONSTRAINT CHK_Agente_Comision CHECK (Agente_ComisionPorcentaje BETWEEN 0 AND 100),
    CONSTRAINT CHK_Agente_Estatus CHECK (Agente_Estatus IN ('Activo', 'Inactivo'))
);
GO

-- Catalogo de coberturas disponibles.
CREATE TABLE Cobertura (
    Cobertura_ID                  INT             IDENTITY(1,1) NOT NULL,
    Cobertura_Nombre              VARCHAR(120)    NOT NULL,
    Cobertura_Descripcion         VARCHAR(300)    NOT NULL,
    Cobertura_PrimaBase          DECIMAL(12,2)   NOT NULL,
    Cobertura_Deducible           DECIMAL(12,2)   NOT NULL DEFAULT 0.00,
    Cobertura_Estatus             VARCHAR(15)     NOT NULL DEFAULT 'Activo',
    CONSTRAINT PK_Cobertura PRIMARY KEY (Cobertura_ID),
    CONSTRAINT UQ_Cobertura_Nombre UNIQUE (Cobertura_Nombre),
    CONSTRAINT CHK_Cobertura_Prima CHECK (Cobertura_PrimaBase > 0),
    CONSTRAINT CHK_Cobertura_Deducible CHECK (Cobertura_Deducible >= 0),
    CONSTRAINT CHK_Cobertura_Estatus CHECK (Cobertura_Estatus IN ('Activo', 'Inactivo'))
);
GO

-- Talleres autorizados por la aseguradora.
CREATE TABLE Taller (
    Taller_ID                     INT             IDENTITY(1,1) NOT NULL,
    Taller_Nombre                 VARCHAR(120)    NOT NULL,
    Taller_Direccion              VARCHAR(200)    NOT NULL,
    Taller_Telefono               VARCHAR(20)     NOT NULL,
    Taller_Email                  VARCHAR(120)    NOT NULL,
    Taller_Responsable            VARCHAR(150)    NOT NULL,
    Taller_Estatus                VARCHAR(15)     NOT NULL DEFAULT 'Activo',
    CONSTRAINT PK_Taller PRIMARY KEY (Taller_ID),
    CONSTRAINT UQ_Taller_Nombre UNIQUE (Taller_Nombre),
    CONSTRAINT UQ_Taller_Email UNIQUE (Taller_Email),
    CONSTRAINT CHK_Taller_Estatus CHECK (Taller_Estatus IN ('Activo', 'Inactivo'))
);
GO

-- Vehiculos registrados por los clientes.
CREATE TABLE Vehiculo (
    Vehiculo_ID                   INT             IDENTITY(1,1) NOT NULL,
    Vehiculo_ClienteID            INT             NOT NULL,
    Vehiculo_TipoVehiculoID       INT             NOT NULL,
    Vehiculo_Placa                VARCHAR(20)     NOT NULL,
    Vehiculo_Marca                VARCHAR(60)     NOT NULL,
    Vehiculo_Modelo               VARCHAR(60)     NOT NULL,
    Vehiculo_Anio                 SMALLINT        NOT NULL,
    Vehiculo_Color                VARCHAR(40)     NOT NULL,
    Vehiculo_ValorAsegurado      DECIMAL(14,2)   NOT NULL,
    Vehiculo_VIN                  VARCHAR(30)     NOT NULL,
    Vehiculo_Estatus              VARCHAR(15)     NOT NULL DEFAULT 'Activo',
    CONSTRAINT PK_Vehiculo PRIMARY KEY (Vehiculo_ID),
    CONSTRAINT UQ_Vehiculo_Placa UNIQUE (Vehiculo_Placa),
    CONSTRAINT UQ_Vehiculo_VIN UNIQUE (Vehiculo_VIN),
    CONSTRAINT FK_Vehiculo_Cliente FOREIGN KEY (Vehiculo_ClienteID) REFERENCES Cliente(Cliente_ID),
    CONSTRAINT FK_Vehiculo_Tipo FOREIGN KEY (Vehiculo_TipoVehiculoID) REFERENCES TipoVehiculo(TipoVehiculo_ID),
    CONSTRAINT CHK_Vehiculo_Anio CHECK (Vehiculo_Anio BETWEEN 1900 AND 2035),
    CONSTRAINT CHK_Vehiculo_Valor CHECK (Vehiculo_ValorAsegurado > 0),
    CONSTRAINT CHK_Vehiculo_Estatus CHECK (Vehiculo_Estatus IN ('Activo', 'Inactivo'))
);
GO

-- Solicitudes previas a la emision de polizas.
CREATE TABLE SolicitudCotizacionPoliza (
    SolicitudCotizacionPoliza_ID                    INT             IDENTITY(1,1) NOT NULL,
    SolicitudCotizacionPoliza_ClienteID             INT             NOT NULL,
    SolicitudCotizacionPoliza_VehiculoID            INT             NOT NULL,
    SolicitudCotizacionPoliza_AgenteID              INT             NOT NULL,
    SolicitudCotizacionPoliza_CoberturaID           INT             NOT NULL,
    SolicitudCotizacionPoliza_FechaSolicitud       DATETIME        NOT NULL,
    SolicitudCotizacionPoliza_Estatus               VARCHAR(20)     NOT NULL DEFAULT 'Pendiente',
    SolicitudCotizacionPoliza_Observaciones         VARCHAR(500)    NOT NULL,
    SolicitudCotizacionPoliza_MontoCotizado        DECIMAL(12,2)   NOT NULL,
    CONSTRAINT PK_SolicitudCotizacionPoliza PRIMARY KEY (SolicitudCotizacionPoliza_ID),
    CONSTRAINT FK_Solicitud_Cliente FOREIGN KEY (SolicitudCotizacionPoliza_ClienteID) REFERENCES Cliente(Cliente_ID),
    CONSTRAINT FK_Solicitud_Vehiculo FOREIGN KEY (SolicitudCotizacionPoliza_VehiculoID) REFERENCES Vehiculo(Vehiculo_ID),
    CONSTRAINT FK_Solicitud_Agente FOREIGN KEY (SolicitudCotizacionPoliza_AgenteID) REFERENCES Agente(Agente_ID),
    CONSTRAINT FK_Solicitud_Cobertura FOREIGN KEY (SolicitudCotizacionPoliza_CoberturaID) REFERENCES Cobertura(Cobertura_ID),
    CONSTRAINT CHK_Solicitud_Estatus CHECK (SolicitudCotizacionPoliza_Estatus IN ('Pendiente', 'Aprobada', 'Rechazada', 'Anulada'))
);
GO

-- Polizas emitidas para los vehiculos asegurados.
CREATE TABLE Poliza (
    Poliza_ID                     INT             IDENTITY(1,1) NOT NULL,
    Poliza_SolicitudCotizacionPolizaID INT       NOT NULL,
    Poliza_ClienteID              INT             NOT NULL,
    Poliza_VehiculoID             INT             NOT NULL,
    Poliza_AgenteID               INT             NOT NULL,
    Poliza_CoberturaID            INT             NOT NULL,
    Poliza_Numero                 VARCHAR(25)     NOT NULL,
    Poliza_FechaEmision          DATE            NOT NULL,
    Poliza_FechaVencimiento      DATE            NOT NULL,
    Poliza_Estatus                VARCHAR(15)     NOT NULL DEFAULT 'Activa',
    Poliza_PrimaAnual            DECIMAL(12,2)   NOT NULL,
    Poliza_Deducible              DECIMAL(12,2)   NOT NULL DEFAULT 0.00,
    Poliza_Observaciones          VARCHAR(500)    NOT NULL,
    CONSTRAINT PK_Poliza PRIMARY KEY (Poliza_ID),
    CONSTRAINT UQ_Poliza_Numero UNIQUE (Poliza_Numero),
    CONSTRAINT FK_Poliza_Solicitud FOREIGN KEY (Poliza_SolicitudCotizacionPolizaID) REFERENCES SolicitudCotizacionPoliza(SolicitudCotizacionPoliza_ID),
    CONSTRAINT FK_Poliza_Cliente FOREIGN KEY (Poliza_ClienteID) REFERENCES Cliente(Cliente_ID),
    CONSTRAINT FK_Poliza_Vehiculo FOREIGN KEY (Poliza_VehiculoID) REFERENCES Vehiculo(Vehiculo_ID),
    CONSTRAINT FK_Poliza_Agente FOREIGN KEY (Poliza_AgenteID) REFERENCES Agente(Agente_ID),
    CONSTRAINT FK_Poliza_Cobertura FOREIGN KEY (Poliza_CoberturaID) REFERENCES Cobertura(Cobertura_ID),
    CONSTRAINT CHK_Poliza_Estatus CHECK (Poliza_Estatus IN ('Activa', 'Vencida', 'Cancelada', 'Inactiva')),
    CONSTRAINT CHK_Poliza_Prima CHECK (Poliza_PrimaAnual > 0),
    CONSTRAINT CHK_Poliza_Fechas CHECK (Poliza_FechaVencimiento > Poliza_FechaEmision)
);
GO

-- Facturas generadas por cada poliza.
CREATE TABLE FacturaPoliza (
    FacturaPoliza_ID             INT             IDENTITY(1,1) NOT NULL,
    FacturaPoliza_PolizaID       INT             NOT NULL,
    FacturaPoliza_Numero         VARCHAR(25)     NOT NULL,
    FacturaPoliza_FechaEmision  DATETIME        NOT NULL,
    FacturaPoliza_MontoTotal    DECIMAL(12,2)   NOT NULL,
    FacturaPoliza_Estatus        VARCHAR(15)     NOT NULL DEFAULT 'Registrada',
    FacturaPoliza_Descripcion    VARCHAR(300)    NOT NULL,
    CONSTRAINT PK_FacturaPoliza PRIMARY KEY (FacturaPoliza_ID),
    CONSTRAINT UQ_FacturaPoliza_Numero UNIQUE (FacturaPoliza_Numero),
    CONSTRAINT FK_FacturaPoliza_Poliza FOREIGN KEY (FacturaPoliza_PolizaID) REFERENCES Poliza(Poliza_ID),
    CONSTRAINT CHK_FacturaPoliza_Estatus CHECK (FacturaPoliza_Estatus IN ('Registrada', 'Entregada', 'Pagada', 'Anulada')),
    CONSTRAINT CHK_FacturaPoliza_Monto CHECK (FacturaPoliza_MontoTotal > 0)
);
GO

-- Pagos realizados sobre las facturas.
CREATE TABLE Pago (
    Pago_ID                       INT             IDENTITY(1,1) NOT NULL,
    Pago_FacturaPolizaID         INT             NOT NULL,
    Pago_ClienteID               INT             NOT NULL,
    Pago_Fecha                    DATETIME        NOT NULL,
    Pago_Monto                    DECIMAL(12,2)   NOT NULL,
    Pago_Metodo                   VARCHAR(20)     NOT NULL,
    Pago_Referencia               VARCHAR(50)     NOT NULL,
    Pago_Estatus                  VARCHAR(15)     NOT NULL DEFAULT 'Aplicado',
    Pago_Observaciones            VARCHAR(300)    NOT NULL,
    CONSTRAINT PK_Pago PRIMARY KEY (Pago_ID),
    CONSTRAINT UQ_Pago_Referencia UNIQUE (Pago_Referencia),
    CONSTRAINT FK_Pago_Factura FOREIGN KEY (Pago_FacturaPolizaID) REFERENCES FacturaPoliza(FacturaPoliza_ID),
    CONSTRAINT FK_Pago_Cliente FOREIGN KEY (Pago_ClienteID) REFERENCES Cliente(Cliente_ID),
    CONSTRAINT CHK_Pago_Monto CHECK (Pago_Monto > 0),
    CONSTRAINT CHK_Pago_Metodo CHECK (Pago_Metodo IN ('Efectivo', 'Transferencia', 'Tarjeta', 'Cheque')),
    CONSTRAINT CHK_Pago_Estatus CHECK (Pago_Estatus IN ('Pendiente', 'Aplicado', 'Anulado'))
);
GO

-- Siniestros reportados por los clientes.
CREATE TABLE Siniestro (
    Siniestro_ID                  INT             IDENTITY(1,1) NOT NULL,
    Siniestro_PolizaID            INT             NOT NULL,
    Siniestro_VehiculoID          INT             NOT NULL,
    Siniestro_Numero              VARCHAR(25)     NOT NULL,
    Siniestro_FechaOcurrencia    DATE            NOT NULL,
    Siniestro_FechaReporte       DATETIME        NOT NULL,
    Siniestro_Tipo                VARCHAR(20)     NOT NULL,
    Siniestro_Descripcion         VARCHAR(500)    NOT NULL,
    Siniestro_LugarOcurrencia    VARCHAR(200)    NOT NULL,
    Siniestro_MontoEstimadoDano DECIMAL(12,2)   NOT NULL DEFAULT 0.00,
    Siniestro_Estatus             VARCHAR(20)     NOT NULL DEFAULT 'Reportado',
    CONSTRAINT PK_Siniestro PRIMARY KEY (Siniestro_ID),
    CONSTRAINT UQ_Siniestro_Numero UNIQUE (Siniestro_Numero),
    CONSTRAINT FK_Siniestro_Poliza FOREIGN KEY (Siniestro_PolizaID) REFERENCES Poliza(Poliza_ID),
    CONSTRAINT FK_Siniestro_Vehiculo FOREIGN KEY (Siniestro_VehiculoID) REFERENCES Vehiculo(Vehiculo_ID),
    CONSTRAINT CHK_Siniestro_Tipo CHECK (Siniestro_Tipo IN ('Colision', 'Robo', 'Incendio', 'Inundacion', 'Vandalismo', 'Otro')),
    CONSTRAINT CHK_Siniestro_Estatus CHECK (Siniestro_Estatus IN ('Reportado', 'En Evaluacion', 'Aprobado', 'Rechazado', 'Cerrado', 'Anulado')),
    CONSTRAINT CHK_Siniestro_Monto CHECK (Siniestro_MontoEstimadoDano >= 0)
);
GO

-- Evaluaciones tecnicas de los siniestros.
CREATE TABLE EvaluacionSiniestro (
    EvaluacionSiniestro_ID                       INT             IDENTITY(1,1) NOT NULL,
    EvaluacionSiniestro_SiniestroID             INT             NOT NULL,
    EvaluacionSiniestro_TallerID                INT             NOT NULL,
    EvaluacionSiniestro_Fecha                    DATE            NOT NULL,
    EvaluacionSiniestro_Perito                   VARCHAR(150)    NOT NULL,
    EvaluacionSiniestro_DescripcionDanos        VARCHAR(600)    NOT NULL,
    EvaluacionSiniestro_MontoAprobado           DECIMAL(12,2)   NOT NULL DEFAULT 0.00,
    EvaluacionSiniestro_Observaciones            VARCHAR(400)    NOT NULL,
    EvaluacionSiniestro_Estatus                  VARCHAR(15)     NOT NULL DEFAULT 'Pendiente',
    CONSTRAINT PK_EvaluacionSiniestro PRIMARY KEY (EvaluacionSiniestro_ID),
    CONSTRAINT FK_EvaluacionSiniestro_Siniestro FOREIGN KEY (EvaluacionSiniestro_SiniestroID) REFERENCES Siniestro(Siniestro_ID),
    CONSTRAINT FK_EvaluacionSiniestro_Taller FOREIGN KEY (EvaluacionSiniestro_TallerID) REFERENCES Taller(Taller_ID),
    CONSTRAINT CHK_EvaluacionSiniestro_Estatus CHECK (EvaluacionSiniestro_Estatus IN ('Pendiente', 'Completada', 'Rechazada', 'Anulada')),
    CONSTRAINT CHK_EvaluacionSiniestro_Monto CHECK (EvaluacionSiniestro_MontoAprobado >= 0)
);
GO

-- Mensaje final de confirmacion del DDL.
PRINT '============================================================';
PRINT 'DDL ejecutado correctamente.';
PRINT 'Base de datos recreada: SeguroVehiculos';
PRINT 'Convencion aplicada: NombreTabla_NombreCampo en CamelCase';
PRINT '============================================================';
GO
