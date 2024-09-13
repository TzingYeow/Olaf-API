CREATE TABLE [dbo].[Mst_IndependentContractor_BranchOut] (
    [IndependentContractorBranchOutId] INT            IDENTITY (1, 1) NOT NULL,
    [IndependentContractorId]          INT            NOT NULL,
    [MarketingCompanyId]               INT            NOT NULL,
    [IndependentContractorLevelId]     INT            NOT NULL,
    [NewBadgeNo]                       NVARCHAR (MAX) NOT NULL,
    [NewCompanyStartDate]              DATETIME       NOT NULL,
    [DeactivateDate]                   DATETIME       NOT NULL,
    [CurrentCompanyReactivateDate]     DATETIME       NULL,
    [GroupRefId]                       NVARCHAR (MAX) NOT NULL,
    [HasBranchedOut]                   BIT            NOT NULL,
    [HasReactivated]                   BIT            NOT NULL,
    [IsDeleted]                        BIT            NOT NULL,
    [CreatedBy]                        NVARCHAR (50)  NULL,
    [CreatedDate]                      DATETIME       NULL,
    [UpdatedBy]                        NVARCHAR (50)  NULL,
    [UpdatedDate]                      DATETIME       NULL,
    CONSTRAINT [PK_dbo.Mst_IndependentContractor_BranchOut] PRIMARY KEY CLUSTERED ([IndependentContractorBranchOutId] ASC),
    CONSTRAINT [FK_dbo.Mst_IndependentContractor_BranchOut_dbo.Mst_IndependentContractor_IndependentContractorId] FOREIGN KEY ([IndependentContractorId]) REFERENCES [dbo].[Mst_IndependentContractor] ([IndependentContractorId]),
    CONSTRAINT [FK_dbo.Mst_IndependentContractor_BranchOut_dbo.Mst_IndependentContractorLevel_IndependentContractorLevelId] FOREIGN KEY ([IndependentContractorLevelId]) REFERENCES [dbo].[Mst_IndependentContractorLevel] ([IndependentContractorLevelId]),
    CONSTRAINT [FK_dbo.Mst_IndependentContractor_BranchOut_dbo.Mst_MarketingCompany_MarketingCompanyId] FOREIGN KEY ([MarketingCompanyId]) REFERENCES [dbo].[Mst_MarketingCompany] ([MarketingCompanyId])
);


GO
CREATE NONCLUSTERED INDEX [IX_IndependentContractorId]
    ON [dbo].[Mst_IndependentContractor_BranchOut]([IndependentContractorId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_MarketingCompanyId]
    ON [dbo].[Mst_IndependentContractor_BranchOut]([MarketingCompanyId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_IndependentContractorLevelId]
    ON [dbo].[Mst_IndependentContractor_BranchOut]([IndependentContractorLevelId] ASC);

