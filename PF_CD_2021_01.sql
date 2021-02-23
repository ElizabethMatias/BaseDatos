
CREATE TABLE Paquete(
    Codigo VARCHAR(8) NOT NULL,
    Direccion VARCHAR(20) NOT NULL,
    Peso REAL NOT NULL,
    Destinatario VARCHAR(20) NOT NULL,
    Fecha_Envio DATE DEFAULT GETDATE(),
    Tipo_Envio VARCHAR(20) NOT NULL,
    CONSTRAINT PK_COD PRIMARY KEY (Codigo),
    CONSTRAINT CHK_COD CHECK (Codigo LIKE '[A-Z][A-Z]_[1-9][1-9][1-9][1-9][1-9]'),
    CONSTRAINT CHK_PESO CHECK (Peso BETWEEN 0 AND 2),
    CONSTRAINT CHK_FECHA CHECK (Fecha_Envio BETWEEN '10/12/2020' AND GETDATE())
);

CREATE TABLE C_Local(
    Codigo_Local INTEGER,
    Nombre VARCHAR(20),
    CONSTRAINT PK_COD_LOCAL PRIMARY KEY (Codigo_Local)
);

CREATE TABLE Internacional(
    Codigo VARCHAR(8) NOT NULL,
    Linea_Aerea VARCHAR(20) NOT NULL DEFAULT 'Mexicana',
    Codigo_Local INTEGER NOT NULL,
    Fecha_Entrega DATE,
    CONSTRAINT FK_COD_INT FOREIGN KEY (Codigo) REFERENCES Paquete (Codigo)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT FK_COD_LOCAL FOREIGN KEY (Codigo_Local) REFERENCES C_Local (Codigo_Local)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT CHK_ENTREGA CHECK (Fecha_Entrega >=  '10/12/2020')
);

