--05.7 Uso de CTE
/*
SELECT
(SELECT count(1) from tbTipoDocumento) as TotTipoDocumento,
(SELECT count(1) from tbProducto) as TotProducto,
(SELECT count(1) from tbTipoCliente) as TotTipoCliente,
(SELECT count(1) from tbUbigeo) as TotUbigeo
*/

WITH cteTipoCambio
AS
(
	select conversionSOL from tbTipoCambio where CONVERT(VARCHAR(8),fecha,112)=CONVERT(VARCHAR(8),GETDATE(),112) 
)

select 
moneda,
deudaTotal,
deudaVencida,
deudaTotal*(select conversionSOL from cteTipoCambio) as deudaTotalSOL,
deudaVencida*(select conversionSOL from cteTipoCambio) as deudaVencidaSOL
from tbCuenta
where moneda='DOL'

--05.8

WITH cteUbigeoAgrupado
AS
(
	select cte.idUbigeo,AVG(cta.diasMoraNuevo) as promDiasMora
	from tbCuenta cta inner join tbCliente cte on cta.idCliente=cte.id
	group by cte.idUbigeo
)

select a.*,b.* from cteUbigeoAgrupado a inner join cteUbigeoAgrupado b on a.idUbigeo=b.idUbigeo

--05-09
--Acá declaro cteresumenTotales
WITH cteresumenTotales AS
(
	select ubi.id as idUbigeo,count(cli.id) as totClientes
	from tbCliente cli inner join tbUbigeo ubi on cli.idUbigeo=ubi.id
	group by ubi.id
),
resumenMaxDiasMora2 AS
(
	select cli.idUbigeo,max(cta.diasMoraNuevo) as maxDiasMora,res.totClientes
	from tbCliente cli 
	inner join tbCuenta cta on cta.idCliente=cli.id
	inner join cteresumenTotales res on cli.idUbigeo=res.idUbigeo--Acá utilizo cteresumenTotales
	group by cli.idUbigeo,res.totClientes
)
select * from resumenMaxDiasMora2
--select cteresumenTotales.idUbigeo,cteresumenTotales.totClientes,resumenMaxDiasMora.maxDiasMora
--from cteresumenTotales inner join resumenMaxDiasMora on cteresumenTotales.idUbigeo=cteresumenTotales.idUbigeo

--05.09 Creación de Vistas

USE [CobranzaDB]
GO

create view vReporteProductos
as
select 
reporteDeudaTotal.idProducto,
pdtoDet.nombre,
min(reporteDeudaTotal.deudaTotalSOL) as minDeudaTotalSOL,
max(reporteDeudaTotal.deudaTotalSOL) as maxDeudaTotalSOL
from
(
	select idProducto,
	case when cta.moneda='SOL' then cta.deudaTotal else 
	(select conversionDOL from tbTipoCambio where CONVERT(VARCHAR(8),fecha,112)=CONVERT(VARCHAR(8),GETDATE(),112))*cta.deudaTotal
	end as deudaTotalSOL
	from tbCuenta cta
	where  idProducto is not null
) reporteDeudaTotal inner join tbProducto pdtoDet on reporteDeudaTotal.idProducto=pdtoDet.id
group by reporteDeudaTotal.idProducto,pdtoDet.nombre

alter view vReporteProductos
as
select 
reporteDeudaTotal.idProducto,
pdtoDet.nombre,
min(reporteDeudaTotal.deudaTotalSOL) as minDeudaTotalSOL,
max(reporteDeudaTotal.deudaTotalSOL) as maxDeudaTotalSOL
from
(
	select idProducto,
	case when cta.moneda='SOL' then cta.deudaTotal else 
	(select conversionDOL from tbTipoCambio where CONVERT(VARCHAR(8),fecha,112)=CONVERT(VARCHAR(8),GETDATE(),112))*cta.deudaTotal
	end as deudaTotalSOL
	from tbCuenta cta
	where  idProducto is not null
) reporteDeudaTotal inner join tbProducto pdtoDet on reporteDeudaTotal.idProducto=pdtoDet.id
group by reporteDeudaTotal.idProducto,pdtoDet.nombre
having reporteDeudaTotal.idProducto=1

