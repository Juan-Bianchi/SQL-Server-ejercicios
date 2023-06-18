CREATE DATABASE ejercicio12
GO
USE ejercicio12;

CREATE TABLE Proveedor(
CodProv INT,
RazonSocial VARCHAR(100),
FechaInicio DATE,
CONSTRAINT CodProv PRIMARY KEY(CodProv));

set dateformat dmy
INSERT INTO Proveedor VALUES(1, 'Agos', '30-07-1999')
INSERT INTO Proveedor VALUES(2, 'Fede', '24-04-2002')
INSERT INTO Proveedor VALUES(3, 'Sele', '05-08-1999')
INSERT INTO Proveedor VALUES(4, 'Valen', '01-01-2023')


CREATE TABLE Producto(
CodProd INT, 
Descripcion VARCHAR(100),
CodProv INT, 
StockActual INT,
CONSTRAINT CodProd PRIMARY KEY(CodProd),
CONSTRAINT CodProvFK FOREIGN KEY(CodProv)
REFERENCES Proveedor(CodProv));

INSERT INTO Producto VALUES(1, 'Leche', 1, 100)
INSERT INTO Producto VALUES(2, 'Manteca', 1, 100)
INSERT INTO Producto VALUES(3, 'Manzana', 2, 10)
INSERT INTO Producto VALUES(4, 'Banana', 2, 10)
INSERT INTO Producto VALUES(5, 'Chocolate', 4, 0)
INSERT INTO Producto VALUES(6, 'kaka', 4, 0)



CREATE TABLE Stock(
Nro INT,
Fecha DATE,
CodProd INT,
Cantidad INT,
CONSTRAINT StockPK PRIMARY KEY(Nro, Fecha, CodProd),
CONSTRAINT CodProdFK FOREIGN KEY(CodProd)
REFERENCES Producto(CodProd));

INSERT INTO Stock VALUES(1, '1-1-2023', 1, 100)
INSERT INTO Stock VALUES(1, '1-1-2023', 2, 101)
INSERT INTO Stock VALUES(1, '1-1-2023', 3, 10)
INSERT INTO Stock VALUES(2, '2-1-2023', 3, 90)
INSERT INTO Stock VALUES(1, '1-1-2023', 4, 10)
INSERT INTO Stock VALUES(1, '8-1-2020', 5, 0)
INSERT INTO Stock VALUES(2, '8-1-2020', 6, 0)

--1. p_EliminaSinstock(): Realizar un procedimiento que 
--   elimine los productos que no poseen stock.
CREATE PROCEDURE p_EliminaSinstock AS
BEGIN
	DELETE Producto
	WHERE CodProd = (SELECT CodProd FROM Producto 
					 WHERE NOT EXISTS(SELECT CodProd FROM Stock));
END;


--2. p_ActualizaStock(): Para los casos que se presenten 
--   inconvenientes en los datos, se necesita realizar un 
--   procedimiento que permita actualizar todos los Stock_Actual 
--   de los productos, tomando los datos de la entidad Stock. 
--   Para ello, se utilizará como stock válido la última fecha en 
--   la cual se haya cargado el stock.


CREATE PROCEDURE p_ActualizaStock AS
BEGIN
	UPDATE Producto 
	SET StockActual = ( SELECT s.Cantidad 
					    FROM Stock s, ( SELECT s.CodProd, MAX(s.Fecha) ult_fecha
						  			    FROM Stock s
										GROUP BY CodProd) filtro
					    WHERE s.CodProd = filtro.CodProd
						AND s.Fecha = filtro.ult_fecha
						AND Producto.CodProd = s.CodProd)
	WHERE CodProd IN (SELECT CodProd FROM Stock);
END;

CREATE PROCEDURE p_ActualizaStock1 AS
BEGIN
	UPDATE Producto 
	SET StockActual = ( SELECT TOP 1 s.Cantidad 
					    FROM Stock s
						WHERE Producto.CodProd = s.CodProd
						ORDER BY s.Cantidad DESC)
	WHERE CodProd IN (SELECT CodProd FROM Stock);
END;

EXECUTE p_ActualizaStock

SELECT * FROM Producto


--3. p_DepuraProveedor(): Realizar un procedimiento que permita 
--   depurar todos los proveedores de los cuales no se posea stock 
--   de ningún producto provisto desde hace más de 1 año.

CREATE PROCEDURE p_DepuraProveedor AS
BEGIN
	DELETE FROM Proveedor
	WHERE CodProv IN( SELECT CodProv FROM Proveedor prov
					  WHERE NOT EXISTS (SELECT s.CodProd FROM Stock s
										GROUP BY s.CodProd 
										HAVING MAX(s.Fecha) < DATEADD(YEAR, -1, GETDATE())
										AND NOT EXISTS ( SELECT * FROM Producto prod
														 WHERE prod.StockActual = 0
														 AND prod.CodProd = s.CodProd
														 AND prod.CodProv = prov.CodProv)))
					  
END


--4. p_InsertStock(nro,fecha,prod,cantidad): Realizar un 
--   procedimiento que permita agregar stocks de productos. Al 
--   realizar la inserción se deberá validar que:
--   a. El producto debe ser un producto existente
--   b. La cantidad de stock del producto debe ser cualquier número entero
--   mayor a cero.
--   c. El número de stock será un valor correlativo que se irá agregando por
--   cada nuevo stock de producto.

CREATE PROCEDURE p_InsertStock(@nro INT, @fecha DATE , @prod INT, @cantidad INT) AS
BEGIN
	IF @nro > (SELECT DISTINCT MAX(Nro) FROM Stock)
	AND @prod IN (SELECT CodProd FROM Producto)
	AND @cantidad >= 0 
		UPDATE Producto
		SET StockActual = @cantidad
		WHERE CodProd = @prod
