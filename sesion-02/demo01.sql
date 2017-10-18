
create database DEVMASTERCLASES

use DEVMASTERCLASES

create table tbEmpleado
(
id int identity(1,1) primary key,
nombres varchar(100),
apellidos varchar(100)
)

insert into tbEmpleado
select 'Juan','Lopez'
insert into tbEmpleado
select 'Luis','Manrique'
insert into tbEmpleado
select 'Juan','Morales'

--Especificar en ORDER BY un campo definido en SELECT
select nombres,apellidos from tbEmpleado
order by nombres DESC--ASC implicitamente

--Especificar en ORDER BY un campo no definido en SELECT.
select nombres,apellidos from tbEmpleado
order by id DESC--ASC implicitamente

--Especificar en ORDER BY un alias definido en SELECT.
select nombres+' '+apellidos as nombrecompleto from tbEmpleado
order by nombrecompleto ASC--ASC implicitamente

select nombres+' '+apellidos as nombrecompleto from tbEmpleado
where nombrecompleto='Juan Lopez'
order by nombrecompleto ASC--ASC implicitamente

--Especificar en ORDER BY una expresión.
select id,nombres,apellidos from tbEmpleado
order by nombres+' '+apellidos asc

select id,nombres+' '+apellidos as nombrecompleto1,
apellidos+' '+nombres as nombrecompleto2 from tbEmpleado
order by apellidos+' '+nombres asc

--Especificar un orden ascendente, descendente.
select apellidos,nombres from tbEmpleado
order by apellidos asc,nombres desc



DECLARE    @tamPagina AS BIGINT = 10, 
           @numPagina AS BIGINT = 11;
SELECT     id,numCuenta,diasMora
FROM       tbCuenta
ORDER BY   id ASC
OFFSET    (@numPagina - 1) * @tamPagina ROWS FETCH NEXT @tamPagina ROWS ONLY
--Sacar a los 10 mas morosos por diasMora 
use CobranzaDB
go
select top 10  * from tbCuenta
order by diasmora desc

select top 10 with ties * from tbCuenta
order by diasmora desc

select * from tbCuenta
order by id asc
OFFSET 5 ROWS FETCH NEXT 20 ROWS ONLY
