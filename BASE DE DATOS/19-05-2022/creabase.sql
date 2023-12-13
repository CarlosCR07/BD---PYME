--Creación de la base de datos
create database PYME
go

use PYME
go

--Creación de los esquemas para usar
create schema persona
go
create schema catalogo
go
create schema promocion
go
create schema venta
go

--Creación de las tablas

--Tabla usuario
create table persona.usuario(
	idUsuario integer not null identity (1,1) 
		constraint PK_USUARIO primary key,
	nombre varchar(25) not null,
	apPaterno varchar(25) not null,
	apMaterno varchar(25) not null,
	nomUsuario varchar(25) not null,
	contrasena varchar(25) not null,
	email varchar(30) not null,
	fechaCumple date null,
	genero char(1) not null,
	curp varchar(18) not null,
	tipoUsr char(1) not null)
go

--Tabla telefonoUsurio
create table persona.telefono(
	idTel int not null identity (1,1),
	idUsuario int not null 
		constraint FK_USUARIO_TELEFONO foreign key references
		persona.usuario(idUsuario) on delete cascade on update cascade,
	numTel numeric(10,0) not null
	constraint PK_TELEFONO_USUARIO primary key(idTel,idUsuario)
)
go

--Tabla domicilioUsuario
create table persona.domicilio(
	idDomicilio int not null identity(1,1),
	idUsuario int not null
		constraint FK_USUARIO_DOMICILIO foreign key references
		persona.usuario(idUsuario) on delete cascade on update cascade,
	calle varchar(25) not null,
	numExt varchar(6) not null,
	numInt varchar(6) null,
	principal bit not null,
	colonia varchar(30) not null,
	alcaldia varchar(25) not null,
	constraint PK_DOMICILIO_USUARIO primary key(idDomicilio,idUsuario)
)
go

--Tabla de vendedor.
create table persona.vendedor(
	idVendedor int not null primary key
		constraint FK_USUARIO_VENDEDOR foreign key references
		persona.usuario(idusuario) on delete cascade on update cascade,
	sueldo money not null,
	comision money not null
)
go

--Tabla de cliente.
create table persona.cliente(
	idCliente int not null primary key
		constraint FK_USUARIO_CLIENTE foreign key references
		persona.usuario(idusuario) on delete cascade on update cascade
)
go

--Tabla de Administrador.
create table persona.administrador(
	idAdmin int not null primary key
		constraint FK_USUARIO_ADMINISTRADOR foreign key references
		persona.usuario(idusuario) on delete cascade on update cascade
)
go

--Tabla de recomendaciones
create table persona.recomendacion(
	idDesc int not null identity (1,1) 
		constraint PK_RECOMENDACION primary key,
	descripcion text not null,
	idCliente int not null 
		constraint FK_CLIENTE_RECOMENDACION foreign key references
		persona.cliente(idCliente) on delete no action on update no action,
	idAdministrador int null 
		constraint FK_ADMINISTRADOR_RECOMENDACION foreign key references
		persona.administrador(idAdmin) on delete no action on update no action
)
go

--Tabla de productos. (Luego añadimos la subcategoria)
create table catalogo.producto(
	clavePro int not null identity(1,1) 
		constraint PK_PRODUCTO primary key,
	precio money not null,
	nombreProd varchar(25) not null,
	descripcion varchar(30) not null,
	descDetalle text not null,
	vinculo text not null,
	stock int not null,
	cantidadReorden int not null,
	--(Luego añadimos la subcategoria) PD. Hecho
)
go

alter table catalogo.producto
	add subcategoria int not null
go

alter table catalogo.producto
	drop column subcategoria
go

alter table catalogo.producto
	add idSubcategoria int not null
go

--Tabla de suscripcion
create table persona.suscripcion(
	idCliente int not null
		constraint FK_CLIENTE_SUSCRIPCION foreign key references
		persona.cliente(idCliente) on delete cascade on update cascade,
	claveProd int not null
		constraint FK_PRODUCTO_SUSCRIPCION foreign key references
		catalogo.producto(clavePro) on delete cascade on update cascade,
	notificacion bit not null
	constraint PK_CLIENTE_PRODUCTO 
		primary key(idCliente,claveProd)
)
go

