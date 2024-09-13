CREATE TABLE [dbo].[Mst_UserRole] (
    [UserRoleId]   INT            IDENTITY (1, 1) NOT NULL,
    [UserRoleCode] NVARCHAR (5)   NOT NULL,
    [Description]  NVARCHAR (300) NOT NULL,
    [IsDeleted]    BIT            NOT NULL,
    [CreatedBy]    NVARCHAR (50)  NULL,
    [CreatedDate]  DATETIME       NULL,
    [UpdatedBy]    NVARCHAR (50)  NULL,
    [UpdatedDate]  DATETIME       NULL,
    CONSTRAINT [PK_dbo.Mst_UserRole] PRIMARY KEY CLUSTERED ([UserRoleId] ASC)
);

