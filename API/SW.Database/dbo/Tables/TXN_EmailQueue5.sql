CREATE TABLE [dbo].[TXN_EmailQueue5] (
    [TxnID]       NVARCHAR (100)  NOT NULL,
    [Description] NVARCHAR (100)  NULL,
    [Recipient]   NVARCHAR (1000) NULL,
    [CC]          NVARCHAR (200)  NULL,
    [BCC]         NVARCHAR (200)  NULL,
    [Subject]     NVARCHAR (200)  NULL,
    [Body]        NVARCHAR (MAX)  NULL,
    [Attachment]  NVARCHAR (2000) NULL,
    [CreateDate]  DATETIME        NULL,
    [CreateBy]    NVARCHAR (50)   NULL
);

