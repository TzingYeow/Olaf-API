CREATE TABLE [dbo].[Mst_RecruitmentCandidate_Induction] (
    [RecruitmentCandidateInductionId] INT            IDENTITY (1, 1) NOT NULL,
    [RecruitmentCandidateId]          INT            NOT NULL,
    [CampaignId]                      INT            NULL,
    [StartDate]                       DATETIME       NOT NULL,
    [EndDate]                         DATETIME       NULL,
    [TrainingFee]                     NVARCHAR (MAX) NOT NULL,
    [Remark]                          NVARCHAR (MAX) NULL,
    [IsDeleted]                       BIT            NOT NULL,
    [CreatedBy]                       NVARCHAR (50)  NULL,
    [CreatedDate]                     DATETIME       NULL,
    [UpdatedBy]                       NVARCHAR (50)  NULL,
    [UpdatedDate]                     DATETIME       NULL,
    CONSTRAINT [PK_dbo.Mst_RecruitmentCandidate_Induction] PRIMARY KEY CLUSTERED ([RecruitmentCandidateInductionId] ASC),
    CONSTRAINT [FK_dbo.Mst_RecruitmentCandidate_Induction_dbo.Mst_Campaign_CampaignId] FOREIGN KEY ([CampaignId]) REFERENCES [dbo].[Mst_Campaign] ([CampaignId]),
    CONSTRAINT [FK_dbo.Mst_RecruitmentCandidate_Induction_dbo.Mst_RecruitmentCandidate_RecruitmentCandidateId] FOREIGN KEY ([RecruitmentCandidateId]) REFERENCES [dbo].[Mst_RecruitmentCandidate] ([RecruitmentCandidateId]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_RecruitmentCandidateId]
    ON [dbo].[Mst_RecruitmentCandidate_Induction]([RecruitmentCandidateId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_CampaignId]
    ON [dbo].[Mst_RecruitmentCandidate_Induction]([CampaignId] ASC);

