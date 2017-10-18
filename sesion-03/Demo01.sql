--sesion 03.Inserción-Modificación-Eliminación.
--3.1 Inserción de un solo registro
--select * from tbUbigeo
INSERT INTO dbo.tbUbigeo VALUES (N'Lima', N'Huaura','Sayán')

select * from dbo.tbUbigeo
--3.2 Insertar varias filas de datos
INSERT INTO dbo.tbUbigeo VALUES 
(N'Lima',N'Barranca','Barranca'),--registro 1 
(N'Lima',N'Barranca','Paramonga'),--registro 2
(N'Lima',N'Barranca','Pativilca'),--registro 3
(N'Lima',N'Barranca','Supe'); --registro 4

--Inserciones para no afectar FK entre tbCliente y tbUbigeo, para ubigeo no existente.
--Insertar registro en tabla de ubigeo
--Insertar registro en tabla cliente con el nuevo id creado de ubigeo.

--3.3 Insertar en cualquier orden de columnas.
INSERT INTO dbo.tbUbigeo(distrito,departamento,provincia)
VALUES (N'Chancay',N'Lima','Huaral')

--Validar registro de Chancay.
select * from tbUbigeo
where distrito='Chancay'

--3.4 Insertar en columnas que tienen valor predeterminado
--ALTER TABLE [dbo].[tbCliente] ADD  DEFAULT (getdate()) FOR [fecRegistro]
--Esta sentencia arroja error porque no existe aún tipo cliente E.
INSERT INTO dbo.tbCliente(tipoCliente,tipoDoc,numDoc,nombres,apellidoPat,apellidoMat,sexo,idUbigeo,fecRegistro) 
VALUES ('E',1,'46173384','Roberto','Vargas','Díaz','M',3,'2017-10-01 00:00:00.000')

--Crear el tipo de cliente E
INSERT INTO tbTipoCliente
values ('E','Cliente sin riesgo')

--Esta sentencia ya no arroja error porque ya existe el tipo cliente E.
INSERT INTO dbo.tbCliente(tipoCliente,tipoDoc,numDoc,nombres,apellidoPat,apellidoMat,sexo,idUbigeo,fecRegistro) 
VALUES ('E',1,'46173384','Roberto','Vargas','Díaz','M',3,'2017-10-01 00:00:00.000')

--3.5 Insertar en una tabla con columna IDENTITY
--Habilita la inserción de valores a pesar que sea IDENTITY. 
SET IDENTITY_INSERT dbo.tbCliente ON; 
--Inserto nuevo registro
INSERT INTO dbo.tbCliente(id,tipoCliente,tipoDoc,numDoc,nombres,apellidoPat,apellidoMat,sexo,
idUbigeo,fecRegistro)
values (108,'E',1,'46503567','Juan','Vargas','Morales','M',1,'2017-10-01 00:00:00.000')
--Valido inserción de 108.
select * from dbo.tbCliente where id=108
--Inserto nuevo registro con IDENTITY_INSERT en ON
INSERT INTO dbo.tbCliente(tipoCliente,tipoDoc,numDoc,nombres,apellidoPat,apellidoMat,sexo,
idUbigeo,fecRegistro)
values ('E',1,'46503567','Juan','Vargas','Morales','M',1,'2017-10-01 00:00:00.000')
--ERROR:Explicit value must be specified for identity column in table 'tbCliente'
--Deshabilita la inserción de valores en campo IDENTITY. 
SET IDENTITY_INSERT dbo.tbCliente OFF; 
--Insertar nuevo registro con clausula IDENTITY_INSERT en OFF si permite.
INSERT INTO dbo.tbCliente(tipoCliente,tipoDoc,numDoc,nombres,apellidoPat,apellidoMat,sexo,
idUbigeo,fecRegistro)
values ('E',1,'80808084','María','Luna','Solari','F',16,'2017-10-01 00:00:00.000')

