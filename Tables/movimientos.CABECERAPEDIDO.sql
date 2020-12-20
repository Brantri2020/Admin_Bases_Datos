CREATE TABLE [movimientos].[CABECERAPEDIDO]
(
[NUMEROPEDIDO] [int] NOT NULL,
[NUMEROCLIENTE] [int] NULL,
[FECHAPEDIDO] [date] NULL,
[TIPOPED] [varchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[MONTOTOTAL] [float] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [movimientos].[TR_DEUDOR]
on [movimientos].[CABECERAPEDIDO] for update
as
declare @tipoPed varchar, 
@montoTotal float, 
@numCli int
select @tipoPed = TIPOPED,
@montoTotal = MONTOTOTAL, 
@numCli = NUMEROCLIENTE
from inserted
if(@tipoPed='Credito')
BEGIN
insert into dbo.DEUDOR Values
(@numCli,null,null,null,@numCli)
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [movimientos].[TR_InsertPedido]
on [movimientos].[CABECERAPEDIDO] for insert
as
declare @numPed int, 
@fechPed date, 
@numCli int
select @numPed = NUMEROPEDIDO, 
@fechPed = FECHAPEDIDO, 
@numCli = NUMEROCLIENTE 
from
inserted
insert into movimientos.cabezacuerpoP Values
(@numPed,@fechPed,@numCli,null,null,null)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [movimientos].[TR_PedidoActualizado]
on [movimientos].[CABECERAPEDIDO] 
for update as declare @numeroPed int, 
@fechaPed date, 
@numeroCli int
select @numeroPed = NUMEROPEDIDO, 
@fechaPed = FECHAPEDIDO, 
@numeroCli = NUMEROCLIENTE 
from inserted
update movimientos.cabezacuerpoP 
set FechaPedido = @fechaPed 
where NumPedido = @numeroPed
and NumCliente = @numeroCli
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [movimientos].[TR_PedidoEliminado]
on [movimientos].[CABECERAPEDIDO] 
for delete as
declare @numeroPed int, 
@fechaPed date, 
@numeroCli int
select @numeroPed = NUMEROPEDIDO, 
@fechaPed = FECHAPEDIDO, 
@numeroCli = NUMEROCLIENTE 
from deleted
delete from movimientos.cabezacuerpoP 
where FechaPedido = @fechaPed 
and NumPedido = @numeroPed 
and NumCliente = @numeroCli
GO
ALTER TABLE [movimientos].[CABECERAPEDIDO] ADD CONSTRAINT [CK_TIPOPED] CHECK (([TIPOPED]='Credito' OR [TIPOPED]='Contado'))
GO
ALTER TABLE [movimientos].[CABECERAPEDIDO] ADD CONSTRAINT [PK_CABECERAPEDIDO] PRIMARY KEY CLUSTERED  ([NUMEROPEDIDO]) ON [PRIMARY]
GO
