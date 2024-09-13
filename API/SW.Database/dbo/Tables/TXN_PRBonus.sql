CREATE TABLE [dbo].[TXN_PRBonus] (
    [ScheduleWeekending]               VARCHAR (10)   NOT NULL,
    [CountryCode]                      NVARCHAR (10)  NULL,
    [Code]                             NVARCHAR (10)  NULL,
    [Name]                             NVARCHAR (150) NULL,
    [IndependentContractorId]          INT            NOT NULL,
    [BadgeNo]                          NVARCHAR (50)  NOT NULL,
    [FirstName]                        NVARCHAR (100) NOT NULL,
    [LastName]                         NVARCHAR (100) NULL,
    [StartDate]                        DATETIME       NULL,
    [LastDeactivateDate]               DATETIME       NULL,
    [RecruiterBadgeNoOrName]           NVARCHAR (100) NULL,
    [LastSalesSubmissionDate]          DATETIME       NULL,
    [RecruiterIndependentContractorId] INT            NULL,
    [RecruiterBadgeNo]                 NVARCHAR (50)  NULL,
    [RecruiterFirstName]               NVARCHAR (100) NULL,
    [RecruiterLastName]                NVARCHAR (100) NULL,
    [RecruiterStatus]                  NVARCHAR (50)  NULL,
    [CreatedDate]                      DATETIME       NOT NULL,
    [UpdatedDate]                      DATETIME       NOT NULL,
    [IsDeleted]                        BIT            NULL
);

