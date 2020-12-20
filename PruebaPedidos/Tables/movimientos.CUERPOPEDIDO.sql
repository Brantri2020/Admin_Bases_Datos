CREATE TABLE [movimientos].[CUERPOPEDIDO]
(
[NUMEROPEDIDO] [int] NULL,
[NUMEROPRODUCTO] [int] NULL,
[CANTIDADPRODUCTO] [int] NOT NULL,
[PRECIOUNITARIO] [numeric] (8, 2) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [movimientos].[TR_CuerpoPedActualizado]
on [movimientos].[CUERPOPEDIDO] for update
as
declare @pre_uni money, @cant int, @num_pro int, @num_pedi int
select @pre_uni = PRECIOUNITARIO, @cant = CANTIDADPRODUCTO, @num_pro = NUMEROPRODUCTO, @num_pedi =
NUMEROPEDIDO from inserted
update movimientos.cabezacuerpoP set PrecioUnit = @pre_uni, Cantidad = @cant where
NumPedido = @num_pedi and NumProducto = @num_pro
UPDATE dispositivos.TotalArticulos SET TotalPedidos =TotalPedidos-@cant WHERE IdArticulo =
@num_pro
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [movimientos].[TR_DETALLE]
on [movimientos].[CUERPOPEDIDO] for insert
as
declare @numPed int, 
@montoTotal float
select @numPed = NUMEROPEDIDO,
@montoTotal = PRECIOUNITARIO*CANTIDADPRODUCTO
from inserted
insert into movimientos.CABECERAPEDIDO Values
(@numPed,null,null,null,@montoTotal)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [movimientos].[TR_DetalleEliminado]
on [movimientos].[CUERPOPEDIDO] for delete
as
declare @pre_uni money, @cant int, @num_pro int, @num_pedi int
select @pre_uni = PRECIOUNITARIO, @cant = CANTIDADPRODUCTO, @num_pro = NUMEROPRODUCTO, @num_pedi =
NUMEROPEDIDO from deleted
delete from movimientos.cabezacuerpoP where PrecioUnit = @pre_uni and Cantidad = @cant and
NumPedido = @num_pedi and NumProducto = @num_pro
UPDATE dispositivos.TotalArticulos SET TotalPedidos = TotalPedidos - @cant WHERE
IdArticulo=@num_pro

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [movimientos].[TR_InsertProduct]
on [movimientos].[CUERPOPEDIDO] for insert
as
declare @pre_uni money, @cant int, @num_pro int, @num_ped int, @num_cli int, @lim_cred money,
@sal_deu money
select @pre_uni = PRECIOUNITARIO, @cant = CANTIDADPRODUCTO, @num_pro = NUMEROPRODUCTO, @num_ped =
NUMEROPEDIDO from inserted
select @num_cli = (select NUMEROCLIENTE from movimientos.CABECERAPEDIDO where NUMEROPEDIDO =
@num_ped)
select @lim_cred = (select LIMITECREDITO from catalogo.CLIENTE where NUMEROCLIENTE = @num_cli)
select @sal_deu = (select SALDODEUDOR from dbo.DEUDOR where NUMEROCLIENTE = @num_cli)
update movimientos.CABECERAPEDIDO set MONTOTOTAL = MONTOTOTAL + (@cant * @pre_uni) where
NUMEROPEDIDO = @num_ped
IF (@lim_cred - @sal_deu) >= @cant * @pre_uni
BEGIN
update dbo.DEUDOR set SALDODEUDOR = SALDODEUDOR + (@cant * @pre_uni) where NUMEROCLIENTE =
@num_cli
IF EXISTS (SELECT * FROM dispositivos.TotalArticulos WHERE IdArticulo = @num_pro)
BEGIN
UPDATE dispositivos.TotalArticulos SET TotalPedidos = TotalPedidos+@cant WHERE IdArticulo =
@num_pro
END
ELSE
BEGIN
INSERT INTO dispositivos.TotalArticulos VALUES (@num_pro,@cant)
END
END
ELSE
BEGIN
ROLLBACK TRANSACTION
END
GO
