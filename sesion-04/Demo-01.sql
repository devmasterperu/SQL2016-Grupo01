--SESION 04
--04.01 Diferencias entre LEN y DATALENGHT
--LEN ( string_expression ) 
select * from tbCliente
update cliente
set nombres='Ana    '
from tbCliente cliente
where id=3

select LEN(nombres) from tbCliente
where id=3
--DATALENGTH ( expression ) 
select DATALENGTH(nombres) from tbCliente
where id=3
--04.02 Uso de ChardIndex
--CHARINDEX ( expressionToFind, expressionToSearch ) 
select id,apellidoMat,CHARINDEX('alce',apellidoMat) as Posicion from tbCliente
--where CHARINDEX('alce',apellidoMat)<>0
where CHARINDEX('alce',apellidoMat)<>0
--04.03 Uso de REPLACE
--REPLACE ( string_expression , string_pattern , string_replacement ) 
select id,apellidoMat,REPLACE(apellidoMat,'alce','NNN') as NuevoApellido 
from tbCliente
where CHARINDEX('alce',apellidoMat)<>0
--Uso de REPLACE en el campo nombres
select id,nombres,apellidoMat,REPLACE(nombres,'Rodrigo','-') as NuevoNombre
from tbCliente
where nombres='Rodrigo'
--04.04 Uso de UPPER y LOWER
--UPPER ( character_expression ) LOWER ( character_expression ) 
select id,nombres,apellidoMat,UPPER(apellidoMat) as apellidoMayusc
from tbCliente
where nombres='Rodrigo'
--Pasar a mayusculas los nombres de todos los clientes.
UPDATE cliente
SET    nombres=UPPER(nombres)
FROM   tbCliente cliente
--Pasar a minusculas los nombres de todos los clientes.
UPDATE cliente
SET    nombres=LOWER(nombres)
FROM   tbCliente cliente
--04.05 Uso de fecha y hora
SELECT 
GETDATE(),--fecha y hora actual
CURRENT_TIMESTAMP,--fecha y hora actual
SYSDATETIME(),--fecha y hora actual + precisa
GETUTCDATE(),--fecha y hora meridiano
SYSUTCDATETIME(),--fecha y hora meridiano + precisa
SYSDATETIMEOFFSET()
--04.06 Uso de DATEADD
--DATEADD(datepart, interval, date)
SELECT id,fecRegistro,
--DATEADD(YYYY,1,fecRegistro) as NuevoAño,
--DATEADD(YYYY,-1,fecRegistro) as ViejoAño,
--DATEADD(MM,1,fecRegistro) as NuevoMes,
--DATEADD(MM,-1,fecRegistro) as ViejoMes,
--DATEADD(DD,1,fecRegistro) as NuevoDia,
--DATEADD(DD,-1,fecRegistro) as ViejoDia,
DATEADD(HH,2,fecRegistro) as NuevaHora,
DATEADD(HH,-2,fecRegistro) as ViejaHora,
DATEADD(mi,10,fecRegistro) as NuevoMinuto,
DATEADD(mi,-10,fecRegistro) as ViejoMinuto,
DATEADD(ss,10,fecRegistro) as NuevoSegundo,
DATEADD(ss,-10,fecRegistro) as ViejoSegundo
FROM tbCliente

--04.07 Uso de EOMONTH(start_date, interval)
SELECT EOMONTH(GETDATE(),1)--Fin del siguiente mes
SELECT EOMONTH(GETDATE(),-1)--Fin del mes anterior
SELECT EOMONTH(GETDATE(),8)--Fin de mes dentro de 8 meses
SELECT EOMONTH(GETDATE(),-8)--Fin del mes hace 8 meses

--Obtener el fin de mes del siguiente mes de su fecha de registro de cada cliente.
SELECT id,fecRegistro,EOMONTH(fecRegistro,1) from tbCliente

--04.08 Uso de DATEDIFF
--DATEDIFF(datepart, start_date, end_date)
--Obtener el número de días transcurridos desde la fecha de registro de cada cliente
SELECT id,fecRegistro,getdate() as fecHoy,DATEDIFF(DD,fecRegistro,GETDATE()) as diasStma from tbCliente
--Obtener los clientes con más de 15 dias transcurridos desde su fecha de registro.
SELECT id,fecRegistro,getdate() as fecHoy,DATEDIFF(DD,fecRegistro,GETDATE()) as diasStma from tbCliente
WHERE DATEDIFF(DD,fecRegistro,GETDATE())>15
order by DATEDIFF(DD,fecRegistro,GETDATE()) DESC
--Obtener el total de clientes con entre 15 y 17 dias transcurridos desde su fecha de registro.
SELECT count(id) from tbCliente
--WHERE DATEDIFF(DD,fecRegistro,GETDATE())>15
WHERE DATEDIFF(DD,fecRegistro,GETDATE()) BETWEEN 15 and 17
--Obtener el máximo de días transcurridos desde su 
--fecha de registro, sólo para los clientes de Huacho.