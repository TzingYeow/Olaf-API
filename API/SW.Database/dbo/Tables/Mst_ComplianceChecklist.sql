CREATE TABLE [dbo].[Mst_ComplianceChecklist] (
    [ComplianceChecklistId]               INT            IDENTITY (1, 1) NOT NULL,
    [Description]                         NVARCHAR (255) NOT NULL,
    [CountryCode]                         NVARCHAR (10)  NULL,
    [CampaignId]                          INT            NULL,
    [ComplyDuration]                      INT            NULL,
    [ForRecruitmentCandidate]             BIT            NOT NULL,
    [ForIndependentContractor]            BIT            NOT NULL,
    [IsRequiredUponCandidateConfirmation] BIT            NOT NULL,
    [IsDeleted]                           BIT            NOT NULL,
    [CreatedBy]                           NVARCHAR (50)  NULL,
    [CreatedDate]                         DATETIME       NULL,
    [UpdatedBy]                           NVARCHAR (50)  NULL,
    [UpdatedDate]                         DATETIME       NULL,
    [IsAttachmentRequired]                BIT            DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_dbo.Mst_ComplianceChecklist] PRIMARY KEY CLUSTERED ([ComplianceChecklistId] ASC),
    CONSTRAINT [FK_dbo.Mst_ComplianceChecklist_dbo.Mst_Campaign_CampaignId] FOREIGN KEY ([CampaignId]) REFERENCES [dbo].[Mst_Campaign] ([CampaignId])
);


GO
CREATE NONCLUSTERED INDEX [IX_CampaignId]
    ON [dbo].[Mst_ComplianceChecklist]([CampaignId] ASC);

