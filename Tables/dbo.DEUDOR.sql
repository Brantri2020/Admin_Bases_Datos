CREATE TABLE [dbo].[DEUDOR]
(
[CODCLI] [int] NOT NULL,
[CODIGOGARANTE] [int] NOT NULL,
[LIMITECREDITO] [float] NOT NULL,
[SALDODEUDOR] [float] NOT NULL,
[NUMEROCLIENTE] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TR_GARANTE]
on [dbo].[DEUDOR] for insert
as
declare @codDeudor int,
@saldoDeud float
select @codDeudor = NUMEROCLIENTE,
@saldoDeud = SALDODEUDOR
from inserted
if(@saldoDeud>0)
BEGIN
PRINT 'No puede ser garante porque tiene saldo';
END
ELSE
BEGIN
insert into catalogo.CLIENTE Values
(null,null,null,null,null,null,@codDeudor)
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [dbo].[TR_PAGOSALDADO]
on [dbo].[DEUDOR] for delete
as
declare @codCli int, 
@saldo float
select @codCli = CODCLI,
@saldo = SALDODEUDOR
from inserted
delete from DEUDOR 
where CODCLI=@codCli
GO
ALTER TABLE [dbo].[DEUDOR] ADD CONSTRAINT [PK_catalogo.DEUDOR] PRIMARY KEY CLUSTERED  ([CODCLI]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DEUDOR] ADD CONSTRAINT [FK_DEUDOR_CLIENT] FOREIGN KEY ([NUMEROCLIENTE]) REFERENCES [catalogo].[CLIENTE] ([NUMEROCLIENTE])
GO
