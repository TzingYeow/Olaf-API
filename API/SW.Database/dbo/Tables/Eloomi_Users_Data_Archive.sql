﻿CREATE TABLE [dbo].[Eloomi_Users_Data_Archive] (
    [id]                     INT            IDENTITY (1, 1) NOT NULL,
    [user_id]                INT            NOT NULL,
    [first_name]             NVARCHAR (80)  NULL,
    [last_name]              NVARCHAR (80)  NULL,
    [employee_id]            NVARCHAR (50)  NULL,
    [email]                  NVARCHAR (80)  NULL,
    [username]               NVARCHAR (50)  NULL,
    [activated_at]           NVARCHAR (30)  NULL,
    [gender]                 NVARCHAR (10)  NULL,
    [birthday]               NVARCHAR (30)  NULL,
    [department_id]          NVARCHAR (150) NULL,
    [user_permission]        NVARCHAR (50)  NULL,
    [start_of_employment_at] NVARCHAR (30)  NULL,
    [end_of_employment_at]   NVARCHAR (30)  NULL,
    [personal_email]         NVARCHAR (50)  NULL,
    [title]                  NVARCHAR (100) NULL,
    [phone]                  NVARCHAR (50)  NULL,
    [mobile_phone]           NVARCHAR (50)  NULL,
    [language]               NVARCHAR (20)  NULL,
    [access_group]           NVARCHAR (150) NULL,
    [generic_role]           NVARCHAR (50)  NULL,
    [country]                NVARCHAR (50)  NULL,
    [location]               NVARCHAR (50)  NULL,
    [timezone]               NVARCHAR (100) NULL,
    [legal]                  NVARCHAR (50)  NULL,
    [level]                  NVARCHAR (50)  NULL,
    [initials]               NVARCHAR (50)  NULL,
    [sub_company]            NVARCHAR (100) NULL,
    [skill_level]            NVARCHAR (50)  NULL,
    [salary_id]              NVARCHAR (50)  NULL,
    [team_id]                NVARCHAR (150) NULL,
    [direct_manager_ids]     NVARCHAR (150) NULL,
    [data_inserted_at]       DATETIME       NULL,
    [data_archived_at]       DATETIME       NULL,
    CONSTRAINT [PK_Eloomi_Users_Data_Archive] PRIMARY KEY CLUSTERED ([id] ASC)
);

