--Creaci�n de base de datos
create database devmasterdb
--Uso de base de datos
use devmasterdb
--Creaci�n de esquema
create schema desarrollo
--Creaci�n de tablas
create table desarrollo.tbPersona
(
id int identity(1,1),
tipoDoc int not null,
nombres varchar(200) not null,
apellidos varchar(200) not null,
sexo char(1) null,
fecNacimiento datetime null
)
--Modificaci�n de tablas.Adici�n de columnas
alter table desarrollo.tbPersona add estadoCivil int
--Modificaci�n de tablas.Modificaci�n de columnas
alter table desarrollo.tbPersona alter column nombres varchar(150)

--select getdate()