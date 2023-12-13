/*
DML Y TRIGGERS
MUCHOS TRIGGERS SE VALIDAN DE LA MANO DE UN PROCEDIMIENTO, ES POR ESO QUE SE COLOCARON JUNTOS
*/

--1.	Procedimiento para dar de alta usuarios (T) / 10.	Notificación de que el usuario ya existe por su nombre usuario o curp.
--Autor: Rivas Solis Carlos Eduardo
use PYME0
go
create or alter procedure persona.pro_RegistroUsario
	@pNombre varchar(25),
	@pPaterno varchar(25),
	@pMaterno varchar(25),
	@pNombreUsuario varchar(25),
	@pContrasena varchar(25),
	@pEmail varchar(30),
	@pFechaCumple date,
	@pGenero char(1),
	@pCurp varchar(18),
	@pTipoUsr char(1)
	as
	begin
		if exists (select idUsuario from persona.usuario where nomUsuario = @pNombreUsuario or curp = @pCurp)
		begin
			print 'Nombre de usuario o CURP ya utilizado'
		end
		else if(@pTipoUsr != 'A' and @pTipoUsr != 'C' and @pTipoUsr != 'V')
		begin
			print 'Tipo de usuario inválido'
		end
		else
		begin
			begin tran
				insert into persona.usuario (nombre,apPaterno,apMaterno,nomUsuario,contrasena,email,fechaCumple,genero,curp,tipoUsr) values
					(@pNombre,@pPaterno,@pMaterno,@pNombreUsuario,@pContrasena,@pEmail,@pFechaCumple,@pGenero,@pCurp,@pTipoUsr)
			commit tran
			print 'El usuario se insertó correctamente'
		end
	end
go

create or alter trigger persona.tr_InsertUsuario
	on persona.usuario
	after insert
	as
	begin
		declare @vTipoUsr char(1),
				@vIdUsuario int
		set @vTipoUsr = (select tipoUsr from inserted)
		set @vIdUsuario = (select idUsuario from inserted)
		if(@vTipoUsr = 'A')
			begin
				insert into persona.administrador (idAdmin) values
					(@vIdUsuario)
					print 'Trigger activado'
			end
		else if(@vTipoUsr = 'C')
			begin
				insert into persona.cliente (idCliente) values
					(@vIdUsuario)
					print 'Trigger activado'
					insert into catalogo.cesta (idCliente) values (@vIdUsuario)
			end
		else
			begin
				insert into persona.vendedor (idVendedor,sueldo) values
					(@vIdUsuario,5001)
					print 'Trigger activado'
			end
	end
go

	--SE HIZO LA CARGA INICIAL DE USUARIOS

-----------------------------------------------------------------------------------------------------------------------------------

--2. PROCEDIMIENTO para visualizar el stock y reoden
--Autor: Castelan Ramos Carlos

GO
create or alter procedure catalogo.pro_IventariarProductos
	as
	begin
		select clavePro, nombreProd, stock, cantidadReorden, idSubcategoria
			from catalogo.producto
	end
go
exec catalogo.pro_IventariarProductos

-- 3. TRIGGER para asignar un valor automatico a reorden despuès de insertar un producto en lista
--Autor: Castelan Ramos Carlos

go 
create or alter trigger catalogo.tr_ReordenAbastecimiento
on catalogo.lista
after insert
as 
	begin 
		declare @vClaveProd int,
			@vCantReorden int,
			@vIdCesta int
		set @vClaveProd=(select claveProd from inserted)
		set @vIdCesta=(select idCesta from inserted)
		update catalogo.producto
		set cantidadReorden=(select cantidad from catalogo.lista 
				where claveProd=@vClaveProd and idCesta=@vIdCesta)
			where clavePro=@vClaveProd
	end
go

--4. PROCEDIMIENTO para abastecer stock segun lo que se visualice en el inventario (PROCEDIMIENTO 2)
--Autor: Castelan Ramos Carlos
GO
create or alter procedure catalogo.pro_AbastecerProductos
	@pClave int,
	@pStock int
	as
	begin
		IF (exists(select clavePro from catalogo.producto where clavePro = @pClave))
			begin
				update catalogo.producto 
				set stock = stock + @pStock,
					cantidadReorden = 0
					where clavePro = @pClave
				print 'Se ha reabastecido correctamente el producto'
			end
		ELSE
			print 'La clave del producto es no existe o es incorrecta'
	end
go

