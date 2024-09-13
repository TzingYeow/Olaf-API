
-- ==========================================================================================
-- Author:		Syafiqah Ab Manah
-- Create date: 2020-11-05
-- Description:	Regional RC Analysis Report 
-- EXEC SP_RPT_RCAnalysis_Regional_Overview_PBI '2021-05-01','b2a2a1706a0d403598e9115d5846485d'
-- ==========================================================================================
CREATE PROCEDURE [dbo].[SP_RPT_RCAnalysis_Regional_Overview_PBI]
	-- Add the parameters for the stored procedure here
	@Searchdate  date,
	@userId varchar(150)
AS
BEGIN
	--Declare @Searchdate Date
	--Set @Searchdate =  '2020-09-01'--CAST(getdate() AS DATE)--'2020-09-18'

	Declare @Todaydate Date
	Declare @Searchmonth Nvarchar(2)
	Declare @Searchyear Nvarchar(4)
	Declare @Currentmonth Nvarchar(2)
	Declare @Numofwe Int
	Declare @Mindate Date, @Maxdate Date

	Set @Searchmonth = Month(@Searchdate)
	Set @Searchyear = Year(@Searchdate)
	Set @Todaydate = CAST(getdate() AS DATE)
	SELECT @Currentmonth = MONTH(WEDATE) FROM Mst_Weekending WHERE CAST(GETDATE() AS DATE) >= FromDate AND  CAST(GETDATE() AS DATE) <= ToDate

		IF OBJECT_ID('tempdb..#OVERVIEW') IS NOT NULL DROP TABLE #OVERVIEW
		CREATE TABLE #OVERVIEW
		(
		ORFirstAppointmentBooked INT,
		PRFirstAppointmentBooked INT,
		ORFirstAppointmentTurnedUp INT,
		PRFirstAppointmentTurnedUp INT,
		ORObservationBooked INT,
		PRObservationBooked INT,
		ORObservationTurnedUp INT,
		PRObservationTurnedUp INT,
		ORInductionBooked INT,
		PRInductionBooked INT,
		ORInductionTurnedUp INT,
		PRInductionTurnedUp INT,
		ORIDBadgeIssued INT,
		PRIDBadgeIssued INT,
		ORFirstDateOnField INT,
		PRFirstDateOnField INT,
		ORLeadersPromoted INT,
		PRLeadersPromoted INT,
		ORTotalActiveHeadcount INT,
		PRTotalActiveHeadcount INT,
		ORAverageHeadcount DECIMAL (18,2),
		PRAverageHeadcount DECIMAL (18,2),
		ORTotalLeaders INT,
		PRTotalLeaders INT,
		ORAverageNoOfLeader DECIMAL (18,2),
		PRAverageNoOfLeader DECIMAL (18,2),
		ORTerminatedICLeader INT,
		PRTerminatedICLeader INT,
		ORTerminatedICNonLeader INT,
		PRTerminatedICNonLeader INT
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
				--SELECT TOP 1 @NUMOFWE =  NoOfWE FROM #Weekending ORDER BY WEdate ASC
				SELECT @Numofwe = NoOfWE - 1 FROM #Weekending WHERE CAST(getdate() AS DATE) >= FromDate AND CAST(getdate() AS DATE) <= ToDate


				SELECT TOP 1 @MINDATE = FromDate FROM #Weekending ORDER BY FromDate ASC
				--SELECT TOP 1 @MAXDATE = ToDate FROM #Weekending WHERE NoOfWE = @NUMOFWE ORDER BY ToDate DESC
				-- ADDED ON 03/05
				Select @MAXDATE = ToDate FROM #Weekending WHERE NoOfWE = @NUMOFWE ORDER BY ToDate DESC
			END
		ELSE
			BEGIN
				IF OBJECT_ID('tempdb..#WEEKENDING2') IS NOT NULL DROP TABLE #WEEKENDING2
				SELECT WEdate,FromDate,ToDate INTO #WEEKENDING2 FROM Mst_Weekending 
				WHERE MONTH(WEdate) =  @SEARCHMONTH AND YEAR(WEdate) = @SEARCHYEAR

				SELECT @NUMOFWE = COUNT(WEDATE) FROM #WEEKENDING2 
				SELECT TOP 1 @MINDATE = FromDate FROM #WEEKENDING2 ORDER BY FromDate ASC
				SELECT TOP 1 @MAXDATE = ToDate FROM #WEEKENDING2 ORDER BY ToDate DESC

			END 

				--SELECT * FROM #Weekending ORDER BY WEdate ASC -- CHECKING
				--SELECT * FROM #WEEKENDING2 ORDER BY WEdate ASC -- CHECKING
				SELECT @SEARCHMONTH AS SEARCHMONTH, @CURRENTMONTH AS CURRENTMONTH
				SELECT @NUMOFWE NoOfWE ,@MINDATE Mindate,@MAXDATE Maxdate -- CHECKING

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
		SELECT C.CountryCode AS MCCountry,c.MarketingCompanyId AS MCID,A.*,B.STATUS,B.LastDeactivateDate,B.RecruitmentType 
		INTO #icmaindata FROM Mst_IndependentContractor_Movement  A
		INNER JOIN Mst_IndependentContractor B ON A.IndependentContractorId = B.IndependentContractorId
		INNER JOIN Mst_MarketingCompany C ON B.MarketingCompanyId = C.MarketingCompanyId
		WHERE convert(date, EffectiveDate) >= @MINDATE AND convert(date, EffectiveDate)  <= @MAXDATE AND B.IsDeleted = 0 AND A.IsDeleted = 0 
		and c.CountryCode IN (SELECT Value from #CountryAcess)
		and b.MarketingCompanyId not in (SELECT MarketingCompanyId FROM #MCExclusion)
		and b.MarketingCompanyId not in (SELECT MarketingCompanyId FROM #RTMCExclusion)

-- ========================= PREP (START) ===========================================================================================================

-- ================== First-Appointment  ===============

		-- First-Appointment(Booked)
		IF OBJECT_ID('tempdb..#FirstAppt') IS NOT NULL DROP TABLE #FirstAppt
		SELECT * INTO #FirstAppt FROM #maindata WHERE ActivityStage = 'First-Appointment' AND ActivityAppointment = 'Registered'

		-- First-Appointment(Turned-Up)
		IF OBJECT_ID('tempdb..#FirstApptTurnedUp') IS NOT NULL DROP TABLE #FirstApptTurnedUp
		SELECT * INTO #FirstApptTurnedUp FROM #maindata WHERE ActivityStage = 'First-Appointment' AND ActivityAppointment = 'Turned-Up'

-- ================== Observation  =====================

		-- Observation (Booked)
		IF OBJECT_ID('tempdb..#ObservationB') IS NOT NULL DROP TABLE #ObservationB
		SELECT * INTO #ObservationB FROM #maindata WHERE ActivityStage = 'Observation' AND ActivityAppointment = 'Registered' 

		-- Observation(Turned-Up)
		IF OBJECT_ID('tempdb..#ObservationTU') IS NOT NULL DROP TABLE #ObservationTU
		SELECT * INTO #ObservationTU FROM #maindata WHERE ActivityStage = 'Observation' AND ActivityAppointment = 'Turned-Up'

-- ================== Induction  ========================

		-- Induction (Booked)
		IF OBJECT_ID('tempdb..#InductionB') IS NOT NULL DROP TABLE #InductionB
		SELECT * INTO #InductionB FROM #maindata WHERE ActivityStage = 'Induction' AND ActivityAppointment = 'Registered' 

		-- Induction(Turned-Up)
		IF OBJECT_ID('tempdb..#InductionTU') IS NOT NULL DROP TABLE #InductionTU
		SELECT * INTO #InductionTU FROM #maindata WHERE ActivityStage = 'Induction' AND ActivityAppointment = 'Turned-Up'

-- ================== FirstdayOnfield  ===================

		-- FirstdayOnfield
		IF OBJECT_ID('tempdb..#FirstdayOnfield') IS NOT NULL DROP TABLE #FirstdayOnfield
		SELECT b.CountryCode AS MCCountry, b.MarketingCompanyId AS MCID,a.IndependentContractorId,a.RecruitmentType,a.DateFirstOnField
		INTO #FirstdayOnfield FROM Mst_IndependentContractor a
		inner join Mst_MarketingCompany b on a.MarketingCompanyId = b.MarketingCompanyId
		WHERE DateFirstOnField >= @MINDATE AND DateFirstOnField <= @MAXDATE AND a.IsDeleted = 0
		and b.CountryCode IN (SELECT Value from #CountryAcess)
		and a.MarketingCompanyId not in (SELECT MarketingCompanyId FROM #MCExclusion)
		and a.MarketingCompanyId not in (SELECT MarketingCompanyId FROM #RTMCExclusion)

-- ================== LeadersPromoted  ====================

		-- #LeadersPromoted 
		IF OBJECT_ID('tempdb..#LeadersPromoted') IS NOT NULL DROP TABLE #LeadersPromoted
		SELECT C.CountryCode AS MCCountry,c.MarketingCompanyId AS MCID,A.*,B.STATUS,B.LastDeactivateDate,B.RecruitmentType, D.WEdate 
		INTO #LeadersPromoted FROM Mst_IndependentContractor_Movement  A
		INNER JOIN Mst_IndependentContractor B ON A.IndependentContractorId = B.IndependentContractorId
		INNER JOIN Mst_MarketingCompany C ON B.MarketingCompanyId = C.MarketingCompanyId
		LEFT JOIN Mst_Weekending D ON A.PromotionDemotionDate >= FromDate AND A.PromotionDemotionDate <= ToDate
		WHERE convert(date, PromotionDemotionDate) >= @MINDATE AND convert(date, PromotionDemotionDate)  <= @MAXDATE AND B.IsDeleted = 0 AND A.IsDeleted = 0 
		and c.CountryCode IN (SELECT Value from #CountryAcess)
		and b.MarketingCompanyId not in (SELECT MarketingCompanyId FROM #MCExclusion)
		and b.MarketingCompanyId not in (SELECT MarketingCompanyId FROM #RTMCExclusion)
		and Description = 'Advance' AND A.IndependentContractorLevelId= '4' and A.IsDeleted = 0

-- ================== INACTIVE BA  ========================

		IF OBJECT_ID('tempdb..#INACTIVEIC') IS NOT NULL DROP TABLE #INACTIVEIC
		SELECT DISTINCT MCCountry,MCID,IndependentContractorId, IndependentContractorLevelId, RecruitmentType, Description, max(EffectiveDate) AS EffectiveDate INTO #INACTIVEIC
		FROM #icmaindata WHERE Description IN ('Deactivate','Deactivated','Terminate')
		AND Coalesce(LeavingReasonCategory, '') <> 'TRANSFER'
		GROUP BY MCCountry,MCID,IndependentContractorId, IndependentContractorLevelId, RecruitmentType, Description

-- ================== TotalActiveHeadcount  ================
		--Declare @Mindate2 Date, @Maxdate2 Date

		--Select @Mindate2 = FromDate, @Maxdate2 = ToDate FROM #Weekending WHERE NoOfWE = @NUMOFWE ORDER BY ToDate DESC

		--Select @Mindate2 Mindate2 , @Maxdate2 Maxdate2

		IF OBJECT_ID('tempdb..#ActiveHC') IS NOT NULL DROP TABLE #ActiveHC
		SELECT A.CountryCode as MCCountry,A.MCCode,A.WEStatus AS WeDate,A.WESTage,B.RecruitmentSource AS Channel, B.RecruiterBadgeNoOrName AS Recruiter,
		A.RecruitmentType,COUNT(*) AS Total 
		INTO #ActiveHC FROM TXN_ICWeekendingStatus A
		INNER JOIN Mst_IndependentContractor B ON A.BAID = B.IndependentContractorId
		WHERE WESTATUS >= @Mindate AND WESTATUS <= @Maxdate AND ACTIVESTATUS = 1
		AND CountryCode IN (SELECT Value from #CountryAcess)
		AND b.MarketingCompanyId not in (SELECT MarketingCompanyId FROM #MCExclusion)
		AND b.MarketingCompanyId not in (SELECT MarketingCompanyId FROM #RTMCExclusion)
		GROUP BY CountryCode,MCCode,WEStatus,WESTage,RecruitmentSource,RecruiterBadgeNoOrName,A.RecruitmentType
		ORDER BY MCCountry ASC,MCCode ASC,WeDate ASC,Channel ASC,RecruiterBadgeNoOrName ASC

-- ================== ACTIVELEADER  ========================

		-- #ACTIVELEADER
		IF OBJECT_ID('tempdb..#ACTIVELEADER') IS NOT NULL DROP TABLE #ACTIVELEADER
		SELECT * INTO #ACTIVELEADER FROM #ActiveHC WHERE WESTage = 'Leader'

-- ================== TotalInactiveLeader  =================

		-- #TotalInactiveLeader
		IF OBJECT_ID('tempdb..#TotalInactiveLeader') IS NOT NULL DROP TABLE #TotalInactiveLeader
		SELECT * INTO #TotalInactiveLeader FROM #INACTIVEIC WHERE IndependentContractorLevelId = '4'

-- ================== TotalInactiveNonLeader  ===============

		-- #TotalInactiveNonLeader
		IF OBJECT_ID('tempdb..#TotalInactiveNonLeader') IS NOT NULL DROP TABLE #TotalInactiveNonLeader
		SELECT * INTO #TotalInactiveNonLeader FROM #INACTIVEIC WHERE IndependentContractorLevelId NOT IN ('4') 

-- ================== IDBadgeIssued  ===============

		-- #IDBadgeIssued
		IF OBJECT_ID('tempdb..#IDBadgeIssued') IS NOT NULL DROP TABLE #IDBadgeIssued
		SELECT B.CountryCode AS MCCountry, B.MarketingCompanyId AS MCID,A.IndependentContractorId,A.RecruitmentType,A.StartDate 
		INTO #IDBadgeIssued FROM Mst_IndependentContractor a 
		INNER JOIN Mst_MarketingCompany B ON A.MarketingCompanyId = B.MarketingCompanyId
		WHERE convert(date, A.StartDate) >= @MINDATE AND convert(date, A.StartDate) <= @MAXDATE AND A.IsDeleted = 0
		AND B.CountryCode IN (SELECT Value from #CountryAcess)
		AND B.MarketingCompanyId not in (SELECT MarketingCompanyId FROM #MCExclusion)
		AND B.MarketingCompanyId not in (SELECT MarketingCompanyId FROM #RTMCExclusion)


-- ========================= PREP (END) ===========================================================================================================

-- ========================= Populate Overview (START) ============================================================================================

		INSERT INTO #OVERVIEW (	ORFirstAppointmentBooked, PRFirstAppointmentBooked, ORFirstAppointmentTurnedUp,
		PRFirstAppointmentTurnedUp, ORObservationBooked, PRObservationBooked, ORObservationTurnedUp, PRObservationTurnedUp,
		ORInductionBooked, PRInductionBooked, ORInductionTurnedUp , PRInductionTurnedUp , ORIDBadgeIssued , PRIDBadgeIssued , ORFirstDateOnField,
		PRFirstDateOnField, ORLeadersPromoted , PRLeadersPromoted , ORTotalActiveHeadcount , PRTotalActiveHeadcount , ORAverageHeadcount ,
		PRAverageHeadcount , ORTotalLeaders , PRTotalLeaders , ORAverageNoOfLeader , PRAverageNoOfLeader ,
		ORTerminatedICLeader , PRTerminatedICLeader , ORTerminatedICNonLeader , PRTerminatedICNonLeader )
		VALUES (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)

		UPDATE #OVERVIEW SET ORFirstAppointmentBooked = (SELECT COUNT(*) FROM #FirstAppt WHERE RecruitmentType = 'Office Recruitment')
		UPDATE #OVERVIEW SET PRFirstAppointmentBooked = (SELECT COUNT(*) FROM #FirstAppt WHERE RecruitmentType = 'Personal Recruitment')
		UPDATE #OVERVIEW SET ORFirstAppointmentTurnedUp = (SELECT COUNT(*) FROM #FirstApptTurnedUp WHERE RecruitmentType = 'Office Recruitment')
		UPDATE #OVERVIEW SET PRFirstAppointmentTurnedUp = (SELECT COUNT(*) FROM #FirstApptTurnedUp WHERE RecruitmentType = 'Personal Recruitment')

		UPDATE #OVERVIEW SET ORObservationBooked = (SELECT COUNT(*) FROM #ObservationB WHERE RecruitmentType = 'Office Recruitment')
		UPDATE #OVERVIEW SET PRObservationBooked = (SELECT COUNT(*) FROM #ObservationB WHERE RecruitmentType = 'Personal Recruitment')
		UPDATE #OVERVIEW SET ORObservationTurnedUp = (SELECT COUNT(*) FROM #ObservationTU WHERE RecruitmentType = 'Office Recruitment')
		UPDATE #OVERVIEW SET PRObservationTurnedUp = (SELECT COUNT(*) FROM #ObservationTU WHERE RecruitmentType = 'Personal Recruitment')

		UPDATE #OVERVIEW SET ORInductionBooked =  (SELECT COUNT(*) FROM #InductionB WHERE RecruitmentType = 'Office Recruitment')
		UPDATE #OVERVIEW SET PRInductionBooked =  (SELECT COUNT(*) FROM #InductionB WHERE RecruitmentType = 'Personal Recruitment')
		UPDATE #OVERVIEW SET ORInductionTurnedUp =  (SELECT COUNT(*) FROM #InductionTU WHERE RecruitmentType = 'Office Recruitment')
		UPDATE #OVERVIEW SET PRInductionTurnedUp =  (SELECT COUNT(*) FROM #InductionTU WHERE RecruitmentType = 'Personal Recruitment')

		UPDATE #OVERVIEW SET ORIDBadgeIssued = (SELECT COUNT(*) FROM #FirstdayOnfield WHERE RecruitmentType = 'Office Recruitment')
		UPDATE #OVERVIEW SET PRIDBadgeIssued = (SELECT COUNT(*) FROM #FirstdayOnfield WHERE RecruitmentType = 'Personal Recruitment')

		UPDATE #OVERVIEW SET ORFirstDateOnField = (SELECT COUNT(*) FROM #IDBadgeIssued WHERE RecruitmentType = 'Office Recruitment')
		UPDATE #OVERVIEW SET PRFirstDateOnField = (SELECT COUNT(*) FROM #IDBadgeIssued WHERE RecruitmentType = 'Personal Recruitment')

		UPDATE #OVERVIEW SET ORLeadersPromoted= (SELECT COUNT(*) FROM #LeadersPromoted WHERE RecruitmentType = 'Office Recruitment')
		UPDATE #OVERVIEW SET PRLeadersPromoted = (SELECT COUNT(*) FROM #LeadersPromoted WHERE RecruitmentType = 'Personal Recruitment')


		--UPDATE #OVERVIEW SET ORTotalActiveHeadcount= (SELECT SUM(Total) FROM #ActiveHC WHERE RecruitmentType = 'Office Recruitment' AND WeDate = @Maxdate2) 
		--UPDATE #OVERVIEW SET PRTotalActiveHeadcount = (SELECT SUM(Total)  FROM #ActiveHC WHERE RecruitmentType = 'Personal Recruitment' AND WeDate = @Maxdate2)

		--UPDATE #OVERVIEW SET ORTotalLeaders = (SELECT SUM(Total) FROM #ACTIVELEADER WHERE RecruitmentType = 'Office Recruitment' AND WeDate = @Maxdate2)
		--UPDATE #OVERVIEW SET PRTotalLeaders = (SELECT SUM(Total) FROM #ACTIVELEADER WHERE RecruitmentType = 'Personal Recruitment' AND WeDate = @Maxdate2)

		-- ADDED ON 03/05
		UPDATE #OVERVIEW SET ORTotalActiveHeadcount= (SELECT SUM(Total) FROM #ActiveHC WHERE RecruitmentType = 'Office Recruitment' AND WeDate = @Maxdate) 
		UPDATE #OVERVIEW SET PRTotalActiveHeadcount = (SELECT SUM(Total)  FROM #ActiveHC WHERE RecruitmentType = 'Personal Recruitment' AND WeDate = @Maxdate)
		-- ADDED ON 03/05
		UPDATE #OVERVIEW SET ORTotalLeaders = (SELECT SUM(Total) FROM #ACTIVELEADER WHERE RecruitmentType = 'Office Recruitment' AND WeDate = @Maxdate)
		UPDATE #OVERVIEW SET PRTotalLeaders = (SELECT SUM(Total) FROM #ACTIVELEADER WHERE RecruitmentType = 'Personal Recruitment' AND WeDate = @Maxdate)


		UPDATE #OVERVIEW SET ORTerminatedICLeader = (SELECT COUNT(*) FROM #TotalInactiveLeader WHERE RecruitmentType = 'Office Recruitment')
		UPDATE #OVERVIEW SET PRTerminatedICLeader = (SELECT COUNT(*) FROM #TotalInactiveLeader WHERE RecruitmentType = 'Personal Recruitment')

		UPDATE #OVERVIEW SET ORTerminatedICNonLeader = (SELECT COUNT(*) FROM #TotalInactiveNonLeader WHERE RecruitmentType = 'Office Recruitment')
		UPDATE #OVERVIEW SET PRTerminatedICNonLeader = (SELECT COUNT(*) FROM #TotalInactiveNonLeader WHERE RecruitmentType = 'Personal Recruitment')

		UPDATE #OVERVIEW SET ORAverageHeadcount = ROUND((ORTotalActiveHeadcount /  CONVERT(decimal(4,2),@NUMOFWE)),0) 
		UPDATE #OVERVIEW SET PRAverageHeadcount = ROUND((PRTotalActiveHeadcount /  CONVERT(decimal(4,2),@NUMOFWE)),0) 

		UPDATE #OVERVIEW SET ORAverageNoOfLeader = ROUND((ORTotalLeaders /  CONVERT(decimal(4,2),@NUMOFWE)),0) 
		UPDATE #OVERVIEW SET PRAverageNoOfLeader = ROUND((PRTotalLeaders /  CONVERT(decimal(4,2),@NUMOFWE)),0) 

		--SELECT * FROM #OVERVIEW
-- ========================= Populate Overview (END) ============================================================================================
-- EXEC SP_RPT_RCAnalysis_Regional_Overview_PBI '2021-04-01','b2a2a1706a0d403598e9115d5846485d'

----CHECKING
SELECT ORTotalActiveHeadcount,PRTotalActiveHeadcount, (ORTotalActiveHeadcount + PRTotalActiveHeadcount) AS TotalActiveBA FROM #OVERVIEW 

--SELECT * FROM #FirstAppt
--SELECT * FROM #FirstApptTurnedUp
--SELECT * FROM #ObservationB
--SELECT * FROM #ObservationTU
--SELECT * FROM #InductionB
--SELECT * FROM #InductionTU
--SELECT * FROM #FirstdayOnfield 
--SELECT * FROM #LeadersPromoted
SELECT * FROM #ActiveHC 
SELECT MCCOUNTRY, WEDATE, SUM(TOTAL) as TOTALACTIVEBA FROM #ActiveHC WHERE WeDate = '2021-04-29' GROUP BY MCCountry, WeDate ORDER BY MCCountry ASC
--SELECT * FROM #ACTIVELEADER
--SELECT * FROM #TotalInactiveLeader
--SELECT * FROM #TotalInactiveNonLeader

END



