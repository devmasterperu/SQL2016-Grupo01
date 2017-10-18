--Creación de base de datos
create database devmasterdb
--Uso de base de datos
use devmasterdb
--Creación de esquema
create schema desarrollo
--Creación de tablas
create table desarrollo.tbPersona
(
id int identity(1,1),
tipoDoc int not null,
nombres varchar(200) not null,
apellidos varchar(200) not null,
sexo char(1) null,
fecNacimiento datetime null
)
--Modificación de tablas.Adición de columnas
alter table desarrollo.tbPersona add estadoCivil int
--Modificación de tablas.Modificación de columnas
alter table desarrollo.tbPersona alter column nombres varchar(150)

--select getdate()