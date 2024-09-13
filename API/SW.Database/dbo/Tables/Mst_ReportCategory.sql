CREATE TABLE [dbo].[Mst_ReportCategory] (
    [ReportCategoryId]   INT            IDENTITY (1, 1) NOT NULL,
    [ReportCategoryCode] VARCHAR (50)   NULL,
    [ReportCategorySeq]  INT            NULL,
    [Name]               NVARCHAR (100) NOT NULL,
    [Description]        NVARCHAR (200) NULL,
    [IsActive]           BIT            NULL,
    CONSTRAINT [PK_MST_ReportCategory] PRIMARY KEY CLUSTERED ([ReportCategoryId] ASC) WITH (FILLFACTOR = 90)
);

