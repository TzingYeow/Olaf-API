CREATE TABLE [dbo].[Mst_Campaign] (
    [CampaignId]    INT            IDENTITY (1, 1) NOT NULL,
    [CampaignCode]  NVARCHAR (20)  NOT NULL,
    [CampaignName]  NVARCHAR (150) NOT NULL,
    [DivisionId]    INT            NOT NULL,
    [CountryCode]   NVARCHAR (10)  NOT NULL,
    [SerialPrefix]  NVARCHAR (10)  NULL,
    [IsTestProduct] BIT            NOT NULL,
    [TempId]        INT            NOT NULL,
    [ClientCode]    NVARCHAR (10)  NULL,
    [IsActive]      BIT            NOT NULL,
    [IsDeleted]     BIT            NOT NULL,
    [CreatedBy]     NVARCHAR (50)  NULL,
    [CreatedDate]   DATETIME       NULL,
    [UpdatedBy]     NVARCHAR (50)  NULL,
    [UpdatedDate]   DATETIME       NULL,
    CONSTRAINT [PK_dbo.Mst_Campaign] PRIMARY KEY CLUSTERED ([CampaignId] ASC),
    CONSTRAINT [FK_dbo.Mst_Campaign_dbo.Mst_Division_DivisionId] FOREIGN KEY ([DivisionId]) REFERENCES [dbo].[Mst_Division] ([DivisionId]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_DivisionId]
    ON [dbo].[Mst_Campaign]([DivisionId] ASC);

