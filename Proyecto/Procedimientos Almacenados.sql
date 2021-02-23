--//PROCEDIMIENTOS ALMACENADOS//
-----------------------------------------------------------------------------------------------------
/* Se debera crear un procedimiento almacenado el cual tendra como entrada el codigo de 
algun paquete-envio
Este procedimiento debera mostrar lo siguiente:
	1. el Id 
	2. Tipo de envio (Nacional o Internacional)
		a. Si es nacional
			i. Direccion	
			ii. Peso	
			iii. El conductor al que le fue asignado el paquete
			iv. Ruta
			v. Placas del Camion    --Camion
			vi. Fecha (entre conductor y camion)
		b. Si es internacional
			i. Direccion
			ii. Linea Aerea
			iii. Y el codigo de la compañia local */

CREATE PROCEDURE SP_DatosEnvio
@Envio VARCHAR(8)
AS
	DECLARE @ConteoN INT 
	SET @ConteoN=(SELECT COUNT(Codigo) FROM Nacional WHERE Codigo=@Envio)
	IF (@ConteoN<>0)
		BEGIN
			PRINT 'Envio Nacional'
			SELECT tbl1.Codigo, tbl1.Direccion, tbl1.Peso, tbl3.Nombre, tbl_4.Nombre, tbl4.Fecha, tbl5.Placa
			FROM Paquete AS tbl1 
				INNER JOIN Nacional AS tbl2 ON (tbl1.Codigo=tbl2.Codigo)
				INNER JOIN Conductor AS tbl3 ON (Tbl2.RFC=tbl3.RFC)
				INNER JOIN Rutas AS tbl_4 ON (tbl3.ID_Ruta=tbl_4.ID_Ruta)
				INNER JOIN Conductor_Camion AS tbl4 ON(tbl3.RFC=tbl4.RFC)
				INNER JOIN Camion AS tbl5 ON(tbl4.Placa=tbl5.Placa)
			WHERE tbl1.Codigo=@Envio
		END
	ELSE
		BEGIN
			PRINT 'Envio Internacional'
			SELECT tbl1.Codigo, tbl1.Direccion, tbl2.Linea_Aerea, tbl3.Codigo_Local
			FROM Paquete AS tbl1 
				INNER JOIN Internacional AS tbl2 ON (tbl1.Codigo=tbl2.Codigo)
				INNER JOIN C_Local AS tbl3 ON (tbl3.Codigo_Local=tbl2.Codigo_Local)
			WHERE tbl1.Codigo=@Envio
		END

EXEC SP_DatosEnvio 'AD_42562'
EXEC SP_DatosEnvio 'NW_61663'

SELECT * FROM Nacional
SELECT * FROM Internacional

DROP PROCEDURE SP_DatosEnvio 

/*DECLARE @ConteoI INT 
	SET @ConteoI=(SELECT COUNT(Codigo) FROM Nacional WHERE Codigo=@Envio)
	IF(@ConteoI<>0)*/