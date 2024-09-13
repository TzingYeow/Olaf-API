
-- =============================================
-- Author:		Asyraf Bakar
-- Create date: 18 October 2018
-- Description:	To get the list of missing information for all Independent Contractors
-- =============================================
--EXEC SP_GetAppointment
CREATE PROCEDURE [dbo].[SP_GetAppointment]
AS
BEGIN
	SET NOCOUNT ON;

--DECLARE @TodayDate AS DATETIME
--DECLARE @FromDate AS DATETIME
--DECLARE @ToDate AS DATETIME = DATEADD(DAY, - 1, CAST(GETDATE() AS DATE))
----SET @TodayDate = CAST(GETDATE() AS DATE)
--SET @TodayDate = DATEADD(DAY, -1,CAST(GETDATE() AS DATE))
 

--IF DATEPART(DW, @TodayDate) > 5
--BEGIN
--SELECT @ToDate = DATEADD(DAY, 5 - DATEPART(DW, @TodayDate),@TodayDate )
--END


--IF DATEPART(DW, @TodayDate) < 5
--BEGIN
--SELECT @ToDate = DATEADD(DAY, - 2 - DATEPART(DW, @TodayDate),@TodayDate ) 
--END


--SET @FromDate = DATEADD(d,-6, @ToDate)
 

--select  a.RecruitmentCandidateId, Description as 'Descs', MAX(ScheduleStartDateTime) as 'ScheduleStartDateTime', B.FirstName, B.LastName, C.Code as 'MC Code', C.Name as 'MC Name', C.CountryCode as 'Country', B.Email into #RCList
--FROM Mst_RecruitmentCandidate_ActivityLog a
--left join Mst_RecruitmentCandidate b on b.RecruitmentCandidateId = a.RecruitmentCandidateId
--left join Mst_MarketingCompany c on c.MarketingCompanyId = b.MarketingCompanyId
--WHERE a.Stage = 'First-Appointment' and a.AppointmentStatus = 'Registered' and A.Description in (
--'1st Schedule',
--'2nd Schedule',
--'Final Schedule'
--)
--and ScheduleStartDateTime <  dateadd(day, 1,@ToDate) and ScheduleStartDateTime >= @FromDate
--and a.IsDeleted = 0 and b.IsDeleted = 0 and c.IsDeleted = 0 
--GROUP BY a.RecruitmentCandidateId, Description, B.FirstName, B.LastName, C.Code , C.Name  , C.CountryCode  , B.Email
 

-- select  a.RecruitmentCandidateId, Description as 'Descs', MAX(ScheduleStartDateTime) as 'ScheduleStartDateTime', B.FirstName, B.LastName, C.Code as 'MC Code', C.Name as 'MC Name', C.CountryCode as 'Country', B.Email into #RCListFuture
--FROM Mst_RecruitmentCandidate_ActivityLog a
--left join Mst_RecruitmentCandidate b on b.RecruitmentCandidateId = a.RecruitmentCandidateId
--left join Mst_MarketingCompany c on c.MarketingCompanyId = b.MarketingCompanyId
--WHERE a.Stage = 'First-Appointment' and a.AppointmentStatus = 'Registered' and A.Description in (
--'1st Schedule',
--'2nd Schedule',
--'Final Schedule'
--) and CAST(ScheduleStartDateTime as Date) > @ToDate
--and a.IsDeleted = 0 and b.IsDeleted = 0 and c.IsDeleted = 0 
--AND A.RecruitmentCandidateId in (SELECT RecruitmentCandidateId FROM #RCList)
--GROUP BY a.RecruitmentCandidateId, Description, B.FirstName, B.LastName, C.Code , C.Name  , C.CountryCode  , B.Email
  

--select distinct a.RecruitmentCandidateId, Description as 'Descs', AppointmentStatus into #RCListRemove
--FROM Mst_RecruitmentCandidate_ActivityLog a
--left join Mst_RecruitmentCandidate b on b.RecruitmentCandidateId = a.RecruitmentCandidateId
--left join Mst_MarketingCompany c on c.MarketingCompanyId = b.MarketingCompanyId
--WHERE ((a.Stage = 'First-Appointment' and a.AppointmentStatus in ('Cancelled','No-answer','Reschedule')) )
--and ScheduleStartDateTime < DATEADD(day, 30,@ToDate) and ScheduleStartDateTime >= @FromDate
--and a.IsDeleted = 0 and b.IsDeleted = 0 and c.IsDeleted = 0 
 
--SELECT A.* Into #RawList FROM #RCList A 
--LEFT JOIN #RCListRemove B ON A.RecruitmentCandidateId = B.RecruitmentCandidateId and A.Descs = B.Descs 
--WHERE B.RecruitmentCandidateId is null  and A.RecruitmentCandidateId not in (
--SELECT RecruitmentCandidateId FROM #RCListFuture
--)

--SELECT  DISTINCT RecruitmentCandidateId INTO #FormSubmitted FROM Mst_CandidateApplication_Form1 WHERE CreatedBy = 'Candidate Submit' and IsDeleted = 0 and RecruitmentCandidateId in (
--SELECT RecruitmentCandidateId FROM #RawList
--) and IsDeleted = 0 and CreatedDate >= Dateadd(day, -7, @FromDate) and CreatedDate <= DATEADD(day, 1,@ToDate)

