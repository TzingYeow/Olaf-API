CREATE TABLE [dbo].[Mst_IndependentContractor_Movement] (
    [IndependentContractorMovementId] INT            IDENTITY (1, 1) NOT NULL,
    [IndependentContractorId]         INT            NOT NULL,
    [Description]                     NVARCHAR (MAX) NOT NULL,
    [IndependentContractorLevelId]    INT            NULL,
    [PromotionDemotionDate]           DATETIME       NULL,
    [EffectiveDate]                   DATETIME       NOT NULL,
    [LeavingReasonCategory]           NVARCHAR (MAX) NULL,
    [LeavingReasonDescription]        NVARCHAR (MAX) NULL,
    [MovementDuration]                INT            NULL,
    [Remark]                          NVARCHAR (MAX) NULL,
    [HasExecuted]                     BIT            NOT NULL,
    [MovementTypeId]                  INT            NULL,
    [IsDeleted]                       BIT            NOT NULL,
    [CreatedBy]                       NVARCHAR (50)  NULL,
    [CreatedDate]                     DATETIME       NULL,
    [UpdatedBy]                       NVARCHAR (50)  NULL,
    [UpdatedDate]                     DATETIME       NULL,
    CONSTRAINT [PK_Mst_IndependentContractor_Movement] PRIMARY KEY CLUSTERED ([IndependentContractorMovementId] ASC),
    CONSTRAINT [FK_dbo.Mst_IndependentContractor_Movement_dbo.Mst_IndependentContractor_IndependentContractorId] FOREIGN KEY ([IndependentContractorId]) REFERENCES [dbo].[Mst_IndependentContractor] ([IndependentContractorId]),
    CONSTRAINT [FK_dbo.Mst_IndependentContractor_Movement_dbo.Mst_IndependentContractorLevel_IndependentContractorLevelId] FOREIGN KEY ([IndependentContractorLevelId]) REFERENCES [dbo].[Mst_IndependentContractorLevel] ([IndependentContractorLevelId]),
    CONSTRAINT [FK_dbo.Mst_IndependentContractor_Movement_dbo.Mst_MovementType_MovementTypeId] FOREIGN KEY ([MovementTypeId]) REFERENCES [dbo].[Mst_MovementType] ([MovementTypeId])
);


GO
CREATE NONCLUSTERED INDEX [IX_IndependentContractorId]
    ON [dbo].[Mst_IndependentContractor_Movement]([IndependentContractorId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_IndependentContractorLevelId]
    ON [dbo].[Mst_IndependentContractor_Movement]([IndependentContractorLevelId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_MovementTypeId]
    ON [dbo].[Mst_IndependentContractor_Movement]([MovementTypeId] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_IndependentContractor_MovementEffectiveDate]
    ON [dbo].[Mst_IndependentContractor_Movement]([IsDeleted] ASC, [IndependentContractorLevelId] ASC)
    INCLUDE([IndependentContractorMovementId], [IndependentContractorId], [PromotionDemotionDate], [EffectiveDate]);


GO
CREATE NONCLUSTERED INDEX [<IX_IndependentContractor_Movement_IndependentContractorId_LevelIDDate>]
    ON [dbo].[Mst_IndependentContractor_Movement]([HasExecuted] ASC, [IsDeleted] ASC)
    INCLUDE([IndependentContractorId], [Description], [IndependentContractorLevelId], [PromotionDemotionDate]);

