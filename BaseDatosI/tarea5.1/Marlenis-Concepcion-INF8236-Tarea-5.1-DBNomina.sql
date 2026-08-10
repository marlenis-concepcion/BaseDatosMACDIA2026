/*
    ===============================================================
    UNIVERSIDAD AUTONOMA DE SANTO DOMINGO (UASD)
    Maestria en Ciencia de Datos e Inteligencia Artificial
    Asignatura: Base de Datos I - INF-8236-C2
    Unidad 5 - Administracion, Optimizacion y Tendencias en BD
    Tarea 5.1 - Consultas Avanzadas, SP y Trigger en SQL Server
    Estudiante: Marlenis Judith Concepcion Cuevas
    Tutora: Mtra. Rosmery Alberto M.
    Fecha: 19 de abril de 2026
    Motor objetivo: Microsoft SQL Server
    Base de datos: DBNomina
    ===============================================================

    Nota tecnica:
    - Para AFP, ARS e ISR se usan referencias vigentes de R.D.:
      AFP empleado 2.87%, ARS empleado 3.04%, ISR 2026.
    - Topes TSS 2026 usados en los calculos:
      SFS = RD$232,230.00 | SVDS = RD$464,460.00
*/

SET NOCOUNT ON;
GO

IF DB_ID(N'DBNomina') IS NULL
BEGIN
    CREATE DATABASE DBNomina;
END;
GO

USE DBNomina;
GO

/* ===============================================================
   LIMPIEZA CONTROLADA DE OBJETOS
   =============================================================== */

IF OBJECT_ID(N'dbo.TR_TransaccionNomina_Historico', 'TR') IS NOT NULL DROP TRIGGER dbo.TR_TransaccionNomina_Historico;
IF OBJECT_ID(N'dbo.TR_TransaccionNomina_Audit', 'TR') IS NOT NULL DROP TRIGGER dbo.TR_TransaccionNomina_Audit;
IF OBJECT_ID(N'dbo.TR_Empleado_Audit', 'TR') IS NOT NULL DROP TRIGGER dbo.TR_Empleado_Audit;
IF OBJECT_ID(N'dbo.TR_TransaccionNomina_AfterInsert_ConsultarEmpleado', 'TR') IS NOT NULL DROP TRIGGER dbo.TR_TransaccionNomina_AfterInsert_ConsultarEmpleado;
IF OBJECT_ID(N'dbo.TR_TransaccionNomina_AfterInsert_Actualizar', 'TR') IS NOT NULL DROP TRIGGER dbo.TR_TransaccionNomina_AfterInsert_Actualizar;
GO

IF OBJECT_ID(N'dbo.VW_TotalNominaEmpleado', 'V') IS NOT NULL
BEGIN
    IF EXISTS (
        SELECT 1
        FROM sys.indexes
        WHERE object_id = OBJECT_ID(N'dbo.VW_TotalNominaEmpleado')
          AND name = N'IX_VW_TotalNominaEmpleado'
    )
    BEGIN
        DROP INDEX IX_VW_TotalNominaEmpleado ON dbo.VW_TotalNominaEmpleado;
    END;
    DROP VIEW dbo.VW_TotalNominaEmpleado;
END;
GO

IF OBJECT_ID(N'dbo.SP_Actualizar_TransaccionesNomina', 'P') IS NOT NULL DROP PROCEDURE dbo.SP_Actualizar_TransaccionesNomina;
IF OBJECT_ID(N'dbo.SP_Consultar_NominaEmpleado', 'P') IS NOT NULL DROP PROCEDURE dbo.SP_Consultar_NominaEmpleado;
IF OBJECT_ID(N'dbo.SP_Insertar_EmpleadoLog', 'P') IS NOT NULL DROP PROCEDURE dbo.SP_Insertar_EmpleadoLog;
IF OBJECT_ID(N'dbo.SP_Insertar_TransaccionNominaLog', 'P') IS NOT NULL DROP PROCEDURE dbo.SP_Insertar_TransaccionNominaLog;
IF OBJECT_ID(N'dbo.SP_Insertar_TransaccionesNominaHistorico', 'P') IS NOT NULL DROP PROCEDURE dbo.SP_Insertar_TransaccionesNominaHistorico;
GO

IF OBJECT_ID(N'dbo.FN_SalarioAnual', 'FN') IS NOT NULL DROP FUNCTION dbo.FN_SalarioAnual;
GO

IF OBJECT_ID(N'dbo.TransaccionNominaHistorico', 'U') IS NOT NULL DROP TABLE dbo.TransaccionNominaHistorico;
IF OBJECT_ID(N'dbo.TransaccionNominaLog', 'U') IS NOT NULL DROP TABLE dbo.TransaccionNominaLog;
IF OBJECT_ID(N'dbo.EmpleadoLog', 'U') IS NOT NULL DROP TABLE dbo.EmpleadoLog;
IF OBJECT_ID(N'dbo.NominaEmpleadoConsultaCache', 'U') IS NOT NULL DROP TABLE dbo.NominaEmpleadoConsultaCache;
IF OBJECT_ID(N'dbo.TransaccionNomina', 'U') IS NOT NULL DROP TABLE dbo.TransaccionNomina;
IF OBJECT_ID(N'dbo.PeriodoNomina', 'U') IS NOT NULL DROP TABLE dbo.PeriodoNomina;
IF OBJECT_ID(N'dbo.TipoNomina', 'U') IS NOT NULL DROP TABLE dbo.TipoNomina;
IF OBJECT_ID(N'dbo.Empleado', 'U') IS NOT NULL DROP TABLE dbo.Empleado;
IF OBJECT_ID(N'dbo.Departamento', 'U') IS NOT NULL DROP TABLE dbo.Departamento;
IF OBJECT_ID(N'dbo.TipoPeriodoNomina', 'U') IS NOT NULL DROP TABLE dbo.TipoPeriodoNomina;
IF OBJECT_ID(N'dbo.Compania', 'U') IS NOT NULL DROP TABLE dbo.Compania;
GO

/* ===============================================================
   MODELO FISICO DEL SISTEMA DE NOMINA
   =============================================================== */

CREATE TABLE dbo.Compania
(
    Compania_Codigo          CHAR(3)       NOT NULL,
    Compania_Descripcion     VARCHAR(100)  NOT NULL,
    Compania_Estado          CHAR(10)      NOT NULL CONSTRAINT DF_Compania_Estado DEFAULT ('Activo'),
    CONSTRAINT PK_Compania PRIMARY KEY CLUSTERED (Compania_Codigo),
    CONSTRAINT CK_Compania_Estado CHECK (Compania_Estado IN ('Activo', 'Inactivo'))
);
GO

CREATE TABLE dbo.TipoPeriodoNomina
(
    TipoPeriodoNomina_Codigo      CHAR(3)       NOT NULL,
    TipoPeriodoNomina_Descripcion VARCHAR(50)   NOT NULL,
    TipoPeriodoNomina_Estado      CHAR(10)      NOT NULL CONSTRAINT DF_TipoPeriodoNomina_Estado DEFAULT ('Activo'),
    CONSTRAINT PK_TipoPeriodoNomina PRIMARY KEY CLUSTERED (TipoPeriodoNomina_Codigo),
    CONSTRAINT CK_TipoPeriodoNomina_Estado CHECK (TipoPeriodoNomina_Estado IN ('Activo', 'Inactivo'))
);
GO