--5. PROCEDIMIENTO para visualizar los productos ordenados por categoría
--Autor: Rivas Solis Carlos Eduardo
go
create or alter procedure catalogo.pro_ProductoCategoria
	@pCategoria varchar(40)
	as
	begin
		select p.clavePro as 'Clave', s.nomSubcategoria as 'Subcategoría', p.nombreProd as 'Nombre', 
			p.descripcion as 'Descripcion', CONCAT('$',p.precio) as 'Costo' from catalogo.producto as p
		inner join catalogo.subcategoria as s
		on p.idSubcategoria = s.idSubcategoria
		inner join catalogo.categoria as c
		on c.idCategoria = s.idCategoria
		where c.nomCategoria like '%'+@pCategoria+'%'
	end
go

--6. PROCEDIMIENTO para Buscar el producto por nombre, descripción, categoría o subcategoríag y mostrar alternativas. PROCEDURE. (T)
--Autor: Carlos Castelan Ramos

go
create or alter procedure catalogo.pro_BusquedaProducto
--Declaramos variables
@filtro varchar(30)
as
begin
	select p.clavePro,p.precio, p.nombreProd,p.descripcion, p.descDetalle, 
	p.vinculo,i.archivo, s.nomSubcategoria, c.nomCategoria 
	from catalogo.producto as p
		inner join catalogo.imagenes as i
		on p.clavePro = i.claveProd
		inner join catalogo.subcategoria as s
		on p.idSubcategoria=s.idSubcategoria
		inner join catalogo.categoria as c
		on s.idCategoria=c.idCategoria
		where p.nombreProd like '%'+@filtro+'%' or 
			p.descripcion like '%'+@filtro+'%' or
			c.nomCategoria like '%'+@filtro+'%'or 
			s.nomSubcategoria like '%'+@filtro+'%' 
	end
go

--7. PROCEDIMIENTO para creacion de WISHLIST
--Autor: Rivas Solis Carlos Eduardo
go
create or alter procedure persona.pro_CrearWishlist
	@pIdCliente int,
	@pClave int
	as
	begin
		if (exists(select idCliente from persona.cliente where idCliente = @pIdCliente) 
			and exists(select clavePro from catalogo.producto where clavePro = @pClave))
		begin
			insert into persona.wishlist(idCliente,claveProd) values
			(@pIdCliente,@pClave)
			print 'Creación de wishlist exitosa'
		end
		else
		begin
			print 'Las ID´s son inválidas'
		end
	end
go

--8. PROCEDIMIENTO para subscribir a producto. 
--Autor: Rivas Solis Carlos Eduardo
go
create or alter procedure persona.pro_Suscribir
	@pIdCliente int,
	@pClave int
	as
	begin
		if (exists(select idCliente from persona.cliente where idCliente = @pIdCliente) 
			and exists(select clavePro from catalogo.producto where clavePro = @pClave))
		begin
			insert into persona.suscripcion (idCliente,claveProd) values
			(@pIdCliente,@pClave)
			print 'Suscripción exitosa'
		end
		else
		begin
			print 'Las ID´s son inválidas'
		end
	end
go

--9. PROCEDIMIENTO para Guardado de producto en la cesta (posible trigger para actualizar el stock) (T) CASTELAN
--Autor: Carlos Castelan Ramos

--Primero un procedimineto insertar productos

go
create or alter procedure catalogo.pro_ClienteListaCesta 
	@pIdCesta int,
	@pClave int,
	@pCantProduc int
	as
	begin
		IF (exists(select idCesta from catalogo.cesta where idCesta = @pIdCesta) 
			and exists(select clavePro from catalogo.producto where clavePro = @pClave))
			if (exists (select stock from catalogo.producto where clavePro = @pClave and stock>= @pCantProduc))
				begin
					insert into catalogo.lista(idCesta,claveProd, cantidad, fechaAgrega) values
					(@pIdCesta, @pClave, @pCantProduc, getdate()) 
					print 'Se ha añadido el producto exiosamente'
				end
			else
				print 'El producto tiene un stock insuficiente para su transacción'
		ELSE
			print 'Las ID´s son inválidas'
	end
go

--10. TRIGGER para calcular la permanencia
--Autor: Castelan Ramos Carlos
go
create or alter trigger catalogo.tr_PermanenciaLista
on catalogo.lista
for insert
as 
	begin 
		update catalogo.lista
		set permanencia = datediff(day, getdate(), fechaAgrega)--day(getdate()-fechaAgrega) 
			where idCesta=(select idCesta from inserted) and claveProd=(select claveProd from inserted)
	end
go

select * from catalogo.lista

GO  

