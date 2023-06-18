create database bancos;
go
use bancos;
go
create table Pais(
pais char(50) primary key);

create table Banco(
id int primary key, 
nombre varchar(50), 
pais char(50));

create table Moneda(
id char(2) primary key, 
descripcion varchar(50), 
valorOro decimal(18,3), 
valorPetroleo decimal(18,3));

create table Persona(
pasaporte char(15) primary key, 
codigoFiscal int, 
nombre varchar(50));

create table Cuenta(
monto decimal(18,3), 
idBanco int not null, 
idMoneda char(2) not null, 
idPersona char(15) not null, 
constraint PK_Persona primary key(idBanco, idMoneda, idPersona));

create table Opera(
idBanco int not null, 
idMoneda char(2) not null, 
cambioCompra decimal(18,3), 
cambioVenta decimal(18,3), 
constraint PK_Opera primary key(idBanco, idMoneda));

go
INSERT INTO pais (pais) VALUES ('Argentina');
INSERT INTO pais (pais) VALUES ('USA');
INSERT INTO pais (pais) VALUES ('Uruguay');
INSERT INTO pais (pais) VALUES ('España');
INSERT INTO pais (pais) VALUES ('Alemania');
INSERT INTO pais (pais) VALUES ('Suiza');
INSERT INTO banco (id, nombre, pais) VALUES ('1', 'Banco Nacion', 'Argentina');
INSERT INTO banco (id, nombre, pais) VALUES ('2', 'Banco Montevideo', 'Uruguay');
INSERT INTO banco (id, nombre, pais) VALUES ('3', 'Banco Ciudad', 'Argentina');
INSERT INTO banco (id, nombre, pais) VALUES ('4', 'City Bank', 'USA');
INSERT INTO banco (id, nombre, pais) VALUES ('5', 'Switzerland Bank', 'Suiza');
INSERT INTO banco (id, nombre, pais) VALUES ('6', 'BBVA', 'España');
INSERT INTO moneda (id, descripcion, valorOro, valorPetroleo) VALUES ('AR', 'Peso Argentino','2', '1');
INSERT INTO moneda (id, descripcion, valorOro, valorPetroleo) VALUES ('UY', 'Peso Uruguayo','5', '2.5');
INSERT INTO moneda (id, descripcion, valorOro, valorPetroleo) VALUES ('US', 'Dolar', '1','1.5');
INSERT INTO moneda (id, descripcion, valorOro, valorPetroleo) VALUES ('EU', 'Euro', '2', '1');
INSERT INTO persona (pasaporte, codigoFiscal, nombre) VALUES ('1', '1234', 'Bill Gates');
INSERT INTO persona (pasaporte, codigoFiscal, nombre) VALUES ('2', '12112', 'Carlos Slim');
INSERT INTO persona (pasaporte, codigoFiscal, nombre) VALUES ('3', '2325', 'Lionel Messi');
INSERT INTO persona (pasaporte, codigoFiscal, nombre) VALUES ('4', '01243', 'Diego Maradona');
INSERT INTO cuenta (monto, idBanco, idMoneda, idPersona) VALUES ('100000', '4', 'US', '1');
INSERT INTO cuenta (monto, idBanco, idMoneda, idPersona) VALUES ('20000', '5', 'EU', '1');
INSERT INTO cuenta (monto, idBanco, idMoneda, idPersona) VALUES ('15000', '2', 'US', '1');
INSERT INTO cuenta (monto, idBanco, idMoneda, idPersona) VALUES ('50000', '4', 'US', '2');
INSERT INTO cuenta (monto, idBanco, idMoneda, idPersona) VALUES ('35000', '5', 'US', '2');
INSERT INTO cuenta (monto, idBanco, idMoneda, idPersona) VALUES ('2000', '1', 'AR', '3');
INSERT INTO cuenta (monto, idBanco, idMoneda, idPersona) VALUES ('10000', '4', 'US', '3');
INSERT INTO cuenta (monto, idBanco, idMoneda, idPersona) VALUES ('15000', '5', 'US', '3');
INSERT INTO cuenta (monto, idBanco, idMoneda, idPersona) VALUES ('15000', '5', 'US', '4');
INSERT INTO cuenta (monto, idBanco, idMoneda, idPersona) VALUES ('2000', '2', 'AR', '3');
INSERT INTO cuenta (monto, idBanco, idMoneda, idPersona) VALUES ('10000', '3', 'US', '3');
INSERT INTO cuenta (monto, idBanco, idMoneda, idPersona) VALUES ('15000', '6', 'US', '3');
INSERT INTO opera (idBanco, idMoneda, cambioCompra, cambioVenta) VALUES ('1', 'US', '1', '1');
INSERT INTO opera (idBanco, idMoneda, cambioCompra, cambioVenta) VALUES ('2', 'US', '1', '1');
INSERT INTO opera (idBanco, idMoneda, cambioCompra, cambioVenta) VALUES ('3', 'US', '1', '1');
INSERT INTO opera (idBanco, idMoneda, cambioCompra, cambioVenta) VALUES ('4', 'US', '1', '1');
INSERT INTO opera (idBanco, idMoneda, cambioCompra, cambioVenta) VALUES ('5', 'US', '1', '1');
INSERT INTO opera (idBanco, idMoneda, cambioCompra, cambioVenta) VALUES ('6', 'US', '1', '1');
INSERT INTO opera (idBanco, idMoneda, cambioCompra, cambioVenta) VALUES ('1', 'EU', '2', '2');
INSERT INTO opera (idBanco, idMoneda, cambioCompra, cambioVenta) VALUES ('2', 'EU', '2', '2');
INSERT INTO opera (idBanco, idMoneda, cambioCompra, cambioVenta) VALUES ('3', 'EU', '3', '3');
INSERT INTO opera (idBanco, idMoneda, cambioCompra, cambioVenta) VALUES ('4', 'EU', '2', '2');
INSERT INTO opera (idBanco, idMoneda, cambioCompra, cambioVenta) VALUES ('5', 'EU', '2.2','2.2');
INSERT INTO opera (idBanco, idMoneda, cambioCompra, cambioVenta) VALUES ('6', 'EU', '2.2','2.5');
INSERT INTO opera (idBanco, idMoneda, cambioCompra, cambioVenta) VALUES ('1', 'AR', '5', '5');
INSERT INTO opera (idBanco, idMoneda, cambioCompra, cambioVenta) VALUES ('3', 'AR', '5.5', '5.5');
INSERT INTO opera (idBanco, idMoneda, cambioCompra, cambioVenta) VALUES ('2', 'AR', '7', '7');
INSERT INTO opera (idBanco, idMoneda, cambioCompra, cambioVenta) VALUES ('1', 'UY', '3', '3');
INSERT INTO opera (idBanco, idMoneda, cambioCompra, cambioVenta) VALUES ('2', 'UY', '2', '2');


