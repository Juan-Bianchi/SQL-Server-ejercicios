USE Ejercicio_9;
GO

INSERT INTO Persona (NroDoc, Nombre, Dirección, FechaNac, Sexo)
VALUES 
		(1, 'Roberto', 'Calle 1', '1920-01-01', 'M'),
		(2, 'Julio', 'Calle 2', '1920-01-01', 'M'),
		(3, 'Juan', 'Calle 3', '1950-01-01', 'M'),
		(4, 'Maria', 'Calle 4', '1955-02-02', 'F'),
		(5, 'Carlos', 'Calle 5', '1950-05-05', 'M'),
		(6, 'Ana', 'Calle 6', '1955-06-06', 'F'),
		(7, 'Pedro', 'Calle 7', '1980-03-03', 'M'),
		(8, 'Lucia', 'Calle 8', '1985-04-04', 'F'),
		(9, 'Pablo', 'Calle 9', '1980-07-07', 'M'),
		(10, 'Laura', 'Calle 10', '1985-08-08', 'F'),
		(11, 'Jorge', 'Calle 11', '2010-09-09', 'M'),
		(12, 'Sofia', 'Calle 12', '2015-10-10', 'F'),
		(13, 'Mateo', 'Calle 13', '2012-11-11', 'M'),
		(14, 'Camila','Calle 14','2013-12-12','F');

INSERT INTO Progenitor (NroDoc, NroDocHijo)
VALUES 
		(1, 3), (1, 5),		-- Roberto es progenitor de Juan y Carlos
		(2, 4),				-- Julio es progenitor de Maria
		(3, 7), (4, 7),		-- Juan y Maria son progenitores de Pedro
		(3, 8), (4, 8),		-- Juan y Maria son progenitores de Lucia
		(5, 9), (6, 9),		-- Carlos y Ana son progenitores de Pablo
		(5, 10), (6, 10),	-- Carlos y Ana son progenitores de Laura
		(7, 11),			-- Pedro es progenitor de Jorge
		(8, 12),			-- Lucia es progenitora de Sofia
		(8, 13),			-- Lucia es progenitora de Mateo
		(8, 14);			-- Lucia es progenitora de Camila


/*
			  Roberto
	Julio		 |
	  |		 ----------
	  |		 |        |
	Maria y Juan   Carlos y Ana
	      |				 |
	  ---------		 ---------
	  |       |		 |       |
	Pedro   Lucia   Pablo  Laura
	  |       |
	Jorge    Sofia,Mateo,Camila
*/
