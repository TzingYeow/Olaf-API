CREATE TABLE [dbo].[Mst_Weekending] (
    [Id]          NVARCHAR (100) NOT NULL,
    [WEdate]      DATE           NULL,
    [FromDate]    DATE           NULL,
    [ToDate]      DATE           NULL,
    [Status]      BIT            NULL,
    [CreatedBy]   NVARCHAR (50)  NOT NULL,
    [CreatedDate] DATETIME       NOT NULL,
    [UpdatedBy]   NVARCHAR (50)  NULL,
    [UpdatedDate] DATETIME       NULL,
    [MonthEnd]    DATE           NULL,
    [IsMonthEnd]  BIT            NULL,
    CONSTRAINT [PK_Mst_Weekending] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);

