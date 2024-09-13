CREATE TABLE [dbo].[Mst_AutoAdvancementSales_Jenny] (
    [SalesId]                      INT             IDENTITY (1, 1) NOT NULL,
    [Weekending]                   DATE            NOT NULL,
    [CountryCode]                  NVARCHAR (10)   NOT NULL,
    [MOCode]                       NVARCHAR (10)   NOT NULL,
    [BadgeNo]                      NVARCHAR (50)   NOT NULL,
    [PersonalPayable]              DECIMAL (18, 2) NULL,
    [TeamPayable]                  DECIMAL (18, 2) NULL,
    [BulletinPoint]                DECIMAL (18, 2) NULL,
    [PersonalSalesPieces]          INT             NULL,
    [FirstGenLeader]               INT             NULL,
    [TotalLeader]                  INT             NULL,
    [TeamSize]                     INT             NULL,
    [IndependentContractorLevelId] INT             NULL,
    [IsDeleted]                    BIT             NOT NULL,
    [CreatedBy]                    NVARCHAR (50)   NOT NULL,
    [CreatedDate]                  DATETIME        NOT NULL,
    [UpdatedBy]                    NVARCHAR (50)   NULL,
    [UpdatedDate]                  DATETIME        NULL
);

