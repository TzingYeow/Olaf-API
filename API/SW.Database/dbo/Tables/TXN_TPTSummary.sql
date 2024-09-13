CREATE TABLE [dbo].[TXN_TPTSummary] (
    [SummaryID]      INT             IDENTITY (1, 1) NOT NULL,
    [WeDate]         DATE            NULL,
    [CountryCode]    NVARCHAR (10)   NULL,
    [MCCode]         NVARCHAR (10)   NULL,
    [MCName]         NVARCHAR (150)  NULL,
    [BadgeNo]        NVARCHAR (20)   NULL,
    [BAName]         NVARCHAR (300)  NULL,
    [CurrentLevel]   NVARCHAR (10)   NULL,
    [BadgeNoLink]    NVARCHAR (500)  NULL,
    [TeamProduction] DECIMAL (18, 2) NULL,
    [Campaign]       NVARCHAR (100)  NULL,
    [NetValue]       DECIMAL (18, 2) NULL,
    [Point]          DECIMAL (18, 2) NULL,
    [Ranking]        INT             NULL,
    [Level]          NVARCHAR (50)   NULL,
    [Rate]           DECIMAL (18, 2) NULL,
    CONSTRAINT [PK_TXN_TPTSummary] PRIMARY KEY CLUSTERED ([SummaryID] ASC)
);

