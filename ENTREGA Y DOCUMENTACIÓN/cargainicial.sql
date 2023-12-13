/*
Carga inicial
*/


/*
Registro de usuarios
*/
use PYME0
begin tran
	--10 GESTORES
	--exec persona.pro_RegistroUsario Nombre, paterno, materno, nomUsuario,contraseña, correo, cumple, genero, curp, tipousuario 
	exec persona.pro_RegistroUsario 'Carlos','Rivas','Solis','CarlosR','aaA1*aaa','Carlosrivas@gmail.com','12/30/2000','H','RISC12','A'
	exec persona.pro_RegistroUsario 'Carlos','Castelan','Ramos','CastelanUSR','aaA1*aaa','castelan@gmail.com','06/15/2001','H','CAST04','A'
	exec persona.pro_RegistroUsario 'Marco','Torres',' ','MacoT','aaA1*aaa','marco@gmail.com','06/21/2001','H','MARC01052AS','A'
	exec persona.pro_RegistroUsario 'Luis','Sanchez','Lopez','Luisito','aaA1*aaa','aaaaa@gmail.com','05/10/2001','H','LSAS1515','A'
	exec persona.pro_RegistroUsario 'Karen','Martinez','Saenz','KarenM','aaA1*aaa','karen@gmail.com','11/11/2001','M','ELBA56565','A'
	exec persona.pro_RegistroUsario 'Luisa','Rojas','','Luisilla','aaA1*aaa','luisa@gmail.com','01/28/2001','H','','A'
	exec persona.pro_RegistroUsario 'Felipe','Carrazco','Perez','Felip77','aaA1*aaa','felipe@gmail.com','04/21/2001','H','JAJA12A','A'
	exec persona.pro_RegistroUsario 'Daniel','Sol','Llaven','Solesito','aaA1*aaa','solesito@gmail.com','10/15/2001','H','SOLE51','A'
	exec persona.pro_RegistroUsario 'Maria','Concepa','Lira','MariaC','aaA1*aaa','mariaa@gmail.com','02/10/2001','M','MARIA12','A'
	exec persona.pro_RegistroUsario 'Martha','Lopez','','MarthaL','aaA1*aaa','marthal@gmail.com','10/21/2001','M','MARTHA0102','A'
commit tran

	--5 vendedores
begin tran
	exec persona.pro_RegistroUsario 'Veronica','Chavez','Antera','Vero15','aaA1*aaa','verinica@gmail.com','05/02/2004','M','VER921','V'
	exec persona.pro_RegistroUsario 'Fernando','Teran','Soles','Fercho10','aaA1*aaa','fercho@gmail.com','02/15/2004','H','FERCHO12','V'
	exec persona.pro_RegistroUsario 'Enrique','Juarez','','Kike','aaA1*aaa','kike@gmail.com','10/10/2004','H','KIKE123','V'
	exec persona.pro_RegistroUsario 'Claudia','Suarez','Ramirez','ClauSR','aaA1*aaa','claur@gmail.com','03/12/2004','M','CLAU321','V'
	exec persona.pro_RegistroUsario 'Pedro','Morales','Cama','Pedrin','aaA1*aaa','pedrin@gmail.com','09/29/2004','H','pedrin','V'
commit tran

	--5 clientes
begin tran
	exec persona.pro_RegistroUsario 'Carlos','Gonzal','Godin','GokuUsr','aaA1*aaa','godin@gmail.com','07/23/2000','H','GODIND12','C'
	exec persona.pro_RegistroUsario 'Juana','Latejana','Camiona','Juanita4k','aaA1*aaa','juana@gmail.com','02/15/2000','M','JUANA654','C'
	exec persona.pro_RegistroUsario 'Samuel','De','Luque','Vegeta777','aaA1*aaa','vegeta@gmail.com','08/20/2003','H','VEGE154','C'
	exec persona.pro_RegistroUsario 'Enrique','Pena','Nieto','Pena','aaA1*aaa','enriquepena@gmail.com','09/18/2000','H','PENA961','C'
	exec persona.pro_RegistroUsario 'Andres','Lopez','Obrador','Amlo','aaA1*aaa','amlo@gmail.com','07/07/2000','H','AMOR123','C'
commit tran
select * from persona.usuario
	select * from persona.cliente
	select * from persona.administrador
	select * from persona.vendedor

