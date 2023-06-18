CREATE DATABASE ejercicio7;

USE ejercicio7;

CREATE TABLE Auto(
matricula CHAR(7), 
modelo VARCHAR(20), 
anio INTEGER,
CONSTRAINT matricula PRIMARY KEY(matricula));

CREATE TABLE Chofer(
nroLicencia INTEGER,
nombre VARCHAR(30),
apellido VARCHAR(30),
fecha_ingreso DATE,
telefono VARCHAR(15),
CONSTRAINT nroLicencia PRIMARY KEY(nroLicencia));

CREATE TABLE Cliente(
nroCliente INTEGER,
calle VARCHAR(30),
nro INTEGER,
localidad VARCHAR(30),
CONSTRAINT nroCliente PRIMARY KEY(nroCliente));



CREATE TABLE Viaje(
fechaHoraInicio DATETIME,
fechaHoraFin DATETIME,
chofer INTEGER,
cliente INTEGER,
auto CHAR(7),
kmTotales INTEGER,
esperaTotal INTEGER, 
costoEspera INTEGER,
costoKms INTEGER,
CONSTRAINT fechaHoraInicio PRIMARY KEY(fechaHoraInicio),
CONSTRAINT nroLicenciaChoferFK FOREIGN KEY(chofer) 
REFERENCES Chofer(nroLicencia),
CONSTRAINT nroClienteFK FOREIGN KEY(cliente)
REFERENCES Cliente(nroCliente),
CONSTRAINT matriculaAutoFK FOREIGN KEY(auto)
REFERENCES Auto(matricula));


INSERT INTO Auto VALUES (1000,'208',2020)
INSERT INTO Auto VALUES (1001,'Golf',2018)
INSERT INTO Auto VALUES (1002,'Focus',2022)
INSERT INTO Auto VALUES (1003,'Gol',2022)

INSERT INTO Chofer VALUES (10,'Juan','Perez', CONVERT(DATE,'20/04/2019',103), null)
INSERT INTO Chofer VALUES (11,'Jorge','Gonzalez', CONVERT(DATE,'15/10/2020',103), null)
INSERT INTO Chofer VALUES (12,'Mario','Tala', '2021-03-22', null)

INSERT INTO Cliente VALUES (100,'Rivadavia',123,'CABA')
INSERT INTO Cliente VALUES (101,'Medrano',456,'CABA')
INSERT INTO Cliente VALUES (102,'Quintana',520,'Castelar')
INSERT INTO Cliente VALUES (103,'Directorio',856,'Haedo')

INSERT INTO Viaje VALUES ('2020-01-18T14:30:00','2020-01-18T17:20:00',10,100,1000,230,55,1200,9900)
INSERT INTO Viaje VALUES ('2020-01-22T09:15:00','2020-01-22T11:40:00',10,101,1001,88,0,0,7500)
INSERT INTO Viaje VALUES ('2020-01-23T09:15:00','2020-01-23T11:40:00',10,101,1002,88,0,0,7500)
INSERT INTO Viaje VALUES ('2020-01-24T09:15:00','2020-01-24T11:40:00',10,101,1003,88,0,0,7500)
INSERT INTO Viaje VALUES ('2023-05-18T09:15:00','2023-05-18T11:40:00',10,102,1001,30,0,0,6500)
INSERT INTO Viaje VALUES ('2023-05-18T19:00:00','2023-05-18T19:40:00',10,101,1000,30,0,0,4000)
INSERT INTO Viaje VALUES ('2023-05-19T09:15:00','2020-01-22T11:40:00',11,102,1002,20,0,0,3500)
INSERT INTO Viaje VALUES ('2023-05-20T09:15:00','2020-01-22T11:40:00',12,103,1002,40,0,0,4000)


--1)Indique cuales son los autos con mayor cantidad de kilómetros realizados en el
--último mes.

CREATE VIEW MaxKmUltimoMes AS
SELECT MAX(v.kmTotales) KmTotales FROM Viaje v 
WHERE v.fechaHoraInicio >= DATEADD(MONTH, -1, GETDATE())
AND v.fechaHoraInicio <= GETDATE();

SELECT auto, v.kmTotales FROM Viaje v, MaxKmUltimoMes
WHERE v.kmTotales = MaxKmUltimoMes.KmTotales;


