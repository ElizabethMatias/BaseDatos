/* 1.- Listar el nombre de los productos para los cuales la categoría a la que pertenecen
tiene más de 350 unidades en Stock.*/
SELECT * FROM [Products]
WHERE CategoryID IN
(SELECT CategoryID FROM [dbo].[Products]
GROUP BY CategoryID
HAVING SUM(UnitsInStock)>350) AS NewTable


/*2.- Listar toda la información para los productos donde para su categoría el dinero que se 
tienen en stock esta entre 3500 y 4000 dólares.*/
SELECT * 
FROM Products
WHERE CategoryID IN(
	SELECT CategoryID FROM Products
	GROUP BY CategoryID
	HAVING SUM(UnitsInStock*UnitPrice)>3500 AND SUM(UnitsInStock*UnitPrice)<4000)

	/*a.- El nombre de las categorías que cumplen lo anterior*/
SELECT CategoryName, CategoryID
FROM Categories
WHERE CategoryID IN(
	SELECT CategoryID 
	FROM Products
	GROUP BY CategoryID
	HAVING SUM(UnitsInStock*UnitPrice)>3500 AND SUM(UnitsInStock*UnitPrice)<4000); 

	/*b.- Mostrar ahora el nombre de las categorías y además el dinero en stock de cada categoría.*/
SELECT CategoryName,(
	SELECT SUM(UnitsInStock*UnitPrice)
	FROM Products
	GROUP BY CategoryID
	HAVING SUM(UnitsInStock*UnitPrice)>3500 AND SUM(UnitsInStock*UnitPrice)<4000
	)
FROM Categories 
WHERE CategoryID IN (
	SELECT CategoryID
	FROM Products
	GROUP BY CategoryID
	HAVING SUM(UnitsInStock*UnitPrice) BETWEEN 3500 AND 4000
	)

	/*c.- Todo lo anterior pero ahora para el proveedor.*/
SELECT ContactName,(
	SELECT T.TotalStock 
		FROM (SELECT SupplierID, SUM(UnitsInStock*UnitPrice) AS TotalStock FROM Products
		GROUP BY SupplierID
		HAVING SUM(UnitsInStock*UnitPrice)BETWEEN 3500 AND 4000) AS T
		WHERE T.SupplierID = S.SupplierID)
FROM Suppliers AS S
WHERE SupplierID IN(SELECT SupplierID
	FROM Products
	GROUP BY SupplierID HAVING SUM(UnitsInStock*UnitPrice)BETWEEN 3500 AND 4000
	)


/*3.- Que categorias son las que su promedio de dinero en stock es mayor al promedio generar de dinero en stock*/
SELECT AVG(UnitsInStock*UnitPrice),CategoryID AS Category
FROM Products
GROUP BY CategoryID 
HAVING AVG(UnitsInStock*UnitPrice) > (
	SELECT AVG(UnitsInStock*UnitPrice) AS Prom
	FROM Products)


/*4.- Las categorias donde el promedio de todo lo nuevamente ordenado supera el 10% de lo que se tiene en stock por categoria
Las categorias donde el promedio de lo reordenado es mayor del 10% de lo que se tiene en stock*/
SELECT SUM(UnitsInStock),CategoryID
FROM Products
GROUP BY CategoryID 
HAVING SUM(UnitsInStock)*0.1 < (
	SELECT AVG(UnitsOnOrder) AS Prom
	FROM Products WHERE UnitsOnOrder<>0
)


/*5.- Listar toda la informacaion de los productos suministrados por los proveedores a los que no se les ha pedido nuevamente ninguna
orden de ningun producto*/
SELECT * 
FROM Products
WHERE SupplierID IN(
	SELECT SupplierID 
	FROM(
		SELECT COUNT(ReorderLevel) AS A, SupplierID,(
			SELECT COUNT(P1.ReorderLevel), P1.SupplierID 
			FROM Products AS P1
			GROUP BY P1.SupplierID
		) 
		FROM Products 
		WHERE ReorderLevel <> 0 
		GROUP BY SupplierID
	) AS S
	WHERE P1.SupplierID = S.SupplierID
)


/*6.- Agregar una columna temporal "Venta" que es el precio de venta final al cual se le debe ganar el 50% del precio unitario de compra,
lo anterior solo aplica para los productos de la categoria con el precio mas bajo.*/
SELECT *, (
	SELECT R.Precio
	FROM (
		SELECT ProductID, SUM(UnitPrice*1.5) AS Precio
		FROM Products
		GROUP BY ProductID) AS R
	WHERE R.ProductID = P.ProductID
	) AS VENTA --unitprice 1.5 as venta
FROM Products AS P
WHERE CategoryID IN (
	SELECT CategoryID
	FROM Products 
	WHERE UnitPrice IN (
		SELECT MIN(UnitPrice)
		FROM Products
	)
)


/*7.- ¿De que proveedor tememos mas dinero en almacen? Listar tambien el dinero.Un solo registro*/
SELECT SupplierID, SUM(UnitPrice*UnitsInStock)
FROM Products
GROUP BY SupplierID
HAVING SUM(UnitPrice*UnitsInStock)=(
	SELECT MAX(R.T)
	FROM(
		SELECT SupplierID, SUM(UnitPrice*UnitsInStock) AS T
		FROM Products
		GROUP BY SupplierID 
	) AS R
)