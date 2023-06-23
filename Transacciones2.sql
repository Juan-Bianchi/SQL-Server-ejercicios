CREATE DATABASE transacciones
GO 
USE transacciones;

CREATE TABLE Departamento
(
  cod_depto    integer PRIMARY KEY,
  descripcion  varchar(30),
)

CREATE TABLE Empleado
(
  legajo    integer PRIMARY KEY,
  nombre    varchar(30),
  salario   numeric(8,2),
  categoria char(1),
  cod_depto integer FOREIGN KEY REFERENCES Departamento (cod_depto),
)



INSERT INTO Departamento VALUES (1,'Ventas')
INSERT INTO Departamento VALUES (2,'Compras')
INSERT INTO Departamento VALUES (3,'Administracion')
INSERT INTO Departamento VALUES (4,'Marketing')
INSERT INTO Departamento VALUES (5,'Sistemas')

INSERT INTO Empleado VALUES (100,'Marcelo',120000,'B',1)
INSERT INTO Empleado VALUES (101,'Diego',60000,'A',2)
INSERT INTO Empleado VALUES (102,'Andrea',90000,'C',3)
INSERT INTO Empleado VALUES (103,'Janice',100000,'C',4)
INSERT INTO Empleado VALUES (104,'Duilio',110000,'A',null)
INSERT INTO Empleado VALUES (105,'Ezequiel',160000,'B',5)
INSERT INTO Empleado VALUES (106,'Mariano',180000,'B',5)
INSERT INTO Empleado VALUES (107,'Sebastian',150000,'C',5)

--SIN BLOQUEO
--T1
--1
BEGIN TRANSACTION;
	--3
	SELECT * FROM Empleado;
	--5
	UPDATE Empleado
	SET salario = salario * 0.2;							
--7	
COMMIT;

							
--T1 bloquea toda la tabla Empleado
--T1
--1
BEGIN TRANSACTION;
	--3
	SELECT * FROM Empleado;

	UPDATE Empleado
	SET salario = salario * 1.2;
--5
COMMIT; 
--Luego de que T1 hace COMMIT, muestra el 
--resultado de la consulta

	
--T1 bloquea una fila de la tabla Empleado 
--y T2 puede modificar otra fila
--Cuando se coloca una condicion por la Primary Key 
--de la tabla, entonces el bloqueo es por fila, y de 
--esa forma permite que dos transacciones puedan 
--hacer cambios en la misma tabla en forma simultanea, 
--en distintas filas.
--Pero es impresindible que se coloque en el WHERE 
--una condicion sobre la clave de la tabla.

--T1
--1
BEGIN TRANSACTION;
	--3
	SELECT * FROM Empleado;

	UPDATE Empleado
	SET salario = salario * 2
	WHERE legajo = 100;
--5
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


--1
BEGIN TRANSACTION;
	--3
	SELECT * FROM Empleado;

	UPDATE Empleado
	SET salario = salario * 2
	WHERE categoria = 'A';
--5
COMMIT
--Luego de que T1 hace COMMIT, muestra el 
--resultado de la consulta

							
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

--1
BEGIN TRANSACTION;
	--3
	SELECT * FROM Empleado;
	--5						
	UPDATE Empleado
	SET salario = salario * 0.5;
	--7							
	SELECT * FROM Departamento;
	--Se queda esperando a que T2 finalice…
COMMIT;				




