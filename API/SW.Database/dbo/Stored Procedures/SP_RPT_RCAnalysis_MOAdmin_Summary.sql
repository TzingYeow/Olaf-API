
-- =============================================
-- Author:		Syafiqah Ab Manah
-- Create date: 2020-11-05
-- Description:	MO Admin Access RC Analysis Report 
-- EXEC SP_RPT_RCAnalysis_MOAdmin_Summary '2021-06-01','ba608c0d064243d88450d8c948e4df40'
-- =============================================
CREATE PROCEDURE [dbo].[SP_RPT_RCAnalysis_MOAdmin_Summary]
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
	Declare @we varchar(100)

	Set @Searchmonth = Month(@Searchdate)
	Set @Searchyear = Year(@Searchdate)
	Set @Todaydate = CAST(getdate() AS DATE)
	SELECT @Currentmonth = MONTH(WEDATE) FROM Mst_Weekending WHERE CAST(GETDATE() AS DATE) >= FromDate AND  CAST(GETDATE() AS DATE) <= ToDate

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
		ORFirstDateOnField INT,
		PRFirstDateOnField INT,
		ORLeadersPromoted INT,
		PRLeadersPromoted INT,
		ORTotalActiveHeadcount INT,
		PRTotalActiveHeadcount INT,
		ORTotalLeaders INT,
		PRTotalLeaders INT
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
				--SELECT @SEARCHMONTH AS SEARCHMONTH, @CURRENTMONTH AS CURRENTMONTH,@NUMOFWE NoOfWE ,@MINDATE Mindate,@MAXDATE Maxdate -- CHECKING
				--SELECT @MINDATE,@MAXDATE

-- ========================= Define Time Range (END) ================================================================================================

