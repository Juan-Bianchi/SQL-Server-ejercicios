 
 -- LENGUAJE SQL. ESTANDAR. ANSI-SQL (ver 92, 97, 99, 2007, 2014, etc)
 -- MOTORES TIENEN LENGUAJES PROPIOS: 
		-- POSTGRES PG/PLSQL
		-- ORACLE PLSQL
		-- ETC
		-- MS SQL (SQL SERVER) TRANSACT SQL (TSQL) link: https://go.microsoft.com/fwlink/?linkid=866662
		-- link MS-SQLMS https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver16
		

 -- BASES DE DATOS
 -- Una base de datos, es un elemento dentro del motor de bases de datos. Esta compuesto por dos o m�s archivos f�sicos, 
 -- donde las tablas ser�n elementos dentro de estos archivos. 
 -- Uno de los archivos es el que contiene la base de datos en s�, mientras que el otro es un archivo de log.

 /*
 

DDL =Data Definition Language
	ejemplo: CREATE -, Alter, DROP + <tipo de objeto (Database, table, view, procedure, trigger, function, user, schema...)>, etc

DML= lenguaje de manipulación de datos
	ejemplo: SELECT, insert, update, delete, etc

DCL=DATA CONTROL LANGUAGE
   ejemplo:GRANT,remoke, deny, etc

TCL=Lenguaje CONTROL DE TRANSACCIÓN 
	ejemplo:COMMIT, rollback,etc

*/



