CREATE TABLE [dbo].[Txn_AutoAdvancementConfirmation] (
    [AdvancementID]           INT            IDENTITY (1, 1) NOT NULL,
    [MarketingCompanyId]      INT            NULL,
    [IndependentContractorId] INT            NULL,
    [WeekendingDate]          DATE           NULL,
    [MTA]                     BIT            NULL,
    [Incoperation]            BIT            NULL,
    [MCAgreement]             BIT            NULL,
    [Remark]                  NVARCHAR (200) NULL,
    [Status]                  NVARCHAR (10)  NULL,
    [StatusDate]              DATE           NULL,
    [isDeleted]               BIT            NULL,
    [CreatedBy]               NVARCHAR (100) NULL,
    [CreatedDate]             DATETIME       NULL,
    [UpdatedBy]               NVARCHAR (50)  NULL,
    [UpdatedDate]             DATETIME       NULL,
    CONSTRAINT [PK_Txn_AutoAdvancementConfirmation] PRIMARY KEY CLUSTERED ([AdvancementID] ASC)
);

