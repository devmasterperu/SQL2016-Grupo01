--Sesion 07
--07.01 Uso de FOR XML RAW
select pdto.id,pdto.nombre,pdto.cantidad,unidad.descripcion as unidad
from   tbProducto pdto 
join   tbUnidad unidad on pdto.idUnidad=unidad.id
FOR XML RAW('producto'),--definir nombre de elemento
ELEMENTS--mostrar resultado centrado en elementos
--07.02 Uso de FOR XML AUTO
select ventadet.idCompra as idVenta,
       pdto.id as idProducto,
       pdto.nombre,
	   pdto.cantidad,
	   unidad.descripcion as unidad
from   tbVentaDetalle ventadet
join     tbProducto pdto 
on       ventadet.idProducto=pdto.id
join     tbUnidad unidad
on       pdto.idUnidad=unidad.id
FOR XML AUTO,ROOT('ventasDetalles')--Especificamos elemento raiz.

select unidad.descripcion as unidad,
       ventadet.idCompra as idVenta,
       pdto.id as idProducto,
       pdto.nombre,
	   pdto.cantidad
from   tbVentaDetalle ventadet
join     tbProducto pdto 
on       ventadet.idProducto=pdto.id
join     tbUnidad unidad
on       pdto.idUnidad=unidad.id
order by unidad.descripcion--Especificamos ORDER BY para agrupamiento
FOR XML AUTO,ROOT('ventasDetalles')--Especificamos elemento raiz.
--07.03 FOR XML PATH
select ventadet.idCompra as "@idVenta",--Lo visualizo como atributo
       ventadet.fecRegistro as "fecRegistro",
       unidad.descripcion as unidad,
       pdto.id as "producto/@id",
       pdto.nombre as "producto/nombre",
       pdto.cantidad as "producto/cantidad"
from   tbVentaDetalle ventadet
join     tbProducto pdto 
on       ventadet.idProducto=pdto.id
join     tbUnidad unidad
on       pdto.idUnidad=unidad.id
FOR XML PATH('venta'),ROOT('ventas')
--07.04 USO DE OPENXML centrado a atributo
--Documento XML.  
DECLARE @idoc int, @xml varchar(4000);  
SET @xml= '<?xml version="1.0" encoding="UTF-8"?>
<productos>
    <producto nombre="Arroz" cantidad="100" precioUnidad="2">
        <unidad id="1" descripcion="kilogramo"></unidad>
    </producto>
    <producto nombre="Aceite" cantidad="50" precioUnidad="1.8">
        <unidad id="4" descripcion="litro"></unidad>
    </producto>
    <producto nombre="Pasta dental" cantidad="12" precioUnidad="2.5">
        <unidad id="3" descripcion="unidad"></unidad>
    </producto>
    <producto nombre="Desodorante" cantidad="30" precioUnidad="8">
        <unidad id="3" descripcion="unidad"></unidad>
    </producto>
</productos>';  

--Crear una representación interna del Documento XML.  
EXEC sp_xml_preparedocument @idoc OUTPUT, @xml; 

print @idoc
--EXEC sys.sp_xml_removedocument @idoc; 
--Lea desde Documento XML.  
/*
Esto es un comentario
*/
--SELECT    *  
--FROM       OPENXML (@idoc, '/productos/producto/unidad',1)--Obtención en base a atributos 
--           WITH (nombre  varchar(300) '../@nombre',--Atributo nombre del padre de Unidad
--                 cantidad decimal(10,2) '../@cantidad',--Atributo cantidad del padre de Unidad
--                 idUnidad int '@id',--Atributo id de unidad.
--                 precioUnidad decimal(10,2) '../@precioUnidad')--Atributo precioUnidad
--				 --del padre de Unidad.

SELECT    *  
FROM       OPENXML (@idoc, '/productos/producto/unidad',1)--Obtención en base a atributos 
           WITH (nombre  varchar(300) '../nombre',--Atributo nombre del padre de Unidad
                 cantidad decimal(10,2) '../cantidad',--Atributo cantidad del padre de Unidad
                 idUnidad int 'id',--Atributo id de unidad.
                 precioUnidad decimal(10,2) '../precioUnidad')--Atributo precioUnidad
				 --del padre de Unidad.
