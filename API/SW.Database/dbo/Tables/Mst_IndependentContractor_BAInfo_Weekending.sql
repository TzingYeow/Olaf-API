CREATE TABLE [dbo].[Mst_IndependentContractor_BAInfo_Weekending] (
    [IndependentContractorBAInfoId] INT            IDENTITY (1, 1) NOT NULL,
    [IndependentContractorId]       INT            NULL,
    [WeekendingDate]                DATE           NULL,
    [MarketingCompanyId]            INT            NOT NULL,
    [IndependentContractorLevelId]  INT            NULL,
    [BAType]                        NVARCHAR (10)  NULL,
    [ReportBadgeNo]                 NVARCHAR (100) NULL,
    [Status]                        NVARCHAR (10)  NULL,
    [IsSuspended]                   BIT            NULL,
    [IsDeleted]                     BIT            NOT NULL,
    [CreatedBy]                     NVARCHAR (100) NULL,
    [CreatedDate]                   DATETIME       NULL,
    [UpdatedBy]                     NVARCHAR (100) NULL,
    [UpdatedDate]                   DATETIME       NULL,
    CONSTRAINT [PK_dbo.Mst_IndependentContractor_BAInfo_Weekending] PRIMARY KEY CLUSTERED ([IndependentContractorBAInfoId] ASC),
    CONSTRAINT [FK_IndependentContractor] FOREIGN KEY ([IndependentContractorId]) REFERENCES [dbo].[Mst_IndependentContractor] ([IndependentContractorId]),
    CONSTRAINT [FK_IndependentContractorLevelId] FOREIGN KEY ([IndependentContractorLevelId]) REFERENCES [dbo].[Mst_IndependentContractorLevel] ([IndependentContractorLevelId])
);