--Tabla de wishlit
create table persona.wishlist(
	idCliente int not null
		constraint FK_CLIENTE_WISHLIST foreign key references
		persona.cliente(idCliente) on delete cascade on update cascade,
	idWish int not null identity(1,1),
	claveProd int null --una wish list puede estar vacía
		constraint FK_PRODUCTO_WISHLIST foreign key references
		catalogo.producto(clavePro) on delete cascade on update cascade,
	constraint PK_CLIENTE_WHISHLIST 
		primary key(idCliente,idWish)
)
go

--Tabla de tipo de oferta
create table promocion.tipoOferta(
	idTipoOferta int not null identity (1,1)
		constraint PK_TIPO_OFERTA primary key,
	descTipo varchar(20) not null,
)
go

--Tabla de Oferta.
create table promocion.oferta(
	idOferta int not null identity(1,1)
		constraint PK_OFERTA primary key,
	fechaInicio date not null,
	fechaFin date not null,
	lapso int not null,
	descipcion text not null,
	porcentaje int not null,
	idTipoOferta int not null
		constraint FK_TIPO_OFERTA foreign key references
		promocion.tipoOferta(idTipoOferta) on delete cascade on update cascade
)
go

--Tabla de rebaja.
create table promocion.rebaja(
	idOferta int not null
		constraint FK_OFERTA_REBAJA foreign key references
		promocion.oferta(idOferta) on delete cascade on update cascade,
	claveProd int not null
		constraint FK_PRODUCTO_REBAJA foreign key references
		catalogo.producto(clavePro) on delete cascade on update cascade,
	precioOferta money not null,
	constraint PK_OFERTA_PRODUCTO 
		primary key(idOferta,claveProd)
)
go

--Tabla de categoria
create table catalogo.categoria(
	idCategoria int not null identity(1,1)
		constraint PK_CATEGORIA primary key,
	nomCategoria varchar(20) not null
)
go

--Tabla de subcategoria
create table catalogo.subcategoria(
	idSubcategoria int not null identity(1,1)
		constraint PK_SUBCATEGORIA primary key,
	nomSubcategoria varchar(20) not null,
	idCategoria int not null
		constraint FK_CATEGORIA_SUBCATEGORIA references
		catalogo.categoria(idCategoria) on delete cascade on update cascade
)
go

--Tabla de imagenes
create table catalogo.imagenes(
	idImagen int not null identity(1,1),
	claveProd int not null
		constraint FK_PRODUCTO_IMAGENES foreign key references
		catalogo.producto(clavePro) on delete cascade on update cascade,
	archivo image not null,
	constraint PK_IMAGEN_PRODUCTO primary key(idImagen,claveProd)
)
go

--Tabla de cesta
create table catalogo.cesta(
	idCesta int not null identity(1,1)
		constraint PK_CESTA primary key,
	cantidadProducto int not null
)
go

--Tabla de lista
create table catalogo.lista(
	idCesta int not null
		constraint FK_CESTA_LISTA foreign key references
		catalogo.cesta(idCesta) on delete cascade on update cascade,
	claveProd int not null
		constraint FK_PRODUCTO_LISTA foreign key references
		catalogo.producto(clavePro) on delete cascade on update cascade, 
	cantidad int not null,
	fechaAgrega date not null,
	permanencia bit not null,
	constraint PK_CESTA_PRODUCTO primary key(idCesta,claveProd)
)
go

--Tabla de compra
create table venta.compra(
	idCompra int not null identity(1,1)
		constraint PK_COMPRA primary key,
	fechaCompra datetime not null,
	montoTotal money not null,
	IVA money not null,
	tipoCompra char(1) not null,
	idCesta int not null 
		constraint FK_CESTA_COMPRA foreign key references
		catalogo.cesta(idCesta) on delete cascade on update cascade
)
go