----Crear una base de 
CREaTE DATABASE ejemplo123 -------------;
--CREATE DATABASE CLASE SABADO
CREATE DATABASE [CLASE SABADO '22]
-- ejemplo de modificaci�n de parametros.  
ALTER DATABASE [CLASE SABADO '22] MODIFY NAME = new_database_name
 --ALTER DATABASE new_database_name MODIFY NAME = ejemplo123 --> DA ERROR PORQUE YA EXISTIA UNA DB CON ESE NOMBRE

-- borrado de una base de datos
 DROP DATABASE new_database_name;


 -- validar si existe la base de datos
 SELECT * FROM sys.databases 

 -- Usar la base de datos;
 USE ejemplo123;

----Que es un esquema?
--Un esquema es un conjunto o agrupador de elementos dentro de la base de datos. Por ejemplo, podemos tener dentro de una 
-- misma base de datos, 1 esquema para desarrollo, 1 para testing y uno para producci�n.

-- CREAR Esquema
CREATE SCHEMA desarrollo;


-- BORRAR Esquema
DROP SCHEMA desarrollo;

--> dbo -> ESQUEMA POR DEFECTO DE MSSQL SERVER 

----Tipos de datos
-- dentro de un motor de base de datos (SQL server 2017)

-- ENTEROS --
bigint		--> ENTERO 8 bytes
int			--> ENTERO 4 bytes
smallint	--> ENTERO 2 bytes
tinyint		--> ENTERO 1 byte

-- BOOLEANO --
bit			--> ENTERO 1 byte 1 / 0 / NULL

-- CON DECIMALES --
numeric (L, d)	--> L= largo total (parte entera + decimal) 
				--> d = cantidad de decimales 1.000.000,00 DECIMAL(9,2)
decimal	(L, d) 


FLOAT , Real,


smallmoney		--> 4 Bytes. Representa numeros con simbolo de dinero. 
money			--> 8 bytes

-- CADENAS DE TEXTO --
char (L)		--> Almacena la cantidad indicada en "L". si pongo Char(5) y guardo ANA, guarar� 3 carateres para ANA y 2 m�s hasta llegar a 5
varchar(L)     --> Almacena la cadena ingresada y si es de largo menor a "L" guarda la cantidad de la cadena. 
				--> ejemplo: VARCHAR(5) "ANA" guarda ANA y 3. si guarda JUAN guarda la cadena y 4.
varchar(MAX)    --> MAXIMO PERMITIDO POR EL MOTOR 

-- CADENAS DE TEXTO UNICODE --
nchar (L)
nvarchar (L)

-- FECHAS & HORAS --
--> todos los datos de fecha se guardan como un n�mero, numero que se toma como 0 un momento dado en el tiempo y luego en milisegundos a partir de ah�.

date		--> el ANSI SQL (est�ndar) indica que el 0 es 1582, 10, 15, y llegar�a hasta el 9999, 12, 31, seg�n el tama�o en bytes del campo
time		--> horas
datetime    --> fecha y hora. Arrancando 1753, 1 de enero.
smalldatetime --> fecha y hora, pero el "0" es un valor m�s pr�ximo que 1753, arrancando de 1900, 1, 1. 
datetime2		--> arranca en 1900, 1, 1 y almacena en 6 bytes el tama�o, para mayor precisi�n en los milisegundos


 -->> QUE VALOR TIENE, EN MILISEGUNDOS, LA FECHA DE INICIO DE LA CLASE DE HOY? 2022/10/30 08:35:00.0000


----Crear una tabla
CREATE TABLE nombreTabla
(
	CAMPO1 int,
	CAMPO2 VARCHAR(6),
	[NOMBRE LARGO CAMPO] DECIMAL(12,2)
)	;


CREATE TABLE desarrollo.nombreTabla
(
	CAMPO1 int,
	CAMPO2 VARCHAR(6)
);	

--EJEMPLO SCHEMA ERRONEO
/*
CREATE TABLE SCHEMA_INEXISTENTE.nombreTabla
(
	CAMPO1 int,
	CAMPO2 VARCHAR(6)
)	
*/

select * from nombreTabla; -- solo nombre de la tabla
select * from ejemplo123.dbo.nombreTabla; -- nombre de la DB.SCHEMA.TABLA
select * from ejemplo123.desarrollo.nombreTabla;


-- MODIFICAR
ALTER TABLE nombreTabla
	ADD campo3 bigint;
	
ALTER TABLE nombreTabla
	ALTER COLUMN campo3 datetime;

ALTER TABLE nombreTabla
	DROP COLUMN campo3;

-- BORRAR
DROP TABLE nombreTabla;

----Mostrar pk
-- PARA CREAR UNA TABLA CON CLAVE PRIMARIA O PRIMARY KEY, HAY DOS OPCIONES
CREATE TABLE tablaUno
(
	CAMPO1 int primary key,
	CAMPO2 VARCHAR(6)
)	;

CREATE TABLE tablaDos
(
	CAMPO1 int,
	CAMPO2 nvarchar(max),   -- <<--- si agregamos la palabra reservada MAX tendremos el largo m�ximo del tipo nvarchar
	PRIMARY KEY (campo1)
);	

--> pk's compuestas
CREATE TABLE tablaTres
(
	CAMPO1 INT,
	CAMPO2 VARCHAR(6),
	PRIMARY KEY (campo1, CAMPO2)
)	;
/*No se puede*/
CREATE TABLE tablaCuatro
(
	CAMPO1 INT PRIMARY KEY,
	CAMPO2 VARCHAR(6),
	PRIMARY KEY (campo1, CAMPO2,)
)	;

-------------------------------
--EJEMPLO

CREATE TABLE Persona1
(
	NroDoc INT,
	tipoDoc VARCHAR(3),
	PRIMARY KEY (NroDoc, tipoDoc)
)	;


-- NO DISCRIMNA ENTRE MAYUSCULAS Y MIN.
Select * from tablaTres
Select * frOm TABLATRES
Select * from tAblAtREs
SeLeCt * FrOm TABLATRES

-- ejemplo
CREATE TABLE persona
(
	nroDoc BIGINT, 
	tipoDoc CHAR(3),
	nombre VARCHAR(40),
	apellido VARCHAR(40),
	PRIMARY KEY (nroDoc, tipoDoc)
)

-- drop table persona

-- CLAVES FOR�NEAS -- 
--> Las claves for�neas estan asociadas a campos clave de otras tablas

CREATE TABLE tablaPk
(
	CAMPO1 int primary key,
	CAMPO2 VARCHAR(6)
)	

-- NO PUEDO CAMBIAR EL TIPO DE DATO 
ALTER TABLE tablapk
	ALTER COLUMN CAMPO1 VARCHAR(50)

--drop table tablapk
--drop table tablaFk
CREATE TABLE tablaFk
(
	CAMPOa int primary key,
	CAMPOb VARCHAR(6),
	CAMPOc int not null,
	FOREIGN KEY (campoC) REFERENCES tablaPk(campo1) -- <<--- indicamos que campo de la tablaFk apunta a que campo de la tablaPk
)

--Eliminar PK o FK
alter table tablaFk
drop constraint  FK__tablaFk__CAMPOc__3F466844;


--ejemplo

CREATE TABLE provincia
(
	id int,
	nombre varchar(40), 
	primary key(id)
)

-- drop table provincia



-- comentario una linea

/* comentario
muchas lineas
*/

CREATE TABLE localidad
(
	codigo int,
	nombre varchar(40),
	codigo_tabla_provincia int, 

	primary key(codigo),
	foreign key (codigo_tabla_provincia) references provincia(id)
)

-- COMO CONOCER LA ESTRUCTURA DE UNA TABLA?
SP_HELP  localidad

-- ERROR AL REFERENCIAR CON DISTINTO TIPO
CREATE TABLE tablaFk_ERROR
(
	CAMPOa int primary key,
	CAMPOb VARCHAR(6),
	CAMPOc VARCHAR(5),
	FOREIGN KEY (campoC) REFERENCES tablaPk(campo1) -- <<--- indicamos que campo de la tablaFk apunta a que campo de la tablaPk
)
----------->>> EJEMPLO TERNARIA 
-- A(a1 pk, a2, a3)
-- B(b1 pk, b2, b3)
-- C(c1 pk, c2, c3)
-- R (a1, b1, c1) donde todos son PK y FK

CREATE TABLE A 
(
	a1 int primary key,
	a2 int,
	a3 int
);

CREATE TABLE B
(
	b1 int primary key,
	b2 int,
	b3 int
);

CREATE TABLE C
(
	c1 int primary key,
	c int,
	c3 int
);

CREATE TABLE R
(
	a1 int,
	b1 int,
	c1 int,
	primary key (a1, b1, c1),
	foreign key (a1) references A(a1),
	foreign key (b1) references B(b1),
	foreign key (c1) references C(c1)
);

sp_help R

-<<<<<---------- EJEMPLO TERNARIA 

-- TRABAJANDO CON DATOS

-- INSERT / UPDATE / DELETE 

----Insertar en tabla
-- Hay varias formas de insertar datos en una base de datos, por fila o tupla o con muchas filas o tuplas

-- INSERTAR 1 FILA
sp_help tablaUno
INSERT INTO tablaUno (CAMPO1, CAMPO2) VALUES 
					  (1,     'A'); -- ORDEN RELATIVO AL CONJUNTO DE CAMPOS
INSERT INTO tablaUno (CAMPO2, CAMPO1) VALUES ('A', 10); -- ORDEN RELATIVO AL CONJUNTO DE CAMPOS

INSERT INTO tablaUno VALUES (2, 'B'); -- ORDEN POR POSICI�N

-- INSERTANDO M�S DE UNA TUPLA A LA VEZ
INSERT INTO tablaUno VALUES (3, 'C'), (4, 'H'), (5, 'G'), (6, 'F'); -- ORDEN POR POSICI�N


-- resulatdo:
SELECT * FROM tablaUno;

-- INSERTANDO MAS DE UNA TUPLA DESDE OTRA TABLA

INSERT INTO tablaDos (CAMPO1, CAMPO2)
SELECT database_id, name 
FROM sys.Databases -- << inserto todos los elementos de la tabla sys.databases


-- resultado:
SELECT * FROM tablaUno;
SELECT * FROM tablaDos;
-- delete from tablaDos;

----MODIFICAR TUPLAS DE UNA TABLA
--PRUEBA:
SELECT *, upper(campo2) + ' - MODIFICADO' as [campo2 en mayuscula] FROM tablaDos -- listo el contenido de la tabla

UPDATE tablaDos              -- INDICO LA TABLA A MODIFICARLE INFORMACION
SET
	CAMPO2 = UPPER(CAMPO2) + ' - MODIFICADO',  -- INDICO EL CAMPO2 Y SU NUEVO VALOR
	CAMPO1 = CAMPO1 + 100                      -- INDICO EL CAMPO1 Y SU NUEVO VALOR

WHERE CAMPO2 = 'master';                      -- FILTRO 

SELECT * FROM tablaDos -- listo el contenido de la tabla, para ver los cambios.

----Borrar
DELETE FROM tablaDos -- << indico la tabla donde voy a borrar info
WHERE campo2 = 'msdb' -- << indico la condicion

----OBTENIENDO INFORMACI�N
-- Para obtener informaci�n de las tablas, se debe utilizar lo que llamamos consultas tipo "SELECT"

-->> CONSULTAS SIN CONDICI�N --> SIMILAR A LA SELECCION
SELECT *             -- << indicamos la palabra SELECT y luego "*" asterisco para listar todos los campos, o detallo los campos 1 a 1
FROM tablaDos        -- << detallamos la tabla


---- CON CONDICI�N --> (ES LA SELECCION EN AR)
SELECT * 
FROM tablaDos 
WHERE campo1 = 3;	-- << con la clausula where, podemos detallar las condiciones, para hacer un filtro horizontal de filas
					-- operadores: = <= >= <>, LIKE, EXISTS, IN, NOT, OR, AND

-- EJEMPLO: IN
SELECT * 
FROM tablaDos 
WHERE campo1 IN (3, 6, 5)  

--- equivalente a 
SELECT * 
FROM tablaDos 
WHERE campo1 = 3 OR campo1 = 6 OR campo1 = 5

---- NOT IN
SELECT * 
FROM tablaDos 
WHERE campo1 NOT IN (3, 6, 5)
--- equivalente a 
SELECT * 
FROM tablaDos 
WHERE campo1 <> 3 and campo1 <> 6 and campo1 <> 5


SELECT * 
FROM tablaDos 
WHERE campo1 = 4 OR 	-- << LIKE SIRVE PARA COMPARAR TEXTOS, CAMPOS TIPO CHAR / VARCHAR.
 campo2 LIKE '%MOD%'							-- << SE PUEDEN USAR "wildcards" o comodines "%", 0 o m�s caracteres
											-- << "_" UN CARACTER

SELECT * 
FROM tablaDos 
--WHERE  --campo2 LIKE '%!_2%'   '+'_'+'%'
SELECT * 
FROM tablaDos 
where campo2 like '%'+'_!'+'%'
----*************************

SELECT * 
FROM tablaDos 
WHERE campo2 LIKE 'mo_el'	                -- << "_" UN CARACTER en medio de otros 

SELECT * 
FROM tablaDos 
WHERE campo2 LIKE 'MSX_B'	                -- << "_" UN CARACTER en medio de otros 


----Uni�n: el operador uni�n "une" dos consultas en un �nico resultado
--SP_HELP TABLAUNO
--SP_HELP  TABLADOS


SELECT * 
FROM tablaUno

UNION 

SELECT *--CAMPO1, CAMPO2
FROM tablaDos


----Resta
SELECT *  FROM tablaUno 

EXCEPT


SELECT * 
FROM tablaDos
/** eliminar duplicados  Distinct

SELECT  distinct Campo2
FROM tablaUno

*/
----Inserci�n

/**Para que de resulatdos*/
update tablaDos
set CAMPO1=1,
CAMPO2='A'
where CAMPO1=7


SELECT * 
FROM tablaUno

INTERSECT 

SELECT * 
FROM tablaDos



----Producto 
SELECT *
FROM tablaUno, tablaDos -- << separando en el FROM las tablas por comas, se realiza un producto cartesiano.
--> AR: tablaUno X tablaDos 

----Juntas 
SELECT * 
FROM tablaUno JOIN tablaDos 
	ON tablaUno.CAMPO1 = tablaDos.CAMPO1 
	 
-- luego del "ON" se indica los campos relacionados entre las tablas
--> AR: tablaUno |X| tablaDos

-- esto es equivalente a
SELECT * 
FROM tablaUno, tablaDos 
WHERE tablaUno.CAMPO1 = tablaDos.CAMPO1 -- < PRODUCTO CARTESIANO + UNA SELECCION


---- JUNTAS A IZQUIERDA
-- ESTE tipo de juntas mostrar� todas las filas de la tabla a izquierda, lo que pueda juntar a derecha. Cuando no tenga con que 
-- emparejar.
SELECT * 
FROM tablaUno LEFT JOIN tablaDos 
	ON   tablaUno.CAMPO1 = tablaDos.CAMPO1
 
	   
--> AR: tablaUno |X tablaDos

---- JUNTAS A DERECHA
-- ESTE tipo de juntas mostrar� todas las filas de la tabla a DERECHA, lo que pueda juntar a derecha. Cuando no tenga con que 
-- emparejar.
SELECT * 
FROM tablaUno RIGHT JOIN tablaDos 
	ON tablaUno.CAMPO1 = tablaDos.CAMPO1
--> AR: tablaUno X| tablaDos


-- EJEMPLO DE REEMPLAZO DE NULOS POR UN VALOR QUE YO QUIERA
SELECT ISNULL(tablaUno.CAMPO1, 0) as campo1, tablaUno.CAMPO2, tablaDos.CAMPO1, tablaDos.CAMPO2
FROM tablaUno RIGHT JOIN tablaDos 
	ON tablaUno.CAMPO1 = tablaDos.CAMPO1

---- JUNTAS COMPLETAS
-- ESTE tipo de juntas mostrar� todas las filas de la tabla a izquierda y derecha, 
-- lo que pueda juntar a derecha. Cuando no tenga con que emparejar.
SELECT * 
FROM tablaUno FULL JOIN tablaDos 
	ON tablaUno.CAMPO1 = tablaDos.CAMPO1

-- PARA SABER CUALES VALORES DE AMBAS TABLAS NO TIENEN CORRESPONDENCIA EN LA OTRA.
SELECT * 
FROM tablaUno FULL JOIN tablaDos 
	ON tablaUno.CAMPO1 = tablaDos.CAMPO1
WHERE tablaUno.CAMPO1 is null or tablaDos.CAMPO1 is null
 

----Group by: Los grupos son el equivalente a la AGRUPACI�N de AR.
SELECT CAMPO2
FROM tablaUno 
GROUP BY campo2  -- << SE LISTAR�, CON ESTE EJEMPLO, LOS VALORES DISTINTOS QUE SE TENGAN EN "CAMPO2" 

-- EJEMPLO, CUENTO CUANTAS OCURRENCIAS HAY DE CADA UNA
SELECT CAMPO2 , COUNT(*) as [cantidad de ocurrencias]
FROM tablaUno 
GROUP BY campo2   -- << SE LISTAR�, CON ESTE EJEMPLO, LOS VALORES DISTINTOS QUE SE TENGAN EN "CAMPO2" 

----Having: SI SE QUIERE REALIZAR SELECCIONES O APLICAR CONDICIONES LUEGO DEL GROUP BY, SE UTILIZA LA PALABRA RESERVADA HAVING
SELECT CAMPO2
FROM tablaUno
where campo2 in('A','C')
GROUP BY campo2
HAVING campo2 LIKE 'C' -- << ES IMPORTATE QUE LOS CAMPOS A UTILIZAR EN EL HAVING DEBEN ESTAR CONTENIDOS EN EL GROUP BY

----Orden by 
-- LA ULTIMA LINEA QUE SE TIENE EN EL SELECT ES EL order by. como su nombre lo indica, sirve para ordenar el resultado. 
-- con los decoradores ASC y DESC se indica ordenar ascendente o descendente.

SELECT *
FROM tablaUno
ORDER BY CAMPO1   -- << por defecto, ordena de forma ascendente

SELECT *
FROM tablaUno
ORDER BY CAMPO2 -- << por defecto, ordena de forma ascendente


SELECT *
FROM tablaUno
ORDER BY CAMPO2, CAMPO1 ASC

SELECT *
FROM tablaUno
ORDER BY CAMPO2, CAMPO1 DESC -- << ORDENAMOS Primero por el campo 2, luego por el campo 1. El campo2 de forma asc y el 2 de forma desc

-------------

----Funciones de agregado
MIN -- toma el minimo de un conjunto
SUM -- suma el conjunto
COUNT -- cuenta los elementos de un conjunto. Es la UNICA que si no hay elementos en el 
      --  conjunto no da NULL, da 0.
MAX	  -- toma el maximo de un conjunto.
AVG	  -- promedia el conjunto
STRING_AGG -- acumula strings (concatena) -- incluida en SQL server 2017!!!

-- EJEMPLO CON TABLA VACIA
CREATE TABLE ejemploFuncAgr ( campo1 int );
INSERT INTO ejemploFuncAgr values (1), (2), (3), (4), (5), (1), (2), (3), (4), (5),(1), (2), (3), (4), (5)
SELECT * FROM ejemploFuncAgr ;

SELECT MIN(CAMPO1) AS MINIMO, MAX(campo1) MAXIMO, SUM(CAMPO1) SUMA, COUNT(CAMPO1) CUENTA 
FROM ejemploFuncAgr;

-- EJEMPLO CON DATOS
SELECT MAX(campo1) AS maximo, MIN(campo1) minimo, AVG(campo1), count(campo1), string_agg(campo2, ', ')
FROM tablaUno

-- FUNCIONES DE AGREGADO CON AGRUPADORES
select * from tablaUno;

SELECT 
 MAX(campo1) as maximo, MIN(campo1) minimo, AVG(campo1) [el promedio], 
count(campo1)[conteo de filas], campo2
 
FROM tablaUno
GROUP BY campo2
HAVING max(campo1) > 4

-- FUNCIONES DE AGREGADO CON AGRUPADORES Y FILTRO 
SELECT MAX(campo1) as [CAMPO max], MIN(campo1), AVG(campo1), count(campo1), campo2
FROM tablaUno
GROUP BY campo2
HAVING max(campo1) > 4

-- ALIAS: Renombrar tablas o columnas
SELECT CAMPO1 as c1, CAMPO2 c2
FROM tablaUno t
WHERE t.campo1 = 1
-- AR -->>>> tablaX (c1, c2) <- SEL campo1 = 1 (tabla1)

--distinct 
---> LISTAR SOLO LOS VALORES DISTINTOS DE UNA QUERY
--SIN
SELECT campo2 FROM tablaUno
--CON
SELECT distinct campo2 FROM tablaUno

----Sub Consultas
------------------
--> ejemplo de subconsulta en AR: liste todas las personas que cursaron todas las materias
--      R <- personas / materia (no lo escribiamos as�, sino que.....)
--      R <- PRO id(PERSONAS) - PRO id (  PRO id(PERSONAS) x PRO cod (MATERIAS) ) - PRO persona,materia (CURSA))
-- las subconsultas se pueden hacer en el select, from, where o having. 

-- en el select

SELECT * , (SELECT campo2  FROM tablaDos d WHERE u.campo1 = d.campo1) 
FROM tablaUno u
 
-- ES IMPORTANTE ACLARAR QUE LAS SUB CONSULTAS EN EL SELECT DEBEN DEVOLVER 1 SOLA FILA POR CADA UNA DE LAS DEL SELECT PRINCIPAL
-- LA SUBCONSULTA DEL SELECT SE EJECUTAR� TANTAS VECES COMO FILAS TENGA LA CONSULTA PRINCIPAL

-- EN EL FROM 
SELECT * 
FROM ( 
		SELECT campo1 AS id, campo2 AS descripcion 
		FROM tablaDos 
		WHERE campo1 > 3
	  ) AS T 
WHERE t.descriPcion LIKE '%pruebas'

-- ES IMPORTANTE ACLARAR QUE LAS SUB CONSULTAS EN EL FROM, TIENE QUE TENER SIEMPRE UN ALIAS!!!

-- EN EL WHERE
SELECT *
FROM tablaUno
WHERE campo1 IN (
				SELECT campo1
				FROM tablaDos
				WHERE campo2 LIKE 'm%'
				)

SELECT *
FROM tablaUno u
WHERE EXISTS (
		SELECT 'A'  
		FROM tablaDos d
		WHERE campo2 LIKE 'm%'
		AND u.CAMPO1 = d.CAMPO1
		)
-- MISMA CONSULTA CON EXISTS E IN

-----------------------------------------------------------------------

-- OPERADOR DE DIVISI�N
-- SUPONGAMOS QUE TENEMOS LA CONSULTA, LISTE TODOS LOS ELEMENTOS DE X CONJUNTO QUE TENGA CORRESPONDENCIA CON TODOS LOS 
-- ELEMENTOS DEL 2do CONJUNTO.

-- conjuntos -->> tablas


CREATE TABLE Alumno
(
	legajo VARCHAR(2) PRIMARY KEY, 
	nombre VARCHAR(50)
);

CREATE TABLE Materia
(
	codigo VARCHAR(2) PRIMARY KEY,
	nombre VARCHAR(50)
)

CREATE TABLE Rinde
(
	alumno VARCHAR(2), 
	materia VARCHAR(2),
	PRIMARY KEY (materia, alumno),
	FOREIGN KEY (alumno) REFERENCES alumno (legajo),
	FOREIGN KEY (materia) REFERENCES materia (codigo)
)

INSERT INTO Alumno  VALUES ('A1', 'juan'), ('A2', 'ana'), ('A3', 'diego');
INSERT INTO Materia VALUES ('M1', 'BDD'), ('M2', 'prog 2'), ('M3', 'ingles');
INSERT INTO Rinde VALUES ('A1', 'M1'), ('A1', 'M2'), ('A1', 'M3'), ('A2', 'M1'), ('A3', 'M1'),('A3', 'M3');
 
select * from rinde order by alumno
select * from alumno
select * from materia

-- liste el/los alumnos que rindieron todas las materias
-- AR 
-- RESULTADO <- PRO idAlumno(ALUMNO) - PROYECTAR idAlumno ((PROYECTAR idAlumno  (alumno) X PROYECTAR codMat (mat)) - rinde)

SELECT *
FROM Alumno A -- ponemos �a� como ALIAS de alumno
WHERE NOT EXISTS 
	(
	SELECT 'A' -- ingreso una costante para optimizar la query
	FROM Materia M -- ponemos "M" como alias de Materia
	WHERE NOT EXISTS
		(
		SELECT 1  -- ingreso una costante para optimizar la query
		FROM Rinde R -- ponemos "R" como alias de Rinde
		WHERE a.legajo = r.alumno AND m.codigo = r.materia -- usamos los alias para acceder a las columnas de las tablas
		)
	)

-- pasos
--paso 1 toma alumno A1, con materia M1
--paso 2 toma alumno A1, con materia M2
--paso 3 toma alumno A1, con materia M3
-- LISTA EL ALUMNO A1
--paso 4 toma alumno A2, con materia M1
--paso 5 toma alumno A2, con materia M2 
--paso 6 toma alumno A2, con materia M3
-- LISTA LAS MATERIAS M2 Y M3 QUE EL ALUMNO NO RINDI�, ENTONCES EL NOT EXISTS DA FALSO, ENTONCES NO LISTA AL ALUMNO A2
--paso 7 toma alumno A3, con materia M1
--paso 8 toma alumno A3, con materia M2 
--paso 9 toma alumno A3, con materia M3
-- LISTA LA MATERIA M2, QUE EL ALUMNO A3 NO RINDI�, ENTONCES EL NOT EXISTS DA FALSO, ENTONCES NO LISTA AL ALUMNO A3

-- OTRA FORMA DE RESOLVER LO MISMO:

-- que sabemos? o que podemos saber?

--1) la cantidad de materias

