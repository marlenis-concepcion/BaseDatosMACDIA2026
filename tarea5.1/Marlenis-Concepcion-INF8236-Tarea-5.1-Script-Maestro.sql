/*
    ===============================================================
    UNIVERSIDAD AUTONOMA DE SANTO DOMINGO (UASD)
    Maestria en Ciencia de Datos e Inteligencia Artificial
    Asignatura: Base de Datos I - INF-8236-C2
    Unidad 5 - Administracion, Optimizacion y Tendencias en BD
    Tarea 5.1 - Consultas Avanzadas, SP y Trigger en MySQL
    Estudiante: Marlenis Judith Concepcion Cuevas
    Tutora: Mtra. Rosmery Alberto M.
    Fecha: 26 de abril de 2026
    Motor objetivo: MySQL 8.0
    Base de datos: DBNomina
    ===============================================================

    Nota tecnica:
    - Para AFP, ARS e ISR se usan referencias vigentes de R.D.:
      AFP empleado 2.87%, ARS empleado 3.04%, ISR 2026.
    - Topes TSS 2026 usados en los calculos:
      SFS = RD$232,230.00 | SVDS = RD$464,460.00
*/

/* ===============================================================
   LIMPIEZA CONTROLADA DE OBJETOS
   =============================================================== */

DROP TRIGGER IF EXISTS TR_TransaccionNomina_Historico;
DROP TRIGGER IF EXISTS TR_TransaccionNomina_Audit;
DROP TRIGGER IF EXISTS TR_Empleado_Audit;
DROP TRIGGER IF EXISTS TR_TransaccionNomina_AfterInsert_ConsultarEmpleado;
DROP VIEW IF EXISTS VW_TotalNominaEmpleado;
DROP PROCEDURE IF EXISTS SP_Actualizar_TransaccionesNomina;
DROP PROCEDURE IF EXISTS SP_Consultar_NominaEmpleado;
DROP PROCEDURE IF EXISTS SP_Insertar_EmpleadoLog;
DROP PROCEDURE IF EXISTS SP_Insertar_TransaccionNominaLog;
DROP PROCEDURE IF EXISTS SP_Insertar_TransaccionesNominaHistorico;
DROP FUNCTION IF EXISTS FN_SalarioAnual;
DROP TABLE IF EXISTS TransaccionNominaHistorico;
DROP TABLE IF EXISTS TransaccionNominaLog;
DROP TABLE IF EXISTS EmpleadoLog;
DROP TABLE IF EXISTS NominaEmpleadoConsultaCache;
DROP TABLE IF EXISTS TransaccionNomina;
DROP TABLE IF EXISTS PeriodoNomina;
DROP TABLE IF EXISTS TipoNomina;
DROP TABLE IF EXISTS Empleado;
DROP TABLE IF EXISTS Departamento;
DROP TABLE IF EXISTS TipoPeriodoNomina;
DROP TABLE IF EXISTS Compania;

/* ===============================================================
   DDL - MODELO FISICO DEL SISTEMA DE NOMINA
   =============================================================== */

CREATE TABLE Compania
(
    Compania_Codigo          CHAR(3)       NOT NULL,
    Compania_Descripcion     VARCHAR(100)  NOT NULL,
    Compania_Estado          CHAR(10)      NOT NULL DEFAULT 'Activo',
    PRIMARY KEY (Compania_Codigo),
    CONSTRAINT CK_Compania_Estado CHECK (Compania_Estado IN ('Activo', 'Inactivo'))
);

CREATE TABLE TipoPeriodoNomina
(
    TipoPeriodoNomina_Codigo      CHAR(3)       NOT NULL,
    TipoPeriodoNomina_Descripcion VARCHAR(50)   NOT NULL,
    TipoPeriodoNomina_Estado      CHAR(10)      NOT NULL DEFAULT 'Activo',
    PRIMARY KEY (TipoPeriodoNomina_Codigo),
    CONSTRAINT CK_TipoPeriodoNomina_Estado CHECK (TipoPeriodoNomina_Estado IN ('Activo', 'Inactivo'))
);

