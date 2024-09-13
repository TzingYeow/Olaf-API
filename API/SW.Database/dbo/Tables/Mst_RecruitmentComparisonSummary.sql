CREATE TABLE [dbo].[Mst_RecruitmentComparisonSummary] (
    [RecruitmentComparisonSummaryId]             INT            IDENTITY (1, 1) NOT NULL,
    [MarketingCompanyId]                         INT            NOT NULL,
    [OwnerIndependentContractorId]               INT            NOT NULL,
    [Channel]                                    NVARCHAR (100) NOT NULL,
    [RecruiterNameOrBadgeNo]                     NVARCHAR (150) NOT NULL,
    [CountryCode]                                NVARCHAR (10)  NOT NULL,
    [WeekendingDate]                             DATETIME       NOT NULL,
    [OrRecruitmentInterviewBookCount]            INT            NOT NULL,
    [OrRecruitmentInterviewTurnedUpCount]        INT            NOT NULL,
    [OrRecruitmentInterviewTurnedUpPercentage]   FLOAT (53)     NULL,
    [PrRecruitmentInterviewBookCount]            INT            NOT NULL,
    [PrRecruitmentInterviewTurnedUpCount]        INT            NOT NULL,
    [PrRecruitmentInterviewTurnedUpPercentage]   FLOAT (53)     NULL,
    [OrRecruitmentObservationBookCount]          INT            NOT NULL,
    [OrRecruitmentObservationTurnedUpCount]      INT            NOT NULL,
    [OrRecruitmentObservationTurnedUpPercentage] FLOAT (53)     NULL,
    [PrRecruitmentObservationBookCount]          INT            NOT NULL,
    [PrRecruitmentObservationTurnedUpCount]      INT            NOT NULL,
    [PrRecruitmentObservationTurnedUpPercentage] FLOAT (53)     NULL,
    [OrRecruitmentTrainingBookCount]             INT            NOT NULL,
    [OrRecruitmentTrainingTurnedUpCount]         INT            NOT NULL,
    [OrRecruitmentTrainingTurnedUpPercentage]    FLOAT (53)     NULL,
    [PrRecruitmentTrainingBookCount]             INT            NOT NULL,
    [PrRecruitmentTrainingTurnedUpCount]         INT            NOT NULL,
    [PrRecruitmentTrainingTurnedUpPercentage]    FLOAT (53)     NULL,
    [OrIdBadgeIsssuedCount]                      INT            NOT NULL,
    [PrIdBadgeIsssuedCount]                      INT            NOT NULL,
    [OrTotalHeadCount]                           INT            NOT NULL,
    [PrTotalHeadCount]                           INT            NOT NULL,
    [OrLeaderHeadCount]                          INT            NOT NULL,
    [PrLeaderHeadCount]                          INT            NOT NULL,
    [OrLeaderAdvancementCount]                   INT            NOT NULL,
    [PrLeaderAdvancementCount]                   INT            NOT NULL,
    [OrLeaderTerminationCount]                   INT            NOT NULL,
    [PrLeaderTerminationCount]                   INT            NOT NULL,
    [OrNonLeaderTerminationCount]                INT            NOT NULL,
    [PrNonLeaderTerminationCount]                INT            NOT NULL,
    [IsDeleted]                                  BIT            NOT NULL,
    [CreatedBy]                                  NVARCHAR (50)  NULL,
    [CreatedDate]                                DATETIME       NULL,
    [UpdatedBy]                                  NVARCHAR (50)  NULL,
    [UpdatedDate]                                DATETIME       NULL,
    CONSTRAINT [PK_dbo.Mst_RecruitmentComparisonSummary] PRIMARY KEY CLUSTERED ([RecruitmentComparisonSummaryId] ASC),
    CONSTRAINT [FK_dbo.Mst_RecruitmentComparisonSummary_dbo.Mst_IndependentContractor_OwnerIndependentContractorId] FOREIGN KEY ([OwnerIndependentContractorId]) REFERENCES [dbo].[Mst_IndependentContractor] ([IndependentContractorId]),
    CONSTRAINT [FK_dbo.Mst_RecruitmentComparisonSummary_dbo.Mst_MarketingCompany_MarketingCompanyId] FOREIGN KEY ([MarketingCompanyId]) REFERENCES [dbo].[Mst_MarketingCompany] ([MarketingCompanyId])
);


GO
CREATE NONCLUSTERED INDEX [IX_MarketingCompanyId]
    ON [dbo].[Mst_RecruitmentComparisonSummary]([MarketingCompanyId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_OwnerIndependentContractorId]
    ON [dbo].[Mst_RecruitmentComparisonSummary]([OwnerIndependentContractorId] ASC);

