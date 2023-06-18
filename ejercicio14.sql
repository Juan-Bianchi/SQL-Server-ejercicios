CREATE DATABASE ejercicio14
GO
USE ejercicio14;

CREATE TABLE Cliente(
NroCliente INT PRIMARY KEY,
RazonSocial VARCHAR(100));

INSERT INTO Cliente
VALUES(1, 'cliente1'),
(2, 'cliente2'),
(3, 'cliente3');



CREATE TABLE Servicio(
NroServicio INT PRIMARY KEY,
Descripcion VARCHAR(100),
Precio DECIMAL(10,2));

INSERT INTO Servicio 
VALUES (1, 'servicio1', 10.5),
(2, 'servicio2', 20.5),
(3, 'servicio3', 30.5);



CREATE TABLE Festejo(
NroFestejo INT PRIMARY KEY,
descripcion VARCHAR(100),
fecha DATE,
nrocliente INT FOREIGN KEY REFERENCES Cliente(NroCliente));

set dateformat dmy
INSERT INTO Festejo
VALUES(1, 'festejo1', '01-01-2023', 1),
(2, 'festejo2', '01-02-2023', 1),
(3, 'festejo3', '01-03-2023', 2),
(4, 'festejo4', '01-04-2023', 2),
(5, 'festejo5', '01-05-2023', 3),
(6, 'festejo6', '01-06-2023', 3);



CREATE TABLE Contrata(
Item VARCHAR(100),
NroFestejo INT,
NroServicio INT,
HDesde TIME,
HHasta TIME,
PRIMARY KEY(Item, NroFestejo),
FOREIGN KEY(NroFestejo)
REFERENCES Festejo(NroFestejo),
FOREIGN KEY(NroServicio)
REFERENCES Servicio(NroServicio));


INSERT INTO Contrata
VALUES ('I1', 1, 1, CONVERT(TIME, GETDATE()), CONVERT(TIME, DATEADD(HOUR, 2, GETDATE())), 0),
('I2', 1, 1, CONVERT(TIME, GETDATE()), CONVERT(TIME, DATEADD(HOUR, 1, GETDATE())),0),
('I3', 2, 2, CONVERT(TIME, GETDATE()), CONVERT(TIME, DATEADD(HOUR, 1, GETDATE())),0),
('I4', 2, 2, CONVERT(TIME, GETDATE()), CONVERT(TIME, DATEADD(HOUR, 2, GETDATE())),0),
('I5', 3, 3, CONVERT(TIME, GETDATE()), CONVERT(TIME, DATEADD(HOUR, 1, GETDATE())),0),
('I6', 4, 3, CONVERT(TIME, GETDATE()), CONVERT(TIME, DATEADD(HOUR, 3, GETDATE())),0),
('I7', 5, 1, CONVERT(TIME, GETDATE()), CONVERT(TIME, DATEADD(HOUR, 1, GETDATE())),0),
('I8', 6, 2, CONVERT(TIME, GETDATE()), CONVERT(TIME, DATEADD(HOUR, 1, GETDATE())),0),
('I9', 1, 3, CONVERT(TIME, GETDATE()), CONVERT(TIME, DATEADD(HOUR, 1, GETDATE())),0),
('I10', 2, 1, CONVERT(TIME, GETDATE()), CONVERT(TIME, DATEADD(HOUR, 2, GETDATE())),0),
('I11', 3, 2, CONVERT(TIME, GETDATE()), CONVERT(TIME, DATEADD(HOUR, 2, GETDATE())),0);

TRUNCATE TABLE Contrata
SELECT * FROM Contrata

--1. p_Servicios(FDesde, FHasta): Crear un procedimiento almacenado que
--   permita listar aquellos servicios que fueron contratados en todos los festejos
--   del período enviado por parámetro. De dichos servicios mostrar el nombre y la
--   cantidad de horas que fueron contratadas en el período enviado por parámetro.
--   Ejemplificar la invocación del procedimiento.

CREATE PROCEDURE p_Servicios(@FDesde DATE, @FHasta DATE) AS
BEGIN
	SELECT s.Descripcion, SUM(x.tiempo) tiempo_acum_en_periodo
	FROM Servicio s, (SELECT c.NroFestejo, c.NroServicio, DATEDIFF(N, c.HDesde, c.HHasta) tiempo
					  FROM Contrata c) x
	WHERE NOT EXISTS( SELECT * FROM Festejo f
					  WHERE f.fecha >= @FDesde 
					  AND f.fecha <= @FHasta
					  AND NOT EXISTS( SELECT *
									  FROM Contrata c
									  WHERE c.NroFestejo = f.NroFestejo
									  AND c.NroServicio = s.NroServicio
									  AND x.NroFestejo = c.NroFestejo
									  AND x.NroServicio = c.NroServicio))
	GROUP BY s.Descripcion;
END;

EXECUTE p_Servicios '2023-01-01', '2023-01-30'


--2. Agregar el campo “Tiempo” en la tabla “Contrata” de tipo smallint, que no
--   acepte nulos y que posea como valor predeterminado 0 (cero). Este campo
--   servirá para que ya se encuentre precalculado la cantidad de minutos que fue
--   contratado el servicio, sin necesidad de realizar el cálculo con los campos de la
--   tabla.

ALTER TABLE Contrata
ADD Tiempo SMALLINT NULL DEFAULT 0;


--3. tg_Tiempo: Crear un trigger que cada vez que se cambia la hora desde/hasta
--   o bien se agregue un nuevo servicio contratado, recalculo el campo “Tiempo”
--   con el tiempo en minutos del servicio. Validar que la hora desde no puede ser
--   posterior a la hora hasta, si esto sucede se deberá avisar y volver atrás la
--   operación. Además, tener en cuenta las actualizaciones masivas. Ejemplificar
--   la invocación del trigger.

CREATE TRIGGER tg_Tiempo ON Contrata AFTER INSERT, UPDATE AS
BEGIN
	IF((SELECT COUNT(*) FROM Contrata c WHERE HDesde >= HHasta) > 0)
		SELECT 'La hora final no puede ser menor o igual a la hora de inicio'
	ELSE IF (NOT EXISTS(SELECT 1 FROM deleted) OR UPDATE(HHasta) OR UPDATE(HDesde))
		UPDATE Contrata
		SET Tiempo = (DATEDIFF(n, HDesde, HHasta))
END;