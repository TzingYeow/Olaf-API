CREATE TABLE [dbo].[Mst_IndependentContractorLevel] (
    [IndependentContractorLevelId] INT           IDENTITY (1, 1) NOT NULL,
    [LevelCode]                    NVARCHAR (10) NOT NULL,
    [Level]                        NVARCHAR (50) NOT NULL,
    [ParentLevel]                  NVARCHAR (50) NULL,
    [LevelOrdinal]                 INT           NOT NULL,
    [IsActive]                     BIT           NOT NULL,
    [IsDemotionLevel]              BIT           NOT NULL,
    [IsDeleted]                    BIT           NOT NULL,
    [CreatedBy]                    NVARCHAR (50) NULL,
    [CreatedDate]                  DATETIME      NULL,
    [UpdatedBy]                    NVARCHAR (50) NULL,
    [UpdatedDate]                  DATETIME      NULL,
    CONSTRAINT [PK_Mst_IndependentContractorLevel] PRIMARY KEY CLUSTERED ([IndependentContractorLevelId] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_LevelCode]
    ON [dbo].[Mst_IndependentContractorLevel]([LevelCode] ASC);

