CREATE TABLE [dbo].[Mst_IcOverview_Network] (
    [IcOverviewNetworkId]          INT           IDENTITY (1, 1) NOT NULL,
    [IndependentContractorId]      INT           NOT NULL,
    [IndependentContractorLevelId] INT           NOT NULL,
    [ReportingBadgeNo]             NVARCHAR (50) NULL,
    [IsStaybackTeam]               BIT           NULL,
    [IsGobackTeam]                 BIT           NULL,
    [MarketingCompanyId]           INT           NOT NULL,
    [IsDeleted]                    BIT           NOT NULL,
    [CreatedBy]                    NVARCHAR (50) NULL,
    [CreatedDate]                  DATETIME      NULL,
    [UpdatedBy]                    NVARCHAR (50) NULL,
    [UpdatedDate]                  DATETIME      NULL,
    CONSTRAINT [PK_dbo.Mst_IcOverview_Network] PRIMARY KEY CLUSTERED ([IcOverviewNetworkId] ASC),
    CONSTRAINT [FK_dbo.Mst_IcOverview_Network_dbo.Mst_IndependentContractor_IndependentContractorId] FOREIGN KEY ([IndependentContractorId]) REFERENCES [dbo].[Mst_IndependentContractor] ([IndependentContractorId]),
    CONSTRAINT [FK_dbo.Mst_IcOverview_Network_dbo.Mst_IndependentContractorLevel_IndependentContractorLevelId] FOREIGN KEY ([IndependentContractorLevelId]) REFERENCES [dbo].[Mst_IndependentContractorLevel] ([IndependentContractorLevelId]),
    CONSTRAINT [FK_dbo.Mst_IcOverview_Network_dbo.Mst_MarketingCompany_MarketingCompanyId] FOREIGN KEY ([MarketingCompanyId]) REFERENCES [dbo].[Mst_MarketingCompany] ([MarketingCompanyId])
);


GO
CREATE NONCLUSTERED INDEX [IX_IndependentContractorId]
    ON [dbo].[Mst_IcOverview_Network]([IndependentContractorId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_IndependentContractorLevelId]
    ON [dbo].[Mst_IcOverview_Network]([IndependentContractorLevelId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_MarketingCompanyId]
    ON [dbo].[Mst_IcOverview_Network]([MarketingCompanyId] ASC);