SELECT COUNT(CODIGO) [total de materias]
FROM Materia

--2) la cantidad de materias que rindi� cada alumno

SELECT alumno, count(distinct materia) [cant materias rendidas]
FROM RINDE
GROUP BY alumno
ORDER BY ALUMNO

--3) AHORA JUNTAMOS AMBAS QUERIES 

SELECT alumno, count(distinct materia) [cant materias rendidas]
FROM RINDE
GROUP BY alumno
HAVING count(distinct materia) = (SELECT COUNT(CODIGO) FROM Materia)
ORDER BY ALUMNO

-- �que esta comparando en la query anterior? columna 2 (cant de rendidas) con la 3 (total de materias).
SELECT alumno, count(distinct materia) [cant materias rendidas], (SELECT COUNT(CODIGO) FROM Materia) [cant total de materias]
FROM RINDE
GROUP BY alumno

-- MISMA QUERY PERO CON MAS INFO

SELECT a.*, count (r.materia) as cantidad, STRING_AGG(m.nombre, ', ')
FROM rinde r join alumno a on r.alumno = a.legajo 
JOIN Materia m ON r.materia = m.codigo 
GROUP BY a.legajo, a.nombre 
having count (r.materia) = (select count (*) from materia)

-- VISTAS
---- las vistas son una forma de guardar CODIGO de una consulta. No se almacena el resultado, SI la consulta y su TXT.

