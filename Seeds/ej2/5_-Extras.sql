
-- 1. CREAR UNA TABLA DE HISTORICO PARA ARTICULOS CON LOS MISMOS CAMPOS QUE LA TABLA ORIGINAL Y ADEMÁS LA FECHA DE CAMBIO Y EL USUARIO
use EJERCICIO_2
go
 
CREATE TABLE Articulo_HISTORICO
(
NroArt INT not null ,
Descripcion VARCHAR(20),
CiudadArt  VARCHAR(20),
Precio DECIMAL(10,4),
FechaCambio DATETIME NOT NULL,
Usuario VARCHAR(20),
PRIMARY KEY  (NroArt, FechaCambio)
)
-- 2. CREAR UN STORE PROCEDURE PARA REALIZAR LA CREACION DE UN NUEVO ARTICULO QUE RECIBA POR PARAMETRO:
/*
Descripcion VARCHAR(20),
CiudadArt  VARCHAR(20),
Precio DECIMAL(10,4),
*/

-- DROP PROC s_createArticulo 
CREATE PROC s_createArticulo 
(
@Descripcion VARCHAR(20),
@CiudadArt  VARCHAR(20),
@Precio DECIMAL(10,4)
)
AS

	
	-- valido si existe la descripcion, si no existe, creo el articulo
	IF NOT EXISTS (SELECT 1 FROM Articulo WHERE Descripcion like @Descripcion)
	BEGIN
		INSERT INTO [dbo].[Articulo] ([Descripcion], [CiudadArt], [Precio])
		VALUES (lower (@Descripcion),  upper (@CiudadArt), @Precio) 
	END
	ELSE 
	BEGIN
		-- si existe, devuelvo un error
		raiserror( 'descripcion ya existente', 16, 10)
	END 
-- MODIFICO CON ALTER PROC ....
-- BORRO CON DROP PROC ...
-- EJECUTO CON EXEC nombreProc

exec s_createArticulo 'desc 1', 'ciudad 1', 10

select * from Articulo

-- 3. CREAR UN SP QUE MODIFIQUE EL PRECIO DE LOS ARTICULOS. ESTE SP DEBE ALMACENAR EN LA TABLA DE HISTORICOS EL VALOR ANTERIOR DEL ARTICULO
/*
PARAMS
NroArt INT,
Precio DECIMAL(10,4),
*/

--DROP PROC s_actualizaPrecioArticulo
CREATE PROC s_actualizaPrecioArticulo
(
	@NroArt INT,
	@PrecioNuevo DECIMAL(10,4),
	@Usuario varchar(20)
)
AS
	-- guardo en el historico, el valor actual
	INSERT INTO Articulo_HISTORICO  (NroArt, [Descripcion], [CiudadArt], [Precio], FechaCambio, Usuario)
	SELECT NroArt, [Descripcion], [CiudadArt], [Precio], getdate(), @Usuario
	FROM Articulo
	WHERE NroArt = @NroArt

	UPDATE Articulo
	SET
		Precio = @PrecioNuevo
	WHERE NroArt = @NroArt

-- ejecuto
EXEC s_actualizaPrecioArticulo 1000, 90.50, 'Alfonso'

-- listo y pruebo
SELECT * FROM Articulo  where NroArt = 1
SELECT * FROM Articulo_HISTORICO  where NroArt = 1


-- 4. CREAR UN SP QUE BORRE UN ARTICULO. TENER CUIDADO! LA TABLA DE ARTICULOS ESTÁ RELACIONADA CON LA TABLA Pedido!
--    SI EL ARTICULO FUE USADO EN ALGUN pedido NO BORRARLO. RETORNAR UN CUSTOM ERROR (ver notas)
/*
PARAMS
NroArt INT
*/

CREATE PROC s_deleteArticulo
(
	@NroArt INT,
	@Usuario VARCHAR(20)
)
AS

	IF EXISTS (SELECT 1 FROM Pedido WHERE NroArt = @NroArt)
	BEGIN 
		RAISERROR('PRODUCTO USADO EN PEDIDOS', 16, 1)
	END

		INSERT INTO Articulo_HISTORICO  (NroArt, [Descripcion], [CiudadArt], [Precio], FechaCambio, Usuario)
		SELECT NroArt, [Descripcion], [CiudadArt], [Precio], getdate(), @Usuario
		FROM Articulo
		WHERE NroArt = @NroArt

		DELETE FROM Articulo WHERE NroArt = @NroArt
	
	EXEC s_deleteArticulo 8, 'juan'
	select * from Articulo where NroArt = 8
	select * from Articulo_HISTORICO where NroArt = 8


