--Sesion 06
--Ejemplo 06.01
select 'VENTA-'+CAST(venta.id AS VARCHAR(10)) as codVenta,
        vende.codVendedor,
        persona.nombres+' '+persona.apellidoPaterno+' '+
        persona.apellidoMaterno as vendedor,
        venta.idVendedor,
        venta.fecRegistro,
        ROW_NUMBER() OVER(PARTITION BY venta.idVendedor ORDER BY venta.fecRegistro ASC) AS FILA_ROW_NUMBER,
        RANK() OVER(PARTITION BY venta.idVendedor ORDER BY venta.fecRegistro ASC) AS FILA_RANK,
        DENSE_RANK() OVER(PARTITION BY venta.idVendedor ORDER BY venta.fecRegistro ASC) AS FILA_DENSE_RANK,
        NTILE(2) OVER(PARTITION BY venta.idVendedor ORDER BY venta.fecRegistro ASC) AS FILA_DENSE_NTILE
from   tbVenta venta 
inner join tbVendedor vende on venta.idVendedor=vende.id
inner join tbPersona  persona on vende.idPersona=persona.id
--order by   idVendedor,venta.fecRegistro ASC

--PARTITION BY venta.idVendedor--Resultados como los agrupo
--ORDER BY venta.fecRegistro ASC--Dentro de cada grupo como los ordeno

--Ejemplo 06.02
--Obtener por cada compra: la suma, el promedio, la cantidad, el mínimo y el máximo de totalDetalle.

SELECT ventaDet.idCompra, 
   ventaDet.cantidad,
   pdto.nombre,
   ventaDet.precioUnidad,
   ventaDet.totalDetalle,
   SUM(totalDetalle)   OVER(PARTITION BY idCompra) AS Total,  
   AVG(totalDetalle)   OVER(PARTITION BY idCompra) AS Avg, 
   COUNT(totalDetalle) OVER(PARTITION BY idCompra) AS Count, 
   MIN(totalDetalle)   OVER(PARTITION BY idCompra) AS Min,  
   MAX(totalDetalle)   OVER(PARTITION BY idCompra) AS Max  
FROM tbVentaDetalle ventaDet inner join
     tbProducto pdto on ventaDet.idProducto=pdto.id

--06.03 Uso de funciones OFFSET
--Uso de funciones OFFSET
select 
vende.codVendedor,
persona.nombres+' '+persona.apellidoPaterno+ ' '+ persona.apellidoMaterno as vendedor,
venta.idVendedor,
venta.total,
venta.fecRegistro,
LAG(venta.fecRegistro) OVER(PARTITION BY idVendedor ORDER BY venta.fecRegistro ASC) AS LAG,--Valor de registro anterior
LEAD(venta.fecRegistro) OVER(PARTITION BY idVendedor ORDER BY venta.fecRegistro ASC) AS LEAD,--Valor de registro posterior
FIRST_VALUE(venta.fecRegistro) OVER(PARTITION BY idVendedor ORDER BY venta.fecRegistro ASC) AS FIRST_VALUE,--Primer valor grupo
LAST_VALUE(venta.fecRegistro) OVER(PARTITION BY idVendedor ORDER BY venta.fecRegistro ASC) AS LAST_VALUE--Ultimo valor de grupo
from   tbVenta venta 
inner join tbVendedor vende on venta.idVendedor=vende.id
inner join tbPersona  persona on vende.idPersona=persona.id
order by venta.idVendedor,venta.fecRegistro ASC

--06.04 Operadores de Conjuntos

--Uso de UNION Y UNION ALL+CTE
WITH CTE_personas AS
(
select  persona.id,     
        persona.nombres,
        persona.apellidoPaterno,
        persona.apellidoMaterno,
		'Información de stma. de compras' as stma
from tbComprador compra 
inner join tbPersona persona on compra.idPersona=persona.id
UNION ALL
Select  --persona.id,
        0 as id,
        persona.nombres,
        persona.apellidoPaterno,
        persona.apellidoMaterno,
		'Otros sistemas' as stma
from tbVendedor venta 
inner join tbPersona persona on venta.idPersona=persona.id
UNION ALL
select 0 as id,
       'Gianfranco' as nombres,
	   'Manrique' as apellidoPaterno,
	   'Valentín' as apellidoMaterno,
	   'Otros sistemas' as stma
)
select * from CTE_personas
where stma='Otros sistemas'

