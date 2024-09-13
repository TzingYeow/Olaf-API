CREATE TABLE [dbo].[Mst_IcOverview_Headcount] (
    [IcOverviewHeadcountId]        INT           IDENTITY (1, 1) NOT NULL,
    [MarketingCompanyId]           INT           NOT NULL,
    [RecruitmentType]              NVARCHAR (50) NOT NULL,
    [IndependentContractorLevelId] INT           NOT NULL,
    [Status]                       NVARCHAR (50) NOT NULL,
    [HeadCount]                    INT           NOT NULL,
    [IsDeleted]                    BIT           NOT NULL,
    [CreatedBy]                    NVARCHAR (50) NULL,
    [CreatedDate]                  DATETIME      NULL,
    [UpdatedBy]                    NVARCHAR (50) NULL,
    [UpdatedDate]                  DATETIME      NULL,
    CONSTRAINT [PK_dbo.Mst_IcOverview_Headcount] PRIMARY KEY CLUSTERED ([IcOverviewHeadcountId] ASC),
    CONSTRAINT [FK_dbo.Mst_IcOverview_Headcount_dbo.Mst_IndependentContractorLevel_IndependentContractorLevelId] FOREIGN KEY ([IndependentContractorLevelId]) REFERENCES [dbo].[Mst_IndependentContractorLevel] ([IndependentContractorLevelId]),
    CONSTRAINT [FK_dbo.Mst_IcOverview_Headcount_dbo.Mst_MarketingCompany_MarketingCompanyId] FOREIGN KEY ([MarketingCompanyId]) REFERENCES [dbo].[Mst_MarketingCompany] ([MarketingCompanyId])
);


GO
CREATE NONCLUSTERED INDEX [IX_MarketingCompanyId]
    ON [dbo].[Mst_IcOverview_Headcount]([MarketingCompanyId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_IndependentContractorLevelId]
    ON [dbo].[Mst_IcOverview_Headcount]([IndependentContractorLevelId] ASC);

