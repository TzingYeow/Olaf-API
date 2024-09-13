-- =============================================
-- Author:		Tan Siuk Ching
-- Create date: 2021-03-05
-- Description:	IC Suspended Update
-- =============================================
 
CREATE PROCEDURE [dbo].[SP_ICSuspendedUpdate]  
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;	

	-- SUSPEND PRESET IC
	IF OBJECT_ID('tempdb..#ICSTARTSUSPEND') IS NOT NULL DROP TABLE #ICSTARTSUSPEND
	SELECT DISTINCT A.IndependentContractorId, A.IndependentContractorLevelId INTO #ICSTARTSUSPEND 
	FROM Mst_IndependentContractor_Suspension A 
	INNER JOIN Mst_IndependentContractor B
	INNER JOIN Mst_MarketingCompany m ON m.MarketingCompanyId = B.MarketingCompanyId
	ON A.IndependentContractorId = B.IndependentContractorId 
	WHERE A.StartDate = CONVERT(DATE, GETDATE()) AND B.IsSuspended = 0 AND A.IsDeleted = 0 AND B.Status = 'Active'
	AND M.CountryCode NOT IN ('SG')

	UPDATE Mst_IndependentContractor SET IsSuspended = 1, UpdatedBy = 'ICSuspendedUpdateA', UpdatedDate = GETDATE()
	FROM Mst_IndependentContractor d INNER JOIN #ICSTARTSUSPEND e on d.IndependentContractorId = e.IndependentContractorId
		
	IF (DATENAME(dw,GETDATE()) = 'Monday')
	BEGIN
		-- NO SALE WITHIN 3 WE AFTER SUSPENSION LIFT WITH APPROVAL
		IF OBJECT_ID('tempdb..#ICSUSPENDLIFTNOSALE') IS NOT NULL DROP TABLE #ICSUSPENDLIFTNOSALE
		SELECT * INTO #ICSUSPENDLIFTNOSALE
		FROM (
		SELECT s.IndependentContractorSuspensionId, i.IndependentContractorId, i.IndependentContractorLevelId
		FROM Mst_IndependentContractor_Suspension s INNER JOIN Mst_IndependentContractor i ON s.IndependentContractorId = i.IndependentContractorId 
		INNER JOIN Mst_MarketingCompany m ON m.MarketingCompanyId = i.MarketingCompanyId 
		WHERE M.CountryCode NOT IN ('PH','MY','TW','SG') AND s.IsDeleted = 0 AND i.IsSuspended = 0 AND IsReactivate = 1 AND s.Description = 'No new sale in 3 week-endings' 
		AND EndDate <= FORMAT(DATEADD(DAY,-21, GETDATE()), 'yyyy-MM-dd') AND ISNULL(i.LastSalesSubmissionDate, '2021-03-26') < EndDate AND i.Status = 'Active' 
		UNION
		SELECT s.IndependentContractorSuspensionId, i.IndependentContractorId, i.IndependentContractorLevelId			-- refer Ticket#2021072313000131 add 84 days for TW, 
		FROM Mst_IndependentContractor_Suspension s INNER JOIN Mst_IndependentContractor i ON s.IndependentContractorId = i.IndependentContractorId 
		INNER JOIN Mst_MarketingCompany m ON m.MarketingCompanyId = i.MarketingCompanyId and m.CountryCode in ('TW')
		WHERE s.IsDeleted = 0 AND i.IsSuspended = 0 AND IsReactivate = 1 AND s.Description = 'No new sale in 3 week-endings' 
		AND EndDate <= FORMAT(DATEADD(DAY,-21, GETDATE()), 'yyyy-MM-dd') AND ISNULL(DATEADD(DAY,84, i.LastSalesSubmissionDate), '2021-03-26') < EndDate AND i.Status = 'Active' 
		UNION
		SELECT s.IndependentContractorSuspensionId, i.IndependentContractorId, i.IndependentContractorLevelId			-- refer Ticket#2021062813000025 add 91 days for MY
		FROM Mst_IndependentContractor_Suspension s INNER JOIN Mst_IndependentContractor i ON s.IndependentContractorId = i.IndependentContractorId 
		INNER JOIN Mst_MarketingCompany m ON m.MarketingCompanyId = i.MarketingCompanyId and m.CountryCode in ('MY')
		WHERE s.IsDeleted = 0 AND i.IsSuspended = 0 AND IsReactivate = 1 AND s.Description = 'No new sale in 3 week-endings' 
		AND EndDate <= FORMAT(DATEADD(DAY,-21, GETDATE()), 'yyyy-MM-dd') AND ISNULL(DATEADD(DAY,91, i.LastSalesSubmissionDate), '2021-03-26') < EndDate AND i.Status = 'Active' 
		) l
		WHERE L.IndependentContractorSuspensionId = (SELECT TOP 1 IndependentContractorSuspensionId FROM Mst_IndependentContractor_Suspension WHERE IndependentContractorId = L.IndependentContractorId AND IsDeleted = 0 ORDER BY IndependentContractorSuspensionId DESC)


		-- IC INACTIVE BUT REACTIVATE AGAIN STILL NO SALES FOR 3WE
		IF OBJECT_ID('tempdb..#ICREACTIVATENOSALE') IS NOT NULL DROP TABLE #ICREACTIVATENOSALE
		SELECT * INTO #ICREACTIVATENOSALE  
		FROM  (
		SELECT IndependentContractorId, IndependentContractorLevelId  FROM #ICSUSPENDLIFTNOSALE ns 
		UNION
		SELECT i.IndependentContractorId, i.IndependentContractorLevelId 
		FROM Mst_IndependentContractor_Suspension s INNER JOIN Mst_IndependentContractor i ON s.IndependentContractorId = i.IndependentContractorId 
		INNER JOIN Mst_MarketingCompany O ON O.MarketingCompanyId = i.MarketingCompanyId
		LEFT JOIN Mst_IndependentContractor_Movement m ON i.IndependentContractorId = m.IndependentContractorId and m.Description = 'Re-activate'
		WHERE s.IsDeleted = 0 AND i.IsSuspended = 0 AND IsReactivate = 0 AND s.Description = 'No new sale in 3 week-endings' 
		AND EndDate <= FORMAT(DATEADD(DAY,-21, GETDATE()), 'yyyy-MM-dd') AND i.Status = 'Active' AND (ISNULL(i.LastSalesSubmissionDate, '2021-03-26') < EndDate 
		AND m.IndependentContractorMovementId is null AND O.CountryCode NOT IN ('SG')
		--OR i.LastSalesSubmissionDate NOT BETWEEN m.EffectiveDate AND DATEADD(DAY, (DATEDIFF(DAY, 3, m.EffectiveDate) / 7) * 7 + 21, 3) -- Take out due to Ticket#2021121313000014 wrong logic
		AND DATEADD(DAY, (DATEDIFF(DAY, 3, m.EffectiveDate) / 7) * 7 + 21, 3) < GETDATE())) s

		INSERT Mst_IndependentContractor_Movement (IndependentContractorId, IndependentContractorLevelId, Description, EffectiveDate, LeavingReasonCategory, LeavingReasonDescription, HasExecuted, IsDeleted, CreatedBy, CreatedDate)
		SELECT IndependentContractorId, IndependentContractorLevelId, 'Deactivate', 
		--DATEADD(dd, 1, DATEDIFF(dd, 0, GETDATE())), -- Fixed issue Deactivation date takes next day : Ticket#2021111013000067
		DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())),
		'No sales after reactivation of no new sale in 3 week-endings suspension', 'Suspension', 0, 0, 'Admin', GETDATE() 
		FROM #ICREACTIVATENOSALE

		---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		-- Suspend BA IF NO SALES FOR 3WE
		DECLARE @COUNTDATE DATE;
		DECLARE @COUNTNEXTWEEKDATE DATE;
		SET @COUNTDATE = DATEADD(DAY, -6, DATEADD(wk, DATEDIFF(wk,13,GETDATE()), -1)); -- Updated on 2022-03-04
		SET @COUNTNEXTWEEKDATE = DATEADD(DAY, -6, DATEADD(wk, DATEDIFF(wk,13,GETDATE()), -8)); -- Updated on 2022-03-04


		IF OBJECT_ID('tempdb..#ICRAWDATA') IS NOT NULL DROP TABLE #ICRAWDATA
		SELECT d.* INTO #ICRAWDATA 	
		FROM (
		SELECT B.CountryCode,B.Code MCCode,a.*, m.IndependentContractorMovementId, m.EffectiveDate FROM
		Mst_IndependentContractor a 
		INNER JOIN Mst_MarketingCompany b on b.MarketingCompanyId = a.MarketingCompanyId
		LEFT JOIN Mst_IndependentContractor_Movement m ON a.IndependentContractorId = m.IndependentContractorId and m.Description = 'Re-activate' and m.EffectiveDate > '2021-03-25 00:00:00.000'
		WHERE b.MarketingCompanyType ='STANDARD' AND BAType IN ('9999','6') 
		AND a.IsDeleted = 0 and b.IsActive = 1  and b.IsDeleted = 0 
		and Status = 'Active' and a.IsSuspended = 0 and a.IndependentContractorLevelId NOT IN (1,2,5,6,9) 
		and ISNULL(LastSalesSubmissionDate, '2021-03-25 00:00:00.000') < @COUNTDATE
		AND B.CountryCode not in ('ID', 'KR', 'HK', 'PH','SG')  and StartDate < @COUNTDATE 
		UNION
		SELECT B.CountryCode,B.Code MCCode,a.*, m.IndependentContractorMovementId, m.EffectiveDate FROM
		Mst_IndependentContractor a 
		INNER JOIN Mst_MarketingCompany b on b.MarketingCompanyId = a.MarketingCompanyId
		LEFT JOIN Mst_IndependentContractor_Movement m ON a.IndependentContractorId = m.IndependentContractorId and m.Description = 'Re-activate' and m.EffectiveDate > '2021-05-06 00:00:00.000' 
		WHERE b.MarketingCompanyType ='STANDARD' AND BAType IN ('9999','6') 
		AND a.IsDeleted = 0 and b.IsActive = 1  and b.IsDeleted = 0 
		and Status = 'Active' and a.IsSuspended = 0 and a.IndependentContractorLevelId NOT IN (1,2,5,6,9) 
		and ISNULL(LastSalesSubmissionDate, '2021-05-06 00:00:00.000') < @COUNTNEXTWEEKDATE
		AND B.CountryCode in ('KR', 'HK')  and StartDate < @COUNTNEXTWEEKDATE ) d

		IF OBJECT_ID('tempdb..#ICSTARTDATE') IS NOT NULL DROP TABLE #ICSTARTDATE	 -- SET START DATE AS 26TH MAR AS FIRST DAY 
		SELECT * INTO #ICSTARTDATE FROM ( 
		SELECT a.*, 
		CASE -- Updated on 2022-03-04
		WHEN ISNULL(A.EffectiveDate, ISNULL(A.LastSalesSubmissionDate, '2021-03-25 00:00:00.000')) < '2021-03-25 00:00:00.000' THEN '2021-03-25 00:00:00.000' 
		WHEN A.EffectiveDate IS NOT NULL AND A.EffectiveDate > ISNULL(A.LastSalesSubmissionDate, '2021-03-25 00:00:00.000') THEN A.EffectiveDate
		ELSE  ISNULL(A.LastSalesSubmissionDate, '2021-03-25 00:00:00.000') 
		END CORRECTEDLASTDATE
		FROM #ICRAWDATA A INNER JOIN Mst_MarketingCompany M ON A.MarketingCompanyId = M.MarketingCompanyId
		WHERE M.CountryCode not in ('SG', 'MY', 'TW')
		UNION
		SELECT a.*, CASE WHEN ISNULL(A.LastSalesSubmissionDate, '2021-09-30 00:00:00.000') < '2021-09-30 00:00:00.000'			-- refer to Ticket#2021091413000073
		THEN '2021-09-30 00:00:00.000' ELSE ISNULL(A.LastSalesSubmissionDate, '2021-09-30 00:00:00.000') END CORRECTEDLASTDATE
		FROM #ICRAWDATA A INNER JOIN Mst_MarketingCompany M ON A.MarketingCompanyId = M.MarketingCompanyId
		WHERE M.CountryCode = 'MY'
		UNION
		SELECT a.*, CASE WHEN ISNULL(A.LastSalesSubmissionDate, '2021-08-05 00:00:00.000') < '2021-08-05 00:00:00.000' 
		THEN '2021-08-05 00:00:00.000' ELSE ISNULL(A.LastSalesSubmissionDate, '2021-08-05 00:00:00.000') END CORRECTEDLASTDATE
		FROM #ICRAWDATA A INNER JOIN Mst_MarketingCompany M ON A.MarketingCompanyId = M.MarketingCompanyId
		WHERE M.CountryCode = 'TW') c

		-- To fix issues raise in Ticket#2021110213000108
		-- Issue : Greyscale BA suspended eventhough did not reach 6WE counts. Happen because BA has LastSalesSubmissionDate = NULL
		-- To add suspension logic check from these three dates (DateFirstOnField/startdate,LastSalesSubmissionDate,campaign assignment startdate), take max date 

		UPDATE #ICSTARTDATE SET CORRECTEDLASTDATE = CASE WHEN ISNULL(DateFirstOnField,StartDate) > CORRECTEDLASTDATE THEN ISNULL(DateFirstOnField,StartDate) ELSE CORRECTEDLASTDATE END

		UPDATE A SET A.CORRECTEDLASTDATE = CASE WHEN B.CampaignStartDate > CORRECTEDLASTDATE THEN B.CampaignStartDate ELSE CORRECTEDLASTDATE END
		FROM #ICSTARTDATE A INNER JOIN 
		(
		SELECT IndependentContractorId, MAX(StartDate) CampaignStartDate FROM Mst_IndependentContractor_Assignment 
		WHERE IsDeleted = 0  
		AND CAST(getdate() as date) > = CAST(StartDate as date)
		AND (CAST(getdate() as date) < = CAST(EndDate as date) OR EndDate IS NULL)
		GROUP BY IndependentContractorId 
		) B ON A.IndependentContractorId = B.IndependentContractorId 

		-- Ticket#2021121413000227 new addition logic : If got reactivate movement (take Reactivate-Effectivedate if latest than curent CORRECTEDLASTDATE) 
		UPDATE A SET A.CORRECTEDLASTDATE = CASE WHEN B.Reactivate_EffectiveDate > CORRECTEDLASTDATE THEN B.Reactivate_EffectiveDate ELSE CORRECTEDLASTDATE END
		FROM #ICSTARTDATE A INNER JOIN 
		(
		SELECT IndependentContractorId, MAX(EffectiveDate) Reactivate_EffectiveDate FROM Mst_IndependentContractor_Movement 
		WHERE IsDeleted = 0 and Description IN ( 'Re-activate','Reactivate' ) -- Ticket#2022041113000157 
		GROUP BY IndependentContractorId 
		) B ON A.IndependentContractorId = B.IndependentContractorId 

		-- CHECK LastSalesSubmissionDate AND Latest EndDate
		IF OBJECT_ID('tempdb..#ICLATESTSALES') IS NOT NULL DROP TABLE #ICLATESTSALES
		SELECT a.*, CASE WHEN ISNULL(B.ENDDATE, '2020-12-31') > A.CORRECTEDLASTDATE THEN ISNULL(B.ENDDATE, A.CORRECTEDLASTDATE) ELSE A.CORRECTEDLASTDATE END LastSalesDate
		INTO #ICLATESTSALES 
		FROM #ICSTARTDATE A LEFT JOIN
		(SELECT IndependentContractorId, MAX(EndDate) EndDate FROM Mst_IndependentContractor_Suspension WHERE IsDeleted = 0 AND IsReactivate = 1
		GROUP BY IndependentContractorId) B ON A.IndependentContractorId = B.IndependentContractorId
	
		-- SG BA involve in Grey Scale campaign can have 6 WE no sales
		DECLARE @COUNT6WEDATE DATE;
		SET @COUNT6WEDATE = DATEADD(DAY, -13, DATEADD(wk, DATEDIFF(wk, 27, GETDATE()), 3));

		IF OBJECT_ID('tempdb..#SGGSCAMP6WEEXCLUDE') IS NOT NULL DROP TABLE #SGGSCAMP6WEEXCLUDE
		SELECT a.IndependentContractorId INTO #SGGSCAMP6WEEXCLUDE
		FROM Mst_IndependentContractor_Assignment a INNER JOIN #ICLATESTSALES d ON a.IndependentContractorId = d.IndependentContractorId 
		WHERE CampaignId IN ( '1188', '1125') AND a.IsDeleted = 0
		AND CAST(getdate() as date) > = CAST(a.StartDate as date)
		AND (CAST(getdate() as date) < = CAST(a.EndDate as date) OR a.EndDate IS NULL)
		AND a.IndependentContractorId IN ( select IndependentContractorId from #ICLATESTSALES) 
		and d.LastSalesDate >= @COUNT6WEDATE
		
		UPDATE d SET d.LastSalesSubmissionDate = '2021-08-19'	-- refer to Ticket#2021072713000114
		FROM Mst_IndependentContractor_Assignment a INNER JOIN #ICLATESTSALES d ON a.IndependentContractorId = d.IndependentContractorId 
		WHERE CampaignId = 1106 AND a.IndependentContractorId IN ( select IndependentContractorId from #ICLATESTSALES) 

		-- Exclusion admin and PIC
		IF OBJECT_ID('tempdb..#ExList') IS NOT NULL DROP TABLE #ExList
		SELECT * INTO #ExList 
		FROM Courses_Users_Exclusion WHERE ExType = 'NS'

		-- Exclusion MO ID
		IF OBJECT_ID('tempdb..#MOExList') IS NOT NULL DROP TABLE #MOExList
		SELECT * INTO #MOExList 
		FROM Courses_Users_Exclusion WHERE ExType = 'MONS'

		IF OBJECT_ID('tempdb..#ICSUSPENDEXCLUDEDATA') IS NOT NULL DROP TABLE #ICSUSPENDEXCLUDEDATA
		SELECT h.* INTO #ICSUSPENDEXCLUDEDATA 
		FROM (
		SELECT i.*
		FROM #ICLATESTSALES i INNER JOIN Mst_MarketingCompany m ON i.MarketingCompanyId = m.MarketingCompanyId 
		WHERE m.CountryCode NOT IN ('KR','HK','SG') 
		AND BadgeNo NOT IN (SELECT BadgeNo FROM #ExList) -- EXCLUSION FOR BA LEVEL
		AND i.MarketingCompanyId NOT IN (SELECT MCID FROM #MOExList) -- ADD EXCLUSION FOR MO LEVEL Ticket#2021112413000041
		AND LastSalesDate <	@COUNTDATE AND i.IndependentContractorId NOT IN (SELECT * FROM #SGGSCAMP6WEEXCLUDE)
		UNION 
		SELECT i.*
		FROM #ICLATESTSALES i INNER JOIN Mst_MarketingCompany m ON i.MarketingCompanyId = m.MarketingCompanyId 
		WHERE m.CountryCode  IN ('KR','HK') 
		AND BadgeNo NOT IN (SELECT BadgeNo FROM #ExList) -- EXCLUSION FOR BA LEVEL 
		AND i.MarketingCompanyId NOT IN (SELECT MCID FROM #MOExList) -- ADD EXCLUSION FOR MO LEVEL Ticket#2021112413000041
		AND i.BAType NOT IN ('1') -- 2022-08-19 ADD EXCLUSION FOR KR TO EXCLUDE HOURLY RATE BA
		AND LastSalesDate <	@COUNTNEXTWEEKDATE ) h	

		--Start Ticket#2021111013000067 --------------------------------------------------------------------------------------------------------------------------------------------------
		--To fix issue second suspension within 180days/6months from first suspension

			-- Find BA that has go thru suspension because of 21days no sale within 180days/6months from current date
			IF OBJECT_ID('tempdb..#Suspension21Daywithin180Day') IS NOT NULL DROP TABLE #Suspension21Daywithin180Day
			SELECT IndependentContractorId, MAX(StartDate)StartDate INTO #Suspension21Daywithin180Day 
			FROM Mst_IndependentContractor_Suspension 
			where StartDate >= DATEADD(day, -180, CAST(GETDATE() as date)) 
			AND EndDate <= CAST(GETDATE() as date)
			and IsDeleted = 0 and Description = 'No new sale in 3 week-endings'
			GROUP BY IndependentContractorId

			-- Find BA that has suspension history before Reactivation to be excluded from Deactivation 
			-- Ticket#2021121413000227 : To ignore any suspension of no sales for 3WE history before reactivation (Treat as new BA)
			IF OBJECT_ID('tempdb..#ExcludeReactivatedBA') IS NOT NULL DROP TABLE #ExcludeReactivatedBA
			SELECT A.* INTO #ExcludeReactivatedBA FROM  #Suspension21Daywithin180Day A 
			INNER JOIN  Mst_IndependentContractor_Movement B ON A.IndependentContractorId = B.IndependentContractorId
			WHERE Description IN ( 'Re-activate','Reactivate' )  --Ticket#2022041113000157 
			AND IsDeleted = 0
			AND StartDate <= EffectiveDate

			-- Suspend if no sales in 21 days and no previous suspension in 180days/6monthsh
			INSERT Mst_IndependentContractor_Suspension (IndependentContractorId,Description,IndependentContractorLevelId, StartDate, EndDate, IsReactivate, IsDeleted,CreatedBy, CreatedDate)
			SELECT c.IndependentContractorId, 'No new sale in 3 week-endings', c.IndependentContractorLevelId, GETDATE(), CONVERT(DATE, DATEADD(DAY,90,GETDATE())), 0, 0, 'Admin', GETDATE()
			FROM #ICSUSPENDEXCLUDEDATA c where C.IndependentContractorId NOT IN (SELECT IndependentContractorId from #Suspension21Daywithin180Day)

			--Archived Suspension Details
			INSERT INTO [dbo].[Mst_SuspensionArchived]
           ([Type] ,[SuspensionRunDate] ,[CountryCode] ,[MCCode] ,[BadgeNo] ,[LastSalesDate] ,[LastSalesSubmissionDate] ,[CORRECTEDLASTDATE]
           ,[IndependentContractorId] ,[Description] ,[IndependentContractorLevelId] ,[StartDate] ,[EndDate]
           ,[IsReactivate] ,[IsDeleted] ,[CreatedBy] ,[CreatedDate])
			SELECT 'Suspension',GETDATE(),CountryCode,MCCode,BadgeNo,LastSalesDate,LastSalesSubmissionDate,CORRECTEDLASTDATE
			,IndependentContractorId,'No new sale in 3 week-endings',IndependentContractorLevelId,GETDATE(), CONVERT(DATE, DATEADD(DAY,90,GETDATE()))
			,0,0,'SuspensionRun',GETDATE() 
			FROM #ICSUSPENDEXCLUDEDATA c where C.IndependentContractorId NOT IN (SELECT IndependentContractorId from #Suspension21Daywithin180Day)
			ORDER BY CountryCode, MCCode, BadgeNo ASC

			DROP TABLE IF EXISTS #SLIST
			SELECT A.IndependentContractorId INTO #SLIST FROM Mst_IndependentContractor_Suspension A INNER JOIN #ICSUSPENDEXCLUDEDATA B ON A.IndependentContractorId = B.IndependentContractorId AND CAST(A.CreatedDate AS DATE) = CAST(GETDATE() AS DATE)

			UPDATE d SET IsSuspended = 1, UpdatedBy = 'ICSuspendedUpdateB', UpdatedDate = GETDATE()
			FROM Mst_IndependentContractor d INNER JOIN #ICSUSPENDEXCLUDEDATA e on d.IndependentContractorId = e.IndependentContractorId 
			WHERE d.IndependentContractorId NOT IN (SELECT IndependentContractorId from #Suspension21Daywithin180Day)
			AND D.IndependentContractorId IN (SELECT IndependentContractorId FROM #SLIST) -- ADDED ON 2023-07-25 Ticket#2023071813000011 - TO MAKE SURE ONLY BA WITH SUSPENSION HISTORY GOT SUSPENDED

			--Deactivate if no sales in 21 days and already has previous suspension within 180days/6months
			INSERT Mst_IndependentContractor_Movement (IndependentContractorId, IndependentContractorLevelId, Description, EffectiveDate, LeavingReasonCategory, LeavingReasonDescription, HasExecuted, IsDeleted, CreatedBy, CreatedDate)
			SELECT IndependentContractorId, IndependentContractorLevelId, 'Deactivate', 
			DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())),
			'No sales after reactivation of no new sale in 3 week-endings suspension within 6 Months', 'Suspension', 0, 0, 'Admin', GETDATE() 
			FROM #ICSUSPENDEXCLUDEDATA c 
			WHERE C.IndependentContractorId IN (SELECT IndependentContractorId from #Suspension21Daywithin180Day)
			AND C.IndependentContractorId NOT IN (SELECT IndependentContractorId from #ExcludeReactivatedBA) -- Ticket#2021121413000227 : To ignore any suspension of no sales for 3WE history before reactivation (Treat as new BA)
	
			--Archived Deactivation Details
			INSERT INTO [dbo].[Mst_SuspensionArchived]
			([Type] ,[SuspensionRunDate] ,[CountryCode] ,[MCCode] ,[BadgeNo] ,[LastSalesDate] ,[LastSalesSubmissionDate] ,[CORRECTEDLASTDATE]
			,[IndependentContractorId] ,[Description] , [LeavingReasonCategory], [LeavingReasonDescription], [IndependentContractorLevelId] ,[EffectiveDate]
			,[IsDeleted] ,[CreatedBy] ,[CreatedDate])
			SELECT 'Deactivation',GETDATE() ,CountryCode,MCCode,BadgeNo,LastSalesDate,LastSalesSubmissionDate,CORRECTEDLASTDATE
			,IndependentContractorId,'Deactivate','No sales after reactivation of no new sale in 3 week-endings suspension within 6 Months','Suspension',IndependentContractorLevelId,DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))
			,0,'SuspensionRun',GETDATE() 			
			FROM #ICSUSPENDEXCLUDEDATA c 
			WHERE C.IndependentContractorId IN (SELECT IndependentContractorId from #Suspension21Daywithin180Day)
			AND C.IndependentContractorId NOT IN (SELECT IndependentContractorId from #ExcludeReactivatedBA)
			ORDER BY CountryCode, MCCode, BadgeNo ASC

			---- 21 DAYS NO SALES
			--INSERT Mst_IndependentContractor_Suspension (IndependentContractorId,Description,IndependentContractorLevelId, StartDate, EndDate, IsReactivate, IsDeleted,CreatedBy, CreatedDate)
			--SELECT c.IndependentContractorId, 'No new sale in 3 week-endings', c.IndependentContractorLevelId, GETDATE(), CONVERT(DATE, DATEADD(DAY,90,GETDATE())), 0, 0, 'Admin', GETDATE()
			--FROM #ICSUSPENDEXCLUDEDATA c 
    
			--UPDATE d SET IsSuspended = 1, UpdatedBy = 'Admin', UpdatedDate = GETDATE()
			--FROM Mst_IndependentContractor d INNER JOIN #ICSUSPENDEXCLUDEDATA e on d.IndependentContractorId = e.IndependentContractorId
		--End Ticket#2021111013000067 --------------------------------------------------------------------------------------------------------------------------------------------------
		
	END
	
	-- INACTVE IC
	IF OBJECT_ID('tempdb..#ICINACTIVE') IS NOT NULL DROP TABLE #ICINACTIVE
	SELECT DISTINCT A.IndependentContractorId, A.IndependentContractorLevelId, A.Description INTO #ICINACTIVE 
	FROM Mst_IndependentContractor_Suspension A 
	INNER JOIN Mst_IndependentContractor B	ON A.IndependentContractorId = B.IndependentContractorId 
	INNER JOIN Mst_MarketingCompany m ON m.MarketingCompanyId = B.MarketingCompanyId
	WHERE A.EndDate = CONVERT(DATE, DATEADD(DAY, -1, GETDATE())) 
	AND B.IsSuspended = 1 AND B.Status = 'Active' AND A.IsReactivate = 0 
	AND A.IsDeleted = 0 AND M.CountryCode NOT IN ('SG')

	-- *UPDATE Mst_IndependentContractor SET Status = 'Inactive', UpdatedBy = 'Admin', UpdatedDate = GETDATE()
	-- *FROM Mst_IndependentContractor d INNER JOIN #ICINACTIVE e on d.IndependentContractorId = e.IndependentContractorId
	
	---******

	INSERT Mst_IndependentContractor_Movement (IndependentContractorId, IndependentContractorLevelId, Description, EffectiveDate, LeavingReasonCategory, LeavingReasonDescription, HasExecuted, IsDeleted, CreatedBy, CreatedDate)
	SELECT IndependentContractorId, IndependentContractorLevelId, 'Deactivate', DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())), 'Auto reactivate was not selecting upon manual suspension', 'Suspension', 0, 0, 'Admin', GETDATE() 
	FROM #ICINACTIVE WHERE Description not in ('Non-completion of M-Learning','No new sale in 3 week-endings','No active campaign assigned')

	INSERT Mst_IndependentContractor_Movement (IndependentContractorId, IndependentContractorLevelId, Description, EffectiveDate, LeavingReasonCategory, LeavingReasonDescription, HasExecuted, IsDeleted, CreatedBy, CreatedDate)
	SELECT IndependentContractorId, IndependentContractorLevelId, 'Deactivate', DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())), Description + ' for 90 days', 'Suspension', 0, 0, 'Admin', GETDATE() 
	FROM #ICINACTIVE WHERE Description in ('Non-completion of M-Learning','No new sale in 3 week-endings','No active campaign assigned')
	---*****


	-- IC SUSPENSION LIFT
	IF OBJECT_ID('tempdb..#ICREACTIVATE') IS NOT NULL DROP TABLE #ICREACTIVATE
	SELECT DISTINCT A.IndependentContractorId, A.IndependentContractorLevelId INTO #ICREACTIVATE 
	FROM Mst_IndependentContractor_Suspension A 
	INNER JOIN Mst_IndependentContractor B ON A.IndependentContractorId = B.IndependentContractorId 
	INNER JOIN Mst_MarketingCompany m ON m.MarketingCompanyId = B.MarketingCompanyId
	WHERE A.EndDate = CONVERT(DATE, DATEADD(day, -1, GETDATE())) AND B.IsSuspended = 1 
	AND B.Status = 'Active' AND A.IsReactivate = 1 AND A.IsDeleted = 0 
	AND M.CountryCode NOT IN ('SG')
 
	UPDATE Mst_IndependentContractor SET IsSuspended = 0, UpdatedBy = 'ICSuspendedUpdate', UpdatedDate = GETDATE()
	FROM Mst_IndependentContractor d INNER JOIN #ICREACTIVATE e on d.IndependentContractorId = e.IndependentContractorId
	
	---- 84 DAYS INACTIVE REMINDER
	IF OBJECT_ID('tempdb..#ICINACTIVEREMINDER') IS NOT NULL DROP TABLE #ICINACTIVEREMINDER
	SELECT DISTINCT A.IndependentContractorId, A.IndependentContractorLevelId, b.MarketingCompanyId, CONCAT(BadgeNo, ': ', FirstName, MiddleName, LastName) Name INTO #ICINACTIVEREMINDER 
	FROM Mst_IndependentContractor_Suspension A INNER JOIN Mst_IndependentContractor B 	ON A.IndependentContractorId = B.IndependentContractorId 
	INNER JOIN Mst_MarketingCompany m ON m.MarketingCompanyId = B.MarketingCompanyId
	WHERE M.CountryCode NOT IN ('SG') AND
	A.Description = 'No new sale in 3 week-endings' AND 
	A.EndDate = CONVERT(DATE, DATEADD(day,6,GETDATE())) AND 
	B.IsSuspended = 1 AND B.Status = 'Active' AND A.IsDeleted = 0

	---- SUSPENDED, ON DAY 84 SEND EMAIL TO MCADMIN
	IF OBJECT_ID('tempdb..#ICINACTIVETOMCALL') IS NOT NULL DROP TABLE #ICINACTIVETOMCALL
	SELECT DISTINCT MarketingCompanyId,  STUFF((SELECT ';' + Convert(varchar ,ROW_NUMBER() OVER(ORDER BY MarketingCompanyId DESC)) + '. ' + c.Name
    FROM #ICINACTIVEREMINDER c WHERE (c.MarketingCompanyId = d.MarketingCompanyId ) FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'') as Badge,
	STUFF((SELECT ';' + u.Email FROM Mst_User u WHERE UserRoleId = 3 and u.MarketingCompanyId = d.MarketingCompanyId and u.IsActive = 1 and u.IsDeleted = 0
    FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'') as McAdmin INTO #ICINACTIVETOMCALL
	from #ICINACTIVEREMINDER d  

	IF OBJECT_ID('tempdb..#ICINACTIVETOMC') IS NOT NULL DROP TABLE #ICINACTIVETOMC
	SELECT s.MarketingCompanyId, s.Badge, concat(s.mcadmin,';',ms.Email) McAdmin INTO #ICINACTIVETOMC
	FROM #ICINACTIVETOMCALL s 
	INNER JOIN Mst_MarketingCompany m ON s.MarketingCompanyId = m.MarketingCompanyId 
	LEFT JOIN mst_marketingcompany_staff ms ON s.marketingcompanyid = ms.marketingcompanyid
	WHERE (s.McAdmin is not null or ms.Email is not null) AND m.IsDeleted = 0 AND ms.IsDeleted = 0
	
    Insert TXN_EmailQueue (TxnID, Description, Recipient, CC, BCC, Subject, Body, CreateDate, CreateBy)
	select CONCAT('ICInactive-', CONVERT(NVARCHAR(20),GETDATE(),20), '-', Cast(MarketingCompanyId as nvarchar)),
	CONCAT('McID-', Cast(MarketingCompanyId as nvarchar)), McAdmin, NULL, 'adilla.aziz@salesworks.asia;syafiqah.manah@salesworks.asia;leonard.yong@salesworks.asia', 'OLAF Deactivation List Reminder: No sales for 3 consecutive Weekending', 
	CONCAT('<span style="font-size:10pt;font-family:Helvetica">Hi,<br>Kindly take note that below ID badges status will be changed from suspended to  inactive on <b>', FORMAT (DATEADD(day,6,GETDATE()), 'dd-MM-yyyy') , '</b> because the IC has been on suspended status 
	due to No Sales for 3 consecutive weekendings for nearly 3 months.<br>Please contact your country PIC for further clarification.<br>Thanks. <br><br>' , REPLACE(Badge, ';', '<br>'), '</span>') , GETDATE(), 'Admin' 
	FROM #ICINACTIVETOMC WHERE McAdmin IS NOT NULL OPTION (QUERYTRACEON 460);
	---- SEND MCADMIN EMAIL END
	
	---- SUSPENDED, ON DAY 84 SEND EMAIL TO GM AND PC	
	IF OBJECT_ID('tempdb..#ICINACTIVETOGM') IS NOT NULL DROP TABLE #ICINACTIVETOGM
	SELECT DISTINCT m.CountryCode, STUFF((SELECT ';;' + N.Code + ';' + c.Badge
    FROM #ICINACTIVETOMC C INNER JOIN Mst_MarketingCompany N ON C.MarketingCompanyId = N.MarketingCompanyId
	WHERE (N.CountryCode = m.CountryCode ) FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'') as Badge,
	STUFF((SELECT ';' + u.Email FROM Mst_User u WHERE UserRoleId = 6 and M.CountryCode = U.CountryAccess and u.IsActive = 1 and u.IsDeleted = 0
    FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'') as PIC INTO #ICINACTIVETOGM
	from #ICINACTIVEREMINDER d INNER JOIN Mst_MarketingCompany M ON M.MarketingCompanyId = D.MarketingCompanyId
	
	Insert TXN_EmailQueue (TxnID, Description, Recipient, CC, BCC, Subject, Body, CreateDate, CreateBy)
	select CONCAT('ICInactive-', CONVERT(NVARCHAR(20),GETDATE(),20), '-', Cast(CountryCode as nvarchar)), 
	CONCAT('MC-', Cast(CountryCode as nvarchar)), PIC, NULL, 'adilla.aziz@salesworks.asia;syafiqah.manah@salesworks.asia;leonard.yong@salesworks.asia', 'OLAF Deactivation List Reminder: No sales for 3 consecutive Weekending', 
	CONCAT('<span style="font-size:10pt;font-family:Helvetica">Hi,<br>Kindly take note that below ID badges status will be changed from suspended to  inactive on <b>', FORMAT (DATEADD(day,6,GETDATE()), 'dd-MM-yyyy') , '</b> because the IC has been on suspended status 
	due to No Sales for 3 consecutive weekendings for nearly 3 months.<br>Please contact your country PIC for further clarification.<br>Thanks. <br>' ,  REPLACE(Badge, ';', '<br>'), '</span>') , GETDATE(), 'Admin' 
	FROM #ICINACTIVETOGM WHERE PIC IS NOT NULL	

END
