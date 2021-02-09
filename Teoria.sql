--VARIABLES DE USUARIO
DECLARE @Mi_Variable nvarchar(5)--Declaro la variable
SET @Mi_Variable = 10--Asigno algun valor
SELECT @Mi_Variable--Puedo utilizar eñ valor de la variable
--
DECLARE @Otra_Variable nvarchar(5), @Resultado nvarchar(5)
SET @Otra_Variable = 5
--
SET @Resultado =@Otra_Variable+@Mi_Variable--concatena
SELECT @Resultado
--
SET @Resultado =@Otra_Variable + 10--suma 
SELECT @Resultado
--
SET @Resultado =@Otra_Variable + '10'--suma 
SELECT @Resultado
---
DECLARE @num01 integer, @num02 integer, @Result integer
SET @num01=5
SET @num02=25
SET @Result=@num01+@num02
SELECT @Result
---Asignar el resultado de una sub consulta a un variable
SET @Result=(
	SELECT COUNT(*)
	FROM Products)
SELECT @Result


--LENGUAJE DE CONTROL DE DATOS 
IF (5<=(SELECT COUNT(*) FROM Products))
	BEGIN 
		PRINT 'ENTRO AL IF'
		--Sentencia de SQL
	END
ELSE
	BEGIN
		PRINT 'ENTRO AL ELSE'
		--Sentencia de SQL
	END
--
IF (4<5)
	BEGIN 
		PRINT 'ENTRO AL IF'
		SELECT  ProductName FROM Products
	END
ELSE
	BEGIN
		PRINT 'ENTRO AL ELSE'
		SELECT  CompanyName FROM Suppliers
	END
--
DECLARE @NumOrder nvarchar(10)
DECLARE @TotalFactura float
SET @NumOrder=10250
SET @TotalFactura=(SELECT SUM(UnitPrice*Quantity)AS precioSinDescuento FROM[Order Details])
IF (@TotalFactura)<1000
	BEGIN 
		PRINT('Se le aplicara un descuento de 10%')
		PRINT('Usted pagara un total de ' + CAST((@TotalFactura)*.10 AS varchar(10)))
	END
ELSE 
	BEGIN
		PRINT('Se le aplicara un descuento de 20%')
		PRINT('Usted pagara un total de ' + CAST((@TotalFactura)*.20 AS varchar(10)))
	END


--------------------------------------------------------------------------------------------------------------------
--TRANSACCIONES
SELECT*
INTO ProductosEjercicio
FROM Products 
--
DECLARE @TransactionName varchar(20) = 'Transaction1';
BEGIN TRAN @TransactionName
	UPDATE ProductosEjercicio
	SET UnitsInStock=5
	WHERE ProductID=2
	UPDATE ProductosEjercicio
	SET UnitPrice=5
	WHERE ProductID=2
	--ROLLBACK OR COMMIT
--
SELECT *FROM ProductosEjercicio
WHERE ProductID=2
--
DECLARE @TransactionName varchar(20) = 'Transaction1';
ROLLBACK TRAN @TransactionName
DECLARE @TransactionName varchar(20) = 'Transaction1';
COMMIT TRAN @TransactionName
/**/
BEGIN TRAN MyTransaccion
	UPDATE ProductosEjercicio
	SET UnitsInStock=5
	WHERE ProductID=2
ROLLBACK TRAN MyTransaccion
COMMIT TRAN MyTransaccion

--------------------------------------------------------------------------------------------------------------------
--DISPARADORES
--Crear un disparador que al ingresar un registro dentro de la tabla Ventas, disminuya nuestro stock
/*CREATE TRIGGER VerificarStock
ON ventas 
FOR insert AS
	DECLARE @stock INT
	DECLARE @cantidadComprada INT--Cuantas unidades de un desterminado libro se compraron
	--JOIN para saber cuantas unidades tenemos en stock del libro comprado 
	SET @cantidadComprada=(select cantidad FROM inserted)
	IF(@stock>=@cantidadComprada)
		UPDATE libros
		JOIN inserted 
		ON inserted.codigolibro=libro.codigo
		--where codigo=inserted.codigolibro
	ELSE
	BEGIN
		RAISERROR('Hay menos libros en stock  de los solicitados para ala venta', 16,1)
		--puede poner un simple print
		--PRINT('Hay menos libros en stock de los solicitados para la venta')
		ROLLBACK TRANSACTION
	END*/

CREATE TABLE Nacional(
ID INT NOT NULL,
DIRECCION varchar (10),
PRIMARY KEY (ID))

CREATE TABLE Internacional(
id INT NOT NULL,
pais varchar (10),
PRIMARY KEY (id))

SELECT * FROM Nacional
SELECT * FROM Internacional

CREATE TRIGGER VerificarEnNacional
ON Nacional
FOR INSERT 
AS 
	DECLARE @ID_Nacional int
	SET @ID_Nacional = (SELECT id FROM inserted)
	DECLARE @Conteo int
	SET @Conteo=(SELECT COUNT(ID) FROM Internacional WHERE ID=@ID_Nacional)
	IF (@Conteo=0)
		BEGIN
			PRINT ('El registro se realizo correctamente')
		END
	ELSE
		BEGIN
			PRINT('No se puede ingresar por el ID ' + 
				CAST(@ID_Internacional AS NVARCHAR(10)) +
				'Ya existe el registro')
			ROLLBACK TRANSACTION
		END

DROP TRIGGER VerificarEnNacional
INSERT INTO Internacional VALUES(1,'USA')
INSERT INTO Nacional VALUES(5,'CDMX')
INSERT INTO Internacional VALUES(3,'URSS')