--los primeros dos caracteres corresponden al apellido paterno; luego, 
--les sigue la inicial del apellido materno y, después, la primera letra del nombre; 
--enseguida  encontrarás los dos dígitos del año, mes y día de nacimiento 
--(dos dígitos por cada categoría) y, por último, está la homoclave, una serie única de 3 caracteres
CREATE TABLE Conductor(
    RFC VARCHAR(13) NOT NULL,
    Nombre VARCHAR(20) NOT NULL,
    Direccion VARCHAR(20) NOT NULL,
    Ruta INTEGER NOT NULL,
    CONSTRAINT PK_RFC PRIMARY KEY (RFC),
    CONSTRAINT CHK_RFC CHECK (RFC LIKE '[A-Z][A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT CHK_RUTA CHECK (Ruta IN (54, 55, 56, 57))
);

CREATE TABLE Nacional(
    Codigo VARCHAR(8) NOT NULL,
    Ciudad_Destino VARCHAR(20) NOT NULL,
    RFC VARCHAR(13) NOT NULL,
    Ruta INTEGER NOT NULL,
    CONSTRAINT FK_COD_NAC FOREIGN KEY (Codigo) REFERENCES Paquete (Codigo)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT FK_COND_NAC FOREIGN KEY (RFC) REFERENCES Conductor (RFC)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT CHK_RUTA_N CHECK (Ruta IN (54, 55, 56, 57))
);

CREATE TABLE Paquete_Envio(
    Codigo VARCHAR(8) NOT NULL,
    Ciudad_Destino VARCHAR(20) NOT NULL,  
    CONSTRAINT FK_COD_PAQ FOREIGN KEY (Codigo) REFERENCES Paquete (Codigo) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
);

CREATE TABLE Camion(
    Placa VARCHAR(7) NOT NULL,
    Carga_MAX INTEGER,
    Ciudad_Resguardo VARCHAR(11) NOT NULL,
    CONSTRAINT PK_PLACA PRIMARY KEY (Placa),
    CONSTRAINT CHK_PLACA CHECK (Placa LIKE '[0-9][0-9][0-9]-[A-Z][A-Z][A-Z]'),
    CONSTRAINT CHK_CARGA CHECK (Carga_MAX BETWEEN 0 AND 4000), --Por las restricciones de la tareas
    CONSTRAINT CHK_CUIDAD CHECK (Ciudad_Resguardo IN('CDMX','Monterrey','Guadalajara','Mérida','Tijuana')),
);

CREATE TABLE Conductor_Camion(
    RFC VARCHAR(13) NOT NULL,
    Placa VARCHAR(7) NOT NULL,
    Fecha DATE,
    CONSTRAINT PK_RFC_PLA PRIMARY KEY (RFC, Placa),
    CONSTRAINT FK_RFC FOREIGN KEY (RFC) REFERENCES Conductor (RFC)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT FK_PLACA FOREIGN KEY (Placa) REFERENCES Camion(Placa)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

--DISPARADORES
CREATE TRIGGER T_enviosInternacionales 
ON Internacional FOR INSERT AS
    DECLARE @Codigo VARCHAR(8)
    DECLARE @CodigoPaquete VARCHAR(8)
    SET @Codigo = (SELECT Codigo FROM INSERTED)
    SET @CodigoPaquete = (SELECT Codigo FROM Nacional WHERE Codigo = @Codigo)
        IF @Codigo = @CodigoPaquete
            BEGIN 
            PRINT '¡Error, este paquete ya esta en nacional!'
            ROLLBACK
        END
    ELSE
        BEGIN
            PRINT '¡Se ha realizado la inserción!'
        END

CREATE TRIGGER T_enviosNacionales 
ON Nacional FOR INSERT AS
    DECLARE @Codigo VARCHAR(8)
    DECLARE @CodigoPaquete VARCHAR(8)
    SET @Codigo = (SELECT Codigo FROM INSERTED)
    SET @CodigoPaquete = (SELECT Codigo FROM Internacional WHERE Codigo = @Codigo)
        IF @Codigo = @CodigoPaquete
            BEGIN 
                PRINT 'Error, este paquete ya esta en internacional'
            ROLLBACK
        END
    ELSE
        BEGIN
            PRINT 'Se ha realizado la inserción'
        END

CREATE TRIGGER T_pesoCamiones 
ON Camion FOR INSERT, UPDATE AS
    DECLARE @Carga_MAX REAL
    SET @Carga_MAX  = (SELECT Carga_MAX FROM INSERTED)
    IF @Carga_MAX < 250 
        BEGIN
            PRINT '¡No se puede ingresar un camión con carga tan BAJA!' 
            ROLLBACK
        END
    ELSE IF @Carga_MAX > 1250
        BEGIN
            PRINT '¡No se puede ingresar un camión con carga tan ALTA!' 
            ROLLBACK
        END 

CREATE TRIGGER T_noEnvios 
ON Nacional FOR INSERT AS 
    DECLARE @idEnvio VARCHAR(8)
    DECLARE @CiudadDestino VARCHAR(30)
    DECLARE @noEnvios INT
    SET @idEnvio = (SELECT Codigo FROM INSERTED)
    SET @CiudadDestino = (SELECT Ciudad_Destino FROM INSERTED)
    SET @noEnvios = (SELECT COUNT(Ciudad_Destino) FROM Nacional 
                     GROUP BY Ciudad_Destino HAVING Ciudad_Destino = @CiudadDestino)
    INSERT INTO Paquete_Envio VALUES (@idEnvio, @CiudadDestino)
    BEGIN
        PRINT 'Se han hecho ' + CAST(@noEnvios AS VARCHAR) + ' envios a ' + @CiudadDestino 
    END

--PROCEDIMIENTO
CREATE PROCEDURE SP_infoPaquete @Codigo VARCHAR(8) AS
    DECLARE @tipoEnvio VARCHAR(20)
    DECLARE @Direccion VARCHAR(20)
    DECLARE @Peso REAL
    DECLARE @Conductor VARCHAR(20)
    DECLARE @Ruta INT
    DECLARE @RFC VARCHAR(13)
    DECLARE @Placas VARCHAR(20)
    DECLARE @Fecha VARCHAR(10)
    DECLARE @LineaAerea VARCHAR(20)
    DECLARE @CodigoLocal INT
    SET @tipoEnvio = (SELECT Tipo_Envio FROM Paquete WHERE Codigo = @Codigo)
    SET @Direccion = (SELECT Direccion FROM Paquete WHERE Codigo = @Codigo)
BEGIN
    IF @tipoEnvio = 'Nacional'
        BEGIN  
            SET @Peso = (SELECT Peso FROM Paquete WHERE Codigo = @Codigo)
            SET @Conductor = (SELECT Nombre FROM Conductor AS C INNER JOIN Nacional AS N ON C.RFC = N.RFC 
                              WHERE N.Codigo = @Codigo)
            SET @Ruta = (SELECT Ruta FROM Nacional WHERE Codigo = @Codigo)
            SET @RFC = (SELECT C.RFC FROM Conductor AS C INNER JOIN Nacional AS N ON C.RFC = N.RFC 
                        WHERE N.Codigo = @Codigo)
            SET @Conductor = (SELECT Nombre FROM Conductor WHERE RFC = @RFC)
            SET @Placas = (SELECT C.Placa FROM Camion AS C INNER JOIN Conductor_Camion AS CC ON C.Placa = CC.Placa 
                           WHERE CC.RFC = @RFC)
            SET @Fecha = (SELECT Fecha FROM Conductor_Camion WHERE RFC = @RFC AND Placa = @Placas)
            PRINT 'Paquete: ' + @Codigo
            PRINT 'Dirección: ' + @Direccion
            PRINT 'Peso: ' + CAST(@Peso AS VARCHAR) + ' kg.'
            PRINT 'Conductor: ' + @Conductor
            PRINT 'Ruta: ' + CAST(@Ruta AS VARCHAR)
            PRINT 'Placas: ' + @Placas
            PRINT 'Fecha: ' + @Fecha
        END
    ELSE 
        BEGIN
            SET @LineaAerea = (SELECT Linea_Aerea FROM Internacional WHERE Codigo = @Codigo)
            SET @CodigoLocal = (SELECT C.Codigo_Local FROM Internacional AS I INNER JOIN C_Local AS C 
                                ON I.Codigo_Local = C.Codigo_Local WHERE I.Codigo = @Codigo)
            PRINT 'Dirección: ' + @Direccion
            PRINT 'Paquete: ' + @Codigo
            PRINT 'Línea aérea: ' + @LineaAerea
            PRINT 'C-Local: ' + CAST(@CodigoLocal AS VARCHAR)
        END
END

--INSERCIONES
--PAQUETES
INSERT INTO Paquete VALUES ('AD_42562', 'Gumaro', 1, 'Edo. Mex', GETDATE(), 'Nacional');
INSERT INTO Paquete VALUES ('HJ_72456', 'Zenzontle', 1.8, 'Guadalajara', '11/12/2020', 'Nacional');
INSERT INTO Paquete VALUES ('WR_73254', 'Hidalgo', 2, 'Guerrero', '23/01/2021', 'Nacional');
INSERT INTO Paquete VALUES ('GA_53255', 'Wilfrido', 1.8, 'CDMX', '08/01/2021', 'Nacional');
INSERT INTO Paquete VALUES ('NB_76245', '100 metros', 1.5, 'CDMX', '01/02/2021', 'Nacional');

INSERT INTO Paquete VALUES ('DD_11564', 'São Paulo', 0.5, 'Brasil', '14/12/2020', 'Internacional');
INSERT INTO Paquete VALUES ('NW_61663', 'Bourke', 1, 'Australia', '14/12/2020', 'Internacional');
INSERT INTO Paquete VALUES ('LJ_42322', 'Portobello', 2, 'Inglaterra', '14/12/2020', 'Internacional');
INSERT INTO Paquete VALUES ('XC_62672', 'Marceau', 1.9, 'Francia', '22/12/2020', 'Internacional');
INSERT INTO Paquete (Codigo, Direccion, Peso, Destinatario, Tipo_Envio) 
VALUES ('BN_24324', 'Erdgeschoss', 0.9, 'Alemania', 'Internacional');

--LOCALES
INSERT INTO C_Local VALUES (121, 'Bijoux Blues');
INSERT INTO C_Local VALUES (652, 'Kleinmarkthalle');
INSERT INTO C_Local VALUES (878, 'L Atelier le Thiers');
INSERT INTO C_Local VALUES (897, 'Viktualienmarkt');
INSERT INTO C_Local VALUES (915, 'Anand Atelier');

--PAQUETES INTERNACIONALES
INSERT INTO Internacional VALUES ('BN_24324','Alemana', 652, '24/12/2020');
INSERT INTO Internacional VALUES ('XC_62672', 'Francesa', 121, '01/01/2021');
INSERT INTO Internacional VALUES ('LJ_42322', 'Alemana', 897, '29/12/2020');
INSERT INTO Internacional VALUES ('NW_61663', 'Europea', 652, '10/03/2021');
INSERT INTO Internacional (Fecha_Entrega, Codigo, Codigo_Local)
VALUES ('30/12/2020', 'DD_11564', 915); 

--CONDUCTORES
INSERT INTO Conductor VALUES ('HEGA280874142', 'Agustin', 'Gumaro', 55);
INSERT INTO Conductor VALUES ('GADM070860623', 'Mariana', 'Zenzontle', 54);
INSERT INTO Conductor VALUES ('CAPR161280872', 'Roberto', 'Xalapa', 56);
INSERT INTO Conductor VALUES ('FAGF220779112', 'Francisco', 'CDMX', 55);
INSERT INTO Conductor VALUES ('JHAR231155723', 'Javier', 'Hermosillo', 54);

--PAQUETES NACIONALES
INSERT INTO Nacional VALUES ('HJ_72456', 'Zenzontle', 'HEGA280874142', 56);
INSERT INTO Nacional VALUES ('AD_42562', 'Cuautitlan','GADM070860623', 55);
INSERT INTO Nacional VALUES ('WR_73254', 'Actopan', 'CAPR161280872', 56);
INSERT INTO Nacional VALUES ('GA_53255','CDMX', 'FAGF220779112', 56);
INSERT INTO Nacional VALUES ('NB_76245','CDMX',  'FAGF220779112', 56);

--CAMIONES
INSERT INTO Camion VALUES ('423-GDA', 1250, 'CDMX');
INSERT INTO Camion VALUES ('653-SGS', 1000, 'Monterrey');
INSERT INTO Camion VALUES ('235-JYD', 950, 'CDMX');
INSERT INTO Camion VALUES ('874-SAF', 500, 'Mérida');
INSERT INTO Camion VALUES ('135-MXB', 900, 'Tijuana');
INSERT INTO Camion VALUES ('763-BAA', 400, 'Guadalajara');

--CONDUTORES-CAMIONES
INSERT INTO Conductor_Camion VALUES ('HEGA280874142', '235-JYD', '20/12/2020');
INSERT INTO Conductor_Camion VALUES ('GADM070860623', '763-BAA', '22/12/2020');
INSERT INTO Conductor_Camion VALUES ('CAPR161280872', '874-SAF', '23/12/2020');