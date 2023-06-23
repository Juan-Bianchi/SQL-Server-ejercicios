-- 0. SETEO DE DB
USE ejercicio2
GO

--1.	Hallar el código (nroProv) de los proveedores que proveen el artículo a146.

--2.	Hallar los clientes (nomCli) que solicitan artículos provistos por p015.

--3.	Hallar los clientes que solicitan algún item provisto por proveedores con categoría mayor que 4.

--4.	Hallar los pedidos en los que un cliente de Rosario solicita artículos producidos en la ciudad de Mendoza.

--5.	Hallar los pedidos en los que el cliente c23 solicita artículos solicitados por el cliente c30.

--6.	Hallar los proveedores que suministran todos los artículos cuyo precio es superior al precio promedio de los artículos que se producen en La Plata.

--7.	Hallar la cantidad de artículos diferentes provistos por cada proveedor que provee a todos los clientes de Junín.

-- todos los clientes de junin
SELECT COUNT (NroCli)
FROM CLIENTE 
WHERE CiudadCli like 'Jun_n'

-- prov que prov a todos los clientes de junin
SELECT NroProv, COUNT(DISTINCT C.NROCLI) AS [Cant de clientes]
FROM PEDIDO p JOIN Cliente c ON p.NroCli = c.NroCli
WHERE CiudadCli like 'Jun_n'
GROUP BY NroProv
HAVING COUNT(DISTINCT C.NROCLI)  = (
									SELECT COUNT (NroCli)
									FROM CLIENTE 
									WHERE CiudadCli like 'Jun_n'
									)
order by NroProv

-- todos los articulos dif que prov. los prov.
SELECT DISTINCT NroProv, NroArt
FROM pedido
ORDER BY NroProv

--Hallar la cantidad de artículos diferentes provistos por cada proveedor que provee a todos los clientes de Junín.


SELECT T.*, A.NroArt
FROM 
	(
	SELECT NroProv, COUNT(DISTINCT C.NROCLI) AS [Cant de clientes]
	FROM PEDIDO p JOIN Cliente c ON p.NroCli = c.NroCli
	WHERE CiudadCli like 'Jun_n'
	GROUP BY NroProv
	HAVING COUNT(DISTINCT C.NROCLI)  = (
										SELECT COUNT (NroCli)
										FROM CLIENTE 
										WHERE CiudadCli like 'Jun_n'
										)
	) AS T 
	JOIN 
	(
	SELECT DISTINCT NroProv, NroArt
	FROM pedido
	) AS A
	ON T.NroProv = A.NroProv

order by T.NroProv


--8.	Hallar los nombres de los proveedores cuya categoría sea mayor que la de todos los proveedores que proveen el artículo cuaderno.

-- PROV CON LA CATEGORIA MAYOR

SELECT *
FROM Proveedor
WHERE Categoria = (
					SELECT  MAX(categoria) as maxCategoria
					FROM Proveedor
				  )
ORDER BY NroProv

-- PROV DE ART CUADERNO

SELECT distinct p.NroProv
FROM Articulo a 
JOIN Pedido p ON a.NroArt = p.NroArt
WHERE Descripcion like '%cuaderno%' -- cuaderno tapa dura | cuaderno espiralado | nuevo cuaderno. Cordoba Córdoba 

-- categoria de los prov de cuadernos

SELECT distinct p.NroProv, pr.Categoria
FROM Articulo a 
JOIN Pedido p ON a.NroArt = p.NroArt
JOIN Proveedor pr ON p.NroProv = pr.NroProv
WHERE Descripcion like '%cuaderno%' -- cuaderno tapa dura | cuaderno espiralado | nuevo cuaderno. Cordoba Córdoba 

-- max categoria de los prov de cuadernos

SELECT MAX (pr.Categoria) [max Categoria De Prov De Cuadernos]
FROM Articulo a 
JOIN Pedido p ON a.NroArt = p.NroArt
JOIN Proveedor pr ON p.NroProv = pr.NroProv
WHERE Descripcion like '%cuaderno%' -- cuaderno tapa dura | cuaderno espiralado | nuevo cuaderno. Cordoba Córdoba 


-- Hallar los nombres de los proveedores cuya categoría sea mayor que la de todos los proveedores que proveen el artículo cuaderno.

SELECT * 
FROM proveedor 
WHERE categoria >
		(
		SELECT MAX (pr.Categoria) [max Categoria De Prov De Cuadernos]
		FROM Articulo a 
		JOIN Pedido p ON a.NroArt = p.NroArt
		JOIN Proveedor pr ON p.NroProv = pr.NroProv
		WHERE Descripcion like '%cuaderno%' -- cuaderno tapa dura | cuaderno espiralado | nuevo cuaderno. Cordoba Córdoba 
		)
ORDER BY NomProv


--9.	Hallar los proveedores que han provisto más de 1000 unidades entre los artículos 1 y 100 .

