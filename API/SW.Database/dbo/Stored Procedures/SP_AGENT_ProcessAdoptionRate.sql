-- =============================================
-- Author:		Leonard Yong
-- Create date: 2020-08-15
-- Description:	Adoption Rate Report
-- =============================================
--EXEC SP_AGENT_ProcessAdoptionRate
CREATE PROCEDURE [dbo].[SP_AGENT_ProcessAdoptionRate] 
	 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @WEDate as DATE
	DECLARE @FromDate as Date
	DECLARE @ToDate as Date
	
SELECT TOP 1 @WEDate = WEdate, @FromDate = FromDate , @ToDate = ToDate FROM Mst_Weekending WHERE ToDate <CAST(GETDATE() as date) order by WEdate DESC
 
 ---------------------------- Overview Digital App Form START---------------------------------------------------------------------
 ---------------------------------------------------------------------------------------------------------------------------------


select  a.RecruitmentCandidateId, Description as 'Descs', MAX(ScheduleStartDateTime) as 'ScheduleStartDateTime', B.FirstName, B.LastName, C.Code as 'MC Code', C.Name as 'MC Name', C.CountryCode as 'Country', B.Email into #RCList
FROM Mst_RecruitmentCandidate_ActivityLog a
left join Mst_RecruitmentCandidate b on b.RecruitmentCandidateId = a.RecruitmentCandidateId
left join Mst_MarketingCompany c on c.MarketingCompanyId = b.MarketingCompanyId
WHERE a.Stage = 'First-Appointment' and a.AppointmentStatus = 'Registered' and A.Description in (
'1st Schedule',
'2nd Schedule',
'Final Schedule'
)
and ScheduleStartDateTime <  dateadd(day, 1,@ToDate) and ScheduleStartDateTime >= @FromDate
and a.IsDeleted = 0 and b.IsDeleted = 0 and c.IsDeleted = 0 
GROUP BY a.RecruitmentCandidateId, Description, B.FirstName, B.LastName, C.Code , C.Name  , C.CountryCode  , B.Email
 

 select  a.RecruitmentCandidateId, Description as 'Descs', MAX(ScheduleStartDateTime) as 'ScheduleStartDateTime', B.FirstName, B.LastName, C.Code as 'MC Code', C.Name as 'MC Name', C.CountryCode as 'Country', B.Email into #RCListFuture
FROM Mst_RecruitmentCandidate_ActivityLog a
left join Mst_RecruitmentCandidate b on b.RecruitmentCandidateId = a.RecruitmentCandidateId
left join Mst_MarketingCompany c on c.MarketingCompanyId = b.MarketingCompanyId
WHERE a.Stage = 'First-Appointment' and a.AppointmentStatus = 'Registered' and A.Description in (
'1st Schedule',
'2nd Schedule',
'Final Schedule'
) and CAST(ScheduleStartDateTime as Date) > @ToDate
and a.IsDeleted = 0 and b.IsDeleted = 0 and c.IsDeleted = 0 
AND A.RecruitmentCandidateId in (SELECT RecruitmentCandidateId FROM #RCList)
GROUP BY a.RecruitmentCandidateId, Description, B.FirstName, B.LastName, C.Code , C.Name  , C.CountryCode  , B.Email
  

select distinct a.RecruitmentCandidateId, Description as 'Descs', AppointmentStatus into #RCListRemove
FROM Mst_RecruitmentCandidate_ActivityLog a
left join Mst_RecruitmentCandidate b on b.RecruitmentCandidateId = a.RecruitmentCandidateId
left join Mst_MarketingCompany c on c.MarketingCompanyId = b.MarketingCompanyId
WHERE ((a.Stage = 'First-Appointment' and a.AppointmentStatus in ('Cancelled','No-answer','Reschedule'))   )
and ScheduleStartDateTime < DATEADD(day, 30,@ToDate) and ScheduleStartDateTime >= @FromDate
and a.IsDeleted = 0 and b.IsDeleted = 0 and c.IsDeleted = 0 
  
   
SELECT A.* Into #RawList FROM #RCList A 
LEFT JOIN #RCListRemove B ON A.RecruitmentCandidateId = B.RecruitmentCandidateId and A.Descs = B.Descs 
WHERE B.RecruitmentCandidateId is null  and A.RecruitmentCandidateId not in (
SELECT RecruitmentCandidateId FROM #RCListFuture
)

SELECT  DISTINCT RecruitmentCandidateId INTO #FormSubmitted FROM Mst_CandidateApplication_Form1 WHERE CreatedBy = 'Candidate Submit' and IsDeleted = 0 and RecruitmentCandidateId in (
SELECT RecruitmentCandidateId FROM #RawList
) and IsDeleted = 0 and CreatedDate >= Dateadd(day, -7, @FromDate) and CreatedDate <= DATEADD(day, 1,@ToDate)

