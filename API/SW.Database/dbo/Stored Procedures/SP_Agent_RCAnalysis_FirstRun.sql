-- =============================================
-- Author:		Leonard Yong
-- Create date: 2022-09-13
-- Description:	Populate RC Analysis 1
-- =============================================
CREATE PROCEDURE [dbo].[SP_Agent_RCAnalysis_FirstRun]
-- Add the parameters for the stored procedure here

AS
BEGIN
--*****************************************************************
-- TXN_Recruitment_Activity
--*****************************************************************

SELECT BAID,MAX(PromotionDemotionDate) as 'EffectiveDate' INTO #BAIDAdvancement FROM VW_Reporting_TXN_BA_Movement 
 WHERE [Description] = 'Advance' and Level = 'Leader'group by BAId 

 SELECT IndependentContractorId, ISNULL(DateFirstOnField,StartDate) as startDate INTO #BAIDStartDate FROM Mst_IndependentContractor  

-- Prepare All Data
SELECT  *,CAST( NULL AS DATE) ActivityGroupWeekending INTO #TempRaw FROM NewOlaf_Prod..VW_Reporting_TXN_Recruitment_Archived where IsDeleted =0  

   
-- Prepare duplicate First Appointment
SELECT  RecruitmentCandidateId, MAX(ActivityScheduleStartDateTime) ActivityScheduleStartDateTime INTO #TempRaw2 FROm #TempRaw where ActivityStage = 'First-Appointment' and ActivityAppointment = 'Registered' 
GROUP BY RecruitmentCandidateId
HAVING COUNT(*) > 1
order by COUNT(*) DESC


-- Remove Duplicate First Appointment
DELETE A FROM #TempRaw A 
LEFT JOIN #TempRaw2  B ON A.RecruitmentCandidateId = B.RecruitmentCandidateId and CAST(A.ActivityScheduleStartDateTime as date) < CAST(B.ActivityScheduleStartDateTime as date)
WHERE A.ActivityStage = 'First-Appointment' and A.ActivityAppointment = 'Registered' and A.RecruitmentCandidateId in (SELECT RecruitmentCandidateId FROM #TempRaw2)
and B.ActivityScheduleStartDateTime is not null


-- Update Activity Weekending
UPDATE A SET A.ActivityGroupWeekending = B.ActivityScheduleStartWeekending FROM #TempRaw A  INNER JOIN ( 
SELECT RecruitmentCandidateId, MIN(ActivityScheduleStartWeekending) as 'ActivityScheduleStartWeekending' FROM NewOlaf_Prod..VW_Reporting_TXN_Recruitment_Archived
GROUP BY RecruitmentCandidateId
) B ON A.RecruitmentCandidateId = B.RecruitmentCandidateId


DELETE FROM #TempRaw WHERE RecruitmentCandidateActivityLogId is null


 
 

--SELECT * INTO Reporting_Recruitment_Activity2 FROM Reporting_Recruitment_Activity 
 -- Migrate Final Data
TRUNCATE TABLE Reporting_Recruitment_Activity
INSERT INTO Reporting_Recruitment_Activity
SELECT   *,null,null,null FROm #TempRaw


WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM Reporting_Recruitment_Activity where
	ActivityStage = 'First-Appointment' and ActivityAppointment = 'Registered'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM Reporting_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM Reporting_Recruitment_Activity where
	ActivityStage = 'First-Appointment' and ActivityAppointment = 'Registered'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 



WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM Reporting_Recruitment_Activity where
	ActivityStage = 'First-Appointment' and ActivityAppointment = 'Turned-Up'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM Reporting_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM Reporting_Recruitment_Activity where
	ActivityStage = 'First-Appointment' and ActivityAppointment = 'Turned-Up'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 



WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM Reporting_Recruitment_Activity where
	ActivityStage = 'Observation' and ActivityAppointment = 'Registered'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM Reporting_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM Reporting_Recruitment_Activity where
	ActivityStage = 'Observation' and ActivityAppointment = 'Registered'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 



WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM Reporting_Recruitment_Activity where
	ActivityStage = 'Observation' and ActivityAppointment = 'Turned-Up'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM Reporting_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM Reporting_Recruitment_Activity where
	ActivityStage = 'Observation' and ActivityAppointment = 'Turned-Up'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 


WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM Reporting_Recruitment_Activity where
	ActivityStage = 'Induction' and ActivityAppointment = 'Registered'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM Reporting_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM Reporting_Recruitment_Activity where
	ActivityStage = 'Induction' and ActivityAppointment = 'Registered'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 


WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM Reporting_Recruitment_Activity where
	ActivityStage = 'Induction' and ActivityAppointment = 'Turned-Up'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM Reporting_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM Reporting_Recruitment_Activity where
	ActivityStage = 'Induction' and ActivityAppointment = 'Turned-Up'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 



WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM Reporting_Recruitment_Activity where
	ActivityStage = 'Confirmed to Independent Contractor' and ActivityAppointment = 'Confirm'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM Reporting_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM Reporting_Recruitment_Activity where
	ActivityStage = 'Confirmed to Independent Contractor' and ActivityAppointment = 'Confirm'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 




WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM Reporting_Recruitment_Activity where
	ActivityStage = 'Rejected' and ActivityAppointment = 'Registered'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM Reporting_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM Reporting_Recruitment_Activity where
	ActivityStage = 'Rejected' and ActivityAppointment = 'Registered'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 


WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM Reporting_Recruitment_Activity where
	ActivityStage = 'First-Appointment' and ActivityAppointment = 'Cancelled'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM Reporting_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM Reporting_Recruitment_Activity where
	ActivityStage = 'First-Appointment' and ActivityAppointment = 'Cancelled'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 


WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM Reporting_Recruitment_Activity where
	ActivityStage = 'First-Appointment' and ActivityAppointment = 'Reschedule'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM Reporting_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM Reporting_Recruitment_Activity where
	ActivityStage = 'First-Appointment' and ActivityAppointment = 'Reschedule'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 


WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM Reporting_Recruitment_Activity where
	ActivityStage = 'PromoteLeader' and ActivityAppointment = 'PromoteLeader'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM Reporting_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM Reporting_Recruitment_Activity where
	ActivityStage = 'PromoteLeader' and ActivityAppointment = 'PromoteLeader'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 



WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM Reporting_Recruitment_Activity where
	ActivityStage = 'Confirmed to Independent Contractor' and ActivityAppointment = 'Confirmed to Independent Contractor'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM Reporting_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM Reporting_Recruitment_Activity where
	ActivityStage = 'Confirmed to Independent Contractor' and ActivityAppointment = 'Confirmed to Independent Contractor'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 


WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM Reporting_Recruitment_Activity where
	ActivityStage = 'First-Appointment' and ActivityAppointment = 'No-answer'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM Reporting_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM Reporting_Recruitment_Activity where
	ActivityStage = 'First-Appointment' and ActivityAppointment = 'No-answer'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 


WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM Reporting_Recruitment_Activity where
	ActivityStage = 'Observation' and ActivityAppointment = 'Reschedule'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM Reporting_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM Reporting_Recruitment_Activity where
	ActivityStage = 'Observation' and ActivityAppointment = 'Reschedule'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 




WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM Reporting_Recruitment_Activity where
	ActivityStage = 'Induction' and ActivityAppointment = 'Cancelled'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM Reporting_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM Reporting_Recruitment_Activity where
	ActivityStage = 'Induction' and ActivityAppointment = 'Cancelled'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 



WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM Reporting_Recruitment_Activity where
	ActivityStage = 'Revert' and ActivityAppointment = 'Registered'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM Reporting_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM Reporting_Recruitment_Activity where
	ActivityStage = 'Revert' and ActivityAppointment = 'Registered'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 



WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM Reporting_Recruitment_Activity where
	ActivityStage = 'Observation' and ActivityAppointment = 'Cancelled'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM Reporting_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM Reporting_Recruitment_Activity where
	ActivityStage = 'Observation' and ActivityAppointment = 'Cancelled'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 




WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM Reporting_Recruitment_Activity where
	ActivityStage = 'Observation' and ActivityAppointment = 'No-answer'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM Reporting_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM Reporting_Recruitment_Activity where
	ActivityStage = 'Observation' and ActivityAppointment = 'No-answer'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 




WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM Reporting_Recruitment_Activity where
	ActivityStage = 'Induction' and ActivityAppointment = 'Reschedule'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM Reporting_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM Reporting_Recruitment_Activity where
	ActivityStage = 'Induction' and ActivityAppointment = 'Reschedule'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 



WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM Reporting_Recruitment_Activity where
	ActivityStage = 'Induction' and ActivityAppointment = 'No-answer'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM Reporting_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM Reporting_Recruitment_Activity where
	ActivityStage = 'Induction' and ActivityAppointment = 'No-answer'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 


 






UPDATE A SET A.RecruitmentType = B.RecruitmentType FROM Reporting_Recruitment_Activity A 
INNER JOIN Mst_IndependentContractor B ON A.RecruitmentCandidateId = B.RecruitmentCandidateId
WHERE  A.RecruitmentType <>  B.RecruitmentType


UPDATE A SET A.MCCode = B.Code  FROM Reporting_Recruitment_Activity A LEFT JOIN Mst_MarketingCompany B ON A.MCId = B.MarketingCompanyId

UPDATE A SET A.TeamLeaderAdvanceDate = B.EffectiveDate FROM  Reporting_Recruitment_Activity A LEFT JOIN Mst_IndependentContractor C ON A.RecruitmentCandidateId = C.RecruitmentCandidateId LEFT JOIN #BAIDAdvancement B ON C.IndependentContractorId = B.BAId 
UPDATE A SET A.BAStartDate = B.StartDate FROM  Reporting_Recruitment_Activity A LEFT JOIN Mst_IndependentContractor C ON A.RecruitmentCandidateId = C.RecruitmentCandidateId LEFT JOIN #BAIDStartDate B ON C.IndependentContractorId = B.IndependentContractorId

--SELECT B.StartDate,D.WEdate, A.* FROM Reporting_Recruitment_Activity A 
--LEFT JOIN Mst_IndependentContractor C ON A.RecruitmentCandidateId = C.RecruitmentCandidateId 
--LEFT JOIN #BAIDStartDate B ON C.IndependentContractorId = B.IndependentContractorId
--LEFT JOIN MST_weekending D ON B.StartDate >= D.FromDate and B.StartDate <= D.ToDate
-- where ActivityStage = 'Confirmed to Independent Contractor'

 
UPDATE A SET A.ActivityScheduleStartDateTime = B.StartDate , A.ActivityScheduleStartWeekending = D.WEdate FROM Reporting_Recruitment_Activity A 
LEFT JOIN Mst_IndependentContractor C ON A.RecruitmentCandidateId = C.RecruitmentCandidateId 
LEFT JOIN #BAIDStartDate B ON C.IndependentContractorId = B.IndependentContractorId
LEFT JOIN MST_weekending D ON B.StartDate >= D.FromDate and B.StartDate <= D.ToDate
 where ActivityStage = 'Confirmed to Independent Contractor'
  
INSERT INTO Reporting_Recruitment_Activity
SELECT distinct   A.BadgeNo
      ,A.IndependentContractorId
      ,'Confirmed to Independent Contractor'
      ,'Confirmed to Independent contractor'
      ,'Confirmed to Independent Contractor'
      ,NULL
      ,NULL
      ,ISNULL(A.DateFirstOnField, ISNULL( A.StartDate,A.CreatedDate))
      ,B.WEdate
      ,A.DateFirstOnField
      ,A.[MarketingCompanyBranchId]
      ,NULL
      ,A.ReportBadgeNo
      ,NULL
      ,A.CreatedDate
      ,A.UpdatedDate
      ,A.CreatedBy
      ,A.[BadgeNo]
      ,A.[FirstName]
      ,A.[MiddleName]
      ,A.[LastName]
      ,A.[Dob]
      ,A.[Email]
      ,A.[Nationality]
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
      ,0
      ,A.[BankCountryCode]
      ,A.MarketingCompanyId
      ,D.Name
      ,D.CountryCode
      ,CASE WHEN D.IsActive = 1 THEN 'Active' ELSE 'Inactive' END
      ,B.WEdate
      ,NULL
      ,ISNULL(A.DateFirstOnField, ISNULL( A.StartDate,A.CreatedDate)), D.Code
  FROM Mst_IndependentContractor A 
  LEFT JOIN Mst_Weekending B ON   ISNULL(A.DateFirstOnField, ISNULL( A.StartDate,A.CreatedDate)) >= B.FromDate and ISNULL(A.DateFirstOnField, ISNULL( A.StartDate,A.CreatedDate)) <= B.ToDate
  LEFT JOIN Mst_MarketingCompany D ON A.MarketingCompanyId = D.MarketingCompanyId 
  WHERE A.RecruitmentCandidateId is null  and A.BadgeNo not in (SELECT RecruitmentCandidateId from  Reporting_Recruitment_Activity)

  
  
