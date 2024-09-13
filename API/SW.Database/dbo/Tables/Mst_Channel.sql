CREATE TABLE [dbo].[Mst_Channel] (
    [ChannelId]   INT            IDENTITY (1, 1) NOT NULL,
    [ChannelCode] NVARCHAR (5)   NOT NULL,
    [ChannelName] NVARCHAR (255) NOT NULL,
    [IsDeleted]   BIT            NOT NULL,
    [CreatedBy]   NVARCHAR (50)  NULL,
    [CreatedDate] DATETIME       NULL,
    [UpdatedBy]   NVARCHAR (50)  NULL,
    [UpdatedDate] DATETIME       NULL,
    CONSTRAINT [PK_dbo.Mst_Channel] PRIMARY KEY CLUSTERED ([ChannelId] ASC)
);

