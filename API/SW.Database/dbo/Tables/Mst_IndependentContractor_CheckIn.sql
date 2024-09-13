CREATE TABLE [dbo].[Mst_IndependentContractor_CheckIn] (
    [CheckInId]               INT           IDENTITY (1, 1) NOT NULL,
    [IndependentContractorId] INT           NOT NULL,
    [CampaignId]              INT           NOT NULL,
    [ChannelId]               INT           NOT NULL,
    [Location]                NVARCHAR (50) NOT NULL,
    [CheckInDate]             DATE          NOT NULL,
    [Session]                 NVARCHAR (10) NOT NULL,
    [IsDeleted]               BIT           NOT NULL,
    [CreatedBy]               NVARCHAR (50) NULL,
    [CreatedDate]             DATETIME      NULL,
    [UpdatedBy]               NVARCHAR (50) NULL,
    [UpdatedDate]             DATETIME      NULL,
    CONSTRAINT [PK_dbo.Mst_IndependentContractor_CheckIn] PRIMARY KEY CLUSTERED ([CheckInId] ASC),
    FOREIGN KEY ([CampaignId]) REFERENCES [dbo].[Mst_Campaign] ([CampaignId]),
    FOREIGN KEY ([ChannelId]) REFERENCES [dbo].[Mst_Channel] ([ChannelId])
);

