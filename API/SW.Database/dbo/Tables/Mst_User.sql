CREATE TABLE [dbo].[Mst_User] (
    [UserId]             NVARCHAR (35)  NOT NULL,
    [Fullname]           NVARCHAR (300) NOT NULL,
    [Displayname]        NVARCHAR (100) NOT NULL,
    [Email]              NVARCHAR (150) NOT NULL,
    [Username]           NVARCHAR (50)  NOT NULL,
    [UserPassword]       NVARCHAR (255) NOT NULL,
    [MarketingCompanyId] INT            NOT NULL,
    [UserRoleId]         INT            NOT NULL,
    [PhoneNumber]        NVARCHAR (20)  NULL,
    [IsActive]           BIT            NOT NULL,
    [CountryAccess]      NVARCHAR (50)  NULL,
    [IsDeleted]          BIT            NOT NULL,
    [CreatedBy]          NVARCHAR (50)  NULL,
    [CreatedDate]        DATETIME       NULL,
    [UpdatedBy]          NVARCHAR (50)  NULL,
    [UpdatedDate]        DATETIME       NULL,
    [DefaultPath]        NVARCHAR (255) NULL,
    CONSTRAINT [PK_dbo.Mst_User] PRIMARY KEY CLUSTERED ([UserId] ASC),
    CONSTRAINT [FK_dbo.Mst_User_dbo.Mst_MarketingCompany_MarketingCompanyId] FOREIGN KEY ([MarketingCompanyId]) REFERENCES [dbo].[Mst_MarketingCompany] ([MarketingCompanyId]) ON DELETE CASCADE,
    CONSTRAINT [FK_dbo.Mst_User_dbo.Mst_UserRole_UserRoleId] FOREIGN KEY ([UserRoleId]) REFERENCES [dbo].[Mst_UserRole] ([UserRoleId]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_MarketingCompanyId]
    ON [dbo].[Mst_User]([MarketingCompanyId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_UserRoleId]
    ON [dbo].[Mst_User]([UserRoleId] ASC);