CREATE VIEW vista1 (alumno)
AS

	SELECT a.nombre
	FROM rinde r join alumno a on r.alumno = a.legajo
	GROUP BY a.legajo, a.nombre 
	having count (r.materia) = (select count (*) from materia)

---
SELECT * FROM vista1; -- << luego, se puede hacer uso de la vista en el from, como si fuera una tabla

-- el select anterior es equivalente a realizar la siguiente sub consulta:

SELECT *
FROM (
	SELECT a.nombre
	FROM rinde r join alumno a on r.alumno = a.legajo
	GROUP BY a.legajo, a.nombre 
	having count (r.materia) = (select count (*) from materia)
) AS vista1

-- SI ACTUALIZO LA INFO DE LAS TABLAS, SE VE REFLEJADO EN LAS VISTAS
update Alumno 
set 
nombre = 'Juana'
where nombre = 'Juan'

-- QUE PASA SI MODIFICO LA INFORMACI�N AGREGANDO MAS VALORES EN RINDE? 
INSERT INTO Rinde VALUES ('A2', 'M2') , ('A2', 'M3') 

SELECT * FROM vista1;

-- EQUIVALENTE A
SELECT * 
FROM 
(
	SELECT a.nombre
	FROM rinde r join alumno a on r.alumno = a.legajo
	GROUP BY a.legajo, a.nombre 
	having count (r.materia) = (select count (*) from materia)
) AS VISTA1

