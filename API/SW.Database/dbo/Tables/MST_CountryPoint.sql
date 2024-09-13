CREATE TABLE [dbo].[MST_CountryPoint] (
    [Country]         NVARCHAR (2)    NULL,
    [StartWE]         DATE            NULL,
    [EndWE]           DATE            NULL,
    [PointConversion] DECIMAL (18, 2) NULL,
    [IsActive]        BIT             NULL,
    [CreatedBy]       NVARCHAR (50)   NULL,
    [CreatedDate]     DATETIME        NULL
);

