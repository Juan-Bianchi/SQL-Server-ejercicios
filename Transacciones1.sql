USE transacciones;

DROP table uno

CREATE TABLE uno(
num INT PRIMARY KEY,
descr varchar(20));

INSERT INTO uno
VALUES(1, 'hola')

UPDATE uno
SET num = 2 WHERE descr LIKE 'hola'

select * from uno

--T2
--SIN BLOQUEO
--2
BEGIN TRANSACTION
	--4
	SELECT * FROM Departamento;
	--6
	UPDATE Departamento
	SET descripcion = 'Finanzas'
	WHERE descripcion = 'Administración';
--8
COMMIT;


--T1 bloquea toda la tabla Empleado
--T2
--2
BEGIN TRANSACTION;
--4
SELECT * FROM Empleado;  --Se queda esperando a que T1 finalice…
--6
COMMIT;


--T1 bloquea una fila de la tabla Empleado 
--y T2 puede modificar otra fila
--Cuando se coloca una condicion por la Primary Key 
--de la tabla, entonces el bloqueo es por fila, y de 
--esa forma permite que dos transacciones puedan 
--hacer cambios en la misma tabla en forma simultanea, 
--en distintas filas.
--Pero es impresindible que se coloque en el WHERE 
--una condicion sobre la clave de la tabla.

--T2
--2
BEGIN TRANSACTION;
	--4
	UPDATE Empleado
	SET salario = salario * 3
	WHERE legajo = 105;
COMMIT



--T1 bloquea un subconjunto de filas y T2 no puede 
--modificar otras filas

--En este caso, T1 modifica el salario de los Empleados 
--de categoria A y luego T2 quiere modificar el 
--salario de los empleados de categoria B, pero no 
--puede hacerlo porque la tabla está bloqueada.
--Solo permite que dos transacciones hagan cambios 
--en distintas filas de la misma tabla cuando se 
--indica una condicion sobre la Clave Primaria de la 
--tabla.


--2
BEGIN TRANSACTION;
	--4
	UPDATE Empleado
	SET salario = salario * 3
	WHERE  categoria = 'B';
	--Se queda esperando a que T1 finalice…
--6
COMMIT


/*Caso 5: Deadlock
T1 modifica la tabla Empleado y T2 modifica la 
tabla Departamento. Luego, T1 quiere leer la tabla 
Departamento pero no puede porque está bloqueada 
por T2 entonces se queda esperando y T2 quiere 
leer la tabla Empleado y tambien se queda 
esperando porque está bloqueada. Ambas 
transacciones se quedan esperando mutuamente, 
en forma infinita. Esto se llama Deadlock o Abrazo 
mortal. Cuando esto sucede, el motor de Base de 
Datos elije a una de las dos transacciones en 
forma aleatoria y la “mata” para que libere los 
recursos y la otra pueda continuar.*/

--2
BEGIN TRANSACTION;
	--4
	SELECT * FROM Departamento;
	--6
	INSERT INTO Departamento
	VALUES (7, 'Contabilidad');
	--8
	SELECT * FROM Empleado;
   --Se queda esperando a que T1 finalice…
COMMIT;