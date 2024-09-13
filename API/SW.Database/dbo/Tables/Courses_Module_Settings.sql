CREATE TABLE [dbo].[Courses_Module_Settings] (
    [CourseModuleSettingId] INT            IDENTITY (1, 1) NOT NULL,
    [GroupId]               INT            NOT NULL,
    [CourseName]            NVARCHAR (100) NULL,
    [CourseDescription]     NVARCHAR (MAX) NULL,
    [IsDeleted]             BIT            DEFAULT ((0)) NOT NULL,
    [CreatedBy]             NVARCHAR (50)  NULL,
    [CreatedDate]           DATETIME       NULL,
    [UpdatedBy]             NVARCHAR (50)  NULL,
    [UpdatedDate]           DATETIME       NULL,
    [EloomiCourseId]        INT            NULL,
    [EloomiCategoryId]      INT            NULL,
    CONSTRAINT [PK_Courses_Module_Settings] PRIMARY KEY CLUSTERED ([CourseModuleSettingId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_GroupId]
    ON [dbo].[Courses_Module_Settings]([GroupId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_IsDeleted]
    ON [dbo].[Courses_Module_Settings]([IsDeleted] ASC);

