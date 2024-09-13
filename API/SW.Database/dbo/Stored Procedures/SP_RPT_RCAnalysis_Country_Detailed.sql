
-- ==========================================================================================
-- Author:		Syafiqah Ab Manah
-- Create date: 2020-11-05
-- Description:	Country RC Analysis Report 
-- EXEC SP_RPT_RCAnalysis_Country_Detailed '2020-11-01','4db0b15873fc478b94b600e4f69737ce'
-- ==========================================================================================
CREATE PROCEDURE [dbo].[SP_RPT_RCAnalysis_Country_Detailed]
	-- Add the parameters for the stored procedure here
	@Searchdate  date,
	@userId varchar(150)
AS
BEGIN
	--Declare @Searchdate Date
	--Set @Searchdate =  '2020-09-01'--Getdate()--'2020-09-18'

	Declare @Todaydate Date
	Declare @Searchmonth Nvarchar(2)
	Declare @Searchyear Nvarchar(4)
	Declare @Currentmonth Nvarchar(2)
	Declare @Numofwe Int
	Declare @Mindate Date, @Maxdate Date
	Declare @we varchar(100)

	Set @Searchmonth = Month(@Searchdate)
	Set @Searchyear = Year(@Searchdate)
	Set @Todaydate = Getdate()
	Set @Currentmonth = Month(@Todaydate)

		
		IF OBJECT_ID('tempdb..#DETAILED') IS NOT NULL DROP TABLE #DETAILED
		CREATE TABLE #DETAILED
		(
		Country Varchar(2),
		MCCode Varchar(200),
		WeDate Date,
		Channel Varchar(200),
		Recruiter Varchar (200),
		Description Varchar(200),
		Total int
		)

		IF OBJECT_ID('tempdb..#ActiveHC') IS NOT NULL DROP TABLE #ActiveHC
		CREATE TABLE #ActiveHC
		(
		MCCountry varchar(10),
		MC_Id varchar(10),
		IndependentContractorId varchar(10),
		RecruitmentType varchar(50),
		IndependentContractorLevelId varchar (10),
		StartDate Date,
		LastDeactivateDate Date
		)


-- ========================= Define Time Range (START) ================================================================================================

		IF @Searchmonth = @Currentmonth
			BEGIN
				IF OBJECT_ID('tempdb..#Weekending') IS NOT NULL DROP TABLE #Weekending
				SELECT ROW_NUMBER() OVER(ORDER BY WEDate ASC) AS NoOfWE,WEdate,FromDate,ToDate     
				INTO #Weekending FROM Mst_Weekending      
				WHERE MONTH(WEdate) =  @Searchmonth AND YEAR(WEdate) = @Searchyear
				ORDER BY WEdate ASC

				--SELECT @NUMOFWE = NoOfWE FROM #Weekending WHERE @Searchdate >= FromDate AND @Searchdate <= ToDate
				SELECT TOP 1 @NUMOFWE =  NoOfWE FROM #Weekending ORDER BY WEdate ASC

				SELECT TOP 1 @MINDATE = FromDate FROM #Weekending ORDER BY FromDate ASC
				SELECT TOP 1 @MAXDATE = ToDate FROM #Weekending WHERE NoOfWE = @NUMOFWE ORDER BY ToDate DESC

				SELECT @we = COALESCE(@we + ',' ,'') + convert(varchar(20),WEdate) from #Weekending

			END
		ELSE
			BEGIN
				IF OBJECT_ID('tempdb..#WEEKENDING2') IS NOT NULL DROP TABLE #WEEKENDING2
				SELECT WEdate,FromDate,ToDate INTO #WEEKENDING2 FROM Mst_Weekending 
				WHERE MONTH(WEdate) =  @SEARCHMONTH AND YEAR(WEdate) = @SEARCHYEAR

				SELECT @NUMOFWE = COUNT(WEDATE) FROM #WEEKENDING2 
				SELECT TOP 1 @MINDATE = FromDate FROM #WEEKENDING2 ORDER BY FromDate ASC
				SELECT TOP 1 @MAXDATE = ToDate FROM #WEEKENDING2 ORDER BY ToDate DESC

				SELECT @we = COALESCE(@we + ',' ,'') + convert(varchar(20),WEdate) from #WEEKENDING2

			END 

				--SELECT * FROM #Weekending ORDER BY WEdate ASC -- CHECKING
				--SELECT * FROM #WEEKENDING2 ORDER BY WEdate ASC -- CHECKING
				--SELECT @SEARCHMONTH AS SEARCHMONTH, @CURRENTMONTH AS CURRENTMONTH,@NUMOFWE NoOfWE ,@MINDATE Mindate,@MAXDATE Maxdate -- CHECKING