--05.10 Función de tabla en línea.
create function fReporteProductosXMoneda(@idProducto int,@moneda varchar(3)) returns table
as
return
select 
reporteDeudaTotal.idProducto,
pdtoDet.nombre,
min(reporteDeudaTotal.deudaTotalSOL) as minDeudaTotalSOL,
max(reporteDeudaTotal.deudaTotalSOL) as maxDeudaTotalSOL
from
(
	select idProducto,
	case when cta.moneda='SOL' then cta.deudaTotal else 
	(select conversionDOL from tbTipoCambio where CONVERT(VARCHAR(8),fecha,112)=CONVERT(VARCHAR(8),GETDATE(),112))*cta.deudaTotal
	end as deudaTotalSOL
	from tbCuenta cta
	where  idProducto is not null and cta.idProducto=@idProducto and cta.moneda=@moneda
) reporteDeudaTotal inner join tbProducto pdtoDet on reporteDeudaTotal.idProducto=pdtoDet.id
group by reporteDeudaTotal.idProducto,pdtoDet.nombre
having reporteDeudaTotal.idProducto=@idProducto

select * from fReporteProductosXMoneda(2,'SOL')

--05.11 Crear una función de tabla en línea que me devuelva los clientes registrados entre dos fechas
--'20171001'
--'20171015'
create function fFiltraClientesPorFecha(@fecInicio varchar(8),@fecFin varchar(8)) returns table
as
return
select tbCliente.id,tbCliente.nombres,tbCliente.apellidoPat from tbCliente
where convert(varchar(8),fecregistro,112)>=@fecInicio and convert(varchar(8),fecregistro,112)<=@fecFin

--05.12 Crear una función que retorne el tipo de cambio de SOL a DOL de cualquier fecha.

create function fMiTipoCambio(@fecha VARCHAR(8)) returns table
as
return
select conversionDOL from tbTipoCambio
where CONVERT(VARCHAR(8),fecha,112)=@fecha

select * from fMiTipoCambio('20171008')

--05.13 Creación de tablas temporales
		
		--Si existe la tabla temporal la elimina
		IF OBJECT_ID('tempdb..#TT_reporteDeudaVencidaPromHuacho') IS NOT NULL
		BEGIN
			DROP TABLE tempdb..#TT_reporteDeudaVencidaPromHuacho
		END
		--Crea una tabla temporal en función a resultado de consulta
		select AVG(deudaVencidaSOL) as deudaVencidaSOLPROM
		into tempdb..#TT_reporteDeudaVencidaPromHuacho 
		from
		(
			--Determinar las deudas vencidas en soles de HUACHO
			select ubi.id,
					case when cta.moneda='SOL' then cta.deudaVencida else 
					(select conversionSOL from tbTipoCambio where CONVERT(VARCHAR(8),fecha,112)=CONVERT(VARCHAR(8),GETDATE(),112))*cta.deudaVencida
					end as deudaVencidaSOL
			from tbCuenta cta 
			inner join tbCliente cte on cta.idCliente=cte.id
			inner join tbUbigeo  ubi on cte.idUbigeo=ubi.id
			where  UPPER(ubi.distrito)='HUACHO'
		) reporteDeudaVencidaPromHuacho
		group by reporteDeudaVencidaPromHuacho.id

		--Uso de tabla
		select *,(select deudaVencidaSOLPROM from tempdb..#TT_reporteDeudaVencidaPromHuacho) as PromHuacho from tbCuenta cta
		where 
		case when cta.moneda='SOL' then cta.deudaVencida 
		else (select conversionSOL from tbTipoCambio where CONVERT(VARCHAR(8),fecha,112)=CONVERT(VARCHAR(8),GETDATE(),112))*cta.deudaVencida
		 end>(select deudaVencidaSOLPROM from tempdb..#TT_reporteDeudaVencidaPromHuacho)
		
		select deudaVencidaSOLPROM from tempdb..#TT_reporteDeudaVencidaPromHuacho

	    --Si existe la tabla temporal la elimina
		IF OBJECT_ID('tempdb..#TT_reporteDeudaVencidaPromHuacho') IS NOT NULL
		BEGIN
			DROP TABLE tempdb..#TT_reporteDeudaVencidaPromHuacho
		END