--06.05 Uso de Intersect
--Uso de INTERSECT
Select persona.id,
       persona.nombres,
       persona.apellidoPaterno,
       persona.apellidoMaterno
from   tbComprador compra 
inner join tbPersona persona on compra.idPersona=persona.id
INTERSECT 
Select persona.id,
       persona.nombres,
       persona.apellidoPaterno,
       persona.apellidoMaterno
from   tbVendedor venta 
inner join tbPersona persona on venta.idPersona=persona.id

--06.05 Uso de Intersect
--Uso de EXCEPT
Select persona.id,
       persona.nombres,
       persona.apellidoPaterno,
       persona.apellidoMaterno
from   tbComprador compra 
inner join tbPersona persona on compra.idPersona=persona.id
go
Select persona.id,
       persona.nombres,
       persona.apellidoPaterno,
       persona.apellidoMaterno
from   tbVendedor venta 
inner join tbPersona persona on venta.idPersona=persona.id
go
Select persona.id,
       persona.nombres,
       persona.apellidoPaterno,
       persona.apellidoMaterno
from   tbComprador compra 
inner join tbPersona persona on compra.idPersona=persona.id
EXCEPT 
Select persona.id,
       persona.nombres,
       persona.apellidoPaterno,
       persona.apellidoMaterno
from   tbVendedor venta 
inner join tbPersona persona on venta.idPersona=persona.id
--Canbiando orden Res1 EXCEPT Res2 !=Res2 EXCEPT Res1
Select persona.id,
       persona.nombres,
       persona.apellidoPaterno,
       persona.apellidoMaterno
from   tbVendedor venta 
inner join tbPersona persona on venta.idPersona=persona.id
EXCEPT
Select persona.id,
       persona.nombres,
       persona.apellidoPaterno,
       persona.apellidoMaterno
from   tbComprador compra 
inner join tbPersona persona on compra.idPersona=persona.id

--06.06.Obtener en formato JSON los tipos de documento SUNAT
select id,tipoSunat,descLarga,descCorta 
from   tbTipoDocumento
FOR JSON AUTO,INCLUDE_NULL_VALUES

--06.07 Obtener en formato JSON, con JSON AUTO y con raíz Vendedores 
select 
vend.id ,
vend.codVendedor,
pers.nombres,
pers.apellidoPaterno,
pers.apellidoMaterno,
tipo.descCorta,
tipo.descLarga
from tbVendedor vend 
inner join tbPersona pers on vend.idPersona=pers.id
inner join tbTipoDocumento tipo on pers.idTipoDoc=tipo.id
FOR JSON AUTO,root('vendedores');

--06.08 Obtener en formato JSON, con JSON Path y sin corchetes datos del vendedor
select vend.id as [vendedor.Id],
--vend.codVendedor as [vendedor.CodVendedor],
'SIN VALOR' as [vendedor.persona.valores.CodVendedor],
--pers.nombres as [vendedor.persona.Nombres],
--pers.apellidoPaterno as [vendedor.persona.ApellidoPat],
--pers.apellidoMaterno as [vendedor.persona.ApellidoMat]
pers.nombres as [vendedor.Nombres],
pers.apellidoPaterno as [vendedor.ApellidoPat],
pers.apellidoMaterno as [vendedor.ApellidoMat]
from tbVendedor vend inner join 
tbPersona pers on vend.idPersona=pers.id
FOR JSON PATH,WITHOUT_ARRAY_WRAPPER

--06.09--Obtener en formato JSON, con JSON Path y con raíz Vendedores 
select vend.id as [vendedor.Id],vend.codVendedor as [vendedor.CodVendedor],
pers.nombres as [vendedor.persona.Nombres],
pers.apellidoPaterno as [vendedor.persona.ApellidoPat],
pers.apellidoMaterno as [vendedor.persona.ApellidoMat]
from tbVendedor vend inner join 
tbPersona pers on vend.idPersona=pers.id
FOR JSON PATH,root('vendedores'),WITHOUT_ARRAY_WRAPPER

--06.10--Convertir JSON a formato tabular
DECLARE @json NVARCHAR(4000) = N'
{
    "StringValue": "Gian",
    "IntValue": 45,
    "TrueValue": true,
    "FalseValue": false,
    "NullValue": null,
    "ArrayValue": ["a","b"],
    "ObjectValue": {
        "edad": "27"
    }
}'

select * from OPENJSON(@json)

