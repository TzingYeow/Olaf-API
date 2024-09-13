CREATE TABLE [dbo].[MST_TPTCountryPoint] (
    [Country]         NVARCHAR (2)    NULL,
    [StartWE]         DATE            NULL,
    [EndWE]           DATE            NULL,
    [BALevel]         NVARCHAR (10)   NULL,
    [PointConversion] DECIMAL (18, 2) NULL,
    [IsActive]        BIT             NULL,
    [CreatedBy]       NVARCHAR (50)   NULL,
    [CreatedDate]     DATETIME        NULL
);

