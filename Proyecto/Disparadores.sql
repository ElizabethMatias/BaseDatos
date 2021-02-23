--//DISPARADORES//
-----------------------------------------------------------------------------------------------------
/*Integridad de los datos
Garantizar que un paquete solo pueda ser de un solo tipo Nacional o Intenacional*/

CREATE TRIGGER IntegridadNacional
ON Nacional
FOR INSERT
AS 
	DECLARE @VarNacional VARCHAR(8)
	SET @VarNacional =(SELECT Codigo FROM inserted)
	DECLARE @Conteo INT
	SET @Conteo=(
		SELECT COUNT(Codigo) 
		FROM Internacional 
		WHERE Codigo=@VarNacional)
	IF (@Conteo=0)
		BEGIN
			PRINT ('El registro se realizo correctamente')
		END
	ELSE
		BEGIN
			PRINT('No se puede ingresar por el ID ' + 
				CAST(@VarNacional AS NVARCHAR(10)) +
				'Ya existe el registro')
			ROLLBACK TRANSACTION
		END
DROP TRIGGER IntegridadNacional


CREATE TRIGGER IntegridadInternacional
ON Internacional
FOR INSERT
AS 
	DECLARE @VarInternacional VARCHAR(8)
	SET @VarInternacional =(SELECT Codigo FROM inserted)
	DECLARE @Conteo INT
	SET @Conteo=(
		SELECT COUNT(Codigo) 
		FROM Nacional
		WHERE Codigo=@VarInternacional)
	IF (@Conteo=0)
		BEGIN
			PRINT ('El registro se realizo correctamente')
		END
	ELSE
		BEGIN
			PRINT('No se puede ingresar por el ID ' + 
				CAST(@VarInternacional AS NVARCHAR(10)) +
				'Ya existe el registro')
			ROLLBACK TRANSACTION
		END

INSERT INTO Internacional VALUES ('NB_76245','Alemana',652,'25/12/2020')
INSERT INTO Nacional VALUES ('BN_24324','CDMX','FAGF220779112',56)

DELETE FROM Internacional WHERE (Codigo='NB_76245')
DELETE FROM Nacional WHERE (Codigo='BN_24324')

DROP TRIGGER IntegridadInternacional
SELECT * FROM Paquete
SELECT * FROM Internacional
SELECT * FROM Nacional

/*Crear Disparador para la tabla Camion
Permite dar de alta camiones con cargas menores a 250kg o mayores a 1250kg
Debera mandar un mesaje de la razon por la cual no se pudo ingresar camiones 
que no cumplan con lo establecido*/

CREATE TRIGGER ComprobacionCamion
ON Camion
FOR INSERT 
AS 
	DECLARE @Entrada INT
	SET @Entrada =(SELECT Carga_MAX FROM inserted)
	IF(@Entrada BETWEEN 250 AND 1250)
		BEGIN
			PRINT 'No se permite ingresar cargas menores a 250kg o mayores a 1250kg'
			ROLLBACK TRANSACTION
		END
	ELSE
		BEGIN
			PRINT 'El registro se realizo correctamente'
		END

INSERT INTO Camion VALUES ('123-ABC', 1251, 'CDMX');
INSERT INTO Camion VALUES ('234-XYZ', 249, 'CDMX');
INSERT INTO Camion VALUES ('249-CDS',999,'CDMX');

DELETE FROM Camion WHERE (Placa='123-ABC');
DELETE FROM Camion WHERE (Placa='234-XYZ');
DELETE FROM Camion WHERE (Placa='249-CDS')
DROP TRIGGER ComprobacionCamion

/*Crear Disparador para Nacional
Al ingresar un nuevo envio ingrese en otra tabla el id del envio y la ciudad
de destino y ademas muestre cuantos envios se han hecho a dicha ciudad destino
(en otras palabras que guarde en un campo en numero de envios)*/

CREATE TRIGGER Envio
ON Nacional
FOR INSERT
AS 
	DECLARE @idEnvio VARCHAR(8)
	SET @idEnvio =(SELECT Codigo FROM inserted)
	DECLARE @cdDestino VARCHAR(30)
	SET @idEnvio =(SELECT Ciudad_Destino FROM inserted)
	DECLARE @cantEnvios INT
	SET @cantEnvios =(
		SELECT COUNT(Ciudad_Destino) 
		FROM  Nacional
		GROUP BY Ciudad_Destino
		HAVING Ciudad_Destino=@cdDestino)
	INSERT INTO EnvioT VALUES (@idEnvio, @cdDestino) 
	BEGIN
		PRINT 'Los envios realizados a '+ @cdDestino+' son: '+ CAST(@cantEnvios AS INT)
	END


INSERT INTO Nacional VALUES ('AD_42562', 'Cuautitlan','GADM070860623', 55);
DELETE FROM Nacional WHERE (Codigo='AD_42562')

CREATE TABLE EnvioT(
idEnvio VARCHAR(8) NOT NULL,
cdDestino VARCHAR(30)
CONSTRAINT PK_EnvioT PRIMARY KEY (idEnvio))	 
	

DROP TRIGGER Envio