--3.6 Usar SELECT para insertar datos en otra tabla.
--Crear esta table con info en bruto.
create table dbo.tbMaestroCliente(
descTipoDoc varchar(100) null,
numDoc varchar(20) null,
nombres varchar(100) null,
apellidoPat varchar(100) null,
apellidoMat varchar(100) null,
sexo char(1) null,
departamento varchar(200) null,
provincia varchar(200) null,
distrito varchar(200) null
)

--Insertar estos registros en tabla maestra.
INSERT INTO dbo.tbMaestroCliente
values ('Carnet de extranjería','66173389','Luz','Salgado','Solari','F','Lima','Huaura','Carquín'),
       ('Pasaporte','44455577','Luis','Espada','Morales','M','Lima','Huaura','Huacho');
--Crear nuevo tipo de documento-Pasaporte
insert into tbTipoDocumento values ('Pasaporte')
--Inserción ya con tipo de documento creado.
INSERT INTO dbo.tbCliente(tipoCliente,tipoDoc,numDoc,nombres,apellidoPat,apellidoMat,sexo,idUbigeo)
select 'A' as tipoCliente,tipoDoc.tipo,mcliente.numDoc,mcliente.nombres,mcliente.apellidoPat,
mcliente.apellidoMat,mcliente.sexo,ubigeo.id 
from  dbo.tbMaestroCliente mcliente
inner join dbo.tbTipoDocumento tipoDoc on mcliente.descTipoDoc=tipoDoc.descripcion
inner join dbo.tbUbigeo ubigeo on mcliente.departamento=ubigeo.departamento 
and mcliente.provincia=ubigeo.provincia 
and mcliente.distrito=ubigeo.distrito
--Validar nuevos registros.
select * from dbo.tbCliente order by fecRegistro desc
--3.7 Usar EXECUTE para insertar datos de otras tablas
--error Could not find stored procedure
INSERT INTO dbo.tbCliente(tipoCliente,tipoDoc,numDoc,nombres,apellidoPat,apellidoMat,sexo,idUbigeo)
EXEC  dbo.spInsertaClienteDeMaestro--Procedimiento almacenado

--Insertar nuevos registros en maestro de clientes.
INSERT INTO dbo.tbMaestroCliente
values ('Carnet de extranjería','11223344','Carlos','Trujillo','Sole','M','Lima','Huaura','Sayán'),
       ('Pasaporte','22445566','Luis','Aguinaga','Perez','M','Lima','Huaura','Sayán');

--Crear procedimiento almacenado
create procedure dbo.spInsertaClienteDeMaestro as
begin--inicio
	select 'A' as tipoCliente,tipoDoc.tipo,mcliente.numDoc,mcliente.nombres,mcliente.apellidoPat,
	mcliente.apellidoMat,mcliente.sexo,ubigeo.id 
	from  dbo.tbMaestroCliente mcliente
	inner join dbo.tbTipoDocumento tipoDoc on mcliente.descTipoDoc=tipoDoc.descripcion
	inner join dbo.tbUbigeo ubigeo on mcliente.departamento=ubigeo.departamento 
	and mcliente.provincia=ubigeo.provincia 
	and mcliente.distrito=ubigeo.distrito
	where mcliente.distrito='Sayán'
end--fin
--Validar ejecución de procedure
EXECUTE dbo.spInsertaClienteDeMaestro
--Permite registro con procedimiento almacenado creado.
INSERT INTO dbo.tbCliente(tipoCliente,tipoDoc,numDoc,nombres,apellidoPat,apellidoMat,sexo,idUbigeo)
EXEC  dbo.spInsertaClienteDeMaestro--Procedimiento almacenado

--3.8 Usar TOP para limitar los datos insertados de la tabla origen
--Forma 1
INSERT TOP(1) INTO dbo.tbCliente(tipoCliente,tipoDoc,numDoc,nombres,apellidoPat,apellidoMat,sexo,idUbigeo)
EXEC  dbo.spInsertaClienteDeMaestro
--Validar inserción de un registro
select * from dbo.tbCliente order by fecRegistro desc
--Forma 2
--Modificar stored procedure
alter procedure dbo.spInsertaClienteDeMaestro as
begin--inicio
	select top 1 'A' as tipoCliente,tipoDoc.tipo,mcliente.numDoc,mcliente.nombres,mcliente.apellidoPat,
	mcliente.apellidoMat,mcliente.sexo,ubigeo.id 
	from  dbo.tbMaestroCliente mcliente
	inner join dbo.tbTipoDocumento tipoDoc on mcliente.descTipoDoc=tipoDoc.descripcion
	inner join dbo.tbUbigeo ubigeo on mcliente.departamento=ubigeo.departamento 
	and mcliente.provincia=ubigeo.provincia 
	and mcliente.distrito=ubigeo.distrito
	where mcliente.distrito='Sayán'
