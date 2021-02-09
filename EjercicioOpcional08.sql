--DISPARADORES
/*1.- Para la tabla EnviosNacionales y EnviosInternacionales no se debe permitir insertar ningun regustro y se debera indicar
que la insercion de datos debe ser desde la tabla Envios*/
/*

CREATE TRIGGER Registro 
ON EnviosNacionales 
FOR INSERT
	PRINT('La insercion de datos debe ser desde la tabla envios')
 
SELECT *
INTO [Order Details01]
FROM [Order Details]
*/

/*2.- De la tabla Order Details No permitir que se borre mas de un registro al mismo tiempo*/
SELECT * FROM [Order Details01]
CREATE TRIGGER RegistroOD
ON [Order Details01]
FOR DELETE 
AS 
	DECLARE @regist INT
	SET @regist = (SELECT OrderID FROM deleted)
	DECLARE @i INT
	SET @i = (SELECT COUNT(OrderID) FROM [Order Details01] WHERE OrderID=@regist)
	IF (@i=1)
		PRINT ('Correcto')
	ELSE
	BEGIN
		PRINT ('No se pueden eliminar mas de un registro simultaneamente')
		ROLLBACK TRANSACTION
	END


/*3.- No permitir que se actualice el nombre de la compañia del proveedor*/
SELECT *
INTO Suppliers01
FROM Suppliers
CREATE TRIGGER NoActualizar
ON SuppliersO1
FOR UPDATE
AS
IF UPDATE(CompanyName)
	BEGIN
		PRINT('No se puede actualizar la columna CompanyName')
		ROLLBACK TRANSACTION 
	END 
--
CREATE TRIGGER NoActualizar
ON SuppliersO1
INSTEAD OF INSERT --En lugar de 
AS 
BEGIN
	PRINT ('No se puede actualizar la columna CompanyName')
END


/*4.- Cuando se relaice una venta (se genera un nuevo registro en detalle de orden) verificar contra nuestro stock y reducir nuestro 
stock para los productos que se han venido, en caso de que lo vendido supere el numero de productos en stock enviar un mensaje que 
no hay suficiente producto y no procesar la transaccion*/
SELECT *
INTO Products01
FROM Products 
CREATE TRIGGER verificarStock
ON [Order Details01]
FOR INSERT
AS
	DECLARE @stock INT 
	DECLARE @cantidad INT 
	SET @stock =(
		SELECT UnitsInStock
		FROM Products01
		JOIN inserted ON inserted.ProductID*Products01.ProductID)
	SET @cantidad=(SELECT Quantity FROM inserted)
	IF(@cantidad>@stock)
		BEGIN
			PRINT 'No hay suficiente producto'
			ROLLBACK TRANSACTION
		END
	ELSE 
		BEGIN
			SET @stock=@stock-@cantidad
			UPDATE Products01
			SET UnitsInStock=@stock
			WHERE ProductID=(
				SELECT ProductID 
				FROM inserted)
			PRINT 'Venta realizada'
		END
INSERT INTO [Order Details01]
VALUES (11078,1,7.00,4,0)


--PROCEDIMIENTOS ALMACENADOS
/*5.- Crear un SP ára cambiar el Stock de un producto  EXEC_SP_cambiarStock(ID_Producto, NuevoStock)*/
CREATE PROCEDURE SP_ListarProducto
@nombre_Produc nvarchar(30)
AS
	begin
		SELECT * FROM Products01
		WHERE ProductName = @nombre_Produc
	END
EXEC SP_ListarProducto Chai
SELECT * FROM Products01
DROP PROCEDURE SP_ListarProducto


/*6.- Crear un SP que muestre todo sobre un producto que busque un cliente
Nota: el cliente puede ingresar parte del nombre del producto, en otras palabra mostrar todo 
lo que coincida con lo ingresado por el cliente. EXEC SP_ListarProducto(crema)*/
CREATE PROCEDURE SP_ListarProducto 
@NombreProducto VARCHAR(20)
AS 
	SELECT *
	FROM Products P
	WHERE P.ProductName LIKE CONCAT('%',@NombreProducto,'%')
EXEC SP_ListarProducto 'queso'
SELECT * FROM Products


/*7.- Mostrar cuantas ordenes a realizado cada empleado(mostrar nombre, apellidos y número de pedidos) 
que sean mayores al parámetro indicado. EXEC SP_NumOrdenesEmpleado(15) */
CREATE PROCEDURE SP_NumOrdenesEmpleado
@no_ordenes INT
AS
	BEGIN 
		SELECT LastName, FirstName, Title,ordenes FROM(
			SELECT EmployeeID,COUNT ( EmployeeID ) AS ordenes 
			FROM Orders
		GROUP BY EmployeeID) AS totales 
		FULL JOIN Employees e
		ON  (totales.EmployeeID = e.EmployeeID)
		WHERE ordenes > @no_ordenes
	END 
EXEC SP_NumOrdenesEmpleado 60