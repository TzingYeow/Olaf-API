CREATE TABLE [dbo].[Mst_MarketingCompany_Campaign] (
    [MarketingCompanyCampaignId] INT           IDENTITY (1, 1) NOT NULL,
    [MarketingCompanyId]         INT           NOT NULL,
    [CampaignId]                 INT           NOT NULL,
    [StartDate]                  DATETIME      NULL,
    [EndDate]                    DATETIME      NULL,
    [IsDeleted]                  BIT           NOT NULL,
    [CreatedBy]                  NVARCHAR (50) NULL,
    [CreatedDate]                DATETIME      NULL,
    [UpdatedBy]                  NVARCHAR (50) NULL,
    [UpdatedDate]                DATETIME      NULL,
    CONSTRAINT [PK_dbo.Mst_MarketingCompany_Campaign] PRIMARY KEY CLUSTERED ([MarketingCompanyCampaignId] ASC),
    CONSTRAINT [FK_dbo.Mst_MarketingCompany_Campaign_dbo.Mst_Campaign_CampaignId] FOREIGN KEY ([CampaignId]) REFERENCES [dbo].[Mst_Campaign] ([CampaignId]) ON DELETE CASCADE,
    CONSTRAINT [FK_dbo.Mst_MarketingCompany_Campaign_dbo.Mst_MarketingCompany_MarketingCompanyId] FOREIGN KEY ([MarketingCompanyId]) REFERENCES [dbo].[Mst_MarketingCompany] ([MarketingCompanyId]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_MarketingCompanyId]
    ON [dbo].[Mst_MarketingCompany_Campaign]([MarketingCompanyId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_CampaignId]
    ON [dbo].[Mst_MarketingCompany_Campaign]([CampaignId] ASC);

