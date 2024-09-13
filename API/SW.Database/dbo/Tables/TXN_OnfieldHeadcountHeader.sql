CREATE TABLE [dbo].[TXN_OnfieldHeadcountHeader] (
    [OnfieldHeadcountID] INT           IDENTITY (1, 1) NOT NULL,
    [MarketingCompanyId] INT           NULL,
    [OnfieldDate]        DATE          NULL,
    [TotalHeadcount]     INT           NULL,
    [CreatedBy]          NVARCHAR (50) NULL,
    [CreatedDate]        DATETIME      NULL,
    [UpdatedBy]          NVARCHAR (50) NULL,
    [UpdatedDate]        DATETIME      NULL,
    [IsDeleted]          BIT           NULL,
    CONSTRAINT [PK_TXN_OnfieldHeadcountHeader] PRIMARY KEY CLUSTERED ([OnfieldHeadcountID] ASC)
);

