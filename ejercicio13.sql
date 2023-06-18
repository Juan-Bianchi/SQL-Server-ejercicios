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


--2. f_ultimamedicion(M�trica): Realizar una funci�n que devuelva la fecha y hora
--   de la �ltima medici�n realizada en una m�trica espec�fica, la cual ser� enviada
--   por par�metro. La sintaxis de la funci�n deber� respetar lo siguiente:
--   Fecha/hora = f_ultimamedicion(vMetrica char(5))
--   Ejemplificar el uso de la funci�n.

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


--3. v_Listado: Realizar una vista que permita listar las m�tricas en las cuales se
--   hayan realizado, en la �ltima semana, mediciones para todos los niveles
--   existentes. El resultado del listado deber� mostrar, el nombre de la m�trica que
--   respete la condici�n enunciada, el m�ximo nivel de temperatura de la �ltima
--   semana y la cantidad de mediciones realizadas tambi�n en la �ltima semana.

CREATE VIEW v_Listado AS
SELECT metrica, COUNT(nivel) cant_niveles
FROM Medicion, Nivel
WHERE Medicion.nivel = Nivel.codigo 
GROUP BY metrica
HAVING (SELECT COUNT(*) FROM Nivel) = COUNT(nivel);


--4. p_ListaAcumulados(finicio,ffin): Realizar un procedimiento que permita
--   generar una tabla de acumulados diarios de temperatura por cada m�trica y
--   por cada d�a. El procedimiento deber� admitir como par�metro el rango de
--   fechas que mostrar� el reporte. Adem�s, estas fechas deben ser validadas.
--   El informe se deber� visualizar de la siguiente forma:
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
--   Realizar un procedimiento que permita agregar una nueva medici�n en su respectiva
--   entidad. Los par�metros deber�n ser validados seg�n:
--   a. Para una nueva fecha hora, no puede haber m�s de una medida por
--   m�trica
--   b. El valor de humedad s�lo podr� efectuarse entre 0 y 100.
--   c. El campo nivel deber� ser v�lido, seg�n su correspondiente entidad.

CREATE PROCEDURE p_InsertMedicion(@fecha DATE, @hora TIME, @metrica VARCHAR(25), @temp DECIMAL(10,2), @presion DECIMAL(5,2), @hum DECIMAL(5,2), @niv INT) AS
BEGIN
	IF (SELECT COUNT(*) FROM Medicion m WHERE m.fecha = @fecha AND m.hora = @hora) = 0 
	    AND @hum >= 0 AND @hum <= 100
		AND @niv IN (SELECT codigo FROM Nivel)
		
		INSERT INTO Medicion 
		VALUES (@fecha, @hora, @metrica, @temp, @presion, @hum, @niv);
	ELSE
		SELECT 'No se ha podido insertar la medici�n. Contiene valores invalidos'
END;


--6. p_depuraMedicion(d�as): Realizar un procedimiento que depure la tabla de
--   mediciones, dejando s�lo las �ltimas mediciones. El resto de las mediciones,
--   no deben ser borradas sino trasladadas a otra entidad que llamaremos
--   Medicion_Hist. El proceso deber� tener como par�metro la cantidad de d�as de
--   retenci�n de las mediciones.

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


--7. tg_descNivel: Realizar un trigger que coloque la descripci�n en may�scula
--   cada vez que se inserte un nuevo nivel.

CREATE TRIGGER tg_descNivel ON Nivel AFTER INSERT AS
BEGIN
	DECLARE @string VARCHAR(100) = (SELECT i.descripcion FROM inserted i, Nivel n WHERE i.codigo = n.codigo)
	UPDATE Nivel 
	SET descripcion = (SELECT UPPER(@string))
	WHERE codigo = (SELECT codigo FROM inserted);
END;