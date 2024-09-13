﻿CREATE TABLE [dbo].[Mst_MasterCode] (
    [id]                    INT             IDENTITY (1, 1) NOT NULL,
    [CodeType]              NVARCHAR (50)   NOT NULL,
    [CodeId]                NVARCHAR (50)   NULL,
    [CodeName]              NVARCHAR (100)  NOT NULL,
    [CodeDescription]       NVARCHAR (100)  NULL,
    [CodeIcon]              VARBINARY (50)  NULL,
    [ParentId]              INT             NULL,
    [IsActive]              BIT             NOT NULL,
    [CreatedBy]             NVARCHAR (50)   NOT NULL,
    [CreatedDate]           DATETIME        NOT NULL,
    [UpdatedBy]             NVARCHAR (50)   NULL,
    [UpdatedDate]           DATETIME        NULL,
    [HasLocale]             BIT             NOT NULL,
    [RefMessage]            NVARCHAR (256)  NULL,
    [RefString1]            NVARCHAR (256)  NULL,
    [RefString1Description] NVARCHAR (256)  NULL,
    [RefString2]            NVARCHAR (256)  NULL,
    [RefString2Description] NVARCHAR (256)  NULL,
    [RefDecimal]            DECIMAL (10, 2) NULL,
    [RefDecimalDescription] NVARCHAR (256)  NULL,
    [RefBoolean]            BIT             NULL,
    [RefBooleanDescription] NVARCHAR (256)  NULL,
    CONSTRAINT [PK_Mst_MasterCode] PRIMARY KEY CLUSTERED ([id] ASC) WITH (FILLFACTOR = 90)
);