-- BORRADO
DROP VIEW vista1;
 
---- Funciones de usuario: Las funciones son un conjunto de c�digo que retornan valores. 
--   Pueden ser 1 escalar, o una tabla

-- devolviendo escalar.

CREATE FUNCTION dbo.miFuncion (@param INT)
RETURNS int
AS

	BEGIN

	RETURN @param * 2

	END;

	--NOTAS: SE CREA UNA FUNCION Que recibe un parametro entero, que adem�s, retorna otro entero.
	-- luego, con las palabras reservadas BEGIN/END generamos un grupo sin nombre de codigo


-- ejecuci�n de prueba de la funcion
SELECT dbo.miFuncion(2), dbo.miFuncion(3), dbo.miFuncion(20)

-- devolviendo tabla
CREATE FUNCTION dbo.miFuncionTabla (@param INT)
RETURNS TABLE
AS
	RETURN
		(
			SELECT power(CAMPO1, @param) as id, campo2
			FROM tablaUno
		);
--NOTA: Como se ve, hacemos un RETURN en linea, no hace falta usar un BEGIN/END

-- ejecuci�n de prueba de la funcion
SELECT * FROM dbo.miFuncionTabla(2);		
SELECT * FROM dbo.miFuncionTabla(3);
SELECT * FROM dbo.miFuncionTabla(4);