end--fin
--Validar nueva versión de procedimiento almacenado
EXEC dbo.spInsertaClienteDeMaestro
--Permite registro con procedimiento almacenado creado.
INSERT INTO dbo.tbCliente(tipoCliente,tipoDoc,numDoc,nombres,apellidoPat,apellidoMat,sexo,idUbigeo)
EXEC  dbo.spInsertaClienteDeMaestro--Procedimiento almacenado
--Validar inserción de un registro
select * from dbo.tbCliente order by fecRegistro desc

--3.9 Insertar datos en una variable del tipo tabla
--3.9.1 declarar la tabla como variable
declare @maestroCliente table
(
tipoCliente char(2) null,
tipoDoc int null,
numDoc varchar(20) null,
nombres varchar(100) null,
apellidoPat varchar(100) null,
apellidoMat varchar(100) null,
sexo char(1) null,
idUbigeo int null
)
--3.9.2 Inserción a través de procedimiento almacenado.
INSERT INTO @maestroCliente(tipoCliente,tipoDoc,numDoc,nombres,apellidoPat,apellidoMat,sexo,idUbigeo)
EXEC  dbo.spInsertaClienteDeMaestro
--3.9.3 Validación inmediatamente luego de la ejecución de 3.9.1 y 3.9.2
select * from @maestroCliente
--3.9.4 Validación falla porque variable @maestroCliente se liberó de memoria.
select * from @maestroCliente

--3.10 Utilizar DELETE sin la clausula WHERE.
BEGIN TRAN--INICIO DE TRANSACCION
	DELETE FROM dbo.tbMaestroCliente
	WHERE 1=1
	TRUNCATE TABLE dbo.tbMaestroCliente
ROLLBACK--REVERSA DE TRANSACCION.

--3.11 Usar la cláusula WHERE para eliminar un conjunto de fila.
BEGIN TRAN--INICIO DE TRANSACCION
	DELETE FROM dbo.tbMaestroCliente
	WHERE nombres=nombres OR numDoc='2233445566'  --Condicion de eliminacion
ROLLBACK--REVERSA DE TRANSACCION.

--3.12 Usar Joins y Subconsultas para eliminar filas de otra tabla.

--Valido si hay resultados en JOIN
select mcliente.numDoc,tipoDoc.tipo,ubigeo.id
from dbo.tbMaestroCliente mcliente
left join dbo.tbTipoDocumento tipoDoc on mcliente.descTipoDoc=tipoDoc.descripcion
left join dbo.tbUbigeo ubigeo on mcliente.departamento=ubigeo.departamento and mcliente.provincia=ubigeo.provincia 
and mcliente.distrito=ubigeo.distrito

BEGIN TRAN--INICIO DE TRANSACCION
delete mcliente
from dbo.tbMaestroCliente mcliente
inner join dbo.tbTipoDocumento tipoDoc on mcliente.descTipoDoc=tipoDoc.descripcion
inner join dbo.tbUbigeo ubigeo on mcliente.departamento=ubigeo.departamento and mcliente.provincia=ubigeo.provincia 
and mcliente.distrito=ubigeo.distrito
ROLLBACK--REVERSA DE TRANSACCION.

