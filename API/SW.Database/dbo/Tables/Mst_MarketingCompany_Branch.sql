CREATE TABLE [dbo].[Mst_MarketingCompany_Branch] (
    [MarketingCompanyBranchId] INT            IDENTITY (1, 1) NOT NULL,
    [AddressLine1]             NVARCHAR (MAX) NULL,
    [AddressLine2]             NVARCHAR (MAX) NULL,
    [AddressLine3]             NVARCHAR (MAX) NULL,
    [City]                     NVARCHAR (50)  NULL,
    [Postcode]                 NVARCHAR (50)  NULL,
    [State]                    NVARCHAR (50)  NULL,
    [Country]                  NVARCHAR (50)  NULL,
    [TelephoneNo]              NVARCHAR (50)  NULL,
    [FaxNo]                    NVARCHAR (50)  NULL,
    [MarketingCompanyId]       INT            NOT NULL,
    [IsDeleted]                BIT            NOT NULL,
    [CreatedBy]                NVARCHAR (50)  NULL,
    [CreatedDate]              DATETIME       NULL,
    [UpdatedBy]                NVARCHAR (50)  NULL,
    [UpdatedDate]              DATETIME       NULL,
    CONSTRAINT [PK_dbo.Mst_MarketingCompany_Branch] PRIMARY KEY CLUSTERED ([MarketingCompanyBranchId] ASC),
    CONSTRAINT [FK_dbo.Mst_MarketingCompany_Branch_dbo.Mst_MarketingCompany_MarketingCompanyId] FOREIGN KEY ([MarketingCompanyId]) REFERENCES [dbo].[Mst_MarketingCompany] ([MarketingCompanyId]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_MarketingCompanyId]
    ON [dbo].[Mst_MarketingCompany_Branch]([MarketingCompanyId] ASC);

