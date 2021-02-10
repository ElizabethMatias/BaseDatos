/*Cruz Matias Yuridia Elizabeth
3er Examen Parcial Base de Datos*/

--1a Mostrar la cantidad de productos en stock que se tiene por proveedor. Ordenarlo de MAYOR A MENOR 
SELECT SupplierID, SUM(UnitsInStock) AS Total
FROM Products
GROUP BY SupplierID
ORDER BY SUM(UnitsInStock) DESC

--1b Ahora quiero saber el nombre del proveedor. 
SELECT CompanyName, SUM(UnitsInStock) AS Total
FROM Products AS tbl1 INNER JOIN Suppliers AS tbl2
ON(tbl1.SupplierID=tbl2.SupplierID)
GROUP BY CompanyName
ORDER BY SUM(UnitsInStock) DESC

--2a Mostrar el máximo y el mínimo del precio de los productos por proveedor y también mostrar el nombre de la compañía proveedora. 
SELECT CompanyName, MAX(UnitPrice) AS Maximo, MIN(UnitPrice) AS Minimo
FROM Products AS tbl1 INNER JOIN Suppliers AS tbl2
ON(tbl1.SupplierID=tbl2.SupplierID)
GROUP BY CompanyName

--2b Mostrar solo los registros que para un precio Máximo menor a 200 y un precio mínimo mayor a 30. 
SELECT CompanyName, MAX(UnitPrice) AS Maximo, MIN(UnitPrice) AS Minimo
FROM Products AS tbl1 INNER JOIN Suppliers AS tbl2
ON(tbl1.SupplierID=tbl2.SupplierID)
GROUP BY CompanyName
HAVING MAX(UnitPrice) < 200 AND MIN(UnitPrice)>30

--3 Ejercicio ¿De que Proveedor tenemos más dinero en almacén? Un solo registro sin uso de TOP
SELECT SupplierID, SUM(UnitPrice*UnitsInStock) AS TotalDinero
FROM Products
GROUP BY SupplierID
HAVING SUM(UnitPrice*UnitsInStock)=(
	SELECT MAX(Tabla.Total)
	FROM(
		SELECT SupplierID, SUM(UnitPrice*UnitsInStock) AS Total
		FROM Products
		GROUP BY SupplierID
	) AS Tabla
)

--4a Listar las ciudades y el país en donde tenemos clientes. 
SELECT DISTINCT Country, City
FROM Customers

--4b Lo anterior pero ahora mostrando la región , si no tiene región no mostrar el registro. 
SELECT DISTINCT Country, City, Region
FROM Customers
WHERE Region IS NOT NULL

/*5a Listar todas las columnas de la tabla productos y además agregar una columna temporal “Venta” que es el 
precio de venta final al cual se le debe ganar el 15% del precio unitario de compra, lo anterior solo aplica 
para los productos de la categoría con el precio más alto*/
SELECT *,(
	SELECT Tabla.Precio
	FROM(
		SELECT ProductID, SUM(UnitPrice*0.15 + UnitPrice) AS Precio
		FROM Products
		GROUP BY ProductID
	) AS Tabla
	WHERE Tabla.ProductID=P.ProductID
) AS VENTA 
FROM Products AS P
WHERE CategoryID IN (
	SELECT CategoryID
	FROM Products
	WHERE UnitPrice IN(
		SELECT MAX(UnitPrice)
		FROM Products
	)	
)

--5b Del inciso a ahora mostrar Nombre del producto, nombre de la compañía del proveedor, la ciudad del proveedor y la columna calculada “Venta” 
SELECT P.ProductName,S.CompanyName, S.City,(
	SELECT Tabla.Precio
	FROM(
		SELECT ProductID, SUM(UnitPrice*0.15 + UnitPrice) AS Precio
		FROM Products
		GROUP BY ProductID
	) AS Tabla
	WHERE Tabla.ProductID=P.ProductID
) AS VENTA 
FROM Products AS P INNER JOIN Suppliers AS S
ON(S.SupplierID=P.SupplierID)
WHERE CategoryID IN (
	SELECT CategoryID
	FROM Products
	WHERE UnitPrice IN(
		SELECT MAX(UnitPrice)
		FROM Products
	)	
)