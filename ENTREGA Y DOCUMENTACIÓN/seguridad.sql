/*
SEGURIDAD
*/
--Autor: Marco Torres Martinez y asociados
use PYME0
go
CREATE or ALTER TRIGGER persona.procSeguridad
on persona.usuario
after insert
as 
begin
	declare 
		@usuario varchar(40),
		@contrasena varchar(40),
		@newUserCommand varchar(256),
		@newUserCommand2 varchar(256),
		@newUserCommand3 varchar(256),
		@tipo char

		select @usuario = nomUsuario from inserted
		select @contrasena = contrasena from inserted
		select @tipo = tipoUsr from inserted

		set @newUserCommand = 'create login '+@usuario+' with password ='''+@contrasena+''',
		default_database = PYME0,  CHECK_EXPIRATION=OFF'
	
		execute (@newUserCommand)
	
		set @newUserCommand2 = CONCAT('CREATE USER "',@usuario,'" for login "',@usuario,'"')
	
		execute (@newUserCommand2)


		if @tipo = 'C'
			begin
				set @newUserCommand3 = 'alter role cliente add member '+@usuario
			end
		else if @tipo = 'V'
			begin 
				set @newUserCommand3 = 'alter role vendedor add member '+@usuario
			end
		else if @tipo = 'A'
			begin 
				set @newUserCommand3 = 'alter role administrador add member '+@usuario
			end
		execute(@newUserCommand3)
end
go

-- Roles

create role cliente
go 
create role invitado
go
create role administrador 
go
create role vendedor
go 

--Despuès 
-- Permisos

grant execute on object ::persona.pro_RegistroUsario to administrador
go

grant execute on object ::catalogo.pro_IventariarProductos to administrador
go

grant execute on object ::catalogo.pro_AbastecerProductos to administrador
go

grant execute on object ::catalogo.pro_ProductoCategoria to administrador, cliente, vendedor, invitado
go

grant execute on object ::catalogo.pro_BusquedaProducto to administrador, cliente, vendedor, invitado
go

grant execute on object ::persona.pro_CrearWishlist to cliente
go

grant execute on object ::persona.pro_Suscribir to cliente
go

grant execute on object ::catalogo.pro_ClienteListaCesta to cliente
go

grant execute on object ::catalogo.pro_BorradoPermanencia to administrador
go

grant execute on object ::promocion.pro_CrearTipoOferta to administrador
go

grant execute on object ::promocion.pro_CrearOferta to administrador
go

grant execute on object ::promocion.pro_CrearRebaja to administrador
go

grant execute on object ::venta.pr_RealizarCompraOnline to cliente
go

grant execute on object ::venta.pr_RealizarCompraFisica to cliente
go

grant execute on object ::promocion.pro_BorradoOferta to administrador
go

grant execute on object ::venta.Cancelacion to administrador
go

grant execute on object ::venta.pro_CatMedioTrans to administrador
go

grant execute on object ::venta.pro_sisTransporte to administrador
go

grant select, insert, delete, update on schema :: persona to administrador
go

grant select, insert, delete, update on schema :: venta to administrador
go

grant select, insert, delete, update on schema :: catalogo to administrador
go

grant select, insert, delete, update on schema :: promocion to administrador
go

grant select, update on object :: catalogo.producto to vendedor
go

grant select, update on object :: venta.fisica to vendedor
go