INSERT INTO Reporting_Recruitment_Activity
SELECT distinct   A.BadgeNo
      ,A.IndependentContractorId
      ,'Confirmed to Independent Contractor'
      ,'Confirmed to independent Contractor'
      ,'Confirmed to Independent Contractor'
      ,NULL
      ,NULL
      ,ISNULL(A.DateFirstOnField, ISNULL( A.StartDate,A.CreatedDate))
      ,B.WEdate
      ,A.DateFirstOnField
      ,A.[MarketingCompanyBranchId]
      ,NULL
      ,A.ReportBadgeNo
      ,NULL
      ,A.CreatedDate
      ,A.UpdatedDate
      ,A.CreatedBy
      ,A.[BadgeNo]
      ,A.[FirstName]
      ,A.[MiddleName]
      ,A.[LastName]
      ,A.[Dob]
      ,A.[Email]
      ,A.[Nationality]
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
      ,0
      ,A.[BankCountryCode]
      ,A.MarketingCompanyId
      ,D.Name
      ,D.CountryCode
      ,CASE WHEN D.IsActive = 1 THEN 'Active' ELSE 'Inactive' END
      ,B.WEdate
      ,NULL
      ,ISNULL(A.DateFirstOnField, ISNULL( A.StartDate,A.CreatedDate)), D.Code
  FROM Mst_IndependentContractor A 
  LEFT JOIN Mst_Weekending B ON   ISNULL(A.DateFirstOnField, ISNULL( A.StartDate,A.CreatedDate)) >= B.FromDate and ISNULL(A.DateFirstOnField, ISNULL( A.StartDate,A.CreatedDate)) <= B.ToDate
  LEFT JOIN Mst_MarketingCompany D ON A.MarketingCompanyId = D.MarketingCompanyId 
  WHERE A.IsDeleted = 0 and A.StartDate is not null and RecruitmentCandidateId is not null and RecruitmentCandidateId not in (
SELECT  RecruitmentCandidateId FROM Mst_RecruitmentCandidate_ActivityLog where Stage = 'Confirmed to Independent Contractor'
)
  


  --Stop here
INSERT INTO Reporting_Recruitment_Activity
SELECT distinct   A.BadgeNo
      ,A.IndependentContractorId
      ,'PromoteLeader'
      ,'PromoteLeader'
      ,'PromoteLeader'
      ,NULL
      ,NULL
      ,E.EffectiveDate
      ,B.WEdate
      ,E.EffectiveDate
      ,A.[MarketingCompanyBranchId]
      ,NULL
      ,A.ReportBadgeNo
      ,NULL
      ,A.CreatedDate
      ,A.UpdatedDate
      ,A.CreatedBy
      ,A.[BadgeNo]
      ,A.[FirstName]
      ,A.[MiddleName]
      ,A.[LastName]
      ,A.[Dob]
      ,A.[Email]
      ,A.[Nationality]
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
      ,0
      ,A.[BankCountryCode]
      ,A.MarketingCompanyId
      ,D.Name
      ,D.CountryCode
      ,CASE WHEN D.IsActive = 1 THEN 'Active' ELSE 'Inactive' END
      ,B.WEdate
      ,NULL
      ,A.DateFirstOnField, D.Code
  FROM Mst_IndependentContractor A 
  INNER JOIN #BAIDAdvancement E ON A.IndependentContractorId = E.BAId
  LEFT JOIN Mst_MarketingCompany D ON A.MarketingCompanyId = D.MarketingCompanyId 
  LEFT JOIN Mst_Weekending B ON E.EffectiveDate >= B.FromDate and E.EffectiveDate <= B.ToDate
  WHERE A.RecruitmentCandidateId is null --and  -- and A.BadgeNo not in (SELECT RecruitmentCandidateId from  NewRegionalReporting..TXN_Recruitment_Activity)
 

 INSERT INTO Reporting_Recruitment_Activity
