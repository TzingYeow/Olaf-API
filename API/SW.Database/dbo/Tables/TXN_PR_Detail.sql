CREATE TABLE [dbo].[TXN_PR_Detail] (
    [RowID]                                 INT             IDENTITY (1, 1) NOT NULL,
    [PRID]                                  INT             NOT NULL,
    [IndependentContractorLevelID]          INT             NULL,
    [RecruiterIndependentContractorLevelID] INT             NULL,
    [RecruiterSubPcs]                       INT             NULL,
    [MilestonesType]                        INT             NULL,
    [MileStonesPoint]                       DECIMAL (18, 4) NULL,
    [MileStonesValue]                       DECIMAL (18, 2) NULL,
    [MilestonesData]                        NVARCHAR (200)  NULL,
    [PayoutID]                              INT             NULL,
    [MilestoneHitWE]                        DATE            NULL,
    [MilestonePayable]                      BIT             NULL,
    [MilestonePayoutWE]                     DATE            NULL,
    [CreatedDate]                           DATETIME        NULL,
    [UpdatedDate]                           DATETIME        NULL,
    [IsDeleted]                             NCHAR (10)      NULL,
    [Campaign]                              NVARCHAR (500)  NULL,
    CONSTRAINT [PK_TXN_PR_Detail] PRIMARY KEY CLUSTERED ([RowID] ASC)
);

