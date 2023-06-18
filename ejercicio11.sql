/*Película (CodPel, Titulo, Duracion, CodGenero, 
IdDirector)

Genero (Id, NombGenero)

Director (Id, NyA)

Ejemplar (nroEj, CodPel, Estado)
{Estado: 1 Disponible, 0 No disponible}

Cliente (CodCli, NyA, Direccion, Tel, Email, Borrado)
{Borrado: 1 Si, 2 No(Default) }

Alquiler (id, NroEj, CodPel, CodCli, FechaAlq, 
FechaDev)
*/


--1.Realice las sentencias DDL necesarias para crear en SQL una base de datos
--  correspondiente al modelo relacional del enunciado.
CREATE DATABASE ejercicio11;

USE ejercicio11;

CREATE TABLE Genero(
Id INT PRIMARY KEY,
NombGenero VARCHAR(50));

CREATE TABLE Director(
Id INT PRIMARY KEY,
NyA VARCHAR(100));

CREATE TABLE Pelicula(
CodPel INT,
Titulo VARCHAR(50),
Duracion DECIMAL(4,2),
CodGenero INT,
IdDirector INT,
PRIMARY KEY(CodPel),
FOREIGN KEY(CodGenero)
REFERENCES Genero(Id),
FOREIGN KEY(IdDirector)
REFERENCES Director(Id));

CREATE TABLE Ejemplar(
NroEj INT,
CodPel INT,
Estado BIT,
PRIMARY KEY(NroEj, CodPel),
CONSTRAINT CodPelFK FOREIGN KEY(CodPel)
REFERENCES Pelicula(CodPel));

DROP TABLE Ejemplar;

CREATE TABLE Cliente(
CodCli INT PRIMARY KEY,
NyA VARCHAR(100),
Direccion VARCHAR(200),
Tel VARCHAR(30),
Email VARCHAR(50),
Borrado BIT);

ALTER TABLE Cliente
ALTER COLUMN Borrado INT;

CREATE TABLE Alquiler(
id INT PRIMARY KEY,
NroEj INT,
CodPel INT,
CodCli INT,
FechaAlq DATE,
FechaDev DATE,
FOREIGN KEY(NroEj, CodPel)
REFERENCES Ejemplar(NroEj, CodPel),
FOREIGN KEY(CodCli)
REFERENCES Cliente(CodCli));


--2. Realice los INSERTs necesarios para cargar en las tablas creadas en el punto
--   anterior los datos de 5 clientes, 10 peliculas (y tablas relacionadas a estas) y al
--   menos 15 alquileres.
INSERT Cliente
VALUES(1, 'Cliente Uno', 'Direccion1', '11112222', 'cliente1@mail.com', 2),
(2, 'Cliente Dos', 'Direccion2', '11113333', 'cliente2@mail.com', 2),
(3, 'Cliente Tres', 'Direccion3', '11114444', 'cliente3@mail.com', 2),
(4, 'Cliente Cuatro', 'Direccion4','11115555', 'cliente4@mail.com', 2),
(5, 'Cliente Cinco', 'Direccion5','11116666', 'cliente5@mail.com', 2),
(6, 'Cliente Seis', 'Direccion6','11117777', 'cliente6@mail.com', 2);


INSERT INTO Genero
VALUES(1, 'Accion'),
(2, 'Suspenso'),
(3, 'Terror'),
(4, 'Comedia'),
(5, 'Infantil'),
(6, 'Ciencia Ficcion');

INSERT INTO Director
VALUES(1, 'Spilberg'),
(2, 'Cameron'),
(3, 'Tarantino'),
(4, 'Burton'),
(5, 'Jackson');

INSERT Pelicula
VALUES(1, 'Avatar', 3.2, 6, 2),
(2, 'Star Wars I', 3, 6, 5),
(3, 'Dumbo', 3.1, 5, 4),
(4, 'Joven Manos de Tijera', 2, 5, 4),
(5, 'Avatar II', 3.2, 6, 2),
(6, 'Inglorious Bastards', 2.5, 1, 3),
(7, 'Django', 2, 1, 3),
(8, 'Star Wars VI', 3.2, 6, 5),
(9, 'Marcianos al Ataque', 1.5, 4, 4),
(10, 'Tiburon', 1.3, 3, 1);