SELECT distinct  A.[RecruitmentCandidateId]
      ,A.[RecruitmentCandidateActivityLogId]
      ,'PromoteLeader'
      ,'PromoteLeader'
      ,'PromoteLeader'
      ,A.[ActivityUnsuitableStatus]
      ,A.[ActivityNotSucceedReason]
      ,A.TeamLeaderAdvanceDate
      ,B.WEdate
      ,A.[ActivityScheduleEndDateTime]
      ,A.[ActivityMarketingCompanyBranchId]
      ,A.[ActivityLocation]
      ,A.[ActivityLeaderBadgeNo]
      ,A.[ActivityRemark]
      ,A.[ActivityCreatedDate]
      ,A.[ActivityUpdatedDate]
      ,A.[ActivityConductedBy]
      ,A.[BadgeNo]
      ,A.[FirstName]
      ,A.[MiddleName]
      ,A.[LastName]
      ,A.[Dob]
      ,A.[Email]
      ,A.[Nationality]
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
      ,A.[BankCountryCode]
      ,A.[MCId]
      ,A.[MCName]
      ,A.[MCCountry]
      ,A.[MCStatus]
      ,A.[ActivityGroupWeekending]
      ,A.[TeamLeaderAdvanceDate]
      ,A.[BAStartDate],  C.Code
  FROM [dbo].[Reporting_Recruitment_Activity] A LEFT JOIN Mst_Weekending B ON A.TeamLeaderAdvanceDate >= B.FromDate and A.TeamLeaderAdvanceDate <= B.ToDate
  LEFT JOIN Mst_MarketingCompany C ON A.MCId = C.MarketingCompanyId
WHERE TeamLeaderAdvanceDate is not null and RecruitmentCandidateActivityLogId in (

 SELECT MAX(RecruitmentCandidateActivityLogId) FROM [dbo].[Reporting_Recruitment_Activity] A 
WHERE ActivityStage = 'Confirmed to Independent Contractor'
 GROUP BY RecruitmentCandidateId
 )

  
 -- Migrate Final Data to RegionalReporting
TRUNCATE TABLE NewRegionalReporting..TXN_Recruitment_Activity
INSERT INTO NewRegionalReporting..TXN_Recruitment_Activity
SELECT   * FROm Reporting_Recruitment_Activity


 
UPDATE A SET A.ActivityScheduleStartDateTime = B.StartDate , A.ActivityScheduleStartWeekending = D.WEdate FROM NewRegionalReporting..TXN_Recruitment_Activity A 
LEFT JOIN Mst_IndependentContractor C ON A.RecruitmentCandidateId = C.RecruitmentCandidateId 
LEFT JOIN #BAIDStartDate B ON C.IndependentContractorId = B.IndependentContractorId
LEFT JOIN MST_weekending D ON B.StartDate >= D.FromDate and B.StartDate <= D.ToDate
 where ActivityStage = 'Confirmed to Independent Contractor' and CountryRunningNumber <> 0

  
 SELECT A.RecruitmentCandidateId, B.IndependentContractorId, ActivityGroupWeekending INTO #BAAtivityGroup FROm Reporting_Recruitment_Activity A 
 LEFT JOIN Mst_IndependentContractor B ON A.RecruitmentCandidateId = B.RecruitmentCandidateId where A.CountryRunningNumber <> 0

--*****************************************************************
-- MST_DivisionCampaign
--***************************************************************** 
TRUNCATE TABLE NewRegionalReporting..MST_DivisionCampaign
INSERT INTO NewRegionalReporting..MST_DivisionCampaign
SELECT * FROM VW_Reporting_DivisionCampaign


--*****************************************************************
-- MST_IndependentContractor
--***************************************************************** 
TRUNCATE TABLE NewRegionalReporting..MST_IndependentContractor
INSERT INTO NewRegionalReporting..MST_IndependentContractor
SELECT *,NULL,NULL FROM VW_Reporting_BA

UPDATE A SET A.LeaderAdvanceDate = B.EffectiveDate FROM  NewRegionalReporting..MST_IndependentContractor A LEFT JOIN #BAIDAdvancement B ON A.BAId = B.BAId
UPDATE A SET A.ActivityGroupWeekending = B.ActivityGroupWeekending FROM  NewRegionalReporting..MST_IndependentContractor A LEFT JOIN #BAAtivityGroup B ON A.BAId = B.IndependentContractorId

--*****************************************************************
-- MST_MarketingCompany
--***************************************************************** 
TRUNCATE TABLE NewRegionalReporting..MST_MarketingCompany
INSERT INTO NewRegionalReporting..MST_MarketingCompany
SELECT * FROM VW_Reporting_MC

