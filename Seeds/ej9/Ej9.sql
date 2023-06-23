USE Ejercicio_9;
GO

INSERT INTO Persona (NroDoc, Nombre, Dirección, FechaNac, Sexo)
VALUES (1, 'Roberto', 'Calle 1', '1920-01-01', 'M'),
       (2, 'Juan', 'Calle 2', '1950-01-01', 'M'),
       (3, 'Maria', 'Calle 3', '1955-02-02', 'F'),
       (4, 'Carlos', 'Calle 4', '1950-05-05', 'M'),
       (5, 'Ana', 'Calle 5', '1955-06-06', 'F'),
       (6, 'Pedro', 'Calle 6', '1980-03-03', 'M'),
       (7, 'Lucia', 'Calle 7', '1985-04-04', 'F'),
       (8, 'Pablo', 'Calle 8', '1980-07-07', 'M'),
       (9, 'Laura', 'Calle 9', '1985-08-08', 'F'),
       (10, 'Jorge', 'Calle 10', '2010-09-09', 'M'),
       (11, 'Sofia', 'Calle 11', '2015-10-10', 'F'),
       (12, 'Mateo', 'Calle 12', '2012-11-11', 'M'),
       (13, 'Camila','Calle 13','2013-12-12','F');

INSERT INTO Progenitor (NroDoc, NroDocHijo)
VALUES (1, 2), (1, 4), -- Roberto es progenitor de Juan y Carlos
       (2, 6), (3, 6), -- Juan y Maria son progenitores de Pedro
       (2, 7), (3, 7), -- Juan y Maria son progenitores de Lucia
       (4, 8), (5, 8), -- Carlos y Ana son progenitores de Pablo
       (4, 9), (5, 9), -- Carlos y Ana son progenitores de Laura
       (6, 10), -- Pedro es progenitor de Jorge
       (7, 11), -- Lucia es progenitora de Sofia
       (7, 12), -- Lucia es progenitora de Mateo
       (7, 13); -- Lucia es progenitora de Camila

/*
1. Hallar para una persona dada, por ejemplo José Pérez, los tipos y números de documentos, nombres, dirección y fecha de nacimiento de todos sus hijos.
*/


create or alter Function dbo.PersonaHijo(@nombre varchar(20))
returns table
as
return
(
select *
from Persona
where NroDoc in(
				select PRO.NroDocHijo
				from [dbo].[Persona] PER
				JOIN [dbo].[Progenitor] PRO
				on PER.NroDoc=PRO.NroDoc
				where PER.Nombre LIKE @nombre+'%'
				)
);

select *
from PersonaHijo('Roberto')

/*2. Hallar para cada persona los tipos y números de documento, nombre, domicilio y
fecha de nacimiento de:
a. Todos sus hermanos, incluyendo medios hermanos.
b. Su madre
c. Su abuelo materno
d. Todos sus nietos*/create or alter Function dbo.PersonaHermano(@nombre varchar(20))
returns table
as
return
(
select *
from Persona
where NroDoc in(/*---*/
				select PRO.NroDocHijo
				from(
					select PRO.NroDoc
					from [dbo].[Persona] PER
					JOIN [dbo].[Progenitor] PRO
					on PER.NroDoc=PRO.NroDocHijo
					where PER.Nombre LIKE @nombre+'%'
					)PER
						join [dbo].[Progenitor] PRO
						on PER.NroDoc=PRO.NroDoc
		except
(
	select PER.NroDoc
	from [dbo].[Persona] PER
	JOIN [dbo].[Progenitor] PRO
	on PER.NroDoc=PRO.NroDocHijo
	where PER.Nombre LIKE @nombre+'%'
)
			 /*---*/)
);create or alter Function dbo.PersonaMadre(@nombre varchar(20))
returns table
as
return
(
select *
from Persona
where NroDoc in(
				select PRO.NroDoc
				from [dbo].[Persona] PER
				JOIN [dbo].[Progenitor] PRO
				on PER.NroDoc=PRO.NroDocHijo
				where PER.Nombre LIKE @nombre+'%'
				) and Sexo='F'
)create or alter Function dbo.PersonaAbuelo(@nombre varchar(20))
returns table
as
return
(
select *
from Persona
where NroDoc in(
				select PRO.NroDoc
				from(
				select pro.NroDoc
				from  [dbo].[Persona] PER
				JOIN [dbo].[Progenitor] PRO
				on per.NroDoc=pro.NroDocHijo
				where per.Nombre like @nombre+'%'
				)PER
					join [dbo].[Progenitor] PRO
					on PER.NroDoc=PRO.NroDocHijo
				)
)create or alter Function dbo.PersonaNieto(@nombre varchar(20))
returns table
as
return
(	
select *
from Persona
where NroDoc in(
				select PRO.NroDocHijo
				from(
					select PRO.NroDocHijo
					from [dbo].[Persona] PER
					join [dbo].[Progenitor] PRO
					on PER.NroDoc=PRO.NroDoc
					where PER.Nombre like @nombre+'%'
					)PER
						JOIN [dbo].[Progenitor] PRO
						on PER.NroDocHijo =PRO.NroDoc
				)
)--Aselect *from PersonaHermano('Juan')--Bselect *from PersonaMadre('Sofia')--cselect *from PersonaAbuelo('Pedro')--dselect *from PersonaNieto('Roberto')