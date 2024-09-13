CREATE TABLE [dbo].[Mst_ReportRole] (
    [ReportId] INT            NOT NULL,
    [RoleId]   NVARCHAR (100) NOT NULL,
    CONSTRAINT [PK_Mst_ReportRole] PRIMARY KEY CLUSTERED ([ReportId] ASC, [RoleId] ASC) WITH (FILLFACTOR = 90)
);

