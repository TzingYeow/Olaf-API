CREATE TABLE [dbo].[TXN_PR_Incentive_Raw_Temp] (
    [WEDate]                  DATE            NULL,
    [MOCode]                  NVARCHAR (10)   NULL,
    [IndependentContractorId] BIGINT          NULL,
    [CountryCode]             NVARCHAR (10)   NULL,
    [BadgeNo]                 NVARCHAR (50)   NULL,
    [Campaign]                NVARCHAR (500)  NULL,
    [Subs]                    INT             NULL,
    [NetEarning]              DECIMAL (18, 2) NULL,
    [Bonus]                   DECIMAL (18, 2) NULL,
    [CreatedDate]             DATETIME        NULL,
    [UpdatedDate]             DATETIME        NULL,
    [IsDeleted]               BIT             NULL
);

