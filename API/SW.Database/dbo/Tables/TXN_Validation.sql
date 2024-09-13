CREATE TABLE [dbo].[TXN_Validation] (
    [TxnId]       INT           IDENTITY (1, 1) NOT NULL,
    [TxnName]     VARCHAR (100) NOT NULL,
    [TxnDate]     DATE          NULL,
    [Status]      NVARCHAR (10) NULL,
    [CreatedBy]   NVARCHAR (50) NOT NULL,
    [CreatedDate] DATETIME      NOT NULL,
    CONSTRAINT [PK_TXN_Validation] PRIMARY KEY CLUSTERED ([TxnId] ASC)
);

