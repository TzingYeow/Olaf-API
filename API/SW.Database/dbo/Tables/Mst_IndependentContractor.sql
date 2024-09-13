CREATE TABLE [dbo].[Mst_IndependentContractor] (
    [IndependentContractorId]         INT             IDENTITY (1, 1) NOT NULL,
    [BadgeNo]                         NVARCHAR (50)   NOT NULL,
    [OriginalBadgeNo]                 NVARCHAR (50)   NULL,
    [OriginalIndependentContractorId] INT             NULL,
    [FirstName]                       NVARCHAR (100)  NOT NULL,
    [MiddleName]                      NVARCHAR (100)  NULL,
    [LastName]                        NVARCHAR (100)  NULL,
    [Gender]                          NVARCHAR (6)    NULL,
    [Ic]                              NVARCHAR (30)   NULL,
    [PassportName]                    NVARCHAR (150)  NULL,
    [PassportNo]                      NVARCHAR (30)   NULL,
    [PassportIssueDate]               DATETIME        NULL,
    [PassportExpiredDate]             DATETIME        NULL,
    [PassportIssueCountry]            NVARCHAR (50)   NULL,
    [Dob]                             DATETIME        NULL,
    [PhoneNumber]                     NVARCHAR (50)   NULL,
    [MobileNumber]                    NVARCHAR (50)   NULL,
    [Email]                           NVARCHAR (150)  NULL,
    [Nationality]                     NVARCHAR (50)   NOT NULL,
    [MarketingCompanyId]              INT             NOT NULL,
    [MarketingCompanyBranchId]        INT             NULL,
    [ReportBadgeNo]                   NVARCHAR (50)   NULL,
    [IndependentContractorLevelId]    INT             NOT NULL,
    [StartDate]                       DATETIME        NULL,
    [DateFirstOnField]                DATETIME        NULL,
    [LastSalesSubmissionDate]         DATETIME        NULL,
    [EducationLevel]                  NVARCHAR (50)   NULL,
    [MaritalStatus]                   NVARCHAR (50)   NULL,
    [BirthPlace]                      NVARCHAR (50)   NULL,
    [PermanentAddress]                NVARCHAR (255)  NULL,
    [Beneficiary1]                    NVARCHAR (150)  NULL,
    [Beneficiary2]                    NVARCHAR (150)  NULL,
    [AddressLine1]                    NVARCHAR (150)  NULL,
    [AddressLine2]                    NVARCHAR (150)  NULL,
    [AddressLine3]                    NVARCHAR (150)  NULL,
    [AddressCity]                     NVARCHAR (80)   NULL,
    [AddressPostCode]                 NVARCHAR (20)   NULL,
    [AddressState]                    NVARCHAR (100)  NULL,
    [AddressCountry]                  NVARCHAR (30)   NULL,
    [EmergencyContactPerson]          NVARCHAR (150)  NULL,
    [EmergencyContactRelationship]    NVARCHAR (20)   NULL,
    [EmergencyContactPhoneNumber]     NVARCHAR (20)   NULL,
    [RecruitmentType]                 NVARCHAR (25)   NULL,
    [RecruiterBadgeNoOrName]          NVARCHAR (100)  NULL,
    [RecruiterNote]                   NVARCHAR (MAX)  NULL,
    [RecruitmentSource]               NVARCHAR (50)   NULL,
    [AdvertisementTitle]              NVARCHAR (50)   NULL,
    [BankName]                        NVARCHAR (200)  NULL,
    [BankBranch]                      NVARCHAR (200)  NULL,
    [BankAccountNo]                   NVARCHAR (50)   NULL,
    [BankAccountName]                 NVARCHAR (100)  NULL,
    [BankSwiftCode]                   NVARCHAR (50)   NULL,
    [TaxNumber]                       NVARCHAR (500)  NULL,
    [ReturnMaterialRemarks]           NVARCHAR (255)  NULL,
    [AppPassword]                     NVARCHAR (10)   NULL,
    [Status]                          NVARCHAR (50)   NOT NULL,
    [BondPercentage]                  DECIMAL (18, 2) NULL,
    [BondLimit]                       DECIMAL (18, 2) NULL,
    [ProfilePicture]                  NVARCHAR (MAX)  NULL,
    [BulletinPicture]                 NVARCHAR (MAX)  NULL,
    [RecruitmentCandidateId]          INT             NULL,
    [HasMissingInformation]           BIT             NOT NULL,
    [Remark]                          NVARCHAR (MAX)  NULL,
    [IsStayBackTeam]                  BIT             NULL,
    [IsGoBackTeam]                    BIT             NULL,
    [EffectiveAdvancementDate]        DATETIME        NULL,
    [LastDeactivateDate]              DATETIME        NULL,
    [FirstAttemptScore]               NVARCHAR (50)   NULL,
    [FirstAttemptSubDate]             DATETIME        NULL,
    [SecondAttemptScore]              NVARCHAR (50)   NULL,
    [SecondAttemptSubDate]            DATETIME        NULL,
    [Nickname]                        NVARCHAR (100)  NULL,
    [PaymentSchema]                   NVARCHAR (50)   NULL,
    [TeamName]                        NVARCHAR (50)   NULL,
    [LocalFirstName]                  NVARCHAR (255)  NULL,
    [LocalLastName]                   NVARCHAR (50)   NULL,
    [IsPartime]                       BIT             NOT NULL,
    [WithHoldingTax]                  FLOAT (53)      NULL,
    [Nhi]                             FLOAT (53)      NULL,
    [IsTemporary]                     BIT             NOT NULL,
    [IsDeleted]                       BIT             NOT NULL,
    [CreatedBy]                       NVARCHAR (50)   NULL,
    [CreatedDate]                     DATETIME        NULL,
    [UpdatedBy]                       NVARCHAR (50)   NULL,
    [UpdatedDate]                     DATETIME        NULL,
    [AgreementSignedDate]             DATETIME        NULL,
    [OverridesSavings]                DECIMAL (18, 2) NULL,
    [ICSavings]                       DECIMAL (18, 2) NULL,
    [BankCountryCode]                 VARCHAR (200)   NULL,
    [RecruitmentSubSource]            NVARCHAR (50)   NULL,
    [SalesBranch]                     NVARCHAR (50)   NULL,
    [BAType]                          NVARCHAR (10)   NULL,
    [IsQREnabled]                     BIT             NULL,
    [ApplicationFormUrl]              NVARCHAR (MAX)  NULL,
    [IsSuspended]                     BIT             DEFAULT ((0)) NOT NULL,
    [TransferFromID]                  NVARCHAR (10)   DEFAULT (NULL) NULL,
    [TransferToID]                    NVARCHAR (10)   DEFAULT (NULL) NULL,
    [TransferLatestID]                NVARCHAR (10)   DEFAULT (NULL) NULL,
    CONSTRAINT [PK_Mst_IndependentContractor] PRIMARY KEY CLUSTERED ([IndependentContractorId] ASC),
    CONSTRAINT [FK_dbo.Mst_IndependentContractor_dbo.Mst_IndependentContractor_OriginalIndependentContractorId] FOREIGN KEY ([OriginalIndependentContractorId]) REFERENCES [dbo].[Mst_IndependentContractor] ([IndependentContractorId]),
    CONSTRAINT [FK_dbo.Mst_IndependentContractor_dbo.Mst_IndependentContractorLevel_IndependentContractorLevelId] FOREIGN KEY ([IndependentContractorLevelId]) REFERENCES [dbo].[Mst_IndependentContractorLevel] ([IndependentContractorLevelId]) ON DELETE CASCADE,
    CONSTRAINT [FK_dbo.Mst_IndependentContractor_dbo.Mst_MarketingCompany_MarketingCompanyId] FOREIGN KEY ([MarketingCompanyId]) REFERENCES [dbo].[Mst_MarketingCompany] ([MarketingCompanyId]) ON DELETE CASCADE,
    CONSTRAINT [FK_dbo.Mst_IndependentContractor_dbo.Mst_RecruitmentCandidate_RecruitmentCandidateId] FOREIGN KEY ([RecruitmentCandidateId]) REFERENCES [dbo].[Mst_RecruitmentCandidate] ([RecruitmentCandidateId])
);


