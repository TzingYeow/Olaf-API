



 

CREATE VIEW [dbo].[VW_ICDetail]
AS
SELECT A.[IndependentContractorId],A.[BadgeNo],A.[OriginalBadgeNo],A.[OriginalIndependentContractorId],A.[FirstName],A.[MiddleName],A.[LastName],A.[Gender],A.[Ic],A.[PassportName]
,A.[PassportNo],A.[PassportIssueDate],A.[PassportExpiredDate],A.[PassportIssueCountry],A.[Dob],A.[PhoneNumber],A.[MobileNumber],A.[Email],A.[Nationality],A.[MarketingCompanyId]
,A.[MarketingCompanyBranchId],A.[ReportBadgeNo],A.[IndependentContractorLevelId],A.[StartDate],A.[DateFirstOnField],A.[LastSalesSubmissionDate],A.[EducationLevel],A.[MaritalStatus],A.[BirthPlace]
,A.[PermanentAddress],A.[Beneficiary1],A.[Beneficiary2],A.[AddressLine1],A.[AddressLine2],A.[AddressLine3],A.[AddressCity],A.[AddressPostCode],A.[AddressState],A.[AddressCountry]
,A.[EmergencyContactPerson],A.[EmergencyContactRelationship],A.[EmergencyContactPhoneNumber],A.[RecruitmentType],A.[RecruiterBadgeNoOrName],A.[RecruiterNote],A.[RecruitmentSource],A.[AdvertisementTitle]
,A.[BankName],A.[BankBranch],A.[BankAccountNo],A.[BankAccountName],A.[BankSwiftCode],A.[TaxNumber],A.[ReturnMaterialRemarks],A.[AppPassword],A.[Status],A.[BondPercentage],A.[BondLimit]
,A.[ProfilePicture],A.[BulletinPicture],A.[RecruitmentCandidateId],A.[HasMissingInformation],A.[Remark],A.[IsStayBackTeam],A.[IsGoBackTeam],A.[EffectiveAdvancementDate]
,A.[LastDeactivateDate],A.[FirstAttemptScore],A.[FirstAttemptSubDate],A.[SecondAttemptScore],A.[SecondAttemptSubDate],A.[Nickname],A.[PaymentSchema],A.[TeamName],A.[LocalFirstName],A.[LocalLastName],A.[IsPartime],A.[WithHoldingTax]
,A.[Nhi],A.[IsTemporary],A.[IsDeleted],A.[CreatedBy],A.[CreatedDate],A.[UpdatedBy],A.[UpdatedDate],A.[AgreementSignedDate],A.[OverridesSavings]
,A.[ICSavings],A.[BankCountryCode],A.[RecruitmentSubSource],A.[SalesBranch], A.BAType [BAType], C.CodeName  as 'BATypeDesc',  A.[IsQREnabled],A.[ApplicationFormUrl],A.[IsSuspended],A.[TransferFromID],A.[TransferToID],A.[TransferLatestID]
,B.[Code],B.[Name],B.[Email] as 'MC_Email',B.[CountryCode],B.[BankName] as 'MC_BankName',B.[BankAccountNo] as 'MC_BankAccountNo',B.[CompanyLogo],B.[IsActive] as 'MC_IsActive',B.[IsDeleted] as 'MC_IsDeleted',B.[CreatedBy] as 'MC_CreatedBy',B.[CreatedDate] as 'MC_CreatedDate'
,B.[UpdatedBy] as 'MC_UpdatedBy',B.[UpdatedDate] as 'MC_UpdatedDate',B.[TempId],B.[ApplicationFormUrl] as 'MC_ApplicationFormUrl',B.[Banner],B.[BgColor],B.[MarketingCompanyType],B.[Province]
  FROM [dbo].[Mst_IndependentContractor] A 
  LEFT JOIN [dbo].[Mst_MarketingCompany] B ON A.MarketingCompanyId = B.MarketingCompanyId
  LEFT JOIN [dbo].[Mst_MasterCode] C ON C.CodeType = 'BAType' AND C.CodeId = A.BAType
