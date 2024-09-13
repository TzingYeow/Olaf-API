CREATE TABLE [dbo].[Mst_CountryCallCode_Currency] (
    [CountryId]    INT          IDENTITY (1, 1) NOT NULL,
    [CountryCode]  VARCHAR (5)  NULL,
    [CountryName]  VARCHAR (50) NULL,
    [DialCode]     VARCHAR (8)  NULL,
    [CurrencyCode] VARCHAR (8)  NULL,
    [CurOrdering]  INT          DEFAULT ('999') NOT NULL,
    CONSTRAINT [PK_MST_CountryCallCode_Currency] PRIMARY KEY CLUSTERED ([CountryId] ASC) WITH (FILLFACTOR = 90)
);

