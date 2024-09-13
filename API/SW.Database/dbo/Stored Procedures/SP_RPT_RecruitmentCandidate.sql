-- =============================================
-- Author:		Syafiqah Ab Manah
-- Create date: 2022-01-20
-- Description:	Recruitment Candidate List
-- EXEC SP_RPT_RecruitmentCandidate 'ba608c0d064243d88450d8c948e4df40' -- MO ADMIN
-- =============================================
CREATE PROCEDURE [dbo].[SP_RPT_RecruitmentCandidate]
(           
 @userId NVARCHAR(255)  --, @Status NVARCHAR(50) = NULL
)    
AS
BEGIN

DECLARE @CountryCode NVARCHAR(255);
DECLARE @MCId NVARCHAR(10);
DECLARE @IsMOAdminRole BIT;


SELECT 
@CountryCode = CountryAccess,
@IsMOAdminRole = CASE WHEN UserRoleId = 3 THEN  1 ELSE 0 END,
@MCId =  MarketingCompanyId
FROM Mst_User WHERE UserId = @userId

IF OBJECT_ID('tempdb..#SubCountry') IS NOT NULL DROP TABLE #SubCountry
SELECT CAST(VALUE as varchar) as 'Country' INTO #SubCountry FROM STRING_SPLIT(@CountryCode, ',') 

IF OBJECT_ID('tempdb..#MainData') IS NOT NULL DROP TABLE #MainData
SELECT B.CountryCode,B.Name,B.Code, a.RecruitmentCandidateId, a.MarketingCompanyId ,a.FirstName, a.MiddleName, a.LastName, a.PhoneNumber, a.Status, a.AccessCode, a.Gender, a.Ic, a.Dob, a.Nationality, a.Email,
a.PassportNo, a.PassportName, a.PassportIssueDate, a.PassportIssueCountry, a.PassportExpiredDate, a.AddressLine1, AddressLine2, a.AddressLine3, a.AddressCity, a.AddressPostCode, a.AddressState, a.AddressCountry,
a.RecruitmentType, a.RecruiterBadgeNoOrName, a.RecruitmentSource, a.AdvertisementTitle, a.RecruiterNote, a.CreatedBy, a.CreatedDate, a.UpdatedBy,a.UpdatedDate
INTO #MainData FROM Mst_RecruitmentCandidate a 
INNER JOIN Mst_MarketingCompany b on b.MarketingCompanyId = a.MarketingCompanyId
WHERE a.IsDeleted = 0 and a.Status != 'Draft' Order by a.RecruitmentCandidateId desc

IF OBJECT_ID('tempdb..#InterviewDateTime') IS NOT NULL DROP TABLE #InterviewDateTime
SELECT RecruitmentCandidateId,MAX(ScheduleStartDateTime) AS 'InterviewDateTime' INTO #InterviewDateTime FROM Mst_RecruitmentCandidate_ActivityLog WHERE Stage = 'First-Appointment' and AppointmentStatus = 'Registered' and IsDeleted = 0 GROUP BY RecruitmentCandidateId ORDER BY InterviewDateTime DESC

IF OBJECT_ID('tempdb..#InterviewTurnedUp') IS NOT NULL DROP TABLE #InterviewTurnedUp
SELECT RecruitmentCandidateId,MAX(ScheduleStartDateTime) AS 'InterviewTurnedUpDateTime', MAX(REMARK) AS 'TurnedUpRemark' , MAX(ConductedBy) AS 'TurnedUpConductBy'
INTO #InterviewTurnedUp FROM Mst_RecruitmentCandidate_ActivityLog WHERE Stage = 'First-Appointment' and AppointmentStatus = 'Turned-Up' and IsDeleted = 0 GROUP BY RecruitmentCandidateId ORDER BY InterviewTurnedUpDateTime DESC

IF OBJECT_ID('tempdb..#CancelledRemark') IS NOT NULL DROP TABLE #CancelledRemark
SELECT RecruitmentCandidateId,MAX(REMARK) AS 'CancelledRemark' 
INTO #CancelledRemark FROM Mst_RecruitmentCandidate_ActivityLog WHERE Stage = 'First-Appointment' and AppointmentStatus = 'Cancelled' and IsDeleted = 0 GROUP BY RecruitmentCandidateId 

IF OBJECT_ID('tempdb..#ObservationDateTime') IS NOT NULL DROP TABLE #ObservationDateTime
SELECT RecruitmentCandidateId,MAX(ScheduleStartDateTime) AS 'ObservationDateTime'
INTO #ObservationDateTime FROM Mst_RecruitmentCandidate_ActivityLog WHERE Stage = 'Observation' and AppointmentStatus = 'Registered' and IsDeleted = 0 GROUP BY RecruitmentCandidateId ORDER BY ObservationDateTime DESC

IF OBJECT_ID('tempdb..#ObservationTurnedUp') IS NOT NULL DROP TABLE #ObservationTurnedUp
SELECT RecruitmentCandidateId,MAX(ScheduleStartDateTime) AS 'ObservationTurnedUpDateTime', MAX(REMARK) AS 'ObsTurnedUpRemark' , MAX(ConductedBy) AS 'ObsTurnedUpConductedBy' , MAX(LeaderBadgeNo) AS 'ObsTurnedUpLeaderBadgeNo'
INTO #ObservationTurnedUp FROM Mst_RecruitmentCandidate_ActivityLog WHERE Stage = 'Observation' and AppointmentStatus = 'Turned-Up' and IsDeleted = 0 GROUP BY RecruitmentCandidateId ORDER BY ObservationTurnedUpDateTime DESC

