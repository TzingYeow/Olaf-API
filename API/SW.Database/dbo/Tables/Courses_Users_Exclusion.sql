CREATE TABLE [dbo].[Courses_Users_Exclusion] (
    [Id]              INT            IDENTITY (1, 1) NOT NULL,
    [UserName]        NVARCHAR (50)  NOT NULL,
    [BadgeNo]         NVARCHAR (50)  NOT NULL,
    [exclusionReason] NVARCHAR (200) NULL,
    [dateAdded]       DATETIME       NULL,
    [ExType]          NVARCHAR (5)   NOT NULL,
    [MCID]            NVARCHAR (5)   NULL,
    CONSTRAINT [PK_Courses_Users_Exclusion] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_BadgeNo]
    ON [dbo].[Courses_Users_Exclusion]([BadgeNo] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_UserName]
    ON [dbo].[Courses_Users_Exclusion]([UserName] ASC);

