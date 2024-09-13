﻿CREATE TABLE [dbo].[Eloomi_Course_Participants_Data] (
    [id]                    INT             IDENTITY (1, 1) NOT NULL,
    [course_id]             INT             NOT NULL,
    [user_id]               INT             NOT NULL,
    [company_id]            INT             NULL,
    [name]                  NVARCHAR (100)  NULL,
    [image_id]              INT             NULL,
    [progress]              INT             NULL,
    [status]                NVARCHAR (100)  NULL,
    [time_spent_string]     NVARCHAR (50)   NULL,
    [score]                 DECIMAL (18, 2) NULL,
    [completed_at]          NVARCHAR (30)   NULL,
    [started_at]            NVARCHAR (30)   NULL,
    [attempts]              INT             NULL,
    [deadline]              NVARCHAR (30)   NULL,
    [completed_by]          NVARCHAR (50)   NULL,
    [assigned_at]           NVARCHAR (30)   NULL,
    [participant_type]      NVARCHAR (50)   NULL,
    [do_notify]             INT             NULL,
    [renewal_type]          NVARCHAR (50)   NULL,
    [renewal_from_date]     NVARCHAR (50)   NULL,
    [renewal_from_interval] NVARCHAR (50)   NULL,
    [renewal_from_function] NVARCHAR (50)   NULL,
    [renewal_period]        NVARCHAR (10)   NULL,
    [renewal_apply_from]    NVARCHAR (50)   NULL,
    [expired_at]            NVARCHAR (30)   NULL,
    [renewal_period_start]  NVARCHAR (30)   NULL,
    [total_renewals]        INT             NULL,
    [total_renewed]         INT             NULL,
    [renewal_at]            NVARCHAR (30)   NULL,
    [course_description]    NVARCHAR (MAX)  NULL,
    [course_name]           NVARCHAR (50)   NULL,
    [course_type]           NVARCHAR (50)   NULL,
    [data_inserted_at]      DATETIME        NULL,
    CONSTRAINT [PK_Eloomi_Course_Participants_Data] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_CourseId_UserId]
    ON [dbo].[Eloomi_Course_Participants_Data]([course_id] ASC, [user_id] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_CourseId_UserId_Attempts]
    ON [dbo].[Eloomi_Course_Participants_Data]([course_id] ASC, [user_id] ASC, [attempts] ASC);

