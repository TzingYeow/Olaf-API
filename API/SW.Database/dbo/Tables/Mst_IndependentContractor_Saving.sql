CREATE TABLE [dbo].[Mst_IndependentContractor_Saving] (
    [IndependentContractorSavingId] INT             IDENTITY (1, 1) NOT NULL,
    [IndependentContractorId]       INT             NOT NULL,
    [AmountType]                    NVARCHAR (50)   NOT NULL,
    [Amount]                        DECIMAL (18, 2) NOT NULL,
    [MaxLimit]                      DECIMAL (18, 2) NOT NULL,
    [StartDate]                     DATETIME        NOT NULL,
    [EndDate]                       DATETIME        NULL,
    [SavingType]                    NVARCHAR (50)   NOT NULL,
    [IsDeleted]                     BIT             NOT NULL,
    [CreatedBy]                     NVARCHAR (50)   NULL,
    [CreatedDate]                   DATETIME        NULL,
    [UpdatedBy]                     NVARCHAR (50)   NULL,
    [UpdatedDate]                   DATETIME        NULL,
    CONSTRAINT [PK_dbo.Mst_IndependentContractor_Saving] PRIMARY KEY CLUSTERED ([IndependentContractorSavingId] ASC),
    CONSTRAINT [FK_dbo.Mst_IndependentContractor_Saving_dbo.Mst_IndependentContractor_IndependentContractorId] FOREIGN KEY ([IndependentContractorId]) REFERENCES [dbo].[Mst_IndependentContractor] ([IndependentContractorId])
);


GO
CREATE NONCLUSTERED INDEX [IX_IndependentContractorId]
    ON [dbo].[Mst_IndependentContractor_Saving]([IndependentContractorId] ASC);

