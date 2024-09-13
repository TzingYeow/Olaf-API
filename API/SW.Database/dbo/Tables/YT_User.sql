CREATE TABLE [dbo].[YT_User] (
    [id]             INT            NOT NULL,
    [companyId]      INT            NULL,
    [forename]       NVARCHAR (100) NULL,
    [surname]        NVARCHAR (100) NULL,
    [email]          NVARCHAR (100) NULL,
    [activeStatusId] INT            NULL,
    CONSTRAINT [PK_YT_User] PRIMARY KEY CLUSTERED ([id] ASC)
);