-- 5. CREAR UNA TABLA PARA HISTORIAL DE CAMBIOS DE CLIENTES. 

CREATE TABLE Cliente_historico
(
NroCli INT  not null,
NomCli  VARCHAR(20), 
CiudadCli VARCHAR(20),
FechaCambio DATETIME NOT NULL,
Usuario VARCHAR(20),
CONSTRAINT PK_ClienteHistorico PRIMARY KEY (NroCli, FechaCambio)
)

SELECT * FROM Cliente_historico

-- 6. CREAR UN TRIGGER SOBRE CLIENTES, PARA LAS ACCIONES DE BORRADO Y MODIFICACION. ESTE TRIGGER DEBE
--    GUARDAR EN LA TABLA DE HISTORIAL DE CLIENTES EL VALOR PREVIO AL CAMBIO 

-- se ejecutará el trigger cuando SE HAGA UN DELETE O UN UPDATE en la tabla cliente
DELETE FROM Cliente WHERE NroCli  = 100
UPDATE Cliente set NomCli = '' WHERE NroCli = 100

-- CREACION DEL TRIGGER
CREATE TRIGGER tr_histClientes
ON CLIENTE
FOR UPDATE, DELETE
AS
	-- IMPORTANTE, LAS ESTRUCTURAS DEL DELETED E INSERTED 
	-- CUANDO SE INSERTA, TENGO LAS TUPLAS NUEVAS, EN INSERTED
	-- CUANDO SE BORRA, TENGO LAS TUPLAS BORRADAS EN DELETED
	-- CUANDO SE ACTUALIZA TENGO LA INFO NUEVA EN INSERTED Y LA VIEJA EN DELETED
	-- EN OTROS MOTORES, SE LLAMAN NEW|OLD.

	INSERT INTO Cliente_HISTORICO  (NROCLI, [NomCli], [CiudadCli], FechaCambio)
	SELECT *, GETDATE()
	FROM DELETED

-- PRUEBA DEL TRIGGER

UPDATE Cliente
SET 
NomCli = 'CLIENTE NUEVO'
WHERE NroCli = 10000

SELECT * FROM Cliente WHERE NroCli = 1
SELECT * FROM Cliente_HISTORICO WHERE NroCli = 1

DELETE FROM cliente
where NroCli IN (SELECT NroCli FROM Pedido.....)


UPDATE c
FROM cliente c join pedido p on c.NroCli = p.NroCli
SET
 c.nomcli = 'asdasda'

where ...

-- nota. revisar la funcion de raiserror 
-- link: https://docs.microsoft.com/en-us/sql/t-sql/language-elements/raiserror-transact-sql?view=sql-server-ver15

-- TRIGGERS STATMENT: https://docs.microsoft.com/en-us/sql/t-sql/statements/create-trigger-transact-sql?view=sql-server-ver15

-- TRIGGER ESTRUCTURA BÁSICA:
CREATE TRIGGER nombre_trigger ON nombre_tabla
{ FOR | AFTER | INSTEAD OF }   -- DEFINEN CUANDO SE EJECUTARÁ EL TRIGGER (ANTES, DESPUES O EN LUGAR DE)
{ [ INSERT ] [ , ] [ UPDATE ] [ , ] [ DELETE ] }   -- DEFINE CUAL OPERACION SERÁ ASOCIADA AL TRIGGER
AS 
--..................... CODIGO SQL A EJECUTAR

-- EJEMPLO 
CREATE TRIGGER ejemplo1  -- creo el trigger
ON Proveedor             -- indico la tabla a la que esta asociado
AFTER INSERT, UPDATE     -- indico a que operaciones me refiero 
AS RAISERROR ('ejemplo de raiseeror y trigger', 16, 10);  -- retorno un error
GO  

-- ¿ que hace el trigger anterior ? que no me permite hacer?