CREATE TABLE Departamento
(
    Compania_Codigo              CHAR(3)       NOT NULL,
    Departamento_Codigo          CHAR(3)       NOT NULL,
    Departamento_Descripcion     VARCHAR(100)  NOT NULL,
    Departamento_Estado          CHAR(10)      NOT NULL DEFAULT 'Activo',
    PRIMARY KEY (Compania_Codigo, Departamento_Codigo),
    CONSTRAINT FK_Departamento_Compania FOREIGN KEY (Compania_Codigo)
        REFERENCES Compania (Compania_Codigo),
    CONSTRAINT CK_Departamento_Estado CHECK (Departamento_Estado IN ('Activo', 'Inactivo'))
);

CREATE TABLE Empleado
(
    Empleado_ID                  INT AUTO_INCREMENT NOT NULL,
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
    Empleado_Estado              CHAR(10)          NOT NULL DEFAULT 'Activo',
    PRIMARY KEY (Empleado_ID),
    UNIQUE KEY UQ_Empleado_CompaniaCodigo (Compania_Codigo, Empleado_Codigo),
    UNIQUE KEY UQ_Empleado_Cedula (Empleado_NumeroCedula),
    CONSTRAINT FK_Empleado_Compania FOREIGN KEY (Compania_Codigo)
        REFERENCES Compania (Compania_Codigo),
    CONSTRAINT FK_Empleado_Departamento FOREIGN KEY (Compania_Codigo, Departamento_Codigo)
        REFERENCES Departamento (Compania_Codigo, Departamento_Codigo),
    CONSTRAINT CK_Empleado_Estado CHECK (Empleado_Estado IN ('Activo', 'Inactivo')),
    CONSTRAINT CK_Empleado_Sexo CHECK (Empleado_Sexo IN ('M', 'F')),
    CONSTRAINT CK_Empleado_EstadoCivil CHECK (Empleado_EstadoCivil IN ('S', 'C', 'U', 'D', 'V')),
    CONSTRAINT CK_Empleado_SueldoBase CHECK (Empleado_SueldoBase IS NULL OR Empleado_SueldoBase >= 0)
);

CREATE TABLE TipoNomina
(
    Compania_Codigo              CHAR(3)       NOT NULL,
    TipoNomina_Codigo            CHAR(3)       NOT NULL,
    TipoNomina_Descripcion       VARCHAR(100)  NOT NULL,
    TipoPeriodoNomina_Codigo     CHAR(3)       NOT NULL,
    TipoNomina_Estado            CHAR(10)      NOT NULL DEFAULT 'Activo',
    PRIMARY KEY (Compania_Codigo, TipoNomina_Codigo),
    CONSTRAINT FK_TipoNomina_Compania FOREIGN KEY (Compania_Codigo)
        REFERENCES Compania (Compania_Codigo),
    CONSTRAINT FK_TipoNomina_TipoPeriodo FOREIGN KEY (TipoPeriodoNomina_Codigo)
        REFERENCES TipoPeriodoNomina (TipoPeriodoNomina_Codigo),
    CONSTRAINT CK_TipoNomina_Estado CHECK (TipoNomina_Estado IN ('Activo', 'Inactivo'))
);

CREATE TABLE PeriodoNomina
(
    Compania_Codigo              CHAR(3)       NOT NULL,
    PeriodoNomina_Codigo         CHAR(6)       NOT NULL,
    PeriodoNomina_Anio           SMALLINT      NOT NULL,
    PeriodoNomina_Descripcion    VARCHAR(50)   NOT NULL,
    PeriodoNomina_FechaInicial   DATETIME      NOT NULL,
    PeriodoNomina_FechaFinal     DATETIME      NOT NULL,
    PeriodoNomina_Estado         CHAR(10)      NOT NULL DEFAULT 'Abierto',
    PRIMARY KEY (Compania_Codigo, PeriodoNomina_Codigo),
    CONSTRAINT FK_PeriodoNomina_Compania FOREIGN KEY (Compania_Codigo)
        REFERENCES Compania (Compania_Codigo),
    CONSTRAINT CK_PeriodoNomina_Estado CHECK (PeriodoNomina_Estado IN ('Abierto', 'Cerrado', 'Pagado')),
    CONSTRAINT CK_PeriodoNomina_Fechas CHECK (PeriodoNomina_FechaFinal >= PeriodoNomina_FechaInicial)
);

