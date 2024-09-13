







CREATE VIEW [dbo].[VW_Reporting_TXN_Recruitment_Archived]
AS 
 SELECT A.[RecruitmentCandidateId] 
	  ,C.[RecruitmentCandidateActivityLogId]
	  ,C.[Stage] as 'ActivityStage'
      ,C.[Description] as 'ActivityDescription'
      ,C.[AppointmentStatus] as 'ActivityAppointment'
      ,C.[UnsuitableStatus] as 'ActivityUnsuitableStatus'
      ,C.[NotSucceedReason] as 'ActivityNotSucceedReason'
      ,C.[ScheduleStartDateTime] as 'ActivityScheduleStartDateTime'
	  ,W.WEdate as 'ActivityScheduleStartWeekending' 
      ,C.[ScheduleEndDateTime] as 'ActivityScheduleEndDateTime'
      ,C.[MarketingCompanyBranchId] as 'ActivityMarketingCompanyBranchId'
      ,C.[Location] as 'ActivityLocation'
      ,C.[LeaderBadgeNo] as 'ActivityLeaderBadgeNo'
      ,C.[Remark] as 'ActivityRemark'  
      ,C.[CreatedDate] as 'ActivityCreatedDate' 
      ,C.[UpdatedDate]  as 'ActivityUpdatedDate'
      ,C.[ConductedBy]  as 'ActivityConductedBy' 
      ,A.[BadgeNo]
      ,A.[FirstName]
      ,A.[MiddleName]
      ,A.[LastName]
      ,A.[Dob]
      ,A.[Email]
      ,ISNULL(A.[Nationality],'') as 'Nationality'
      ,A.[PhoneNumber]
      ,A.[IsDeleted] 
      ,A.[CreatedDate] 
      ,A.[UpdatedDate]
      ,A.[Remark]
      ,A.[EducationLevel]
      ,A.[RecruitmentType]
      ,A.[RecruiterBadgeNoOrName]
      ,A.[RecruiterNote]
      ,A.[RecruitmentSource]
      ,A.[RecruitmentSubSource]
      ,A.[AdvertisementTitle]
      ,A.[AddressLine1]
      ,A.[AddressLine2]
      ,A.[AddressLine3]
      ,A.[AddressCity]
      ,A.[AddressPostCode]
      ,A.[AddressState]
      ,A.[AddressCountry]
      ,A.[EmergencyContactPerson]
      ,A.[EmergencyContactRelationship]
      ,A.[EmergencyContactPhoneNumber]
      ,A.[Gender]
      ,A.[Ic]
      ,A.[BankName]
      ,A.[BankBranch]
      ,A.[BankAccountName]
      ,A.[BankAccountNo]
      ,A.[BankSwiftCode]
      ,A.[PassportName]
      ,A.[PassportNo]
      ,A.[PassportIssueDate]
      ,A.[PassportExpiredDate]
      ,A.[PassportIssueCountry]
      ,A.[Nickname]
      ,A.[TeamName]
      ,A.[LocalFirstName]
      ,A.[LocalLastName]
      ,A.[IsPartime]
      ,A.[IsTemporary]
      ,A.[Status]
      ,A.[CountryRunningNumber] 
      ,A.[BankCountryCode], A.MarketingCompanyId as 'MCId', B.Name as 'MCName', B.CountryCode as 'MCCountry', CAST(CASE WHEN B.IsActive = 1 THEN 'Active' Else 'Inactive' END as nvarchar(10)) as  'MCStatus'
	  FROM [dbo].[Mst_RecruitmentCandidate] A 
	  LEFT JOIN Mst_MarketingCompany B ON A.MarketingCompanyId = B.MarketingCompanyId
	  LEFT JOIN Mst_RecruitmentCandidate_ActivityLog C ON A.RecruitmentCandidateId = C.RecruitmentCandidateId and C.IsDeleted = 0
	  LEFT JOIN Mst_Weekending W ON CAST(C.ScheduleStartDateTime as date) >= W.FromDate and CAST(C.ScheduleStartDateTime as date) <= W.ToDate