--07.05 USO DE OPENXML centrado a elementos
--Documento XML.  
DECLARE @idoc2 int, @doc varchar(1000);  
SET @doc= '<?xml version="1.0" encoding="UTF-8"?>
<productos>
<producto>
    <nombre>Arroz</nombre>
    <cantidad>100</cantidad>
    <unidad>
        <id>1</id>
        <descripcion>kilogramo</descripcion>
    </unidad>
    <precioUnidad>2</precioUnidad>
</producto>
<producto>
    <nombre>Aceite</nombre>
    <cantidad>50</cantidad>
   <unidad>
        <id>4</id>
        <descripcion>litro</descripcion>
    </unidad>
    <precioUnidad>1.8</precioUnidad>
</producto>
<producto>
    <nombre>Pasta dental</nombre>
    <cantidad>12</cantidad>
    <unidad>
        <id>3</id>
        <descripcion>unidad</descripcion>
    </unidad>
    <precioUnidad>2.5</precioUnidad>
</producto>
<producto>
    <nombre>Desodorante</nombre>
    <cantidad>30</cantidad>
    <unidad>
        <id>3</id>
        <descripcion>unidad</descripcion>
    </unidad>
    <precioUnidad>8</precioUnidad>
</producto>
</productos>';  

--Crear una representación interna del Documento XML.  
EXEC sp_xml_preparedocument @idoc2 OUTPUT, @doc; 
--EXEC sys.sp_xml_removedocument @idoc; 
--Lea desde Documento XML.  
SELECT    *  
FROM       OPENXML (@idoc2, '/productos/producto/unidad',2) --Leer XML centrado en elementos
           WITH (nombre  varchar(300) '../nombre',--Del padre de unidad obtener el elemento hijo "nombre"
                 cantidad decimal(10,2) '../cantidad',--Del padre de unidad obtener el elemento hijo "cantidad"
                 idUnidad int 'id',--Obtener el valor id de unidad
                 precioUnidad decimal(10,2) '../precioUnidad');--Del padre de unidad obtener el elemento hijo "precioUnidad"
--07.06 Creación de procedimiento almacenado
--SP para inserción en base de datos
select * from tbTipoDocumento

--CREATE PROCEDURE usp_InsertarTipoDocumento
ALTER PROCEDURE usp_InsertarTipoDocumento
--Parametros de entrada
(
@tipoSunat varchar(2),
@descLarga varchar(30),
@descCorta varchar(20)
)
--Cuerpo de SP
AS
BEGIN
	INSERT INTO dbo.tbTipoDocumento(tipoSunat,descLarga,descCorta)
	--SELECT @tipoSunat,@descLarga,@descCorta
	VALUES (@tipoSunat,@descLarga,@descCorta)
END
--Ejecucion de SP
--@tipoSunat varchar(2),
--@descLarga varchar(30),
--@descCorta varchar(20)
EXECUTE usp_InsertarTipoDocumento '08','PASAPORTE ELECTRONICO','PAS. ELECTRON.'
EXEC usp_InsertarTipoDocumento @tipoSunat='09',@descLarga='CARNET COMUNIDAD ANDINA',@descCorta ='CAN'

--07.07 Procedimiento almacenado con parámetros y mensaje
create procedure usp_InsertarProducto
(
@nombre varchar(300),
@cantidad decimal(10, 2),
--@idUnidad int,
@descripcionUnidad varchar(10),
@precioUnidad decimal(10,2)
)
as
begin
--Obtención de id de Unidad de medida
declare @idUnidad int
set @idUnidad=(select id from tbUnidad where descripcion=@descripcionUnidad)

IF @idUnidad IS NULL--No existe unidad de medida
BEGIN
	PRINT 'Unidad de medida no existente'
END
ELSE--Si existe unidad de medida
BEGIN
    --Registro de producto
	insert into dbo.tbProducto(nombre,cantidad,idUnidad,precioUnidad)
	values(@nombre,@cantidad,@idUnidad,@precioUnidad)
	PRINT 'Producto ingresado a las '+CAST(GETDATE() AS VARCHAR(20))
