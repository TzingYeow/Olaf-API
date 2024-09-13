CREATE TABLE [dbo].[YT_MarketingCompany] (
    [id]    INT            NOT NULL,
    [name]  NVARCHAR (200) NULL,
    [mcPin] NVARCHAR (50)  NULL,
    [mcId]  NVARCHAR (50)  NULL,
    CONSTRAINT [PK_YT_MarketingCompany] PRIMARY KEY CLUSTERED ([id] ASC)
);

