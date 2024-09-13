CREATE TABLE [dbo].[Mst_RecruitmentCandidate_ActivityLog] (
    [RecruitmentCandidateActivityLogId] INT            IDENTITY (1, 1) NOT NULL,
    [RecruitmentCandidateId]            INT            NOT NULL,
    [Stage]                             NVARCHAR (50)  NOT NULL,
    [Description]                       NVARCHAR (50)  NOT NULL,
    [AppointmentStatus]                 NVARCHAR (50)  NOT NULL,
    [UnsuitableStatus]                  NVARCHAR (50)  NULL,
    [NotSucceedReason]                  NVARCHAR (50)  NULL,
    [ScheduleStartDateTime]             DATETIME       NOT NULL,
    [ScheduleEndDateTime]               DATETIME       NOT NULL,
    [MarketingCompanyBranchId]          INT            NULL,
    [Location]                          NVARCHAR (MAX) NULL,
    [LeaderBadgeNo]                     NVARCHAR (MAX) NULL,
    [Remark]                            NVARCHAR (MAX) NULL,
    [IsDeleted]                         BIT            NOT NULL,
    [CreatedBy]                         NVARCHAR (50)  NULL,
    [CreatedDate]                       DATETIME       NULL,
    [UpdatedBy]                         NVARCHAR (50)  NULL,
    [UpdatedDate]                       DATETIME       NULL,
    [ConductedBy]                       NVARCHAR (250) NULL,
    CONSTRAINT [PK_dbo.Mst_RecruitmentCandidate_ActivityLog] PRIMARY KEY CLUSTERED ([RecruitmentCandidateActivityLogId] ASC),
    CONSTRAINT [FK_dbo.Mst_RecruitmentCandidate_ActivityLog_dbo.Mst_MarketingCompany_Branch_MarketingCompanyBranchId] FOREIGN KEY ([MarketingCompanyBranchId]) REFERENCES [dbo].[Mst_MarketingCompany_Branch] ([MarketingCompanyBranchId]),
    CONSTRAINT [FK_dbo.Mst_RecruitmentCandidate_ActivityLog_dbo.Mst_RecruitmentCandidate_RecruitmentCandidateId] FOREIGN KEY ([RecruitmentCandidateId]) REFERENCES [dbo].[Mst_RecruitmentCandidate] ([RecruitmentCandidateId]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_RecruitmentCandidateId]
    ON [dbo].[Mst_RecruitmentCandidate_ActivityLog]([RecruitmentCandidateId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_MarketingCompanyBranchId]
    ON [dbo].[Mst_RecruitmentCandidate_ActivityLog]([MarketingCompanyBranchId] ASC);

