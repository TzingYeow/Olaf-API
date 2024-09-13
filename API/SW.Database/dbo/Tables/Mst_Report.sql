CREATE TABLE [dbo].[Mst_Report] (
    [ReportId]           INT            IDENTITY (1, 1) NOT NULL,
    [ReportRDL]          VARCHAR (50)   NULL,
    [ReportSeq]          INT            NOT NULL,
    [ReportCategoryCode] VARCHAR (50)   NOT NULL,
    [ServerPath]         VARCHAR (200)  NOT NULL,
    [Name]               NVARCHAR (100) NOT NULL,
    [Description]        NVARCHAR (200) NULL,
    [IsActive]           BIT            NULL,
    CONSTRAINT [PK_MST_Report] PRIMARY KEY CLUSTERED ([ReportId] ASC) WITH (FILLFACTOR = 90)
);

