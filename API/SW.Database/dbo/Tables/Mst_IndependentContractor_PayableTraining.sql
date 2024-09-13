CREATE TABLE [dbo].[Mst_IndependentContractor_PayableTraining] (
    [IndependentContractorPayableTrainingId] INT            IDENTITY (1, 1) NOT NULL,
    [IndependentContractorId]                INT            NOT NULL,
    [CampaignId]                             INT            NULL,
    [StartDate]                              DATETIME       NOT NULL,
    [EndDate]                                DATETIME       NULL,
    [TrainingFee]                            NVARCHAR (MAX) NOT NULL,
    [Remark]                                 NVARCHAR (MAX) NULL,
    [IsDeleted]                              BIT            NOT NULL,
    [CreatedBy]                              NVARCHAR (50)  NULL,
    [CreatedDate]                            DATETIME       NULL,
    [UpdatedBy]                              NVARCHAR (50)  NULL,
    [UpdatedDate]                            DATETIME       NULL,
    CONSTRAINT [PK_dbo.Mst_IndependentContractor_PayableTraining] PRIMARY KEY CLUSTERED ([IndependentContractorPayableTrainingId] ASC),
    CONSTRAINT [FK_dbo.Mst_IndependentContractor_PayableTraining_dbo.Mst_Campaign_CampaignId] FOREIGN KEY ([CampaignId]) REFERENCES [dbo].[Mst_Campaign] ([CampaignId]),
    CONSTRAINT [FK_dbo.Mst_IndependentContractor_PayableTraining_dbo.Mst_IndependentContractor_IndependentContractorId] FOREIGN KEY ([IndependentContractorId]) REFERENCES [dbo].[Mst_IndependentContractor] ([IndependentContractorId]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_IndependentContractorId]
    ON [dbo].[Mst_IndependentContractor_PayableTraining]([IndependentContractorId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_CampaignId]
    ON [dbo].[Mst_IndependentContractor_PayableTraining]([CampaignId] ASC);