CREATE TABLE TransaccionNomina
(
    TransaccionNomina_ID             INT AUTO_INCREMENT NOT NULL,
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
    TransaccionNomina_Estado         CHAR(10)          NOT NULL DEFAULT 'Aplicada',
    PRIMARY KEY (TransaccionNomina_ID),
    UNIQUE KEY UQ_TransaccionNomina_CompaniaNumero (Compania_Codigo, TransaccionNomina_Numero),
    CONSTRAINT FK_TransaccionNomina_Compania FOREIGN KEY (Compania_Codigo)
        REFERENCES Compania (Compania_Codigo),
    CONSTRAINT FK_TransaccionNomina_Empleado FOREIGN KEY (Empleado_ID)
        REFERENCES Empleado (Empleado_ID),
    CONSTRAINT FK_TransaccionNomina_TipoNomina FOREIGN KEY (Compania_Codigo, TipoNomina_Codigo)
        REFERENCES TipoNomina (Compania_Codigo, TipoNomina_Codigo),
    CONSTRAINT FK_TransaccionNomina_PeriodoNomina FOREIGN KEY (Compania_Codigo, PeriodoNomina_Codigo)
        REFERENCES PeriodoNomina (Compania_Codigo, PeriodoNomina_Codigo),
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

CREATE TABLE NominaEmpleadoConsultaCache
(
    Cache_ID                         INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
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
    FechaGeneracionCache             DATETIME          NOT NULL DEFAULT NOW()
);

CREATE TABLE EmpleadoLog
(
    EmpleadoLog_ID                   INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    Empleado_ID                      INT               NULL,
    Compania_Codigo                  CHAR(3)           NULL,
    Empleado_Codigo                  CHAR(6)           NULL,
    NombreCompleto                   VARCHAR(80)       NULL,
    Empleado_Estado                  CHAR(10)          NULL,
    Accion                           VARCHAR(10)       NOT NULL,
    UsuarioBD                        VARCHAR(128)      NOT NULL DEFAULT 'root',
    FechaEvento                      DATETIME          NOT NULL DEFAULT NOW()
);

CREATE TABLE TransaccionNominaLog
(
    TransaccionNominaLog_ID          INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    TransaccionNomina_ID             INT               NULL,
    Compania_Codigo                  CHAR(3)           NULL,
    TransaccionNomina_Numero         INT               NULL,
    Empleado_ID                      INT               NULL,
    MontoBruto                       DECIMAL(12,2)     NULL,
    MontoNeto                        DECIMAL(12,2)     NULL,
    Estado                           CHAR(10)          NULL,
    Accion                           VARCHAR(10)       NOT NULL,
    UsuarioBD                        VARCHAR(128)      NOT NULL DEFAULT 'root',
    FechaEvento                      DATETIME          NOT NULL DEFAULT NOW()
);

CREATE TABLE TransaccionNominaHistorico
(
    Historico_ID                     INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
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
    UsuarioBD                        VARCHAR(128)      NOT NULL DEFAULT 'root',
    FechaArchivado                   DATETIME          NOT NULL DEFAULT NOW()
);

/* ===============================================================
   DML - DATOS MAESTROS
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
('UAS', 'TIC', 'Tecnologia');

INSERT INTO TipoNomina (Compania_Codigo, TipoNomina_Codigo, TipoNomina_Descripcion, TipoPeriodoNomina_Codigo)
VALUES
('UAS', 'FIX', 'Nomina de empleados fijos', 'MEN'),
('UAS', 'DOC', 'Nomina de docentes', 'MEN'),
('UAS', 'EXT', 'Nomina extraordinaria', 'MEN');

INSERT INTO PeriodoNomina
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

INSERT INTO Empleado
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

/* ===============================================================
   FUNCIONES
   =============================================================== */

DELIMITER //

CREATE FUNCTION FN_SalarioAnual(pSueldoMensual DECIMAL(12,2))
RETURNS DECIMAL(14,2)
READS SQL DATA
DETERMINISTIC
BEGIN
    RETURN ROUND(IFNULL(pSueldoMensual, 0.00) * 12.00, 2);
END//

/* ===============================================================
   STORED PROCEDURES
   =============================================================== */

CREATE PROCEDURE SP_Actualizar_TransaccionesNomina(
    IN pTransaccionNomina_ID INT,
    IN pCompania_Codigo CHAR(3),
    IN pEmpleado_Codigo CHAR(6),
    IN pSueldoBruto DECIMAL(12,2)
)
BEGIN
    DECLARE vEmpleado_ID INT;
    DECLARE vSueldoBase DECIMAL(12,2);
    DECLARE vMontoBruto DECIMAL(12,2);
    DECLARE vMontoAFP DECIMAL(12,2);
    DECLARE vMontoARS DECIMAL(12,2);
    DECLARE vMontoISR DECIMAL(12,2);
    DECLARE vMontoNeto DECIMAL(12,2);
    DECLARE vIngresoAnualGravado DECIMAL(14,2);

    SELECT
        Empleado_ID,
        Empleado_SueldoBase
    INTO vEmpleado_ID, vSueldoBase
    FROM Empleado
    WHERE Compania_Codigo = pCompania_Codigo
      AND Empleado_Codigo = pEmpleado_Codigo;

    IF vEmpleado_ID IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No existe el empleado para la compania y codigo suministrados.';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM TransaccionNomina
        WHERE TransaccionNomina_ID = pTransaccionNomina_ID
          AND Compania_Codigo = pCompania_Codigo
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No existe la transaccion de nomina indicada.';
    END IF;

    SET vMontoBruto = IFNULL(pSueldoBruto, vSueldoBase);

    SET vMontoAFP = ROUND(
        (CASE WHEN vMontoBruto > 464460.00 THEN 464460.00 ELSE vMontoBruto END) * 0.0287,
        2
    );

    SET vMontoARS = ROUND(
        (CASE WHEN vMontoBruto > 232230.00 THEN 232230.00 ELSE vMontoBruto END) * 0.0304,
        2
    );

    SET vIngresoAnualGravado = ROUND((vMontoBruto - vMontoAFP - vMontoARS) * 12.00, 2);

    IF vIngresoAnualGravado <= 416220.00 THEN
        SET vMontoISR = 0.00;
    ELSEIF vIngresoAnualGravado <= 624329.00 THEN
        SET vMontoISR = ROUND((((vIngresoAnualGravado - 416220.01) * 0.15) / 12.00), 2);
    ELSEIF vIngresoAnualGravado <= 867123.00 THEN
        SET vMontoISR = ROUND(((31216.00 + ((vIngresoAnualGravado - 624329.01) * 0.20)) / 12.00), 2);
    ELSE
        SET vMontoISR = ROUND(((79776.00 + ((vIngresoAnualGravado - 867123.01) * 0.25)) / 12.00), 2);
    END IF;

    SET vMontoNeto = ROUND(vMontoBruto - vMontoAFP - vMontoARS - vMontoISR, 2);

    UPDATE TransaccionNomina
    SET Empleado_ID = vEmpleado_ID,
        TransaccionNomina_SueldoBase = vSueldoBase,
        TransaccionNomina_Monto = vMontoBruto,
        TransaccionNomina_MontoAFP = vMontoAFP,
        TransaccionNomina_MontoARS = vMontoARS,
        TransaccionNomina_MontoISR = vMontoISR,
        TransaccionNomina_SueldonNeto = vMontoNeto,
        TransaccionNomina_Estado = 'Aplicada'
    WHERE TransaccionNomina_ID = pTransaccionNomina_ID;
END//

CREATE PROCEDURE SP_Consultar_NominaEmpleado(
    IN pEmpleado_ID INT
)
BEGIN
    SELECT
        E.Empleado_ID,
        T.TransaccionNomina_ID,
        T.TransaccionNomina_Numero,
        T.Compania_Codigo,
        E.Empleado_Codigo,
        CONCAT(E.Empleado_Nombre, ' ', E.Empleado_Apellido) AS Empleado_NombreCompleto,
        T.PeriodoNomina_Codigo,
        T.TipoNomina_Codigo,
        T.TransaccionNomina_Fecha,
        T.TransaccionNomina_Monto AS MontoBruto,
        T.TransaccionNomina_SueldonNeto AS MontoNeto,
        T.TransaccionNomina_Estado AS Estado
    FROM TransaccionNomina AS T
    INNER JOIN Empleado AS E
        ON E.Empleado_ID = T.Empleado_ID
    WHERE T.Empleado_ID = pEmpleado_ID
    ORDER BY T.TransaccionNomina_Fecha, T.TransaccionNomina_Numero;
END//

CREATE PROCEDURE SP_Insertar_EmpleadoLog(
    IN pEmpleado_ID INT,
    IN pCompania_Codigo CHAR(3),
    IN pEmpleado_Codigo CHAR(6),
    IN pNombreCompleto VARCHAR(80),
    IN pEmpleado_Estado CHAR(10),
    IN pAccion VARCHAR(10)
)
BEGIN
    INSERT INTO EmpleadoLog
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
        pEmpleado_ID,
        pCompania_Codigo,
        pEmpleado_Codigo,
        pNombreCompleto,
        pEmpleado_Estado,
        pAccion,
        CURRENT_USER
    );
