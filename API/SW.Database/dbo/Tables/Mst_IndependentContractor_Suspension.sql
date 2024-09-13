CREATE TABLE [dbo].[Mst_IndependentContractor_Suspension] (
    [IndependentContractorSuspensionId] INT            IDENTITY (1, 1) NOT NULL,
    [IndependentContractorId]           INT            NOT NULL,
    [Description]                       NVARCHAR (MAX) NOT NULL,
    [IndependentContractorLevelId]      INT            NULL,
    [StartDate]                         DATE           NULL,
    [EndDate]                           DATE           NULL,
    [Remark]                            NVARCHAR (MAX) NULL,
    [IsReactivate]                      BIT            NOT NULL,
    [IsDeleted]                         BIT            NOT NULL,
    [CreatedBy]                         NVARCHAR (50)  NULL,
    [CreatedDate]                       DATETIME       NULL,
    [UpdatedBy]                         NVARCHAR (50)  NULL,
    [UpdatedDate]                       DATETIME       NULL,
    CONSTRAINT [PK_Mst_IndependentContractor_Suspension] PRIMARY KEY CLUSTERED ([IndependentContractorSuspensionId] ASC)
);

