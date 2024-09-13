CREATE TABLE [dbo].[Mst_IndependentContractor_Compliance_Archive] (
    [IndependentContractorComplianceId] INT            NOT NULL,
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
    [UploadedDate]                      DATETIME       NULL
);