END
end
--Ejecucion de SP
--No se registró producto
EXECUTE usp_InsertarProducto @nombre='Galletas',@cantidad=100,@descripcionUnidad='unid.',
@precioUnidad=0.50
--Si se registró producto
EXECUTE usp_InsertarProducto @nombre='Galletas',@cantidad=100,@descripcionUnidad='unidad',
@precioUnidad=0.50
--07.08 Procedimiento almacenado con parámetros y mensaje
ALTER PROCEDURE usp_ActualizarPersona
(
@tipodoc int,
@numdoc varchar(15),
@nombres varchar(100),
@apellidopat varchar(100),
@apellidomat varchar(100)
)
as
begin
--Obtenemos id de persona
declare @id int
set @id=(select id from tbPersona where idTipoDoc=@tipodoc and numDoc=@numdoc)
--Validamos id de persona
	IF @id IS NOT NULL--Id si existe
	BEGIN
		 UPDATE dbo.tbPersona
		 SET    nombres=@nombres,
				apellidoPaterno=@apellidopat,
				apellidoMaterno=@apellidomat
		 WHERE  id=@id
	END
	ELSE
	BEGIN
		PRINT 'NO existe la persona a modificar'

	END
END
--Ejecución y validación de SP (No actualiza)
EXECUTE usp_ActualizarPersona @tipodoc=1,
@numdoc='46173386',@nombres='ROSITA',@apellidopat='GONZALES',
@apellidomat='MENESES'
--Ejecución y validación de SP (Si actualiza)
EXECUTE usp_ActualizarPersona @tipodoc=2,
@numdoc='46173386',@nombres='ROSITA',@apellidopat='GONZALES',
@apellidomat='MENESES'

--07.09 Creación de un procedure para eliminar
CREATE PROCEDURE usp_EliminarEmpresa
(
@ruc varchar(20) 
)
as
begin 
 declare @nombre varchar(30)
 set @nombre=(SELECT nombre from tb_empresas where ruc=@ruc)
 
 IF @nombre IS NOT NULL
 BEGIN
	DELETE FROM tb_empresas
    where ruc=@ruc

	PRINT 'Empresa '+@nombre+' eliminada'
 END
 ELSE
 BEGIN
	PRINT 'Empresa no existe'
 END
end
--Ejecución de SP
EXECUTE usp_EliminarEmpresa '1111111110'--No borra
EXECUTE usp_EliminarEmpresa '1111111112'--Si borra

--07.10 Reporte de venta
alter procedure usp_obtenerProductoMayorMontoVta
as
begin
    --Obtener datos generales
	declare @nomEmpresa varchar(30)
	set @nomEmpresa=(select nombre from tb_empresas where ruc='1111111111')
	print @nomEmpresa

	declare @fechora varchar(40)
	set @fechora='Reporte al '+CONVERT(VARCHAR(10),getdate(),103)

	--Obtener el producto con mayor monto de ventas
	declare @idproducto int
	declare @nomProducto varchar(300)
	declare @totalDetalle DECIMAL(10,2)

	select TOP 1 @idproducto=tbProducto.id,
	             @nomProducto=tbProducto.nombre,
	             @totalDetalle=SUM(totalDetalle)
	from tbVentaDetalle 
	join tbProducto on tbVentaDetalle.idProducto=tbProducto.id
	group by tbProducto.id,tbProducto.nombre
	order by SUM(totalDetalle) desc

	--SELECT  @idproducto,@nomProducto,@totalDetalle
	--Obtengo datos de ventas
	declare @fecprimeraventa varchar(10)
	declare @fecultimaventa varchar(10)

	select @fecprimeraventa= CONVERT(VARCHAR(10),min(fecRegistro),103),
	       @fecultimaventa=CONVERT(VARCHAR(10),max(fecRegistro),103)
    from   tbVentaDetalle
	where idProducto=@idproducto

	SELECT @nomEmpresa as NombreEmpresa,
		   @fechora as 'Fecha y Hora actual',
		   @nomProducto as 'Producto + vendido',
		   @totalDetalle as 'Monto total venta',
		   @fecprimeraventa as 'Fecha primera venta',
	       @fecultimaventa as 'Fecha última venta'
