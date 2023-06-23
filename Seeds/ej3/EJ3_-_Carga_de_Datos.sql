
USE ejercicio3;
GO

INSERT INTO Proveedor (idProveedor, nombre, respdCivil, cuit)
VALUES (1, 'Proveedor 1', 'Responsable Inscripto', '20-12345678-9'),
       (2, 'Proveedor 2', 'Responsable Inscripto', '20-87654321-9'),
       (3, 'Proveedor 3', 'Responsable Inscripto', '20-12345678-9'),
       (4, 'Proveedor 4', 'Responsable Inscripto', '20-87654321-9'),
       (5, 'Proveedor 5', 'Responsable Inscripto', '20-12345678-9');

INSERT INTO Producto (idProducto, nombre, descrip, estado, idProveedor)
VALUES (1, 'Producto 1', 'Descripción del producto 1', 'en stock', 1),
       (2, 'Producto 2', 'Descripción del producto 2', 'en stock', 1),
       (3, 'Producto 3', 'Descripción del producto 3', 'agotado', 2),
       (4, 'Producto 4', 'Descripción del producto 4', 'agotado', 2),
       (5, 'Producto 5', 'Descripción del producto 5', 'en stock', 3),
       (6, 'Producto 6', 'Descripción del producto 6', 'en stock', 3),
       (7, 'Producto 7', 'Descripción del producto 7', 'agotado', 4),
       (8, 'Producto 8', 'Descripción del producto 8', 'agotado', 4),
       (9, 'Producto 9', 'Descripción del producto 9', 'en stock', 5);

INSERT INTO Cliente (idCliente, nombre, respIVA, CUIL)
VALUES (1, 'Cliente 1', 'Responsable Inscripto', '20-12345678-9'),
       (2, 'Cliente 2', 'Responsable Inscripto', '20-87654321-9'),
       (3, 'Cliente 3', 'Responsable Inscripto', '20-12325678-9'),
       (4, 'Cliente 4', 'Responsable Inscripto', '20-87644321-9'),
       (5, 'Cliente 5', 'Responsable Inscripto', '20-12341678-9');

INSERT INTO Direccion (idDir,idCliente , calle , nro , piso , dpto )
VALUES(1 ,1 ,'Calle Falsa' ,'1234' ,NULL ,NULL ),
      (2 ,2 ,'Calle Verdadera' ,'4321' ,NULL ,NULL ),
      (3 ,3 ,'Calle Falsa' ,'1235' ,NULL ,NULL ),
      (4 ,4 ,'Calle Verdadera' ,'4320' ,NULL ,NULL ),
      (5 ,5 ,'Calle Falsa' ,'1236' ,NULL ,NULL );

INSERT INTO Vendedor(idEmpleado,nombre ,apellido,DNI )
VALUES(1,'Vendedor','Uno','12345678'),
      (2,'Vendedor','Dos','87654321'),
      (3,'Vendedor','Tres','12345678'),
      (4,'Vendedor','Cuatro','87654321'),
      (5,'Vendedor','Cinco','12345678');

INSERT INTO Venta(nroFactura,idCliente ,fecha,idVendedor )
VALUES(1,1,GETDATE(),1),
(2,2,GETDATE(),2),
(3,3,GETDATE(),3),
(4,4,GETDATE(),4),
(5,5,GETDATE(),5),
(6,1,GETDATE(),1),
(7,2,GETDATE(),1),
(8,3,GETDATE(),2),
(9,4,GETDATE(),2),
(10,5,GETDATE(),3);

INSERT INTO Detalle_venta(nroFactura,nro,idProducto,cantidad ,precioUnitario )
VALUES (1,1,1,15001,100),
(1,2,2,15002,200),
(2,1,3,15003,300),
(2,2,4,15004,400),
(3,1,5,10000,500),
(3,2,6,10001,600),
(4,1,7,1000,700),
(4,2,8,1001,800),
(5,1,6,1002,900),
(6,1,1,1000,100),
(6,2,2,1000,200),
(7,1,3,1000,300),
(7,2,4,1000,400),
(8,1,5,1000,500),
(9,1,6,1000,600),
(10,1,7,1020,700);