--1- Redactar las sentencias que permitan agregar las restricciones de integridad referencial permitiendo 
--   la actualizacion automatica para el caso de actualizar o eliminar un banco, moneda o persona.
--   Demostrar el correcto funcionamiento de las restricciones creadas
--   Redactar las sentencias que permitan eliminar las restricciones creadas en el paso anterior.

ALTER TABLE Cuenta
ADD CONSTRAINT FKIdBanco FOREIGN KEY(idBanco)
REFERENCES Banco(id)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Cuenta
ADD CONSTRAINT
FKidMoneda FOREIGN KEY(idMoneda)
REFERENCES Moneda(id)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Cuenta
ADD CONSTRAINT 
FKIdPersona FOREIGN KEY(idPersona)
REFERENCES Persona(pasaporte);

ALTER TABLE Opera
ADD CONSTRAINT 
FKIdBanco1 FOREIGN KEY(idBanco)
REFERENCES Banco(id)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Opera
ADD CONSTRAINT 
FKIdMoneda1 FOREIGN KEY(idMoneda)
REFERENCES Moneda(id)
ON DELETE CASCADE ON UPDATE CASCADE;


--2-Listar los bancos que solamente operan todas las monedas que no son el PESO URUGUAYO.
--  Utilizar una vista para todas las monedas.

CREATE VIEW bancos_que_operan_todas_monedas_salvo_uruguayo AS
SELECT * FROM Banco b
WHERE NOT EXISTS( SELECT * FROM Moneda m 
				  WHERE m.descripcion <> 'Peso Uruguayo'
				  AND NOT EXISTS ( SELECT * FROM Opera o
								   WHERE o.idBanco = b.id
								   AND o.idMoneda = m.id));


--4-Crear una funcion que devuelva el valor oro de una moneda. La misma debe recibir como parametro el 
--  codigo de la moneda y devolver el valor -1 para el caso en que la moneda no exista.
--  Escribir la sentencia que prueba el correcto funcionamiento.

CREATE FUNCTION f_valor_oro(@codMon CHAR(2)) 
RETURNS DECIMAL(18,3) AS
BEGIN
	DECLARE @retorno DECIMAL(18,3)

	SET @retorno = (SELECT isnull((SELECT valorOro 
									FROM Moneda m
									WHERE m.id = @codMon),-1));
	RETURN @retorno;