CREATE TABLE dbo.Departamento
(
    Compania_Codigo              CHAR(3)       NOT NULL,
    Departamento_Codigo          CHAR(3)       NOT NULL,
    Departamento_Descripcion     VARCHAR(100)  NOT NULL,
    Departamento_Estado          CHAR(10)      NOT NULL CONSTRAINT DF_Departamento_Estado DEFAULT ('Activo'),
    CONSTRAINT PK_Departamento PRIMARY KEY CLUSTERED (Compania_Codigo, Departamento_Codigo),
    CONSTRAINT FK_Departamento_Compania FOREIGN KEY (Compania_Codigo)
        REFERENCES dbo.Compania (Compania_Codigo),
    CONSTRAINT CK_Departamento_Estado CHECK (Departamento_Estado IN ('Activo', 'Inactivo'))
);
GO

CREATE TABLE dbo.Empleado
(
    Empleado_ID                  INT IDENTITY(1,1) NOT NULL,
    Compania_Codigo              CHAR(3)           NOT NULL,
    Empleado_Codigo              CHAR(6)           NOT NULL,
    Empleado_Nombre              VARCHAR(30)       NOT NULL,
    Empleado_Apellido            VARCHAR(30)       NOT NULL,
    Empleado_NumeroCedula        CHAR(13)          NOT NULL,
    Empleado_FechaNacimiento     DATETIME          NULL,
    Empleado_FechaIngreso        DATETIME          NULL,
    Empleado_Sexo                CHAR(1)           NULL,
    Empleado_EstadoCivil         CHAR(1)           NULL,
    Empleado_Telefono            CHAR(13)          NULL,
    Empleado_Direccion           VARCHAR(100)      NULL,
    Departamento_Codigo          CHAR(3)           NULL,
    Empleado_Cargo               VARCHAR(50)       NULL,
    Empleado_SueldoBase          DECIMAL(12,2)     NULL,
    Empleado_Estado              CHAR(10)          NOT NULL CONSTRAINT DF_Empleado_Estado DEFAULT ('Activo'),
    CONSTRAINT PK_Empleado PRIMARY KEY CLUSTERED (Empleado_ID),
    CONSTRAINT UQ_Empleado_CompaniaCodigo UNIQUE (Compania_Codigo, Empleado_Codigo),
    CONSTRAINT UQ_Empleado_Cedula UNIQUE (Empleado_NumeroCedula),
    CONSTRAINT FK_Empleado_Compania FOREIGN KEY (Compania_Codigo)
        REFERENCES dbo.Compania (Compania_Codigo),
    CONSTRAINT FK_Empleado_Departamento FOREIGN KEY (Compania_Codigo, Departamento_Codigo)
        REFERENCES dbo.Departamento (Compania_Codigo, Departamento_Codigo),
    CONSTRAINT CK_Empleado_Estado CHECK (Empleado_Estado IN ('Activo', 'Inactivo')),
    CONSTRAINT CK_Empleado_Sexo CHECK (Empleado_Sexo IN ('M', 'F')),
    CONSTRAINT CK_Empleado_EstadoCivil CHECK (Empleado_EstadoCivil IN ('S', 'C', 'U', 'D', 'V')),
    CONSTRAINT CK_Empleado_SueldoBase CHECK (Empleado_SueldoBase IS NULL OR Empleado_SueldoBase >= 0)
);
GO

CREATE TABLE dbo.TipoNomina
(
    Compania_Codigo              CHAR(3)       NOT NULL,
    TipoNomina_Codigo            CHAR(3)       NOT NULL,
    TipoNomina_Descripcion       VARCHAR(100)  NOT NULL,
    TipoPeriodoNomina_Codigo     CHAR(3)       NOT NULL,
    TipoNomina_Estado            CHAR(10)      NOT NULL CONSTRAINT DF_TipoNomina_Estado DEFAULT ('Activo'),
    CONSTRAINT PK_TipoNomina PRIMARY KEY CLUSTERED (Compania_Codigo, TipoNomina_Codigo),
    CONSTRAINT FK_TipoNomina_Compania FOREIGN KEY (Compania_Codigo)
        REFERENCES dbo.Compania (Compania_Codigo),
    CONSTRAINT FK_TipoNomina_TipoPeriodo FOREIGN KEY (TipoPeriodoNomina_Codigo)
        REFERENCES dbo.TipoPeriodoNomina (TipoPeriodoNomina_Codigo),
    CONSTRAINT CK_TipoNomina_Estado CHECK (TipoNomina_Estado IN ('Activo', 'Inactivo'))
);
GO

CREATE TABLE dbo.PeriodoNomina
(
    Compania_Codigo              CHAR(3)       NOT NULL,
    PeriodoNomina_Codigo         CHAR(6)       NOT NULL,
    PeriodoNomina_Anio           SMALLINT      NOT NULL,
    PeriodoNomina_Descripcion    VARCHAR(50)   NOT NULL,
    PeriodoNomina_FechaInicial   DATETIME      NOT NULL,
    PeriodoNomina_FechaFinal     DATETIME      NOT NULL,
    PeriodoNomina_Estado         CHAR(10)      NOT NULL CONSTRAINT DF_PeriodoNomina_Estado DEFAULT ('Abierto'),
    CONSTRAINT PK_PeriodoNomina PRIMARY KEY CLUSTERED (Compania_Codigo, PeriodoNomina_Codigo),
    CONSTRAINT FK_PeriodoNomina_Compania FOREIGN KEY (Compania_Codigo)
        REFERENCES dbo.Compania (Compania_Codigo),
    CONSTRAINT CK_PeriodoNomina_Estado CHECK (PeriodoNomina_Estado IN ('Abierto', 'Cerrado', 'Pagado')),
    CONSTRAINT CK_PeriodoNomina_Fechas CHECK (PeriodoNomina_FechaFinal >= PeriodoNomina_FechaInicial)
);
GO

CREATE TABLE dbo.TransaccionNomina
(
    TransaccionNomina_ID             INT IDENTITY(1,1) NOT NULL,
    Compania_Codigo                  CHAR(3)           NOT NULL,
    TransaccionNomina_Numero         INT               NOT NULL,
    TransaccionNomina_Fecha          DATETIME          NOT NULL,
    Empleado_ID                      INT               NOT NULL,
    TipoNomina_Codigo                CHAR(3)           NULL,
    PeriodoNomina_Codigo             CHAR(6)           NOT NULL,
    TransaccionNomina_Comentario     VARCHAR(100)      NOT NULL,
    TransaccionNomina_SueldoBase     DECIMAL(12,2)     NULL,
    TransaccionNomina_Monto          DECIMAL(12,2)     NULL,
    TransaccionNomina_MontoAFP       DECIMAL(12,2)     NULL,
    TransaccionNomina_MontoARS       DECIMAL(12,2)     NULL,
    TransaccionNomina_MontoISR       DECIMAL(12,2)     NULL,
    TransaccionNomina_SueldonNeto    DECIMAL(12,2)     NULL,
    TransaccionNomina_SueldoNeto     AS (TransaccionNomina_SueldonNeto),
    TransaccionNomina_Estado         CHAR(10)          NOT NULL CONSTRAINT DF_TransaccionNomina_Estado DEFAULT ('Aplicada'),
    CONSTRAINT PK_TransaccionNomina PRIMARY KEY CLUSTERED (TransaccionNomina_ID),
    CONSTRAINT UQ_TransaccionNomina_CompaniaNumero UNIQUE (Compania_Codigo, TransaccionNomina_Numero),
    CONSTRAINT FK_TransaccionNomina_Compania FOREIGN KEY (Compania_Codigo)
        REFERENCES dbo.Compania (Compania_Codigo),
    CONSTRAINT FK_TransaccionNomina_Empleado FOREIGN KEY (Empleado_ID)
        REFERENCES dbo.Empleado (Empleado_ID),
    CONSTRAINT FK_TransaccionNomina_TipoNomina FOREIGN KEY (Compania_Codigo, TipoNomina_Codigo)
        REFERENCES dbo.TipoNomina (Compania_Codigo, TipoNomina_Codigo),
    CONSTRAINT FK_TransaccionNomina_PeriodoNomina FOREIGN KEY (Compania_Codigo, PeriodoNomina_Codigo)
        REFERENCES dbo.PeriodoNomina (Compania_Codigo, PeriodoNomina_Codigo),
    CONSTRAINT CK_TransaccionNomina_Estado CHECK (TransaccionNomina_Estado IN ('Aplicada', 'Pendiente', 'Anulada')),
    CONSTRAINT CK_TransaccionNomina_Montos CHECK (
        (TransaccionNomina_SueldoBase IS NULL OR TransaccionNomina_SueldoBase >= 0) AND
        (TransaccionNomina_Monto IS NULL OR TransaccionNomina_Monto >= 0) AND
        (TransaccionNomina_MontoAFP IS NULL OR TransaccionNomina_MontoAFP >= 0) AND
        (TransaccionNomina_MontoARS IS NULL OR TransaccionNomina_MontoARS >= 0) AND
        (TransaccionNomina_MontoISR IS NULL OR TransaccionNomina_MontoISR >= 0) AND
        (TransaccionNomina_SueldonNeto IS NULL OR TransaccionNomina_SueldonNeto >= 0)
    )
);
GO

