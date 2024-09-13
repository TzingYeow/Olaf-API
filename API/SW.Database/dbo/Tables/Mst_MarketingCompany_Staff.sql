CREATE TABLE [dbo].[Mst_MarketingCompany_Staff] (
    [MarketingCompanyStaffId] INT            IDENTITY (1, 1) NOT NULL,
    [Name]                    NVARCHAR (255) NULL,
    [Email]                   NVARCHAR (100) NULL,
    [PhoneNumber]             NVARCHAR (50)  NULL,
    [Postion]                 NVARCHAR (50)  NULL,
    [MarketingCompanyId]      INT            NOT NULL,
    [IsDeleted]               BIT            NOT NULL,
    [CreatedBy]               NVARCHAR (50)  NULL,
    [CreatedDate]             DATETIME       NULL,
    [UpdatedBy]               NVARCHAR (50)  NULL,
    [UpdatedDate]             DATETIME       NULL,
    CONSTRAINT [PK_dbo.Mst_MarketingCompany_Staff] PRIMARY KEY CLUSTERED ([MarketingCompanyStaffId] ASC),
    CONSTRAINT [FK_dbo.Mst_MarketingCompany_Staff_dbo.Mst_MarketingCompany_MarketingCompanyId] FOREIGN KEY ([MarketingCompanyId]) REFERENCES [dbo].[Mst_MarketingCompany] ([MarketingCompanyId]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_MarketingCompanyId]
    ON [dbo].[Mst_MarketingCompany_Staff]([MarketingCompanyId] ASC);

