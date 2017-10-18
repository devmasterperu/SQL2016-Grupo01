--PARTE 01
use CobranzaDB

--Liste los clientes cuyo primer nombre inicia con una vocal.

Select * from tbCliente 
where nombres LIKE '[aeiou]%'

--Liste los clientes cuyo primer nombre inicia con una consonante

Select * from tbCliente 
where nombres LIKE '[^aeiou]%' and nombres NOT LIKE '^%'

--Liste los clientes cuyo apellido materno tenga como segunda letra una “a” y como penúltima, la letra “r”.
Select * from tbCliente 
where apellidoMat LIKE '_a%r_'

--Liste los clientes cuyo apellido materno tenga como segunda letra una “a” y como penúltima, una letra diferente a “r”.
Select * from tbCliente 
where apellidoMat LIKE '_a%[^r]_'

--Liste los clientes cuyo apellido materno tenga como segunda letra una “a” y además contenga un sombrero seguido de una r
Select * from tbCliente 
where apellidoMat LIKE '_a%^[r]_'

--Liste los clientes cuyo apellido paterno contenga una vocal seguida de la letra n y seguida de una consonante.

Select apellidoPat,* from tbCliente 
where apellidoPat LIKE '%[aeiou]n[^aeiou]%'

Manrique
Muñante
Gonzales

/*PARTE 02
Demo de consultas a múltiples tablas
*/
--¿Quiénes son los clientes de nombre Rosa y registrados con carnet de extranjería?
select tab1.tipoDoc,tab2.descripcion,tab1.numDoc,tab1.nombres+' '+tab1.apellidoPat as nombapellidos 
from tbCliente tab1--tipoDoc
inner join tbTipoDocumento tab2 on tab1.tipoDoc=tab2.tipo --and tab1.nombres='Rosa'--tipo 
where tab1.nombres='Rosa' and tab2.descripcion='Carnet de extranjería'

--¿Cuál es la cantidad de clientes registrados en los distritos de Santa María y Huacho? Utilice una sola consulta.
--1.tbCliente join tbUbigeo
--2.Agrupar y usar count

select reporte.distrito,count(reporte.id) as totClientesXDistrito
from
(
select tab1.id,tab2.distrito from tbCliente tab1 inner join
tbUbigeo tab2 on tab1.idUbigeo=tab2.id and tab2.distrito in ('Santa María','Huacho','Huaura') 
) reporte
group by reporte.distrito

select reporte.distrito,count(reporte.id) as totClientesXDistrito
from
(
select tab1.id,tab2.distrito from tbCliente tab1 inner join
tbUbigeo tab2 on tab1.idUbigeo=tab2.id and (tab2.distrito='Santa María' or tab2.distrito='Huacho'  or tab2.distrito='Huaura') 
) reporte
group by reporte.distrito

--2.5 Mostrar cantidad de clientes registrados por distrito en el departamento de Lima.

select reporte.departamento,reporte.provincia,reporte.distrito,count(reporte.id) as totClientesXDistrito
from
(
select tab1.id,tab2.departamento,tab2.provincia,tab2.distrito from tbCliente tab1 inner join
tbUbigeo tab2 on tab1.idUbigeo=tab2.id and tab2.departamento='Lima' 
) reporte
group by reporte.departamento,reporte.provincia,reporte.distrito

--¿Cuál es la cantidad de clientes registrados por sexo en los distritos de Santa María y Huacho? 

select tab1.sexo,count(tab1.id) as totxSexo from tbCliente tab1 inner join
tbUbigeo tab2 on tab1.idUbigeo=tab2.id and tab2.distrito in ('Santa María','Huacho')
group by tab1.sexo

--¿Cuál es la cantidad de clientes registrados por sexo dentro de cada distrito en Santa María y Huacho? 
select tab1.sexo,tab2.distrito,count(tab1.id) as totxSexo from tbCliente tab1 inner join
tbUbigeo tab2 on tab1.idUbigeo=tab2.id and tab2.distrito in ('Santa María','Huacho')
group by tab1.sexo,tab2.distrito
order by tab1.sexo ASC,tab2.distrito DESC

--¿Cuál es la cantidad de clientes registrados por tipo de documento en los distritos de Huaura y Hualmay? Utilice una sola consulta.
select tab3.descripcion,count(tab1.id) as totXDoc from tbCliente tab1 
inner join tbUbigeo tab2 on tab1.idUbigeo=tab2.id 
inner join tbTipoDocumento tab3 on tab1.tipoDoc=tab3.tipo
where tab2.distrito in ('Huaura','Hualmay')
group by tab3.descripcion

--¿Cuál es la cantidad de clientes registrados por tipo de documento dentro de cada distritos en Huaura y Hualmay? Utilice una sola consulta.
select tab2.distrito,tab3.descripcion,count(tab1.id) as totXDoc from tbCliente tab1 
inner join tbUbigeo tab2 on tab1.idUbigeo=tab2.id 
inner join tbTipoDocumento tab3 on tab1.tipoDoc=tab3.tipo
where tab2.distrito in ('Huaura','Hualmay')
group by tab2.distrito,tab3.descripcion
order by tab2.distrito asc,tab3.descripcion asc

--¿Cuál es la cantidad de clientes registrados por tipo de documento,sexo dentro de cada distritos en Huaura y Hualmay? Utilice una sola consulta.
select tab2.distrito,tab3.descripcion,tab1.sexo,count(tab1.id) as totXDoc from tbCliente tab1 
inner join tbUbigeo tab2 on tab1.idUbigeo=tab2.id 
inner join tbTipoDocumento tab3 on tab1.tipoDoc=tab3.tipo
where tab2.distrito in ('Huaura','Hualmay')
group by tab2.distrito,tab3.descripcion,tab1.sexo
order by tab2.distrito asc,tab3.descripcion asc

--¿Cuál es la cantidad de clientes registrados por tipo de cliente,tipo de documento,sexo
--dentro de cada distritos en Huaura y Hualmay? Utilice una sola consulta.
select tab2.distrito,tab4.descripcion,tab3.descripcion,tab1.sexo,count(tab1.id) as totXDoc from tbCliente tab1 
inner join tbUbigeo tab2 on tab1.idUbigeo=tab2.id 
inner join tbTipoDocumento tab3 on tab1.tipoDoc=tab3.tipo
inner join tbTipoCliente   tab4 on tab1.tipoCliente=tab4.tipo
where tab2.distrito in ('Huaura','Hualmay')
group by tab2.distrito,tab4.descripcion,tab3.descripcion,tab1.sexo
order by tab2.distrito asc,tab4.descripcion asc,tab3.descripcion asc

select * from tbProducto

--select * from tbCliente


