CREATE TABLE [dbo].[Mst_MovementType] (
    [MovementTypeId] INT            IDENTITY (1, 1) NOT NULL,
    [IsDeleted]      BIT            NOT NULL,
    [CreatedBy]      NVARCHAR (50)  NULL,
    [CreatedDate]    DATETIME       NULL,
    [UpdatedBy]      NVARCHAR (50)  NULL,
    [UpdatedDate]    DATETIME       NULL,
    [MovementCode]   NVARCHAR (5)   NOT NULL,
    [Type]           NVARCHAR (300) NOT NULL,
    CONSTRAINT [PK_dbo.Mst_MovementType] PRIMARY KEY CLUSTERED ([MovementTypeId] ASC)
);