--11. TRIGGER para actualizar cantidaProducto de la tabla cesta a partir de las cantidades de cada producto de lista
--Autor: Castelan Ramos Carlos
go
create or alter trigger catalogo.tr_CantidadProductoCesta
on catalogo.lista
after insert
as
	begin 
		declare @vIdCesta int
		set @vIdCesta=(select idCesta from inserted)
		update catalogo.cesta
		set cantidadProducto = (select sum(cantidad) from catalogo.lista where idCesta=@vIdCesta) 
			where idCesta=@vIdCesta
	end 
go

--12. PROCEDIMIENTO para borrado de cesta los productos con más de 15 días de permanencia. CASTELAN
--Autor: Castelan Ramos Carlos y Rivas Solis Carlos Eduardo
go
create or alter procedure catalogo.pro_BorradoPermanencia
	as
	begin 
	declare 
		@vIdCesta int, 
		@vClaveProd int, 
		@vCantidad int,
		@vCantidadReorden int,
		@vPermanencia int
		DECLARE cPermanencia cursor 
		for select distinct idCesta, claveProd, cantidad, permanencia from catalogo.lista

		OPEN cPermanencia 
			FETCH cPermanencia into @vIdCesta, @vClaveProd, @vCantidad, @vPermanencia 
			WHILE (@@FETCH_STATUS=0)
				BEGIN
					if (@vPermanencia>15)
					begin
						delete catalogo.lista where idCesta=@vIdCesta and claveProd=@vClaveProd
						update catalogo.cesta
							set cantidadProducto=cantidadProducto-@vCantidad where idCesta=@vIdCesta
						update catalogo.producto 
							set cantidadReorden= cantidadReorden-@vCantidad where clavePro=@vClaveProd
						print 'Han pasado mas de 15 días de su cesta y lista se eliminará'
					end
					else
						begin
							print 'La cesta aún esta disponible'
						end
				FETCH cPermanencia into @vIdCesta, @vClaveProd, @vCantidad, @vPermanencia 
				END
		CLOSE cPermanencia
		deallocate cPermanencia
	end
go

--13. TRIGGER para notificación de que un producto recibe una oferta

--Primero debemos crear o el procedimiento de creación de tipos de ofertas(solo puede el admin)
--Autor: Castelan Ramos Carlos
go
create or alter procedure promocion.pro_CrearTipoOferta
@pDescripcionOferta varchar (30)
as
	begin
		insert into promocion.tipoOferta(descTipo) values
			(@pDescripcionOferta)
		print 'Se creó correctamente el tipo de oferta'
	end
go

--14. PROCEDIMIENTO para  para crear y aplicar ofertas
--Autor: Castelan Ramos Carlos
go 
create or alter procedure promocion.pro_CrearOferta
@pFechaInicio date,
@pFechaFin date,
@pDescripcion text, 
@pPorcentaje int,
@pIdTipoOferta int
as
	begin 
		insert into promocion.oferta(fechaInicio, fechaFin, descipcion, porcentaje, idTipoOferta) values
			(@pFechaInicio, @pFechaFin, @pDescripcion,  @pPorcentaje, @pIdTipoOferta)
		print 'Se creó correctamente la oferta'
		select o.idOferta,o.fechaInicio, o.fechaFin, o.lapso, o.descipcion, o.porcentaje, o.idTipoOferta, ti.descTipo  
			from promocion.oferta as o
			inner join promocion.tipoOferta as ti
			on o.idTipoOferta=ti.idTipoOferta
	end
go

--15. TRIGGERS para actualizacion de lapso oferta
--Autor: Castelan Ramos Carlos y Rivas Solis Carlos E
create or alter trigger promocion.tr_LapsoOferta
on promocion.oferta
for insert
as 
	begin 
		update promocion.oferta
		set lapso= datediff(day, fechaInicio, fechaFin)
			where idOferta = (select idOferta from inserted)
	end
go

