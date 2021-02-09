/*1. Se requiere mostrar las ordenes con los productos quqe contiene cada orden, se debe mostrar id de la ordenes, 
el descuento de producto, nombre del producto.*/
SELECT Tbl1.*, Tbl2.ProductName
FROM[Order Details] AS Tbl1 FULL JOIN Products AS Tbl2
ON (Tbl1.ProductID=Tbl2.ProductID)


/*2. Mostrar que productos proveen cada compañia, mostrar producto y nombre de la compañia, ordenar por nombre de compañia.*/
SELECT Tbl1.CompanyName, Tbl2.ProductName
FROM Suppliers AS Tbl1 FULL JOIN Products AS Tbl2
ON (Tbl1.SupplierID=Tbl2.SupplierID)
ORDER BY CompanyName


/*3. Calcular el dinero	que tenemos en stock por cada proveedor, mostrar la cantidad de dinero y el nombre de la compañia.*/
SELECT Tbl1.SupplierID, SUM(Tbl2.UnitPrice*Tbl2.UnitsInStock) AS Total, Tbl1.CompanyName
FROM Suppliers AS Tbl1 FULL JOIN Products AS Tbl2
ON (Tbl1.SupplierID=Tbl2.SupplierID)
GROUP BY Tbl1.SupplierID,Tbl1.CompanyName
ORDER BY Tbl1.CompanyName


/*4. Se requiere saber la descripcion de la categoria de cada producto que se encuentra en los detalles de orden.*/
SELECT Tbl2.ProductName, Tbl2.CategoryID, Tbl1.Description
FROM Categories AS Tbl1 
	INNER JOIN Products AS Tbl2 
		ON Tbl1.CategoryID=Tbl2.CategoryID 
	INNER JOIN [Order Details] AS Tbl3 
		ON Tbl2.ProductID=Tbl3.ProductID
ORDER BY Tbl2.ProductName

SELECT * FROM Products
SELECT * FROM [Order Details]
SELECT * FROM Suppliers


/*5.- Calcular el total de dinero por ventas hechas a cada pais.*/
SELECT Tbl2.ShipCountry AS Pais, SUM(Tbl1.Quantity*Tbl1.UnitPrice) AS Total
FROM [Order Details] AS Tbl1 
	FULL JOIN Orders AS Tbl2 
		ON Tbl1.OrderID=Tbl2.OrderID
GROUP BY Tbl2.ShipCountry
ORDER BY SUM(Tbl1.Quantity*Tbl1.UnitPrice) DESC

	--a. ¿Cual es el pais en donde se ha vendido mas?
	--b. ¿Mexico que lugar ocupa?

/*SELECT Tbl1.Country, SUM(Tbl3.Quantity*Tbl2.UnitPrice) AS Total
FROM Suppliers AS Tbl1 
	FULL JOIN Products AS Tbl2 
		ON Tbl1.SupplierID=Tbl2.SupplierID
	FULL JOIN [Order Details] AS Tbl3 
		ON Tbl2.ProductID=Tbl3.ProductID
GROUP BY Tbl1.Country
ORDER BY SUM(Tbl3.Quantity*Tbl3.UnitPrice) DESC*/

/*6.- Se cometio un error por un empleado y algunos precios no son los correctos en los detalles de las ordenes, 
el precio por unidad en el detalle de las ordenes debe coincidir con el precio unitario de los productos.
Determinar en que ordenes el precio por unidad no coincide, dar una posible explicacion.*/
SELECT Tbl1.OrderID, Tbl2.UnitPrice, Tbl1.UnitPrice
FROM [Order Details] AS Tbl1 
	FULL JOIN Products AS Tbl2 
		ON Tbl1.ProductID=Tbl2.ProductID
WHERE Tbl1.UnitPrice<>Tbl2.UnitPrice AND Tbl1.OrderID=10360
GROUP BY Tbl1.OrderID
ORDER BY Tbl1.OrderID ASC

	--a. ¿En cuantas ordenes se cometio el error de precios?
	SELECT COUNT(T.OrderID) FROM (
			SELECT Tbl1.OrderID 
			FROM [Order Details] AS Tbl1 
				FULL JOIN Products AS Tbl2 
					ON Tbl1.ProductID=Tbl2.ProductID
			WHERE Tbl1.UnitPrice<>Tbl2.UnitPrice
			GROUP BY Tbl1.OrderID) AS T

	--b. ¿Cuantos errores se cometieron por orden?
	SELECT Tbl1.OrderID, COUNT(Tbl1.OrderID) AS Errores
		FROM [Order Details] AS Tbl1 
			FULL JOIN Products AS Tbl2 
				ON Tbl1.ProductID=Tbl2.ProductID
		WHERE Tbl1.UnitPrice<>Tbl2.UnitPrice
		GROUP BY Tbl1.OrderID


/*7.- Listar los proveedores(nombre del proveedor)dependiendo de que proveedor vendemos mas productos (mas unidades, no tipos de productos)
ordenarlo de mayor a menor*/
SELECT Tbl1.CompanyName, SUM(Tbl3.Quantity)--, Tbl1.ContactName
	FROM Suppliers AS Tbl1 
		FULL JOIN Products AS Tbl2 
			ON Tbl1.SupplierID=Tbl2.SupplierID
		FULL JOIN [Order Details] AS Tbl3
			ON Tbl3.ProductID=Tbl2.ProductID
	GROUP BY Tbl1.CompanyName--Tbl1.ContactName
	ORDER BY SUM(Tbl3.Quantity) DESC


/*8.- Suponiendo que ya se ha encontrado el probñlema del ejercico 6 ahora se debe determinar cuanto dinero estamos perdiendo en cada orden,
ordenar por mayor perdida*/
	SELECT Tbl1.OrderID, SUM((Tbl2.UnitPrice-Tbl1.UnitPrice)*Tbl1.Quantity) AS Dinero
		FROM [Order Details] AS Tbl1
			FULL JOIN Products AS Tbl2 
				ON Tbl1.ProductID=Tbl2.ProductID
		WHERE Tbl1.UnitPrice<>Tbl2.UnitPrice
		GROUP BY Tbl1.OrderID
		ORDER BY Dinero DESC