CREATE TABLE [dbo].[Eloomi_Courses_Data_Archive] (
    [id]                     INT             IDENTITY (1, 1) NOT NULL,
    [course_id]              INT             NOT NULL,
    [name]                   NVARCHAR (100)  NULL,
    [description]            NVARCHAR (MAX)  NULL,
    [cover]                  INT             NULL,
    [active]                 INT             NULL,
    [points]                 NVARCHAR (50)   NULL,
    [reward]                 INT             NULL,
    [expected_duration]      NVARCHAR (50)   NULL,
    [voluntary]              NVARCHAR (50)   NULL,
    [lock_after_deadline]    INT             NULL,
    [inform_leader_deadline] INT             NULL,
    [reference_number]       NVARCHAR (50)   NULL,
    [created_at]             NVARCHAR (30)   NULL,
    [updated_at]             NVARCHAR (30)   NULL,
    [price]                  DECIMAL (18, 4) NULL,
    [data_inserted_at]       DATETIME        NULL,
    [data_archived_at]       DATETIME        NULL,
    CONSTRAINT [PK_Eloomi_Courses_Data_Archive] PRIMARY KEY CLUSTERED ([id] ASC)
);