INSERT INTO Ejemplar
VALUES (1, 1, 1),
(2, 1, 0),
(1, 2, 1),
(2, 2, 0),
(1, 3, 1),
(2, 3, 0),
(1, 4, 1),
(2, 4, 0),
(1, 5, 1),
(2, 5, 1),
(1, 6, 1),
(2, 6, 1),
(1, 7, 1),
(2, 7, 0),
(1, 8, 1),
(2, 8, 0),
(1, 9, 1),
(2, 9, 0),
(1, 10, 1),
(2, 10, 1);


INSERT INTO Alquiler
VALUES (1, 1, 1, 1, '2023-01-01', '2023-01-05'),
(2, 1, 2, 2, '2023-01-10', '2023-01-15'),
(3, 1, 3, 1, '2023-02-01', '2023-02-05'),
(4, 1, 4, 3, '2023-03-01', '2023-03-05'),
(5, 1, 5, 2, '2023-03-12', '2023-03-13'),
(6, 1, 6, 5, '2023-04-01', '2023-04-05'),
(7, 1, 7, 4, '2023-05-01', '2023-05-05'),
(8, 1, 8, 5, '2023-06-20', '2023-06-25'),
(9, 1, 9, 2, '2023-06-21', '2023-06-28'),
(10, 2, 9, 1,'2023-06-15', NULL),
(11, 2, 1, 3, '2023-06-15', NULL),
(12, 2, 2, 4, '2023-06-15', NULL),
(13, 2, 3, 5, '2023-06-15', NULL),
(14, 2, 4, 2, '2023-06-15', NULL),
(15, 2, 7, 1, '2023-06-15', NULL);


--3. Agregue el atributo “año” en la tabla Película.
ALTER TABLE Pelicula
ADD anio DECIMAL(4,0); 


--4. Actualice la tabla película para que incluya el año de 
--   lanzamiento de las películas en stock.
CREATE PROCEDURE agregaAnio AS
DECLARE @contador INT = 1
DECLARE @tamanioPelicula INT
BEGIN
	SET @tamanioPelicula = (SELECT COUNT(*) FROM Pelicula);
	WHILE (@contador <> @tamanioPelicula + 1) BEGIN
		
		UPDATE Pelicula 
		SET anio =
					CASE @contador 
						WHEN 1 THEN 2009
						WHEN 2 THEN 1999
						WHEN 3 THEN 2019
						WHEN 4 THEN 1990
						WHEN 5 THEN 2023
						WHEN 6 THEN 2009
						WHEN 7 THEN 2012
						WHEN 8 THEN 1983
						WHEN 9 THEN 1996
						WHEN 10 THEN 1976
						ELSE 1900
					END
		WHERE CodPel = @contador;

		SET @contador = @contador + 1;
	END;

	SELECT * FROM Pelicula;
END;

EXECUTE agregaAnio;


--5. Queremos que al momento de eliminar una película 
--   se eliminen todos los ejemplares de la misma. 
--   Realice una CONSTRAINT para esta tarea.

ALTER TABLE Ejemplar
DROP CONSTRAINT CodPelFK
GO
ALTER TABLE Ejemplar
ADD CONSTRAINT CodPelFK FOREIGN KEY(CodPel)
REFERENCES Pelicula(CodPel)ON DELETE CASCADE
GO

/*CREATE TRIGGER borraEjemplares 
ON Pelicula INSTEAD OF DELETE AS
BEGIN
	DELETE FROM Ejemplar
	WHERE CodPel IN(SELECT d.CodPel FROM deleted d);
END;*/


--6. Queremos que exista un borrado de lógico y no 
--   físico de clientes, realice un TRIGGER que 
--   usando el atributo “Borrado” haga esta tarea.
CREATE TRIGGER booradoLogicoCliente 
ON Cliente INSTEAD OF DELETE AS 
BEGIN
	UPDATE Cliente 
	SET Borrado = 1
	WHERE CodCli = (SELECT CodCli FROM deleted);
END;


--7. Elimine las películas de las que no se hayan 
--   alquilado ninguna copia.
SELECT * FROM Pelicula;

DELETE Pelicula 
WHERE CodPel = (SELECT p.CodPel FROM Pelicula p
				EXCEPT 
				SELECT DISTINCT a.CodPel FROM Alquiler a);

SELECT * FROM Pelicula;


--8. Elimine los clientes sin alquileres.
DELETE Cliente
WHERE CodCli = (SELECT CodCli FROM Cliente
				EXCEPT 
				SELECT CodCli FROM Alquiler);

SELECT * FROM Cliente;