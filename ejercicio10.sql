/*
Request (NoRequest, IP, Fecha, Hora, IDMetodo)
Page (IP, WebPage, IDAmbiente)
Método (ID, Clase, Metodo)
Ambiente (ID, Descripción)

Nota: El ambiente podrá ser Desarrollo, Testing o Producción. 
La función date() devuelve la fecha actual.
Si se resta un valor entero a la función, restará días. 
El ejercicio consiste en indicar qué enunciado dio
origen a cada una de las consultas:

1)
Select P.IP, count(distinct fecha), 
count(distinct IDMetodo), max(fecha)
From Page P Inner join Request R on P.IP=R.IP
Group by P.IP

Obtenga las IP, la cantidad de fechas de las requests,
la cantidad de métodos, y la ultima fecha de las Request 
realizadas.


2)
Select *
From Ambiente A
Where id not in
	(Select idambiente
	 From Page P
	 Where not exists (
				Select 1 From Request R
				Where R.IP=P.IP and fecha>= date()-7))

Obtenga los ambientes tal se encuentren en paginas
con fecha posterior a los ultimos 7 días. 


3)
Select Fecha, count(*)
From Request R
Where hora between ‘00:00’ and ‘04:00’
and not exists(
		select 1 from Page P
		inner join Ambiente A on P.IDAmbiente = A.ID
		where R.IP=P.IP AND A.Descripcion=’Desarrollo’ )
Group by fecha
Having count(*) >= 10

Obtenga las fechas y cantidades por fecha de las 
request efectuadas entre las 0hs y las 4hs, cuyo 
ambiente no sea de desarrollo, cuando las mismas sumen
mas de 10 por día. 


4)
Select W.WebPage, A.Descripcion, max(R.fecha), ‘S’
From Request R
	Inner join WebPage W on R.IP=W.IP
	Inner join Ambiente A on A.id=W.IDAmbiente
Where R.Fecha>=date()-7 and W.Webpage like ‘www%’
Group by W.WebPage, A.Descripcion
Having count(distinct fecha)>=7

Obtenga el nombre de la web page y la descripcion del
ambiente de fecha mas reciente de los últimos 7 días
tal que la web pague comience con www.


5)
Select W.WebPage, A.Descripcion,
max(case 
		when R2.fecha is null then ‘01/01/1900’ 
		else R2.fecha
	end), ‘N’
From WebPage W 
Left join (Select IP, max(fecha)
		   From Request R
		   Group by IP ) R2 
on R2.IP = W.IP
Where W.Webpage like ‘ftp%’ 
and not exists (
		Select 1
		from Request R
		where R.IP=W.IP and R.Fecha>=date()-7
		group by R.IP
		having count(*)>=7)
Group by W.WebPage, A.Descripcion

Obtenga  la descripcion del ambiente y la fecha mas 
reciente(en caso de ser null asignar 01/01/1900) 
de cada web page que contengan 'ftp', que sea de 
fecha anterior a los ultimos 7 días y que la cantidad
de request no excedan la cantidad de 7.


6)
insert into Page
select IP, ‘Web ‘ + IDMetodo, ‘?’
from request R
where not exists (
		Select 1 from Page P
		where R.IP=P.IP )
and IDMetodo in (select ID from Metodo)
and fecha>=date()-30

Insertar en la tabla Page aquellas paginas que 
contengan ips no registradas en request, su nombre 
estará formado por el id del metodo correspondiente
a la tabla metodo y con fecha dentro de los ultmos
30 dias.
