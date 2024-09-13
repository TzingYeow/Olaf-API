CREATE TABLE [dbo].[TXN_CampaignDocument_Archive] (
    [ADate]            DATETIME       NULL,
    [ATask]            NVARCHAR (50)  NULL,
    [AUser]            NVARCHAR (50)  NULL,
    [CampaignDocId]    INT            NOT NULL,
    [CampaignId]       INT            NULL,
    [DocumentName]     NVARCHAR (100) NULL,
    [StartDate]        DATE           NULL,
    [EndDate]          DATE           NULL,
    [DocPath]          NVARCHAR (200) NULL,
    [RequiredReminder] BIT            NULL,
    [ReminderDay]      INT            NULL,
    [IsDeleted]        BIT            NULL,
    [CreatedBy]        NVARCHAR (50)  NULL,
    [CreatedDate]      DATETIME       NULL,
    [UpdatedBy]        NVARCHAR (50)  NULL,
    [UpdatedDate]      DATETIME       NULL
);

