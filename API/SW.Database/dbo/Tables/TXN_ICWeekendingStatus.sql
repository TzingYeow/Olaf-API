CREATE TABLE [dbo].[TXN_ICWeekendingStatus] (
    [BAID]                     INT            NOT NULL,
    [BadgeNo]                  NVARCHAR (50)  NOT NULL,
    [MCID]                     INT            NULL,
    [MCName]                   NVARCHAR (150) NULL,
    [StartDate]                DATETIME       NULL,
    [StartDateWeekending]      DATE           NULL,
    [LastDeactivateDate]       DATETIME       NULL,
    [LastDeactivateWeekending] DATE           NULL,
    [Status]                   NVARCHAR (50)  NOT NULL,
    [RecruitmentType]          NVARCHAR (25)  NULL,
    [ActivityGroupWeekending]  DATE           NULL,
    [CountryCode]              NVARCHAR (50)  NULL,
    [BALevel]                  NVARCHAR (50)  NULL,
    [WEStatus]                 DATE           NULL,
    [ActiveStatus]             BIT            NULL,
    [WESTage]                  NVARCHAR (50)  NULL,
    [MCCode]                   NVARCHAR (50)  NULL
);

