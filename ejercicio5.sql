CREATE DATABASE ejercicio5
go

USE ejercicio5

/*
Película (CodPel, Título, Duración, Año, CodRubro)
Rubro    (CodRubro, NombRubro)

Ejemplar (CodEj, CodPel, Estado, Ubicación) 
          Estado: Libre, Ocupado
Cliente  (CodCli, Nombre, Apellido, Direccion, Tel, Email)
Préstamo (CodPrest, CodEj, CodPel, CodCli, FechaPrest, FechaDev)

*/

CREATE TABLE Rubro
(
CodRubro INT IDENTITY(1,1) PRIMARY KEY,
NombRubro VARCHAR(20) NOT NULL 
)


CREATE TABLE Pelicula
(
CodPel INT IDENTITY(1,1) PRIMARY KEY,
Titulo VARCHAR(50) NOT NULL,
Duracion decimal(6,2),
Anio int,
CodRubro int
	CONSTRAINT FK_CodRubro FOREIGN KEY (CodRubro)     REFERENCES Rubro(CodRubro)
)

CREATE TABLE Ejemplar
(
CodEj INT not NULL,
CodPel int not NULL,
Estado bit not NULL,
Ubicación varchar(10)
)

ALTER TABLE Ejemplar
ADD CONSTRAINT PK_CodEjPel PRIMARY KEY (CodEj,CodPel);

ALTER TABLE Ejemplar
ADD CONSTRAINT FK_Pelicula
FOREIGN KEY (CodPel) REFERENCES Pelicula(CodPel);


CREATE TABLE Cliente
(
CodCli INT IDENTITY(1,1) PRIMARY KEY,
Nombre VARCHAR(20) NOT NULL,
Apellido VARCHAR(20) NOT NULL,
Direccion VARCHAR(20)  NULL,
Tel   VARCHAR(20)  NULL,
Email VARCHAR(20)  NULL

)


CREATE TABLE Prestamo
(
CodPrest INT IDENTITY(1,1) PRIMARY KEY,
CodEj INT NOT NULL,
CodPel INT NOT NULL,
CodCli INT  NULL,
FechaPrest   datetime not  NULL,
FechaDev datetime  NULL 
)

--1)Listar los clientes que no hayan reportado préstamos del rubro “Policial”.
SELECT DISTINCT cli.CodCli, cli.Apellido FROM Pelicula p, Prestamo pre, Rubro ru, Cliente cli
WHERE p.CodPel = pre.CodPel
AND p.CodRubro = ru.CodRubro
AND cli.CodCli = pre.CodCli
EXCEPT
SELECT DISTINCT cli.CodCli, cli.Apellido FROM Pelicula p, Prestamo pre, Rubro ru, Cliente cli
WHERE p.CodPel = pre.CodPel
AND p.CodRubro = ru.CodRubro
AND ru.NombRubro LIKE 'Policial'
AND cli.CodCli = pre.CodCli


--2)Listar las películas de mayor duración que alguna vez fueron prestadas.
SELECT p.CodPel, p.Duracion FROM Pelicula p
JOIN (SELECT MAX(p.Duracion) maximaDuracion FROM Pelicula p, Prestamo pre
	  WHERE pre.CodPel = p.CodPel)x
ON p.Duracion = x.maximaDuracion;


--3)Listar los clientes que tienen más de un 
--  préstamo sobre la misma película (listar 
--  Cliente, Película y cantidad de préstamos).
SELECT pre.CodCli, pre.CodPel, COUNT(*) cant_prestamos
FROM Prestamo pre
GROUP BY pre.CodCli, pre.CodPel
HAVING COUNT(*) > 1
ORDER BY pre.CodCli;



--4)Listar los clientes que han realizado 
--  préstamos del título “Rey León” y “Terminador 3” (Ambos). 

SELECT c.CodCli, c.Nombre, c.Apellido 
FROM Cliente c
JOIN (SELECT pre.CodCli FROM Prestamo pre, Pelicula p
	  WHERE pre.CodPel = p.CodPel
	  AND p.Titulo LIKE 'Rey%') rey
ON rey.CodCli = c.CodCli
JOIN (SELECT pre.CodCli FROM Prestamo pre, Pelicula p
	  WHERE pre.CodPel = p.CodPel
	  AND p.Titulo LIKE 'Ter%') ter
ON ter.CodCli = rey.CodCli;


--5)Listar las películas más vistas en cada mes 
--  (Mes, Película, Cantidad de Alquileres).
CREATE VIEW Cant_alq_x_mes_x_pelicula AS
SELECT MONTH(pre.FechaPrest) mes, pre.CodPel, COUNT(pre.CodPel) cant_alq
FROM Prestamo pre
GROUP BY MONTH(pre.FechaPrest), pre.CodPel;

SELECT ca.mes, ca.CodPel, x.maximo FROM Cant_alq_x_mes_x_pelicula ca
JOIN ( SELECT ca.mes, MAX(ca.cant_alq) maximo
       FROM Cant_alq_x_mes_x_pelicula ca
	   GROUP BY ca.mes) x
ON x.mes = ca.mes AND x.maximo = ca.cant_alq
ORDER BY ca.mes;

SELECT * FROM Prestamo
ORDER BY MONTH(FechaPrest);


--6)Listar los clientes que hayan alquilado todas las películas del video.
SELECT * FROM Cliente c
WHERE NOT EXISTS(SELECT 1 FROM Pelicula p
				 WHERE NOT EXISTS(SELECT 1 FROM Prestamo pre
				                  WHERE pre.CodPel = p.CodPel
								  AND pre.CodCli = c.CodCli));


--7)Listar las películas que no han registrado ningún préstamo a la fecha.
SELECT p.CodPel FROM Pelicula p
EXCEPT 
SELECT DISTINCT pre.CodPel FROM Prestamo pre;


--8)Listar los clientes que no han efectuado la devolución de ejemplares.
SELECT DISTINCT pre.CodCli 
FROM Prestamo pre
WHERE pre.FechaDev IS NULL;


--9)Listar los títulos de las películas que tienen la mayor cantidad 
--  de préstamos.
SELECT y.CodPel, maximo.maximo FROM 
(SELECT MAX(x.cant) maximo
 FROM (SELECT pre.CodPel , COUNT(*) cant
	   FROM Prestamo pre
       GROUP BY pre.CodPel) x) maximo,
(SELECT pre.CodPel , COUNT(*) cant
	   FROM Prestamo pre
       GROUP BY pre.CodPel) y
WHERE maximo.maximo = y.cant;

SELECT * FROM Prestamo
ORDER BY CodPel;


--10)Listar las películas que tienen todos los ejemplares prestados.
SELECT * FROM Pelicula p
WHERE NOT EXISTS( SELECT * FROM Ejemplar e
				  WHERE e.Estado = 1
				  AND NOT EXISTS(SELECT 1 FROM Prestamo pre
								 WHERE pre.CodEj = e.CodEj
								 AND pre.CodPel = p.CodPel));

