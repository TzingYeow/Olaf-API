CREATE TABLE [dbo].[Mst_Suspension_TempTable] (
    [Id]                           INT            IDENTITY (1, 1) NOT NULL,
    [Type]                         NVARCHAR (50)  NULL,
    [SuspensionRunDate]            DATETIME       NULL,
    [CountryCode]                  NVARCHAR (5)   NULL,
    [MCCode]                       NVARCHAR (5)   NULL,
    [BadgeNo]                      NVARCHAR (10)  NULL,
    [LastSalesDate]                DATETIME       NULL,
    [LastSalesSubmissionDate]      DATETIME       NULL,
    [CORRECTEDLASTDATE]            DATETIME       NULL,
    [IndependentContractorId]      NVARCHAR (10)  NULL,
    [Description]                  NVARCHAR (255) NULL,
    [LeavingReasonCategory]        NVARCHAR (255) NULL,
    [LeavingReasonDescription]     NVARCHAR (255) NULL,
    [IndependentContractorLevelId] NVARCHAR (10)  NULL,
    [StartDate]                    DATETIME       NULL,
    [EndDate]                      DATETIME       NULL,
    [EffectiveDate]                DATETIME       NULL,
    [IsReactivate]                 BIT            NULL,
    [IsDeleted]                    BIT            NULL,
    [CreatedBy]                    NVARCHAR (50)  NULL,
    [CreatedDate]                  DATETIME       NULL
);