/* ===============================================================
   TABLAS DE SOPORTE PARA AUDITORIA, CACHE E HISTORICO
   =============================================================== */

CREATE TABLE dbo.NominaEmpleadoConsultaCache
(
    Cache_ID                         INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Empleado_ID                      INT               NOT NULL,
    TransaccionNomina_ID             INT               NOT NULL,
    TransaccionNomina_Numero         INT               NOT NULL,
    Compania_Codigo                  CHAR(3)           NOT NULL,
    Empleado_Codigo                  CHAR(6)           NOT NULL,
    Empleado_NombreCompleto          VARCHAR(80)       NOT NULL,
    PeriodoNomina_Codigo             CHAR(6)           NOT NULL,
    TipoNomina_Codigo                CHAR(3)           NULL,
    TransaccionNomina_Fecha          DATETIME          NOT NULL,
    MontoBruto                       DECIMAL(12,2)     NULL,
    MontoNeto                        DECIMAL(12,2)     NULL,
    Estado                           CHAR(10)          NOT NULL,
    FechaGeneracionCache             DATETIME          NOT NULL CONSTRAINT DF_Cache_Fecha DEFAULT (GETDATE())
);
GO

CREATE TABLE dbo.EmpleadoLog
(
    EmpleadoLog_ID                   INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Empleado_ID                      INT               NULL,
    Compania_Codigo                  CHAR(3)           NULL,
    Empleado_Codigo                  CHAR(6)           NULL,
    NombreCompleto                   VARCHAR(80)       NULL,
    Empleado_Estado                  CHAR(10)          NULL,
    Accion                           VARCHAR(10)       NOT NULL,
    UsuarioBD                        SYSNAME           NOT NULL CONSTRAINT DF_EmpleadoLog_Usuario DEFAULT (SYSTEM_USER),
    FechaEvento                      DATETIME          NOT NULL CONSTRAINT DF_EmpleadoLog_Fecha DEFAULT (GETDATE())
);
GO

CREATE TABLE dbo.TransaccionNominaLog
(
    TransaccionNominaLog_ID          INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    TransaccionNomina_ID             INT               NULL,
    Compania_Codigo                  CHAR(3)           NULL,
    TransaccionNomina_Numero         INT               NULL,
    Empleado_ID                      INT               NULL,
    MontoBruto                       DECIMAL(12,2)     NULL,
    MontoNeto                        DECIMAL(12,2)     NULL,
    Estado                           CHAR(10)          NULL,
    Accion                           VARCHAR(10)       NOT NULL,
    UsuarioBD                        SYSNAME           NOT NULL CONSTRAINT DF_TransaccionLog_Usuario DEFAULT (SYSTEM_USER),
    FechaEvento                      DATETIME          NOT NULL CONSTRAINT DF_TransaccionLog_Fecha DEFAULT (GETDATE())
);
GO

CREATE TABLE dbo.TransaccionNominaHistorico
(
    Historico_ID                     INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    TransaccionNomina_ID             INT               NOT NULL,
    Compania_Codigo                  CHAR(3)           NOT NULL,
    TransaccionNomina_Numero         INT               NOT NULL,
    Empleado_ID                      INT               NOT NULL,
    TipoNomina_Codigo                CHAR(3)           NULL,
    PeriodoNomina_Codigo             CHAR(6)           NOT NULL,
    TransaccionNomina_Fecha          DATETIME          NOT NULL,
    Comentario                       VARCHAR(100)      NOT NULL,
    SueldoBase                       DECIMAL(12,2)     NULL,
    MontoBruto                       DECIMAL(12,2)     NULL,
    MontoAFP                         DECIMAL(12,2)     NULL,
    MontoARS                         DECIMAL(12,2)     NULL,
    MontoISR                         DECIMAL(12,2)     NULL,
    MontoNeto                        DECIMAL(12,2)     NULL,
    Estado                           CHAR(10)          NOT NULL,
    Operacion                        VARCHAR(10)       NOT NULL,
    UsuarioBD                        SYSNAME           NOT NULL CONSTRAINT DF_Historico_Usuario DEFAULT (SYSTEM_USER),
    FechaArchivado                   DATETIME          NOT NULL CONSTRAINT DF_Historico_Fecha DEFAULT (GETDATE())
);
GO

/* ===============================================================
   DATOS MAESTROS
   =============================================================== */

INSERT INTO dbo.Compania (Compania_Codigo, Compania_Descripcion, Compania_Estado)
VALUES ('UAS', 'Universidad Autonoma de Santo Domingo', 'Activo');
GO

INSERT INTO dbo.TipoPeriodoNomina (TipoPeriodoNomina_Codigo, TipoPeriodoNomina_Descripcion)
VALUES
('MEN', 'Mensual'),
('QUI', 'Quincenal'),
('DIA', 'Diaria');
GO

INSERT INTO dbo.Departamento (Compania_Codigo, Departamento_Codigo, Departamento_Descripcion)
VALUES
('UAS', 'ADM', 'Administracion'),
('UAS', 'FIN', 'Finanzas'),
('UAS', 'DOC', 'Docencia'),
('UAS', 'TIC', 'Tecnologia');
GO

INSERT INTO dbo.TipoNomina (Compania_Codigo, TipoNomina_Codigo, TipoNomina_Descripcion, TipoPeriodoNomina_Codigo)
VALUES
('UAS', 'FIX', 'Nomina de empleados fijos', 'MEN'),
('UAS', 'DOC', 'Nomina de docentes', 'MEN'),
('UAS', 'EXT', 'Nomina extraordinaria', 'MEN');
GO

INSERT INTO dbo.PeriodoNomina
(
    Compania_Codigo,
    PeriodoNomina_Codigo,
    PeriodoNomina_Anio,
    PeriodoNomina_Descripcion,
    PeriodoNomina_FechaInicial,
    PeriodoNomina_FechaFinal,
    PeriodoNomina_Estado
)
VALUES
('UAS', '202601', 2026, 'Nomina enero 2026', '2026-01-01', '2026-01-31', 'Pagado'),
('UAS', '202602', 2026, 'Nomina febrero 2026', '2026-02-01', '2026-02-28', 'Pagado'),
('UAS', '202603', 2026, 'Nomina marzo 2026', '2026-03-01', '2026-03-31', 'Abierto');
GO

