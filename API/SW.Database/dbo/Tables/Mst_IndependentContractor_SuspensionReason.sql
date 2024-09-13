CREATE TABLE [dbo].[Mst_IndependentContractor_SuspensionReason] (
    [SuspensionReasonId] INT            IDENTITY (1, 1) NOT NULL,
    [UserRoleId]         INT            NOT NULL,
    [CountryCode]        NVARCHAR (10)  NOT NULL,
    [Description]        NVARCHAR (300) NOT NULL,
    [PeriodDuration]     INT            NOT NULL,
    [IsDeleted]          BIT            NOT NULL,
    [CreatedBy]          NVARCHAR (50)  NULL,
    [CreatedDate]        DATETIME       NULL,
    CONSTRAINT [PK_dbo.Mst_IndependentContractor_SuspensionReason] PRIMARY KEY CLUSTERED ([SuspensionReasonId] ASC)
);