--*****************************************************************
-- MST_Recruiter
--***************************************************************** 
TRUNCATE TABLE NewRegionalReporting..MST_Recruiter
INSERT INTO NewRegionalReporting..MST_Recruiter
SELECT * FROM VW_Reporting_Recruiter


--*****************************************************************
-- TXN_IndependentContractor_Movement
--***************************************************************** 
TRUNCATE TABLE NewRegionalReporting..TXN_IndependentContractor_Movement
INSERT INTO NewRegionalReporting..TXN_IndependentContractor_Movement
SELECT *,null,null,null,NULL, NULL, null FROM VW_Reporting_TXN_BA_Movement

UPDATE A SET A.LeaderAdvanceDate = B.EffectiveDate FROM  NewRegionalReporting..TXN_IndependentContractor_Movement A LEFT JOIN #BAIDAdvancement B ON A.BAId = B.BAId
UPDATE A SET A.ActivityGroupWeekending = B.ActivityGroupWeekending FROM  NewRegionalReporting..TXN_IndependentContractor_Movement A LEFT JOIN #BAAtivityGroup B ON A.BAId = B.IndependentContractorId
UPDATE A SET A.BAStartDate = B.StartDate FROM  NewRegionalReporting..TXN_IndependentContractor_Movement A LEFT JOIN #BAIDStartDate B ON A.BAId = B.IndependentContractorId

UPDATE A SET A.DeactivateGroupWeekending = B.WEdate FROM NewRegionalReporting..[TXN_IndependentContractor_Movement] A INNER JOIN (
SELECT A.BAId, B.WEdate FROM (
SELECT BAId, MAX(effectiveDate) effectiveDate FROM NewRegionalReporting..[TXN_IndependentContractor_Movement]  where [Description] in ('Deactivate','Terminate') and HasExecuted = 1 GROUP BY BAID
) A LEFT JOIN MST_Weekending B ON A.effectiveDate >= B.FromDate and A.effectiveDate <= B.ToDate
) B ON A.BAId = B.BAId