INSERT INTO dbo.Empleado
(
    Compania_Codigo,
    Empleado_Codigo,
    Empleado_Nombre,
    Empleado_Apellido,
    Empleado_NumeroCedula,
    Empleado_FechaNacimiento,
    Empleado_FechaIngreso,
    Empleado_Sexo,
    Empleado_EstadoCivil,
    Empleado_Telefono,
    Empleado_Direccion,
    Departamento_Codigo,
    Empleado_Cargo,
    Empleado_SueldoBase,
    Empleado_Estado
)
VALUES
('UAS', 'E00001', 'Marlenis Judith', 'Concepcion Cuevas', '001-000001-1', '1990-05-10', '2024-02-01', 'F', 'C', '809-555-1001', 'Santo Domingo', 'ADM', 'Analista de datos', 42000.00, 'Activo'),
('UAS', 'E00002', 'Roberto Byas', 'De la Cruz',         '001-000002-2', '1988-08-14', '2023-07-15', 'M', 'C', '809-555-1002', 'Santo Domingo Este', 'FIN', 'Director financiero', 55000.00, 'Activo'),
('UAS', 'E00003', 'Victor',        'Perez Padilla',      '001-000003-3', '1985-11-25', '2022-01-10', 'M', 'C', '809-555-1003', 'Santo Domingo Norte', 'DOC', 'Docente investigador', 78000.00, 'Activo'),
('UAS', 'E00004', 'Manicaotex',    'Mueses',             '001-000004-4', '1987-02-20', '2021-09-01', 'M', 'S', '809-555-1004', 'Santiago', 'TIC', 'Arquitecto de datos', 120000.00, 'Activo'),
('UAS', 'E00005', 'Rosmery',       'Alberto Martinez',   '001-000005-5', '1982-12-05', '2020-03-05', 'F', 'C', '809-555-1005', 'Santo Domingo', 'ADM', 'Coordinadora academica', 250000.00, 'Activo'),
('UAS', 'E00006', 'Ana',           'Martinez',           '001-000006-6', '1994-10-30', '2025-04-21', 'F', 'S', '809-555-1006', 'Bani', 'FIN', 'Auxiliar contable', 32000.00, 'Activo');
GO

/* ===============================================================
   FUNCION
   =============================================================== */

CREATE FUNCTION dbo.FN_SalarioAnual
(
    @SueldoMensual DECIMAL(12,2)
)
RETURNS DECIMAL(14,2)
AS
BEGIN
    RETURN ROUND(ISNULL(@SueldoMensual, 0.00) * 12.00, 2);
END;
GO

/* ===============================================================
   STORED PROCEDURES
   =============================================================== */

CREATE PROCEDURE dbo.SP_Actualizar_TransaccionesNomina
    @TransaccionNomina_ID INT,
    @Compania_Codigo CHAR(3),
    @Empleado_Codigo CHAR(6),
    @SueldoBruto DECIMAL(12,2) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
        @Empleado_ID INT,
        @SueldoBase DECIMAL(12,2),
        @MontoBruto DECIMAL(12,2),
        @MontoAFP DECIMAL(12,2),
        @MontoARS DECIMAL(12,2),
        @MontoISR DECIMAL(12,2),
        @MontoNeto DECIMAL(12,2),
        @IngresoAnualGravado DECIMAL(14,2);

    SELECT
        @Empleado_ID = E.Empleado_ID,
        @SueldoBase = E.Empleado_SueldoBase
    FROM dbo.Empleado AS E
    WHERE E.Compania_Codigo = @Compania_Codigo
      AND E.Empleado_Codigo = @Empleado_Codigo;

    IF @Empleado_ID IS NULL
    BEGIN
        RAISERROR('No existe el empleado para la compania y codigo suministrados.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.TransaccionNomina AS T
        WHERE T.TransaccionNomina_ID = @TransaccionNomina_ID
          AND T.Compania_Codigo = @Compania_Codigo
    )
    BEGIN
        RAISERROR('No existe la transaccion de nomina indicada.', 16, 1);
        RETURN;
    END;

    SET @MontoBruto = ISNULL(@SueldoBruto, @SueldoBase);

    SET @MontoAFP = ROUND(
        (CASE WHEN @MontoBruto > 464460.00 THEN 464460.00 ELSE @MontoBruto END) * 0.0287,
        2
    );

    SET @MontoARS = ROUND(
        (CASE WHEN @MontoBruto > 232230.00 THEN 232230.00 ELSE @MontoBruto END) * 0.0304,
        2
    );

    SET @IngresoAnualGravado = ROUND((@MontoBruto - @MontoAFP - @MontoARS) * 12.00, 2);

    IF @IngresoAnualGravado <= 416220.00
        SET @MontoISR = 0.00;
    ELSE IF @IngresoAnualGravado <= 624329.00
        SET @MontoISR = ROUND(((@IngresoAnualGravado - 416220.01) * 0.15) / 12.00, 2);
    ELSE IF @IngresoAnualGravado <= 867123.00
        SET @MontoISR = ROUND((31216.00 + ((@IngresoAnualGravado - 624329.01) * 0.20)) / 12.00, 2);
    ELSE
        SET @MontoISR = ROUND((79776.00 + ((@IngresoAnualGravado - 867123.01) * 0.25)) / 12.00, 2);

    SET @MontoNeto = ROUND(@MontoBruto - @MontoAFP - @MontoARS - @MontoISR, 2);

    UPDATE dbo.TransaccionNomina
    SET Empleado_ID = @Empleado_ID,
        TransaccionNomina_SueldoBase = @SueldoBase,
        TransaccionNomina_Monto = @MontoBruto,
        TransaccionNomina_MontoAFP = @MontoAFP,
        TransaccionNomina_MontoARS = @MontoARS,
        TransaccionNomina_MontoISR = @MontoISR,
        TransaccionNomina_SueldonNeto = @MontoNeto,
        TransaccionNomina_Estado = 'Aplicada'
    WHERE TransaccionNomina_ID = @TransaccionNomina_ID;
END;
GO

CREATE PROCEDURE dbo.SP_Consultar_NominaEmpleado
    @Empleado_ID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        E.Empleado_ID,
        T.TransaccionNomina_ID,
        T.TransaccionNomina_Numero,
        T.Compania_Codigo,
        E.Empleado_Codigo,
        E.Empleado_Nombre + ' ' + E.Empleado_Apellido AS Empleado_NombreCompleto,
        T.PeriodoNomina_Codigo,
        T.TipoNomina_Codigo,
        T.TransaccionNomina_Fecha,
        T.TransaccionNomina_Monto AS MontoBruto,
        T.TransaccionNomina_SueldonNeto AS MontoNeto,
        T.TransaccionNomina_Estado AS Estado
    FROM dbo.TransaccionNomina AS T
    INNER JOIN dbo.Empleado AS E
        ON E.Empleado_ID = T.Empleado_ID
    WHERE T.Empleado_ID = @Empleado_ID
    ORDER BY T.TransaccionNomina_Fecha, T.TransaccionNomina_Numero;
END;
GO

