CREATE TABLE [dbo].[TXN_ReportingBadge_KR] (
    [RowID]                   INT            IDENTITY (1, 1) NOT NULL,
    [WEDate]                  DATE           NULL,
    [DirectReportBadgeNumber] NVARCHAR (20)  NULL,
    [BadgeNo]                 NVARCHAR (20)  NULL,
    [CurrentLevel]            NVARCHAR (20)  NULL,
    [LevelCode]               NVARCHAR (20)  NULL,
    [BadgeNolink]             NVARCHAR (500) NULL
);