GO
CREATE NONCLUSTERED INDEX [IX_BadgeNo]
    ON [dbo].[Mst_IndependentContractor]([BadgeNo] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_OriginalIndependentContractorId]
    ON [dbo].[Mst_IndependentContractor]([OriginalIndependentContractorId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_MarketingCompanyId]
    ON [dbo].[Mst_IndependentContractor]([MarketingCompanyId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_IndependentContractorLevelId]
    ON [dbo].[Mst_IndependentContractor]([IndependentContractorLevelId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_RecruitmentCandidateId]
    ON [dbo].[Mst_IndependentContractor]([RecruitmentCandidateId] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_IndependentContractor]
    ON [dbo].[Mst_IndependentContractor]([IsDeleted] ASC, [LastDeactivateDate] ASC)
    INCLUDE([BadgeNo], [MarketingCompanyId], [Status]);


GO
CREATE NONCLUSTERED INDEX [idx_IndependentContractor_suspended]
    ON [dbo].[Mst_IndependentContractor]([IsDeleted] ASC, [IsSuspended] ASC)
    INCLUDE([BadgeNo], [MarketingCompanyId], [Status]);


GO
CREATE NONCLUSTERED INDEX [IX_IndependentContractor_Status ]
    ON [dbo].[Mst_IndependentContractor]([Status] ASC);