--16. PROCEDIMIENTO para Aplicar rebaja a prodcuto
--Autor: Castelan Ramos Carlos y Rivas Solis Carlos Eduardo
go
create or alter procedure promocion.pro_CrearRebaja
	@pIdOferta int,
	@pClavePro int
	as
	begin
		declare
		@vPrecioOferta money
		if exists (select idOferta from promocion.rebaja 
			where idOferta = @pIdOferta and claveProd = @pClavePro)
		begin
			print 'La oferta ya fue aplicada en el producto antes'
		end
		else
		begin
			set @vPrecioOferta = (select precio from catalogo.producto where clavePro = @pClavePro)
			set @vPrecioOferta = @vPrecioOferta - (@vPrecioOferta * (select porcentaje from promocion.oferta where idOferta=@pIdOferta)*0.01)
			insert into promocion.rebaja (idOferta,claveProd,precioOferta) values
				(@pIdOferta,@pClavePro,@vPrecioOferta)
			print 'Oferta aplicada correctamente'
			select clavePro, nombreProd, precio as 'Precio Normal', o.porcentaje  as 'Porcentaje descuento',
			o.descipcion as 'Tipo descuento', r.precioOferta as 'Precio con descuento'
				from catalogo.producto as p
				inner join promocion.rebaja as r
				on p.clavePro = r.claveProd
				inner join promocion.oferta as o
				on r.idOferta = o.idOferta
		end
	end
go

--17. TRIGGER para enviar notificacion a todos los suscritos a un producto
--Autor: Rivas Solis Carlos Eduardo
go
create or alter trigger promocion.tr_ActivarNotificacion
	on promocion.rebaja
	after insert
	as
	begin
		declare @vClaveProducto int
		set @vClaveProducto = (select claveProd from inserted)
		update persona.suscripcion
			set notificacion = 1
			where claveProd = @vClaveProducto
		print 'Notificado a todos los suscritos'
	end
go

--18. PROEDIMIENTO para realizar compra online y fisica (comision del 5% al vendedor)
--Autor: Rivas Solis Carlos Eduardo
create or alter procedure venta.pr_RealizarCompraOnline
	@pIdCesta int,
	@pIdTrans int
	as
	begin
		if((select tipoUsr from persona.usuario
				inner join catalogo.cesta
				on idUsuario = idCliente
				where idCesta = @pIdCesta) = 'C')
		begin
			declare @vMontoTotal int
			set @vMontoTotal = (select sum(p.precio) from catalogo.lista as l
				inner join catalogo.producto as p
				on l.claveProd = p.clavePro
				where l.idCesta = @pIdCesta)
			if((select cantidadProducto from catalogo.cesta where idCesta = @pIdCesta)=0)
			begin
				print 'La cesta está vacía, venta cancelada.'
			end
			else
			begin
				if exists (select idDomicilio from persona.domicilio 
					where idUsuario = (select idCliente from catalogo.cesta 
						where idCesta = @pIdCesta) and principal = 1)
				begin
					if exists(select idTrans from venta.sistTransporte where idTrans = @pIdTrans)
					begin
						insert into venta.compra(fechaCompra,montoTotal,IVA,tipoCompra,idCesta) values
							(GETDATE(),@vMontoTotal,16,'O',@pIdCesta)
						declare @vIdCompra int = scope_identity()
						insert into venta.online(idCompra,idTrans) values 
							(@vIdCompra,@pIdTrans)
					end
					else
					begin
						print 'No hay un medio de transporte asignado'
					end
				end
				else
				begin
					print 'El usuario no tiene ningún domicilio principal'
				end
			end
		end
		else
		begin
			print 'El usuario no tiene permiso para la compra'
		end
	end
go

create or alter procedure venta.pr_RealizarCompraFisica
	@pIdCesta int,
	@pIdVendedor int
	as
	begin
		if((select tipoUsr from persona.usuario
				inner join catalogo.cesta
				on idUsuario = idCliente
				where idCesta = @pIdCesta) = 'C')
		begin
			declare @vMontoTotal int
			set @vMontoTotal = (select sum(p.precio) from catalogo.lista as l
				inner join catalogo.producto as p
				on l.claveProd = p.clavePro
				where l.idCesta = @pIdCesta)
			if((select cantidadProducto from catalogo.cesta where idCesta = @pIdCesta)=0)
			begin
				print 'La cesta está vacía, venta cancelada.'
			end
			else
			begin
				
				if exists(select idVendedor from persona.vendedor where idVendedor = @pIdVendedor)
				begin
					insert into venta.compra(fechaCompra,montoTotal,IVA,tipoCompra,idCesta) values
						(GETDATE(),@vMontoTotal,16,'F',@pIdCesta)
					declare @vIdCompra int = scope_identity()
					insert into venta.fisica(idCompra,idVendedor) values 
						(@vIdCompra,@pIdVendedor)
				end
				else
				begin
					print 'No existe este vendedor'
				end
			end
		end
		else
		begin
			print 'El usuario no tiene permiso para la compra'
		end
	end
go

