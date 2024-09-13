CREATE TABLE [dbo].[Mst_UserResetPasswordToken] (
    [UserResetPasswordTokenId] INT            IDENTITY (1, 1) NOT NULL,
    [IsDeleted]                BIT            NOT NULL,
    [CreatedBy]                NVARCHAR (50)  NULL,
    [CreatedDate]              DATETIME       NULL,
    [UpdatedBy]                NVARCHAR (50)  NULL,
    [UpdatedDate]              DATETIME       NULL,
    [UserId]                   NVARCHAR (35)  NOT NULL,
    [Email]                    NVARCHAR (150) NOT NULL,
    [Token]                    NVARCHAR (255) NOT NULL,
    [HasUsed]                  BIT            NOT NULL,
    [TokenExpiredDateTime]     DATETIME       NOT NULL,
    CONSTRAINT [PK_dbo.Mst_UserResetPasswordToken] PRIMARY KEY CLUSTERED ([UserResetPasswordTokenId] ASC),
    CONSTRAINT [FK_dbo.Mst_UserResetPasswordToken_dbo.Mst_User_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Mst_User] ([UserId]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_UserId]
    ON [dbo].[Mst_UserResetPasswordToken]([UserId] ASC);

