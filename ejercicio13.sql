CREATE DATABASE ejercicio13;
GO
USE ejercicio13;

--1. p_CrearEntidades(): Realizar un procedimiento que permita crear las tablas
--   de nuestro modelo relacional. 

CREATE PROCEDURE p_CrearEntidades AS
BEGIN
	CREATE TABLE Nivel(
	codigo int PRIMARY KEY,
	descripcion VARCHAR(100));

	CREATE TABLE Medicion(
	fecha DATE,
	hora TIME,
	metrica VARCHAR(25),
	temperatura DECIMAL(10,2),
	presion DECIMAL(5,2),
	humedad DECIMAL(5,2),
	nivel INT,
	CONSTRAINT PKMedicion PRIMARY KEY(fecha, hora, metrica),
	CONSTRAINT nivelFK FOREIGN KEY(nivel) 
	REFERENCES Nivel(codigo));
END;

EXECUTE p_CrearEntidades;


--2. f_ultimamedicion(Métrica): Realizar una función que devuelva la fecha y hora
--   de la última medición realizada en una métrica específica, la cual será enviada
--   por parámetro. La sintaxis de la función deberá respetar lo siguiente:
--   Fecha/hora = f_ultimamedicion(vMetrica char(5))
--   Ejemplificar el uso de la función.

CREATE FUNCTION f_ultimamedicion(@Metrica VARCHAR(25))
RETURNS DATETIME
AS
BEGIN
DECLARE @fecha DATE
DECLARE @hora TIME
DECLARE @retorno DATETIME
	SET @fecha = (SELECT fecha FROM Medicion
				  WHERE metrica = @Metrica);
	SET	@hora = (SELECT hora FROM Medicion
				 WHERE metrica = @Metrica);
	SET	@retorno = cast(@fecha as datetime) + cast(@hora as datetime);
		
	RETURN @retorno;
END;


--3. v_Listado: Realizar una vista que permita listar las métricas en las cuales se
--   hayan realizado, en la última semana, mediciones para todos los niveles
--   existentes. El resultado del listado deberá mostrar, el nombre de la métrica que
--   respete la condición enunciada, el máximo nivel de temperatura de la última
--   semana y la cantidad de mediciones realizadas también en la última semana.

CREATE VIEW v_Listado AS
SELECT metrica, COUNT(nivel) cant_niveles
FROM Medicion, Nivel
WHERE Medicion.nivel = Nivel.codigo 
GROUP BY metrica
HAVING (SELECT COUNT(*) FROM Nivel) = COUNT(nivel);


--4. p_ListaAcumulados(finicio,ffin): Realizar un procedimiento que permita
--   generar una tabla de acumulados diarios de temperatura por cada métrica y
--   por cada día. El procedimiento deberá admitir como parámetro el rango de
--   fechas que mostrará el reporte. Además, estas fechas deben ser validadas.
--   El informe se deberá visualizar de la siguiente forma:
--      Fecha      Metrica Ac.DiarioTemp Ac.Temp
--   01/03/2009       M1         25        25
--   02/03/2009       M1         20        45
--   03/03/2009       M1         15        60
--   01/03/2009       M2         15        15
--   02/03/2009       M2         10        25

CREATE PROCEDURE p_ListaAcumulados(@finicio DATE, @ffin DATE) AS
BEGIN
	SELECT m.fecha Fecha, m.metrica Metrica, 
	       SUM(m.temperatura)
		   OVER (PARTITION BY m.fecha 
		   ORDER BY DATEPART(dd,m.fecha)) AcDiarioTemp,
		   SUM(m.temperatura)
		   OVER (PARTITION BY m.metrica) AcMetrica
	FROM Medicion m
	ORDER BY m.metrica ASC, m.fecha DESC
END;


--5. p_InsertMedicion(fecha,hora, metrica,temp,presion,hum,niv):
--   Realizar un procedimiento que permita agregar una nueva medición en su respectiva
--   entidad. Los parámetros deberán ser validados según:
--   a. Para una nueva fecha hora, no puede haber más de una medida por
--   métrica
--   b. El valor de humedad sólo podrá efectuarse entre 0 y 100.
--   c. El campo nivel deberá ser válido, según su correspondiente entidad.

CREATE PROCEDURE p_InsertMedicion(@fecha DATE, @hora TIME, @metrica VARCHAR(25), @temp DECIMAL(10,2), @presion DECIMAL(5,2), @hum DECIMAL(5,2), @niv INT) AS
BEGIN
	IF (SELECT COUNT(*) FROM Medicion m WHERE m.fecha = @fecha AND m.hora = @hora) = 0 
	    AND @hum >= 0 AND @hum <= 100
		AND @niv IN (SELECT codigo FROM Nivel)
		
		INSERT INTO Medicion 
		VALUES (@fecha, @hora, @metrica, @temp, @presion, @hum, @niv);
	ELSE
		SELECT 'No se ha podido insertar la medición. Contiene valores invalidos'
END;


--6. p_depuraMedicion(días): Realizar un procedimiento que depure la tabla de
--   mediciones, dejando sólo las últimas mediciones. El resto de las mediciones,
--   no deben ser borradas sino trasladadas a otra entidad que llamaremos
--   Medicion_Hist. El proceso deberá tener como parámetro la cantidad de días de
--   retención de las mediciones.

CREATE TABLE Medicion_Hist(
fecha DATE,
hora TIME,
metrica VARCHAR(25),
temperatura DECIMAL(10,2),
presion DECIMAL(5,2),
humedad DECIMAL(5,2),
nivel INT,
CONSTRAINT PKMedicionHist PRIMARY KEY(fecha, hora, metrica),
CONSTRAINT nivelFKHist FOREIGN KEY(nivel) 
REFERENCES Nivel(codigo));

CREATE PROCEDURE p_depuraMedicion(@dias INT) AS
BEGIN
	INSERT INTO Medicion_Hist
	SELECT * FROM Medicion
	WHERE fecha < DATEADD(DAY, -@dias, GETDATE());

	DELETE FROM Medicion_Hist
	WHERE fecha < DATEADD(DAY, -@dias, GETDATE());
END;


--7. tg_descNivel: Realizar un trigger que coloque la descripción en mayúscula
--   cada vez que se inserte un nuevo nivel.

CREATE TRIGGER tg_descNivel ON Nivel AFTER INSERT AS
BEGIN
	DECLARE @string VARCHAR(100) = (SELECT i.descripcion FROM inserted i, Nivel n WHERE i.codigo = n.codigo)
	UPDATE Nivel 
	SET descripcion = (SELECT UPPER(@string))
	WHERE codigo = (SELECT codigo FROM inserted);
END;