--2) Indique los clientes que más viajes hayan realizado con el mismo chofer.
CREATE VIEW  ViajesPorCliYChofer AS
SELECT v.chofer, v.cliente, COUNT(v.cliente) cantViajes 
FROM Viaje v 
GROUP BY v.chofer, v.cliente


SELECT v.cliente, v.chofer, x.maxCantViajes FROM ViajesPorCliYChofer v
JOIN
(SELECT maximo.chofer,MAX(maximo.cantViajes) maxCantViajes
FROM ViajesPorCliYChofer maximo
GROUP BY maximo.chofer) x
ON x.chofer = v.chofer
AND x.maxCantViajes = v.cantViajes;


--3) Indique el o los clientes con mayor cantidad de viajes en este año.
SELECT * FROM Viaje;

CREATE VIEW maxCantViajes AS
SELECT MAX(viajesPorCliente.cant_viajes) maxPorCliente 
FROM (SELECT v.cliente, COUNT(*) cant_viajes 
	  FROM Viaje v
	  WHERE v.fechaHoraInicio >= DATEADD(YEAR, -1, GETDATE())
	  AND v.fechaHoraInicio <= GETDATE()
	  GROUP BY v.cliente) viajesPorCliente;

SELECT v.cliente, COUNT(*) cant_viajes 
FROM Viaje v, maxCantViajes
WHERE v.fechaHoraInicio >= DATEADD(YEAR, -1, GETDATE())
AND v.fechaHoraInicio <= GETDATE()
GROUP BY v.cliente, maxCantViajes.maxPorCliente
HAVING COUNT(*) = maxCantViajes.maxPorCliente;


--4) Obtenga nombre y apellido de los choferes que no 
--manejaron todos los vehículos que disponemos.

SELECT nombre, apellido, c_autos FROM
(SELECT COUNT(*) cant_autos FROM Auto) CantAutos
JOIN (SELECT v.chofer, COUNT(v.auto) c_autos 
	  FROM (SELECT DISTINCT chofer, auto FROM Viaje) v
	  GROUP BY v.chofer) x
ON c_autos <> cant_autos
JOIN Chofer
ON chofer = nroLicencia;

--o
SELECT c.nombre, c.apellido FROM Chofer c
EXCEPT
SELECT c.nombre, c.apellido FROM Chofer c
WHERE NOT EXISTS (SELECT * FROM Auto a
				 WHERE NOT EXISTS (SELECT * FROM Viaje v
								   WHERE v.auto = a.matricula
								   AND v.chofer = c.nroLicencia));


--5)Obtenga el nombre y apellido de los clientes que 
--  hayan viajado en todos nuestros autos.

SELECT c.nroCliente FROM Cliente c
WHERE NOT EXISTS (SELECT * FROM Auto a
				  WHERE NOT EXISTS ( SELECT * FROM Viaje v
								     WHERE v.auto = a.matricula
									 AND v.cliente = c.nroCliente));
SELECT * FROM Viaje;


--6)Queremos conocer el tiempo de espera promedio de 
--  los viajes de los últimos 2 meses.

SELECT AVG(v.esperaTotal) FROM Viaje v
WHERE v.fechaHoraInicio >= DATEADD(MONTH, -2, GETDATE())
AND v.fechaHoraInicio <= GETDATE();


--7)Indique los kilómetros realizados en viajes por cada auto.
SELECT auto, SUM(kmTotales) Km_totales FROM Viaje
GROUP BY auto;

--8)Indique el costo promedio de los viajes realizados por cada auto.
SELECT auto, AVG(costoKms) Promedio_costos 
FROM Viaje v
GROUP BY auto;

--9)Indique el costo total de los viajes realizados por 
--  cada chofer en el último mes.

SELECT v.chofer, 
SUM(v.costoEspera * v.esperaTotal + v.costoKms * v.kmTotales) costo_total
FROM Viaje v
GROUP BY v.chofer;

SELECT * FROM Viaje;


--10)Indique la fecha inicial, el chofer y el cliente 
--   que hayan realizado el viaje más largo de este año.

SELECT v.fechaHoraInicio, v.chofer, v.cliente
FROM Viaje v
JOIN (SELECT MAX(v.kmTotales) maximo
      FROM Viaje v
	  WHERE v.fechaHoraInicio >= DATEADD(YEAR, -1, GETDATE())
	  AND v.fechaHoraInicio <= GETDATE())m
ON v.kmTotales = maximo;

SELECT * FROM Viaje;
		