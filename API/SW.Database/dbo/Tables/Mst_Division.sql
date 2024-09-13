CREATE TABLE [dbo].[Mst_Division] (
    [DivisionId]     INT            IDENTITY (1, 1) NOT NULL,
    [DivisionCode]   NVARCHAR (5)   NOT NULL,
    [DivisionName]   NVARCHAR (255) NOT NULL,
    [ParentDivision] NVARCHAR (5)   NULL,
    [IsDeleted]      BIT            NOT NULL,
    [CreatedBy]      NVARCHAR (50)  NULL,
    [CreatedDate]    DATETIME       NULL,
    [UpdatedBy]      NVARCHAR (50)  NULL,
    [UpdatedDate]    DATETIME       NULL,
    CONSTRAINT [PK_dbo.Mst_Division] PRIMARY KEY CLUSTERED ([DivisionId] ASC)
);