SELECT NroProv, SUM(cantidad) AS [cantidad total art 1 y 100]
FROM Pedido
WHERE NroArt IN (1, 100)
GROUP BY NroProv
HAVING SUM(cantidad) > 1000
ORDER BY NroProv

----
-- otra forma de ver la misma info

SELECT p1.NroProv, 
		ISNULL(p1.totalP1, 0) as total1, 
		ISNULL(P100.totalP100, 0) as total100, 
		ISNULL(p1.totalP1, 0) + ISNULL(P100.totalP100, 0) as [total = p1 + p100]
FROM 
	(
	SELECT NroProv, SUM(cantidad) AS totalP1
	FROM Pedido  
	WHERE NroArt = 1
	GROUP BY NroProv
	) AS P1
FULL JOIN 
	(
	SELECT NroProv, SUM(cantidad) AS totalP100
	FROM Pedido  
	WHERE NroArt = 100
	GROUP BY NroProv
	) AS P100
ON p1.NroProv = p100.NroProv

	 
--10.	Listar la cantidad y el precio total de cada artículo que han pedido los Clientes 
--a sus proveedores entre las fechas 01-01-2004 y 31-03-2004 (se requiere visualizar Cliente, Articulo, Proveedor, Cantidad y Precio).

--11.	Idem anterior y que además la Cantidad sea mayor o igual a 1000 o el Precio sea mayor a $1000

--12.	Listar la descripción de los artículos en donde se hayan pedido en el día más del stock existente para ese mismo día.

--13.	Listar los datos de los proveedores que hayan pedido de todos los artículos en un mismo día. Verificar sólo en el último mes de pedidos.

--14.	Listar los proveedores a los cuales no se les haya solicitado ningún artículo en el último mes, pero sí se les haya pedido en el mismo mes del año anterior.


/*
Proveedor (NroProv, NomProv, Categoria, CiudadProv)
Artículo  (NroArt, Descripción, CiudadArt, Precio)
Cliente   (NroCli, NomCli, CiudadCli)
Pedido    (NroPed, NroArt, NroCli, NroProv, FechaPedido, Cantidad, PrecioTotal)
Stock     (NroArt, fecha, cantidad)
*/


-- TRABAJO CON FECHAS
SELECT GETDATE() [FECHA HOY], DATEADD(MONTH, -1, GETDATE()) [ UN MES PARA ATRAS], YEAR(GETDATE()) [Año], MONTH(GETDATE()) [MES], DAY(GETDATE()) [DIA]

-- prov que tuvieron pedidos durante el ultimo mes
SELECT *
FROM Pedido p
WHERE p.FechaPedido >= DATEADD(MONTH, -1, GETDATE()) AND p.FechaPedido <= GETDATE()

-- prov que NO tuvieron pedidos durante el ultimo mes
SELECT *
FROM Proveedor PR
WHERE NOT EXISTS 
				(
				SELECT *
				FROM Pedido p
				WHERE p.FechaPedido >= DATEADD(MONTH, -1, GETDATE()) AND p.FechaPedido <= GETDATE()
				AND p.NroProv = pr.NroProv
				)


-- FECHAS DEL AÑO PASADO
SELECT DATEADD(YEAR ,-1, DATEADD(MONTH, -1, GETDATE())) ,  DATEADD(YEAR, -1, GETDATE())

-- prov que SI tuvieron pedidos durante el ultimo mes, pero del año anterior
SELECT *
FROM Pedido p
WHERE p.FechaPedido >= DATEADD(YEAR ,-1, DATEADD(MONTH, -1, GETDATE())) AND p.FechaPedido <= DATEADD(YEAR, -1, GETDATE())


--Listar los proveedores a los cuales no se les haya solicitado ningún artículo en el último mes, pero sí se les haya pedido en el mismo mes del año anterior.

SELECT pr.NroProv
FROM Proveedor PR
WHERE NOT EXISTS 
				(
				SELECT *
				FROM Pedido p
				WHERE p.FechaPedido >= DATEADD(MONTH, -1, GETDATE()) AND p.FechaPedido <= GETDATE()
				AND p.NroProv = pr.NroProv
				)
INTERSECT -- INTERSECT | UNION | UNION ALL | MINUS | SUBSTRACT 

SELECT NroProv
FROM Pedido p
WHERE p.FechaPedido >= DATEADD(YEAR ,-1, DATEADD(MONTH, -1, GETDATE())) AND p.FechaPedido <= DATEADD(YEAR, -1, GETDATE())


--datediff -- muestra diferencia entre dos fechas
--dateadd -- agregar o substrae respecto de una fecha. puedo agregarle a una fecha dada, X segundos o Y minutos, o Z dias, etc 
--getdate -- | now  retorna la fecha de hoy

--15.	Listar los nombres de los clientes que hayan solicitado más de un artículo cuyo precio sea superior a $100
--y que correspondan a proveedores de Capital Federal. Por ejemplo, se considerará si se ha solicitado el artículo a2 y a3, 
--pero no si solicitaron 5 unidades del articulo a2.
 






