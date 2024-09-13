CREATE TABLE [dbo].[Txn_Bonus] (
    [BonusType]        NVARCHAR (50)   NULL,
    [BonusDescription] NVARCHAR (255)  NULL,
    [BonusAmount]      DECIMAL (18, 2) NULL,
    [StartDate]        DATE            NULL,
    [EndDate]          DATE            NULL,
    [CreatedDate]      DATETIME        NULL,
    [CreatedBy]        NVARCHAR (50)   NULL,
    [UpdatedDate]      DATETIME        NULL,
    [UpdatedBy]        NVARCHAR (50)   NULL
);