END//

CREATE PROCEDURE SP_Insertar_TransaccionNominaLog(
    IN pTransaccionNomina_ID INT,
    IN pCompania_Codigo CHAR(3),
    IN pTransaccionNomina_Numero INT,
    IN pEmpleado_ID INT,
    IN pMontoBruto DECIMAL(12,2),
    IN pMontoNeto DECIMAL(12,2),
    IN pEstado CHAR(10),
    IN pAccion VARCHAR(10)
)
BEGIN
    INSERT INTO TransaccionNominaLog
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
        pTransaccionNomina_ID,
        pCompania_Codigo,
        pTransaccionNomina_Numero,
        pEmpleado_ID,
        pMontoBruto,
        pMontoNeto,
        pEstado,
        pAccion,
        CURRENT_USER
    );
END//

CREATE PROCEDURE SP_Insertar_TransaccionesNominaHistorico(
    IN pTransaccionNomina_ID INT,
    IN pCompania_Codigo CHAR(3),
    IN pTransaccionNomina_Numero INT,
    IN pEmpleado_ID INT,
    IN pTipoNomina_Codigo CHAR(3),
    IN pPeriodoNomina_Codigo CHAR(6),
    IN pTransaccionNomina_Fecha DATETIME,
    IN pComentario VARCHAR(100),
    IN pSueldoBase DECIMAL(12,2),
    IN pMontoBruto DECIMAL(12,2),
    IN pMontoAFP DECIMAL(12,2),
    IN pMontoARS DECIMAL(12,2),
    IN pMontoISR DECIMAL(12,2),
    IN pMontoNeto DECIMAL(12,2),
    IN pEstado CHAR(10),
    IN pOperacion VARCHAR(10)
)
BEGIN
    INSERT INTO TransaccionNominaHistorico
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
        pTransaccionNomina_ID,
        pCompania_Codigo,
        pTransaccionNomina_Numero,
        pEmpleado_ID,
        pTipoNomina_Codigo,
        pPeriodoNomina_Codigo,
        pTransaccionNomina_Fecha,
        pComentario,
        pSueldoBase,
        pMontoBruto,
        pMontoAFP,
        pMontoARS,
        pMontoISR,
        pMontoNeto,
        pEstado,
        pOperacion,
        CURRENT_USER
    );
