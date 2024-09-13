CREATE TABLE [dbo].[Mst_IndependentContractor_ReportingNoChanges] (
    [IndependentContractorReportingNoChangesId] INT            IDENTITY (1, 1) NOT NULL,
    [IndependentContractorId]                   INT            NOT NULL,
    [CurrentReportingBadgeNo]                   NVARCHAR (MAX) NULL,
    [NewReportingBadgeNo]                       NVARCHAR (MAX) NOT NULL,
    [HasChanged]                                BIT            NOT NULL,
    [IndependentContractorBranchOutId]          INT            NULL,
    [EffectiveDate]                             DATETIME       NOT NULL,
    [EndDate]                                   DATETIME       NULL,
    [IsDeleted]                                 BIT            NOT NULL,
    [CreatedBy]                                 NVARCHAR (50)  NULL,
    [CreatedDate]                               DATETIME       NULL,
    [UpdatedBy]                                 NVARCHAR (50)  NULL,
    [UpdatedDate]                               DATETIME       NULL,
    CONSTRAINT [PK_Mst_IndependentContractor_ReportingNoChanges] PRIMARY KEY CLUSTERED ([IndependentContractorReportingNoChangesId] ASC),
    CONSTRAINT [FK_dbo.Mst_IndependentContractor_ReportingNoChanges_dbo.Mst_IndependentContractor_BranchOut_IndependentContractorBranchOutId] FOREIGN KEY ([IndependentContractorBranchOutId]) REFERENCES [dbo].[Mst_IndependentContractor_BranchOut] ([IndependentContractorBranchOutId]),
    CONSTRAINT [FK_dbo.Mst_IndependentContractor_ReportingNoChanges_dbo.Mst_IndependentContractor_IndependentContractorId] FOREIGN KEY ([IndependentContractorId]) REFERENCES [dbo].[Mst_IndependentContractor] ([IndependentContractorId])
);


GO
CREATE NONCLUSTERED INDEX [IX_IndependentContractorId]
    ON [dbo].[Mst_IndependentContractor_ReportingNoChanges]([IndependentContractorId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_IndependentContractorBranchOutId]
    ON [dbo].[Mst_IndependentContractor_ReportingNoChanges]([IndependentContractorBranchOutId] ASC);

