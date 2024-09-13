CREATE TABLE [dbo].[Courses_Grouping] (
    [GroupId]          INT            IDENTITY (1, 1) NOT NULL,
    [GroupDescription] NVARCHAR (MAX) NULL,
    [CountryCode]      NVARCHAR (5)   NULL,
    [Campaign]         NVARCHAR (200) NULL,
    [IsAllCampaign]    BIT            DEFAULT ((0)) NOT NULL,
    [IsCompulsory]     BIT            DEFAULT ((0)) NOT NULL,
    [IsDeleted]        BIT            DEFAULT ((0)) NOT NULL,
    [CreatedBy]        NVARCHAR (50)  NULL,
    [CreatedDate]      DATETIME       NULL,
    [UpdatedBy]        NVARCHAR (50)  NULL,
    [UpdatedDate]      DATETIME       NULL,
    CONSTRAINT [PK_Courses_Grouping] PRIMARY KEY CLUSTERED ([GroupId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_IsDeleted_IsCompulsory]
    ON [dbo].[Courses_Grouping]([IsDeleted] ASC, [IsCompulsory] ASC);