-- para borrar una funcion:
DROP FUNCTION dbo.miFuncionTabla;

----Procedimientos almacenados
-- UN Prodicimento es un conjunto de operaciones que se deben ejecutar de forma reiterativa. 


CREATE PROCEDURE borra(@legajo varchar(2))
AS

	DELETE FROM rinde WHERE alumno = @legajo;
	DELETE FROM alumno WHERE legajo = @legajo;


-- ejecutar procedimiento: 
DELETE FROM Alumno WHERE legajo = 'A1'

EXEC borra 'a3';

select * from Alumno;

 ----------- triggers: SON ESTRUCTURAS DE CODIGO QUE SE "DISPARAN" CUANDO OCURRE UN EVENTO. 
 -- POR EJEMPLO, INSERT, DELETE, UPDATE DE UNA TABLA

 
CREATE TABLE Cliente 
(
NroCli INT  not null,
NomCli  VARCHAR(20), 
CiudadCli VARCHAR(20)
CONSTRAINT PK_Cliente PRIMARY KEY (NroCli)
)


INSERT INTO [dbo].[Cliente] (NroCli, [NomCli], [CiudadCli]) VALUES (1,'Cli1','Laferrere')
INSERT INTO [dbo].[Cliente] (NroCli, [NomCli], [CiudadCli]) VALUES (2,'Cli2','Laferrere')
INSERT INTO [dbo].[Cliente] (NroCli, [NomCli], [CiudadCli]) VALUES (3,'Cli3','San Justo')
INSERT INTO [dbo].[Cliente] (NroCli, [NomCli], [CiudadCli]) VALUES (4,'Cli4','Ramos Mejia')
INSERT INTO [dbo].[Cliente] (NroCli, [NomCli], [CiudadCli]) VALUES (5,'Cli5','Gonzalez Catan')
INSERT INTO [dbo].[Cliente] (NroCli, [NomCli], [CiudadCli]) VALUES (6,'Cli6','San Justo')
INSERT INTO [dbo].[Cliente] (NroCli, [NomCli], [CiudadCli]) VALUES (7,'Cli7','Ramos Mejia')

