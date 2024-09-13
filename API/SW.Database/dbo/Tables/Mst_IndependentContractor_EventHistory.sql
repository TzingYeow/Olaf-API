CREATE TABLE [dbo].[Mst_IndependentContractor_EventHistory] (
    [IndependentContractorEventHistoryId] INT            IDENTITY (1, 1) NOT NULL,
    [IndependentContractorId]             INT            NOT NULL,
    [EventName]                           NVARCHAR (MAX) NOT NULL,
    [Month]                               NVARCHAR (MAX) NOT NULL,
    [Year]                                INT            NOT NULL,
    [IndependentContractorLevelId]        INT            NOT NULL,
    [SubsidyAmount]                       FLOAT (53)     NULL,
    [TimeWithHods]                        NVARCHAR (MAX) NULL,
    [StarRisingMeetingLevel]              NVARCHAR (MAX) NULL,
    [IsDeleted]                           BIT            NOT NULL,
    [CreatedBy]                           NVARCHAR (50)  NULL,
    [CreatedDate]                         DATETIME       NULL,
    [UpdatedBy]                           NVARCHAR (50)  NULL,
    [UpdatedDate]                         DATETIME       NULL,
    CONSTRAINT [PK_dbo.Mst_IndependentContractor_EventHistory] PRIMARY KEY CLUSTERED ([IndependentContractorEventHistoryId] ASC),
    CONSTRAINT [FK_dbo.Mst_IndependentContractor_EventHistory_dbo.Mst_IndependentContractor_IndependentContractorId] FOREIGN KEY ([IndependentContractorId]) REFERENCES [dbo].[Mst_IndependentContractor] ([IndependentContractorId]) ON DELETE CASCADE,
    CONSTRAINT [FK_dbo.Mst_IndependentContractor_EventHistory_dbo.Mst_IndependentContractorLevel_IndependentContractorLevelId] FOREIGN KEY ([IndependentContractorLevelId]) REFERENCES [dbo].[Mst_IndependentContractorLevel] ([IndependentContractorLevelId])
);


GO
CREATE NONCLUSTERED INDEX [IX_IndependentContractorId]
    ON [dbo].[Mst_IndependentContractor_EventHistory]([IndependentContractorId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_IndependentContractorLevelId]
    ON [dbo].[Mst_IndependentContractor_EventHistory]([IndependentContractorLevelId] ASC);

