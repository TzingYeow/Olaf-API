
-- ==========================================================================================
-- Author:		Syafiqah Ab Manah
-- Create date: 2020-11-05
-- Description:	Regional RC Analysis Report 
-- SP_RPT_RCAnalysis_Regional_Detailed_RC '2021-06-01','b2a2a1706a0d403598e9115d5846485d'
-- ==========================================================================================
CREATE PROCEDURE [dbo].[SP_RPT_RCAnalysis_Regional_Detailed_RC]
	-- Add the parameters for the stored procedure here
	@Searchdate  date,
	@userId varchar(150)
AS
BEGIN
	--Declare @Searchdate Date
	--Set @Searchdate =  '2020-05-01'--CAST(getdate() AS DATE)--'2020-09-18'

	Declare @Todaydate Date
	Declare @Searchmonth Nvarchar(2)
	Declare @Searchyear Nvarchar(4)
	Declare @Currentmonth Nvarchar(2)
	Declare @Currentyear Nvarchar(4)
	Declare @Numofwe Int
	Declare @Mindate Date, @Maxdate Date
	Declare @we varchar(100)

	Set @Searchmonth = Month(@Searchdate)
	Set @Searchyear = Year(@Searchdate)
	Set @Todaydate = CAST(getdate() AS DATE)
	Set @Currentmonth = Month(@Todaydate)
	SELECT @Currentmonth = MONTH(WEDATE) FROM Mst_Weekending WHERE CAST(GETDATE() AS DATE) >= FromDate AND  CAST(GETDATE() AS DATE) <= ToDate

		
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

				IF (SELECT NoOfWE FROM #Weekending WHERE CAST(getdate() AS DATE) >= FromDate AND CAST(getdate() AS DATE) <= ToDate) <= 1 
					BEGIN
					SELECT @Numofwe =  NoOfWE FROM #Weekending WHERE CAST(getdate() AS DATE) >= FromDate AND CAST(getdate() AS DATE) <= ToDate
					END
				ELSE 
					BEGIN
					SELECT @Numofwe = NoOfWE - 1 FROM #Weekending WHERE CAST(getdate() AS DATE) >= FromDate AND CAST(getdate() AS DATE) <= ToDate
					END

				SELECT TOP 1 @MINDATE = FromDate FROM #Weekending ORDER BY FromDate ASC
				--SELECT TOP 1 @MAXDATE = ToDate FROM #Weekending WHERE NoOfWE = @NUMOFWE ORDER BY ToDate DESC
				-- ADDED ON 03/05
				Select @MAXDATE = ToDate FROM #Weekending WHERE NoOfWE = @NUMOFWE ORDER BY ToDate DESC

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
				--SELECT @SEARCHMONTH AS SEARCHMONTH, @CURRENTMONTH AS CURRENTMONTH
				--SELECT @NUMOFWE NoOfWE ,@MINDATE Mindate,@MAXDATE Maxdate -- CHECKING
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
		
		SELECT * from #DETAILED WHERE WeDate <= @Maxdate order by Country asc, MCCode asc, WeDate asc

END


