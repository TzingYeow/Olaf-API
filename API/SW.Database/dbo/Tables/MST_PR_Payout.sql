CREATE TABLE [dbo].[MST_PR_Payout] (
    [PayoutID]      INT             IDENTITY (1, 1) NOT NULL,
    [Country]       NVARCHAR (2)    NULL,
    [MilestoneType] INT             NULL,
    [PayoutType]    NVARCHAR (50)   NULL,
    [SW]            DECIMAL (18, 2) NULL,
    [MC]            DECIMAL (18, 2) NULL,
    [PO]            DECIMAL (18, 2) NULL,
    CONSTRAINT [PK_MST_PR_Payout] PRIMARY KEY CLUSTERED ([PayoutID] ASC)
);

