CREATE TABLE [dbo].[Mst_IndependentContractor_BadgeCard] (
    [IndependentContractorBadgeCardId] INT            IDENTITY (1, 1) NOT NULL,
    [IndependentContractorId]          INT            NOT NULL,
    [CampaignId]                       INT            NULL,
    [SerialNo]                         NVARCHAR (MAX) NULL,
    [BadgeType]                        NVARCHAR (MAX) NOT NULL,
    [IssueDate]                        DATETIME       NOT NULL,
    [ExpiredDate]                      DATETIME       NOT NULL,
    [IsActive]                         BIT            NOT NULL,
    [IsDeleted]                        BIT            NOT NULL,
    [CreatedBy]                        NVARCHAR (50)  NULL,
    [CreatedDate]                      DATETIME       NULL,
    [UpdatedBy]                        NVARCHAR (50)  NULL,
    [UpdatedDate]                      DATETIME       NULL,
    CONSTRAINT [PK_dbo.Mst_IndependentContractor_BadgeCard] PRIMARY KEY CLUSTERED ([IndependentContractorBadgeCardId] ASC),
    CONSTRAINT [FK_dbo.Mst_IndependentContractor_BadgeCard_dbo.Mst_Campaign_CampaignId] FOREIGN KEY ([CampaignId]) REFERENCES [dbo].[Mst_Campaign] ([CampaignId]),
    CONSTRAINT [FK_dbo.Mst_IndependentContractor_BadgeCard_dbo.Mst_IndependentContractor_IndependentContractorId] FOREIGN KEY ([IndependentContractorId]) REFERENCES [dbo].[Mst_IndependentContractor] ([IndependentContractorId]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_IndependentContractorId]
    ON [dbo].[Mst_IndependentContractor_BadgeCard]([IndependentContractorId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_CampaignId]
    ON [dbo].[Mst_IndependentContractor_BadgeCard]([CampaignId] ASC);

