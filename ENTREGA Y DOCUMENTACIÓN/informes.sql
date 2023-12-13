/*
INFORMES
ESTADISTICAS
*/
--Autor: Torres Martinez Marco
--1. FUNCION para ver ¿Qué vendedo realiza más ventas en un periodo? 

create or alter function venta.mejorVendedor
(@fechaInferior date, @fechaSuperior date)
returns varchar(60)
as
begin
	declare @v_vendedor varchar (60), @v_id int, @v_maxVentas int
	if datediff(day, @fechaInferior, @fechaSuperior) < 0
		set @v_vendedor = 'La fecha inicial es mayor que la final'
	else
	begin
		select @v_maxVentas = max(ttu.numVentas) from (
		select f.idVendedor, count(*) as numVentas
		from venta.compra as c
		inner join venta.fisica as f
		on c.idCompra = f.idCompra
		where c.fechaCompra between @fechaInferior and @fechaSuperior
		group by f.idVendedor) as ttu

		select top 1 @v_id = idVendedor from (
		select f.idVendedor, count(*) as numVentas
		from venta.compra as c
		inner join venta.fisica as f
		on c.idCompra = f.idCompra
		where c.fechaCompra between @fechaInferior and @fechaSuperior
		group by f.idVendedor
		having count(*) = @v_maxVentas) as ttd

		select @v_vendedor = 'El mejor vendedor para ese periodo fue '+nombre+' '+apPaterno+' '+apMaterno  from persona.usuario where idUsuario = @v_id
	end
	return @v_vendedor
end


--2. FUNCION para saber ¿Qué productos son los más comprados en un periodo? 
--Autor: Torres Martinez Marco
go
create or alter function venta.mejorProducto
(@fechaInferior date, @fechaSuperior date)
returns table
as
return(
select top 3 ttu.nombreProd, count(*) as numComprasProd from(
select nombreProd
from catalogo.producto as p
inner join catalogo.lista as l
on p.clavePro = l.claveProd
inner join venta.compra as c
on c.idCesta = l.idCesta
where c.fechaCompra between @fechaInferior and @fechaSuperior
) as ttu
group by nombreProd
order by numComprasProd desc
)

--3. FUNCION para SABER ¿Por qué medio se aelizan más venta en un periodo? 
go
create or alter function venta.mejorMedio
(@fechaInferior date, @fechaSuperior date)
returns varchar(50)
as
begin
	declare @v_medio varchar (30), @v_numol int,  @v_numfs int,  @v_mensaje varchar (50)
	if datediff(day, @fechaInferior, @fechaSuperior) < 0
		set @v_medio = 'La fecha inicial es mayor que la final'
	else
	begin
		select @v_numol = count(*)
		from venta.compra as c
		where c.tipoCompra = 'O' and c.fechaCompra between @fechaInferior and @fechaSuperior

		select @v_numfs = count(*)
		from venta.compra as c
		where c.tipoCompra = 'F' and c.fechaCompra between @fechaInferior and @fechaSuperior

		if @v_numol = @v_numfs
		begin
			set @v_medio = 'Ambos son iguales'
		end
		else if @v_numol > @v_numfs
		begin
			set @v_medio = 'Online'
		end
		else
		begin
			set @v_medio = 'Fisico'
		end
		set @v_mensaje = 'Medio con mas compras: '+@v_medio
	end

	return @v_mensaje
end