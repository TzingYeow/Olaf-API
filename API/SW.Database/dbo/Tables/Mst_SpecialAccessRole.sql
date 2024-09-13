CREATE TABLE [dbo].[Mst_SpecialAccessRole] (
    [AccessId]    INT           IDENTITY (1, 1) NOT NULL,
    [Route]       VARCHAR (255) NULL,
    [UserId]      VARCHAR (255) NOT NULL,
    [IsActive]    BIT           NULL,
    [CreatedBy]   NVARCHAR (50) NULL,
    [CreatedDate] DATETIME      NULL,
    CONSTRAINT [PK_Mst_SpecialAccessRole] PRIMARY KEY CLUSTERED ([AccessId] ASC) WITH (FILLFACTOR = 90)
);

