DROP TABLE [dbo].[KURS];
GO
CREATE TABLE [dbo].[KURS] (
    [Id]        INT          IDENTITY (1, 1) NOT NULL,
    [KURS_DATE] DATE         NOT NULL,
    [CURR_CODE] NVARCHAR (3) NOT NULL,
    [RATE]      MONEY        NOT NULL,
    [FORC]      INT          NOT NULL,
    CONSTRAINT [PK_KURS] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_KURS_FORC] CHECK ([FORC]>(0)),
    CONSTRAINT [CK_KURS_RATE] CHECK ([RATE]>(0))
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_KURS]
    ON [dbo].[KURS]([KURS_DATE] ASC, [CURR_CODE] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'KURS', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Дата курса', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'KURS', @level2type = N'COLUMN', @level2name = N'KURS_DATE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Код валюты', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'KURS', @level2type = N'COLUMN', @level2name = N'CURR_CODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Курс', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'KURS', @level2type = N'COLUMN', @level2name = N'RATE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Курс за', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'KURS', @level2type = N'COLUMN', @level2name = N'FORC';
GO

DROP PROCEDURE [dbo].[SET_KURS];
GO
CREATE PROCEDURE [dbo].[SET_KURS]
	@kurs_date date,
	@curr_code nvarchar(3),
	@rate money,
	@forc int
AS
    insert into [dbo].[KURS] (kurs_date, curr_code, rate, forc) values (@kurs_date, @curr_code, @rate, @forc);
GO

DROP FUNCTION [dbo].[GET_KURS];
GO
CREATE FUNCTION [dbo].[GET_KURS]
(
	@kurs_date date,
	@curr_code nvarchar(3)	
)
RETURNS FLOAT
AS
BEGIN
    DECLARE @p_rezult money;		
    
	SELECT @p_rezult = MAX(k.RATE / k.FORC) FROM [dbo].[KURS] k WHERE k.KURS_DATE = @kurs_date and k.CURR_CODE = @curr_code
	
	RETURN @p_rezult;
END
GO