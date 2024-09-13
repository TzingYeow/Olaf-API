CREATE TABLE [dbo].[TXN_WeeklyBASummary] (
    [WeDate]                  DATE            NULL,
    [CountryCode]             NVARCHAR (10)   NULL,
    [MCCode]                  NVARCHAR (10)   NULL,
    [IndependentContractorID] INT             NULL,
    [BadgeNo]                 NVARCHAR (20)   NULL,
    [CurrentLevel]            NVARCHAR (10)   NULL,
    [WELevel]                 NVARCHAR (10)   NULL,
    [BadgeNoLink]             NVARCHAR (500)  NULL,
    [DirectReportBadgeNo]     NVARCHAR (10)   NULL,
    [LevelPromotionDate]      DATE            NULL,
    [NetPoint]                DECIMAL (18, 4) NULL,
    [NetValue]                DECIMAL (18, 2) NULL,
    [NetPcs]                  INT             NULL,
    [SubPcs]                  INT             NULL,
    [CreatedDate]             DATETIME        NULL,
    [UpdatedDate]             DATETIME        NULL,
    [IsDeleted]               BIT             NULL
);

