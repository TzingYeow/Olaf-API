CREATE TABLE [dbo].[Mst_MarketingCompany] (
    [MarketingCompanyId]   INT            IDENTITY (1, 1) NOT NULL,
    [Code]                 NVARCHAR (10)  NOT NULL,
    [Name]                 NVARCHAR (150) NOT NULL,
    [Email]                NVARCHAR (100) NULL,
    [CountryCode]          NVARCHAR (10)  NOT NULL,
    [BankName]             NVARCHAR (200) NULL,
    [BankAccountNo]        NVARCHAR (50)  NULL,
    [CompanyLogo]          NVARCHAR (MAX) NULL,
    [IsActive]             BIT            NOT NULL,
    [IsDeleted]            BIT            NOT NULL,
    [CreatedBy]            NVARCHAR (50)  NULL,
    [CreatedDate]          DATETIME       NULL,
    [UpdatedBy]            NVARCHAR (50)  NULL,
    [UpdatedDate]          DATETIME       NULL,
    [TempId]               INT            NOT NULL,
    [ApplicationFormUrl]   NVARCHAR (MAX) NULL,
    [Banner]               NVARCHAR (MAX) NULL,
    [BgColor]              VARCHAR (10)   NULL,
    [MarketingCompanyType] NVARCHAR (50)  NULL,
    [Province]             NVARCHAR (50)  NULL,
    CONSTRAINT [PK_Mst_MarketingCompany] PRIMARY KEY CLUSTERED ([MarketingCompanyId] ASC)
);