--select * from tbMaestroCliente
--select * from tbUbigeo
--update tbMaestroCliente
--set distrito='Carquín'
--from tbMaestroCliente
--where numDoc='66173389'
update tbMaestroCliente
set distrito='Sayán'
from tbMaestroCliente
where numDoc in ('11223344','22445566')
--3.13 Subconsultas para eliminar filas de otra tabla
--Considerar que en la realidad debería validarse por tipo+número
BEGIN TRAN--INICIO DE TRANSACCION
delete mcliente
from   dbo.tbMaestroCliente mcliente
where  numDoc not in
(
 select distinct numDoc from tbCliente 
)
ROLLBACK--REVERSA DE TRANSACCION.
--Valido que no hay registros por insertar
select * from tbMaestroCliente
where numDoc not in
(
 select distinct numDoc from tbCliente 
)
--Ingresar un nuevo registro
INSERT INTO dbo.tbMaestroCliente
values ('Carnet de extranjería','99999999','Jose','Manrique','Uceda','M','Lima','Huaura','Hualmay')
--Valido que hay registros por eliminar
select * from tbMaestroCliente
where numDoc not in
(
 select distinct numDoc from tbCliente 
)
--Eliminación ahora procede porque tbMaestroCliente tiene registros que no están en tbCliente
BEGIN TRAN--INICIO DE TRANSACCION
delete mcliente
from   dbo.tbMaestroCliente mcliente
where  numDoc not in
(
 select distinct numDoc from tbCliente 
)
ROLLBACK--REVERSA DE TRANSACCION.
--3.14 Utilizar TOP para limitar el número de filas eliminadas
--Obtener los primeros 5 clientes con deuda total<1000
select top(5) * from dbo.tbCuenta
where deudaTotal<1000
--Ejecutar eliminación.
BEGIN TRAN--INICIO DE TRANSACCION
delete TOP(5) from dbo.tbCuenta
where deudaTotal<1000
ROLLBACK--REVERSA DE TRANSACCION.

--3.15 Utilizar UPDATE para actualizar una sola columna
update tbCuenta
set diasMora=diasMora+1
where diasMora>0
--Adicionar columna diasMoraNuevo
--3.16 Utilizar UPDATE para actualizar más de una columna
update tbCuenta
set diasMora=diasMora+1
where diasMora>0
--La nueva columna a usar es diasMoraNuevo
update tbCuenta
set    diasMoraNuevo=diasMoraNuevo+1,
       diasMora=99999999
where diasMora>0
--3.17 Utilizar UPDATE para actualizar más de una columna
--Adicionar columna fecactualiza
alter table tbCliente add fecActualiza datetime null
--Modificar campos tipoCliente y fecActualiza
update cli
set    tipoCliente=case when cli.idClienteRel is not null then'A' else 'E' end,
       fecActualiza=getdate()
from   tbCliente cli
--Validacion de update
select tipoCliente,fecActualiza,id,nombres,apellidoPat,apellidoMat from tbCliente
--Modificar campos tipoCliente y fecActualiza
--Error The UPDATE statement conflicted with the FOREIGN KEY constraint
update cli
set    tipoCliente=case when cli.idClienteRel is not null then'A' else 'F' end,
       fecActualiza=getdate()
from   tbCliente cli

--3.18 Utilizar UPDATE con Joins y Subconsultas 
--Actualizo fecActualiza y tipoCliente con JOIN
BEGIN TRAN
update  cli
set     cli.fecActualiza=getdate(),
        cli.tipoCliente='A'
from    tbCliente cli inner join
        tbCuenta  cta on cli.id=cta.idCliente
where   diasmoraNuevo=(select min(diasmoraNuevo) from tbCuenta 
				       where diasMoraNuevo>30
				       )
ROLLBACK
--Valido si actualización cumplió condiciones
select cli.*,cta.diasMoraNuevo from tbCliente cli join tbCuenta cta on cli.id=cta.idCliente
order by cli.fecActualiza desc
--Actualizo fecActualiza y tipoCliente sin JOIN
BEGIN TRAN
update  cli
set     cli.fecActualiza=getdate(),
        cli.tipoCliente='A'
from    tbCliente cli,
        tbCuenta  cta 
where   cli.id=cta.idCliente 
and     diasMoraNuevo=(select min(diasMoraNuevo) from tbCuenta 
				       where diasMoraNuevo>30
				      )
ROLLBACK
