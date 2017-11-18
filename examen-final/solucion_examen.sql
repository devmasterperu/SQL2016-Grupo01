--1 Completar el cuadro resumen
--#NUM. PELICULAS
select count(id) as nroPeliculas from tbPelicula
--#NUM. PELICULAS EXTRANJERAS
select COUNT(pa.id) as nroPeliculasExtranjeras from tbPais pa
inner join tbPelicula pe on pa.id=pe.idpais
 where pa.nombre<>'PERU'
--#NUM. PELICULAS NACIONALES
select COUNT(pa.id) as nroPeliculasNacionales from tbPais pa
inner join tbPelicula pe on pa.id=pe.idpais
 where pa.nombre='PERU'	
--PELICULA + ANTIGUA (AÑO)
select min(año) as añoMasAnt from tbPelicula
--PELICULA + NUEVA (AÑO)
select max(año) as añoMasNuevo from tbPelicula	
--PELICULA + DURACION
select max(duracion)as mayorDuracion from tbPelicula
--2 Listar aquellas películas que contengan TAN o REY dentro de su nombre y presentarlos en base al siguiente cuadro 
select pel.nombre as NOMBRE_PELICULA,
	   pel.año as AÑO,
	   cat.nombre as NOMBRE_CATEGORIA,
       case when pel.nombre  like '%TAN%' then 'Contiene TAN' 
	   else 'Contiene REY' end as RESULTADO
from   tbPelicula pel inner join
	   tbCategoriaPelicula catpel on pel.id=catpel.idpelicula inner join
	   tbCategoria cat on catpel.idcategoria=cat.id
where pel.nombre like '%TAN%' or pel.nombre like '%REY%'
order by pel.nombre
--3 Mostrar para “ESTADOS UNIDOS DE AMERICA” y “PERU” la cantidad de películas por país, categoría 
select pais.nombre as PAIS, 
       cat.nombre as CATEGORIA,
	   COUNT(pel.id) as '#PELICULAS'
from   tbPais pais
inner join tbPelicula pel on pais.id=pel.idpais
inner join tbCategoriaPelicula catpel on pel.id=catpel.idpelicula
inner join tbCategoria cat on catpel.idcategoria=cat.id
group by pais.nombre,cat.nombre
having pais.nombre='ESTADOS UNIDOS DE AMERICA' or pais.nombre='PERU'
order by pais.nombre,cat.nombre asc;
--4 Se le solicita implementar una nueva forma de carga de usuarios. Por ello tiene que ejecutar las siguientes instrucciones:
--4.1 Crear un esquema con sus iniciales
CREATE SCHEMA gmv
--4.2 Sobre su esquema debe crear la tabla tbMaestroUsuario. Esta tabla debe tener la siguiente estructura
create table gmv.tbMaestroUsuario
(
usuariomaestro varchar(10),
correomaestro varchar(200)
)
--4.3 Inserte sobre su tabla creada 5 nuevos usuarios.
insert into gmv.tbMaestroUsuario select 'gcmanriquev','gcmanriquev@gmail.com';
insert into gmv.tbMaestroUsuario select 'jgonzalesm','jgonzalesm@gmail.com';
insert into gmv.tbMaestroUsuario select 'fmanriqueq','fmanriqueq@gmail.com';
insert into gmv.tbMaestroUsuario select 'sofiavalch','sofiavalch@gmail.com';
insert into gmv.tbMaestroUsuario select 'mariagonza','mariagonza@gmail.com';
--4.4	Crear un procedimiento almacenado con parámetros que inserte sobre miesquema. tbMaestroUsuario un nuevo usuario.
create procedure gmv.usp_InsertaUsuario
(
@usuariomaestro varchar(10),
@correomaestro varchar(200)
)
as
begin
	insert into gmv.tbMaestroUsuario(usuariomaestro,correomaestro)
	select @usuariomaestro,@correomaestro

end
--ejecutamos el sp_InsertSchemalcy
exec gmv.usp_InsertaUsuario 'mmoralesm','mmoralesm@gmail.com';
--5 Crear un procedimiento almacenado sin parámetros que muestre las películas de Perú ordenadas por año de mayor a menor valoración
create procedure dbo.usp_ListarPeliculasPeruPorAño
as
begin
select ROW_NUMBER() OVER(PARTITION BY pel.año ORDER BY pel.año desc) AS #FILA,
       pel.nombre as NOMBRE_PELICULA,
	   pel.duracion as DURACION,
	   pel.año as AÑO,
	   ROUND(AVG(CAST(val.calificacion as float)),2) as [VALORACION PROMEDIO]
from tbPais pais inner join 
     tbPelicula pel on pais.id=pel.idpais inner join 
	 tbValoracion val on pel.id=val.idpelicula
where pais.nombre='PERU' 
group by pel.nombre,pel.duracion,pel.año
order by pel.año desc
end

execute dbo.usp_ListarPeliculasPeruPorAño
--6 Presentar la información de usuarios en base al archivo usuarios.json 
select usu.id as [usuario.id],usu.usuario as [usuario.usuario],usu.correo as [usuario.correo],
pais.nombre as [pais.nombre] from tbUsuario usu 
inner join tbPais pais on usu.idpais=pais.id
order by usu.id
FOR JSON PATH,root('usuarios')
--7 Presentar la información de usuarios en base al archivo usuarios.xml 
select usu.id as 'usuario/@id',usu.usuario as 'usuario/@usuario',usu.correo as 'usuario/@correo',
pais.nombre as 'pais.nombre' from tbUsuario usu 
inner join tbPais pais on usu.idpais=pais.id
order by usu.id
FOR XML PATH('usuario'),root('usuarios')