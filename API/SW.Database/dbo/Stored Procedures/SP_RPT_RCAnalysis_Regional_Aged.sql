
-- =============================================
-- Author:		Syafiqah Ab Manah
-- Create date: 2020-11-05
-- Description:	Regional RC Analysis Aged Report 
-- SP_RPT_RCAnalysis_Regional_Aged '2020-09-01','b2a2a1706a0d403598e9115d5846485d'
-- =============================================
CREATE PROCEDURE [dbo].[SP_RPT_RCAnalysis_Regional_Aged]
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

		IF OBJECT_ID('tempdb..#SUMMARY') IS NOT NULL DROP TABLE SUMMARY
		CREATE TABLE #SUMMARY
		(
		MCCountry NVARCHAR(2),
		WeDate DATE,

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

		IF OBJECT_ID('tempdb..#SUMMARY2') IS NOT NULL DROP TABLE SUMMARY2
		CREATE TABLE #SUMMARY2
		(
		MCCountry varchar(10),
		WeDate DATE,
		Description varchar(150),
		Total int
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

-- ========================= Prepare Main Data (START) ==============================================================================================
		DECLARE @CountryList nvarchar(50)
		SELECT @CountryList = CountryAccess from Mst_User where UserId = @userId -- UserId = 'b2a2a1706a0d403598e9115d5846485d' --@userid
		IF OBJECT_ID('tempdb..#CountryAcess') IS NOT NULL DROP TABLE #CountryAcess
		SELECT * INTO #CountryAcess FROM STRING_SPLIT((@CountryList ),',')  
		--SELECT * FROM #CountryAcess

		IF OBJECT_ID('tempdb..#MCExclusion') IS NOT NULL DROP TABLE #MCExclusion
		SELECT MarketingCompanyId INTO #MCExclusion FROM Mst_MCExclusion WHERE ExclusionCode = 'RCA'

		IF OBJECT_ID('tempdb..#RTMCExclusion') IS NOT NULL DROP TABLE #RTMCExclusion
		SELECT MarketingCompanyId INTO #RTMCExclusion FROM Mst_MarketingCompany WHERE MarketingCompanyType = 'Roadtrip' AND IsDeleted = 0

		IF OBJECT_ID('tempdb..#FirstApptBooked') IS NOT NULL DROP TABLE #FirstApptBooked
		SELECT * INTO #FirstApptBooked FROM Reporting_Recruitment_Activity  
		WHERE convert(date,ActivityGroupWeekending) >= @MINDATE AND convert(date,ActivityGroupWeekending) <= @MAXDATE
		AND ActivityStage = 'First-Appointment' AND ActivityAppointment = 'Registered' 
		and IsDeleted = 0 and MCCountry IN (SELECT Value from #CountryAcess)
		and MCId not in (SELECT MarketingCompanyId FROM #MCExclusion)
		and MCId not in (SELECT MarketingCompanyId FROM #RTMCExclusion)

		IF OBJECT_ID('tempdb..#MainData') IS NOT NULL DROP TABLE #MainData
		SELECT Distinct RecruitmentCandidateId, ActivityGroupWeekending, RecruitmentType, MCCountry,MCCode,ActivityStage,ActivityAppointment 
		INTO #MainData FROM Reporting_Recruitment_Activity  
		Where RecruitmentCandidateId in (Select RecruitmentCandidateId from #FirstApptBooked)


-- ========================= PREP (START) ========================================================================================================
		-- ================== First-Appointment  ===============
		-- First-Appointment(Booked)
		IF OBJECT_ID('tempdb..#FirstAppt') IS NOT NULL DROP TABLE #FirstAppt
		SELECT DISTINCT RecruitmentCandidateId,MCCountry,ActivityGroupWeekending,RecruitmentType,ActivityStage,ActivityAppointment INTO #FirstAppt FROM #maindata WHERE ActivityStage = 'First-Appointment' AND ActivityAppointment = 'Registered'

		-- First-Appointment(Turned-Up)
		IF OBJECT_ID('tempdb..#FirstApptTurnedUp') IS NOT NULL DROP TABLE #FirstApptTurnedUp
		SELECT DISTINCT RecruitmentCandidateId,MCCountry,ActivityGroupWeekending,RecruitmentType,ActivityStage,ActivityAppointment  INTO #FirstApptTurnedUp FROM #maindata WHERE ActivityStage = 'First-Appointment' AND ActivityAppointment = 'Turned-Up'

		-- ================== Observation  =====================
		-- Observation (Booked)
		IF OBJECT_ID('tempdb..#ObservationB') IS NOT NULL DROP TABLE #ObservationB
		SELECT DISTINCT RecruitmentCandidateId,MCCountry,ActivityGroupWeekending,RecruitmentType,ActivityStage,ActivityAppointment  INTO #ObservationB FROM #maindata WHERE ActivityStage = 'Observation' AND ActivityAppointment = 'Registered' 

		-- Observation(Turned-Up)
		IF OBJECT_ID('tempdb..#ObservationTU') IS NOT NULL DROP TABLE #ObservationTU
		SELECT DISTINCT RecruitmentCandidateId,MCCountry,ActivityGroupWeekending,RecruitmentType,ActivityStage,ActivityAppointment  INTO #ObservationTU FROM #maindata WHERE ActivityStage = 'Observation' AND ActivityAppointment = 'Turned-Up'

		-- ================== Induction  ========================
		-- Induction (Booked)
		IF OBJECT_ID('tempdb..#InductionB') IS NOT NULL DROP TABLE #InductionB
		SELECT DISTINCT RecruitmentCandidateId,MCCountry,ActivityGroupWeekending,RecruitmentType,ActivityStage,ActivityAppointment  INTO #InductionB FROM #maindata WHERE ActivityStage = 'Induction' AND ActivityAppointment = 'Registered' 

		-- Induction(Turned-Up)
		IF OBJECT_ID('tempdb..#InductionTU') IS NOT NULL DROP TABLE #InductionTU
		SELECT DISTINCT RecruitmentCandidateId,MCCountry,ActivityGroupWeekending,RecruitmentType,ActivityStage,ActivityAppointment  INTO #InductionTU FROM #maindata WHERE ActivityStage = 'Induction' AND ActivityAppointment = 'Turned-Up'

		-- ================== IDBadgeIssued  ===============
		-- #IDBadgeIssued
		IF OBJECT_ID('tempdb..#IDBadgeIssued') IS NOT NULL DROP TABLE #IDBadgeIssued
		SELECT DISTINCT RecruitmentCandidateId,MCCountry,ActivityGroupWeekending,RecruitmentType,ActivityStage,ActivityAppointment  INTO #IDBadgeIssued FROM #MainData WHERE ActivityStage = 'Confirmed to Independent Contractor'
		
		-- ================== LeadersPromoted  ====================
		-- #LeadersPromoted 
		IF OBJECT_ID('tempdb..#LeadersPromoted') IS NOT NULL DROP TABLE #LeadersPromoted
		SELECT DISTINCT RecruitmentCandidateId,MCCountry,ActivityGroupWeekending,RecruitmentType,ActivityStage,ActivityAppointment  INTO #LeadersPromoted FROM #MainData WHERE ActivityStage = 'PromoteLeader'
-- ========================= PREP (END) ==========================================================================================================

-- ========================= Populate Summary (START) ============================================================================================
		-- DEFINE COUNTRY FOR DISPLAY ACCORDING TO USER COUNTRY ACCESS
		INSERT INTO #SUMMARY (	MCCountry,WeDate,ORFirstAppointmentBooked,PRFirstAppointmentBooked,ORFirstAppointmentTurnedUp,PRFirstAppointmentTurnedUp,ORObservationBooked,PRObservationBooked,ORObservationTurnedUp,PRObservationTurnedUp,ORInductionBooked,PRInductionBooked,ORInductionTurnedUp,PRInductionTurnedUp,ORIDBadgeIssued,PRIDBadgeIssued,ORLeadersPromoted,PRLeadersPromoted)
		SELECT VALUE AS CC,CB.ActivityGroupWeekending,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		FROM #CountryAcess CA INNER JOIN 
		(SELECT MCCountry, ActivityGroupWeekending
		FROM #maindata  ) CB
		ON CA.VALUE = CB.MCCountry
		GROUP BY CA.value, CB.ActivityGroupWeekending

		--First Appointment
		UPDATE A SET ORFirstAppointmentBooked = CNT
		FROM #SUMMARY A 
		INNER JOIN (SELECT MCCountry,ActivityGroupWeekending, COUNT(RecruitmentCandidateId) AS CNT 
		FROM #FirstAppt WHERE RecruitmentType = 'Office Recruitment' GROUP BY MCCountry,ActivityGroupWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityGroupWeekending
		UPDATE A SET PRFirstAppointmentBooked = CNT
		FROM #SUMMARY A 
		INNER JOIN (SELECT MCCountry,ActivityGroupWeekending,COUNT(*) AS CNT 
		FROM #FirstAppt WHERE RecruitmentType = 'Personal Recruitment' GROUP BY MCCountry,ActivityGroupWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityGroupWeekending
		UPDATE A SET ORFirstAppointmentTurnedUp = CNT
		FROM #SUMMARY A 
		INNER JOIN (SELECT MCCountry,ActivityGroupWeekending,COUNT(*) AS CNT 
		FROM #FirstApptTurnedUp WHERE RecruitmentType = 'Office Recruitment' GROUP BY MCCountry,ActivityGroupWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityGroupWeekending
		UPDATE A SET PRFirstAppointmentTurnedUp = CNT
		FROM #SUMMARY A 
		INNER JOIN (SELECT MCCountry,ActivityGroupWeekending,COUNT(*) AS CNT 
		FROM #FirstApptTurnedUp WHERE RecruitmentType = 'Personal Recruitment' GROUP BY MCCountry,ActivityGroupWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityGroupWeekending

		--Observation
		UPDATE A SET ORObservationBooked = CNT
		FROM #SUMMARY A 
		INNER JOIN (SELECT MCCountry,ActivityGroupWeekending,COUNT(*) AS CNT 
		FROM #ObservationB WHERE RecruitmentType = 'Office Recruitment' GROUP BY MCCountry,ActivityGroupWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityGroupWeekending
		UPDATE A SET PRObservationBooked = CNT
		FROM #SUMMARY A 
		INNER JOIN (SELECT MCCountry,ActivityGroupWeekending,COUNT(*) AS CNT 
		FROM #ObservationB WHERE RecruitmentType = 'Personal Recruitment' GROUP BY MCCountry,ActivityGroupWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityGroupWeekending
		UPDATE A SET ORObservationTurnedUp = CNT
		FROM #SUMMARY A 
		INNER JOIN (SELECT MCCountry,ActivityGroupWeekending,COUNT(*) AS CNT 
		FROM #ObservationTU WHERE RecruitmentType = 'Office Recruitment' GROUP BY MCCountry,ActivityGroupWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityGroupWeekending
		UPDATE A SET PRObservationTurnedUp = CNT
		FROM #SUMMARY A 
		INNER JOIN (SELECT MCCountry,ActivityGroupWeekending,COUNT(*) AS CNT 
		FROM #ObservationTU WHERE RecruitmentType = 'Personal Recruitment' GROUP BY MCCountry,ActivityGroupWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityGroupWeekending

		-- Induction
		UPDATE A SET ORInductionBooked = CNT
		FROM #SUMMARY A 
		INNER JOIN (SELECT MCCountry,ActivityGroupWeekending,COUNT(*) AS CNT 
		FROM #InductionB WHERE RecruitmentType = 'Office Recruitment' GROUP BY MCCountry,ActivityGroupWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityGroupWeekending
		UPDATE A SET PRInductionBooked = CNT
		FROM #SUMMARY A 
		INNER JOIN (SELECT MCCountry,ActivityGroupWeekending,COUNT(*) AS CNT 
		FROM #InductionB WHERE RecruitmentType = 'Personal Recruitment' GROUP BY MCCountry,ActivityGroupWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityGroupWeekending
		UPDATE A SET ORInductionTurnedUp = CNT
		FROM #SUMMARY A 
		INNER JOIN (SELECT MCCountry,ActivityGroupWeekending,COUNT(*) AS CNT 
		FROM #InductionTU WHERE RecruitmentType = 'Office Recruitment' GROUP BY MCCountry,ActivityGroupWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityGroupWeekending
		UPDATE A SET PRInductionTurnedUp = CNT
		FROM #SUMMARY A 
		INNER JOIN (SELECT MCCountry,ActivityGroupWeekending,COUNT(*) AS CNT 
		FROM #InductionTU WHERE RecruitmentType = 'Personal Recruitment' GROUP BY MCCountry,ActivityGroupWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityGroupWeekending

		-- New Starters Badge
		UPDATE A SET ORIDBadgeIssued = CNT
		FROM #SUMMARY A 
		INNER JOIN (SELECT MCCountry,ActivityGroupWeekending,COUNT(*) AS CNT 
		FROM #IDBadgeIssued WHERE RecruitmentType = 'Office Recruitment' GROUP BY MCCountry,ActivityGroupWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityGroupWeekending
		UPDATE A SET PRIDBadgeIssued = CNT
		FROM #SUMMARY A 
		INNER JOIN (SELECT MCCountry,ActivityGroupWeekending,COUNT(*) AS CNT 
		FROM #IDBadgeIssued WHERE RecruitmentType = 'Personal Recruitment' GROUP BY MCCountry,ActivityGroupWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityGroupWeekending

		-- Promoted Leaders 
		UPDATE A SET ORLeadersPromoted = CNT
		FROM #SUMMARY A 
		INNER JOIN (SELECT MCCountry,ActivityGroupWeekending,COUNT(*) AS CNT 
		FROM #LeadersPromoted WHERE RecruitmentType = 'Office Recruitment' GROUP BY MCCountry,ActivityGroupWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityGroupWeekending
		UPDATE A SET PRLeadersPromoted = CNT
		FROM #SUMMARY A 
		INNER JOIN (SELECT MCCountry,ActivityGroupWeekending,COUNT(*) AS CNT 
		FROM #LeadersPromoted WHERE RecruitmentType = 'Office Recruitment' GROUP BY MCCountry,ActivityGroupWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityGroupWeekending

		--SELECT * FROM #SUMMARY ORDER BY MCCountry ASC, WeDate ASC
-- ========================= Populate Summary (END) ============================================================================================

		DECLARE @HeaderDesc VARCHAR (1000)
		SET @HeaderDesc = 'ORFirstAppointmentBooked,PRFirstAppointmentBooked,ORFirstAppointmentTurnedUp,PRFirstAppointmentTurnedUp,ORObservationBooked,PRObservationBooked,ORObservationTurnedUp,PRObservationTurnedUp,ORInductionBooked,PRInductionBooked,ORInductionTurnedUp,PRInductionTurnedUp,ORIDBadgeIssued,PRIDBadgeIssued,ORLeadersPromoted,PRLeadersPromoted'
		
		IF OBJECT_ID('tempdb..#HeaderDesc') IS NOT NULL DROP TABLE #HeaderDesc
		SELECT * INTO #HeaderDesc FROM STRING_SPLIT((@HeaderDesc ),',')  

		IF OBJECT_ID('tempdb..#WE') IS NOT NULL DROP TABLE #we
		SELECT * INTO #we FROM STRING_SPLIT((@we ),',')  

		select a.value as CC,b.value as Description, c.value AS WeDate into #Header from #CountryAcess a cross join  #HeaderDesc b cross join #we c

		INSERT INTO #SUMMARY2 (	MCCountry,WeDate,Description,Total)
		SELECT CC,WeDate,Description,0
		FROM #Header
		GROUP BY CC,WeDate,Description
		
		-- FIRST APPOINTMENT----------------------------------------------------------------------------------------------------------																											
		UPDATE A SET Total = CNT
		FROM #SUMMARY2 A 
		INNER JOIN (SELECT MCCountry,ActivityGroupWeekending,COUNT(*) AS CNT 
		FROM #FirstAppt WHERE RecruitmentType = 'Office Recruitment' GROUP BY MCCountry,ActivityGroupWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityGroupWeekending AND A.Description = 'ORFirstAppointmentBooked'

		UPDATE A SET Total = CNT
		FROM #SUMMARY2 A 
		INNER JOIN (SELECT MCCountry,ActivityGroupWeekending,COUNT(*) AS CNT 
		FROM #FirstApptTurnedUp WHERE RecruitmentType = 'Office Recruitment' GROUP BY MCCountry,ActivityGroupWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityGroupWeekending AND A.Description = 'ORFirstAppointmentTurnedUp'

		UPDATE A SET Total = CNT
		FROM #SUMMARY2 A 
		INNER JOIN (SELECT MCCountry,ActivityGroupWeekending,COUNT(*) AS CNT 
		FROM #FirstAppt WHERE RecruitmentType = 'Personal Recruitment' GROUP BY MCCountry,ActivityGroupWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityGroupWeekending AND A.Description = 'PRFirstAppointmentBooked'

		UPDATE A SET Total = CNT
		FROM #SUMMARY2 A 
		INNER JOIN (SELECT MCCountry,ActivityGroupWeekending,COUNT(*) AS CNT 
		FROM #FirstApptTurnedUp WHERE RecruitmentType = 'Personal Recruitment' GROUP BY MCCountry,ActivityGroupWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityGroupWeekending AND A.Description = 'PRFirstAppointmentTurnedUp'
		-- FIRST APPOINTMENT----------------------------------------------------------------------------------------------------------																											
		-- OBSERVATION ---------------------------------------------------------------------------------------------------------------																											
		UPDATE A SET Total = CNT
		FROM #SUMMARY2 A 
		INNER JOIN (SELECT MCCountry,ActivityGroupWeekending,COUNT(*) AS CNT 
		FROM #ObservationB WHERE RecruitmentType = 'Office Recruitment' GROUP BY MCCountry,ActivityGroupWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityGroupWeekending AND A.Description = 'ORObservationBooked'

		UPDATE A SET Total = CNT
		FROM #SUMMARY2 A 
		INNER JOIN (SELECT MCCountry,ActivityGroupWeekending,COUNT(*) AS CNT 
		FROM #ObservationTU WHERE RecruitmentType = 'Office Recruitment' GROUP BY MCCountry,ActivityGroupWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityGroupWeekending AND A.Description = 'ORObservationTurnedUp'

		UPDATE A SET Total = CNT
		FROM #SUMMARY2 A 
		INNER JOIN (SELECT MCCountry,ActivityGroupWeekending,COUNT(*) AS CNT
		FROM #ObservationB WHERE RecruitmentType = 'Personal Recruitment' GROUP BY MCCountry,ActivityGroupWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityGroupWeekending AND A.Description = 'PRObservationBooked'

		UPDATE A SET Total = CNT
		FROM #SUMMARY2 A 
		INNER JOIN (SELECT MCCountry,ActivityGroupWeekending,COUNT(*) AS CNT 
		FROM #ObservationTU WHERE RecruitmentType = 'Personal Recruitment' GROUP BY MCCountry,ActivityGroupWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityGroupWeekending AND A.Description = 'PRObservationTurnedUp'
		-- OBSERVATION ---------------------------------------------------------------------------------------------------------------																											
		-- INDUCTION  ----------------------------------------------------------------------------------------------------------------																											
		UPDATE A SET Total = CNT
		FROM #SUMMARY2 A    
		INNER JOIN (SELECT MCCountry,ActivityGroupWeekending,COUNT(*) AS CNT 
		FROM #InductionB WHERE RecruitmentType = 'Office Recruitment' GROUP BY MCCountry,ActivityGroupWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityGroupWeekending AND A.Description = 'ORInductionBooked'

		UPDATE A SET Total = CNT                                                 
		FROM #SUMMARY2 A 
		INNER JOIN (SELECT MCCountry,ActivityGroupWeekending,COUNT(*) AS CNT 
		FROM #InductionTU WHERE RecruitmentType = 'Office Recruitment' GROUP BY MCCountry,ActivityGroupWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityGroupWeekending AND A.Description = 'ORInductionTurnedUp'

		UPDATE A SET Total = CNT
		FROM #SUMMARY2 A 
		INNER JOIN (SELECT MCCountry,ActivityGroupWeekending,COUNT(*) AS CNT 
		FROM #InductionB WHERE RecruitmentType = 'Personal Recruitment' GROUP BY MCCountry,ActivityGroupWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityGroupWeekending AND A.Description = 'PRInductionBooked'

		UPDATE A SET Total = CNT 
		FROM #SUMMARY2 A 
		INNER JOIN (SELECT MCCountry,ActivityGroupWeekending,COUNT(*) AS CNT 
		FROM #InductionTU WHERE RecruitmentType = 'Personal Recruitment' GROUP BY MCCountry,ActivityGroupWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityGroupWeekending AND A.Description = 'PRInductionTurnedUp'
		-- INDUCTION  ----------------------------------------------------------------------------------------------------------------			
		-- ID BADGE ISSUED  ----------------------------------------------------------------------------------------------------------																											
		UPDATE A SET Total = CNT
		FROM #SUMMARY2 A    
		INNER JOIN (SELECT MCCountry,ActivityGroupWeekending,COUNT(*) AS CNT 
		FROM #IDBadgeIssued WHERE RecruitmentType = 'Office Recruitment' GROUP BY MCCountry,ActivityGroupWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityGroupWeekending AND A.Description = 'ORIDBadgeIssued' 

		UPDATE A SET Total = CNT 
		FROM #SUMMARY2 A 
		INNER JOIN (SELECT MCCountry,ActivityGroupWeekending,COUNT(*) AS CNT 
		FROM #IDBadgeIssued WHERE RecruitmentType = 'Personal Recruitment' GROUP BY MCCountry,ActivityGroupWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityGroupWeekending AND A.Description = 'PRIDBadgeIssued'
		-- ID BADGE ISSUED  ----------------------------------------------------------------------------------------------------------		
		-- LEADER PROMOTED  ----------------------------------------------------------------------------------------------------------																											
		UPDATE A SET Total = CNT
		FROM #SUMMARY2 A    
		INNER JOIN (SELECT MCCountry,ActivityGroupWeekending,COUNT(*) AS CNT 
		FROM #LeadersPromoted WHERE RecruitmentType = 'Office Recruitment' GROUP BY MCCountry,ActivityGroupWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityGroupWeekending AND A.Description = 'ORLeadersPromoted' 

		UPDATE A SET Total = CNT 
		FROM #SUMMARY2 A 
		INNER JOIN (SELECT MCCountry,ActivityGroupWeekending,COUNT(*) AS CNT 
		FROM #LeadersPromoted WHERE RecruitmentType = 'Personal Recruitment' GROUP BY MCCountry,ActivityGroupWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityGroupWeekending AND A.Description = 'PRLeadersPromoted'
		-- LEADER PROMOTED  ----------------------------------------------------------------------------------------------------------	
																					
																												
		SELECT * FROM #SUMMARY2 ORDER BY Description ASC,MCCountry ASC, WeDate ASC

----CHECKING

SELECT * FROM #FirstAppt ORDER BY ActivityGroupWeekending ASC
SELECT * FROM #FirstApptTurnedUp ORDER BY ActivityGroupWeekending ASC
SELECT * FROM #ObservationB ORDER BY ActivityGroupWeekending ASC
SELECT * FROM #ObservationTU ORDER BY ActivityGroupWeekending ASC
SELECT * FROM #InductionB ORDER BY ActivityGroupWeekending ASC
SELECT * FROM #InductionTU ORDER BY ActivityGroupWeekending ASC
SELECT * FROM #IDBadgeIssued ORDER BY ActivityGroupWeekending ASC
SELECT * FROM #LeadersPromoted ORDER BY ActivityGroupWeekending ASC

END



