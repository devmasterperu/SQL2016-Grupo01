  --1.Indique el total de cuentas con moneda SOL por distrito en el departamento de Lima.
  select count(a.id) as cantidad ,distrito,departamento
   from tbCliente a
   inner join [tbCuenta] b  on a.id=b.id
   inner join tbUbigeo c on a.idUbigeo=c.id 
   where b.moneda ='SOL' and departamento='Lima'
   group by distrito,departamento
   --2. Indique el acumulado de deuda total con moneda SOL por distrito en el departamento de Lima.
   select count(c.id) as total,sum(cu.deudaTotal)as DeudaTotal,cu.moneda,u.distrito,u.departamento
from tbUbigeo u inner join tbCliente c on u.id=c.idUbigeo
inner join tbCuenta cu on cu.idCliente=c.id
where cu.moneda='SOL'
group by cu.moneda,u.distrito,u.departamento
order by u.distrito
--3. Indique el total de cuentas por tipo de cliente y tipo de producto dentro del distrito de Checras. 
  select 
   count(*) as cantidad,
   c.descripcion as TipoCliente, 
   e.nombre as TipoProducto
   from tbCliente a
   inner join tbCuenta b  on a.id=b.id
   inner join tbTipoCliente c on a.tipoCliente=c.tipo
   inner join tbUbigeo d on a.idUbigeo=d.id 
   inner join tbProducto e on b.idProducto=e.id
   where d.distrito='Checras'
   group by 
   c.descripcion,
   e.nombre






   select * from tbProducto

   select * from tbCliente