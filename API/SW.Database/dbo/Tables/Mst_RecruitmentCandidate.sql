﻿CREATE TABLE [dbo].[Mst_RecruitmentCandidate] (
    [RecruitmentCandidateId]       INT            IDENTITY (1, 1) NOT NULL,
    [MarketingCompanyId]           INT            NOT NULL,
    [BadgeNo]                      NVARCHAR (50)  NULL,
    [FirstName]                    NVARCHAR (100) NOT NULL,
    [MiddleName]                   NVARCHAR (100) NULL,
    [LastName]                     NVARCHAR (100) NULL,
    [Dob]                          DATETIME       NULL,
    [Email]                        NVARCHAR (150) NULL,
    [Nationality]                  NVARCHAR (50)  NULL,
    [PhoneNumber]                  NVARCHAR (50)  NULL,
    [IsDeleted]                    BIT            NOT NULL,
    [CreatedBy]                    NVARCHAR (50)  NULL,
    [CreatedDate]                  DATETIME       NULL,
    [UpdatedBy]                    NVARCHAR (50)  NULL,
    [UpdatedDate]                  DATETIME       NULL,
    [Remark]                       NVARCHAR (MAX) NULL,
    [EducationLevel]               NVARCHAR (50)  NULL,
    [RecruitmentType]              NVARCHAR (25)  NULL,
    [RecruiterBadgeNoOrName]       NVARCHAR (100) NULL,
    [RecruiterNote]                NVARCHAR (MAX) NULL,
    [RecruitmentSource]            NVARCHAR (50)  NULL,
    [RecruitmentSubSource]         NVARCHAR (50)  NULL,
    [AdvertisementTitle]           NVARCHAR (50)  NULL,
    [AddressLine1]                 NVARCHAR (150) NULL,
    [AddressLine2]                 NVARCHAR (150) NULL,
    [AddressLine3]                 NVARCHAR (150) NULL,
    [AddressCity]                  NVARCHAR (80)  NULL,
    [AddressPostCode]              NVARCHAR (20)  NULL,
    [AddressState]                 NVARCHAR (100) NULL,
    [AddressCountry]               NVARCHAR (30)  NULL,
    [EmergencyContactPerson]       NVARCHAR (150) NULL,
    [EmergencyContactRelationship] NVARCHAR (20)  NULL,
    [EmergencyContactPhoneNumber]  NVARCHAR (20)  NULL,
    [Gender]                       NVARCHAR (6)   NULL,
    [Ic]                           NVARCHAR (30)  NULL,
    [BankName]                     NVARCHAR (200) NULL,
    [BankBranch]                   NVARCHAR (200) NULL,
    [BankAccountName]              NVARCHAR (100) NULL,
    [BankAccountNo]                NVARCHAR (50)  NULL,
    [BankSwiftCode]                NVARCHAR (50)  NULL,
    [PassportName]                 NVARCHAR (150) NULL,
    [PassportNo]                   NVARCHAR (30)  NULL,
    [PassportIssueDate]            DATETIME       NULL,
    [PassportExpiredDate]          DATETIME       NULL,
    [PassportIssueCountry]         NVARCHAR (50)  NULL,
    [Nickname]                     NVARCHAR (100) NULL,
    [TeamName]                     NVARCHAR (50)  NULL,
    [LocalFirstName]               NVARCHAR (255) NULL,
    [LocalLastName]                NVARCHAR (50)  NULL,
    [IsPartime]                    BIT            NOT NULL,
    [IsTemporary]                  BIT            NOT NULL,
    [Status]                       NVARCHAR (50)  NOT NULL,
    [CountryRunningNumber]         INT            NOT NULL,
    [AccessCode]                   NVARCHAR (20)  NOT NULL,
    [BankCountryCode]              VARCHAR (200)  NULL,
    [BAType]                       NVARCHAR (10)  NULL,
    CONSTRAINT [PK_dbo.Mst_RecruitmentCandidate] PRIMARY KEY CLUSTERED ([RecruitmentCandidateId] ASC),
    CONSTRAINT [FK_dbo.Mst_RecruitmentCandidate_dbo.Mst_MarketingCompany_MarketingCompanyId] FOREIGN KEY ([MarketingCompanyId]) REFERENCES [dbo].[Mst_MarketingCompany] ([MarketingCompanyId]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_MarketingCompanyId]
    ON [dbo].[Mst_RecruitmentCandidate]([MarketingCompanyId] ASC);