END;

EXECUTE p_InsertStock 4,'2023-06-16', 2, 25;

SELECT * FROM Producto;


--5. tg_CrearStock: Realizar un trigger que permita automáticamente agregar un
--   registro en la entidad Stock, cada vez que se inserte un nuevo producto. El stock
--   inicial a tomar, será el valor del campo Stock_Actual.

CREATE TRIGGER tg_CrearStock ON Producto
AFTER INSERT AS
DECLARE @nro INT 
DECLARE @fecha DATE
DECLARE @codProd INT
DECLARE @cantidad INT

BEGIN
	/*INSERT INTO Stock (CodProd, Cantidad)
	SELECT i.CodProd, i.StockActual FROM inserted i
	UPDATE Stock
	SET Nro = (SELECT DISTINCT MAX(Nro) FROM Stock) + 1,
	    Fecha = GETDATE()
	WHERE Nro IS NULL;*/
	SET @nro = (SELECT DISTINCT MAX(Nro) FROM Stock) + 1;
	SET @fecha = GETDATE();
	SET @codProd = (SELECT CodProd FROM inserted);
	SET @cantidad = (SELECT StockActual FROM inserted);

	INSERT INTO Stock
	VALUES (@nro, @fecha, @codProd, @cantidad);
END;

INSERT INTO Producto VALUES(7, 'Queso', 4, 100);
INSERT INTO Producto VALUES(8, 'Crema', 4, 100);

SELECT * FROM Producto;


--6. p_ListaSinStock(): Crear un procedimiento que permita listar los productos que
--   no posean stock en este momento y que no haya ingresado ninguno en este
--   último mes. De estos productos, listar el código y nombre del producto, razón
--   social del proveedor y stock que se tenía al mes anterior.

CREATE PROCEDURE p_ListaSinStock AS
BEGIN
	SELECT p.CodProd, p.Descripcion, pro.RazonSocial,  mes_pasado.Cantidad cant_mes_pasado
	FROM Stock s, Producto p, Proveedor pro, (SELECT * FROM Stock s
											  WHERE s.Fecha < DATEADD(MONTH, -1, GETDATE())) mes_pasado
	WHERE p.StockActual = 0
	AND p.CodProd = s.CodProd
	AND pro.CodProv = p.CodProv
	AND mes_pasado.CodProd = s.CodProd
	AND s.Fecha < DATEADD(MONTH, -1, GETDATE())
END;

EXECUTE p_ListaSinStock;


--7. p_ListaStock(): Realizar un procedimiento que permita generar el siguiente
--   reporte:
--      Fecha	    > 1000   < 1000   = 0
--   01/08/2009        100      8       3
--   03/08/2009         53     50       7
--   04/08/2009         50     20      40
--       ...            ...    ...     ..
--   En este listado se observa que se contará la cantidad de productos que posean 
--   a una determinada fecha más de 1000 unidades, menos de 1000 unidades o que no
--   existan unidades de ese producto.
--   Según el ejemplo, el 01/08/2009 existen 100 productos que poseen más de 1000
--   unidades, en cambio el 03/08/2009 sólo hubo 53 productos con más de 1000
--   unidades.

CREATE PROCEDURE p_ListaStock AS
BEGIN
	SELECT s.Fecha, isnull(mas_de_mil.mas,0) mas, isnull(menos_de_mil.menos,0) menos, isnull(cero.cero,0) cero
	FROM Stock s FULL JOIN
	(SELECT s1.Fecha, COUNT(s1.cantidad)mas FROM Stock s1 WHERE s1.cantidad > 1000 GROUP BY s1.Fecha) mas_de_mil
	ON s.Fecha = mas_de_mil.Fecha
	FULL JOIN
	(SELECT s2.Fecha, COUNT(s2.cantidad)menos FROM Stock s2 WHERE s2.cantidad <= 1000 AND  s2.cantidad >0  GROUP BY s2.Fecha) menos_de_mil
	ON menos_de_mil.Fecha = s.Fecha
	FULL JOIN
	(SELECT s2.Fecha, COUNT(s2.cantidad)cero FROM Stock s2 WHERE s2.cantidad = 0 GROUP BY s2.Fecha) cero
	ON cero.Fecha = S.Fecha
	ORDER BY s.Fecha ASC;
END

EXECUTE p_ListaStock;


--8. El siguiente requerimiento consiste en actualizar el campo stock actual de la
--   entidad producto, cada vez que se altere una cantidad (positiva o negativa) de ese
--   producto. El stock actual reflejará el stock que exista del producto, sabiendo que
--   en la entidad Stock se almacenará la cantidad que ingrese o egrese. Además, se
--   debe impedir que el campo “Stock actual” pueda ser actualizado manualmente. Si
--   esto sucede, se deberá dar marcha atrás a la operación indicando que no está
--   permitido

CREATE TRIGGER t_modificarStock ON Stock AFTER UPDATE AS
BEGIN
	UPDATE Producto
	SET StockActual = (SELECT Cantidad FROM inserted)
END;


CREATE TRIGGER t_restringir_cambio_stock_Producto ON Producto INSTEAD OF UPDATE AS
BEGIN
	IF (SELECT StockActual FROM inserted ) <> (SELECT StockActual FROM deleted)
		SELECT 'No se pueden realizar cambios manuales del Stock del Producto. Realize un INSERT en la tabla Stock'
	ELSE
		UPDATE Producto
		SET Descripcion = (SELECT Descripcion FROM inserted),
			CodProv = (SELECT CodProv FROM inserted);
END;

SELECT * FROM Producto;

UPDATE Stock
SET Cantidad = 50
WHERE CodProd = 8;
