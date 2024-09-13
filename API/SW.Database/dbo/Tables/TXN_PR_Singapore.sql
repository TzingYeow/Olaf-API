CREATE TABLE [dbo].[TXN_PR_Singapore] (
    [RowNo]              INT             IDENTITY (1, 1) NOT NULL,
    [ScheduleWeekending] DATE            NULL,
    [MOCode]             NVARCHAR (10)   NULL,
    [BadgeNo]            NVARCHAR (10)   NULL,
    [Division]           NVARCHAR (50)   NULL,
    [BASubPcs]           INT             NULL,
    [BANetEarning]       DECIMAL (18, 2) NULL,
    [BANetBonus1]        DECIMAL (18, 2) NULL,
    [BANetBonus2]        DECIMAL (18, 2) NULL,
    CONSTRAINT [PK_TXN_PR_Singapore] PRIMARY KEY CLUSTERED ([RowNo] ASC)
);