-- ========================= Prepare Main Data (START) ================================================================================================
		DECLARE @CountryList nvarchar(200)
		DECLARE @MCList nvarchar(200)
		SELECT @CountryList = CountryAccess from Mst_User where UserId = @userId -- UserId = 'b2a2a1706a0d403598e9115d5846485d' --@userid

		IF OBJECT_ID('tempdb..#CountryAcess') IS NOT NULL DROP TABLE #CountryAcess
		SELECT * INTO #CountryAcess FROM STRING_SPLIT((@CountryList ),',')  

		IF OBJECT_ID('tempdb..#MCExclusion') IS NOT NULL DROP TABLE #MCExclusion
		SELECT MarketingCompanyId INTO #MCExclusion FROM Mst_MCExclusion WHERE ExclusionCode = 'RCA'

		IF OBJECT_ID('tempdb..#RTMCExclusion') IS NOT NULL DROP TABLE #RTMCExclusion
		SELECT MarketingCompanyId INTO #RTMCExclusion FROM Mst_MarketingCompany 
		WHERE MarketingCompanyType IN ('Roadtrip','Agency') AND IsDeleted = 0

		DECLARE @AdminMC nvarchar(50)
		SELECT @AdminMC = MarketingCompanyId from Mst_User where UserId = @userId -- UserId = 'b2a2a1706a0d403598e9115d5846485d' --@userid

		IF OBJECT_ID('tempdb..#maindata') IS NOT NULL DROP TABLE #maindata
		SELECT * INTO #maindata FROM Reporting_Recruitment_Activity  
		WHERE convert(date,ActivityScheduleStartDateTime) >= @MINDATE AND convert(date,ActivityScheduleStartDateTime) <= @MAXDATE
		and IsDeleted = 0 and MCCountry IN (SELECT Value from #CountryAcess)
		and MCId not in (SELECT MarketingCompanyId FROM #MCExclusion)
		and MCId not in (SELECT MarketingCompanyId FROM #RTMCExclusion)
		and MCId = @AdminMC

		IF OBJECT_ID('tempdb..#icmaindata') IS NOT NULL DROP TABLE #icmaindata
		SELECT C.CountryCode AS MCCountry,c.MarketingCompanyId AS MCID,A.*,B.STATUS,B.LastDeactivateDate,B.RecruitmentType, D.WEdate 
		INTO #icmaindata FROM Mst_IndependentContractor_Movement  A
		INNER JOIN Mst_IndependentContractor B ON A.IndependentContractorId = B.IndependentContractorId
		INNER JOIN Mst_MarketingCompany C ON B.MarketingCompanyId = C.MarketingCompanyId
		LEFT JOIN Mst_Weekending D ON A.EffectiveDate >= FromDate AND A.EffectiveDate <= ToDate
		WHERE convert(date, EffectiveDate) >= @MINDATE AND convert(date, EffectiveDate)  <= @MAXDATE AND B.IsDeleted = 0 AND A.IsDeleted = 0 
		and c.CountryCode IN (SELECT Value from #CountryAcess)
		and b.MarketingCompanyId not in  (SELECT MarketingCompanyId FROM #MCExclusion)
		and b.MarketingCompanyId not in  (SELECT MarketingCompanyId FROM #RTMCExclusion)
		and b.MarketingCompanyId = @AdminMC

		IF OBJECT_ID('tempdb..#MC') IS NOT NULL DROP TABLE #MC
		SELECT * INTO #MC FROM Mst_MarketingCompany WHERE CountryCode IN (SELECT Value from #CountryAcess) 
		AND MarketingCompanyId = @AdminMC

		SELECT @MCList = COALESCE(@MCList + ',' ,'') + convert(varchar(20),Code) from #MC

-- ========================= PREP (START) ===========================================================================================================

-- ================== First-Appointment  =======================================================

		-- First-Appointment(Booked)
		IF OBJECT_ID('tempdb..#FirstAppt') IS NOT NULL DROP TABLE #FirstAppt
		SELECT * INTO #FirstAppt FROM #maindata WHERE ActivityStage = 'First-Appointment' AND ActivityAppointment = 'Registered'

		-- First-Appointment(Turned-Up)
		IF OBJECT_ID('tempdb..#FirstApptTurnedUp') IS NOT NULL DROP TABLE #FirstApptTurnedUp
		SELECT * INTO #FirstApptTurnedUp FROM #maindata WHERE ActivityStage = 'First-Appointment' AND ActivityAppointment = 'Turned-Up'

-- ================== Observation  =============================================================

		-- Observation (Booked)
		IF OBJECT_ID('tempdb..#ObservationB') IS NOT NULL DROP TABLE #ObservationB
		SELECT * INTO #ObservationB FROM #maindata WHERE ActivityStage = 'Observation' AND ActivityAppointment = 'Registered' 

		-- Observation(Turned-Up)
		IF OBJECT_ID('tempdb..#ObservationTU') IS NOT NULL DROP TABLE #ObservationTU
		SELECT * INTO #ObservationTU FROM #maindata WHERE ActivityStage = 'Observation' AND ActivityAppointment = 'Turned-Up'

-- ================== Induction  ================================================================

		-- Induction (Booked)
		IF OBJECT_ID('tempdb..#InductionB') IS NOT NULL DROP TABLE #InductionB
		SELECT * INTO #InductionB FROM #maindata WHERE ActivityStage = 'Induction' AND ActivityAppointment = 'Registered' 

		-- Induction(Turned-Up)
		IF OBJECT_ID('tempdb..#InductionTU') IS NOT NULL DROP TABLE #InductionTU
		SELECT * INTO #InductionTU FROM #maindata WHERE ActivityStage = 'Induction' AND ActivityAppointment = 'Turned-Up'

-- ================== LeadersPromoted  ============================================================

		-- #LeadersPromoted 
		IF OBJECT_ID('tempdb..#LeadersPromoted') IS NOT NULL DROP TABLE #LeadersPromoted
		SELECT C.CountryCode AS MCCountry,c.MarketingCompanyId AS MCID,A.*,B.STATUS,B.LastDeactivateDate,B.RecruitmentType, D.WEdate 
		INTO #LeadersPromoted FROM Mst_IndependentContractor_Movement  A
		INNER JOIN Mst_IndependentContractor B ON A.IndependentContractorId = B.IndependentContractorId
		INNER JOIN Mst_MarketingCompany C ON B.MarketingCompanyId = C.MarketingCompanyId
		LEFT JOIN Mst_Weekending D ON A.PromotionDemotionDate >= FromDate AND A.PromotionDemotionDate <= ToDate
		WHERE convert(date, PromotionDemotionDate) >= @MINDATE AND convert(date, PromotionDemotionDate)  <= @MAXDATE AND B.IsDeleted = 0 AND A.IsDeleted = 0 
		and c.CountryCode IN (SELECT Value from #CountryAcess)
		and b.MarketingCompanyId not in  (SELECT MarketingCompanyId FROM #MCExclusion)
		and b.MarketingCompanyId not in  (SELECT MarketingCompanyId FROM #RTMCExclusion)
		and b.MarketingCompanyId = @AdminMC
		and Description = 'Advance' AND A.IndependentContractorLevelId= '4' and A.IsDeleted = 0

-- ================== INACTIVE BA  ================================================================

		IF OBJECT_ID('tempdb..#INACTIVEIC') IS NOT NULL DROP TABLE #INACTIVEIC
		SELECT DISTINCT MCCountry,MCID,IndependentContractorId, IndependentContractorLevelId, RecruitmentType, Description, max(EffectiveDate) AS EffectiveDate INTO #INACTIVEIC
		FROM #icmaindata WHERE Description IN ('Deactivate','Deactivated','Terminate')
		AND Coalesce(LeavingReasonCategory, '') <> 'TRANSFER'
		GROUP BY MCCountry,MCID,IndependentContractorId, IndependentContractorLevelId, RecruitmentType, Description

-- ================== TotalActiveHeadcount  ============================================================================

		IF OBJECT_ID('tempdb..#ActiveHC') IS NOT NULL DROP TABLE #ActiveHC
		SELECT A.CountryCode as MCCountry,A.MCCode,A.WEStatus AS WeDate,A.WESTage,B.RecruitmentSource AS Channel, B.RecruiterBadgeNoOrName AS Recruiter,
		A.RecruitmentType,COUNT(*) AS Total 
		INTO #ActiveHC FROM TXN_ICWeekendingStatus A
		INNER JOIN Mst_IndependentContractor B ON A.BAID = B.IndependentContractorId
		WHERE WESTATUS >= @Mindate AND WESTATUS <= @Maxdate AND ACTIVESTATUS = 1
		and b.MarketingCompanyId not in  (SELECT MarketingCompanyId FROM #MCExclusion)
		and b.MarketingCompanyId not in  (SELECT MarketingCompanyId FROM #RTMCExclusion)
		and b.MarketingCompanyId = @AdminMC
		GROUP BY CountryCode,MCCode,WEStatus,WESTage,RecruitmentSource,RecruiterBadgeNoOrName,A.RecruitmentType
		ORDER BY MCCountry ASC,MCCode ASC,WeDate ASC,Channel ASC,RecruiterBadgeNoOrName ASC
	
-- ================== IDBadgeIssued  ===========================================================================

		-- #IDBadgeIssued
		IF OBJECT_ID('tempdb..#IDBadgeIssued') IS NOT NULL DROP TABLE #IDBadgeIssued
		SELECT B.CountryCode AS MCCountry, B.MarketingCompanyId AS MCID,A.IndependentContractorId,A.RecruitmentType,A.StartDate , C.WEdate
		INTO #IDBadgeIssued FROM Mst_IndependentContractor a 
		INNER JOIN Mst_MarketingCompany B ON A.MarketingCompanyId = B.MarketingCompanyId
		LEFT JOIN Mst_Weekending C ON A.StartDate >= FromDate AND A.StartDate <= ToDate
		WHERE convert(date, A.StartDate) >= @MINDATE AND convert(date, A.StartDate) <= @MAXDATE AND A.IsDeleted = 0
		and a.MarketingCompanyId not in  (SELECT MarketingCompanyId FROM #MCExclusion)
		and a.MarketingCompanyId not in  (SELECT MarketingCompanyId FROM #RTMCExclusion)
		and b.MarketingCompanyId = @AdminMC

-- ================== FirstdayOnfield  ===========================================================

		-- FirstdayOnfield
		IF OBJECT_ID('tempdb..#FirstdayOnfield') IS NOT NULL DROP TABLE #FirstdayOnfield
		SELECT b.CountryCode AS MCCountry, b.MarketingCompanyId AS MCID,a.IndependentContractorId,a.RecruitmentType,a.DateFirstOnField,c.WEdate
		INTO #FirstdayOnfield FROM Mst_IndependentContractor a
		inner join Mst_MarketingCompany b on a.MarketingCompanyId = b.MarketingCompanyId
		inner join Mst_Weekending C on DateFirstOnField >= FromDate AND DateFirstOnField <= ToDate
		WHERE DateFirstOnField >= @MINDATE AND DateFirstOnField <= @MAXDATE AND a.IsDeleted = 0
		and b.CountryCode IN (SELECT Value from #CountryAcess)
		and a.MarketingCompanyId not in  (SELECT MarketingCompanyId FROM #MCExclusion)
		and a.MarketingCompanyId not in  (SELECT MarketingCompanyId FROM #RTMCExclusion)
		and b.MarketingCompanyId = @AdminMC

-- ========================= PREP (END) ===========================================================================================================

---- ========================= Populate Summary (START) ============================================================================================
------ DEFINE COUNTRY FOR DISPLAY ACCORDING TO USER COUNTRY ACCESS
--		INSERT INTO #SUMMARY (	MCCountry,WeDate,ORFirstAppointmentBooked,PRFirstAppointmentBooked,ORFirstAppointmentTurnedUp,PRFirstAppointmentTurnedUp,ORObservationBooked,PRObservationBooked,ORObservationTurnedUp,PRObservationTurnedUp,ORInductionBooked,PRInductionBooked,ORInductionTurnedUp,PRInductionTurnedUp,ORIDBadgeIssued,PRIDBadgeIssued,ORFirstDateOnField,PRFirstDateOnField,ORLeadersPromoted,PRLeadersPromoted,ORTotalActiveHeadcount,PRTotalActiveHeadcount,ORTotalLeaders,PRTotalLeaders)
--		SELECT VALUE AS CC,CB.ActivityScheduleStartWeekending,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
--		FROM #CountryAcess CA INNER JOIN 
--		(SELECT MCCountry, ActivityScheduleStartWeekending
--		FROM #maindata  ) CB
--		ON CA.VALUE = CB.MCCountry
--		GROUP BY CA.value, CB.ActivityScheduleStartWeekending

--		UPDATE A SET ORFirstAppointmentBooked = CNT
--		FROM #SUMMARY A 
--		INNER JOIN (SELECT MCCountry,ActivityScheduleStartWeekending,COUNT(*) AS CNT 
--		FROM #FirstAppt WHERE RecruitmentType = 'Office Recruitment' GROUP BY MCCountry,ActivityScheduleStartWeekending ) AS B
--		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityScheduleStartWeekending

--		UPDATE A SET ORFirstAppointmentTurnedUp = CNT
--		FROM #SUMMARY A 
--		INNER JOIN (SELECT MCCountry,ActivityScheduleStartWeekending,COUNT(*) AS CNT 
--		FROM #FirstApptTurnedUp WHERE RecruitmentType = 'Office Recruitment' GROUP BY MCCountry,ActivityScheduleStartWeekending ) AS B
--		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityScheduleStartWeekending

--		UPDATE A SET ORObservationBooked = CNT
--		FROM #SUMMARY A 
--		INNER JOIN (SELECT MCCountry,ActivityScheduleStartWeekending,COUNT(*) AS CNT 
--		FROM #ObservationB WHERE RecruitmentType = 'Office Recruitment' GROUP BY MCCountry,ActivityScheduleStartWeekending ) AS B
--		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityScheduleStartWeekending

--		UPDATE A SET ORObservationTurnedUp = CNT
--		FROM #SUMMARY A 
--		INNER JOIN (SELECT MCCountry,ActivityScheduleStartWeekending,COUNT(*) AS CNT 
--		FROM #ObservationTU WHERE RecruitmentType = 'Office Recruitment' GROUP BY MCCountry,ActivityScheduleStartWeekending ) AS B
--		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityScheduleStartWeekending

--		UPDATE A SET ORInductionBooked = CNT
--		FROM #SUMMARY A 
--		INNER JOIN (SELECT MCCountry,ActivityScheduleStartWeekending,COUNT(*) AS CNT 
--		FROM #InductionB WHERE RecruitmentType = 'Office Recruitment' GROUP BY MCCountry,ActivityScheduleStartWeekending ) AS B
--		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityScheduleStartWeekending

--		UPDATE A SET ORInductionTurnedUp = CNT
--		FROM #SUMMARY A 
--		INNER JOIN (SELECT MCCountry,ActivityScheduleStartWeekending,COUNT(*) AS CNT 
--		FROM #InductionTU WHERE RecruitmentType = 'Office Recruitment' GROUP BY MCCountry,ActivityScheduleStartWeekending ) AS B
--		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityScheduleStartWeekending

--		UPDATE A SET ORIDBadgeIssued = CNT
--		FROM #SUMMARY A 
--		INNER JOIN (SELECT MCCountry,WEdate,COUNT(*) AS CNT 
--		FROM #IDBadgeIssued WHERE RecruitmentType = 'Office Recruitment' GROUP BY MCCountry,WEdate ) AS B
--		ON A.MCCountry = B.MCCountry AND A.WeDate = B.WEdate

--		UPDATE A SET ORFirstDateOnField = CNT 
--		FROM #SUMMARY A 
--		INNER JOIN (SELECT MCCountry,WEdate,COUNT(*) AS CNT 
--		FROM #FirstdayOnfield WHERE RecruitmentType = 'Office Recruitment' GROUP BY MCCountry,WEdate ) AS B
--		ON A.MCCountry = B.MCCountry AND A.WeDate = B.WEdate

--		UPDATE A SET ORTotalActiveHeadcount = CNT
--		FROM #SUMMARY A 
--		INNER JOIN (SELECT MCCountry,WEdate,COUNT(*) AS CNT 
--		FROM #ActiveHC WHERE RecruitmentType = 'Office Recruitment' GROUP BY MCCountry,WEdate ) AS B
--		ON A.MCCountry = B.MCCountry AND A.WeDate = B.WEdate

--		UPDATE A SET PRFirstAppointmentBooked = CNT
--		FROM #SUMMARY A 
--		INNER JOIN (SELECT MCCountry,ActivityScheduleStartWeekending,COUNT(*) AS CNT 
--		FROM #FirstAppt WHERE RecruitmentType = 'Personal Recruitment' GROUP BY MCCountry,ActivityScheduleStartWeekending ) AS B
--		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityScheduleStartWeekending

--		UPDATE A SET PRFirstAppointmentTurnedUp = CNT
--		FROM #SUMMARY A 
--		INNER JOIN (SELECT MCCountry,ActivityScheduleStartWeekending,COUNT(*) AS CNT 
--		FROM #FirstApptTurnedUp WHERE RecruitmentType = 'Personal Recruitment' GROUP BY MCCountry,ActivityScheduleStartWeekending ) AS B
--		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityScheduleStartWeekending

--		UPDATE A SET PRObservationBooked = CNT
--		FROM #SUMMARY A 
--		INNER JOIN (SELECT MCCountry,ActivityScheduleStartWeekending,COUNT(*) AS CNT 
--		FROM #ObservationB WHERE RecruitmentType = 'Personal Recruitment' GROUP BY MCCountry,ActivityScheduleStartWeekending ) AS B
--		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityScheduleStartWeekending

--		UPDATE A SET PRObservationTurnedUp = CNT
--		FROM #SUMMARY A 
--		INNER JOIN (SELECT MCCountry,ActivityScheduleStartWeekending,COUNT(*) AS CNT 
--		FROM #ObservationTU WHERE RecruitmentType = 'Personal Recruitment' GROUP BY MCCountry,ActivityScheduleStartWeekending ) AS B
--		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityScheduleStartWeekending

--		UPDATE A SET PRInductionBooked = CNT
--		FROM #SUMMARY A 
--		INNER JOIN (SELECT MCCountry,ActivityScheduleStartWeekending,COUNT(*) AS CNT 
--		FROM #InductionB WHERE RecruitmentType = 'Personal Recruitment' GROUP BY MCCountry,ActivityScheduleStartWeekending ) AS B
--		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityScheduleStartWeekending

--		UPDATE A SET PRInductionTurnedUp = CNT
--		FROM #SUMMARY A 
--		INNER JOIN (SELECT MCCountry,ActivityScheduleStartWeekending,COUNT(*) AS CNT 
--		FROM #InductionTU WHERE RecruitmentType = 'Personal Recruitment' GROUP BY MCCountry,ActivityScheduleStartWeekending ) AS B
--		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityScheduleStartWeekending

--		UPDATE A SET PRIDBadgeIssued = CNT
--		FROM #SUMMARY A 
--		INNER JOIN (SELECT MCCountry,WEdate,COUNT(*) AS CNT 
--		FROM #IDBadgeIssued WHERE RecruitmentType = 'Personal Recruitment' GROUP BY MCCountry,WEdate ) AS B
--		ON A.MCCountry = B.MCCountry AND A.WeDate = B.WEdate

--		UPDATE A SET PRFirstDateOnField = CNT
--		FROM #SUMMARY A 
--		INNER JOIN (SELECT MCCountry,WEdate,COUNT(*) AS CNT 
--		FROM #FirstdayOnfield WHERE RecruitmentType = 'Personal Recruitment' GROUP BY MCCountry,WEdate ) AS B
--		ON A.MCCountry = B.MCCountry AND A.WeDate = B.WEdate

--		UPDATE A SET PRTotalActiveHeadcount = CNT
--		FROM #SUMMARY A 
--		INNER JOIN (SELECT MCCountry,WEdate,COUNT(*) AS CNT 
--		FROM #ActiveHC WHERE RecruitmentType = 'Personal Recruitment' GROUP BY MCCountry,WEdate ) AS B
--		ON A.MCCountry = B.MCCountry AND A.WeDate = B.WEdate

--		UPDATE A SET ORTotalLeaders = CNT
--		FROM #SUMMARY A 
--		INNER JOIN (SELECT MCCountry,WEdate,COUNT(*) AS CNT 
--		FROM #ActiveHC WHERE RecruitmentType = 'Personal Recruitment' AND WESTage = 'Leader' GROUP BY MCCountry,WEdate ) AS B
--		ON A.MCCountry = B.MCCountry AND A.WeDate = B.WEdate

--		UPDATE A SET PRTotalLeaders = CNT
--		FROM #SUMMARY A 
--		INNER JOIN (SELECT MCCountry,WEdate,COUNT(*) AS CNT 
--		FROM #ActiveHC WHERE RecruitmentType = 'Personal Recruitment' AND WESTage = 'Leader' GROUP BY MCCountry,WEdate ) AS B
--		ON A.MCCountry = B.MCCountry AND A.WeDate = B.WEdate

		--SELECT * FROM #SUMMARY ORDER BY MCCountry ASC, WeDate ASC
-- ========================= Populate Summary (END) ============================================================================================

		DECLARE @HeaderDesc VARCHAR (1000)
		SET @HeaderDesc = 'ORFirstAppointmentBooked,PRFirstAppointmentBooked,ORFirstAppointmentTurnedUp,PRFirstAppointmentTurnedUp,ORObservationBooked,PRObservationBooked,ORObservationTurnedUp,PRObservationTurnedUp,ORInductionBooked,PRInductionBooked,ORInductionTurnedUp,PRInductionTurnedUp,ORIDBadgeIssued,PRIDBadgeIssued,ORFirstDateOnField,PRFirstDateOnField,ORLeadersPromoted,PRLeadersPromoted,ORTotalActiveHeadcount,PRTotalActiveHeadcount,ORTotalLeaders,PRTotalLeaders'
		
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
		INNER JOIN (SELECT MCCountry,ActivityScheduleStartWeekending,COUNT(*) AS CNT 
		FROM #FirstAppt WHERE RecruitmentType = 'Office Recruitment' GROUP BY MCCountry,ActivityScheduleStartWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityScheduleStartWeekending AND A.Description = 'ORFirstAppointmentBooked'

		UPDATE A SET Total = CNT
		FROM #SUMMARY2 A 
		INNER JOIN (SELECT MCCountry,ActivityScheduleStartWeekending,COUNT(*) AS CNT 
		FROM #FirstApptTurnedUp WHERE RecruitmentType = 'Office Recruitment' GROUP BY MCCountry,ActivityScheduleStartWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityScheduleStartWeekending AND A.Description = 'ORFirstAppointmentTurnedUp'

		UPDATE A SET Total = CNT
		FROM #SUMMARY2 A 
		INNER JOIN (SELECT MCCountry,ActivityScheduleStartWeekending,COUNT(*) AS CNT 
		FROM #FirstAppt WHERE RecruitmentType = 'Personal Recruitment' GROUP BY MCCountry,ActivityScheduleStartWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityScheduleStartWeekending AND A.Description = 'PRFirstAppointmentBooked'

		UPDATE A SET Total = CNT
		FROM #SUMMARY2 A 
		INNER JOIN (SELECT MCCountry,ActivityScheduleStartWeekending,COUNT(*) AS CNT 
		FROM #FirstApptTurnedUp WHERE RecruitmentType = 'Personal Recruitment' GROUP BY MCCountry,ActivityScheduleStartWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityScheduleStartWeekending AND A.Description = 'PRFirstAppointmentTurnedUp'
		-- FIRST APPOINTMENT----------------------------------------------------------------------------------------------------------																											
		-- OBSERVATION ---------------------------------------------------------------------------------------------------------------																											
		UPDATE A SET Total = CNT
		FROM #SUMMARY2 A 
		INNER JOIN (SELECT MCCountry,ActivityScheduleStartWeekending,COUNT(*) AS CNT 
		FROM #ObservationB WHERE RecruitmentType = 'Office Recruitment' GROUP BY MCCountry,ActivityScheduleStartWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityScheduleStartWeekending AND A.Description = 'ORObservationBooked'

		UPDATE A SET Total = CNT
		FROM #SUMMARY2 A 
		INNER JOIN (SELECT MCCountry,ActivityScheduleStartWeekending,COUNT(*) AS CNT 
		FROM #ObservationTU WHERE RecruitmentType = 'Office Recruitment' GROUP BY MCCountry,ActivityScheduleStartWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityScheduleStartWeekending AND A.Description = 'ORObservationTurnedUp'

		UPDATE A SET Total = CNT
		FROM #SUMMARY2 A 
		INNER JOIN (SELECT MCCountry,ActivityScheduleStartWeekending,COUNT(*) AS CNT
		FROM #ObservationB WHERE RecruitmentType = 'Personal Recruitment' GROUP BY MCCountry,ActivityScheduleStartWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityScheduleStartWeekending AND A.Description = 'PRObservationBooked'

		UPDATE A SET Total = CNT
		FROM #SUMMARY2 A 
		INNER JOIN (SELECT MCCountry,ActivityScheduleStartWeekending,COUNT(*) AS CNT 
		FROM #ObservationTU WHERE RecruitmentType = 'Personal Recruitment' GROUP BY MCCountry,ActivityScheduleStartWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityScheduleStartWeekending AND A.Description = 'PRObservationTurnedUp'
		-- OBSERVATION ---------------------------------------------------------------------------------------------------------------																											
		-- INDUCTION  ----------------------------------------------------------------------------------------------------------------																											
		UPDATE A SET Total = CNT
		FROM #SUMMARY2 A    
		INNER JOIN (SELECT MCCountry,ActivityScheduleStartWeekending,COUNT(*) AS CNT 
		FROM #InductionB WHERE RecruitmentType = 'Office Recruitment' GROUP BY MCCountry,ActivityScheduleStartWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityScheduleStartWeekending AND A.Description = 'ORInductionBooked'

		UPDATE A SET Total = CNT                                                 
		FROM #SUMMARY2 A 
		INNER JOIN (SELECT MCCountry,ActivityScheduleStartWeekending,COUNT(*) AS CNT 
		FROM #InductionTU WHERE RecruitmentType = 'Office Recruitment' GROUP BY MCCountry,ActivityScheduleStartWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityScheduleStartWeekending AND A.Description = 'ORInductionTurnedUp'

		UPDATE A SET Total = CNT
		FROM #SUMMARY2 A 
		INNER JOIN (SELECT MCCountry,ActivityScheduleStartWeekending,COUNT(*) AS CNT 
		FROM #InductionB WHERE RecruitmentType = 'Personal Recruitment' GROUP BY MCCountry,ActivityScheduleStartWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityScheduleStartWeekending AND A.Description = 'PRInductionBooked'

		UPDATE A SET Total = CNT 
		FROM #SUMMARY2 A 
		INNER JOIN (SELECT MCCountry,ActivityScheduleStartWeekending,COUNT(*) AS CNT 
		FROM #InductionTU WHERE RecruitmentType = 'Personal Recruitment' GROUP BY MCCountry,ActivityScheduleStartWeekending ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.ActivityScheduleStartWeekending AND A.Description = 'PRInductionTurnedUp'
		-- INDUCTION  ----------------------------------------------------------------------------------------------------------------			
		-- ID BADGE ISSUED  ----------------------------------------------------------------------------------------------------------																											
		UPDATE A SET Total = CNT
		FROM #SUMMARY2 A    
		INNER JOIN (SELECT MCCountry,WEdate,COUNT(*) AS CNT 
		FROM #IDBadgeIssued WHERE RecruitmentType = 'Office Recruitment' GROUP BY MCCountry,WEdate ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.WEdate AND A.Description = 'ORIDBadgeIssued' 

		UPDATE A SET Total = CNT 
		FROM #SUMMARY2 A 
		INNER JOIN (SELECT MCCountry,WEdate,COUNT(*) AS CNT 
		FROM #IDBadgeIssued WHERE RecruitmentType = 'Personal Recruitment' GROUP BY MCCountry,WEdate ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.WEdate AND A.Description = 'PRIDBadgeIssued'
		-- ID BADGE ISSUED  ----------------------------------------------------------------------------------------------------------		

		-- First Date On Field  ----------------------------------------------------------------------------------------------------------																											
		UPDATE A SET Total = CNT
		FROM #SUMMARY2 A    
		INNER JOIN (SELECT MCCountry,WEdate,COUNT(*) AS CNT 
		FROM #FirstdayOnfield WHERE RecruitmentType = 'Office Recruitment' GROUP BY MCCountry,WEdate ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.WEdate AND A.Description = 'ORFirstDateOnField' 

		UPDATE A SET Total = CNT 
		FROM #SUMMARY2 A 
		INNER JOIN (SELECT MCCountry,WEdate,COUNT(*) AS CNT 
		FROM #FirstdayOnfield WHERE RecruitmentType = 'Personal Recruitment' GROUP BY MCCountry,WEdate ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.WEdate AND A.Description = 'PRFirstDateOnField'
		-- First Date On Field  ----------------------------------------------------------------------------------------------------------		
		-- LEADER PROMOTED  ----------------------------------------------------------------------------------------------------------																											
		UPDATE A SET Total = CNT
		FROM #SUMMARY2 A    
		INNER JOIN (SELECT MCCountry,WEdate,COUNT(*) AS CNT 
		FROM #LeadersPromoted WHERE RecruitmentType = 'Office Recruitment' GROUP BY MCCountry,WEdate ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.WEdate AND A.Description = 'ORLeadersPromoted' 

		UPDATE A SET Total = CNT 
		FROM #SUMMARY2 A 
		INNER JOIN (SELECT MCCountry,WEdate,COUNT(*) AS CNT 
		FROM #LeadersPromoted WHERE RecruitmentType = 'Personal Recruitment' GROUP BY MCCountry,WEdate ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.WEdate AND A.Description = 'PRLeadersPromoted'
		-- LEADER PROMOTED  ----------------------------------------------------------------------------------------------------------	
		-- ACTIVE HEADCOUNT  ----------------------------------------------------------------------------------------------------------				
																						
		UPDATE A SET Total = CNT
		FROM #SUMMARY2 A    
		INNER JOIN (SELECT MCCountry,WEdate,sum(total) AS CNT 
		FROM #ActiveHC WHERE RecruitmentType = 'Office Recruitment'  GROUP BY MCCountry,WEdate ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.WEdate AND A.Description = 'ORTotalActiveHeadcount' 

		UPDATE A SET Total = CNT 
		FROM #SUMMARY2 A 
		INNER JOIN (SELECT MCCountry,WEdate,sum(total) AS CNT 
		FROM #ActiveHC WHERE RecruitmentType = 'Personal Recruitment'  GROUP BY MCCountry,WEdate ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.WEdate AND A.Description = 'PRTotalActiveHeadcount'
		-- ACTIVE HEADCOUNT  ----------------------------------------------------------------------------------------------------------			
		-- ACTIVE LEADER HEADCOUNT  ---------------------------------------------------------------------------------------------------																						
		UPDATE A SET Total = CNT
		FROM #SUMMARY2 A    
		INNER JOIN (SELECT MCCountry,WEdate,sum(total) AS CNT 
		FROM #ActiveHC WHERE RecruitmentType = 'Office Recruitment' AND WESTage = 'Leader'  GROUP BY MCCountry,WEdate ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.WEdate AND A.Description = 'ORTotalLeaders' 

		UPDATE A SET Total = CNT 
		FROM #SUMMARY2 A 
		INNER JOIN (SELECT MCCountry,WEdate,sum(total) AS CNT 
		FROM #ActiveHC WHERE RecruitmentType = 'Personal Recruitment' AND WESTage = 'Leader'  GROUP BY MCCountry,WEdate ) AS B
		ON A.MCCountry = B.MCCountry AND A.WeDate = B.WEdate AND A.Description = 'PRTotalLeaders'
		-- ACTIVE LEADER HEADCOUNT  ---------------------------------------------------------------------------------------------------																						
																												
		SELECT * FROM #SUMMARY2 WHERE WeDate <= @Maxdate ORDER BY Description ASC,MCCountry ASC, WeDate ASC

END



