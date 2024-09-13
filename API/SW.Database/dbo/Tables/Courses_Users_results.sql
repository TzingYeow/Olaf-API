CREATE TABLE [dbo].[Courses_Users_results] (
    [Id]                      INT      IDENTITY (1, 1) NOT NULL,
    [EloomiUserId]            INT      NULL,
    [CourseId]                INT      NULL,
    [IndependentContractorId] INT      NULL,
    [Status]                  INT      NULL,
    [data_created_at]         DATETIME NULL,
    [data_updated_at]         DATETIME NULL,
    CONSTRAINT [PK_Courses_Users_results] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_EloomiUserId_CourseId]
    ON [dbo].[Courses_Users_results]([EloomiUserId] ASC, [CourseId] ASC);

