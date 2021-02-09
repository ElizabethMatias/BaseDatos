/*1.- ¿En cuantas ciudades tenemos clintes?*/
SELECT DISTINCT Country 
FROM Customers


/*2.- Quiero los clientes que tenemos por pais y ciudad*/
SELECT DISTINCT Country, City
FROM Customers


/*3.- Quiero los clientes que tenemos por pais ciudad, region y ademas tiene asignada una region*/
SELECT DISTINCT Country, City
FROM Customers
WHERE Region IS NOT NULL

/*4.- Nombre de contacto de los clientes, pero ordenado por nombre*/
SELECT ContactName
FROM Customers
ORDER BY ContactName


/*5.- De esos clientes Hungry Coyote Import Store, Hungry Owl All-Night Groces, Island Trading, Koniglich Essen
¿A cual le falta? Region, PostalCode, Country, Phone, Fax*/
SELECT * 
FROM Customers AS C
WHERE C.CompanyName IN ('Hungry Coyote Import Store', 'Hungry Owl All-Night Grocers', 'Island Trading', 'Königlich Essen')
AND (C.Region IS NULL OR C.PostalCode IS NULL OR C.Country IS NULL OR C.Phone IS NULL OR C.Fax IS NULL)