CREATE TABLE [dbo].[Eloomi_Course_Categories] (
    [categories_id]    INT            NOT NULL,
    [parent_id]        INT            NULL,
    [name]             NVARCHAR (150) NULL,
    [data_inserted_at] DATETIME       NULL,
    CONSTRAINT [PK_Eloomi_Course_Categories] PRIMARY KEY CLUSTERED ([categories_id] ASC)
);