--INSERTAMOS ALGUNOS DOMICILIOS
select * from persona.cliente
insert into persona.domicilio(idUsuario,calle,numExt,principal, colonia, alcaldia) 
		values (18,'Calle Ignacio Zaragoza', '10', 1, 'Xaltipac','Milpa Alta'),
			(16,'Calle Ignacio Zaragoza', '10', 1, 'Xaltipac','Milpa Alta'),
			(17,'Calle Ignacio Zaragoza', '10', 1, 'Xaltipac','Milpa Alta'),
			(19,'Calle 5 de fec', '10', 1, 'Xaltipac','Milpa Alta')
	

--INSERTAMOS MEDIOS DE TRANSPORTE
go
begin tran
exec venta.pro_CatMedioTrans DHL
exec venta.pro_CatMedioTrans ESTAFETA
exec venta.pro_CatMedioTrans MercadoLibre
commit tran
select * from venta.catMedioTrans

--INSERCION PARA ELECCION DE MEDIOS DE TRANSPORTE CON COMPRA
begin tran
exec venta.pro_sisTransporte 1
exec venta.pro_sisTransporte 2
exec venta.pro_sisTransporte 3
commit tran
select * from  venta.sistTransporte

--INSERTAMOS CATEGORIAS
begin tran
insert into catalogo.categoria(nomCategoria) values 
('Electronica'), ('Ropa'), ('Comida'),('Jugueteria') 
go
commit tran
select * from catalogo.categoria order by idCategoria

--INSERTAMOS SUBCATEGORIAS
begin tran
insert into catalogo.subcategoria(nomSubcategoria, idCategoria) values
	('Linea Blanca',1),('Entretenimiento',1),
	('Adultos',2),('Niños',2),
	('Vegetales',3), ('Carnes rojas',3),
	('Bebes', 4),('De mesa',4)
	go
commit tran
select * from catalogo.subcategoria order by idSubcategoria

--INSERTAMOS PRODUCTOS
begin tran
insert into catalogo.producto (precio, nombreProd, descripcion, descDetalle, vinculo,stock,idSubcategoria, cantidadReorden) values
	(2000, 'Lavadora LG', 'Lavadora LG 50KG','Lavadora LG Blanca 50 KG','http://lavadora.com', 10,1,0),
	(2500,'Estufa Mabe','Estuda Mabe blanca Mediana','Estuda de 6 fuegos ahorradora de gas', 'https://estufa.com',5,1,0),
	(3010, 'Television SAMSUNG', 'TV FHD SAMSUNG','TV FLHD 4K 60Pulgadas','http://tv.com', 5,2,0),
	(150, 'Camisa de cuadros', 'Camisa POLO de cuadros','Camisa de cuadros azul tamaño mediano','http://camisa.com', 15,3,0),
	(1200, 'Gorrito de kiko', 'Gorro de kiko del chavo del 8','Gorro negro y fresa para verse cul','http://gorro', 8,4,0),
	(15,'Manzana permium','Una manzana','Una manzana ROJA','http://manzana.com',80,5,0), 
	(50,'Carne de res','Carne de res','Antes estaba viva, ahora no','http://carne.com',30,6,0), 
	(2500,'Carreola','Una carreola de bebe','Para divertirte con tu bebe','http://carreola.com',15,7,0),
	(500,'Monopoly','Juego de mesa de monopoly','Para perder tus amigos con estilo','http://monopolu.com',10,8,0)
go
commit tran

select * from catalogo.producto
select * from catalogo.subcategoria

--INSERTAR imagenes de productos
begin tran
insert into catalogo.imagenes (claveProd,archivo) values
	(1,'https://drive.google.com/file/d/1isJcvRcYlKUe8VZM8lTkKTPp5RFsWEIt/view?usp=sharing'),
	(1,'https://drive.google.com/file/d/1_gkZXIiI_bCm94BkGmP0Q1SP9Ai1B4TZ/view?usp=sharing'), 
	(2,'https://drive.google.com/file/d/1z9fguDeV0BJB_nHScJpPJDL8GYLcFH-f/view?usp=sharing'),
	(3,'https://drive.google.com/file/d/10iUxbFpa1fWw8jV2k7EO_VaUiVba2rV0/view?usp=sharing'),
	(4,'https://drive.google.com/file/d/1ODlLW37uXn_qm7eljkVAW92r2FgNBnKn/view?usp=sharing'),
	(5,'https://drive.google.com/file/d/1HUQyQfjFD4rtcaLgXONpV21HtgchItBD/view?usp=sharing'), 
	(6,'https://drive.google.com/file/d/1Nu6Mh_r6jYGywH_fWY_ZZe3GO3Q9OxXA/view?usp=sharing'), 
	(7,'https://drive.google.com/file/d/1LAX8VOzlVIdiEF4ir018RQ9KxgsNO7jj/view?usp=sharing'),
	(8,'https://drive.google.com/file/d/1kFbc_DnHeVbctIFRNeWv917HwT8Qi-wd/view?usp=sharing')
	go