--Tabla de fisica
create table venta.fisica(
	idCompra int not null primary key
		constraint FK_COMPRA_FISICA foreign key references
		venta.compra(idCompra) on delete cascade on update cascade,
	idVendedor int not null 
		constraint FK_VENDEDOR_FISICA foreign key references
		persona.vendedor(idVendedor) on delete cascade on update cascade
)
go

--Tabla de cateoria de medio de transporte
create table venta.catMedioTrans(
	idMedioTrans int not null identity(1,1)
		constraint PK_CATMEDIOTRANS primary key,
	nomMedioTrans varchar(20) not null
)
go

--Tabla de sistema de trasnporte
create table venta.sistTransporte(
	idTrans int not null identity(1,1)
		constraint PK_TRANSPORTE primary key,
	idMedioTrans int not null
		constraint PK_MEDIO_TRANSPORTE foreign key references
		venta.catMedioTrans(idMedioTrans)
)
go

--Tabla de online
create table venta.online(
	idCompra int not null primary key
		constraint FK_COMPRA_ONLINE foreign key references
		venta.compra(idCompra) on delete cascade on update cascade,
	cancelacion bit not null,
	fechaCancelacion date null,
	multa money null,
	idCliente int not null
		constraint FK_CLIENTE_ONLINE foreign key references
		persona.cliente(idCliente) on delete cascade on update cascade,
	idTrans int not null
		constraint FK_TRANS_ONLIE foreign key references
		venta.sistTransporte(idTrans) on delete cascade on update cascade
)
go

--Alterando tabla producto
alter table catalogo.producto
	add constraint FK_SUBCATEGORIA_PRODUCTO foreign key (idSubcategoria)
		references catalogo.subcategoria(idSubcategoria) on delete cascade on update cascade
go


-------------------------------------------------------------------------------
-------------------------------17/May/2022-------------------------------------
-------------------------------------------------------------------------------

--Agregando UNIQUES a Persona.Usuario
alter table persona.usuario add
	constraint UQ_NombreUsuario unique(nomUsuario),
	constraint UQ_Email unique(email),
	constraint UQ_CURP unique(curp)
go

--Agregando UNIQUES a catalogo.categoria
alter table catalogo.categoria add
	constraint UQ_NombreCategoria unique(nomCategoria)
go

--Agregando UNIQUES a catalogo.subcategoria
alter table catalogo.subcategoria add
	constraint UQ_NombreSubcategoria unique(nomSubcategoria)
go

--Agregando CHECKS a persona.usuario
alter table persona.usuario add
	constraint CK_TipoUsuario check(tipoUsr in('V','C','A')), --V-> Vendedor, C->Cliente, A->Administrador
	constraint CK_Genero check(genero in ('H', 'M'))	--H-> HOMBRE,M->MUJER
go

--Agregando CHECKS a venta.compra
alter table venta.compra add
	constraint CK_TipoCompra check(tipoCompra in ('F','O'))	-- F-> FISICA, O->ONLINE
go

--Alterando columna
alter table promocion.rebaja
	alter column precioOferta money null
go

--Alterando tabla promocion.oferta
alter table promocion.oferta 
	alter column lapso int null 
	go
alter table promocion.oferta add
	constraint CK_Lapso check(lapso < 40)
	go

--Alterando tabla catalogo.lista
alter table catalogo.lista
	alter column permanencia int null
go
alter table catalogo.lista
	alter column fechaAgrega datetime not null
go
alter table catalogo.lista add
	constraint CK_Permanencia check(Day(getdate()-fechaAgrega)<15)
go

--Alterando tabla persona.vendedor
alter table persona.vendedor add
	constraint CK_Sueldo check(sueldo > 5000)
go

--Alterando tabla venta.online
alter table venta.online
	alter column idTrans int null
go
alter table venta.online
	add constraint df_IdTrans default 1 for idTrans
go

--Alterando tabla catalogo.imagen
alter table catalogo.imagenes
	drop column archivo
go
alter table catalogo.imagenes add
	archivo text not null
go