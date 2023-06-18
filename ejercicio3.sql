CREATE DATABASE ejercicio3;
USE ejercicio3;

CREATE TABLE Proveedor(
idProveedor INTEGER,
nombre VARCHAR(25),
respdCivil VARCHAR(50),
cuit VARCHAR(25),
CONSTRAINT idProveedor PRIMARY KEY(idProveedor));

CREATE TABLE Producto(
idProducto INTEGER,
nombre VARCHAR(25),
descrip VARCHAR(100),
estado VARCHAR(50),
idProveedor INTEGER,
CONSTRAINT idProducto PRIMARY KEY(idProducto),
CONSTRAINT idProveedorFK FOREIGN KEY(idProveedor)
REFERENCES Proveedor(idProveedor));

CREATE TABLE Cliente(
idCliente INTEGER,
nombre VARCHAR(50),
respIVA VARCHAR(50),
CUIL VARCHAR(25),
CONSTRAINT idCliente PRIMARY KEY(idCliente));

CREATE TABLE Direccion(
idDir INTEGER,
idCliente INTEGER,
calle VARCHAR(100),
nro VARCHAR(7),
piso INTEGER,
dpto INTEGER,
CONSTRAINT idDir PRIMARY KEY(idDir),
CONSTRAINT idClienteFK FOREIGN KEY(idCliente)
REFERENCES Cliente(idCliente));

CREATE TABLE Vendedor(
idEmpleado INTEGER,
nombre VARCHAR(50),
apellido VARCHAR(50),
DNI VARCHAR(25),
CONSTRAINT idEmpleado PRIMARY KEY(idEmpleado));

CREATE TABLE Venta(
nroFactura INTEGER,
idCliente INTEGER,
fecha DATE,
idVendedor INTEGER,
CONSTRAINT ventaPK PRIMARY KEY(nroFactura, idCliente),
CONSTRAINT idClienteFK2 FOREIGN KEY(idCliente)
REFERENCES Cliente(idCliente),
CONSTRAINT idVendedorFK FOREIGN KEY(idVendedor)
REFERENCES Vendedor(idEmpleado));

CREATE TABLE Detalle_venta(
nroFactura INTEGER,
nro INTEGER,
idProducto INTEGER,
cantidad INTEGER,
precioUnitario DECIMAL(10,2),
CONSTRAINT detalle_ventaPK PRIMARY KEY(nroFactura, nro),
CONSTRAINT idProductoFK FOREIGN KEY(idProducto)
REFERENCES Producto(idProducto));


--1)Indique la cantidad de productos que tiene la empresa.
SELECT COUNT(*) cant_prod FROM Producto p;


--2)Indique la cantidad de productos en estado 'en stock' que tiene la empresa.
SELECT * FROM Producto p 
WHERE p.estado LIKE '%stock%';


--3)Indique los productos que nunca fueron vendidos.
SELECT * FROM Producto p
WHERE NOT EXISTS(SELECT 1 FROM Detalle_venta v
				 WHERE v.idProducto = p.idProducto);

SELECT * FROM Detalle_venta;


--4)Indique la cantidad de unidades que fueron vendidas de cada producto.
SELECT idProducto, SUM(cantidad) cantidad
FROM Detalle_venta
GROUP BY idProducto;


--5)Indique cual es la cantidad promedio de unidades vendidas de cada producto.
SELECT idProducto, AVG(cantidad) cantidad
FROM Detalle_venta
GROUP BY idProducto;


--6)Indique quien es el vendedor con mas ventas realizadas.
CREATE VIEW MaxCantidadVentas AS
SELECT MAX(x.cantidadVentas) maximaCantVentas
FROM (SELECT idVendedor, COUNT(*) cantidadVentas
	  FROM Venta v
	  GROUP BY idVendedor)x;

SELECT v.idEmpleado, v.nombre, v.apellido, m.maximaCantVentas
FROM Vendedor v, MaxCantidadVentas m,
(SELECT idVendedor, COUNT(*) cantidadVentas
	  FROM Venta v
	  GROUP BY idVendedor)x
WHERE v.idEmpleado = x.idVendedor
AND m.maximaCantVentas = x.cantidadVentas;


--7)Indique todos los productos de lo que se hayan vendido 
--  más de 15.000 unidades
SELECT idProducto, SUM(cantidad) cant_total
FROM Detalle_venta d
GROUP BY idProducto 
HAVING SUM(cantidad) > 15000;


--8)Indique quien es el vendedor con mayor volumen de ventas.
CREATE VIEW maxVolumenVenta AS
SELECT MAX(x.volumen) maxVolumen FROM 
(SELECT v.idVendedor, SUM(d.cantidad) volumen
FROM Venta v, Detalle_venta d
WHERE v.nroFactura = d.nroFactura
GROUP BY v.idVendedor) x

SELECT v.idEmpleado, v.nombre, v.apellido, m.maxVolumen
FROM Vendedor v, maxVolumenVenta m,
(SELECT v.idVendedor, SUM(d.cantidad) volumen
FROM Venta v, Detalle_venta d
WHERE v.nroFactura = d.nroFactura
GROUP BY v.idVendedor)x
WHERE v.idEmpleado = x.idVendedor
AND m.maxVolumen = x.volumen;