end

execute usp_obtenerProductoMayorMontoVta

--07.10 Reporte de ventas por periodo
alter procedure usp_ReportePorPeriodo
(
@fecinicio varchar(8),--20171105
@fecfin varchar(8)
)
as 
begin
	--Datos de la empresa

	--Cabecera de búsqueda
	declare @cabeceraBusqueda varchar(50)
	set @cabeceraBusqueda='Reporte del '+@fecinicio+' al '+@fecfin

	select @cabeceraBusqueda

	--Venta|Monto Total|Vendedor|Fecha Venta

	select 'VENTA'+CAST(vta.id as VARCHAR(10)) as Venta,
	        vta.total as [Monto Total],
			pers.nombres+' '+pers.apellidoPaterno as Vendedor,
	       CONVERT(varchar(8),vta.fecRegistro,103) as [Fecha Venta]
	from tbVenta vta
	join tbVendedor vend on vta.idVendedor=vend.id
	join tbPersona  pers on pers.id=vend.idPersona
	where convert(varchar(8),vta.fecRegistro,112)>=@fecinicio
	and   convert(varchar(8),vta.fecRegistro,112)<=@fecfin
end

usp_ReportePorPeriodo '20171001','20171105'
--07.11 Reporte del vendedor estrella
create procedure usp_ReporteVendedorEstrella
as
begin
	--Determinar el vendedor estrella
	--VENDEDOR ESTRELLA: Nombre del Vendedor
	--MONTO VENDIDO (SOLES): Monto en soles
	--MONTO VENDIDO (DOLARES): Monto en dólares
	 declare @idVendedor int
	 declare @mtoVentaSOL decimal(10,2)
	 declare @mtoVentaDOL decimal(10,2)
	 declare @tipoVambio decimal(10,4)
	 set @tipoVambio=3.3

	 select TOP 1 @idVendedor=idVendedor,@mtoVentaSOL=sum(total),
	 @mtoVentaDOL=sum(total)/@tipoVambio
	 from tbVenta
	 group by idVendedor
	 order by sum(total) desc

	 select @idVendedor as 'vendedor estrella',@mtoVentaSOL as 'monto total sol',@mtoVentaDOL as 'monto total dol'
	--Mostrar sus ventas relacionadas
	select ROW_NUMBER() OVER(PARTITION BY idVendedor ORDER BY total desc),'VEN'+CAST(id as VARCHAR(10)),total,fecRegistro from tbVenta
	where idVendedor=@idVendedor
	order by total desc
end

execute usp_ReporteVendedorEstrella

--07.12 Reporte por id de venta
alter procedure usp_ReportePorIdVenta
(
@idVenta int
)
as
begin
	if OBJECT_ID('tempdb..#reporte') is not null
	begin
		drop table tempdb..#reporte
	end

	select tbPersona.nombres+' '+tbPersona.apellidoPaterno as comprador,
	tbPersona.direccion,
	tbVentaDetalle.cantidad,
	tbProducto.nombre,
	tbVentaDetalle.precioUnidad,
	tbVentaDetalle.totalDetalle
	into tempdb..#reporte
	from tbVenta venta
	join tbComprador on venta.idComprador=tbComprador.id
	join tbPersona   on tbComprador.idPersona=tbPersona.id
	join tbVentaDetalle on tbVentaDetalle.idCompra=venta.id
	join tbProducto on tbVentaDetalle.idProducto=tbProducto.id
	where venta.id=@idVenta

	select * from tempdb..#reporte
	--Calcular subtotal,igv,total
	declare @subtotal decimal(10,2)
	declare @igv decimal(10,2)
	declare @total decimal(10,2)
	set @subtotal=(SELECT SUM(totalDetalle) FROM tempdb..#reporte)
	set @igv=(SELECT SUM(totalDetalle) FROM tempdb..#reporte)*0.18
	set @total=@subtotal+@igv
	
	select @subtotal as subtotal,@igv as igv,@total as total
end

execute usp_ReportePorIdVenta 4
select * from tbVentaDetalle
select * from tbProducto