CREATE PROCEDURE dbo.SP_Insertar_EmpleadoLog
    @Empleado_ID INT = NULL,
    @Compania_Codigo CHAR(3) = NULL,
    @Empleado_Codigo CHAR(6) = NULL,
    @NombreCompleto VARCHAR(80) = NULL,
    @Empleado_Estado CHAR(10) = NULL,
    @Accion VARCHAR(10),
    @UsuarioBD SYSNAME = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.EmpleadoLog
    (
        Empleado_ID,
        Compania_Codigo,
        Empleado_Codigo,
        NombreCompleto,
        Empleado_Estado,
        Accion,
        UsuarioBD
    )
    VALUES
    (
        @Empleado_ID,
        @Compania_Codigo,
        @Empleado_Codigo,
        @NombreCompleto,
        @Empleado_Estado,
        @Accion,
        ISNULL(@UsuarioBD, SYSTEM_USER)
    );
END;
GO

CREATE PROCEDURE dbo.SP_Insertar_TransaccionNominaLog
    @TransaccionNomina_ID INT = NULL,
    @Compania_Codigo CHAR(3) = NULL,
    @TransaccionNomina_Numero INT = NULL,
    @Empleado_ID INT = NULL,
    @MontoBruto DECIMAL(12,2) = NULL,
    @MontoNeto DECIMAL(12,2) = NULL,
    @Estado CHAR(10) = NULL,
    @Accion VARCHAR(10),
    @UsuarioBD SYSNAME = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.TransaccionNominaLog
    (
        TransaccionNomina_ID,
        Compania_Codigo,
        TransaccionNomina_Numero,
        Empleado_ID,
        MontoBruto,
        MontoNeto,
        Estado,
        Accion,
        UsuarioBD
    )
    VALUES
    (
        @TransaccionNomina_ID,
        @Compania_Codigo,
        @TransaccionNomina_Numero,
        @Empleado_ID,
        @MontoBruto,
        @MontoNeto,
        @Estado,
        @Accion,
        ISNULL(@UsuarioBD, SYSTEM_USER)
    );
END;
GO

CREATE PROCEDURE dbo.SP_Insertar_TransaccionesNominaHistorico
    @TransaccionNomina_ID INT,
    @Compania_Codigo CHAR(3),
    @TransaccionNomina_Numero INT,
    @Empleado_ID INT,
    @TipoNomina_Codigo CHAR(3) = NULL,
    @PeriodoNomina_Codigo CHAR(6),
    @TransaccionNomina_Fecha DATETIME,
    @Comentario VARCHAR(100),
    @SueldoBase DECIMAL(12,2) = NULL,
    @MontoBruto DECIMAL(12,2) = NULL,
    @MontoAFP DECIMAL(12,2) = NULL,
    @MontoARS DECIMAL(12,2) = NULL,
    @MontoISR DECIMAL(12,2) = NULL,
    @MontoNeto DECIMAL(12,2) = NULL,
    @Estado CHAR(10),
    @Operacion VARCHAR(10),
    @UsuarioBD SYSNAME = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.TransaccionNominaHistorico
    (
        TransaccionNomina_ID,
        Compania_Codigo,
        TransaccionNomina_Numero,
        Empleado_ID,
        TipoNomina_Codigo,
        PeriodoNomina_Codigo,
        TransaccionNomina_Fecha,
        Comentario,
        SueldoBase,
        MontoBruto,
        MontoAFP,
        MontoARS,
        MontoISR,
        MontoNeto,
        Estado,
        Operacion,
        UsuarioBD
    )
    VALUES
    (
        @TransaccionNomina_ID,
        @Compania_Codigo,
        @TransaccionNomina_Numero,
        @Empleado_ID,
        @TipoNomina_Codigo,
        @PeriodoNomina_Codigo,
        @TransaccionNomina_Fecha,
        @Comentario,
        @SueldoBase,
        @MontoBruto,
        @MontoAFP,
        @MontoARS,
        @MontoISR,
        @MontoNeto,
        @Estado,
        @Operacion,
        ISNULL(@UsuarioBD, SYSTEM_USER)
    );
END;
GO

/* ===============================================================
   TRIGGERS
   =============================================================== */

CREATE TRIGGER dbo.TR_TransaccionNomina_AfterInsert_Actualizar
ON dbo.TransaccionNomina
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
        @TransaccionNomina_ID INT,
        @Compania_Codigo CHAR(3),
        @Empleado_Codigo CHAR(6),
        @MontoBruto DECIMAL(12,2);

    DECLARE cur_transaccion CURSOR LOCAL FAST_FORWARD FOR
        SELECT
            I.TransaccionNomina_ID,
            I.Compania_Codigo,
            E.Empleado_Codigo,
            I.TransaccionNomina_Monto
        FROM inserted AS I
        INNER JOIN dbo.Empleado AS E
            ON E.Empleado_ID = I.Empleado_ID;

    OPEN cur_transaccion;
    FETCH NEXT FROM cur_transaccion INTO @TransaccionNomina_ID, @Compania_Codigo, @Empleado_Codigo, @MontoBruto;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC dbo.SP_Actualizar_TransaccionesNomina
            @TransaccionNomina_ID = @TransaccionNomina_ID,
            @Compania_Codigo = @Compania_Codigo,
            @Empleado_Codigo = @Empleado_Codigo,
            @SueldoBruto = @MontoBruto;

        FETCH NEXT FROM cur_transaccion INTO @TransaccionNomina_ID, @Compania_Codigo, @Empleado_Codigo, @MontoBruto;
    END;

    CLOSE cur_transaccion;
    DEALLOCATE cur_transaccion;
END;
GO

CREATE TRIGGER dbo.TR_TransaccionNomina_AfterInsert_ConsultarEmpleado
ON dbo.TransaccionNomina
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Empleado_ID INT;

    DECLARE cur_empleado CURSOR LOCAL FAST_FORWARD FOR
        SELECT DISTINCT Empleado_ID
        FROM inserted;

    OPEN cur_empleado;
    FETCH NEXT FROM cur_empleado INTO @Empleado_ID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        DELETE FROM dbo.NominaEmpleadoConsultaCache
        WHERE Empleado_ID = @Empleado_ID;

        INSERT INTO dbo.NominaEmpleadoConsultaCache
        (
            Empleado_ID,
            TransaccionNomina_ID,
            TransaccionNomina_Numero,
            Compania_Codigo,
            Empleado_Codigo,
            Empleado_NombreCompleto,
            PeriodoNomina_Codigo,
            TipoNomina_Codigo,
            TransaccionNomina_Fecha,
            MontoBruto,
            MontoNeto,
            Estado
        )
        EXEC dbo.SP_Consultar_NominaEmpleado @Empleado_ID = @Empleado_ID;

        FETCH NEXT FROM cur_empleado INTO @Empleado_ID;
    END;

    CLOSE cur_empleado;
    DEALLOCATE cur_empleado;
END;
GO

