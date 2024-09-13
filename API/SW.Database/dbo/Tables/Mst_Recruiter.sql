CREATE TABLE [dbo].[Mst_Recruiter] (
    [RecruiterId]        INT            IDENTITY (1, 1) NOT NULL,
    [FirstName]          NVARCHAR (150) NOT NULL,
    [MiddleName]         NVARCHAR (150) NULL,
    [LastName]           NVARCHAR (150) NULL,
    [LocalFirstName]     NVARCHAR (255) NULL,
    [LocalLastName]      NVARCHAR (255) NULL,
    [MarketingCompanyId] INT            NOT NULL,
    [IsDeleted]          BIT            NOT NULL,
    [CreatedBy]          NVARCHAR (50)  NULL,
    [CreatedDate]        DATETIME       NULL,
    [UpdatedBy]          NVARCHAR (50)  NULL,
    [UpdatedDate]        DATETIME       NULL,
    CONSTRAINT [PK_dbo.Mst_Recruiter] PRIMARY KEY CLUSTERED ([RecruiterId] ASC),
    CONSTRAINT [FK_dbo.Mst_Recruiter_dbo.Mst_MarketingCompany_MarketingCompanyId] FOREIGN KEY ([MarketingCompanyId]) REFERENCES [dbo].[Mst_MarketingCompany] ([MarketingCompanyId]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_MarketingCompanyId]
    ON [dbo].[Mst_Recruiter]([MarketingCompanyId] ASC);