--19. PROCEDIMIENTO para Validar que una oferta no tiene más de 40 días ¿Procedure verificar ofertas?		CASTELAN - function
--Autor: Castelan Ramos Carlos
go
create or alter procedure promocion.pro_BorradoOferta
	as
	begin 
	declare 
		@vIdOferta int, 
		@vLapso int
		DECLARE cLapso cursor 
		for select distinct idOferta, lapso from promocion.oferta

		OPEN cLapso
			FETCH cLapso into @vIdOferta, @vLapso
			WHILE (@@FETCH_STATUS=0)
				BEGIN
					if (@vLapso>40)
					begin
						delete promocion.oferta where idOferta=@vIdOferta
						print 'Han pasado mas de 40 días de la oferta, entonces se eliminará'
					end
					else
						begin
							print 'La oferta aún esta disponible'
						end
				FETCH cLapso into @vIdOferta, @vLapso
				END
		CLOSE cLapso
		deallocate cLapso
	end
go	

--20. PROCEDIMIENTO para Cancelar una venta con 48 h posteriores con 15% de multa (un procedure con trigger insertado en el on delete)
--Autor: Torres Martinez Marco
create or alter procedure venta.Cancelacion
@p_idCompra int
as
begin
	declare @v_fechaCompra datetime
	select @v_fechaCompra = fechaCompra from venta.compra where idCompra = @p_idCompra
	if DATEDIFF(HOUR, @v_fechaCompra,getdate()) > 48
		print 'Han transcurrido más de 48 horas desde su compra por lo que ya no puede ser cancelada'
	else
	begin
		update venta.compra set cancelacion = 1, montoTotal = montoTotal*0.15
	end
end

--21. TRIGGER para validacion de contraseña
--Autor: Torres Martinez Marco
go
create or alter trigger persona.verificaContrasena
on persona.usuario
for insert
as
begin
	declare @vcontrasena varchar(25)
	select @vcontrasena = contrasena from inserted
	if len(@vcontrasena) between 8 and 12
	begin
		if not exists(select idUsuario from inserted where contrasena like '%[0-9]%')
		begin
			print 'La contraseña debe contener al menos un numero'
			rollback transaction
		end
		else
		begin
			if not exists(select idUsuario from inserted where contrasena like '%[A-Z]%' collate SQL_Latin1_General_CP1_CS_AS)
			begin
				print 'La contraseña debe contener al menos una letra mayuscula'
				rollback transaction
			end
			else
			begin
				if not exists(select idUsuario from inserted where contrasena like '%[a-z]%' collate SQL_Latin1_General_CP1_CS_AS)
				begin
					print 'La contraseña debe contener al menos una letra minuscula'
					rollback transaction
				end
			end
		end
	end
	else
	begin
		print 'La contraseña debe tener entre 8 y 12 caracteres'
		rollback transaction
	end
end
go

--22. PROCEDIMIENTO para  insertar sistema de transporte 
--Autor: Castelan Ramos Carlos
go
create or alter procedure venta.pro_CatMedioTrans
@pNomMedioTrans varchar (20)
as
	begin
		insert into venta.catMedioTrans(nomMedioTrans) values
			(@pNomMedioTrans)
		print 'Añadió correctamente el medio de transporte'
	end
go

--23.  PROCEDIMIENTO para elegir medio de transporte
--Autor: Castelan Ramos Carlos
go
create or alter procedure venta.pro_sisTransporte
@pIdMedioTrans int
as
	begin
		insert into venta.sistTransporte(idMedioTrans) values
			(@pIdMedioTrans)
		print 'Se eligió correctamente el medio de transporte'
	end
go

--24. TRIGGER para asignar a un vendedor su comisión
--Autor: Rivas Solis Carlos Eduardo
create or alter trigger venta.tr_AsignarComision
	on venta.fisica
	after insert
	as
	begin
		declare @vComision int,
				@vIdVendedor int
		set @vComision = ((select montoTotal from venta.compra 
			where idCompra = (select idCompra from inserted))*0.05)
		set @vIdVendedor = (select idVendedor from inserted)
		print concat('El vendedor ', @vIdVendedor,' recibió una comision de ',
			@vComision)
	end
go

--25. TRIGGERr para limpiar la cesta y listas de un usuario
--Autor: Rivas Solis Carlos Eduardo
create or alter trigger venta.tr_ActualizarCestaCompra
	on venta.compra
	after insert
	as
	begin
		update catalogo.cesta
			set cantidadProducto = 0
			where idCesta = (select idCesta from inserted)
		update catalogo.lista
			set cantidad = 0
				where idCesta = (select idCesta from inserted)
	end
go

------------------------------------------------------