-- ========================= Define Time Range (END) ================================================================================================

-- ========================= Prepare Main Data (START) ================================================================================================
		DECLARE @CountryList nvarchar(50)
		SELECT @CountryList = CountryAccess from Mst_User where UserId = @userId -- UserId = 'b2a2a1706a0d403598e9115d5846485d' --@userid
		IF OBJECT_ID('tempdb..#CountryAcess') IS NOT NULL DROP TABLE #CountryAcess
		SELECT * INTO #CountryAcess FROM STRING_SPLIT((@CountryList ),',')  
		--SELECT * FROM #CountryAcess

		IF OBJECT_ID('tempdb..#MCExclusion') IS NOT NULL DROP TABLE #MCExclusion
		SELECT MarketingCompanyId INTO #MCExclusion FROM Mst_MCExclusion WHERE ExclusionCode = 'RCA'

		IF OBJECT_ID('tempdb..#RTMCExclusion') IS NOT NULL DROP TABLE #RTMCExclusion
		SELECT MarketingCompanyId INTO #RTMCExclusion FROM Mst_MarketingCompany 
		WHERE MarketingCompanyType IN ('Roadtrip','Agency') AND IsDeleted = 0

		IF OBJECT_ID('tempdb..#maindata') IS NOT NULL DROP TABLE #maindata
		SELECT * INTO #maindata FROM Reporting_Recruitment_Activity  
		WHERE convert(date,ActivityScheduleStartDateTime) >= @MINDATE AND convert(date,ActivityScheduleStartDateTime) <= @MAXDATE
		and IsDeleted = 0 and MCCountry IN (SELECT Value from #CountryAcess)
		and MCId not in (SELECT MarketingCompanyId FROM #MCExclusion)
		and MCId not in (SELECT MarketingCompanyId FROM #RTMCExclusion)

		IF OBJECT_ID('tempdb..#icmaindata') IS NOT NULL DROP TABLE #icmaindata
		SELECT C.CountryCode AS MCCountry,c.MarketingCompanyId AS MCID,C.Code AS MCCode,A.*,B.STATUS,B.LastDeactivateDate,B.RecruitmentType,B.RecruitmentSource,B.RecruiterBadgeNoOrName, D.WEdate 
		INTO #icmaindata FROM Mst_IndependentContractor_Movement  A
		INNER JOIN Mst_IndependentContractor B ON A.IndependentContractorId = B.IndependentContractorId
		INNER JOIN Mst_MarketingCompany C ON B.MarketingCompanyId = C.MarketingCompanyId
		LEFT JOIN Mst_Weekending D ON A.EffectiveDate >= FromDate AND A.EffectiveDate <= ToDate
		WHERE convert(date, EffectiveDate) >= @MINDATE AND convert(date, EffectiveDate)  <= @MAXDATE AND B.IsDeleted = 0 AND A.IsDeleted = 0 
		and c.CountryCode IN (SELECT Value from #CountryAcess)
		AND b.MarketingCompanyId not in (SELECT MarketingCompanyId FROM #MCExclusion)
		AND b.MarketingCompanyId not in (SELECT MarketingCompanyId FROM #RTMCExclusion)

-- ========================= PREP (START) ===========================================================================================================
-- ================== First-Appointment  ===============
		-- FISRTAPPBOOKED
		IF OBJECT_ID('tempdb..#FISRTAPPBOOKED') IS NOT NULL DROP TABLE #FISRTAPPBOOKED
		SELECT MCCountry,MCCode,convert(date,ActivityScheduleStartWeekending) as WeDate,RecruitmentSource As Channel,RecruiterBadgeNoOrName As Recruiter,RecruitmentType,COUNT(*) AS Total 
		INTO #FISRTAPPBOOKED FROM #maindata 
		WHERE ActivityStage = 'First-Appointment' AND ActivityAppointment = 'Registered'
		GROUP BY MCCountry,MCCode,ActivityScheduleStartWeekending,RecruitmentSource,RecruiterBadgeNoOrName,RecruitmentType
		ORDER BY MCCountry ASC,MCCode ASC,WeDate ASC,Channel ASC,RecruiterBadgeNoOrName ASC

		INSERT INTO #DETAILED (Country,MCCode,WeDate,Channel,Recruiter,Description,Total)
		SELECT MCCountry,MCCode,WeDate,Channel,Recruiter,'ORFirstAppointmentBooked',Total
		FROM #FISRTAPPBOOKED WHERE RecruitmentType = 'Office Recruitment'

		INSERT INTO #DETAILED (Country,MCCode,WeDate,Channel,Recruiter,Description,Total)
		SELECT MCCountry,MCCode,WeDate,Channel,Recruiter,'PRFirstAppointmentBooked',Total
		FROM #FISRTAPPBOOKED WHERE RecruitmentType = 'Personal Recruitment'

		-- FIRSTAPPTURNEDUP
		IF OBJECT_ID('tempdb..#FIRSTAPPTURNEDUP') IS NOT NULL DROP TABLE #FIRSTAPPTURNEDUP
		SELECT MCCountry,MCCode,convert(date,ActivityScheduleStartWeekending) as WeDate,RecruitmentSource As Channel,RecruiterBadgeNoOrName As Recruiter,RecruitmentType,COUNT(*) AS Total 
		INTO #FIRSTAPPTURNEDUP FROM #maindata 
		WHERE ActivityStage = 'First-Appointment' AND ActivityAppointment = 'Turned-Up'
		GROUP BY MCCountry,MCCode,ActivityScheduleStartWeekending,RecruitmentSource,RecruiterBadgeNoOrName,RecruitmentType
		ORDER BY MCCountry ASC,MCCode ASC,WeDate ASC,Channel ASC,RecruiterBadgeNoOrName ASC

		INSERT INTO #DETAILED (Country,MCCode,WeDate,Channel,Recruiter,Description,Total)
		SELECT MCCountry,MCCode,WeDate,Channel,Recruiter,'ORFirstAppointmentTurnedUp',Total
		FROM #FIRSTAPPTURNEDUP WHERE RecruitmentType = 'Office Recruitment'

		INSERT INTO #DETAILED (Country,MCCode,WeDate,Channel,Recruiter,Description,Total)
		SELECT MCCountry,MCCode,WeDate,Channel,Recruiter,'PRFirstAppointmentTurnedUp',Total
		FROM #FIRSTAPPTURNEDUP WHERE RecruitmentType = 'Personal Recruitment'

-- ================== Observation  =====================
		-- OBSBOOKED
		IF OBJECT_ID('tempdb..#OBSBOOKED') IS NOT NULL DROP TABLE #OBSBOOKED
		SELECT MCCountry,MCCode,convert(date,ActivityScheduleStartWeekending) as WeDate,RecruitmentSource As Channel,RecruiterBadgeNoOrName As Recruiter,RecruitmentType,COUNT(*) AS Total 
		INTO #OBSBOOKED FROM #maindata 
		WHERE ActivityStage = 'Observation' AND ActivityAppointment = 'Registered'
		GROUP BY MCCountry,MCCode,ActivityScheduleStartWeekending,RecruitmentSource,RecruiterBadgeNoOrName,RecruitmentType
		ORDER BY MCCountry ASC,MCCode ASC,WeDate ASC,Channel ASC,RecruiterBadgeNoOrName ASC

		INSERT INTO #DETAILED (Country,MCCode,WeDate,Channel,Recruiter,Description,Total)
		SELECT MCCountry,MCCode,WeDate,Channel,Recruiter,'ORObservationBooked',Total
		FROM #OBSBOOKED WHERE RecruitmentType = 'Office Recruitment'

		INSERT INTO #DETAILED (Country,MCCode,WeDate,Channel,Recruiter,Description,Total)
		SELECT MCCountry,MCCode,WeDate,Channel,Recruiter,'PRObservationBooked',Total
		FROM #OBSBOOKED WHERE RecruitmentType = 'Personal Recruitment'

		-- OBSTURNEDUP
		IF OBJECT_ID('tempdb..#OBSTURNEDUP') IS NOT NULL DROP TABLE #OBSTURNEDUP
		SELECT MCCountry,MCCode,convert(date,ActivityScheduleStartWeekending) as WeDate,RecruitmentSource As Channel,RecruiterBadgeNoOrName As Recruiter,RecruitmentType,COUNT(*) AS Total 
		INTO #OBSTURNEDUP FROM #maindata 
		WHERE ActivityStage = 'Observation' AND ActivityAppointment = 'Turned-Up'
		GROUP BY MCCountry,MCCode,ActivityScheduleStartWeekending,RecruitmentSource,RecruiterBadgeNoOrName,RecruitmentType
		ORDER BY MCCountry ASC,MCCode ASC,WeDate ASC,Channel ASC,RecruiterBadgeNoOrName ASC

		INSERT INTO #DETAILED (Country,MCCode,WeDate,Channel,Recruiter,Description,Total)
		SELECT MCCountry,MCCode,WeDate,Channel,Recruiter,'ORObservationTurnedUp',Total
		FROM #OBSTURNEDUP WHERE RecruitmentType = 'Office Recruitment'

		INSERT INTO #DETAILED (Country,MCCode,WeDate,Channel,Recruiter,Description,Total)
		SELECT MCCountry,MCCode,WeDate,Channel,Recruiter,'PRObservationTurnedUp',Total
		FROM #OBSTURNEDUP WHERE RecruitmentType = 'Personal Recruitment'

-- ================== Induction  ========================

		-- INDBOOKED
		IF OBJECT_ID('tempdb..#INDBOOKED') IS NOT NULL DROP TABLE #INDBOOKED
		SELECT MCCountry,MCCode,convert(date,ActivityScheduleStartWeekending) as WeDate,RecruitmentSource As Channel,RecruiterBadgeNoOrName As Recruiter,RecruitmentType,COUNT(*) AS Total 
		INTO #INDBOOKED FROM #maindata 
		WHERE ActivityStage = 'Induction' AND ActivityAppointment = 'Registered'
		GROUP BY MCCountry,MCCode,ActivityScheduleStartWeekending,RecruitmentSource,RecruiterBadgeNoOrName,RecruitmentType
		ORDER BY MCCountry ASC,MCCode ASC,WeDate ASC,Channel ASC,RecruiterBadgeNoOrName ASC

		INSERT INTO #DETAILED (Country,MCCode,WeDate,Channel,Recruiter,Description,Total)
		SELECT MCCountry,MCCode,WeDate,Channel,Recruiter,'ORInductionBooked',Total
		FROM #INDBOOKED WHERE RecruitmentType = 'Office Recruitment'

		INSERT INTO #DETAILED (Country,MCCode,WeDate,Channel,Recruiter,Description,Total)
		SELECT MCCountry,MCCode,WeDate,Channel,Recruiter,'PRInductionBooked',Total
		FROM #INDBOOKED WHERE RecruitmentType = 'Personal Recruitment'

		-- Induction(Turned-Up)
		IF OBJECT_ID('tempdb..#INDTURNEDUP') IS NOT NULL DROP TABLE #INDTURNEDUP
		SELECT MCCountry,MCCode,convert(date,ActivityScheduleStartWeekending) as WeDate,RecruitmentSource As Channel,RecruiterBadgeNoOrName As Recruiter,RecruitmentType,COUNT(*) AS Total 
		INTO #INDTURNEDUP FROM #maindata 
		WHERE ActivityStage = 'Induction' AND ActivityAppointment = 'Turned-Up'
		GROUP BY MCCountry,MCCode,ActivityScheduleStartWeekending,RecruitmentSource,RecruiterBadgeNoOrName,RecruitmentType
		ORDER BY MCCountry ASC,MCCode ASC,WeDate ASC,Channel ASC,RecruiterBadgeNoOrName ASC

		INSERT INTO #DETAILED (Country,MCCode,WeDate,Channel,Recruiter,Description,Total)
		SELECT MCCountry,MCCode,WeDate,Channel,Recruiter,'ORInductionTurnedUp',Total
		FROM #INDTURNEDUP WHERE RecruitmentType = 'Office Recruitment'

		INSERT INTO #DETAILED (Country,MCCode,WeDate,Channel,Recruiter,Description,Total)
		SELECT MCCountry,MCCode,WeDate,Channel,Recruiter,'PRInductionTurnedUp',Total
		FROM #INDTURNEDUP WHERE RecruitmentType = 'Personal Recruitment'

-- ================== IDBadgeIssued  ===============

		-- #IDBadgeIssued
		IF OBJECT_ID('tempdb..#IDBadgeIssued') IS NOT NULL DROP TABLE #IDBadgeIssued
		SELECT B.CountryCode AS MCCountry, B.Code AS MCCode,C.WEdate,A.RecruitmentSource As Channel,A.RecruiterBadgeNoOrName As Recruiter,A.RecruitmentType,COUNT(*) AS Total 
		INTO #IDBadgeIssued FROM Mst_IndependentContractor a 
		INNER JOIN Mst_MarketingCompany B ON A.MarketingCompanyId = B.MarketingCompanyId
		LEFT JOIN Mst_Weekending C ON A.StartDate >= FromDate AND A.StartDate <= ToDate
		WHERE convert(date, A.StartDate) >= @MINDATE AND convert(date, A.StartDate) <= @MAXDATE AND A.IsDeleted = 0
		AND B.CountryCode  IN (SELECT Value from #CountryAcess)
		AND A.MarketingCompanyId not in (SELECT MarketingCompanyId FROM #MCExclusion)
		AND A.MarketingCompanyId not in (SELECT MarketingCompanyId FROM #RTMCExclusion)

		GROUP BY B.CountryCode,B.Code,C.WEdate,RecruitmentSource,RecruiterBadgeNoOrName,RecruitmentType
		ORDER BY MCCountry ASC,MCCode ASC,WeDate ASC,Channel ASC,RecruiterBadgeNoOrName ASC

		INSERT INTO #DETAILED (Country,MCCode,WeDate,Channel,Recruiter,Description,Total)
		SELECT MCCountry,MCCode,WeDate,Channel,Recruiter,'ORIDBadgeIssued',Total
		FROM #IDBadgeIssued WHERE RecruitmentType = 'Office Recruitment'

		INSERT INTO #DETAILED (Country,MCCode,WeDate,Channel,Recruiter,Description,Total)
		SELECT MCCountry,MCCode,WeDate,Channel,Recruiter,'PRIDBadgeIssued',Total
		FROM #IDBadgeIssued WHERE RecruitmentType = 'Personal Recruitment'

		-- ================== FirstdayOnfield  ===========================================================

		-- FirstdayOnfield
		IF OBJECT_ID('tempdb..#FirstdayOnfield') IS NOT NULL DROP TABLE #FirstdayOnfield
		SELECT b.CountryCode AS MCCountry, b.Code AS MCCode,c.WEdate,a.RecruitmentSource As Channel,a.RecruiterBadgeNoOrName As Recruiter,a.RecruitmentType,COUNT(*) AS Total 
		INTO #FirstdayOnfield FROM Mst_IndependentContractor a
		inner join Mst_MarketingCompany b on a.MarketingCompanyId = b.MarketingCompanyId
		inner join Mst_Weekending C on DateFirstOnField >= FromDate AND DateFirstOnField <= ToDate
		WHERE DateFirstOnField >= @MINDATE AND DateFirstOnField <= @MAXDATE AND a.IsDeleted = 0
		and b.CountryCode IN (SELECT Value from #CountryAcess)
		and A.MarketingCompanyId not in (SELECT MarketingCompanyId FROM #MCExclusion)
		and A.MarketingCompanyId not in (SELECT MarketingCompanyId FROM #RTMCExclusion)
		GROUP BY B.CountryCode,B.Code,C.WEdate,RecruitmentSource,RecruiterBadgeNoOrName,RecruitmentType
		ORDER BY MCCountry ASC,MCCode ASC,WeDate ASC,Channel ASC,RecruiterBadgeNoOrName ASC

		INSERT INTO #DETAILED (Country,MCCode,WeDate,Channel,Recruiter,Description,Total)
		SELECT MCCountry,MCCode,WeDate,Channel,Recruiter,'ORFirstDateOnField',Total
		FROM #FirstdayOnfield WHERE RecruitmentType = 'Office Recruitment'

		INSERT INTO #DETAILED (Country,MCCode,WeDate,Channel,Recruiter,Description,Total)
		SELECT MCCountry,MCCode,WeDate,Channel,Recruiter,'PRFirstDateOnField',Total
		FROM #FirstdayOnfield WHERE RecruitmentType = 'Personal Recruitment'

		-- ================== LeadersPromoted  ====================

		-- LeadersPromoted
		IF OBJECT_ID('tempdb..#LEADERPROMOTED') IS NOT NULL DROP TABLE #LEADERPROMOTED
		SELECT C.CountryCode AS MCCountry,C.Code AS MCCode, convert(date,WEdate) as WeDate,RecruitmentSource As Channel,RecruiterBadgeNoOrName As Recruiter,RecruitmentType,COUNT(*) AS Total 
		INTO #LEADERPROMOTED FROM Mst_IndependentContractor_Movement  A
		INNER JOIN Mst_IndependentContractor B ON A.IndependentContractorId = B.IndependentContractorId
		INNER JOIN Mst_MarketingCompany C ON B.MarketingCompanyId = C.MarketingCompanyId
		LEFT JOIN Mst_Weekending D ON A.PromotionDemotionDate >= FromDate AND A.PromotionDemotionDate <= ToDate
		WHERE convert(date, PromotionDemotionDate) >= @MINDATE AND convert(date, PromotionDemotionDate)  <= @MAXDATE AND B.IsDeleted = 0 AND A.IsDeleted = 0 
		and c.CountryCode IN (SELECT Value from #CountryAcess)
		AND b.MarketingCompanyId not in (SELECT MarketingCompanyId FROM #MCExclusion)
		AND b.MarketingCompanyId not in (SELECT MarketingCompanyId FROM #RTMCExclusion)
		and Description = 'Advance' AND A.IndependentContractorLevelId= '4' and A.IsDeleted = 0
		GROUP BY CountryCode,Code,WeDate,RecruitmentSource,RecruiterBadgeNoOrName,RecruitmentType
		ORDER BY MCCountry ASC,MCCode ASC,WeDate ASC,Channel ASC,RecruiterBadgeNoOrName ASC

		INSERT INTO #DETAILED (Country,MCCode,WeDate,Channel,Recruiter,Description,Total)
		SELECT MCCountry,MCCode,WeDate,Channel,Recruiter,'ORLeadersPromoted',Total
		FROM #LEADERPROMOTED WHERE RecruitmentType = 'Office Recruitment'

		INSERT INTO #DETAILED (Country,MCCode,WeDate,Channel,Recruiter,Description,Total)
		SELECT MCCountry,MCCode,WeDate,Channel,Recruiter,'PRLeadersPromoted',Total
		FROM #LEADERPROMOTED WHERE RecruitmentType = 'Personal Recruitment'

-- ================== Active Headcount  ================

		IF OBJECT_ID('tempdb..#ActiveHeadcount') IS NOT NULL DROP TABLE #ActiveHeadcount
		SELECT A.CountryCode as MCCountry,A.MCCode,A.WEStatus AS WeDate,A.WESTage,B.RecruitmentSource AS Channel, B.RecruiterBadgeNoOrName AS Recruiter,
		A.RecruitmentType,COUNT(*) AS Total 
		INTO #ActiveHeadcount FROM TXN_ICWeekendingStatus A
		INNER JOIN Mst_IndependentContractor B ON A.BAID = B.IndependentContractorId
		WHERE WESTATUS >= @Mindate AND WESTATUS <= @Maxdate AND ACTIVESTATUS = 1
		AND A.CountryCode  IN (SELECT Value from #CountryAcess)
		AND b.MarketingCompanyId not in (SELECT MarketingCompanyId FROM #MCExclusion)
		AND b.MarketingCompanyId not in (SELECT MarketingCompanyId FROM #RTMCExclusion)
		GROUP BY CountryCode,MCCode,WEStatus,WESTage,RecruitmentSource,RecruiterBadgeNoOrName,A.RecruitmentType
		ORDER BY MCCountry ASC,MCCode ASC,WeDate ASC,Channel ASC,RecruiterBadgeNoOrName ASC

		
		INSERT INTO #DETAILED (Country,MCCode,WeDate,Channel,Recruiter,Description,Total)
		SELECT MCCountry,MCCode,WeDate,Channel,Recruiter,'ORActiveHeadcount',Total
		FROM #ActiveHeadcount WHERE RecruitmentType = 'Office Recruitment'

		INSERT INTO #DETAILED (Country,MCCode,WeDate,Channel,Recruiter,Description,Total)
		SELECT MCCountry,MCCode,WeDate,Channel,Recruiter,'PRActiveHeadcount',Total
		FROM #ActiveHeadcount WHERE RecruitmentType = 'Personal Recruitment'

		--Quick Teporary Solution added on 2021-01-08
		--Total Active headcount for the month
		DECLARE @MAXWEDATE DATE
		SELECT @MAXWEDATE =  MAX(WEDATE) from #DETAILED
		--SELECT @MAXWEDATE

		INSERT INTO #DETAILED (Country,MCCode,WeDate,Channel,Recruiter,Description,Total)
		SELECT MCCountry,MCCode,WeDate,Channel,Recruiter,'ORTotalActiveHeadcount',Total
		FROM #ActiveHeadcount WHERE RecruitmentType = 'Office Recruitment' AND WeDate = @MAXWEDATE

		INSERT INTO #DETAILED (Country,MCCode,WeDate,Channel,Recruiter,Description,Total)
		SELECT MCCountry,MCCode,WeDate,Channel,Recruiter,'PRTotalActiveHeadcount',Total
		FROM #ActiveHeadcount WHERE RecruitmentType = 'Personal Recruitment' AND WeDate = @MAXWEDATE

-- ================== Active Headcount (Leader)  =======

		-- #ACTIVELEADER
		INSERT INTO #DETAILED (Country,MCCode,WeDate,Channel,Recruiter,Description,Total)
		SELECT MCCountry,MCCode,WeDate,Channel,Recruiter,'ORActiveHCLeaders',Total
		FROM #ActiveHeadcount WHERE RecruitmentType = 'Office Recruitment' AND WESTage = 'Leader'

		INSERT INTO #DETAILED (Country,MCCode,WeDate,Channel,Recruiter,Description,Total)
		SELECT MCCountry,MCCode,WeDate,Channel,Recruiter,'PRActiveHCLeaders',Total
		FROM #ActiveHeadcount WHERE RecruitmentType = 'Personal Recruitment' AND WESTage = 'Leader'

		--Quick Teporary Solution added on 2021-01-08
		--Total Active Leader for the month
		INSERT INTO #DETAILED (Country,MCCode,WeDate,Channel,Recruiter,Description,Total)
		SELECT MCCountry,MCCode,WeDate,Channel,Recruiter,'ORTotalActiveHCLeaders',Total
		FROM #ActiveHeadcount WHERE RecruitmentType = 'Office Recruitment' AND WESTage = 'Leader' AND WeDate = @MAXWEDATE

		INSERT INTO #DETAILED (Country,MCCode,WeDate,Channel,Recruiter,Description,Total)
		SELECT MCCountry,MCCode,WeDate,Channel,Recruiter,'PRTotalActiveHCLeaders',Total
		FROM #ActiveHeadcount WHERE RecruitmentType = 'Personal Recruitment' AND WESTage = 'Leader' AND WeDate = @MAXWEDATE
		
-- ================== NO. OF EXITS (LEADER)  ========================

		-- NO. OF EXITS (LEADER)
		IF OBJECT_ID('tempdb..#EXITSL') IS NOT NULL DROP TABLE #EXITSL
		SELECT MCCountry,MCCode,convert(date,WEdate) as WeDate,RecruitmentSource As Channel,RecruiterBadgeNoOrName As Recruiter,RecruitmentType,COUNT(*) AS Total 
		INTO #EXITSL FROM #icmaindata 
		WHERE Description IN ('Deactivate','Deactivated','Terminate') 
		AND Coalesce(LeavingReasonCategory, '') <> 'TRANSFER'	
		AND IndependentContractorLevelId= '4' and IsDeleted = 0
		GROUP BY MCCountry,MCCode,WeDate,RecruitmentSource,RecruiterBadgeNoOrName,RecruitmentType
		ORDER BY MCCountry ASC,MCCode ASC,WeDate ASC,Channel ASC,RecruiterBadgeNoOrName ASC

		INSERT INTO #DETAILED (Country,MCCode,WeDate,Channel,Recruiter,Description,Total)
		SELECT MCCountry,MCCode,WeDate,Channel,Recruiter,'ORExitsLeader',Total
		FROM #EXITSL WHERE RecruitmentType = 'Office Recruitment'

		INSERT INTO #DETAILED (Country,MCCode,WeDate,Channel,Recruiter,Description,Total)
		SELECT MCCountry,MCCode,WeDate,Channel,Recruiter,'PRExitsLeader',Total
		FROM #EXITSL WHERE RecruitmentType = 'Personal Recruitment'

-- ================== NO. OF EXITS (NON- LEADER)  ========================

		-- NO. OF EXITS (NON- LEADER)
		IF OBJECT_ID('tempdb..#EXITSNL') IS NOT NULL DROP TABLE #EXITSNL
		SELECT MCCountry,MCCode,convert(date,WEdate) as WeDate,RecruitmentSource As Channel,RecruiterBadgeNoOrName As Recruiter,RecruitmentType,COUNT(*) AS Total 
		INTO #EXITSNL FROM #icmaindata 
		WHERE Description IN ('Deactivate','Deactivated','Terminate') 
		AND Coalesce(LeavingReasonCategory, '') <> 'TRANSFER'	
		AND IndependentContractorLevelId not in( '4' ) and IsDeleted = 0
		GROUP BY MCCountry,MCCode,WeDate,RecruitmentSource,RecruiterBadgeNoOrName,RecruitmentType
		ORDER BY MCCountry ASC,MCCode ASC,WeDate ASC,Channel ASC,RecruiterBadgeNoOrName ASC

		INSERT INTO #DETAILED (Country,MCCode,WeDate,Channel,Recruiter,Description,Total)
		SELECT MCCountry,MCCode,WeDate,Channel,Recruiter,'ORExitsNonLeader',Total
		FROM #EXITSNL WHERE RecruitmentType = 'Office Recruitment'

		INSERT INTO #DETAILED (Country,MCCode,WeDate,Channel,Recruiter,Description,Total)
		SELECT MCCountry,MCCode,WeDate,Channel,Recruiter,'PRExitsNonLeader',Total
		FROM #EXITSNL WHERE RecruitmentType = 'Personal Recruitment'


		SELECT * from #DETAILED order by Country asc, MCCode asc, WeDate asc


END


