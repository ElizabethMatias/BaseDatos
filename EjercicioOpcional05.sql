/*1.- Determinar la cantidad de producto en stock que tenemos por proveedor 
Presentarlo de la mayor cantidad a la menor*/
SELECT P.SupplierID, COUNT(P.UnitsInStock) AS Cantidad
FROM Products AS P
GROUP BY P.SupplierID
ORDER BY Cantidad DESC


/*2.- ¿De que proveedor tenemos mas dinero en almacen?*/
SELECT P.SupplierID, SUM(P.UnitPrice*UnitsInStock) AS Dinero
FROM Products AS P
GROUP BY P.SupplierID
ORDER BY Dinero DESC


/*3.- Necesitamos saber cuantas ordenes le hemos hecho a cada proveedor*/
SELECT P.SupplierID, COUNT(P.UnitsOnOrder)
FROM Products AS P
GROUP BY P.SupplierID


/*4.- ¿Cuanto dinero hemos pagado a cada proveedor por los prodiuctos de las ordenes? Que tenemos en almacen */
SELECT P.SupplierID, SUM(P.UnitPrice)--*P.UnitsOnOrder
FROM Products AS P
GROUP BY P.SupplierID


/*5.- ¿Cuantas categorias de producto tenemos?*/
SELECT Distinct CategoryID
FROM Products


/*6.- ¿Cuantos productos diferentes tenemos por categoria?*/
SELECT CategoryID, COUNT(CategoryID)
FROM Products
GROUP BY CategoryID


/*7.- Se necesita saber cuanto dinero tenemos en stock por cada categoria y por proveedor, mostrar 
el resultado primero todo por la cateria uno y despues todo por categoria dos asi hasta la categoria 8*/
SELECT P.Categoryid, P.SupplierID, SUM(P.UnitPrice*P.CategoryID*P.SupplierID)
FROM Products AS P
GROUP BY P.SupplierID, P.CategoryID


/*8.- Se necesita un reporte para saber por categoria el total de los niveles minimos para re ordenar mas producto
En otras palabras, de que categoria debemos tener niveles altos de stock*/
SELECT P.CategoryID, SUM(UnitsInStock), SUM(ReorderLevel)
FROM Products AS P
GROUP BY P.CategoryID 
HAVING SUM(UnitsInStock)>SUM(ReorderLevel)


/*9.- De la pregunta 7 ahora solo se requiere repotar aquellos resultados donde el dinero stock sea mayor a 3 mil dolares*/ 
SELECT P.Categoryid, P.SupplierID, SUM(P.UnitPrice*P.UnitsInStock) AS R
FROM Products AS P
GROUP BY P.SupplierID, P.CategoryID
HAVING SUM(P.UnitPrice*P.UnitsInStock)>3000
ORDER BY R


 /*10. De la pregunta 6*/
	--a. Ahora tambien se requiere saber el dinero en stock, Primer Reporte
	SELECT CategoryID, COUNT(CategoryID), SUM(UnitsInStock*UnitPrice)
	FROM Products
	GROUP BY CategoryID
	--b. El segundo reporte spñp se reqiuiere los registrosdonde la categoria tiene mas de 7 productos
	SELECT CategoryID, COUNT(CategoryID)
	FROM Products
	GROUP BY CategoryID
	HAVING COUNT (CategoryID)>7 
	--c. Tercer reporte, todo lo anterior pero donde el dinero en Stock es mas de 11 mil dolares
	SELECT CategoryID, COUNT(CategoryID), SUM(UnitsInStock*UnitPrice)
	FROM Products
	GROUP BY CategoryID
	HAVING COUNT (CategoryID)>7 AND SUM(UnitsInStock*UnitPrice)>11000

SELECT * FROM [Order Details] 


 /*11.- Un reporte por empleado del total de ordenes atendidas desglosado por numero
 de ordenes y tipo de envio, pero solo  de las ordenes que superan las 30*/
SELECT EmployeeID, ShipVia, COUNT(EmployeeID)
FROM Orders
GROUP BY EmployeeID, ShipVia
HAVING COUNT(EmployeeID)>30
ORDER BY EmployeeID ASC


/*12.- En algunas ordenes ciertos productos tienen descuento, generar un reporte que muestre el subtotal a pagar 
de cada orden (el subtotal es el precio total sin aplicar descuento), el total a pagar (total es el precio final 
ya que con el descuento aplicado) el descueto aplicado(cuanto dinero se deconto), todo lo anterior solopara las 
ordenes donde el descuto (dinero ahorrado) no supere el 20% de la venta del subtotal*/ 
SELECT O.OrderID, 
SUM(O.Quantity*O.UnitPrice) AS subtotal, 
SUM(O.Quantity*O.UnitPrice*O.Discount) AS descuento, 
SUM(O.Quantity*O.UnitPrice-O.Quantity*O.UnitPrice*O.Discount) AS total,
SUM(O.Quantity*O.UnitPrice*0.20) AS veinte
FROM [Order Details] AS O
GROUP BY O.OrderID
HAVING SUM(O.Quantity*O.UnitPrice*0.20)>=SUM(O.Quantity*O.UnitPrice*O.Discount)
	--a Agregar la restriccion "Y ahora ademas que las ordenes tengan al menos un producto con descuento"				
	SELECT O.OrderID, 
	SUM(O.Quantity*O.UnitPrice) AS subtotal, 
	SUM(O.Quantity*O.UnitPrice*O.Discount) AS descuento, 
	SUM(O.Quantity*O.UnitPrice-O.Quantity*O.UnitPrice*O.Discount) AS total,
	SUM(O.Quantity*O.UnitPrice*0.20) AS veinte
	FROM [Order Details] AS O                   
	GROUP BY O.OrderID
	HAVING SUM(O.Quantity*O.UnitPrice*0.20)>=SUM(O.Quantity*O.UnitPrice*O.Discount) AND MIN(O.Discount)>0
--AND SUM(UnitPrice*Discount)>0