CREATE DATABASE ejercicio9;

USE ejercicio9;

CREATE TABLE Persona
(
DNI       numeric(8,0) PRIMARY KEY,
Nombre    varchar(30),
Direccion varchar(80),
FechaNac  date,
Sexo      char(1),
)

CREATE TABLE Progenitor
(
DNI       numeric(8,0),
DNI_Hijo  numeric(8,0),
PRIMARY KEY (DNI, DNI_Hijo),
FOREIGN KEY (DNI) REFERENCES Persona(DNI),
FOREIGN KEY (DNI_Hijo) REFERENCES Persona(DNI),
)


INSERT INTO Persona (DNI,NOMBRE,SEXO) VALUES (10100100,'Hector','M');
INSERT INTO Persona (DNI,NOMBRE,SEXO) VALUES (10100200,'Maria','F');
INSERT INTO Persona (DNI,NOMBRE,SEXO) VALUES (10200100,'Francisco','M');
INSERT INTO Persona (DNI,NOMBRE,SEXO) VALUES (10200200,'Juana','F');
INSERT INTO Persona (DNI,NOMBRE,SEXO) VALUES (20100100,'Jorge','M');
INSERT INTO Persona (DNI,NOMBRE,SEXO) VALUES (20100200,'Claudio','M');
INSERT INTO Persona (DNI,NOMBRE,SEXO) VALUES (20100300,'Susana','F');
INSERT INTO Persona (DNI,NOMBRE,SEXO) VALUES (20200100,'Oscar','M');
INSERT INTO Persona (DNI,NOMBRE,SEXO) VALUES (20200200,'Alicia','F');
INSERT INTO Persona (DNI,NOMBRE,SEXO) VALUES (30100100,'Diego','M');
INSERT INTO Persona (DNI,NOMBRE,SEXO) VALUES (30100200,'Natalia','F');
INSERT INTO Persona (DNI,NOMBRE,SEXO) VALUES (30200100,'Pablo','M');
INSERT INTO Persona (DNI,NOMBRE,SEXO) VALUES (30200200,'Laura','F');
INSERT INTO Persona (DNI,NOMBRE,SEXO) VALUES (30200300,'Sabrina','F');


INSERT INTO Progenitor (DNI,DNI_HIJO) VALUES (10100100,20100100);
INSERT INTO Progenitor (DNI,DNI_HIJO) VALUES (10100100,20100200);
INSERT INTO Progenitor (DNI,DNI_HIJO) VALUES (10100100,20100300);
INSERT INTO Progenitor (DNI,DNI_HIJO) VALUES (10100200,20100100);
INSERT INTO Progenitor (DNI,DNI_HIJO) VALUES (10100200,20100200);
INSERT INTO Progenitor (DNI,DNI_HIJO) VALUES (10100200,20100300);
INSERT INTO Progenitor (DNI,DNI_HIJO) VALUES (10200100,20200100);
INSERT INTO Progenitor (DNI,DNI_HIJO) VALUES (10200100,20200200);
INSERT INTO Progenitor (DNI,DNI_HIJO) VALUES (10200200,20200100);
INSERT INTO Progenitor (DNI,DNI_HIJO) VALUES (10200200,20200200);
INSERT INTO Progenitor (DNI,DNI_HIJO) VALUES (20100100,30100100);
INSERT INTO Progenitor (DNI,DNI_HIJO) VALUES (20100100,30100200);
INSERT INTO Progenitor (DNI,DNI_HIJO) VALUES (20200200,30100100);
INSERT INTO Progenitor (DNI,DNI_HIJO) VALUES (20200200,30100200);
INSERT INTO Progenitor (DNI,DNI_HIJO) VALUES (20100300,30200100);
INSERT INTO Progenitor (DNI,DNI_HIJO) VALUES (20100300,30200200);
INSERT INTO Progenitor (DNI,DNI_HIJO) VALUES (20100300,30200300);
INSERT INTO Progenitor (DNI,DNI_HIJO) VALUES (20200100,30200100);
INSERT INTO Progenitor (DNI,DNI_HIJO) VALUES (20200100,30200200);
INSERT INTO Progenitor (DNI,DNI_HIJO) VALUES (20200100,30200300);



--1)Hallar para una persona dada, por ejemplo José Pérez, los tipos y números de
--  documentos, nombres, dirección y fecha de nacimiento de todos sus hijos.
SELECT hijo.DNI, hijo.Nombre, hijo.Direccion, hijo.FechaNac
FROM Persona padre, Persona hijo, Progenitor pro
WHERE padre.Nombre LIKE 'Oscar'
AND pro.DNI = padre.DNI
AND hijo.DNI = pro.DNI_Hijo;


--2)Hallar para cada persona los tipos y números de documento, nombre, domicilio y
--  fecha de nacimiento de:
--  a. Todos sus hermanos, incluyendo medios hermanos.
SELECT DISTINCT persona.DNI, persona.Nombre, hermano.DNI, hermano.Nombre
FROM Persona persona, Persona hermano, Progenitor pro1, Progenitor pro2
WHERE pro1.DNI_Hijo = persona.DNI
AND pro1.DNI = pro2.DNI
AND pro2.DNI_Hijo = hermano.DNI
AND hermano.DNI <> persona.DNI;

--b. Su madre
SELECT DISTINCT persona.DNI, persona.Nombre, mad.DNI, mad.Nombre
FROM Persona persona, Progenitor madre, Persona mad
WHERE madre.DNI_Hijo = persona.DNI
AND mad.DNI = madre.DNI
AND mad.Sexo = 'F';

--c. Su abuelo materno
SELECT DISTINCT persona.DNI, persona.Nombre, abMat.DNI, abMat.Nombre
FROM Persona persona, Progenitor madre, Persona mad, Progenitor abuelo, Persona abMat
WHERE abMat.DNI = abuelo.DNI
AND abMat.Sexo = 'M'
AND abuelo.DNI_Hijo = madre.DNI
AND madre.DNI = mad.DNI
AND mad.Sexo = 'F'
AND madre.DNI_Hijo = persona.DNI;

--d. Todos sus nietos
SELECT DISTINCT persona.DNI, persona.Nombre, nieto.DNI, nieto.Nombre
FROM Persona persona, Persona nieto, Progenitor abuelo, Progenitor padre
WHERE abuelo.DNI_Hijo = padre.DNI
AND padre.DNI_Hijo = nieto.DNI
AND abuelo.DNI = persona.DNI;