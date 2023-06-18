USE ejercicio2;


CREATE TABLE Proveedor
(
NroProv INT IDENTITY(1,1) PRIMARY KEY,
NomProv VARCHAR(20) NOT NULL,
Categoria VARCHAR(20),
CiudadProv VARCHAR(20)
)

CREATE TABLE Articulo
(
NroArt INT IDENTITY(1,1) not null ,
Descripcion VARCHAR(20),
CiudadArt  VARCHAR(20),
Precio DECIMAL(10,4),
PRIMARY KEY  (NroArt)
)

CREATE TABLE Cliente
(
NroCli INT IDENTITY(1,1) not null,
NomCli  VARCHAR(20), 
CiudadCli VARCHAR(20),
CONSTRAINT PK_Cliente PRIMARY KEY (NroCli)
)

CREATE TABLE Pedido    (
NroPed INT IDENTITY(1,1) not null, 
NroArt INT , 
NroCli INT , 
NroProv INT, 
FechaPedido DATETIME, 
Cantidad INT , 
PrecioTotal DECIMAL(10,4),
PRIMARY KEY  (NroPed)

)

ALTER TABLE Pedido
ADD CONSTRAINT FK_PedidoArticulo
FOREIGN KEY (NroArt) REFERENCES Articulo(NroArt);

ALTER TABLE Pedido
ADD CONSTRAINT FK_PedidoCliente
FOREIGN KEY (NroCli) REFERENCES Cliente(NroCli);


ALTER TABLE Pedido
ADD CONSTRAINT FK_PedidoProveedor
FOREIGN KEY (NroProv) REFERENCES Proveedor(NroProv);



CREATE TABLE Stock     
(NroArt  INT NOT NULL FOREIGN KEY REFERENCES Articulo(NroArt), 
fecha DATETIME NOT NULL, 
cantidad INT 
--CONSTRAINT FK_StockArticulo FOREIGN KEY (NroArt)     REFERENCES Articulo(NroArt)
)

ALTER TABLE Stock
ADD CONSTRAINT PK_Stock PRIMARY KEY (NroArt,fecha);

SELECT * FROM Pedido p
WHERE p.NroCli = 1 AND p.NroProv = 1;


--1)
SELECT NroProv FROM Pedido
JOIN Articulo
ON Articulo.NroArt = Pedido.NroArt
WHERE Articulo.descripcion LIKE 'a146';

--2)
SELECT DISTINCT c.NomCli, p.NroProv 
FROM Pedido p JOIN Cliente c
ON c.NroCli = p.NroCli
JOIN Proveedor pro
ON pro.NroProv = p.NroProv
WHERE pro.NomProv LIKE 'p015';

--3)
SELECT *
FROM Pedido p, Proveedor pro
WHERE pro.Categoria > 4 AND p.NroProv = pro.NroProv;

--4)
SELECT * FROM Pedido p
WHERE p.NroCli = 1 AND p.NroArt = 1;

SELECT p.NroPed, c.CiudadCli, a.CiudadArt
FROM Pedido p, Cliente c, Articulo a
WHERE p.NroCli = c.NroCli AND p.NroArt = a.NroArt AND a.CiudadArt LIKE 'Mendoza' AND c.CiudadCli LIKE 'Rosario';

--5)
SELECT p.NroArt, p.NroCli, p.NroPed FROM Pedido p
WHERE p.NroCli = 1  OR  p.NroCli = 2;

SELECT p.NroPed, p.NroArt, c.NomCli 
FROM Pedido p JOIN Cliente c
ON p.NroCli = c.NroCli
JOIN (SELECT p.NroPed, p.NroArt, c.NomCli 
	  FROM Pedido p, Cliente c
	  WHERE p.NroCli = c.NroCli AND c.NomCli LIKE 'c30') AS Pedido_c30
ON c.NomCli LIKE 'c23' and Pedido_c30.NroArt = p.NroArt;


--6)
SELECT * FROM Articulo;

SELECT * FROM Proveedor pro
WHERE NOT EXISTS (SELECT a.NroArt FROM Articulo a
				  WHERE a.Precio >( SELECT AVG(a.precio) Promedio FROM Articulo a
									WHERE a.CiudadArt LIKE 'La Plata')
				  AND NOT EXISTS (SELECT 1 FROM Pedido p
								  WHERE pro.NroProv = p.NroProv
								  AND p.NroArt = a.NroArt));


