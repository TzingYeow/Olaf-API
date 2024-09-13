CREATE TABLE [dbo].[TXN_OnfieldHeadcountDetail] (
    [DetailID]                INT           IDENTITY (1, 1) NOT NULL,
    [OnfieldHeadcountID]      INT           NULL,
    [IndependentContractorId] INT           NULL,
    [CampaignID]              INT           NULL,
    [Status]                  BIT           NULL,
    [Session]                 NVARCHAR (50) NULL,
    [Channel]                 NVARCHAR (50) NULL,
    [Location]                NVARCHAR (20) NULL,
    CONSTRAINT [PK_TXN_OnfieldHeadcountDetail] PRIMARY KEY CLUSTERED ([DetailID] ASC)
);