END//

/* ===============================================================
   TRIGGERS
   =============================================================== */

CREATE TRIGGER TR_TransaccionNomina_AfterInsert_ConsultarEmpleado
AFTER INSERT ON TransaccionNomina
FOR EACH ROW
BEGIN
    CALL SP_Insertar_TransaccionNominaLog(
        NEW.TransaccionNomina_ID,
        NEW.Compania_Codigo,
        NEW.TransaccionNomina_Numero,
        NEW.Empleado_ID,
        NEW.TransaccionNomina_Monto,
        NEW.TransaccionNomina_SueldonNeto,
        NEW.TransaccionNomina_Estado,
        'INSERT'
    );
END//

CREATE TRIGGER TR_Empleado_Audit
AFTER INSERT ON Empleado
FOR EACH ROW
BEGIN
    CALL SP_Insertar_EmpleadoLog(
        NEW.Empleado_ID,
        NEW.Compania_Codigo,
        NEW.Empleado_Codigo,
        CONCAT(NEW.Empleado_Nombre, ' ', NEW.Empleado_Apellido),
        NEW.Empleado_Estado,
        'INSERT'
    );
END//

CREATE TRIGGER TR_TransaccionNomina_Audit
AFTER UPDATE ON TransaccionNomina
FOR EACH ROW
BEGIN
    CALL SP_Insertar_TransaccionNominaLog(
        NEW.TransaccionNomina_ID,
        NEW.Compania_Codigo,
        NEW.TransaccionNomina_Numero,
        NEW.Empleado_ID,
        NEW.TransaccionNomina_Monto,
        NEW.TransaccionNomina_SueldonNeto,
        NEW.TransaccionNomina_Estado,
        'UPDATE'
    );
