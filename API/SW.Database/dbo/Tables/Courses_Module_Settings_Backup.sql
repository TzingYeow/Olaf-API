CREATE TABLE [dbo].[Courses_Module_Settings_Backup] (
    [CourseModuleSettingId] INT            IDENTITY (1, 1) NOT NULL,
    [GroupId]               INT            NOT NULL,
    [CourseName]            NVARCHAR (100) NULL,
    [CourseDescription]     NVARCHAR (MAX) NULL,
    [IsDeleted]             BIT            NOT NULL,
    [CreatedBy]             NVARCHAR (50)  NULL,
    [CreatedDate]           DATETIME       NULL,
    [UpdatedBy]             NVARCHAR (50)  NULL,
    [UpdatedDate]           DATETIME       NULL,
    [EloomiCourseId]        INT            NULL,
    [EloomiCategoryId]      INT            NULL
);

