CREATE TABLE [dbo].[Mst_Menu] (
    [MenuId]          INT             IDENTITY (1, 1) NOT NULL,
    [MenuCode]        VARCHAR (50)    NOT NULL,
    [MenuName]        NVARCHAR (255)  NULL,
    [MenuDescription] NVARCHAR (255)  NULL,
    [ParentMenuCode]  VARCHAR (50)    NULL,
    [Sequence]        INT             NULL,
    [Path]            NVARCHAR (4000) NULL,
    [IsVisible]       BIT             NOT NULL,
    [IsDeleted]       BIT             NOT NULL,
    [CreatedBy]       NVARCHAR (50)   NOT NULL,
    [CreatedDate]     DATETIME        NOT NULL,
    [UpdatedBy]       NVARCHAR (50)   NULL,
    [UpdatedDate]     DATETIME        NULL,
    CONSTRAINT [PK_Mst_Menu] PRIMARY KEY CLUSTERED ([MenuId] ASC)
);

