CREATE TABLE [dbo].[TXN_ClientIdentification2] (
    [ClientIdentificationID]  INT            IDENTITY (1, 1) NOT NULL,
    [MarketingCompanyId]      INT            NULL,
    [IndependentContractorId] INT            NULL,
    [CampaignId]              INT            NULL,
    [StartDate]               DATE           NULL,
    [EndDate]                 DATE           NULL,
    [identificationID]        NVARCHAR (100) NULL,
    [isDeleted]               BIT            NULL,
    [CreatedBy]               NVARCHAR (50)  NULL,
    [CreatedDate]             DATETIME       NULL,
    [UpdatedBy]               NVARCHAR (50)  NULL,
    [UpdatedDate]             DATETIME       NULL
);

