CREATE TABLE [dbo].[TXN_RegionalSalesBonus] (
    [Country]        NVARCHAR (20)   NULL,
    [MOCode]         NVARCHAR (20)   NULL,
    [MOName]         NVARCHAR (100)  NULL,
    [Weekending]     DATE            NULL,
    [RMonth]         NVARCHAR (50)   NULL,
    [RQuarter]       NVARCHAR (50)   NULL,
    [GrossBAEarning] DECIMAL (18, 2) NULL,
    [NetBAEarning]   DECIMAL (18, 2) NULL,
    [SWBonus]        DECIMAL (18, 2) NULL,
    [ConversionRate] DECIMAL (18, 2) NULL,
    [BuletinPoint]   DECIMAL (18, 2) NULL
);