END;

SELECT dbo.f_valor_oro('MM') AS valorOro;
SELECT dbo.f_valor_oro('UY') AS valorOro;


--5- Crear una funcion que retorne el pasaporte y el nombre de las personas que tienen cuenta en todos los bancos.
--   Escribir la sentencia que prueba el correcto funcionamiento.

CREATE FUNCTION clientes_de_todos_los_bancos()
RETURNS TABLE
AS
RETURN 
(
SELECT p.nombre, p.pasaporte FROM Persona p
WHERE NOT EXISTS ( SELECT 1 FROM Banco b
				   WHERE NOT EXISTS (SELECT 1 FROM Cuenta c
									 WHERE b.id = c.idBanco
									 AND p.pasaporte = c.idPersona))
);

SELECT * FROM clientes_de_todos_los_bancos();


--6- Crear un SP que muestre por pantalla a las personas que tienen mas de 3 cuentas en dolares en bancos extranjeros. 
--   Escribir la sentencia que prueba el correcto funcionamiento.

CREATE PROCEDURE personas_mas_tres_cuentas_dolares_bancos_extranjeros AS 
BEGIN
	SELECT p.pasaporte, COUNT(c.idBanco) cant_bancos 
	FROM Persona p, Cuenta c, Banco b
	WHERE c.idPersona = p.pasaporte
	AND b.id = c.idBanco
	AND b.pais <> 'Argentina'
	GROUP BY p.pasaporte
	HAVING COUNT(c.idBanco) = (SELECT COUNT(*) FROM Banco b
							   WHERE b.pais <> 'Argentina');
END;


SELECT * FROM Banco;


--7- Crear un SP que reciba por parametro un pasaporte y muestre las cuentas asociadas a la misma. 
--   Si el pasaporte no existe, mostrar un mensaje de error.
--   Escribir la sentencia que prueba el correcto funcionamiento.
--   EXECUTE personas_mas_tres_cuentas_dolares_bancos_extranjeros;

CREATE PROCEDURE mostrar_cuentas_asociadas(@pasaporte CHAR(15)) AS
BEGIN
	DECLARE @persona INT = (SELECT COUNT(*) FROM Persona p
						    WHERE p.pasaporte = @pasaporte);
	IF( @persona = 0 )
		SELECT 'El pasaporte proporcionado está incorrecto';
	ELSE 
		SELECT * FROM Cuenta c
		WHERE c.idPersona = @pasaporte;
END;

EXECUTE mostrar_cuentas_asociadas 16;
EXECUTE mostrar_cuentas_asociadas 3;



--8- Crear un Trigger que realice el respaldo de los datos de un Banco cuando el mismo es eliminado. El trigger no debe 
--   permitir que se eliminen bancos que operan con la moneda "PESO ARGENTINO"
--   Se debe crear una tabla "banco_respaldo"
--   Escribir las sentencias que prueban el correcto funcionamiento.

create table BancoRespaldo(
id int primary key, 
nombre varchar(50), 
pais char(50));

CREATE TRIGGER respaldar_banco ON Banco INSTEAD OF DELETE AS
BEGIN
	IF((SELECT COUNT(*) FROM deleted d, Opera o, Moneda m
	    WHERE d.id = o.idBanco
	    AND o.idMoneda = m.id
	    AND m.descripcion LIKE 'PESO ARGENTINO') = 0)
		BEGIN 
			INSERT BancoRespaldo
			SELECT * FROM deleted

			DELETE Banco 
			WHERE  banco.id IN (SELECT id FROM deleted)
		END
	ELSE
		(SELECT 'No se pueden eliminar bancos que operan Pesos Argentinos');
END;


--9- Crear un Trigger que actualice el id de moneda en las tablas opera y cuenta para cuando un codigo de moneda 
--   sea actualizado en la tabla moneda.
--   Escribir la sentencia que prueba el correcto funcionamiento.

CREATE TRIGGER t_actualiza_moneda ON Moneda AFTER UPDATE AS
BEGIN
	
	IF UPDATE(id)
		BEGIN 
			UPDATE Opera 
			SET idMoneda = (SELECT i.id FROM inserted i)
			WHERE idMoneda IN (SELECT id FROM deleted);

			UPDATE Cuenta 
			SET idMoneda = (SELECT id FROM inserted)
			WHERE idMoneda IN (SELECT id FROM deleted);
		END;
END;