CREATE TRIGGER dbo.TR_Empleado_Audit
ON dbo.Empleado
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
        @Empleado_ID INT,
        @Compania_Codigo CHAR(3),
        @Empleado_Codigo CHAR(6),
        @NombreCompleto VARCHAR(80),
        @Empleado_Estado CHAR(10),
        @Accion VARCHAR(10);

    DECLARE cur_empleado_log CURSOR LOCAL FAST_FORWARD FOR
        SELECT
            ISNULL(I.Empleado_ID, D.Empleado_ID) AS Empleado_ID,
            ISNULL(I.Compania_Codigo, D.Compania_Codigo) AS Compania_Codigo,
            ISNULL(I.Empleado_Codigo, D.Empleado_Codigo) AS Empleado_Codigo,
            ISNULL(I.Empleado_Nombre, D.Empleado_Nombre) + ' ' + ISNULL(I.Empleado_Apellido, D.Empleado_Apellido) AS NombreCompleto,
            ISNULL(I.Empleado_Estado, D.Empleado_Estado) AS Empleado_Estado,
            CASE
                WHEN I.Empleado_ID IS NOT NULL AND D.Empleado_ID IS NOT NULL THEN 'UPDATE'
                WHEN I.Empleado_ID IS NOT NULL AND D.Empleado_ID IS NULL THEN 'INSERT'
                ELSE 'DELETE'
            END AS Accion
        FROM inserted AS I
        FULL OUTER JOIN deleted AS D
            ON I.Empleado_ID = D.Empleado_ID;

    OPEN cur_empleado_log;
    FETCH NEXT FROM cur_empleado_log INTO @Empleado_ID, @Compania_Codigo, @Empleado_Codigo, @NombreCompleto, @Empleado_Estado, @Accion;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC dbo.SP_Insertar_EmpleadoLog
            @Empleado_ID = @Empleado_ID,
            @Compania_Codigo = @Compania_Codigo,
            @Empleado_Codigo = @Empleado_Codigo,
            @NombreCompleto = @NombreCompleto,
            @Empleado_Estado = @Empleado_Estado,
            @Accion = @Accion,
            @UsuarioBD = SYSTEM_USER;

        FETCH NEXT FROM cur_empleado_log INTO @Empleado_ID, @Compania_Codigo, @Empleado_Codigo, @NombreCompleto, @Empleado_Estado, @Accion;
    END;

    CLOSE cur_empleado_log;
    DEALLOCATE cur_empleado_log;
END;
GO

CREATE TRIGGER dbo.TR_TransaccionNomina_Audit
ON dbo.TransaccionNomina
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
        @TransaccionNomina_ID INT,
        @Compania_Codigo CHAR(3),
        @TransaccionNomina_Numero INT,
        @Empleado_ID INT,
        @MontoBruto DECIMAL(12,2),
        @MontoNeto DECIMAL(12,2),
        @Estado CHAR(10),
        @Accion VARCHAR(10);

    DECLARE cur_trans_log CURSOR LOCAL FAST_FORWARD FOR
        SELECT
            ISNULL(I.TransaccionNomina_ID, D.TransaccionNomina_ID) AS TransaccionNomina_ID,
            ISNULL(I.Compania_Codigo, D.Compania_Codigo) AS Compania_Codigo,
            ISNULL(I.TransaccionNomina_Numero, D.TransaccionNomina_Numero) AS TransaccionNomina_Numero,
            ISNULL(I.Empleado_ID, D.Empleado_ID) AS Empleado_ID,
            ISNULL(I.TransaccionNomina_Monto, D.TransaccionNomina_Monto) AS MontoBruto,
            ISNULL(I.TransaccionNomina_SueldonNeto, D.TransaccionNomina_SueldonNeto) AS MontoNeto,
            ISNULL(I.TransaccionNomina_Estado, D.TransaccionNomina_Estado) AS Estado,
            CASE
                WHEN I.TransaccionNomina_ID IS NOT NULL AND D.TransaccionNomina_ID IS NOT NULL THEN 'UPDATE'
                WHEN I.TransaccionNomina_ID IS NOT NULL AND D.TransaccionNomina_ID IS NULL THEN 'INSERT'
                ELSE 'DELETE'
            END AS Accion
        FROM inserted AS I
        FULL OUTER JOIN deleted AS D
            ON I.TransaccionNomina_ID = D.TransaccionNomina_ID;

    OPEN cur_trans_log;
    FETCH NEXT FROM cur_trans_log INTO @TransaccionNomina_ID, @Compania_Codigo, @TransaccionNomina_Numero, @Empleado_ID, @MontoBruto, @MontoNeto, @Estado, @Accion;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC dbo.SP_Insertar_TransaccionNominaLog
            @TransaccionNomina_ID = @TransaccionNomina_ID,
            @Compania_Codigo = @Compania_Codigo,
            @TransaccionNomina_Numero = @TransaccionNomina_Numero,
            @Empleado_ID = @Empleado_ID,
            @MontoBruto = @MontoBruto,
            @MontoNeto = @MontoNeto,
            @Estado = @Estado,
            @Accion = @Accion,
            @UsuarioBD = SYSTEM_USER;

        FETCH NEXT FROM cur_trans_log INTO @TransaccionNomina_ID, @Compania_Codigo, @TransaccionNomina_Numero, @Empleado_ID, @MontoBruto, @MontoNeto, @Estado, @Accion;
    END;

    CLOSE cur_trans_log;
    DEALLOCATE cur_trans_log;
END;
GO

CREATE TRIGGER dbo.TR_TransaccionNomina_Historico
ON dbo.TransaccionNomina
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
        @TransaccionNomina_ID INT,
        @Compania_Codigo CHAR(3),
        @TransaccionNomina_Numero INT,
        @Empleado_ID INT,
        @TipoNomina_Codigo CHAR(3),
        @PeriodoNomina_Codigo CHAR(6),
        @TransaccionNomina_Fecha DATETIME,
        @Comentario VARCHAR(100),
        @SueldoBase DECIMAL(12,2),
        @MontoBruto DECIMAL(12,2),
        @MontoAFP DECIMAL(12,2),
        @MontoARS DECIMAL(12,2),
        @MontoISR DECIMAL(12,2),
        @MontoNeto DECIMAL(12,2),
        @Estado CHAR(10);

    DECLARE cur_hist CURSOR LOCAL FAST_FORWARD FOR
        SELECT
            D.TransaccionNomina_ID,
            D.Compania_Codigo,
            D.TransaccionNomina_Numero,
            D.Empleado_ID,
            D.TipoNomina_Codigo,
            D.PeriodoNomina_Codigo,
            D.TransaccionNomina_Fecha,
            D.TransaccionNomina_Comentario,
            D.TransaccionNomina_SueldoBase,
            D.TransaccionNomina_Monto,
            D.TransaccionNomina_MontoAFP,
            D.TransaccionNomina_MontoARS,
            D.TransaccionNomina_MontoISR,
            D.TransaccionNomina_SueldonNeto,
            D.TransaccionNomina_Estado
        FROM deleted AS D;

    OPEN cur_hist;
    FETCH NEXT FROM cur_hist INTO
        @TransaccionNomina_ID,
        @Compania_Codigo,
        @TransaccionNomina_Numero,
        @Empleado_ID,
        @TipoNomina_Codigo,
        @PeriodoNomina_Codigo,
        @TransaccionNomina_Fecha,
        @Comentario,
        @SueldoBase,
        @MontoBruto,
        @MontoAFP,
        @MontoARS,
        @MontoISR,
        @MontoNeto,
        @Estado;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC dbo.SP_Insertar_TransaccionesNominaHistorico
            @TransaccionNomina_ID = @TransaccionNomina_ID,
            @Compania_Codigo = @Compania_Codigo,
            @TransaccionNomina_Numero = @TransaccionNomina_Numero,
            @Empleado_ID = @Empleado_ID,
            @TipoNomina_Codigo = @TipoNomina_Codigo,
            @PeriodoNomina_Codigo = @PeriodoNomina_Codigo,
            @TransaccionNomina_Fecha = @TransaccionNomina_Fecha,
            @Comentario = @Comentario,
            @SueldoBase = @SueldoBase,
            @MontoBruto = @MontoBruto,
            @MontoAFP = @MontoAFP,
            @MontoARS = @MontoARS,
            @MontoISR = @MontoISR,
            @MontoNeto = @MontoNeto,
            @Estado = @Estado,
            @Operacion = 'DELETE',
            @UsuarioBD = SYSTEM_USER;

        FETCH NEXT FROM cur_hist INTO
            @TransaccionNomina_ID,
            @Compania_Codigo,
            @TransaccionNomina_Numero,
            @Empleado_ID,
            @TipoNomina_Codigo,
            @PeriodoNomina_Codigo,
            @TransaccionNomina_Fecha,
            @Comentario,
            @SueldoBase,
            @MontoBruto,
            @MontoAFP,
            @MontoARS,
            @MontoISR,
            @MontoNeto,
            @Estado;
    END;

    CLOSE cur_hist;
    DEALLOCATE cur_hist;
