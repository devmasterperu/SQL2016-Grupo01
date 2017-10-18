--TIPOS DE DATOS

--3.19 FUNCION SUBSTRING (expression , start , length) 
--Usar como campo a mostrar
select SUBSTRING (apellidoPat,2,3) as parteApellidoPat,apellidoPat  from tbCliente
select SUBSTRING (apellidoPat,3,4) as parteApellidoPat,apellidoPat  from tbCliente
--Usar substring con tabla con alias.
select SUBSTRING (micliente.nombrecompleto,3,10) as parteMiNombreCompleto
from
(
select apellidoPat+' '+apellidoMat+' '+nombres as nombrecompleto
from tbCliente
) micliente
--Usar como condición de filtro
select * from tbCliente
where SUBSTRING (apellidoPat,3,4)='nriq'
select * from tbCliente
where apellidoPat like '__nriq%'
--3.20 FUNCION LEFT (expression , integer_value)
select LEFT (apellidoPat,6) as parteApellidoPat,apellidoPat  from tbCliente
select SUBSTRING (apellidoPat,1,6) as parteApellidoPat,apellidoPat  from tbCliente
--3.21 FUNCION RIGHT (expression , integer_value) 
select RIGHT (apellidoPat,6) as parteApellidoPat,apellidoPat  from tbCliente
--3.22 FUNCION LEN (string_expression) 
--Mostrar el tamaño de los apellidos paternos
select LEN (apellidoPat) as tamApellidoPat,apellidoPat  from tbCliente
--Filtrar los clientes con longitud de apellido paterno<10
select id,apellidoPat,LEN (apellidoPat)  from tbCliente
where LEN (apellidoPat)<10
order by LEN (apellidoPat) desc
--Filtrar los clientes con longitud de apellido paterno<10 y contengan "and"
select id,apellidoPat,LEN (apellidoPat)  from tbCliente
where LEN (apellidoPat)<10 and 
	  apellidoPat LIKE '%and%'
order by LEN (apellidoPat) desc