CREATE TABLE [dbo].[Mst_IndependentContractor_Compliance] (
    [IndependentContractorComplianceId] INT            IDENTITY (1, 1) NOT NULL,
    [IndependentContractorId]           INT            NOT NULL,
    [ComplianceChecklistId]             INT            NOT NULL,
    [HasComplied]                       BIT            NOT NULL,
    [IsDeleted]                         BIT            NOT NULL,
    [CreatedBy]                         NVARCHAR (50)  NULL,
    [CreatedDate]                       DATETIME       NULL,
    [UpdatedBy]                         NVARCHAR (50)  NULL,
    [UpdatedDate]                       DATETIME       NULL,
    [ComplianceEffectiveDate]           DATETIME       NULL,
    [AttachmentPath]                    NVARCHAR (MAX) NULL,
    [ComplianceAttemptCount]            INT            NULL,
    [UploadedBy]                        NVARCHAR (50)  NULL,
    [UploadedDate]                      DATETIME       NULL,
    CONSTRAINT [PK_dbo.Mst_IndependentContractor_Compliance] PRIMARY KEY CLUSTERED ([IndependentContractorComplianceId] ASC),
    CONSTRAINT [FK_dbo.Mst_IndependentContractor_Compliance_dbo.Mst_ComplianceChecklist_ComplianceChecklistId] FOREIGN KEY ([ComplianceChecklistId]) REFERENCES [dbo].[Mst_ComplianceChecklist] ([ComplianceChecklistId]),
    CONSTRAINT [FK_dbo.Mst_IndependentContractor_Compliance_dbo.Mst_IndependentContractor_IndependentContractorId] FOREIGN KEY ([IndependentContractorId]) REFERENCES [dbo].[Mst_IndependentContractor] ([IndependentContractorId])
);


GO
CREATE NONCLUSTERED INDEX [IX_IndependentContractorId]
    ON [dbo].[Mst_IndependentContractor_Compliance]([IndependentContractorId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ComplianceChecklistId]
    ON [dbo].[Mst_IndependentContractor_Compliance]([ComplianceChecklistId] ASC);

