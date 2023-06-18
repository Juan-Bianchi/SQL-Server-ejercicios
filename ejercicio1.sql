CREATE DATABASE ejercicio1;

USE ejercicio1;

CREATE TABLE Almacén
(Nro SMALLINT , Resposable VARCHAR(100)
CONSTRAINT Key_Nro_Almacen PRIMARY KEY(Nro));

INSERT INTO Almacén
VALUES(1, 'Pedro'),
(2, 'Juan'),
(3, 'Luis'),
(4, 'Pablo'),
(5, 'Nora'),
(6, 'Martin Gomez'),
(7, 'Lucas');



CREATE TABLE Artículo
(CodArt SMALLINT, descripcion VARCHAR(100), precio NUMERIC(10,2)
CONSTRAINT PK_CodArt PRIMARY KEY(CodArt));

INSERT INTO Artículo
VALUES(001, 'Modulo de facturación', 5),
(002, 'Modulo de compra', 15),
(003, 'Modulo de stock', 9),
(004, 'Modulo de estadisticas', 25),
(005, 'Modulo de sueldos', 10),
(006, 'A', 65),
(7,'B',5),
(8,'C', 105);



CREATE TABLE Material
(CodMat SMALLINT, descripcion VARCHAR(100)
CONSTRAINT PKCodMat PRIMARY KEY(CodMat));

INSERT INTO Material
VALUES('1', 'Silicio'),
('2', 'Plastico'),
('3', 'Microprocesador'),
('4', 'Microcontrolador'),
('5', 'RWM'),
(6, 'M1'),
(123, 'L5'),
(7, 'Cobre'),
(8, 'Platino');


CREATE TABLE Proveedor
(CodProv SMALLINT, nombre VARCHAR(100), domicilio VARCHAR(100), ciudad VARCHAR(100)
CONSTRAINT PKCodProv PRIMARY KEY(CodProv));

INSERT INTO Proveedor
VALUES(1, 'Fico', 'aaa', 'La Plata'),
(2, 'Accenture', 'bbb', 'La Plata'),
(3, 'Globant', 'ccc', 'CABA'),
(4, 'EY', 'ddd', 'San Isidro'),
(5, 'IBM', 'eee', 'CABA'),
(10, 'NVIDIA', 'eee', 'CABA'),
(15, 'AMD', 'eee', 'CABA'),
(6, 'Perez', 'aaa', 'Pergamino'),
(7, 'Lopez', 'aaa', 'Luján'),
(8, 'Rodriguez', 'aaa', 'Pergamino'),
(9, 'Smith', 'aaa', 'CABA'),
(11, 'Peres', 'aaa', 'Viedma'),
(12, 'Perez', 'rrr', 'Rosario'),
(13, 'Adison', 'rrr', 'Rosario');


CREATE TABLE Tiene
(NroAlm SMALLINT, CodArtArt SMALLINT
CONSTRAINT PKTiene PRIMARY KEY(NroAlm, CodArtArt),
CONSTRAINT FKAlmacenArticulo FOREIGN KEY(NroAlm)
REFERENCES Almacén(Nro),
CONSTRAINT FKArticulo FOREIGN KEY(CodArtArt)
REFERENCES Artículo(CodArt))

INSERT INTO Tiene
VALUES(1, 5),
(2, 5),
(1, 6),
(4, 2),
(3, 3),
(1, 3),
(5, 6),
(5,7),
(3,7),
(6,1),
(6,4),
(6,3),
(7, 3),
(7, 6);


CREATE TABLE Compuesto_por
(CodArt SMALLINT, CodMat SMALLINT,
CONSTRAINT PKCompuesto_por PRIMARY KEY(CodArt, CodMat),
CONSTRAINT FKArticulo1 FOREIGN KEY(CodArt)
REFERENCES Artículo(CodArt),
CONSTRAINT FKMaterial FOREIGN KEY(CodMat)
REFERENCES Material(CodMAt));

INSERT INTO Compuesto_por
VALUES(1, 6),
(2, 5),
(3, 3),
(1, 3),
(1, 1),
(1, 2),
(1, 4),
(1, 5),
(1, 7),
(1, 8),
(1, 123),
(4, 2),
(2, 1),
(5, 6),
(7, 6),
(8, 4),
(6, 1),
(3, 2),
(2, 4),
(7, 1),
(6, 123),
(3, 123);