END;
GO

EXEC sys.sp_settriggerorder
    @triggername = N'dbo.TR_TransaccionNomina_AfterInsert_Actualizar',
    @order = N'First',
    @stmttype = N'INSERT';
GO

EXEC sys.sp_settriggerorder
    @triggername = N'dbo.TR_TransaccionNomina_AfterInsert_ConsultarEmpleado',
    @order = N'Last',
    @stmttype = N'INSERT';
GO

/* ===============================================================
   CARGA DE TRANSACCIONES DE NOMINA
   =============================================================== */

INSERT INTO dbo.TransaccionNomina
(
    Compania_Codigo,
    TransaccionNomina_Numero,
    TransaccionNomina_Fecha,
    Empleado_ID,
    TipoNomina_Codigo,
    PeriodoNomina_Codigo,
    TransaccionNomina_Comentario,
    TransaccionNomina_Monto,
    TransaccionNomina_Estado
)
VALUES
('UAS', 1001, '2026-01-31', 1, 'FIX', '202601', 'Pago mensual de enero', 42000.00, 'Pendiente'),
('UAS', 1002, '2026-01-31', 2, 'FIX', '202601', 'Pago mensual de enero', 55000.00, 'Pendiente'),
('UAS', 1003, '2026-01-31', 3, 'DOC', '202601', 'Pago mensual de enero', 78000.00, 'Pendiente'),
('UAS', 1004, '2026-01-31', 4, 'FIX', '202601', 'Pago mensual de enero', 120000.00, 'Pendiente'),
('UAS', 1005, '2026-01-31', 5, 'FIX', '202601', 'Pago mensual de enero', 250000.00, 'Pendiente'),
('UAS', 1006, '2026-02-28', 3, 'DOC', '202602', 'Pago mensual de febrero', 80000.00, 'Pendiente');
GO

/* ===============================================================
   EJERCICIO 1 - ANALISIS DE PLANES DE EJECUCION
   =============================================================== */

PRINT 'EJERCICIO 1 - Activar el plan de ejecucion real en SSMS (Ctrl + M).';
SELECT *
FROM dbo.TransaccionNomina
WHERE Empleado_ID = 3;
GO

/* ===============================================================
   EJERCICIO 2 - INDICES Y OPTIMIZACION
   =============================================================== */

CREATE NONCLUSTERED INDEX IX_TransaccionNomina_Empleado_ID
ON dbo.TransaccionNomina (Empleado_ID);
GO

SELECT *
FROM dbo.TransaccionNomina
WHERE Empleado_ID = 3;
GO

/* ===============================================================
   EJERCICIO 3 - ESTADISTICAS
   =============================================================== */

UPDATE STATISTICS dbo.TransaccionNomina;
GO

SELECT *
FROM dbo.TransaccionNomina
WHERE TransaccionNomina_Monto > 20000;
GO

/* ===============================================================
   EJERCICIO 4 - ACID Y MANEJO DE TRANSACCIONES
   =============================================================== */

BEGIN TRY
    BEGIN TRAN;

    INSERT INTO dbo.TransaccionNomina
    (
        Compania_Codigo,
        TransaccionNomina_Numero,
        TransaccionNomina_Fecha,
        Empleado_ID,
        TipoNomina_Codigo,
        PeriodoNomina_Codigo,
        TransaccionNomina_Comentario,
        TransaccionNomina_Monto,
        TransaccionNomina_Estado
    )
    VALUES
    ('UAS', 1007, '2026-03-31', 6, 'FIX', '202603', 'Pago mensual confirmado con COMMIT', 32000.00, 'Pendiente');

    COMMIT TRAN;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRAN;
    THROW;
END CATCH;
GO

SELECT TransaccionNomina_ID, TransaccionNomina_Numero, Empleado_ID, TransaccionNomina_Monto, TransaccionNomina_SueldonNeto
FROM dbo.TransaccionNomina
WHERE TransaccionNomina_Numero = 1007;
GO

/* ===============================================================
   EJERCICIO 5 - ROLLBACK Y SAVEPOINT
   =============================================================== */

BEGIN TRY
    BEGIN TRAN;

    INSERT INTO dbo.TransaccionNomina
    (
        Compania_Codigo,
        TransaccionNomina_Numero,
        TransaccionNomina_Fecha,
        Empleado_ID,
        TipoNomina_Codigo,
        PeriodoNomina_Codigo,
        TransaccionNomina_Comentario,
        TransaccionNomina_Monto,
        TransaccionNomina_Estado
    )
    VALUES
    ('UAS', 1008, '2026-03-31', 1, 'FIX', '202603', 'Transaccion para prueba SAVEPOINT 1', 42000.00, 'Pendiente'),
    ('UAS', 1009, '2026-03-31', 2, 'FIX', '202603', 'Transaccion para prueba SAVEPOINT 2', 55000.00, 'Pendiente');

    SAVE TRAN PuntoParcial;

    UPDATE dbo.TransaccionNomina
    SET TransaccionNomina_Comentario = 'Actualizacion revertida por SAVEPOINT'
    WHERE TransaccionNomina_Numero = 1009;

    ROLLBACK TRAN PuntoParcial;
    COMMIT TRAN;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRAN;
    THROW;
END CATCH;
GO

SELECT TransaccionNomina_Numero, TransaccionNomina_Comentario
FROM dbo.TransaccionNomina
WHERE TransaccionNomina_Numero IN (1008, 1009)
ORDER BY TransaccionNomina_Numero;
GO

/* ===============================================================
   EJERCICIO 6 - CONCURRENCIA Y BLOQUEOS
   Ejecutar en dos sesiones diferentes de SSMS.
   =============================================================== */

/*
SESION 1
BEGIN TRAN;
UPDATE dbo.Empleado
SET Empleado_SueldoBase = 83000.00
WHERE Empleado_ID = 3;
-- Mantener abierta la transaccion sin COMMIT.

SESION 2
UPDATE dbo.Empleado
SET Empleado_SueldoBase = 84000.00
WHERE Empleado_ID = 3;
-- La segunda sesion queda bloqueada hasta que la sesion 1 haga COMMIT o ROLLBACK.
*/
GO

/* ===============================================================
   EJERCICIO 7 - NIVELES DE AISLAMIENTO
   =============================================================== */

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
GO

SELECT *
FROM dbo.TransaccionNomina;
GO

/* ===============================================================
   EJERCICIO 8 - STORED PROCEDURES
   =============================================================== */

EXEC dbo.SP_Actualizar_TransaccionesNomina
    @TransaccionNomina_ID = 3,
    @Compania_Codigo = 'UAS',
    @Empleado_Codigo = 'E00003',
    @SueldoBruto = 78000.00;
GO

EXEC dbo.SP_Consultar_NominaEmpleado
    @Empleado_ID = 3;
GO

