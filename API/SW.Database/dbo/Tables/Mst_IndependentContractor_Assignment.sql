CREATE TABLE [dbo].[Mst_IndependentContractor_Assignment] (
    [IndependentContractorAssigmentId] INT            IDENTITY (1, 1) NOT NULL,
    [IndependentContractorId]          INT            NOT NULL,
    [CampaignId]                       INT            NOT NULL,
    [StartDate]                        DATETIME       NULL,
    [EndDate]                          DATETIME       NULL,
    [ClientBadgeId]                    NVARCHAR (MAX) NULL,
    [Remark]                           NVARCHAR (255) NULL,
    [IsDeleted]                        BIT            NOT NULL,
    [CreatedBy]                        NVARCHAR (50)  NULL,
    [CreatedDate]                      DATETIME       NULL,
    [UpdatedBy]                        NVARCHAR (50)  NULL,
    [UpdatedDate]                      DATETIME       NULL,
    CONSTRAINT [PK_dbo.Mst_IndependentContractor_Assignment] PRIMARY KEY CLUSTERED ([IndependentContractorAssigmentId] ASC),
    CONSTRAINT [FK_dbo.Mst_IndependentContractor_Assignment_dbo.Mst_Campaign_CampaignId] FOREIGN KEY ([CampaignId]) REFERENCES [dbo].[Mst_Campaign] ([CampaignId]) ON DELETE CASCADE,
    CONSTRAINT [FK_dbo.Mst_IndependentContractor_Assignment_dbo.Mst_IndependentContractor_IndependentContractorId] FOREIGN KEY ([IndependentContractorId]) REFERENCES [dbo].[Mst_IndependentContractor] ([IndependentContractorId]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_IndependentContractorId]
    ON [dbo].[Mst_IndependentContractor_Assignment]([IndependentContractorId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_CampaignId]
    ON [dbo].[Mst_IndependentContractor_Assignment]([CampaignId] ASC);


GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]
    ON [dbo].[Mst_IndependentContractor_Assignment]([IsDeleted] ASC, [EndDate] ASC)
    INCLUDE([IndependentContractorId], [CampaignId]);


GO
CREATE NONCLUSTERED INDEX [<IX_IsDeleted_CampaignId_StartDate]
    ON [dbo].[Mst_IndependentContractor_Assignment]([IsDeleted] ASC, [EndDate] ASC)
    INCLUDE([IndependentContractorId], [CampaignId]);


GO
CREATE NONCLUSTERED INDEX [IX_IsDeleted_CampaignId_StartDate >]
    ON [dbo].[Mst_IndependentContractor_Assignment]([IsDeleted] ASC)
    INCLUDE([CampaignId], [StartDate]);


GO
CREATE NONCLUSTERED INDEX [IX_IsDeleted_CampaignId_StartDate2 >]
    ON [dbo].[Mst_IndependentContractor_Assignment]([IsDeleted] ASC)
    INCLUDE([CampaignId], [StartDate]);

