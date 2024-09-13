CREATE TABLE [dbo].[Eloomi_Course_Categories_Archive] (
    [id]               INT            IDENTITY (1, 1) NOT NULL,
    [categories_id]    INT            NOT NULL,
    [parent_id]        INT            NULL,
    [name]             NVARCHAR (150) NULL,
    [data_inserted_at] DATETIME       NULL,
    [data_archived_at] DATETIME       NULL,
    CONSTRAINT [PK_Eloomi_Course_Categories_Archive] PRIMARY KEY CLUSTERED ([id] ASC)
);