--06.11 Uso de OPENJSON
declare @myjson varchar(8000)=N'{
    "empresa":"Dev Master Perú SAC",
    "ruc":"1111111111",
    "numTrabajadores":5,
    "cursos":[
        {
            "curso":"Base de Datos con SQL Server 2016",
            "docente":{
                "nombres":"Gianfranco",
                "apellidos":"Manrique",
                "direccion":"Urb.Los Cipreses M-24",
                "ubigeo":{
                    "departamento":"Lima",
                    "provincia":"Huaura",
                    "distrito":"Santa María",
                    "nombre":"Lima\/Huaura\/Santa María"
                }
            }
        },
        {
            "curso":"Modelamiento de Datos",
            "docente":{
                "nombres":"Gianfranco",
                "apellidos":"Manrique",
                "direccion":"Urb.Los Cipreses M-24",
                "ubigeo":{
                    "departamento":"Lima",
                    "provincia":"Huaura",
                    "distrito":"Santa María",
                    "nombre":"Lima\/Huaura\/Santa María"
                }
            }
        }
    ]
}'

select * from OPENJSON(@myjson)

--06.12 Uso de OPENJSON+path
declare @myjson varchar(8000)=N'{
    "empresa":"Dev Master Perú SAC",
    "ruc":"1111111111",
    "numTrabajadores":5,
    "cursos":[
        {
            "curso":"Base de Datos con SQL Server 2016",
            "docente":{
                "nombres":"Gianfranco",
                "apellidos":"Manrique",
                "direccion":"Urb.Los Cipreses M-24",
                "ubigeo":{
                    "departamento":"Lima",
                    "provincia":"Huaura",
                    "distrito":"Santa María",
                    "nombre":"Lima\/Huaura\/Santa María"
                }
            }
        },
        {
            "curso":"Modelamiento de Datos",
            "docente":{
                "nombres":"Gianfranco",
                "apellidos":"Manrique",
                "direccion":"Urb.Los Cipreses M-24",
                "ubigeo":{
                    "departamento":"Lima",
                    "provincia":"Huaura",
                    "distrito":"Santa María",
                    "nombre":"Lima\/Huaura\/Santa María"
                }
            }
        }
    ]
}'

--select * from OPENJSON(@myjson,'lax $.cursos[1].docente.ubigeo2')
select * from OPENJSON(@myjson,'strict $.cursos[1].docente.ubigeo2')

--06.13 Uso de JSON_VALUE
declare @myjson varchar(8000)=N'{
    "empresa":"Dev Master Perú SAC",
    "ruc":"1111111111",
    "numTrabajadores":5,
    "cursos":[
        {
            "curso":"Base de Datos con SQL Server 2016",
            "docente":{
                "nombres":"Gianfranco",
                "apellidos":"Manrique",
                "direccion":"Urb.Los Cipreses M-24",
                "ubigeo":{
                    "departamento":"Lima",
                    "provincia":"Huaura",
                    "distrito":"Santa María",
                    "nombre":"Lima\/Huaura\/Santa María"
                }
            }
        },
        {
            "curso":"Modelamiento de Datos",
            "docente":{
                "nombres":"Gianfranco",
                "apellidos":"Manrique",
                "direccion":"Urb.Los Cipreses M-24",
                "ubigeo":{
                    "departamento":"Lima",
                    "provincia":"Huaura",
                    "distrito":"Santa María",
                    "nombre":"Lima\/Huaura\/Santa María"
                }
            }
        }
    ]
}'

--select JSON_VALUE(@myjson,'$.cursos[1].docente.ubigeo') as ubigeo
select JSON_VALUE(@myjson,'$.cursos[1].docente.ubigeo.departamento') as ubigeo

--06.14 
--Uso de JSON_VALUE
DECLARE @jsonInfo NVARCHAR(MAX)

SET @jsonInfo=N'{  
     "informacion":{    
     "nombres":"Gianfranco",
     "apellidos":"Manrique Valentín",
     "direccion":"Urb. Los Cipreses M-24",
       "ubigeo":{    
         "departamento":"Lima",  
         "provincia":"Huaura",  
         "distrito":"Huacho"  
       },  
     "cursos":["Base de Datos", "Modelamiento de Datos"]  
    }
 }'  

select  JSON_VALUE(@jsonInfo,'$.informacion.nombres') as nombres,
        JSON_VALUE(@jsonInfo,'$.informacion.apellidos') as apellidos,
        JSON_VALUE(@jsonInfo,'$.informacion.direccion') as direccion,
        JSON_VALUE(@jsonInfo,'$.informacion.ubigeo.departamento') as departamento,
		JSON_VALUE(@jsonInfo,'$.informacion.cursos') as cursos