-- Remove multiple Deactivate
WHILE (
	SELECT COUNT(*) FROM (
	SELECT BAId FROM NewRegionalReporting..[TXN_IndependentContractor_Movement]  where
	Description = 'Deactivate'  
	GROUP BY BAId
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM NewRegionalReporting..[TXN_IndependentContractor_Movement] A INNER JOIN 
	(
	SELECT BAId, MAX(IndependentContractorMovementId) IndependentContractorMovementId FROM  NewRegionalReporting..[TXN_IndependentContractor_Movement]
	where Description = 'Deactivate'   
	GROUP BY BAId
	having COUNT(*)> 1
	) B ON A.BAId = B.BAId and A.IndependentContractorMovementId = B.IndependentContractorMovementId
END 
	

 

UPDATE A SET A.RecruitmentType = B.RecruitmentType FROM NewRegionalReporting..TXN_IndependentContractor_Movement A 
INNER JOIN Mst_IndependentContractor B ON A.BAId = B.IndependentContractorId
WHERE   A.RecruitmentType is null


 UPDATE a set a.rcid = B.RecruitmentCandidateId FROM NewRegionalReporting..TXN_IndependentContractor_Movement   A 
 LEFT JOIN Mst_IndependentContractor B ON A.BAId = B.IndependentContractorId  

--*****************************************************************
-- TXN_Recruitment
--***************************************************************** 
TRUNCATE TABLE NewRegionalReporting..TXN_Recruitment
INSERT INTO NewRegionalReporting..TXN_Recruitment
SELECT * FROM VW_Reporting_TXN_Recruitment

UPDATE A SET A.RecruitmentType = B.RecruitmentType FROM NewRegionalReporting..TXN_Recruitment A INNER JOIN Mst_IndependentContractor B ON A.RecruitmentCandidateId = B.RecruitmentCandidateId
WHERE A.RecruitmentType <> B.RecruitmentType
--*****************************************************************
-- TXN_BAStatus
--***************************************************************** 
 
--TRUNCATE TABLE NewRegionalReporting..TXN_BAStatus
--INSERT INTO NewRegionalReporting..TXN_BAStatus
--SELECT DISTINCT A.IndependentContractorId as 'BAID', BadgeNo, B.MarketingCompanyId as 'MCID', B.Name as 'MCName', A.DateFirstOnField as 'StartDate', C.WEdate as 'StartDateWeekending', A.LastDeactivateDate, D.WEdate as 'LastDeactivateWeekending', A.Status, A.RecruitmentType, E.ActivityGroupWeekending, B.CountryCode, F.Level
-- FROM Mst_IndependentContractor A LEFT JOIN Mst_MarketingCompany B ON A.MarketingCompanyId = B.MarketingCompanyId
-- LEFT JOIN Mst_Weekending C ON A.DateFirstOnField >= C.FromDate and A.DateFirstOnField <= C.ToDate
-- LEFT JOIN Mst_Weekending D ON A.LastDeactivateDate >= D.FromDate and A.LastDeactivateDate <= D.ToDate
-- LEFT JOIN #BAAtivityGroup E ON A.IndependentContractorId = E.IndependentContractorId
-- LEFT JOIN Mst_IndependentContractorLevel F ON A.IndependentContractorLevelId = F.IndependentContractorLevelId



TRUNCATE TABLE NewRegionalReporting..TXN_BAStatus
INSERT INTO NewRegionalReporting..TXN_BAStatus
SELECT B.IndependentContractorId, B.BadgeNo,  C.MarketingCompanyId, C.Name, A.ActivityScheduleStartDateTime, A.ActivityScheduleStartWeekending, B.LastDeactivateDate, 
D.WEdate as 'LastDeactivateWeekending', B.Status, B.RecruitmentType, A.ActivityGroupWeekending, A.MCCountry, F.Level, B.RecruitmentCandidateId FROM Reporting_Recruitment_Activity A 
LEFT JOIN Mst_IndependentContractor B ON A.RecruitmentCandidateId = B.RecruitmentCandidateId-- and A.mcid = B.MarketingCompanyId
LEFT JOIN Mst_MarketingCompany C ON B.MarketingCompanyId = C.MarketingCompanyId
 LEFT JOIN Mst_Weekending D ON B.LastDeactivateDate >= D.FromDate and B.LastDeactivateDate <= D.ToDate
 LEFT JOIN Mst_IndependentContractorLevel F ON B.IndependentContractorLevelId = F.IndependentContractorLevelId
WHERE A.IsDeleted = 0 and B.IsDeleted = 0 and A.BadgeNo is null  and  CountryRunningNumber <> 0 and  ActivityStage = 'Confirmed to Independent Contractor' and B.BadgeNo is not null   and ISNULL(B.StartDate,'3000-01-01') <= (SELECT MAX(WEdate) FROM Mst_Weekending)
-- and MCCountry ='TH' and ActivityGroupWeekending = '2020-09-03'
  UNION ALL
  SELECT B.IndependentContractorId, B.BadgeNo,  C.MarketingCompanyId, C.Name, A.ActivityScheduleStartDateTime, A.ActivityScheduleStartWeekending, B.LastDeactivateDate, 
D.WEdate as 'LastDeactivateWeekending', B.Status, B.RecruitmentType, A.ActivityGroupWeekending, A.MCCountry, F.Level, B.RecruitmentCandidateId FROM Reporting_Recruitment_Activity A 
LEFT JOIN Mst_IndependentContractor B ON A.RecruitmentCandidateId = B.BadgeNo and A.MCId = B.MarketingCompanyId
LEFT JOIN Mst_MarketingCompany C ON B.MarketingCompanyId = C.MarketingCompanyId 
 LEFT JOIN Mst_Weekending D ON B.LastDeactivateDate >= D.FromDate and B.LastDeactivateDate <= D.ToDate
 LEFT JOIN Mst_IndependentContractorLevel F ON B.IndependentContractorLevelId = F.IndependentContractorLevelId
WHERE   A.IsDeleted = 0 and B.IsDeleted = 0 and CountryRunningNumber = 0 and  ActivityStage = 'Confirmed to Independent Contractor'  and ISNULL(B.StartDate,'3000-01-01') <= (SELECT MAX(WEdate) FROM Mst_Weekending)
-- and MCCountry ='TH' and ActivityGroupWeekending = '2020-09-10'


 
--*****************************************************************
-- Clear Duplicate
--***************************************************************** 
  
WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'First-Appointment' and ActivityAppointment = 'Registered'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM NewRegionalReporting..TXN_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'First-Appointment' and ActivityAppointment = 'Registered'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 



WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'First-Appointment' and ActivityAppointment = 'Turned-Up'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM NewRegionalReporting..TXN_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'First-Appointment' and ActivityAppointment = 'Turned-Up'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 

WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'Observation' and ActivityAppointment = 'Registered'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM NewRegionalReporting..TXN_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'Observation' and ActivityAppointment = 'Registered'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 


WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'Observation' and ActivityAppointment = 'Turned-Up'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM NewRegionalReporting..TXN_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'Observation' and ActivityAppointment = 'Turned-Up'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 


WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'Induction' and ActivityAppointment = 'Registered'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM NewRegionalReporting..TXN_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'Induction' and ActivityAppointment = 'Registered'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 


WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'Induction' and ActivityAppointment = 'Turned-Up'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM NewRegionalReporting..TXN_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'Induction' and ActivityAppointment = 'Turned-Up'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 



WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'Confirmed to Independent Contractor' and ActivityAppointment = 'Confirm'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM NewRegionalReporting..TXN_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'Confirmed to Independent Contractor' and ActivityAppointment = 'Confirm'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 


WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'Rejected' and ActivityAppointment = 'Registered'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM NewRegionalReporting..TXN_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'Rejected' and ActivityAppointment = 'Registered'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 


WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'First-Appointment' and ActivityAppointment = 'Cancelled'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM NewRegionalReporting..TXN_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'First-Appointment' and ActivityAppointment = 'Cancelled'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 

WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'First-Appointment' and ActivityAppointment = 'Reschedule'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM NewRegionalReporting..TXN_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'First-Appointment' and ActivityAppointment = 'Reschedule'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 

WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'PromoteLeader' and ActivityAppointment = 'PromoteLeader'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM NewRegionalReporting..TXN_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'PromoteLeader' and ActivityAppointment = 'PromoteLeader'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 


WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'Confirmed to Independent Contractor' and ActivityAppointment = 'Confirmed to Independent Contractor'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM NewRegionalReporting..TXN_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'Confirmed to Independent Contractor' and ActivityAppointment = 'Confirmed to Independent Contractor'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 

WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'First-Appointment' and ActivityAppointment = 'No-answer'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM NewRegionalReporting..TXN_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'First-Appointment' and ActivityAppointment = 'No-answer'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 

WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'Observation' and ActivityAppointment = 'Reschedule'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM NewRegionalReporting..TXN_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'Observation' and ActivityAppointment = 'Reschedule'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 



WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'Induction' and ActivityAppointment = 'Cancelled'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM NewRegionalReporting..TXN_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'Induction' and ActivityAppointment = 'Cancelled'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 


WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'Revert' and ActivityAppointment = 'Registered'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM NewRegionalReporting..TXN_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'Revert' and ActivityAppointment = 'Registered'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 



WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'Observation' and ActivityAppointment = 'Cancelled'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM NewRegionalReporting..TXN_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'Observation' and ActivityAppointment = 'Cancelled'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 



WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'Observation' and ActivityAppointment = 'No-answer'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM NewRegionalReporting..TXN_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'Observation' and ActivityAppointment = 'No-answer'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 



WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'Induction' and ActivityAppointment = 'Reschedule'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM NewRegionalReporting..TXN_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'Induction' and ActivityAppointment = 'Reschedule'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 


WHILE (
	SELECT COUNT(*) FROM (
	SELECT RecruitmentCandidateId FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'Induction' and ActivityAppointment = 'No-answer'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)> 1
	) A
) > 0
BEGIN 

	DELETE A FROM NewRegionalReporting..TXN_Recruitment_Activity A INNER JOIN 
	(
	SELECT RecruitmentCandidateId, MIN(RecruitmentCandidateActivityLogID) RecruitmentCandidateActivityLogID FROM NewRegionalReporting..TXN_Recruitment_Activity where
	ActivityStage = 'Induction' and ActivityAppointment = 'No-answer'
	GROUP BY RecruitmentCandidateId, ActivityStage, ActivityAppointment
	having COUNT(*)>1
	) B ON A.RecruitmentCandidateActivityLogID = B.RecruitmentCandidateActivityLogID and A.RecruitmentCandidateId = B.RecruitmentCandidateId
END 


--*****************************************************************
-- Clear Duplicate
--***************************************************************** 
 

DROP TABLE #BAIDAdvancement
DROP TABLE #BAIDStartDate
DROP TABLE #BAAtivityGroup
DROP TABLE #TempRaw
DROP TABLE #TempRaw2

 
 END
