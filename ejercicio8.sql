CREATE DATABASE ejercicio8;

USE ejercicio8;

CREATE TABLE Persona(
id INTEGER,
nombre VARCHAR(50),
CONSTRAINT idPersona PRIMARY KEY(id));

CREATE TABLE Bar(
id INTEGER,
nombre VARCHAR(50),
CONSTRAINT idBar PRIMARY KEY(id));

CREATE TABLE Cerveza(
id INTEGER,
nombre VARCHAR(50),
CONSTRAINT idCerveza PRIMARY KEY(id));

CREATE TABLE Frecuenta(
persona INTEGER,
bar INTEGER,
CONSTRAINT PKFrecuenta PRIMARY KEY(persona, bar),
CONSTRAINT personaIdFrec FOREIGN KEY(persona)
REFERENCES Persona(id),
CONSTRAINT barIdFrec FOREIGN KEY(bar)
REFERENCES Bar(id));

CREATE TABLE Sirve(
bar INTEGER,
cerveza INTEGER,
CONSTRAINT PKSirve PRIMARY KEY(bar, cerveza),
CONSTRAINT barIdSirv FOREIGN KEY(bar)
REFERENCES Bar(id),
CONSTRAINT cervezaIdSirv FOREIGN KEY(cerveza)
REFERENCES Cerveza(id));

CREATE TABLE Gusta(
persona INTEGER,
cerveza INTEGER,
CONSTRAINT PKGusta PRIMARY KEY(persona, cerveza),
CONSTRAINT personaIdGusta FOREIGN KEY(persona)
REFERENCES Persona(id),
CONSTRAINT cervezaIdGusta FOREIGN KEY(cerveza)
REFERENCES Cerveza(id));

INSERT INTO Persona (id, nombre)
VALUES 
		(1, 'Juan'), 
		(2, 'Maria'), 
		(3, 'Pedro'), 
		(4, 'Lucia'), 
		(5, 'Roberto'), 
		(6, 'Sofía'),
		(7, 'Julia');

INSERT INTO Bar (id, nombre)
VALUES 
		(1, 'Bar 1'), 
		(2, 'Bar 2'), 
		(3, 'Bar 3');

INSERT INTO Cerveza (id, nombre)
VALUES	(1, 'Cerveza 1'), 
		(2, 'Cerveza 2'), 
		(3, 'Cerveza 3'), 
		(4, 'Cerveza 4');

INSERT INTO Frecuenta (persona, bar)
VALUES	
		(1, 2), 
		(1, 3), 
		(2, 1), 
		(3, 2), 
		(4, 3), 
		(5, 1), 
		(5, 2), 
		(5, 3), 
		(6, 2),
		(7, 2);

INSERT INTO Sirve (bar, cerveza)
VALUES	
		(1, 2), 
		(1, 3), 
		(2, 1), 
		(2, 4), 
		(3, 1),
		(3, 3);

INSERT INTO Gusta (persona, cerveza)
VALUES	
		(1, 3), 
		(1, 4), 
		(2, 1), 
		(3, 2), 
		(4, 3), 
		(5, 4), 
		(6, 4),
		(7, 1),
		(7, 4);


--1)Frecuentan solamente bares que sirven alguna 
--  cerveza que les guste.

SELECT  DISTINCT p.id, p.nombre 
FROM Persona p, Frecuenta f, Sirve s, Gusta g
WHERE p.id = f.persona
AND f.bar = s.bar
AND s.cerveza = g.cerveza
AND p.id = g.persona;


--2)No frecuentan ningún bar que sirva alguna 
--  cerveza que les guste.

SELECT DISTINCT p.id, p.nombre 
FROM Persona p, Frecuenta f
WHERE p.id = f.persona
EXCEPT
SELECT DISTINCT p.id, p.nombre 
FROM Persona p, Frecuenta f, Sirve s, Gusta g
WHERE p.id = f.persona
AND f.bar = s.bar
AND s.cerveza = g.cerveza
AND p.id = g.persona;


--3)Frecuentan solamente los bares que sirven todas 
--  las cervezas que les gustan.
SELECT DISTINCT f.persona FROM Frecuenta f
JOIN Sirve s
ON f.bar = s.bar
JOIN Gusta g 
ON s.cerveza = g.cerveza
WHERE f.persona = g.persona

--4)Frecuentan solamente los bares que no sirven 
--  ninguna de las cervezas que no les gusta.