IF OBJECT_ID('tempdb..#ObsCancelledRemark') IS NOT NULL DROP TABLE #ObsCancelledRemark
SELECT RecruitmentCandidateId,MAX(REMARK) AS 'ObsCancelledRemark' 
INTO #ObsCancelledRemark FROM Mst_RecruitmentCandidate_ActivityLog WHERE Stage = 'Observation' and AppointmentStatus = 'Cancelled' and IsDeleted = 0 GROUP BY RecruitmentCandidateId 

IF OBJECT_ID('tempdb..#InductionDateTime') IS NOT NULL DROP TABLE #InductionDateTime
SELECT RecruitmentCandidateId,MAX(ScheduleStartDateTime) AS 'InductionDateTime'
INTO #InductionDateTime FROM Mst_RecruitmentCandidate_ActivityLog WHERE Stage = 'Induction' and AppointmentStatus = 'Registered' and IsDeleted = 0 GROUP BY RecruitmentCandidateId ORDER BY InductionDateTime DESC

IF OBJECT_ID('tempdb..#InductionTurnedUp') IS NOT NULL DROP TABLE #InductionTurnedUp
SELECT RecruitmentCandidateId, MAX(ScheduleStartDateTime) AS 'InductionTurnedUpDateTime', MAX(REMARK) AS 'IndTurnedUpRemark' , MAX(LeaderBadgeNo) AS 'IndTurnedUpLeaderBadgeNo'
INTO #InductionTurnedUp FROM Mst_RecruitmentCandidate_ActivityLog WHERE Stage = 'Induction' and AppointmentStatus = 'Turned-Up' and IsDeleted = 0 GROUP BY RecruitmentCandidateId ORDER BY InductionTurnedUpDateTime DESC

IF OBJECT_ID('tempdb..#IndCancelled') IS NOT NULL DROP TABLE #IndCancelled
SELECT RecruitmentCandidateId, MAX(REMARK) AS 'IndCancelledRemark', MAX(ConductedBy) AS 'IndCancelledConductedBy' 
INTO #IndCancelled FROM Mst_RecruitmentCandidate_ActivityLog WHERE Stage = 'Induction' and AppointmentStatus = 'Cancelled' and IsDeleted = 0 GROUP BY RecruitmentCandidateId 

IF OBJECT_ID('tempdb..#ConfirmDateTime') IS NOT NULL DROP TABLE #ConfirmDateTime
SELECT RecruitmentCandidateId, MAX(ScheduleStartDateTime) AS 'ConfirmDateTime'
INTO #ConfirmDateTime FROM Mst_RecruitmentCandidate_ActivityLog WHERE Stage = 'Confirmed to Independent Contractor' and AppointmentStatus = 'Confirm' and IsDeleted = 0 GROUP BY RecruitmentCandidateId ORDER BY ConfirmDateTime DESC


IF @IsMOAdminRole = 1 -- MO Admin
	BEGIN
		DELETE A		
		FROM #MainData A	
		WHERE A.MarketingCompanyId NOT IN (@MCId)
	END
ELSE
	BEGIN
		DELETE A		
		FROM #MainData A	
		WHERE A.CountryCode NOT IN (SELECT Country FROM #SubCountry)
	END


	SELECT A.*,	B.InterviewDateTime,C.InterviewTurnedUpDateTime,C.TurnedUpRemark,C.TurnedUpConductBy,D.CancelledRemark,E.ObservationDateTime,F.ObservationTurnedUpDateTime,F.ObsTurnedUpRemark,F.ObsTurnedUpConductedBy,F.ObsTurnedUpLeaderBadgeNo,
	G.ObsCancelledRemark,H.InductionDateTime,I.InductionTurnedUpDateTime,I.IndTurnedUpRemark,I.IndTurnedUpLeaderBadgeNo,J.IndCancelledRemark,J.IndCancelledConductedBy
	FROM #MainData A
	LEFT JOIN #InterviewDateTime B ON A.RecruitmentCandidateId = B.RecruitmentCandidateId
	LEFT JOIN #InterviewTurnedUp C ON A.RecruitmentCandidateId = C.RecruitmentCandidateId
	LEFT JOIN #CancelledRemark D ON A.RecruitmentCandidateId = D.RecruitmentCandidateId
	LEFT JOIN #ObservationDateTime E ON A.RecruitmentCandidateId = E.RecruitmentCandidateId
	LEFT JOIN #ObservationTurnedUp F ON A.RecruitmentCandidateId = F.RecruitmentCandidateId
	LEFT JOIN #ObsCancelledRemark G ON A.RecruitmentCandidateId = G.RecruitmentCandidateId
	LEFT JOIN #InductionDateTime H ON A.RecruitmentCandidateId = H.RecruitmentCandidateId
	LEFT JOIN #InductionTurnedUp I ON A.RecruitmentCandidateId = I.RecruitmentCandidateId
	LEFT JOIN #IndCancelled J ON A.RecruitmentCandidateId = J.RecruitmentCandidateId
	LEFT JOIN #ConfirmDateTime K ON A.RecruitmentCandidateId = K.RecruitmentCandidateId
	ORDER BY CountryCode ASC, MarketingCompanyId ASC, RecruitmentCandidateId DESC
END
