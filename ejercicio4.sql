CREATE DATABASE ejercicio4;

USE ejercicio4;

CREATE TABLE Persona(
dni INT PRIMARY KEY,
nomPersona VARCHAR(100),
telefono CHAR(10));

CREATE TABLE Empresa(
nomEmpresa VARCHAR(50) PRIMARY KEY,
telefono CHAR(10));

CREATE TABLE Vive(
dni INT PRIMARY KEY,
calle VARCHAR(100),
ciudad VARCHAR(25),
FOREIGN KEY (dni) 
REFERENCES Persona(dni));

CREATE TABLE Trabaja(
dni INT,
nomEmpresa VARCHAR(50),
salario DECIMAL(10,2),
feIngreso DATE,
feEgreso DATE,
PRIMARY KEY(dni, nomEmpresa),
FOREIGN KEY(dni) 
REFERENCES Persona(dni),
FOREIGN KEY(nomEmpresa)
REFERENCES Empresa(nomEmpresa));

CREATE TABLE Situada_En(
nomEmpresa VARCHAR(50) PRIMARY KEY,
ciudad VARCHAR(25)
FOREIGN KEY(nomEmpresa) 
REFERENCES Empresa(nomEmpresa));

CREATE TABLE Supervisa(
dniPer INT,
dniSup INT,
PRIMARY KEY(dniPer, dniSup),
FOREIGN KEY(dniPer) 
REFERENCES Persona(dni),
FOREIGN KEY(dniSup)
REFERENCES Persona(dni));


INSERT INTO Empresa
VALUES ('Banelco', '55555555'),
('Telecom', '11111111'),
('Paulinas', '22222222'),
('Clarín', '33333333'),
('Sony', '44444444');

INSERT INTO Persona
VALUES(1111, 'Pedro', '1511111111'),
(2222, 'Luis', '1522222222'),
(3333, 'Pablo', '1533333333'),
(4444, 'Rodrigo', '1544444444'),
(5555, 'Cesar', '1555555555'),
(6666, 'Juan', '1566666666');

INSERT INTO Vive
VALUES (1111, 'Calle1', 'CABA'),
(2222, 'Calle2', 'CABA'),
(3333, 'Calle3', 'Buenos Aires'),
(4444, 'Calle4', 'La Plata'),
(5555, 'Calle5', 'Junin'),
(6666, 'Calle6', 'CABA');

INSERT INTO Trabaja
VALUES (1111, 'Banelco', 700, '2000-01-01', '2000-01-31'),
(1111, 'Clarín', 1000, '2000-02-01',NULL),
(2222, 'Paulinas', 1700, '2000-03-15', NULL),
(3333, 'Sony', 1000, '2000-01-01', '2002-01-31'),
(4444, 'Sony', 2000, '2000-01-01', NULL),
(5555, 'Telecom', 1000, '2001-01-01', NULL),
(6666, 'Telecom', 1500, '2000-02-01', '2002-12-20'),
(3333, 'Clarín', 700, '2002-01-01', '2002-03-01'),
(3333, 'Paulinas', 800, '2002-04-01', '2002-04-25'),
(3333, 'Banelco', 900, '2002-05-01', '2002-10-01'),
(3333, 'Telecom', 1700, '2002-10-06', NULL),
(6666, 'Paulinas', 2000, '2003-01-01', '2003-12-31'),
(6666, 'Banelco', 1700, '2004-03-31', NULL);

INSERT INTO Situada_En 
VALUES ('Banelco', 'CABA'),
('Telecom', 'CABA'),
('Paulinas', 'Buenos Aires'),
('Clarín', 'La Plata'),
('Sony', 'Junin');

INSERT INTO Supervisa
VALUES (1111, 1111),
(2222, 2222),
(3333, 5555),
(4444, 4444),
(5555, 1111),
(6666, 3333);


--a)Encontrar el nombre de todas las personas que trabajan en la empresa “Banelco”.
SELECT p.nomPersona FROM Persona p, Trabaja t
WHERE t.dni = p.dni
AND t.nomEmpresa LIKE 'Banel%'
AND t.feEgreso IS NULL;


