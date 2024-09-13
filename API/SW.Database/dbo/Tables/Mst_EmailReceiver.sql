CREATE TABLE [dbo].[Mst_EmailReceiver] (
    [ReceiverId]          INT            IDENTITY (1, 1) NOT NULL,
    [CountryCode]         NVARCHAR (5)   NOT NULL,
    [EmailType]           NVARCHAR (300) NOT NULL,
    [Email]               NVARCHAR (300) NOT NULL,
    [ReceiverDescription] NVARCHAR (300) NOT NULL,
    [IsDeleted]           BIT            NOT NULL,
    [CreatedBy]           NVARCHAR (50)  NULL,
    [CreatedDate]         DATETIME       NULL,
    [UpdatedBy]           NVARCHAR (50)  NULL,
    [UpdatedDate]         DATETIME       NULL
);