--06.15 

DECLARE @jsonInfo NVARCHAR(MAX)

SET @jsonInfo=N'{  
     "informacion":{    
     "nombres":"Gianfranco",
     "apellidos":"Manrique Valentín",
     "direccion":"Urb. Los Cipreses M-24",
       "ubigeo":{    
         "departamento":"Lima",  
         "provincia":"Huaura",  
         "distrito":"Huacho"  
       },  
     "cursos":["Base de Datos", "Modelamiento de Datos"]  
    }
 }'  

 select JSON_QUERY(@jsonInfo,'$.informacion') as informacion,
        JSON_QUERY(@jsonInfo,'$.informacion.ubigeo') as ubigeo,
        JSON_QUERY(@jsonInfo,'$.informacion.cursos') as cursos,
		JSON_QUERY(@jsonInfo,'$.informacion.nombres') as nombres
--06.16
--Consumir JSON
declare @myjson varchar(8000)=N'
 [
        {
            "empresa": 
            {
                "nombre":"Dev Master Perú SAC",
                "ruc": "1111111111",
                "numTrabajadores": 5
            },
            "sedeprincipal":{
                "departamento":"Lima",
                "provincia":"Huaura",
                "distrito":"Santa María"
            },
            "cursos": [
                {
                    "curso": "Base de Datos con SQL Server 2016",
                    "docente": {
                        "nombres": "Gianfranco",
                        "apellidos": "Manrique",
                        "direccion": "Urb.Los Cipreses M-24",
                        "ubigeo": {
                            "departamento": "Lima",
                            "provincia": "Huaura",
                            "distrito": "Santa María",
                            "nombre": "Lima\/Huaura\/Santa María"
                        }
                    }
                },
                {
                    "curso": "Modelamiento de Datos",
                    "docente": {
                        "nombres": "Gianfranco",
                        "apellidos": "Manrique",
                        "direccion": "Urb.Los Cipreses M-24",
                        "ubigeo": {
                            "departamento": "Lima",
                            "provincia": "Huaura",
                            "distrito": "Santa María",
                            "nombre": "Lima\/Huaura\/Santa María"
                        }
                    }
                }
            ]
        },
        {
            "empresa": {
                "nombre":"Cibertec",
                "ruc": "1111111112",
                "numTrabajadores": 1000
            },
            "sedeprincipal":{
                "departamento":"Lima",
                "provincia":"Lima",
                "distrito":"Miraflores"
            },
            "cursos": [
                {
                    "curso": "Base de Datos con SQL Server 2016",
                    "docente": {
                        "nombres": "Juan",
                        "apellidos": "Lopez",
                        "direccion": "NE",
                        "ubigeo": {
                            "departamento": "-",
                            "provincia": "-",
                            "distrito": "-",
                            "nombre": "-\/-\/-"
                        }
                    }
                },
                {
                    "curso": "Modelamiento de Datos",
                    "docente": {
                        "nombres": "Maria",
                        "apellidos": "Gonzales",
                        "direccion": "Urb. Los Jardines",
                        "ubigeo": {
                            "departamento": "Lima",
                            "provincia": "Lima",
                            "distrito": "San Martín de Porres",
                            "nombre": "Lima\/Lima\/SMP"
                        }
                    }
                }
            ]
        }
    ]
'
--Transferirlo a tabla luego de formatearlo con campos
select * 
into tb_empresas
from OPENJSON(@myjson) WITH
(
ruc    varchar(20) '$.empresa.ruc',
nombre varchar(30) '$.empresa.nombre',
sedePrinDpto varchar(30) '$.sedeprincipal.departamento',
sedePrinProv varchar(30) '$.sedeprincipal.provincia',
sedePrinDto  varchar(30) '$.sedeprincipal.distrito'
)
--Crear procedure en base a la tabla alimentada con JSON
create procedure sp_FiltrarEmpresa(@dpto varchar(30),@prov varchar(30),@dto varchar(30))
as
begin
select * from tb_empresas
where sedePrinDpto=@dpto and sedePrinProv=@prov and sedePrinDto=@dto
end
--Ejecutar procedure y obtener información cargada a través de JSON
sp_FiltrarEmpresa 'Lima','Lima','Miraflores'
