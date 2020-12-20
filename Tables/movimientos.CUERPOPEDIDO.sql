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
on [movimientos].[CUERPOPEDIDO] 
for update as
declare @precioUni money, 
@cantidad int, 
@numeroPro int, 
@numeroPed int
select @precioUni = PRECIOUNITARIO, 
@cantidad = CANTIDADPRODUCTO, 
@numeroPro = NUMEROPRODUCTO, 
@numeroPed = NUMEROPEDIDO 
from inserted
update movimientos.cabezacuerpoP 
set PrecioUnit = @precioUni, 
Cantidad = @cantidad 
where NumPedido = @numeroPed 
and NumProducto = @numeroPro
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
on [movimientos].[CUERPOPEDIDO] 
for delete as
declare @precioUni money,
@cantidad int, 
@numeroPro int, 
@numeroPed int
select @precioUni = PRECIOUNITARIO, 
@cantidad = CANTIDADPRODUCTO, 
@numeroPro = NUMEROPRODUCTO, 
@numeroPed = NUMEROPEDIDO 
from deleted
delete from movimientos.cabezacuerpoP 
where PrecioUnit = @precioUni 
and Cantidad = @cantidad 
and NumPedido = @numeroPed 
and NumProducto = @numeroPro
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [movimientos].[TR_InsertProduct]
on [movimientos].[CUERPOPEDIDO] for insert
as
declare @precioUni money, 
@cantidad int,
@numeroProd int,
@numeroPed int
select @precioUni = PRECIOUNITARIO, 
@cantidad = CANTIDADPRODUCTO, 
@numeroProd = NUMEROPRODUCTO,
@numeroPed = NUMEROPEDIDO
from inserted
update movimientos.cabezacuerpoP 
set PrecioUnit = @precioUni,
Cantidad=@cantidad,
NumProducto=@numeroProd
where NumPedido=@numeroPed
GO