--SELECT DISTINCT RecruitmentCandidateId INTO #FormCreated FROM Mst_CandidateApplication_Form1 WHERE CreatedBy = 'Candidate Login' and IsDeleted = 0 and RecruitmentCandidateId in (
--SELECT RecruitmentCandidateId FROM #RawList
--) and IsDeleted = 0 and CreatedDate >= Dateadd(day, -7, @FromDate) and CreatedDate <= DATEADD(day, 1,@ToDate)
   
    
-- --SELECT DISTINCT  A.RecruitmentCandidateId, A.ScheduleStartDateTime as 'Appointment Date', A.Country, A.[MC Code],A.[MC Name], A.FirstName, A.LastName, A.Email, CASE WHEN C.RecruitmentCandidateId IS NOT NULL THEN 'YES' ELSE 'NO' END as 'Created', 
-- --CASE WHEN B.RecruitmentCandidateId IS NOT NULL THEN 'YES' ELSE 'NO' END as 'Submitted','YES' as 'First Appointment' FROM #RawList A 
-- --LEFT JOIN #FormSubmitted B ON A.RecruitmentCandidateId = B.RecruitmentCandidateId
-- --LEFT JOIN #FormCreated C ON A.RecruitmentCandidateId = C.RecruitmentCandidateId  
-- --order by A.RecruitmentCandidateId

 select CountryCode, code, name,
isnull(CASE WHEN d.TriggerPoint  = '|' THEN 'First-Appointment-Registered' ELSE REPLACE(d.TriggerPoint,'|','-') END, 'First-Appointment-Registered')  as 'SetupStatus' INTO #Raw
from Mst_MarketingCompany m left join Mst_DigitalFormSettings d on m.MarketingCompanyId = d.MarketingCompanyId
and d.FormType = 'OR' 
WHERE m.IsActive = 1
Order by CountryCode , Code

  
  SELECT A.RecruitmentCandidateId as 'RecruitmentCandidateId', A.MCCountry as 'Country', A.ActivityScheduleStartDateTime 'Appointment Date', A.MCCode as 'MC Code', A.MCName as 'MC Name', A.FirstName as 'FirstName', A.LastName as 'LastName', A.Email as 'Email',  Case WHEN C.RecruitmentCandidateId IS NULL THEN 'NO' ELSE 'YES' END as 'Created', Case WHEN B.RecruitmentCandidateId IS NULL THEN 'NO' ELSE 'YES' END as 'Submitted', 'YES' as 'First Appointment' ,Z.SetupStatus
FROM Reporting_Recruitment_Activity A 
LEFT JOIN Mst_CandidateApplication_Form1 B ON A.RecruitmentCandidateId = B.RecruitmentCandidateId and B.CreatedBy = 'Candidate Submit'
LEFT JOIN Mst_CandidateApplication_Form1 C ON A.RecruitmentCandidateId = C.RecruitmentCandidateId and C.CreatedBy = 'Candidate Login'
LEFT JOIN #Raw Z ON A.MCCountry = Z.CountryCode and A.MCCode = Z.Code
where A.ActivityStage = 'First-Appointment' and A.ActivityAppointment ='Turned-Up'  and A.ActivityScheduleStartWeekending >= '2021-12-31'  ( SELECT MAX(wedate) FROM Mst_Weekending where WEdate < GETDATE() )

DROP TABLE #Raw

--DROP TABLE #RCList
--DROP TABLE #RCListRemove
--DROP TABLE #RawList
--DROP TABLE #FormCreated
--DROP TABLE #FormSubmitted
--DROP TABLE #RCListFuture
END