CREATE TABLE Provisto_por
(CodMAt SMALLINT, CodProv SMALLINT,
CONSTRAINT PKProvisto_por PRIMARY KEY(CodMat, CodProv),
CONSTRAINT FKMaterial1 FOREIGN KEY(CodMat)
REFERENCES Material(CodMat),
CONSTRAINT FKProveedor FOREIGN KEY(CodProv)
REFERENCES Proveedor(CodProv));

INSERT INTO Provisto_por
VALUES(1, 10),
(1, 15),
(2, 10),
(3, 10),
(3, 15),
(4, 15),
(5, 10),
(5, 15),
(6, 12),
(6, 13),
(2, 12),
(4, 13),
(2, 7),
(6, 7),
(7, 5),
(8, 9);




--1)
SELECT nombre FROM Proveedor 
WHERE ciudad LIKE 'La Plata';

--2)
SELECT CodArt FROM Artículo
WHERE precio < 10;

--3)
SELECT Resposable FROM Almacén;

--4)
--MAL
SELECT CodMat FROM Provisto_por
WHERE --CodProv IN (10) AND
CodProv NOT IN (15);

--OK
SELECT CodMat FROM Provisto_por
WHERE CodProv IN (10)
EXCEPT
SELECT CodMat FROM Provisto_por
WHERE CodProv IN (15);

--5)
SELECT NroAlm FROM Tiene JOIN Artículo
ON Artículo.CodArt = CodArtArt
WHERE descripcion LIKE 'A'; 

--6)
SELECT * FROM Proveedor
WHERE Ciudad IN('Pergamino') AND Nombre IN ('Perez');

--7)
SELECT NroAlm FROM Tiene JOIN Artículo
ON Artículo.codArt = CodArtArt
EXCEPT
SELECT NroAlm FROM Tiene JOIN Artículo
ON Artículo.codArt = CodArtArt
WHERE descripcion NOT IN( 'A', 'B');

--8)
SELECT a.CodArt, a.descripcion, a.precio, m.descripcion as material
FROM Artículo a JOIN(SELECT cp.CodArt, cp.CodMat 
					 FROM Compuesto_por cp JOIN Material m
					 ON cp.CodMat = m.CodMat
					 WHERE m.descripcion LIKE 'M1'
					 UNION
					 SELECT cp.CodArt, cp.CodMat
					 FROM Compuesto_por cp JOIN Artículo a
					 ON cp.CodArt = a.CodArt
					 WHERE precio > 100) AS x
ON a.CodArt = x.CodArt
JOIN Material m ON m.CodMat = x.CodMat;

--9)
SELECT m.CodMat, m.descripcion, x.ciudad FROM 
Material M JOIN (SELECT pp.CodMat, pp.CodProv, p.ciudad 
                 FROM Provisto_por pp
			     JOIN Proveedor p ON p.CodProv = pp.CodProv
				 WHERE p.ciudad LIKE 'ro%') AS x
ON m.CodMat = x.CodMat;

--10)
SELECT a.CodArt, a.descripcion, a.precio, t.NroAlm
FROM Artículo a JOIN Tiene t 
ON a.CodArt = t.CodArtArt
WHERE t.NroAlm = 1;

--11)
SELECT m.descripcion 
FROM Material m 
JOIN (SELECT cp.CodArt, a.descripcion, cp.CodMat FROM Compuesto_por cp JOIN Artículo a
      ON cp.CodArt = a.CodArt) AS x
ON x.CodMat = m.CodMat
WHERE x.descripcion LIKE 'B'; 

--12)
SELECT DISTINCT p.nombre FROM Proveedor p
JOIN Provisto_por pp ON pp.CodProv = p.CodProv 
JOIN Compuesto_por cp ON cp.CodMat = pp.CodMAt
JOIN Tiene t ON t.CodArtArt = cp.CodArt 
JOIN Almacén a ON a.Nro = T.NroAlm
WHERE a.Resposable LIKE 'Martin Gomez';

--13)
SELECT a.CodArt, a.descripcion, x.nombre
FROM Artículo a JOIN(SELECT pp.CodMAt, p.nombre, cp.CodArt FROM
					Proveedor p JOIN Provisto_por pp
					ON p.CodProv = pp.CodProv
					JOIN Compuesto_por cp
					ON pp.CodMAt = cp.CodMat
					WHERE p.nombre = 'Lopez' 
					) as x 
