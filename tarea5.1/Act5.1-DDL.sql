/*
    ===============================================================
    TAREA 5.1 - DDL (Data Definition Language)
    Definicion de tablas para Sistema de Nomina
    ===============================================================
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
   MODELO FISICO DEL SISTEMA DE NOMINA
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