CREATE TABLE Cliente_historico
(
NroCli INT  not null,
NomCli  VARCHAR(20), 
CiudadCli VARCHAR(20),
FechaCambio DATETIME NOT NULL,
Usuario VARCHAR(20),
accion VARCHAR(20),
CONSTRAINT PK_ClienteHistorico PRIMARY KEY (NroCli, FechaCambio)
)

SELECT * FROM Cliente_historico

-- CREAR UN TRIGGER SOBRE CLIENTES, PARA LAS ACCIONES DE BORRADO Y MODIFICACION. ESTE TRIGGER DEBE
--    GUARDAR EN LA TABLA DE HISTORIAL DE CLIENTES EL VALOR PREVIO AL CAMBIO 

-- se ejecutar� el trigger cuando SE HAGA UN DELETE O UN UPDATE en la tabla cliente
DELETE FROM Cliente WHERE NroCli  = 7
UPDATE Cliente set NomCli = '' WHERE NroCli = 6

-- CREACION DEL TRIGGER
CREATE TRIGGER tr_histClientes
ON CLIENTE
FOR UPDATE, DELETE
AS
	-- IMPORTANTE, LAS ESTRUCTURAS DEL DELETED E INSERTED 
	-- CUANDO SE INSERTA, TENGO LAS TUPLAS NUEVAS, EN INSERTED
	-- CUANDO SE BORRA, TENGO LAS TUPLAS BORRADAS EN DELETED
	-- CUANDO SE ACTUALIZA, TENGO LAS TUPLAS NUEVAS EN INSERTED Y LAS VIEJAS EN DELETED
	-- CUANDO SE ACTUALIZA TENGO LA INFO NUEVA EN INSERTED Y LA VIEJA EN DELETED
	-- EN OTROS MOTORES, SE LLAMAN NEW|OLD.

	IF EXISTS (SELECT * FROM INSERTED) -->> ES UN UPDATE 
		INSERT INTO Cliente_HISTORICO  (NROCLI, [NomCli], [CiudadCli], FechaCambio, accion)
		SELECT *, GETDATE(), 'UPDATE'
		FROM DELETED
	ELSE
		INSERT INTO Cliente_HISTORICO  (NROCLI, [NomCli], [CiudadCli], FechaCambio, accion)
		SELECT *, GETDATE(), 'DELETE'
		FROM DELETED
	
-- PRUEBA DEL TRIGGER

UPDATE Cliente
SET 
CIUDADcLI = 'san rafael'
WHERE NroCli = 6

SELECT * FROM Cliente WHERE NroCli = 6
SELECT * FROM Cliente_HISTORICO WHERE NroCli = 6

DELETE FROM cliente where nrocli = 5

SELECT * FROM Cliente WHERE NroCli = 5
SELECT * FROM Cliente_HISTORICO WHERE NroCli = 5

UPDATE Cliente
SET 
CIUDADcLI = 'TARTAGAL'
WHERE NroCli = 6

SELECT * FROM Cliente WHERE NroCli = 6
SELECT * FROM Cliente_HISTORICO WHERE NroCli = 6