END//

CREATE TRIGGER TR_TransaccionNomina_Historico
AFTER UPDATE ON TransaccionNomina
FOR EACH ROW
BEGIN
    CALL SP_Insertar_TransaccionesNominaHistorico(
        NEW.TransaccionNomina_ID,
        NEW.Compania_Codigo,
        NEW.TransaccionNomina_Numero,
        NEW.Empleado_ID,
        NEW.TipoNomina_Codigo,
        NEW.PeriodoNomina_Codigo,
        NEW.TransaccionNomina_Fecha,
        NEW.TransaccionNomina_Comentario,
        NEW.TransaccionNomina_SueldoBase,
        NEW.TransaccionNomina_Monto,
        NEW.TransaccionNomina_MontoAFP,
        NEW.TransaccionNomina_MontoARS,
        NEW.TransaccionNomina_MontoISR,
        NEW.TransaccionNomina_SueldonNeto,
        NEW.TransaccionNomina_Estado,
        'UPDATE'
    );
END//

/* ===============================================================
   VISTAS
   =============================================================== */

CREATE VIEW VW_TotalNominaEmpleado AS
SELECT
    E.Empleado_ID,
    E.Compania_Codigo,
    E.Empleado_Codigo,
    CONCAT(E.Empleado_Nombre, ' ', E.Empleado_Apellido) AS Empleado_NombreCompleto,
    E.Empleado_Cargo,
    COUNT(T.TransaccionNomina_ID) AS TotalTransacciones,
    SUM(CASE WHEN T.TransaccionNomina_Estado = 'Aplicada' THEN 1 ELSE 0 END) AS TransaccionesAplicadas,
    SUM(CASE WHEN T.TransaccionNomina_Estado = 'Pendiente' THEN 1 ELSE 0 END) AS TransaccionesPendientes,
    SUM(CASE WHEN T.TransaccionNomina_Estado = 'Anulada' THEN 1 ELSE 0 END) AS TransaccionesAnuladas,
    SUM(T.TransaccionNomina_Monto) AS MontoBrutoTotal,
    SUM(T.TransaccionNomina_MontoAFP) AS MontoAFPTotal,
    SUM(T.TransaccionNomina_MontoARS) AS MontoARSTotal,
    SUM(T.TransaccionNomina_MontoISR) AS MontoISRTotal,
    SUM(T.TransaccionNomina_SueldonNeto) AS MontoNetoTotal
FROM Empleado AS E
LEFT JOIN TransaccionNomina AS T
    ON E.Empleado_ID = T.Empleado_ID
GROUP BY
    E.Empleado_ID,
    E.Compania_Codigo,
    E.Empleado_Codigo,
    E.Empleado_Nombre,
    E.Empleado_Apellido,
    E.Empleado_Cargo//

DELIMITER ;

/* ===============================================================
   DQL - CONSULTAS DE EJEMPLO
   =============================================================== */

SELECT 'Estructura de Base de Datos Completada' AS Estado;
SELECT COUNT(*) AS Total_Empleados FROM Empleado;
SELECT COUNT(*) AS Total_Transacciones FROM TransaccionNomina;
SELECT Empleado_Codigo, Empleado_Nombre, Empleado_Apellido, Empleado_SueldoBase
FROM Empleado WHERE Compania_Codigo = 'UAS' ORDER BY Empleado_Codigo;