ON a.CodArt = x.CodArt;

--14)
SELECT p.CodProv, p.nombre, x.precio, x.descripcion nombre_prod
FROM Proveedor p JOIN (SELECT a.CodArt, a.precio, pp.CodProv, a.descripcion
					   FROM Artículo a JOIN Compuesto_por cp 
					   ON cp.CodArt = a.CodArt
					   JOIN Provisto_por pp 
					   ON pp.CodMAt = cp.CodMat
					   WHERE a.precio > 100) as x
ON p.CodProv = x.CodProv;

--15)
SELECT a.Nro FROM Almacén a
WHERE NOT EXISTS (SELECT * FROM Compuesto_por cp 
				  WHERE cp.CodMat = 123
				  AND NOT EXISTS (SELECT * FROM Tiene t
								  WHERE a.Nro = t.NroAlm
								  AND t.CodArtArt = CodArt));

--16)
SELECT p.CodProv, p.nombre, p.ciudad FROM Proveedor p, Provisto_por pp
WHERE p.ciudad = 'CABA'
AND p.CodProv = pp.CodProv
AND NOT EXISTS ( SELECT * FROM Provisto_por pp2, Proveedor p2
				 WHERE pp2.CodMAt = pp.CodMat 
				 AND pp2.CodProv <> pp.CodProv
				 AND pp2.CodProv = p2.CodProv
				 AND p2.ciudad = 'CABA');



--17)
SELECT * FROM Artículo a
WHERE a.precio = (SELECT MAX(precio) FROM Artículo);

--18)
SELECT * FROM Artículo a
WHERE a.precio = (SELECT MIN(precio) FROM Artículo);

--19)
SELECT promedio.NroAlm, AVG(promedio.precio) promedio
FROM (SELECT a.CodArt, a.descripcion, a.precio, t.NroAlm 
	  FROM Artículo a, Tiene t
      WHERE a.CodArt = t.CodArtArt) AS promedio
GROUP BY promedio.NroAlm;

--o
SELECT t.NroAlm , AVG(a.precio) promedio_precio
FROM Tiene t, Artículo a
WHERE t.CodArtArt = a.CodArt
GROUP BY t.NroAlm;

--20)
SELECT * FROM Tiene;

SELECT * FROM (SELECT t.NroAlm, COUNT(t.CodArtArt) suma
			   FROM Tiene t
			   GROUP BY t.NroAlm) AS c
WHERE c.suma =( SELECT MAX(c.suma) maximo
				FROM ( SELECT t.NroAlm, COUNT(t.CodArtArt) suma
					   FROM Tiene t
					   GROUP BY t.NroAlm) AS c);

--o
CREATE VIEW Cant_Articulos AS
SELECT NroAlm, COUNT(*) cant_art
FROM Tiene
GROUP BY NroAlm;

SELECT * FROM Cant_Articulos
WHERE cant_art = (SELECT MAX(cant_art)
				  FROM Cant_Articulos);

--21)
SELECT cp.CodArt, COUNT(*) cantMateriales
FROM Compuesto_por cp
GROUP BY cp.CodArt
HAVING COUNT(*) > 1;

--22)
SELECT cp.CodArt, COUNT(*) cantMateriales
FROM Compuesto_por cp
GROUP BY cp.CodArt
HAVING COUNT(*) = 2;

--23)
SELECT cp.CodArt, COUNT(*) cantMateriales
FROM Compuesto_por cp
GROUP BY cp.CodArt
HAVING COUNT(* < 3;


--24)
SELECT cp.CodArt, COUNT(cp.CodMat) totalMateriales FROM Compuesto_por cp
GROUP BY cp.CodArt 
HAVING COUNT(cp.CodMat) = (SELECT COUNT(*) FROM Material);

--25)
SELECT p.ciudad FROM Proveedor p
WHERE EXISTS (SELECT pp.CodProv ,COUNT(pp.CodMat) FROM Provisto_por pp
			  GROUP BY pp.CodProv
			  HAVING COUNT(pp.CodMat) = (SELECT COUNT(*) FROM Material));
