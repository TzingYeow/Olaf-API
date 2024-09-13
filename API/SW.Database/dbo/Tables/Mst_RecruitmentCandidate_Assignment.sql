CREATE TABLE [dbo].[Mst_RecruitmentCandidate_Assignment] (
    [RecruitmentCandidateAssignmentId] INT            IDENTITY (1, 1) NOT NULL,
    [RecruitmentCandidateId]           INT            NOT NULL,
    [CampaignId]                       INT            NOT NULL,
    [StartDate]                        DATETIME       NOT NULL,
    [EndDate]                          DATETIME       NULL,
    [Remark]                           NVARCHAR (MAX) NULL,
    [IsDeleted]                        BIT            NOT NULL,
    [CreatedBy]                        NVARCHAR (50)  NULL,
    [CreatedDate]                      DATETIME       NULL,
    [UpdatedBy]                        NVARCHAR (50)  NULL,
    [UpdatedDate]                      DATETIME       NULL,
    CONSTRAINT [PK_dbo.Mst_RecruitmentCandidate_Assignment] PRIMARY KEY CLUSTERED ([RecruitmentCandidateAssignmentId] ASC),
    CONSTRAINT [FK_dbo.Mst_RecruitmentCandidate_Assignment_dbo.Mst_Campaign_CampaignId] FOREIGN KEY ([CampaignId]) REFERENCES [dbo].[Mst_Campaign] ([CampaignId]) ON DELETE CASCADE,
    CONSTRAINT [FK_dbo.Mst_RecruitmentCandidate_Assignment_dbo.Mst_RecruitmentCandidate_RecruitmentCandidateId] FOREIGN KEY ([RecruitmentCandidateId]) REFERENCES [dbo].[Mst_RecruitmentCandidate] ([RecruitmentCandidateId]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_RecruitmentCandidateId]
    ON [dbo].[Mst_RecruitmentCandidate_Assignment]([RecruitmentCandidateId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_CampaignId]
    ON [dbo].[Mst_RecruitmentCandidate_Assignment]([CampaignId] ASC);