UPDATE dbo.Empleado
SET Empleado_Telefono = '809-555-1999'
WHERE Empleado_ID = 1;
GO

SELECT TOP (20) *
FROM dbo.EmpleadoLog
ORDER BY EmpleadoLog_ID DESC;
GO

SELECT TOP (20) *
FROM dbo.TransaccionNominaLog
ORDER BY TransaccionNominaLog_ID DESC;
GO

/* ===============================================================
   EJERCICIO 9 - FUNCION
   =============================================================== */

SELECT
    E.Empleado_ID,
    E.Empleado_Codigo,
    E.Empleado_Nombre + ' ' + E.Empleado_Apellido AS Empleado,
    E.Empleado_SueldoBase AS SueldoMensual,
    dbo.FN_SalarioAnual(E.Empleado_SueldoBase) AS SalarioAnual
FROM dbo.Empleado AS E
ORDER BY E.Empleado_ID;
GO

/* ===============================================================
   EJERCICIO 10 - TRIGGERS
   Se demuestra el disparo de los 5 triggers creados.
   =============================================================== */

INSERT INTO dbo.Empleado
(
    Compania_Codigo,
    Empleado_Codigo,
    Empleado_Nombre,
    Empleado_Apellido,
    Empleado_NumeroCedula,
    Empleado_FechaNacimiento,
    Empleado_FechaIngreso,
    Empleado_Sexo,
    Empleado_EstadoCivil,
    Empleado_Telefono,
    Empleado_Direccion,
    Departamento_Codigo,
    Empleado_Cargo,
    Empleado_SueldoBase,
    Empleado_Estado
)
VALUES
('UAS', 'E00007', 'Jose', 'Amado', '001-000007-7', '1991-06-18', '2026-03-01', 'M', 'C', '809-555-1007', 'Santo Domingo Oeste', 'TIC', 'Administrador de plataformas', 68000.00, 'Activo');
GO

INSERT INTO dbo.TransaccionNomina
(
    Compania_Codigo,
    TransaccionNomina_Numero,
    TransaccionNomina_Fecha,
    Empleado_ID,
    TipoNomina_Codigo,
    PeriodoNomina_Codigo,
    TransaccionNomina_Comentario,
    TransaccionNomina_Monto,
    TransaccionNomina_Estado
)
SELECT
    'UAS',
    1010,
    '2026-03-31',
    E.Empleado_ID,
    'FIX',
    '202603',
    'Transaccion de prueba para trigger y auditoria',
    68000.00,
    'Pendiente'
FROM dbo.Empleado AS E
WHERE E.Empleado_Codigo = 'E00007';
GO

SELECT *
FROM dbo.NominaEmpleadoConsultaCache
WHERE Empleado_Codigo = 'E00007';
GO

SELECT TOP (10) *
FROM dbo.EmpleadoLog
ORDER BY EmpleadoLog_ID DESC;
GO

SELECT TOP (10) *
FROM dbo.TransaccionNominaLog
ORDER BY TransaccionNominaLog_ID DESC;
GO

DELETE FROM dbo.TransaccionNomina
WHERE TransaccionNomina_Numero = 1010;
GO

SELECT TOP (10) *
FROM dbo.TransaccionNominaHistorico
ORDER BY Historico_ID DESC;
GO

/* ===============================================================
   EJERCICIO 11 - VISTA MATERIALIZADA (INDEXED VIEW EN SQL SERVER)
   =============================================================== */

SET ANSI_NULLS ON;
GO
SET ANSI_PADDING ON;
GO
SET ANSI_WARNINGS ON;
GO
SET ARITHABORT ON;
GO
SET CONCAT_NULL_YIELDS_NULL ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
SET NUMERIC_ROUNDABORT OFF;
GO

CREATE VIEW dbo.VW_TotalNominaEmpleado
WITH SCHEMABINDING
AS
    SELECT
        T.Empleado_ID,
        COUNT_BIG(*) AS CantidadTransacciones,
        SUM(ISNULL(T.TransaccionNomina_SueldonNeto, 0.00)) AS TotalPagado
    FROM dbo.TransaccionNomina AS T
    WHERE T.TransaccionNomina_Estado = 'Aplicada'
    GROUP BY T.Empleado_ID;
GO

CREATE UNIQUE CLUSTERED INDEX IX_VW_TotalNominaEmpleado
ON dbo.VW_TotalNominaEmpleado (Empleado_ID);
GO

SELECT
    V.Empleado_ID,
    E.Empleado_Codigo,
    E.Empleado_Nombre + ' ' + E.Empleado_Apellido AS Empleado,
    V.CantidadTransacciones,
    V.TotalPagado
FROM dbo.VW_TotalNominaEmpleado AS V
INNER JOIN dbo.Empleado AS E
    ON E.Empleado_ID = V.Empleado_ID
ORDER BY V.TotalPagado DESC;
GO

/* ===============================================================
   EJERCICIO 12 - SEGURIDAD: USUARIOS, ROLES Y PERMISOS
   Ejecutar con permisos administrativos de servidor.
   =============================================================== */

USE master;
GO

IF SUSER_ID(N'login_consulta_nomina_marlenis') IS NULL
BEGIN
    CREATE LOGIN login_consulta_nomina_marlenis
    WITH PASSWORD = 'Nomina#UASD2026',
         CHECK_POLICY = ON,
         CHECK_EXPIRATION = OFF;
END;
GO

USE DBNomina;
GO

IF USER_ID(N'user_consulta_nomina_marlenis') IS NULL
BEGIN
    CREATE USER user_consulta_nomina_marlenis
    FOR LOGIN login_consulta_nomina_marlenis;
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'RolConsultaNomina')
BEGIN
    CREATE ROLE RolConsultaNomina;
END;
GO

GRANT SELECT ON dbo.Compania TO RolConsultaNomina;
GRANT SELECT ON dbo.Departamento TO RolConsultaNomina;
GRANT SELECT ON dbo.Empleado TO RolConsultaNomina;
GRANT SELECT ON dbo.TipoNomina TO RolConsultaNomina;
GRANT SELECT ON dbo.PeriodoNomina TO RolConsultaNomina;
GRANT SELECT ON dbo.TransaccionNomina TO RolConsultaNomina;
GRANT SELECT ON dbo.VW_TotalNominaEmpleado TO RolConsultaNomina;
GO

ALTER ROLE RolConsultaNomina
ADD MEMBER user_consulta_nomina_marlenis;
GO

/* ===============================================================
   CONSULTAS FINALES DE VERIFICACION
   =============================================================== */

SELECT
    T.TransaccionNomina_ID,
    T.TransaccionNomina_Numero,
    E.Empleado_Codigo,
    E.Empleado_Nombre + ' ' + E.Empleado_Apellido AS Empleado,
    T.TransaccionNomina_Monto AS MontoBruto,
    T.TransaccionNomina_MontoAFP AS AFP,
    T.TransaccionNomina_MontoARS AS ARS,
    T.TransaccionNomina_MontoISR AS ISR,
    T.TransaccionNomina_SueldonNeto AS SueldoNeto
FROM dbo.TransaccionNomina AS T
INNER JOIN dbo.Empleado AS E
    ON E.Empleado_ID = T.Empleado_ID
ORDER BY T.TransaccionNomina_Numero;
GO

SELECT
    E.Empleado_Codigo,
    E.Empleado_Nombre + ' ' + E.Empleado_Apellido AS Empleado,
    dbo.FN_SalarioAnual(E.Empleado_SueldoBase) AS SalarioAnual
FROM dbo.Empleado AS E
ORDER BY Empleado_Codigo;
GO