commit tran
select * from catalogo.imagenes


--SUSCRIBIRSE A UN PRODUCTO
select * from persona.cliente
select * from catalogo.producto

begin tran
exec persona.pro_Suscribir 18,4

commit tran

--INSERTAR OFERTAS
--Primero creamos tipos de ofertas

begin tran
	exec promocion.pro_CrearTipoOferta 'Descuento ropa'
	exec promocion.pro_CrearTipoOferta 'Des Higiene'
	exec promocion.pro_CrearTipoOferta 'Desc electrodom'
commit tran
	select * from promocion.tipoOferta

--Asignar tipos ofertas a ofertas especificas
	--exec promocion.pro_CrearOferta 'FechaInicio','FechaFin','Descripcion',porcentaje, idTipoOferta
	select * from promocion.tipoOferta--Primero tengo que ver los tipos de oferta
	begin tran
	exec promocion.pro_CrearOferta '05/23/2022','05/28/2022','Descuento a ropa de adulto', 15 , 1
	--Para cuando la oferta es mayor a 40 dìas
	exec promocion.pro_CrearOferta '04/01/2020','05/12/2022','Descuento a estufas',10 , 3
	rollback tran
	delete promocion.oferta
	dbcc checkident ('promocion.oferta', reseed,0)

--Creacion de rebaja sobre productos
--Probando creación de rebajas
	select * from promocion.oferta
	select * from catalogo.producto

begin tran
	--exec promocion.pro_CrearRebaja idOferta, claveProd
	exec promocion.pro_CrearRebaja 1,4
	
commit tran

--LLENAR LISTA 
--Creamos una  vista para mayor comodidad
create or alter view catalogo.visCestas as
	select c.idCesta as 'Id cesta', c.idCliente as 'Id usuario', concat(u.apPaterno,' ', ISNULL(u.apMaterno,'-'),' ',u.Nombre) as 'Nombre del usuario'  from catalogo.cesta as c
		inner join persona.usuario as u 
		on c.idCliente = u.idUsuario
go
select * from catalogo.visCestas

--Insertar productos
select * from catalogo.cesta
begin tran
--exec catalogo.pro_ClienteListaCesta idCesta,claveProd, cantidad,
exec catalogo.pro_ClienteListaCesta 1, 2, 3
select * from catalogo.lista
select * from catalogo.cesta
commit tran

begin tran
exec catalogo.pro_ClienteListaCesta 2, 1,3
exec catalogo.pro_ClienteListaCesta 2, 5,4
select * from catalogo.lista
select * from catalogo.cesta
rollback tran

--REALIZAMOS COMPRA ONLINE
--Usamos vista creada
select * from catalogo.visCestas
--Lista y cesta sin vaciar
select * from catalogo.cesta
select * from catalogo.lista
---
begin tran
	--exec venta.pr_RealizarCompraOnline idCesta, idTransporte
	exec venta.pr_RealizarCompraOnline 1,2
	select * from venta.compra
select * from venta.online
--Se vacia la lista y cesta
select * from catalogo.cesta
select * from catalogo.lista
rollback tran


--REALIZAMOS COMPRA FISICA
select * from persona.vendedor
--Lista y cesta sin vaciar
select * from catalogo.cesta
select * from catalogo.lista
---
begin tran
	--exec venta.pr_RealizarCompraOnline idCesta, idVendedor
	exec venta.pr_RealizarCompraFisica 1,13
	select * from venta.compra
	select * from venta.fisica
--Se vacia la lista y cesta
select * from catalogo.cesta
select * from catalogo.lista
rollback tran

--CREACION DE VISTAS 
--Vista para ver la informacion(clavePro, precio, nombre) del producto categoria y subcategoria
go
create or alter view catalogo.visProducto as
	select p.clavePro, p.precio, p.nombreProd, s.nomSubcategoria, c.nomCategoria from catalogo.producto as p
	inner join catalogo.subcategoria as s
	on p.idSubcategoria=s.idSubcategoria 
	inner join catalogo.categoria as c
	on s.idCategoria=c.idCategoria
go
select * from catalogo.visProducto

--Vista para ver usuarios vendedores hombres
go
create or alter view persona.usuariosHombres as
	select idUsuario, CONCAT(nombre, apPaterno, apMaterno)as 'Nombre Completo', genero from persona.usuario
		where genero='H' and tipoUsr = 'V'
go
select * from persona.usuariosHombres 