--b)Localizar el nombre y la ciudad de todas las 
--  personas que trabajan para la empresa “Telecom”.
SELECT p.nomPersona, v.ciudad
FROM Persona p, Trabaja t, Vive v
WHERE t.dni = p.dni
AND v.dni = p.dni
AND t.nomEmpresa LIKE 'Telecom'
AND t.feEgreso IS NULL;


--c)Buscar el nombre, calle y ciudad de todas las 
--  personas que trabajan para la empresa “Paulinas” 
--  y ganan más de $1500.
SELECT p.nomPersona, v.calle, v.ciudad 
FROM Persona p, Vive v, Trabaja t
WHERE p.dni = v.dni
AND t.dni = p.dni
AND t.salario > 1500
AND t.nomEmpresa LIKE 'Pau%'
AND t.feEgreso IS NULL;


--d)Encontrar las personas que viven en la misma 
--  ciudad en la que se halla la empresa en donde 
--  trabajan.
SELECT p.dni, p.nomPersona, v.ciudad, s.ciudad
FROM Persona p, Vive v, Trabaja t, Situada_En s
WHERE p.dni = v.dni
AND v.ciudad = s.ciudad
AND t.dni = p.dni
AND t.nomEmpresa = s.nomEmpresa
AND t.feEgreso IS NULL;


--e)Hallar todas las personas que viven en la misma 
--  ciudad y en la misma calle que su supervisor.
SELECT p.nomPersona empl, sup.nomPersona superv, v.ciudad, v.calle  
FROM Persona p, Persona sup, Supervisa s, Vive v, Vive v2
WHERE p.dni = v.dni
AND s.dniPer = p.dni
AND s.dniSup = sup.dni
AND v2.dni = sup.dni
AND v.calle = v2.calle
AND v.ciudad = v2.ciudad;


--f)Encontrar todas las personas que ganan más que 
--  cualquier empleado de la empresa “Clarín”.
SELECT p.dni, p.nomPersona, t.salario
FROM Persona p, Trabaja t,
(SELECT MAX(t.salario) maximo FROM Trabaja t
 WHERE t.nomEmpresa LIKE 'Clar_n'
 AND t.feEgreso IS NULL) maxSuelClarin
WHERE t.salario > maxSuelClarin.maximo
AND t.dni = p.dni
AND t.feEgreso IS NULL;


--g)Localizar las ciudades en las que todos los 
--  trabajadores que vienen en ellas ganan más de $1000.

SELECT v.ciudad FROM Vive v
EXCEPT ( SELECT v.ciudad FROM Trabaja t, Vive v
		 WHERE t.salario <= 1000
	     AND t.feEgreso IS NULL
		 AND v.dni = t.dni);

-- no funciona y con not exists tampoco
SELECT * FROM Vive v
WHERE v.dni NOT IN(SELECT p.dni FROM Persona p
				  WHERE p.dni 
				  NOT IN (SELECT t.dni FROM Trabaja t
								  WHERE T.salario > 1000
								  AND t.feEgreso IS NULL));


--h)Listar los primeros empleados que la compañía “Sony” 
--  contrató.

SELECT t.dni FROM Trabaja t, 
(SELECT MIN(t.feIngreso) fecha_mas_antigua FROM Trabaja t
WHERE t.nomEmpresa LIKE 'So%') primer_fecha_sony
WHERE t.feIngreso = primer_fecha_sony.fecha_mas_antigua
AND t.nomEmpresa LIKE 'So%';


--i)Listar los empleados que hayan ingresado en mas de 4 
--  Empresas en el periodo 01-01-2000 y 31-03-2004 y que 
--  no hayan tenido menos de 5 supervisores

SELECT t.dni, COUNT(s.dniSup) cant_sup, COUNT(t.dni) cant_trab
FROM Trabaja t, Supervisa s
WHERE t.feIngreso >= '2000-01-01' 
AND t.feIngreso <= '2004-03-31'
AND t.dni = s.dniPer
GROUP BY t.dni
HAVING COUNT(t.dni) > 4
AND COUNT(s.dniSup) >= 5;