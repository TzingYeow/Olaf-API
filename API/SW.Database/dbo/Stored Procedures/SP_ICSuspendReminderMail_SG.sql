-- =============================================
-- Author:		Tan Siuk Ching
-- Create date: 05/03/2021
-- Description:	IC Suspend Reminder Email
-- SG NEXT WEEK REMINDER (SUSPENSION RUN WEDNESDAY NEXT WEEK)
-- =============================================
CREATE PROCEDURE [dbo].[SP_ICSuspendReminderMail_SG]  
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	 DECLARE @SUSPENSIONRUNDATE DATE;
		SET @SUSPENSIONRUNDATE = CAST(DATEADD(DAY, 7, GETDATE()) AS DATE) -- Nextweek Rundate : Wednesday

		DECLARE @COUNTDATE DATE;
		SET @COUNTDATE = DATEADD(DAY, -6, DATEADD(wk, DATEDIFF(wk,13,@SUSPENSIONRUNDATE), -1));

		IF OBJECT_ID('tempdb..#ICRAWDATA') IS NOT NULL DROP TABLE #ICRAWDATA
		SELECT d.* INTO #ICRAWDATA 	
		FROM (
		SELECT B.CountryCode,B.Code MCCode,a.*, m.IndependentContractorMovementId, m.EffectiveDate FROM Mst_IndependentContractor a 
		INNER JOIN Mst_MarketingCompany b on b.MarketingCompanyId = a.MarketingCompanyId
		LEFT JOIN Mst_IndependentContractor_Movement m ON a.IndependentContractorId = m.IndependentContractorId and m.Description = 'Re-activate' and m.EffectiveDate > '2021-03-25 00:00:00.000'
		WHERE b.MarketingCompanyType is null AND a.IsDeleted = 0 and b.IsActive = 1  and b.IsDeleted = 0 
		and Status = 'Active' and a.IsSuspended = 0 and a.IndependentContractorLevelId NOT IN (1,2,5,6,9) 
		and ISNULL(LastSalesSubmissionDate, '2021-03-25 00:00:00.000') < @COUNTDATE
		AND B.CountryCode in ('SG')  and StartDate < @COUNTDATE ) d
		WHERE D.BadgeNo NOT IN (SELECT BadgeNo FROM Mst_Suspension_TempTable WHERE Type = 'Suspension') -- to exclude badgeno that has already included in the 'NextDay Reminder'


		IF OBJECT_ID('tempdb..#ICSTARTDATE') IS NOT NULL DROP TABLE #ICSTARTDATE	 -- SET START DATE AS 26TH MAR AS FIRST DAY 
		SELECT * INTO #ICSTARTDATE FROM ( 
		SELECT a.*, CASE WHEN ISNULL(A.LastSalesSubmissionDate, '2021-07-22 00:00:00.000') < '2021-07-22 00:00:00.000' 
		THEN '2021-07-22 00:00:00.000' ELSE ISNULL(A.LastSalesSubmissionDate, '2021-07-22 00:00:00.000') END CORRECTEDLASTDATE
		FROM #ICRAWDATA A INNER JOIN Mst_MarketingCompany M ON A.MarketingCompanyId = M.MarketingCompanyId
		WHERE M.CountryCode = 'SG') c

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
		WHERE CampaignId IN ( '1188', '1125')  AND a.IsDeleted = 0
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
		WHERE m.CountryCode IN ('SG') 
		AND BadgeNo NOT IN (SELECT BadgeNo FROM #ExList) -- EXCLUSION FOR BA LEVEL
		AND i.MarketingCompanyId NOT IN (SELECT MCID FROM #MOExList) -- ADD EXCLUSION FOR MO LEVEL Ticket#2021112413000041
		AND LastSalesDate <	@COUNTDATE AND i.IndependentContractorId NOT IN (SELECT * FROM #SGGSCAMP6WEEXCLUDE)) h	

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
			IF OBJECT_ID('tempdb..#SuspensionList') IS NOT NULL DROP TABLE #SuspensionList
			SELECT c.* INTO #SuspensionList
			FROM #ICSUSPENDEXCLUDEDATA c where C.IndependentContractorId NOT IN (SELECT IndependentContractorId from #Suspension21Daywithin180Day)
			ORDER BY CountryCode, MCCode, BadgeNo ASC


 -- EMAIL REGION (START)===================================================================================================================================================================================================

	-- NO SALES 14 DAYS REMINDER EMAIL TO MCADMIN
	IF OBJECT_ID('tempdb..#ICSUSPENDDATAALL') IS NOT NULL DROP TABLE #ICSUSPENDDATAALL
	SELECT MarketingCompanyId,  STUFF((SELECT ';' + Convert(varchar ,ROW_NUMBER() OVER(ORDER BY MarketingCompanyId DESC)) + '. ' + c.BadgeNo + ': ' + CAST(CONCAT(FirstName, MiddleName, LastName) AS VARCHAR(MAX))
    FROM #SuspensionList c WHERE (d.MarketingCompanyId = c.MarketingCompanyId)	
	FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'') as Badge,
	STUFF((SELECT ';' + u.Email FROM Mst_User u WHERE UserRoleId = 3 and u.MarketingCompanyId = d.MarketingCompanyId and u.IsActive = 1 and u.IsDeleted = 0
	and u.Email not in ('123@salesworks.asia','123@saleswork.asia','123@gmail.com')
    FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'') as McAdmin INTO #ICSUSPENDDATAALL
	from #SuspensionList d 	
	group by d.marketingcompanyid 

	IF OBJECT_ID('tempdb..#ICSUSPENDDATA') IS NOT NULL DROP TABLE #ICSUSPENDDATA
	SELECT s.MarketingCompanyId, s.Badge, concat(s.mcadmin,';',ms.Email) McAdmin INTO #ICSUSPENDDATA
	FROM #ICSUSPENDDATAALL s
	INNER JOIN Mst_MarketingCompany m ON s.MarketingCompanyId = m.MarketingCompanyId
	LEFT JOIN (SELECT marketingcompanyid, STRING_AGG(Email,';') as Email FROM mst_marketingcompany_staff GROUP BY marketingcompanyid) ms ON s.marketingcompanyid = ms.marketingcompanyid
	WHERE (s.McAdmin is not null or ms.Email is not null)

    Insert TXN_EmailQueue (TxnID, Description, Recipient, BCC, Subject, Body, CreateDate, CreateBy)
	select CONCAT('ICSuspend-', CONVERT(NVARCHAR(20),@SUSPENSIONRUNDATE,20), '-', Cast(MarketingCompanyId as nvarchar)), 
	CONCAT('McID-', Cast(MarketingCompanyId as nvarchar)), McAdmin, 'adilla.aziz@salesworks.asia;syafiqah.manah@salesworks.asia;leonard.yong@salesworks.asia', 
	'OLAF Suspension List Reminder: No sales for 3 consecutive Weekending', 
	CONCAT('<span style="font-size:10pt;font-family:Helvetica">Hi,<br>Kindly take note that below ID badges will be suspended on <b>', 
	FORMAT (@SUSPENSIONRUNDATE, 'dd-MM-yyyy'), '</b> due to No Sales in 3 consecutive weekendings if they did not submit any new sales within the next 7 days.<br>Please contact your country PIC for further clarification.<br>Thanks.<br><br>', REPLACE(Badge, ';', '<br>'), '</span>') 
	, GETDATE(), 'Admin' 
	FROM #ICSUSPENDDATA WHERE McAdmin IS NOT NULL

	 --NO SALES 14 DAYS REMINDER EMAIL TO GM & COUNTRY PIC
	IF OBJECT_ID('tempdb..#ICSUSPENDTOGM') IS NOT NULL DROP TABLE #ICSUSPENDTOGM
	SELECT DISTINCT m.CountryCode, STUFF((SELECT ';;' + N.Code + ';' + c.Badge
    FROM #ICSUSPENDDATAALL C INNER JOIN Mst_MarketingCompany N ON C.MarketingCompanyId = N.MarketingCompanyId
	WHERE (N.CountryCode = m.CountryCode ) FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'') as Badge,
	STUFF((SELECT ';' + u.Email FROM Mst_User u WHERE UserRoleId = 6 and M.CountryCode = U.CountryAccess and u.IsActive = 1 and u.IsDeleted = 0
    FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'') as PIC INTO #ICSUSPENDTOGM
	from #ICSUSPENDDATAALL d INNER JOIN Mst_MarketingCompany M ON M.MarketingCompanyId = D.MarketingCompanyId

	Insert TXN_EmailQueue (TxnID, Description, Recipient, BCC, Subject, Body, CreateDate, CreateBy)
	select CONCAT('ICSuspend-GM-', CONVERT(NVARCHAR(20),@SUSPENSIONRUNDATE,20), '-', Cast(CountryCode as nvarchar)), 
	CONCAT('MC-', Cast(CountryCode as nvarchar)), PIC, 'adilla.aziz@salesworks.asia;syafiqah.manah@salesworks.asia;leonard.yong@salesworks.asia', 
	'OLAF Suspension List Reminder: No sales for 3 consecutive Weekending', 
	CONCAT('<span style="font-size:10pt;font-family:Helvetica">Hi,<br>Kindly take note that below ID badges will be suspended on <b>', 
	FORMAT(@SUSPENSIONRUNDATE, 'dd-MM-yyyy'),'</b> due to No Sales in 3 consecutive weekendings if they did not submit any new sales within the next 7 days.<br>Please contact your country PIC for further clarification.<br>Thanks.<br>', REPLACE(Badge, ';', '<br>'), '</span>') 
	, GETDATE(), 'Admin' 
	FROM #ICSUSPENDTOGM WHERE PIC IS NOT NULL

-- EMAIL REGION (END)===================================================================================================================================================================================================

END
 
