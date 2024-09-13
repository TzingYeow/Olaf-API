CREATE TABLE [dbo].[MST_PR_Master] (
    [PRID]                                  INT      IDENTITY (1, 1) NOT NULL,
    [IndependentContractorID]               INT      NULL,
    [StartDate]                             DATE     NULL,
    [StartDateWE]                           DATE     NULL,
    [RecruiterIndependentContractorID]      INT      NULL,
    [RecruiterIndependentContractorLevelID] INT      NULL,
    [MileStone1]                            DATE     NULL,
    [MileStone2]                            DATE     NULL,
    [MileStone3]                            DATE     NULL,
    [MileStone4]                            INT      NULL,
    [MileStone5]                            DATE     NULL,
    [MileStone6]                            DATE     NULL,
    [MileStone7]                            DATE     NULL,
    [CreatedDate]                           DATETIME NULL,
    [UpdatedDate]                           DATETIME NULL,
    [IsDeleted]                             BIT      NULL,
    CONSTRAINT [PK_MST_PR_Master] PRIMARY KEY CLUSTERED ([PRID] ASC)
);

