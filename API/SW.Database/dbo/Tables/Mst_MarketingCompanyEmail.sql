CREATE TABLE [dbo].[Mst_MarketingCompanyEmail] (
    [MarketingCompanyEmailId] INT            IDENTITY (1, 1) NOT NULL,
    [MarketingCompanyId]      INT            NOT NULL,
    [Email]                   NVARCHAR (100) NULL,
    [Password]                NVARCHAR (100) NOT NULL,
    [EmailProvider]           NVARCHAR (100) NULL,
    [PortNo]                  INT            NOT NULL,
    [IsActive]                BIT            NOT NULL,
    [IsDeleted]               BIT            NOT NULL,
    [CreatedBy]               NVARCHAR (50)  NULL,
    [CreatedDate]             DATETIME       NULL,
    [UpdatedBy]               NVARCHAR (50)  NULL,
    [UpdatedDate]             DATETIME       NULL,
    [EnableSSL]               BIT            DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_Mst_MarketingCompanyEmail] PRIMARY KEY CLUSTERED ([MarketingCompanyEmailId] ASC)
);

