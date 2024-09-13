CREATE TABLE [dbo].[Mst_Bank] (
    [BankId]        INT            IDENTITY (1, 1) NOT NULL,
    [BankName]      NVARCHAR (150) NOT NULL,
    [LocalBankName] NVARCHAR (150) NULL,
    [BankCode]      NVARCHAR (10)  NULL,
    [CountryCode]   NVARCHAR (10)  NOT NULL,
    [IsDeleted]     BIT            NOT NULL,
    [CreatedBy]     NVARCHAR (20)  NULL,
    [CreatedDate]   DATETIME       NULL,
    [UpdatedBy]     NVARCHAR (20)  NULL,
    [UpdatedDate]   DATETIME       NULL,
    [HubsBankName]  NVARCHAR (150) NULL,
    CONSTRAINT [PK_dbo.Mst_Bank] PRIMARY KEY CLUSTERED ([BankId] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Store Bank Master', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Mst_Bank';

