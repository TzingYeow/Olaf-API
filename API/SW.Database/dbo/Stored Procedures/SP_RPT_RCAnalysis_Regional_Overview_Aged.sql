
-- ==========================================================================================
-- Author:		Syafiqah Ab Manah
-- Create date: 2020-11-18
-- Description:	Regional RC Analysis Aged Report 
-- SP_RPT_RCAnalysis_Regional_Overview_Aged '2020-09-01','b2a2a1706a0d403598e9115d5846485d'
-- ==========================================================================================
CREATE PROCEDURE [dbo].[SP_RPT_RCAnalysis_Regional_Overview_Aged]
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

	Set @Searchmonth = Month(@Searchdate)
	Set @Searchyear = Year(@Searchdate)
	Set @Todaydate = Getdate()
	Set @Currentmonth = Month(@Todaydate)

		IF OBJECT_ID('tempdb..#AgedData') IS NOT NULL DROP TABLE #AgedData
		CREATE TABLE #AgedData
		(
		CountryCode nvarchar (2),
		WeDate date,

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

		ORLeadersPromoted INT,
		PRLeadersPromoted INT,
		)
-- ========================= Define Time Range (START) ================================================================================================

		IF @Searchmonth = @Currentmonth
			BEGIN
				IF OBJECT_ID('tempdb..#Weekending') IS NOT NULL DROP TABLE #Weekending
				SELECT ROW_NUMBER() OVER(ORDER BY WEDate ASC) AS NoOfWE,WEdate,FromDate,ToDate     
				INTO #Weekending FROM Mst_Weekending      
				WHERE MONTH(WEdate) =  @Searchmonth AND YEAR(WEdate) = @Searchyear
				ORDER BY WEdate ASC

				SELECT @NUMOFWE = NoOfWE FROM #Weekending WHERE @Searchdate >= FromDate AND @Searchdate <= ToDate

				SELECT TOP 1 @MINDATE = FromDate FROM #Weekending ORDER BY FromDate ASC
				SELECT TOP 1 @MAXDATE = ToDate FROM #Weekending WHERE NoOfWE = @NUMOFWE ORDER BY ToDate DESC

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

		IF OBJECT_ID('tempdb..#FirstApptBooked') IS NOT NULL DROP TABLE #FirstApptBooked
		SELECT * INTO #FirstApptBooked FROM Reporting_Recruitment_Activity  
		WHERE convert(date,ActivityGroupWeekending) >= @MINDATE AND convert(date,ActivityGroupWeekending) <= @MAXDATE
		AND ActivityStage = 'First-Appointment' AND ActivityAppointment = 'Registered' 
		and IsDeleted = 0 and MCCountry IN (SELECT Value from #CountryAcess)
		and MCId not in (SELECT MarketingCompanyId FROM #MCExclusion)
		and MCId not in (SELECT MarketingCompanyId FROM #RTMCExclusion)

		IF OBJECT_ID('tempdb..#MainData') IS NOT NULL DROP TABLE #MainData
		SELECT RecruitmentCandidateId, ActivityGroupWeekending, RecruitmentType, MCCountry,MCCode,ActivityStage,ActivityAppointment INTO #MainData FROM Reporting_Recruitment_Activity  
		Where RecruitmentCandidateId in (Select RecruitmentCandidateId from #FirstApptBooked)

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

		-- ================== IDBadgeIssued  ===============
		-- #IDBadgeIssued
		IF OBJECT_ID('tempdb..#IDBadgeIssued') IS NOT NULL DROP TABLE #IDBadgeIssued
		SELECT * INTO #IDBadgeIssued FROM #MainData WHERE ActivityStage = 'Confirmed to Independent Contractor'
		
		-- ================== LeadersPromoted  ====================
		-- #LeadersPromoted 
		IF OBJECT_ID('tempdb..#LeadersPromoted') IS NOT NULL DROP TABLE #LeadersPromoted
		SELECT * INTO #LeadersPromoted FROM #MainData WHERE ActivityStage = 'PromoteLeader'

-- ========================= PREP (END) ===========================================================================================================

-- ========================= Populate Overview (START) ============================================================================================

		INSERT INTO #AgedData (	ORFirstAppointmentBooked, PRFirstAppointmentBooked, ORFirstAppointmentTurnedUp,	PRFirstAppointmentTurnedUp, 
								ORObservationBooked, PRObservationBooked, ORObservationTurnedUp, PRObservationTurnedUp,
								ORInductionBooked, PRInductionBooked, ORInductionTurnedUp , PRInductionTurnedUp , 
								ORIDBadgeIssued , PRIDBadgeIssued , ORLeadersPromoted , PRLeadersPromoted)
		VALUES	(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)

		UPDATE #AgedData SET ORFirstAppointmentBooked = (SELECT COUNT(*) FROM #FirstAppt WHERE RecruitmentType = 'Office Recruitment')
		UPDATE #AgedData SET PRFirstAppointmentBooked = (SELECT COUNT(*) FROM #FirstAppt WHERE RecruitmentType = 'Personal Recruitment')
		UPDATE #AgedData SET ORFirstAppointmentTurnedUp = (SELECT COUNT(*) FROM #FirstApptTurnedUp WHERE RecruitmentType = 'Office Recruitment')
		UPDATE #AgedData SET PRFirstAppointmentTurnedUp = (SELECT COUNT(*) FROM #FirstApptTurnedUp WHERE RecruitmentType = 'Personal Recruitment')

		UPDATE #AgedData SET ORObservationBooked = (SELECT COUNT(*) FROM #ObservationB WHERE RecruitmentType = 'Office Recruitment')
		UPDATE #AgedData SET PRObservationBooked = (SELECT COUNT(*) FROM #ObservationB WHERE RecruitmentType = 'Personal Recruitment')
		UPDATE #AgedData SET ORObservationTurnedUp = (SELECT COUNT(*) FROM #ObservationTU WHERE RecruitmentType = 'Office Recruitment')
		UPDATE #AgedData SET PRObservationTurnedUp = (SELECT COUNT(*) FROM #ObservationTU WHERE RecruitmentType = 'Personal Recruitment')

		UPDATE #AgedData SET ORInductionBooked =  (SELECT COUNT(*) FROM #InductionB WHERE RecruitmentType = 'Office Recruitment')
		UPDATE #AgedData SET PRInductionBooked =  (SELECT COUNT(*) FROM #InductionB WHERE RecruitmentType = 'Personal Recruitment')
		UPDATE #AgedData SET ORInductionTurnedUp =  (SELECT COUNT(*) FROM #InductionTU WHERE RecruitmentType = 'Office Recruitment')
		UPDATE #AgedData SET PRInductionTurnedUp =  (SELECT COUNT(*) FROM #InductionTU WHERE RecruitmentType = 'Personal Recruitment')

		UPDATE #AgedData SET ORIDBadgeIssued = (SELECT COUNT(*) FROM #IDBadgeIssued WHERE RecruitmentType = 'Office Recruitment')
		UPDATE #AgedData SET PRIDBadgeIssued = (SELECT COUNT(*) FROM #IDBadgeIssued WHERE RecruitmentType = 'Personal Recruitment')

		UPDATE #AgedData SET ORLeadersPromoted= (SELECT COUNT(*) FROM #LeadersPromoted WHERE RecruitmentType = 'Office Recruitment')
		UPDATE #AgedData SET PRLeadersPromoted = (SELECT COUNT(*) FROM #LeadersPromoted WHERE RecruitmentType = 'Personal Recruitment')

		SELECT * FROM #AgedData
-- ========================= Populate Overview (END) ============================================================================================


----CHECKING

SELECT * FROM #FirstAppt
SELECT * FROM #FirstApptTurnedUp
SELECT * FROM #ObservationB
SELECT * FROM #ObservationTU
SELECT * FROM #InductionB
SELECT * FROM #InductionTU
SELECT * FROM #LeadersPromoted

END



