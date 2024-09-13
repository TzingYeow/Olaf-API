CREATE TABLE [dbo].[Mst_RecruitmentCandidate_Compliance] (
    [RecruitmentCandidateComplianceId] INT           IDENTITY (1, 1) NOT NULL,
    [RecruitmentCandidateId]           INT           NOT NULL,
    [ComplianceChecklistId]            INT           NOT NULL,
    [HasComplied]                      BIT           NOT NULL,
    [IsDeleted]                        BIT           NOT NULL,
    [CreatedBy]                        NVARCHAR (50) NULL,
    [CreatedDate]                      DATETIME      NULL,
    [UpdatedBy]                        NVARCHAR (50) NULL,
    [UpdatedDate]                      DATETIME      NULL,
    CONSTRAINT [PK_dbo.Mst_RecruitmentCandidate_Compliance] PRIMARY KEY CLUSTERED ([RecruitmentCandidateComplianceId] ASC),
    CONSTRAINT [FK_dbo.Mst_RecruitmentCandidate_Compliance_dbo.Mst_ComplianceChecklist_ComplianceChecklistId] FOREIGN KEY ([ComplianceChecklistId]) REFERENCES [dbo].[Mst_ComplianceChecklist] ([ComplianceChecklistId]),
    CONSTRAINT [FK_dbo.Mst_RecruitmentCandidate_Compliance_dbo.Mst_RecruitmentCandidate_RecruitmentCandidateId] FOREIGN KEY ([RecruitmentCandidateId]) REFERENCES [dbo].[Mst_RecruitmentCandidate] ([RecruitmentCandidateId]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_RecruitmentCandidateId]
    ON [dbo].[Mst_RecruitmentCandidate_Compliance]([RecruitmentCandidateId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ComplianceChecklistId]
    ON [dbo].[Mst_RecruitmentCandidate_Compliance]([ComplianceChecklistId] ASC);

