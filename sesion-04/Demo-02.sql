--04.11 

--Obtener por cada cuenta el diferencial entre el días mora máximo y días mora de cada cuenta
--******Forma no optima******
--Sacar el máximo días mora de todos.
select MAX(diasMoraNuevo) from tbCuenta
--Colocar en duro el valor del máximo
select numCuenta,
diasMoraNuevo,
102 as MaximoDiasMora,--Duro
102-diasMoraNuevo as Diferencia
from tbCuenta
--******Forma optima*******
select numCuenta,
diasMoraNuevo,
(select MAX(diasMoraNuevo) from tbCuenta) as MaximoDiasMora,--Duro
(select MAX(diasMoraNuevo) from tbCuenta)-diasMoraNuevo as Diferencia
from tbCuenta

--04.12 Obtener la clasificación de cada cuenta en función al diferencial de días mora obtenido en el punto 1.
--Considere cuadro de clasificación.
--A 1 90
--B 91 120
--C 121
select numCuenta,diasMoraNuevo,
(select MAX(diasMoraNuevo) from tbCuenta) as MaximoDiasMora,--Duro
(select MAX(diasMoraNuevo) from tbCuenta)-diasMoraNuevo as Diferencial,
--Logica del A
CASE WHEN (select MAX(diasMoraNuevo) from tbCuenta)-diasMoraNuevo>=1 and
	      (select MAX(diasMoraNuevo) from tbCuenta)-diasMoraNuevo<=90 
     THEN 'A'
ELSE 
	CASE WHEN (select MAX(diasMoraNuevo) from tbCuenta)-diasMoraNuevo>=91 and
	      (select MAX(diasMoraNuevo) from tbCuenta)-diasMoraNuevo<=120 
     THEN 'B'--Logica del B
	 ELSE
	    CASE WHEN (select MAX(diasMoraNuevo) from tbCuenta)-diasMoraNuevo>=121
		THEN
			'C'--Logica del C
		ELSE
		    '-'--Logica de otros.
		END
	 END
 END 
 as Clasificacion
from tbCuenta

--04.13 Obtener los montos de deuda vencida y deuda total solarizados. Considere el tipo de cambio al día de hoy.
--Crear la tabla tipo de cambio
DROP TABLE tbTipoCambio
CREATE TABLE tbTipoCambio
(
id int identity(1,1) primary key,
--codmoneda varchar(4) not null,
fecha datetime not null,
conversionSOL numeric(18,3) not null,
conversionDOL numeric(18,3) not null,
fecregistro datetime default getdate(),
fecactualiza datetime,
usuarioCreador varchar(8) not null
)
--Cargar la tabla tipo de cambio
INSERT INTO tbTipoCambio
SELECT GETDATE(),3.269,0.306,GETDATE(),NULL,'GMV'
--Valido carga
select * from tbTipoCambio
--Obtener los montos de deuda vencida y deuda total solarizados. Considere el tipo de cambio al día de hoy.
select numcuenta,moneda,deudaVencida,deudaTotal,
--3.269*deudaVencida,
CASE WHEN moneda='DOL' 
THEN (select conversionSOL from tbTipoCambio where CONVERT(VARCHAR(8),fecha,112)=CONVERT(VARCHAR(8),GETDATE(),112))*deudaVencida
ELSE 
	deudaVencida
END as deudaVencidaSOL,
CASE WHEN moneda='DOL' 
THEN (select conversionSOL from tbTipoCambio where CONVERT(VARCHAR(8),fecha,112)=CONVERT(VARCHAR(8),GETDATE(),112))*deudaTotal
ELSE 
	deudaTotal
END as deudaTotalSOL
--*deudaTotal
from tbCuenta
--04.14 
/*Obtener solamente para las cuentas en soles los siguientes ratios:
Ratio de deuda total. En porcentaje indicar cuanto representa la deuda total de la cuenta respecto a la deuda total de todas las cuentas con moneda soles.
Ratio de deuda vencida. En porcentaje indicar cuanto representa la deuda vencida de la cuenta respecto a la deuda vencida de todas las cuentas con moneda soles.
*/
select numcuenta,moneda,deudaTotal,deudaVencida,
(select SUM(deudaVencida) from tbCuenta where moneda='SOL') as deudaVencidaAcum,
deudaVencida/(select SUM(deudaVencida) from tbCuenta where moneda='SOL')*100 as ratioDeudaVencidaSOL--,
--ratioDeudaTotalSOL
from tbCuenta
where moneda='SOL'
/*Obtener solamente para las cuentas en soles de Huacho los siguientes ratios:
Ratio de deuda total. En porcentaje indicar cuanto representa la deuda total de la cuenta respecto a la deuda total de todas las cuentas con moneda soles.
Ratio de deuda vencida. En porcentaje indicar cuanto representa la deuda vencida de la cuenta respecto a la deuda vencida de todas las cuentas con moneda soles.
*/
select numcuenta,moneda,deudaTotal,deudaVencida,

(
select SUM(deudaVencida) from tbCuenta micta
inner join tbCliente micte on micta.idCliente=micte.id
inner join tbUbigeo  miubi on micte.idUbigeo=miubi.id
where moneda='SOL' and miubi.distrito='Huacho'
) as deudaVencidaAcum,

deudaVencida/
(select SUM(deudaVencida) from tbCuenta micta
inner join tbCliente micte on micta.idCliente=micte.id
inner join tbUbigeo  miubi on micte.idUbigeo=miubi.id
where moneda='SOL' and miubi.distrito='Huacho')*100 
as ratioDeudaVencidaSOL
--ratioDeudaTotalSOL
from tbCuenta cta 
inner join tbCliente cte on cta.idCliente=cte.id
inner join tbUbigeo ubi on cte.idUbigeo=ubi.id
where moneda='SOL' and ubi.distrito='Huacho'

