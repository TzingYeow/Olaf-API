CREATE TABLE [dbo].[Mst_DigitalFormRequiredField] (
    [FormRequiredId] INT           IDENTITY (1, 1) NOT NULL,
    [Field]          NVARCHAR (50) NULL,
    [IsActive]       BIT           NULL,
    [IsDeleted]      BIT           NULL,
    [CreatedBy]      NVARCHAR (50) NULL,
    [CreatedDate]    DATETIME      NULL,
    [UpdatedBy]      NVARCHAR (50) NULL,
    [UpdatedDate]    DATETIME      NULL
);

