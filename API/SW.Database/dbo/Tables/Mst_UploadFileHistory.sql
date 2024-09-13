CREATE TABLE [dbo].[Mst_UploadFileHistory] (
    [UploadFileHistoryId] INT            IDENTITY (1, 1) NOT NULL,
    [FullPath]            NVARCHAR (255) NOT NULL,
    [FileName]            NVARCHAR (150) NOT NULL,
    [Action]              NVARCHAR (50)  NOT NULL,
    [IsDeleted]           BIT            NOT NULL,
    [CreatedBy]           NVARCHAR (50)  NULL,
    [CreatedDate]         DATETIME       NULL,
    [UpdatedBy]           NVARCHAR (50)  NULL,
    [UpdatedDate]         DATETIME       NULL,
    CONSTRAINT [PK_dbo.Mst_UploadFileHistory] PRIMARY KEY CLUSTERED ([UploadFileHistoryId] ASC)
);

