use PYME
go


insert into catalogo.categoria(nomCategoria) values ('Higiene') 
go

select * from catalogo.categoria

insert into catalogo.subcategoria(nomSubcategoria, idCategoria) values
	('Dental',1)
	go

insert into catalogo.producto (precio, nombreProd, descripcion, descDetalle, vinculo,stock,idSubcategoria, cantidadReorden) values
	(5000,'Colgate','Pasta dental','Para lavarte los dientes cochino','http://hola',5,1,5)
go
select * from catalogo.producto
go

insert into catalogo.imagenes (claveProd,archivo) values
	(3,'Imagina que soy una imagen')
	go

--Procedimiento para búsuqeda de productos.
create or alter procedure catalogo.pro_BusquedaProducto
	@vNombre varchar(25)
	as
	begin
	select p.clavePro,p.precio, p.nombreProd,p.descripcion, p.descDetalle, p.vinculo,i.archivo from catalogo.producto as p
		inner join catalogo.imagenes as i
		on p.clavePro = i.claveProd
		where nombreProd like '%'+@vNombre+'%'
	end
go
exec catalogo.pro_BusquedaProducto 'gate'
go

--Procedimiento de búsqueda por nombre de categoría.
create or alter procedure catalogo.pro_BusquedaCategoria
	@vNombre varchar(25)
	as
	begin
		select p.clavePro,p.precio, p.nombreProd,p.descripcion, p.descDetalle, p.vinculo,i.archivo from catalogo.producto as p
		inner join catalogo.imagenes as i
		on p.clavePro = i.claveProd
		inner join subcategoria as s
		on p.idSubcategoria = s.idSubcategoria
		inner join categoria as c
		on s.idCategoria = c.idCategoria
		where c.nomCategoria like '%'+@vNombre+'%'
	end
go

exec catalogo.pro_BusquedaCategoria 'Higiene'
go

--Procedimiento de listadod de categorias
create or alter procedure catalogo.pro_ListadoCategorias
as begin
	select idCategoria,nomCategoria from catalogo.categoria
end
go

exec catalogo.pro_ListadoCategorias
go

create or alter procedure catalogo.pro_ListadoSubcategoria
	@vNombre varchar(25)
	as
	begin
		select s.idSubcategoria, s.nomSubcategoria from catalogo.producto as p
		inner join catalogo.imagenes as i
		on p.clavePro = i.claveProd
		inner join subcategoria as s
		on p.idSubcategoria = s.idSubcategoria
		inner join categoria as c
		on s.idCategoria = c.idCategoria
		where c.nomCategoria like '%'+@vNombre+'%'
	end
go

exec catalogo.pro_ListadoSubcategoria 'Higiene'
go

--Procedimiento de búsqueda por nombre de subcategoría.
create or alter procedure catalogo.pro_BusquedaSubcategoria
	@vNombre varchar(25)
	as
	begin
		select * from catalogo.producto as p
		inner join subcategoria as s
		on p.idSubcategoria = s.idSubcategoria
		where s.nomSubcategoria like '%'+@vNombre+'%'
	end
go

exec catalogo.pro_BusquedaSubcategoria 'Dental'