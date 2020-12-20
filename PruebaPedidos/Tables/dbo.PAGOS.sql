CREATE TABLE [dbo].[PAGOS]
(
[CodigoCli] [int] NOT NULL,
[fechaPago] [date] NULL,
[valorPago] [float] NULL,
[numeroCli] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [dbo].[TR_PAGO]
on [dbo].[PAGOS] for insert
as
declare @saldo float, 
@numCli int
select @saldo=valorPago,
@numCli = numeroCli
from inserted
update DEUDOR
set SALDODEUDOR = @saldo
where NUMEROCLIENTE=@numCli
GO
ALTER TABLE [dbo].[PAGOS] ADD CONSTRAINT [PK_PAGOS] PRIMARY KEY CLUSTERED  ([CodigoCli]) ON [PRIMARY]
GO
