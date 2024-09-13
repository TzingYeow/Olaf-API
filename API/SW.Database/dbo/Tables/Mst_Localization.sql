CREATE TABLE [dbo].[Mst_Localization] (
    [LocalizationId] INT             IDENTITY (1, 1) NOT NULL,
    [TextTag]        NVARCHAR (100)  NOT NULL,
    [TextType]       NVARCHAR (100)  NOT NULL,
    [Page]           NVARCHAR (150)  NULL,
    [Remark]         NVARCHAR (255)  NULL,
    [ENDescription]  NVARCHAR (2000) NOT NULL,
    [MYDescription]  NVARCHAR (2000) NULL,
    [TWDescription]  NVARCHAR (2000) NULL,
    [HKDescription]  NVARCHAR (2000) NULL,
    [KRDescription]  NVARCHAR (2000) NULL,
    [THDescription]  NVARCHAR (2000) NULL,
    [PHDescription]  NVARCHAR (2000) NULL,
    [IDDescription]  NVARCHAR (2500) NULL,
    [IsDeleted]      BIT             NOT NULL,
    [CreatedBy]      NVARCHAR (50)   NULL,
    [CreatedDate]    DATETIME        NULL,
    [UpdatedBy]      NVARCHAR (50)   NULL,
    [UpdatedDate]    DATETIME        NULL,
    CONSTRAINT [PK_dbo.Mst_Localization] PRIMARY KEY CLUSTERED ([LocalizationId] ASC)
);

