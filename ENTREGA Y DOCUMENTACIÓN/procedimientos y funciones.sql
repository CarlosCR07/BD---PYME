
--PROCEDMIENTO PARA DAR DE ALTA USUARIOS
procedure persona.pro_RegistroUsario --Administrador

--PROCEDIMIENTO PARA VER INVENTARIO
procedure catalogo.pro_IventariarProductos--Administrador 

--PROCEDIMIENTO PARA ABASTECER PRODUCTOS
procedure catalogo.pro_AbastecerProductos --Adiministrador

--PROCEDIMIENTO PARA VISUALIZAR PRODUTOS ORDENADOS POR CATEGORIA
procedure catalogo.pro_ProductoCategoria --Todos

--PROCEDIMIENTO PARA BUSCAR PRODUCTO POR NOMBRE, DESCRIPCION, CATEGORIA O SUBCATEGORIA
procedure catalogo.pro_BusquedaProducto --Todos

--PROCEDIMIENTO PARA CREAR WISHLIST
procedure persona.pro_CrearWishlist --Cliente y Administrador

--PROCEDIMIENTO PARA SUSCRIBIRSE A PRODUCTO
procedure persona.pro_Suscribir --Cliente y Administrador

--PROCEDIMIENTO  PARA GUARDAR PRODUCTO EN LISTA
procedure catalogo.pro_ClienteListaCesta --Cliente y administrador

--PROCEDIMIENTO PARA BORRADO DE CESAT Y LISTAS CON MAS DE 15 DIAS
procedure catalogo.pro_BorradoPermanencia --Administrador

--PROCEDIMIENTO PARA CREAR TIPOS DE OFERTAS
procedure promocion.pro_CrearTipoOferta --Administrador

--PROCEDIMIENTO PARA CREAR OFERTAS
procedure promocion.pro_CrearOferta --Administrador

--PROCEDIMIENTO PARA CREAR REBAJA
procedure promocion.pro_CrearRebaja --Administrador

--PROCEDIMIENTO PARA REALIZAR COMPRA ONLINE
procedure venta.pr_RealizarCompraOnline--Cliente y administrador

--PROCEDIMIENTO PARA REALIZAR COMPRA FISICA 
procedure venta.pr_RealizarCompraFisica--Cliente y administrador

--PROCEDIMIENTO PARA REALIZAR EL BORRADO DE UNA OFERTA DE MAS DE 40 DIAS
procedure promocion.pro_BorradoOferta--Administrador

--PROCEDIMIENTO PARA REALIZAR UNA CANCELACION CON 15% DE MULTA SI ES MAYOR A 48HRS
procedure venta.Cancelacion--Administrador

--PROCEDIMIENTO PARA ASIGNAR CATEGORIAS DE MEDIO DE TRANSPORTES
procedure venta.pro_CatMedioTrans--Administrador

--PROCEDIMIENTO PARA ELEGIR MEDIO DE TRANSPORTE
procedure venta.pro_sisTransporte--Administrador




--		FUNCIONES
--FUNCION PARA VER QUE VENDEDOR REALIZA MÁS VENTAS
function venta.mejorVendedor--Administrador


--FUNCION PARA CER EN QUE EPOCA SE REALIZA MAS VENTAS
function venta.mejorTemporada()

--FUNCION PARA VER QUE PRODUCTOS SON LOS MAS COMPRADOS EN UNA TEMPORADA
function venta.mejorProducto


--FUNCION PATA VER EN QUE MEDIO SE REALIZAN MAS VENTAS EN UN PERIODO
function venta.mejorMedio



--FUNCION 