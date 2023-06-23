USE Ejercicio_8;
GO

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

INSERT INTO Frecuenta (idPersona, idBar)
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

INSERT INTO Sirve (idBar, idCerveza)
VALUES	
		(1, 2), 
		(1, 3), 
		(2, 1), 
		(2, 4), 
		(3, 1),
		(3, 3);

INSERT INTO Gusta (idPersona, idCerveza)
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
