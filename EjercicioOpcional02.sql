--1 Productos igual a 18, 34, 17
SELECT * FROM Products
WHERE UnitPrice =18 or UnitPrice = 34 or UnitPrice = 17

SELECT ProductName FROM Products
WHERE UnitPrice =18 or UnitPrice = 34 or UnitPrice = 17


--2 Nombre de los productos que cuetan mas de 40m dolares y esten descontinuados y aun no haya vendido
SELECT ProductName FROM PRODUCTS
WHERE UnitPrice>40 and Discontinued=1 and  UnitsInStock!=0


--3 El producto y el vendedor del producto que tengamos menos de 10 unidades y que aun no se hay ordenado 
--mas meercancia
SELECT ProductName, SupplierID FROM PRODUCTS
WHERE unitsInStock<10 and UnitsOnOrder=0
	--5


--4 Que productos ya se han ordenado nuevamente
SELECT ProductName FROM PRODUCTS
WHERE UnitsOnOrder>0
	--17


--5 Que productos aun no se han ordenado a pesar de estar debajo del minimo de stock
SELECT ProductName FROM PRODUCTS
WHERE UnitsOnOrder=0 and UnitsInStock<ReorderLevel
	--1


--6 que proctos tiene mas de 100 unidades sin vender ty cuesta mas de 100
--o que productos que cuesten menos de 20 y se tenga mas de 100 unidades y ademas venga del proveedor1
SELECT ProductName FROM PRODUCTS
WHERE (UnitsInStock>100 and UnitPrice>100) or (UnitsInStock<20 and UnitPrice>100 and SupplierID=1)
	--0


--7 que productos se pidieron al proveedir 5 que surta nuevamente
SELECT ProductName FROM PRODUCTS
WHERE SupplierID=5 and UnitsOnOrder>0
	--1


--9 Se ha ordenado algo que no se necesitaba
SELECT ProductName FROM PRODUCTS
WHERE UnitsOnOrder>0 and UnitsInStock>ReorderLevel
	--0


--10 Los productos que tenemos con mas 40 unidades, pero menos de 100
SELECT ProductName FROM PRODUCTS
WHERE UnitsInStock>40 and UnitsInStock<100
	--15


--11 Que productos vendemos por onzas
SELECT ProductName,QuantityPerUnit FROM PRODUCTS
WHERE QuantityPerUnit LIKE '% oz %'
	--12

--12 Que productos se nos surten por caja o por bolsas
SELECT ProductName,QuantityPerUnit FROM PRODUCTS
WHERE QuantityPerUnit LIKE '%boxes%' or QuantityPerUnit LIKE '%bags%' 
	--14

--13 Los precios y productos donde el precio es cerrado (el precio no tiene valor en los decimales)
SELECT ProductName, UnitPrice FROM PRODUCTS
WHERE UnitPrice LIKE '%.00'
	--42

SELECT ProductName FROM PRODUCTS
WHERE ProductName LIKE '%Queso%'

--14  Que productios nos lo surten en cajas y por piezas
SELECT ProductName,QuantityPerUnit FROM PRODUCTS
--WHERE QuantityPerUnit LIKE '%boxes%pieces%' 
WHERE QuantityPerUnit LIKE '%boxes%' and QuantityPerUnit LIKE '%pieces%' 

--15  productos que se surten por paquete 'pkgs' y ademas esta abajo en stock
SELECT ProductName,QuantityPerUnit FROM PRODUCTS
WHERE QuantityPerUnit LIKE '%pkgs%' and UnitsInStock<ReorderLevel 

--16  Los productos que nos venden a partir de 100 piezas y ademas las unidades osn gramos g 
SELECT *FROM PRODUCTS
WHERE --UnitsOnOrder>=100 and 
QuantityPerUnit LIKE '100%'and QuantityPerUnit LIKE '%g%' 

