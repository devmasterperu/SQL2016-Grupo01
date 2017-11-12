--1 Crear una función escalar
create or alter function dbo.fnOperaciones--Crea o modifica la función
(
@operacion char(1),
@valor1 int,
@valor2 int,
@valor3 int
)
returns int
as
begin
    declare @resultado int

    if @operacion='S'
	BEGIN
		SET @resultado=@valor1+@valor2+@valor3
	END
	if @operacion='M'
	BEGIN
		SET @resultado=@valor1*@valor2*@valor3
	END

	return @resultado
end
select dbo.fnOperaciones('S',1,5,3)
select dbo.fnOperaciones('M',1,5,3)
--2 Crear función que valide si una fecha es feriado

create or alter function dbo.fnValidaFeriado(
@fecha varchar(8)
)
returns varchar(50)
as
begin
	declare @total int
	declare @mensaje varchar(50)
	set @total=(select count(id) from tbFeriado where fecha=@fecha)
	
	if @total>0
	begin
		set @mensaje='Si es un feriado la fecha '+@fecha
	end
	else
	begin
	    set @mensaje='No es un feriado la fecha '+@fecha
	end 

	return @mensaje
end
select dbo.fnValidaFeriado('20171208')
select dbo.fnValidaFeriado('20171209')

--3 Uso de funciones en sentencia SELECT
update tbVenta
set fecRegistro='2017-12-08 00:00:00.000'
where id=1

select id,fecRegistro,dbo.fnValidaFeriado(CONVERT(VARCHAR(8),fecRegistro,112)) as mensaje from tbVenta

--4 Uso de funciones del tipo Tabla
create or alter function dbo.fnObtenerDetalleVenta
(
@idventa int
)returns table
as
	return select vta.id,vta.glosa,vtaDet.totalDetalle,vtaDet.cantidad,pdto.nombre
	from dbo.tbVenta vta 
	inner join tbVentaDetalle vtaDet on vta.id=vtaDet.idCompra
	inner join tbProducto pdto on vtaDet.idProducto=pdto.id
	where vta.id=@idventa
	--order by vta.id
--ver la definicion
EXEC sp_helptext 'fnObtenerDetalleVenta'--Pasar nombre del objeto

--5 Manejo de Transacciones
BEGIN TRANSACTION;

INSERT INTO tbVenta(idComprador,idVendedor,glosa)
select 3,2,'BOLETA-'+CONVERT(VARCHAR(8),GETDATE(),112)

declare @idventa int=(SELECT @@IDENTITY)

INSERT INTO  tbVentaDetalle(idCompra,idProducto,cantidad,precioUnidad)
VALUES (@idventa,1,100,3.5),(@idventa,2,100,1),(@idventa,3,100,2),(@idventa,5,100,0.5)

update tbVenta
set subtotal=(select sum(totalDetalle) from tbVentaDetalle where idCompra=@idventa)
where id=@idventa

COMMIT;
ROLLBACK;

select * from tbVenta
select * from tbVentaDetalle

--6 Uso de XACT_ABORT 
IF OBJECT_ID(N't2', N'U') IS NOT NULL  
    DROP TABLE t2;  
GO  
IF OBJECT_ID(N't1', N'U') IS NOT NULL  
    DROP TABLE t1;  
GO  
CREATE TABLE t1  
    (a INT NOT NULL PRIMARY KEY);  
CREATE TABLE t2  
    (a INT NOT NULL REFERENCES t1(a));  
GO  
INSERT INTO t1 VALUES (1);  
INSERT INTO t1 VALUES (3);  
INSERT INTO t1 VALUES (4);  
INSERT INTO t1 VALUES (6);  
GO 

SET XACT_ABORT OFF;  
GO  
BEGIN TRANSACTION;  
INSERT INTO t2 VALUES (1);  
INSERT INTO t2 VALUES (2);  
INSERT INTO t2 VALUES (3);  
COMMIT TRANSACTION;  
GO  

SET XACT_ABORT ON;  
GO  
BEGIN TRANSACTION;  
INSERT INTO t2 VALUES (4);  
INSERT INTO t2 VALUES (5);  
INSERT INTO t2 VALUES (6);  
COMMIT TRANSACTION;  
GO 

select * from t2


--7 Funciones para manejo de Errores
--COMANDO
create procedure dbo.usp_InsertarProductoPorProcedure
(
@nombre varchar(300),
@cantidad decimal(10,2),
@idunidad int,
@preciounidad decimal(10,2)
)
as
begin
BEGIN TRY
	insert into dbo.tbProducto(nombre,cantidad,idUnidad,precioUnidad)
	select @nombre,@cantidad,@idunidad,@preciounidad
	--select 'Fideos',100,0,2.5,getdate(),null
END TRY
BEGIN CATCH
	SELECT
	ERROR_NUMBER() AS ERRNUM,
	ERROR_MESSAGE() AS ERRMSG,
	ERROR_SEVERITY() AS ERRSEV,
	ERROR_PROCEDURE() AS ERRPROC,
	ERROR_LINE() AS ERRLINE;
END CATCH
end

EXECUTE usp_InsertarProductoPorProcedure 'Atún',90,2,2.80

--8 Uso de THROW
THROW 52000,'Este registro no existe en la base de datos.', 1

BEGIN TRY
	insert into dbo.tbProducto 
	select 'Fideos',100,0,2.5,getdate(),null
END TRY
BEGIN CATCH
	PRINT 'Código dentro de CATCH está iniciando'
	PRINT 'Error: ' + CAST(ERROR_NUMBER() AS VARCHAR(255));
	THROW;
END CATCH
