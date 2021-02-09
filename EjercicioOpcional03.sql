/*1.- ¿La LADA de España es la misma para todas sus ciudades?*/
SELECT * FROM Customers
WHERE Country='Spain'

/*2.- Los donde los telefonos tengan lada y ademas el telefono y su Fax sean diferentes*/
SELECT * FROM Customers
WHERE Phone LIKE '(%)%' AND Phone<>Fax 

/*3.- Los registros donde los telefonos no contienen lada y en vez de guiones puuntos*/
SELECT PostalCode FROM Customers
WHERE Phone NOT LIKE '(%' AND Phone LIKE '%.%'--like '_.%'

/*4.- El codigo postal que no contiene ninguna letras, Solo debe tener numeros*/
SELECT PostalCode FROM Customers
WHERE PostalCode NOT LIKE '%[A-Z]%'

/*5.- ¿Que clientes tenen asignados una region y ademas esta definida por solo iniciales?*/
SELECT Region FROM Customers
WHERE Region IS NOT NULL AND  Region LIKE '[A-Z][A-Z]'

/*6.- ¿Que clientes no tienen region y ademas su telefono y fax son el mismo?*/
SELECT ContactName FROM Customers
WHERE Region IS NULL AND phone=Fax