--7)
SELECT prov.NroProv, COUNT(p.NroArt) Cant_art_dist 
FROM (SELECT DISTINCT NroProv, NroArt FROM pedido p ) as p     -- articulos diferentes por proveedor
JOIN (SELECT pro.NroProv FROM Proveedor pro 
      WHERE NOT EXISTS (SELECT * FROM Cliente c
 					    WHERE c.CiudadCli LIKE 'Jun_n'
						AND NOT EXISTS (SELECT * FROM Pedido p 
										WHERE pro.NroProv = p.NroProv 
										AND c.NroCli = p.NroCli))) AS prov     -- proveedores que proveen a todos los clientes de junin
ON p.NroProv = prov.NroProv
GROUP BY prov.NroProv;


--8)
SELECT pro.NomProv, pro.Categoria FROM Proveedor pro 
JOIN (SELECT MAX(pro.categoria) as maximo FROM Proveedor pro
	  WHERE NOT EXISTS (SELECT * FROM Articulo a
		  			    WHERE a.Descripcion LIKE 'cuaderno'
						AND NOT EXISTS (SELECT * FROM Pedido p
										WHERE p.NroProv = pro.NroProv 
										AND p.NroArt = a.NroArt))) AS x
ON pro.Categoria > x.maximo;


--9)
SELECT * FROM PEDIDO
WHERE pedido.NroArt = 5 OR pedido.NroArt = 7;

SELECT p.NroProv, SUM(p.Cantidad) suma FROM Pedido p
JOIN (SELECT * FROM Articulo a
      WHERE a.Descripcion 
	  IN('A001','A100') )AS rango
ON p.NroArt = rango.NroArt
GROUP BY p.NroProv
HAVING SUM(p.Cantidad) > 1000;


--10)
SELECT p.NroCli, p.NroArt, p.NroProv, p.Cantidad, p.PrecioTotal
FROM Pedido p
WHERE p.FechaPedido >= CAST('2004-01-01' AS DATE) AND p.FechaPedido <= CAST('2004-03-31' AS DATE);


--11)
SELECT p.NroCli, p.NroArt, p.NroProv, p.Cantidad, p.PrecioTotal
FROM Pedido p
WHERE p.FechaPedido >= CAST('2004-01-01' AS DATE) AND p.FechaPedido <= CAST('2004-03-31' AS DATE)
OR p.Cantidad >= 1000 OR p.PrecioTotal > 1000;


--12)
SELECT a.descripcion FROM Articulo a
JOIN (SELECT DISTINCT p.NroArt FROM Stock s, Pedido p
	  WHERE p.FechaPedido = s.fecha AND p.NroArt = s.NroArt AND p.Cantidad > s.cantidad) AS x
ON a.NroArt = x.NroArt;


--13)
SELECT * FROM Proveedor pro
WHERE NOT EXISTS (SELECT 1 FROM Articulo a 
				  WHERE NOT EXISTS (SELECT 1 FROM Pedido p 
									WHERE p.NroProv = pro.NroProv
								    AND p.NroArt = a.NroArt
									GROUP BY p.FechaPedido));

--14)
CREATE VIEW ProveedoresSinPedidosMesPasado AS
SELECT * FROM Proveedor pro
WHERE NOT EXISTS (SELECT 1 FROM Pedido p
				  WHERE p.FechaPedido >= DATEADD(MONTH, -1, GETDATE()) 
				  AND p.FechaPedido <= GETDATE());

SELECT * FROM Pedido pro, ProveedoresSinPedidosMesPasado p, Pedido ped
WHERE pro.NroProv = p.NomProv
AND ped.FechaPedido >= DATEADD(MONTH, -13, GETDATE()) 
AND ped.FechaPedido <= DATEADD(MONTH, -12, GETDATE())
AND ped.NroProv = p.NroProv;


--15)
SELECT c.NroCli, c.NomCli, COUNT(*)cant_art 
FROM Cliente c
JOIN (SELECT DISTINCT p.NroCli, p.NroProv, p.NroArt
	  FROM Proveedor pro, Pedido p, Articulo a
      WHERE pro.CiudadProv = 'Capital Federal'
	  AND pro.NroProv = p.NroProv
	  AND a.Precio > 100
	  AND a.NroArt = p.NroArt) x
ON c.NroCli = x.NroCli
GROUP BY c.NomCli, c.NroCli
HAVING COUNT(*) > 1;