SELECT DISTINCT RecruitmentCandidateId INTO #FormCreated FROM Mst_CandidateApplication_Form1 WHERE CreatedBy = 'Candidate Login' and IsDeleted = 0 and RecruitmentCandidateId in (
SELECT RecruitmentCandidateId FROM #RawList
) and IsDeleted = 0 and CreatedDate >= Dateadd(day, -7, @FromDate) and CreatedDate <= DATEADD(day, 1,@ToDate)
   
    
 SELECT DISTINCT  A.RecruitmentCandidateId, A.ScheduleStartDateTime as 'Appointment Date', A.Country, A.[MC Code] as 'MoCode',A.[MC Name] as 'MoName', A.FirstName, A.LastName, A.Email, CASE WHEN C.RecruitmentCandidateId IS NOT NULL THEN 'YES' ELSE 'NO' END as 'Created', 
 CASE WHEN B.RecruitmentCandidateId IS NOT NULL THEN 'YES' ELSE 'NO' END as 'Submitted','YES' as 'FirstAppointment' INTO #CleanRaw FROM #RawList A 
 LEFT JOIN #FormSubmitted B ON A.RecruitmentCandidateId = B.RecruitmentCandidateId
 LEFT JOIN #FormCreated C ON A.RecruitmentCandidateId = C.RecruitmentCandidateId  
 order by A.RecruitmentCandidateId

 SELECT @WEDate as 'WeDate', Country , SUM(CASE WHEN Submitted = 'YES' THEN 1 ELSE 0 END) as 'Submitted', SUM(CASE WHEN FirstAppointment = 'YES' THEN 1 ELSE 0 END) as 'FirstAppointment' INTO #RawGroup  FROM #CleanRaw
 GROUP BY Country 
  
 SELECT @WEDate as 'WeDate', Country ,MoCode as 'MoCode', SUM(CASE WHEN Submitted = 'YES' THEN 1 ELSE 0 END) as 'Submitted', SUM(CASE WHEN FirstAppointment = 'YES' THEN 1 ELSE 0 END) as 'FirstAppointment' INTO #RawGroupDetail  FROM #CleanRaw
 GROUP BY Country,MoCode

 UPDATE A SET A.R_Hongkong = ISNULL(B.Submitted,0), A.MC_Hongkong = ISNULL(B.FirstAppointment,0) FROM RPT_OverviewDigitalAppNewdMethod A INNER JOIN #RawGroup B ON A.WeDate = B.WEDate and B.Country = 'HK'
 UPDATE A SET A.R_Philippines = ISNULL(B.Submitted,0), A.MC_Philippines = ISNULL(B.FirstAppointment,0) FROM RPT_OverviewDigitalAppNewdMethod A INNER JOIN #RawGroup B ON A.WeDate = B.WEDate and B.Country = 'PH'
 UPDATE A SET A.R_Taiwan = ISNULL(B.Submitted,0), A.MC_Taiwan = ISNULL(B.FirstAppointment,0) FROM RPT_OverviewDigitalAppNewdMethod A INNER JOIN #RawGroup B ON A.WeDate = B.WEDate and B.Country = 'TW'
 UPDATE A SET A.R_Thailand = ISNULL(B.Submitted,0), A.MC_Thailand = ISNULL(B.FirstAppointment,0) FROM RPT_OverviewDigitalAppNewdMethod A INNER JOIN #RawGroup B ON A.WeDate = B.WEDate and B.Country = 'TH'
 UPDATE A SET A.R_Indonesia = ISNULL(B.Submitted,0), A.MC_Indonesia = ISNULL(B.FirstAppointment,0) FROM RPT_OverviewDigitalAppNewdMethod A INNER JOIN #RawGroup B ON A.WeDate = B.WEDate and B.Country = 'ID'
 UPDATE A SET A.R_Malaysia = ISNULL(B.Submitted,0), A.MC_Malaysia = ISNULL(B.FirstAppointment,0) FROM RPT_OverviewDigitalAppNewdMethod A INNER JOIN #RawGroup B ON A.WeDate = B.WEDate and B.Country = 'MY'
 UPDATE A SET A.R_Korea = ISNULL(B.Submitted,0), A.MC_Korea = ISNULL(B.FirstAppointment,0) FROM RPT_OverviewDigitalAppNewdMethod A INNER JOIN #RawGroup B ON A.WeDate = B.WEDate and B.Country = 'KR'
 UPDATE A SET A.R_Singapore = ISNULL(B.Submitted,0), A.MC_Singapore = ISNULL(B.FirstAppointment,0) FROM RPT_OverviewDigitalAppNewdMethod A INNER JOIN #RawGroup B ON A.WeDate = B.WEDate and B.Country = 'SG'
 UPDATE A SET A.R_India = ISNULL(B.Submitted,0), A.MC_India = ISNULL(B.FirstAppointment,0) FROM RPT_OverviewDigitalAppNewdMethod A INNER JOIN #RawGroup B ON A.WeDate = B.WEDate and B.Country = 'IN'

 UPDATE A SET A.TotalSubmitted = Submitted, A.TotalFirstAppointment = FirstAppointment, A.Average = CAST(Submitted as decimal(18,2)) /CAST(FirstAppointment as decimal(18,2)) FROM RPT_OverviewDigitalAppNewdMethod A INNER JOIN (SELECT WeDate, SUM(Submitted) as 'Submitted', SUM(FirstAppointment) as 'FirstAppointment'  FROM #RawGroup GROUP BY WeDate) B ON A.WeDate = B.WEDate



 DROP TABLE #CleanRaw
 DROP TABLE #FormCreated
 DROP TABLE #FormSubmitted
 DROP TABLE #RawGroup
 DROP TABLE #RawList
 DROP TABLE #RCList
 DROP TABLE #RCListFuture
 DROP TABLE #RCListRemove
 ---------------------------- Overview Digital App Form END---------------------------------------------------------------------
 ---------------------------------------------------------------------------------------------------------------------------------



 
 ---------------------------- Overview Recruitment START--------------------------------------------------------------------------
 ---------------------------------------------------------------------------------------------------------------------------------


 SELECT @WEDate as 'WeDate', * INTO #TempRecruitment  FROM VW_RecruitmentCandidate_ActivityLog WHERE ScheduleStartDateTime >= @FromDate and ScheduleStartDateTime < @ToDate
 
 SELECT WeDate, CountryCode, COUNT(distinct MC_Code) totalMC INTO #TempActiveMC FROM #TempRecruitment GROUP BY WeDate,CountryCode


 UPDATE A SET A.R_Hongkong = B.totalMC FROM  RPT_OverviewRecruitment A 
 INNER JOIN #TempActiveMC 
 B ON A.WeDate = B.WeDate AND B.CountryCode = 'HK'

  UPDATE A SET A.R_Indonesia = B.totalMC FROM  RPT_OverviewRecruitment A 
 INNER JOIN #TempActiveMC
 B ON A.WeDate = B.WeDate AND B.CountryCode = 'ID'

  UPDATE A SET A.R_India = B.totalMC FROM  RPT_OverviewRecruitment A 
 INNER JOIN #TempActiveMC
 B ON A.WeDate = B.WeDate AND B.CountryCode = 'IN'

  UPDATE A SET A.R_Korea = B.totalMC FROM  RPT_OverviewRecruitment A 
 INNER JOIN #TempActiveMC
 B ON A.WeDate = B.WeDate AND B.CountryCode = 'KR'

  UPDATE A SET A.R_Malaysia = B.totalMC FROM  RPT_OverviewRecruitment A 
 INNER JOIN #TempActiveMC
 B ON A.WeDate = B.WeDate AND B.CountryCode = 'MY'

  UPDATE A SET A.R_Philippines = B.totalMC FROM  RPT_OverviewRecruitment A 
 INNER JOIN #TempActiveMC
 B ON A.WeDate = B.WeDate AND B.CountryCode = 'PH'

  UPDATE A SET A.R_Singapore = B.totalMC FROM  RPT_OverviewRecruitment A 
 INNER JOIN #TempActiveMC
 B ON A.WeDate = B.WeDate AND B.CountryCode = 'SG'

  UPDATE A SET A.R_Thailand = B.totalMC FROM  RPT_OverviewRecruitment A 
 INNER JOIN #TempActiveMC 
 B ON A.WeDate = B.WeDate AND B.CountryCode = 'TH'

  UPDATE A SET A.R_Taiwan = B.totalMC FROM  RPT_OverviewRecruitment A 
 INNER JOIN #TempActiveMC
 B ON A.WeDate = B.WeDate AND B.CountryCode = 'TW'



SELECT @WEDate as 'WeDate', CountryCode, COUNT(distinct Code) as TotalMC INTO #TempMC FROM Mst_MarketingCompany where IsActive = 1 and IsDeleted = 0 and Code not in ('A','HQ') GROUP BY CountryCode

 UPDATE A SET A.MC_Hongkong = B.totalMC FROM  RPT_OverviewRecruitment A 
 INNER JOIN #TempMC
 B ON A.WeDate = B.WeDate AND B.CountryCode = 'HK'

  UPDATE A SET A.MC_Indonesia = B.totalMC FROM  RPT_OverviewRecruitment A 
 INNER JOIN #TempMC
 B ON A.WeDate = B.WeDate AND B.CountryCode = 'ID'

  UPDATE A SET A.MC_India = B.totalMC FROM  RPT_OverviewRecruitment A 
 INNER JOIN #TempMC
 B ON A.WeDate = B.WeDate AND B.CountryCode = 'IN'

  UPDATE A SET A.MC_Korea = B.totalMC FROM  RPT_OverviewRecruitment A 
 INNER JOIN #TempMC
 B ON A.WeDate = B.WeDate AND B.CountryCode = 'KR'

  UPDATE A SET A.MC_Malaysia = B.totalMC FROM  RPT_OverviewRecruitment A 
 INNER JOIN #TempMC
 B ON A.WeDate = B.WeDate AND B.CountryCode = 'MY'

  UPDATE A SET A.MC_Philippines = B.totalMC FROM  RPT_OverviewRecruitment A 
 INNER JOIN #TempMC
 B ON A.WeDate = B.WeDate AND B.CountryCode = 'PH'

  UPDATE A SET A.MC_Singapore = B.totalMC FROM  RPT_OverviewRecruitment A 
 INNER JOIN #TempMC
 B ON A.WeDate = B.WeDate AND B.CountryCode = 'SG'

  UPDATE A SET A.MC_Thailand = B.totalMC FROM  RPT_OverviewRecruitment A 
 INNER JOIN #TempMC
 B ON A.WeDate = B.WeDate AND B.CountryCode = 'TH'

  UPDATE A SET A.MC_Taiwan = B.totalMC FROM  RPT_OverviewRecruitment A 
 INNER JOIN #TempMC
 B ON A.WeDate = B.WeDate AND B.CountryCode = 'TW'

 UPDATE RPT_OverviewRecruitment SET TotalMC = (SELECT SUM(TotalMC) FROM #TempMC), TotalMCActive = (SELECT SUM(totalMC) FROM #TempActiveMC) 
 WHERE WeDate = @WEDate

  UPDATE RPT_OverviewRecruitment SET AverageMCActive = CAST(CAST(TotalMCActive as decimal(18,2))/CAST(TotalMC as decimal(18,2)) as decimal(18,2))
 WHERE WeDate = @WEDate

 ---------------------------- Overview Recruitment END--------------------------------------------------------------------------
 ---------------------------------------------------------------------------------------------------------------------------------

 --SELECT * FROM #RawGroupDetail
 --EXEC SP_AGENT_ProcessAdoptionRate


 DELETE FROM RPT_OverviewDetailByCountry WHERE WeDate = @WEDate
 INSERT INTO RPT_OverviewDetailByCountry (WeDate, Country, MoCode,ActiveIC, FormSubmitted, FirstAppoinment, Recruitment)
 SELECT @WEDate, B.CountryCode, B.Code, COUNT(distinct A.BadgeNo),0,0,'NO' FROM Mst_IndependentContractor A LEFT JOIN Mst_MarketingCompany B ON A.MarketingCompanyId = B.MarketingCompanyId
 WHERE B.IsActive = 1 and B.IsDeleted = 0 and ISNULL(A.LastDeactivateDate,@ToDate) >= @ToDate and B.Code not in ('A','HQ')
 GROUP BY B.CountryCode, B.Code

 UPDATE A SET A.FormSubmitted = ISNULL(B.Submitted,0) , A.FirstAppoinment = ISNULL(B.FirstAppointment,0)
 FROM RPT_OverviewDetailByCountry A INNER JOIN #RawGroupDetail B ON A.WeDate = B.WeDate and A.Country = B.Country and A.MoCode = B.MoCode
--SELECT * FROM RPT_OverviewDetailByCountry WHERE WeDate = '2020-08-13'

UPDATE A SET A.Recruitment = 'YES' FROm RPT_OverviewDetailByCountry A INNER JOIN (
SELECT DISTINCT @WEDate WeDate, MC_Code, CountryCode FROM VW_RecruitmentCandidate_ActivityLog WHERE ScheduleStartDateTime >= @FromDate and ScheduleStartDateTime <= @ToDate
) B ON A.WeDate = B.WeDate and A.MoCode = B.MC_Code and A.Country = B.CountryCode
  
END






