CREATE TABLE [dbo].[Mst_AdvancementCriteria] (
    [AdvancementId]                INT             IDENTITY (1, 1) NOT NULL,
    [CountryCode]                  NVARCHAR (10)   NOT NULL,
    [Province]                     NVARCHAR (50)   NULL,
    [IndependentContractorLevelId] INT             NOT NULL,
    [SalesValue]                   DECIMAL (18, 2) NULL,
    [SalesPoint]                   INT             NULL,
    [PersonalSalesPieces]          INT             NULL,
    [FirstGenLeader]               INT             NULL,
    [TotalLeader]                  INT             NULL,
    [TeamSize]                     INT             NULL,
    [TeamSizeLevel]                INT             NULL,
    [TeamSizeSale]                 NVARCHAR (100)  NULL,
    [StartDate]                    DATETIME        NOT NULL,
    [EndDate]                      DATETIME        NULL,
    [IsDeleted]                    BIT             NOT NULL,
    [CreatedBy]                    NVARCHAR (50)   NOT NULL,
    [CreatedDate]                  DATETIME        NOT NULL,
    [UpdatedBy]                    NVARCHAR (50)   NULL,
    [UpdatedDate]                  DATETIME        NULL
);

