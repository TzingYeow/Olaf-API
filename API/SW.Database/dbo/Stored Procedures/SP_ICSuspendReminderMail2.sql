-- =============================================
-- Author:		Tan Siuk Ching
-- Create date: 05/03/2021
-- Description:	IC Suspend Reminder Email
-- =============================================
CREATE PROCEDURE [dbo].[SP_ICSuspendReminderMail2]  
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	 

		DECLARE @SUSPENSIONRUNDATE DATE;
		SET @SUSPENSIONRUNDATE = CAST(DATEADD(DAY, 7, '2022-03-07') AS DATE) -- RUNDATE IS MONDAY then get the next monday date
		--SET @SUSPENSIONRUNDATE = CAST(DATEADD(DAY, 7, GETDATE()) AS DATE) -- RUNDATE IS MONDAY then get the next monday date

		DECLARE @COUNTDATE DATE;
		DECLARE @COUNTNEXTWEEKDATE DATE;
		SET @COUNTDATE = DATEADD(DAY, -6, DATEADD(wk, DATEDIFF(wk,13,@SUSPENSIONRUNDATE), -1)); -- Updated on 2022-03-04
		SET @COUNTNEXTWEEKDATE = DATEADD(DAY, -6, DATEADD(wk, DATEDIFF(wk,13,@SUSPENSIONRUNDATE), -8)); -- Updated on 2022-03-04
    SELECT @COUNTDATE, @COUNTNEXTWEEKDATE
	-- GET 120 DAYS NO SALES
	IF OBJECT_ID('tempdb..#ICRAWDATA') IS NOT NULL DROP TABLE #ICRAWDATA
	SELECT d.* INTO #ICRAWDATA 	
	FROM (
	SELECT a.*, m.IndependentContractorMovementId, m.EffectiveDate FROM
	Mst_IndependentContractor a 
	INNER JOIN Mst_MarketingCompany b on b.MarketingCompanyId = a.MarketingCompanyId
	LEFT JOIN Mst_IndependentContractor_Movement m ON a.IndependentContractorId = m.IndependentContractorId and m.Description = 'Re-activate' and m.EffectiveDate > '2021-03-25 00:00:00.000'
	WHERE b.MarketingCompanyType is null AND a.IsDeleted = 0 and b.IsActive = 1  and b.IsDeleted = 0 
	and Status = 'Active' and a.IsSuspended = 0 and a.IndependentContractorLevelId NOT IN (1,2,5,6,9) 
	and ISNULL(LastSalesSubmissionDate, '2021-03-25 00:00:00.000') < @COUNTDATE
	AND B.CountryCode not in ('ID', 'KR', 'HK','PH')  and StartDate < @COUNTDATE 
	UNION
	SELECT a.*, m.IndependentContractorMovementId, m.EffectiveDate FROM
	Mst_IndependentContractor a 
	INNER JOIN Mst_MarketingCompany b on b.MarketingCompanyId = a.MarketingCompanyId
	LEFT JOIN Mst_IndependentContractor_Movement m ON a.IndependentContractorId = m.IndependentContractorId and m.Description = 'Re-activate' and m.EffectiveDate > '2021-05-06 00:00:00.000' 
	WHERE b.MarketingCompanyType is null AND a.IsDeleted = 0 and b.IsActive = 1  and b.IsDeleted = 0 
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
	--CASE WHEN ISNULL(A.EffectiveDate, ISNULL(A.LastSalesSubmissionDate, '2021-03-25 00:00:00.000')) < '2021-03-25 00:00:00.000' 
	--THEN '2021-03-25 00:00:00.000' 
	--ELSE ISNULL(A.EffectiveDate, ISNULL(A.LastSalesSubmissionDate, '2021-03-25 00:00:00.000')) END CORRECTEDLASTDATE
	FROM #ICRAWDATA A INNER JOIN Mst_MarketingCompany M ON A.MarketingCompanyId = M.MarketingCompanyId
	WHERE M.CountryCode not in ('SG', 'MY', 'TW')
	UNION
	SELECT a.*, CASE WHEN ISNULL(A.LastSalesSubmissionDate, '2021-07-22 00:00:00.000') < '2021-07-22 00:00:00.000' 
	THEN '2021-07-22 00:00:00.000' ELSE ISNULL(A.LastSalesSubmissionDate, '2021-07-22 00:00:00.000') END CORRECTEDLASTDATE
	FROM #ICRAWDATA A INNER JOIN Mst_MarketingCompany M ON A.MarketingCompanyId = M.MarketingCompanyId
	WHERE M.CountryCode = 'SG'
	UNION
	SELECT a.*, CASE WHEN ISNULL(A.LastSalesSubmissionDate, '2021-09-30 00:00:00.000') < '2021-09-30 00:00:00.000'		-- refer to Ticket#2021091413000073
	THEN '2021-09-30 00:00:00.000' ELSE ISNULL(A.LastSalesSubmissionDate, '2021-09-30 00:00:00.000') END CORRECTEDLASTDATE
	FROM #ICRAWDATA A INNER JOIN Mst_MarketingCompany M ON A.MarketingCompanyId = M.MarketingCompanyId
	WHERE M.CountryCode = 'MY'
	UNION
	SELECT a.*, CASE WHEN ISNULL(A.LastSalesSubmissionDate, '2021-08-05 00:00:00.000') < '2021-08-05 00:00:00.000' 
	THEN '2021-08-05 00:00:00.000' ELSE ISNULL(A.LastSalesSubmissionDate, '2021-08-05 00:00:00.000') END CORRECTEDLASTDATE
	FROM #ICRAWDATA A INNER JOIN Mst_MarketingCompany M ON A.MarketingCompanyId = M.MarketingCompanyId
	WHERE M.CountryCode = 'TW') c

	---- CHECK LastSalesSubmissionDate AND Latest EndDate
	IF OBJECT_ID('tempdb..#ICLATESTSALES') IS NOT NULL DROP TABLE #ICLATESTSALES
	SELECT a.*, CASE WHEN ISNULL(B.ENDDATE, '2020-12-31') > A.CORRECTEDLASTDATE THEN ISNULL(B.ENDDATE, A.CORRECTEDLASTDATE) ELSE A.CORRECTEDLASTDATE END LastSalesDate
	INTO #ICLATESTSALES 
	FROM #ICSTARTDATE A LEFT JOIN
	(SELECT IndependentContractorId, MAX(EndDate) EndDate FROM Mst_IndependentContractor_Suspension WHERE IsDeleted = 0 AND IsReactivate = 1
	GROUP BY IndependentContractorId) B ON A.IndependentContractorId = B.IndependentContractorId
	
	-- SG BA involve in Grey Scale campaign can have 6 WE no sales
	DECLARE @COUNT6WEDATE DATE;
	SET @COUNT6WEDATE = DATEADD(DAY, -13, DATEADD(wk, DATEDIFF(wk, 20, @SUSPENSIONRUNDATE), 3));

	IF OBJECT_ID('tempdb..#SGGSCAMP6WEEXCLUDE') IS NOT NULL DROP TABLE #SGGSCAMP6WEEXCLUDE
	SELECT a.IndependentContractorId INTO #SGGSCAMP6WEEXCLUDE
	FROM Mst_IndependentContractor_Assignment a INNER JOIN #ICLATESTSALES d ON a.IndependentContractorId = d.IndependentContractorId 
	WHERE CampaignId = 1188 AND a.IndependentContractorId IN ( select IndependentContractorId from #ICLATESTSALES) 
	and d.LastSalesDate >= @COUNT6WEDATE

	UPDATE d SET d.LastSalesSubmissionDate = '2021-08-19'	-- refer to Ticket#2021072713000114
	FROM Mst_IndependentContractor_Assignment a INNER JOIN #ICLATESTSALES d ON a.IndependentContractorId = d.IndependentContractorId 
	WHERE CampaignId = 1106 AND a.IndependentContractorId IN ( select IndependentContractorId from #ICLATESTSALES) 

	-- Exclusion admin and PIC
	IF OBJECT_ID('tempdb..#ExList') IS NOT NULL DROP TABLE #ExList
	SELECT * INTO #ExList 
	FROM Courses_Users_Exclusion WHERE ExType = 'NS'

	IF OBJECT_ID('tempdb..#ICSUSPENDEXCLUDEDATA') IS NOT NULL DROP TABLE #ICSUSPENDEXCLUDEDATA
	SELECT h.* INTO #ICSUSPENDEXCLUDEDATA 
	FROM (
	SELECT i.*
	FROM #ICLATESTSALES i INNER JOIN Mst_MarketingCompany m ON i.MarketingCompanyId = m.MarketingCompanyId 
	WHERE m.CountryCode NOT IN ('KR','SG') AND BadgeNo NOT IN (SELECT BadgeNo FROM #ExList)
	AND LastSalesDate <	@COUNTDATE
	UNION 
	SELECT i.*
	FROM #ICLATESTSALES i INNER JOIN Mst_MarketingCompany m ON i.MarketingCompanyId = m.MarketingCompanyId 
	WHERE m.CountryCode  IN ('KR','SG') AND BadgeNo NOT IN (SELECT BadgeNo FROM #ExList)
	AND LastSalesDate <	@COUNTNEXTWEEKDATE AND i.IndependentContractorId NOT IN (SELECT * FROM #SGGSCAMP6WEEXCLUDE)) h	

	-- NO SALES 14 DAYS REMINDER EMAIL TO MCADMIN
	IF OBJECT_ID('tempdb..#ICSUSPENDDATAALL') IS NOT NULL DROP TABLE #ICSUSPENDDATAALL
	SELECT MarketingCompanyId,  STUFF((SELECT ';' + Convert(varchar ,ROW_NUMBER() OVER(ORDER BY MarketingCompanyId DESC)) + '. ' + c.BadgeNo + ': ' + CAST(CONCAT(FirstName, MiddleName, LastName) AS VARCHAR(MAX))
    FROM #ICSUSPENDEXCLUDEDATA c WHERE (d.MarketingCompanyId = c.MarketingCompanyId)	
	FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'') as Badge,
	STUFF((SELECT ';' + u.Email FROM Mst_User u WHERE UserRoleId = 3 and u.MarketingCompanyId = d.MarketingCompanyId and u.IsActive = 1 and u.IsDeleted = 0
	and u.Email not in ('123@salesworks.asia','123@saleswork.asia','123@gmail.com')
    FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'') as McAdmin INTO #ICSUSPENDDATAALL
	from #ICSUSPENDEXCLUDEDATA d 	
	group by d.marketingcompanyid 

	IF OBJECT_ID('tempdb..#ICSUSPENDDATA') IS NOT NULL DROP TABLE #ICSUSPENDDATA
	SELECT s.MarketingCompanyId, s.Badge, concat(s.mcadmin,';',ms.Email) McAdmin INTO #ICSUSPENDDATA
	FROM #ICSUSPENDDATAALL s 
	INNER JOIN Mst_MarketingCompany m ON s.MarketingCompanyId = m.MarketingCompanyId 
	LEFT JOIN (SELECT marketingcompanyid, STRING_AGG(Email,';') as Email FROM mst_marketingcompany_staff GROUP BY marketingcompanyid) ms ON s.marketingcompanyid = ms.marketingcompanyid
	WHERE (s.McAdmin is not null or ms.Email is not null) 
	 

	--SELECT * FROM mst_marketingcompany_staff WHERE MarketingCompanyId = 1457
	SELECT * FROM #ICSUSPENDDATAALL where MarketingCompanyId = 1457

	select CONCAT('ICSuspend-', CONVERT(NVARCHAR(20),@SUSPENSIONRUNDATE,20), '-', Cast(MarketingCompanyId as nvarchar)), 
	CONCAT('McID-', Cast(MarketingCompanyId as nvarchar)), McAdmin, 'adilla.aziz@salesworks.asia;syafiqah.manah@salesworks.asia;leonard.yong@salesworks.asia', 
	'OLAF Suspension List Reminder: No sales for 3 consecutive Weekending', 
	CONCAT('<span style="font-size:10pt;font-family:Helvetica">Hi,<br>Kindly take note that below ID badges will be suspended on <b>', 
	FORMAT (@SUSPENSIONRUNDATE, 'dd-MM-yyyy'), '</b> due to No Sales in 3 consecutive weekendings if they did not submit any new sales within the next 7 days.<br>Please contact your country PIC for further clarification.<br>Thanks.<br><br>', REPLACE(Badge, ';', '<br>'), '</span>') , GETDATE(), 'Admin' 
	FROM #ICSUSPENDDATA WHERE McAdmin IS NOT NULL

	 

END
 

 --SP_ICSuspendReminderMail2