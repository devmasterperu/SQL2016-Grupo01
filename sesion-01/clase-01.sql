--Crear base de datos
CREATE DATABASE DEVMASTERCLASES
--Crear esquema
CREATE SCHEMA alumnos
--Crear tabla



--Usar esta base de datos
USE DEVMASTERCLASES
GO
--Crear esquema sobre BD anterior
CREATE SCHEMA produccion
--Crear tabla sobre esquema produccion
CREATE TABLE produccion.alumno
(
id int identity(1,1)  primary key,
nombres varchar(100),
apellidos varchar(200),
tipo char(2),
estado bit
)
--Crear tabla sobre esquema dbo
CREATE TABLE alumno
(
id int identity(1,1)  primary key,
nombres varchar(100),
apellidos varchar(200),
tipo char(2),
estado bit
)
--Consultar todos los campos
select * from produccion.alumno
--Modificar la columna tipo
alter table produccion.alumno alter column tipo char(4)
--Agregar columna fecnacimiento
alter table produccion.alumno add fecnacimiento datetime
--Agregar columna fecregistro
alter table produccion.alumno add fecregistro datetime default getdate()
--Eliminar columna fecnacimiento
alter table produccion.alumno drop column fecnacimiento
--Insertar registros
select * from produccion.alumno

insert into produccion.alumno
select 'gianfranco','manrique valentín','A',1,null

insert into produccion.alumno(nombres,apellidos,tipo,estado)
select 'gin carlos','manrique valentín','A',1

insert into produccion.alumno(nombres,apellidos,tipo,estado)
select 'juan','lopez perez','A',0

insert into produccion.alumno(nombres,apellidos,tipo,estado)
select 'jesus','morales diaz','B',1

insert into produccion.alumno(nombres,apellidos,tipo,estado)
select 'armando','luna trujillo','B',1

insert into produccion.alumno(nombres,apellidos,tipo,estado)
select 'A','X','A',1 union all 
select 'B','Y','B',0 union all 
select 'C','Z','A',1 union all 
select 'A','X','B',0 union all 
select 'B','Y','A',1 union all 
select 'C','Z','B',0 union all 
select 'A','X','A',1 union all 
select 'B','Y','B',0 union all 
select 'C','Z','A',1 union all 
select 'A','X','B',0 union all 
select 'B','Y','A',1 union all 
select 'C','Z','B',0 union all 
select 'A','X','A',1 union all 
select 'B','Y','B',0 union all 
select 'C','Z','A',1 union all 
select 'A','X','B',0 union all 
select 'B','Y','A',1 
--Uso de Where

--Obtener todos los alumnos del tipo A y que se encuentren activos
select * from  produccion.alumno
where tipo='A' and estado=1
--Obtener los nombres y apellidos completos de
--todos los alumnos del tipo B y que se encuentren inactivos
select id as IdAlumno,nombres+' '+apellidos as nombrecompleto from  produccion.alumno
where tipo='A' and estado=0
--Obtener los alumnos que tengan como apellido manrique en cualqquier parte
select id,nombres+' '+apellidos as nombrecompleto from  produccion.alumno
where apellidos like '%manrique%'
--Obtener los alumnos que sus nombres inicien con A
select id,nombres+' '+apellidos as nombrecompleto from  produccion.alumno
where nombres like 'A%'
--Obtener los alumnos que se hayan registrado el día de hoy
select * from produccion.alumno
where CONVERT(VARCHAR(8),fecregistro,112)=CONVERT(VARCHAR(8),getdate(),112)
--Mostrar la columna fecregistro en formato aaaammyy
select CONVERT(VARCHAR(8),getdate(),112) from produccion.alumno
--Mostrar el total de alumnos por estado.
select case when estado=0 then 'inactivo' else 'activo' end as estadoAgrupado,count(id) as totalAgrupado
from produccion.alumno
group by estado
--Obtener el promedio máximo por cada tipo de alumno
alter table  produccion.alumno add promedio int
--Actualizar los promedios
--update produccion.alumno
--set promedio=11
--where id>=1 and id<=5

--update produccion.alumno
--set promedio=13
--where id>=6 and id<=10

--update produccion.alumno
--set promedio=16
--where id>=11 
select tipo as tipoAlumno,max(promedio) as maxpromedio,
count(id) as totAlumnos from produccion.alumno
group by tipo

--Obtener los alumnos que tengan el promedio máximo
select id,nombres+' '+apellidos as nombrecompleto,promedio
from produccion.alumno
where promedio=(select max(promedio) from produccion.alumno)

--Obtener los alumnos que no tengan el promedio máximo
select id,nombres+' '+apellidos as nombrecompleto,promedio
from produccion.alumno
where promedio<>(select max(promedio) from produccion.alumno)
--Obtener el promedio máximo por cada estado y tipo de alumno
select case when estado='0' then 'inactivo' else 'activo' end as nomestado,
case when tipo='A' then 'Premium' else 'Standard' end as nomtipo,
max(promedio) as maxpromedioXet from produccion.alumno
group by estado,tipo
having estado='1'--Grupos con estado activo
--Obtener el promedio máximo por cada estado y tipo de alumno y que tenga un valor
--de registro.
select case when estado='0' then 'inactivo' else 'activo' end as nomestado,
case when tipo='A' then 'Premium' else 'Standard' end as nomtipo,
max(promedio) as maxpromedioXet from produccion.alumno
where fecregistro is not null
group by estado,tipo
having estado='1'--Grupos con estado activo
--Trasladar información de esquema produccion a esquema dbo.
insert into dbo.alumno (nombres,apellidos,tipo,estado)
select nombres,apellidos,tipo,estado
from produccion.alumno

insert into dbo.alumno
select 'Carlos','Morales Díaz','C',1
--Cuales son los tipos de alumnos que están en esquema dbo pero no en produccion.
select distinct tipo from dbo.alumno
where tipo not in
(
select distinct tipo from produccion.alumno
)
--Cuales son los tipos de alumnos que están en esquema dbo y en produccion.
select distinct tipo from dbo.alumno
where tipo in
(
select distinct tipo from produccion.alumno
)
--Cuales son los tipos de alumnos que están en esquema producción y no dbo.
select distinct tipo from produccion.alumno
where tipo not in
(
select distinct tipo from dbo.alumno
)
--Obtener por cada estado, tipo, ciudad el total de alumnos 
--cuyos nombres comiencen con A
alter table produccion.alumno add ciudad varchar(200)
--update produccion.alumno
--set ciudad='Huacho'
--where id<=11
--update produccion.alumno
--set ciudad='Barranca'
--where id>11

select estado,tipo,ciudad,count(distinct id) as Total from produccion.alumno
where nombres like 'A%'
group by estado,tipo,ciudad

select estado,tipo,ciudad,count(distinct id) as Total from produccion.alumno
where nombres like 'Am%'
group by estado,tipo,ciudad
