-- =============================================
-- Author:		Tan Siuk Ching
-- Create date: 2021-09-10
-- Description:	IC No Active Campaign Suspension
-- =============================================
 
CREATE PROCEDURE [dbo].[SP_ICCampaignSuspension]  
	-- Add the parameters for the stored procedure here
AS
BEGIN

	-- Day 8 Suspend BA due to no active campaign

	DECLARE @REMINDERDAY INT = 8;
	DECLARE @STARTDATE DATE = '2021-09-23';

	IF OBJECT_ID('tempdb..#TEMP_IndependentContractor2') IS NOT NULL DROP TABLE #TEMP_IndependentContractor2
	SELECT i.IndependentContractorId, I.IndependentContractorLevelId, BadgeNo, I.MarketingCompanyId,ISNULL(assigned.CampStartDate, @STARTDATE) CampStartDate,  assigned.CampEndDate, 
	(SELECT SUBSTRING((SELECT ',' + y.CampaignName AS 'data()' FROM Mst_IndependentContractor_Assignment x
	LEFT JOIN Mst_Campaign y ON x.CampaignId = y.CampaignId  WHERE x.IsDeleted = 0 AND y.IsDeleted = 0 
	AND x.IndependentContractorId = i.IndependentContractorId AND (x.EndDate is null or x.EndDate >= GETDATE()) FOR XML PATH('') ), 2 , 9999)) Campaign 
	INTO #TEMP_IndependentContractor2
	FROM Mst_IndependentContractor i LEFT JOIN Mst_MarketingCompany m ON m.MarketingCompanyId = i.MarketingCompanyId
	OUTER APPLY (SELECT top 1 CASE WHEN StartDate < @STARTDATE THEN @STARTDATE ELSE StartDate END CampStartDate , 
	EndDate CampEndDate FROM Mst_IndependentContractor_Assignment a WHERE a.IndependentContractorId = i.IndependentContractorId AND ISNULL(enddate, '2099-12-31') >= FORMAT(DATEADD(DAY, -1, GETDATE()), 'yyyy-MM-dd') order by EndDate desc) as assigned
	WHERE --m.MarketingCompanyType is null AND 
	i.IsDeleted = 0 AND m.IsDeleted = 0 AND Status = 'Active' AND i.IndependentContractorLevelId NOT IN (1,2,5,6,9) AND I.IsSuspended = 0 AND M.CountryCode NOT IN ('ID','PH')
	ORDER BY CampEndDate

	IF OBJECT_ID('tempdb..#ExList') IS NOT NULL DROP TABLE #ExList
	SELECT * INTO #ExList 
	FROM Courses_Users_Exclusion WHERE ExType = 'NS'

	IF OBJECT_ID('tempdb..#ExListMO') IS NOT NULL DROP TABLE #ExListMO
	SELECT * INTO #ExListMO
	FROM Courses_Users_Exclusion WHERE ExType = 'MONS'

	IF OBJECT_ID('tempdb..#TEMP_IcToSuspend') IS NOT NULL DROP TABLE #TEMP_IcToSuspend
	SELECT * INTO #TEMP_IcToSuspend
	FROM #TEMP_IndependentContractor2 
	WHERE 
	(CampStartDate = FORMAT(DATEADD(DAY, -@REMINDERDAY, GETDATE()), 'yyyy-MM-dd') AND Campaign IS NULL AND BadgeNo NOT IN (SELECT BadgeNo FROM #ExList) AND MarketingCompanyId NOT IN (SELECT MCID FROM #ExListMO)) OR		-- For first time check, suspend on D8 after launch nocampaignassigned suspension
	(CampStartDate != @STARTDATE AND (FORMAT(CampEndDate, 'yyyy-MM-dd') = FORMAT(DATEADD(DAY, -1, GETDATE()), 'yyyy-MM-dd') AND Campaign IS NULL) AND BadgeNo NOT IN (SELECT BadgeNo FROM #ExList) AND MarketingCompanyId NOT IN (SELECT MCID FROM #ExListMO)) OR
	(CampStartDate =  @STARTDATE AND CampEndDate IS NULL AND Campaign IS NULL AND BadgeNo NOT IN (SELECT BadgeNo FROM #ExList) AND MarketingCompanyId NOT IN (SELECT MCID FROM #ExListMO)) -- ADDED ON 2022-06-10 Ticket#2022053113000037
	
	----Ticket#2023032413000016 — [OLAF] Temporary Exclusion of suspension for no campaign assigned (SG)
	--DELETE #TEMP_IcToSuspend WHERE BadgeNo IN ('JE0002',	'JE0003',	'JE0004',	'JE0005',	'JE0006',	'JE0007',	'JE0008',	'JE0009',	'JE0010',	'JE0011',	'JE0012',	'DC00002',	'DC00003',	'DC00004',	'DC00005',	'DC00006',	'DC00007',	'DC00008',	'DC00009',	'DC00010',	'DC00011',	'DC00012',	'DC00013',	'DC00014',	'DC00015',	'DC00016',	'DC00017',	'DC00018',	'DC00019',	'DC00020',	'DC00021') -- TEMPORARY ADDED Ticket#2023032413000016

	INSERT Mst_IndependentContractor_Suspension (IndependentContractorId,Description,IndependentContractorLevelId, StartDate, EndDate, IsReactivate, IsDeleted,CreatedBy, CreatedDate)
	SELECT c.IndependentContractorId, 'No active campaign assigned', c.IndependentContractorLevelId, GETDATE(), CONVERT(DATE, DATEADD(DAY,90,GETDATE())), 0, 0, 'Admin', GETDATE()
	FROM #TEMP_IcToSuspend c 

	UPDATE d SET IsSuspended = 1, UpdatedBy = 'ICCampaignSuspension', UpdatedDate = GETDATE()
	FROM Mst_IndependentContractor d INNER JOIN #TEMP_IcToSuspend e ON d.IndependentContractorId = e.IndependentContractorId

----------------------------------------------------------------------------------------------------------

	-- Prepare the BA list
	IF OBJECT_ID('tempdb..#TEMP_IndependentContractor') IS NOT NULL DROP TABLE #TEMP_IndependentContractor
	SELECT m.CountryCode ,i.IndependentContractorId, BadgeNo, i.MarketingCompanyId, CONCAT(BadgeNo, ': ', TRIM(CONCAT(FirstName,' ', MiddleName)),' ', LastName) Name, assigned.StartDate CampStartDate,  assigned.CampEndDate, 
	(SELECT SUBSTRING((SELECT ',' + y.CampaignName AS 'data()' FROM Mst_IndependentContractor_Assignment x
	LEFT JOIN Mst_Campaign y ON x.CampaignId = y.CampaignId  WHERE x.IsDeleted = 0 AND y.IsDeleted = 0 
	AND x.IndependentContractorId = i.IndependentContractorId AND (x.EndDate is null or x.EndDate >= GETDATE()) FOR XML PATH('') ), 2 , 9999)) Campaign 
	INTO #TEMP_IndependentContractor
	FROM Mst_IndependentContractor i LEFT JOIN Mst_MarketingCompany m ON m.MarketingCompanyId = i.MarketingCompanyId
	OUTER APPLY (SELECT top 1 StartDate , EndDate CampEndDate FROM Mst_IndependentContractor_Assignment a WHERE a.IndependentContractorId = i.IndependentContractorId AND ISNULL(enddate, '2099-12-31') >= GETDATE() order by EndDate desc) as assigned
	WHERE m.MarketingCompanyType IS NULL AND i.IsDeleted = 0 AND m.IsDeleted = 0 AND Status = 'Active' AND i.IndependentContractorLevelId NOT IN (1,2,5,6,9) AND I.IsSuspended = 0 AND M.CountryCode NOT IN ('ID','PH')
	ORDER BY CampEndDate


	DELETE A
	FROM #TEMP_IndependentContractor A	
	WHERE (CampEndDate != FORMAT(DATEADD(DAY, 6, GETDATE()), 'yyyy-MM-dd'))
	 OR (Campaign IS NOT NULL AND CampEndDate IS NULL)	
	 OR (Campaign IS NULL AND CampStartDate IS NULL)-- * INCLUDE START FROM SECOND DAY

	IF OBJECT_ID('tempdb..#ICNOTCAMPAIGNASSIGN') IS NOT NULL DROP TABLE #ICNOTCAMPAIGNASSIGN
	SELECT i.* INTO #ICNOTCAMPAIGNASSIGN 
	FROM #TEMP_IndependentContractor i 
	WHERE BadgeNo NOT IN (SELECT BadgeNo FROM #ExList) AND MarketingCompanyId NOT IN (SELECT MCID FROM #ExListMO) 

	-- get mc email
	IF OBJECT_ID('tempdb..#TEMP_MCEmail') IS NOT NULL DROP TABLE #TEMP_MCEmail
	SELECT DISTINCT MarketingCompanyId,  STUFF((SELECT ';' + Convert(varchar ,ROW_NUMBER() OVER(ORDER BY MarketingCompanyId DESC)) + '. ' + c.Name
	FROM #ICNOTCAMPAIGNASSIGN c WHERE (c.MarketingCompanyId = d.MarketingCompanyId ) FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'') as Badge,
	STUFF((SELECT ';' + u.Email FROM Mst_User u WHERE UserRoleId = 3 AND u.MarketingCompanyId = d.MarketingCompanyId AND u.IsActive = 1 AND u.IsDeleted = 0
	AND u.Email not in ('123@salesworks.asia','123@saleswork.asia','123@gmail.com', 'eileen.how@salesworks.asia')
	FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'') as McAdmin INTO #TEMP_MCEmail
	FROM #ICNOTCAMPAIGNASSIGN d 

	IF OBJECT_ID('tempdb..#TEMP_EmailDetails') IS NOT NULL DROP TABLE #TEMP_EmailDetails
	SELECT s.MarketingCompanyId, s.Badge, concat(s.mcadmin,';',ms.Email) McAdmin INTO #TEMP_EmailDetails
	FROM #TEMP_MCEmail s 
	INNER JOIN Mst_MarketingCompany m ON s.MarketingCompanyId = m.MarketingCompanyId 
	LEFT JOIN mst_marketingcompany_staff ms ON s.marketingcompanyid = ms.marketingcompanyid
	WHERE (s.McAdmin is not null or ms.Email is not null)


	Insert TXN_EmailQueue (TxnID, Description, Recipient, BCC, Subject, Body, CreateDate, CreateBy)
	SELECT CONCAT('ICSuspend-', CONVERT(NVARCHAR(20),GETDATE(),20), '-', Cast(MarketingCompanyId as nvarchar)), 
	CONCAT('McID-', Cast(MarketingCompanyId as nvarchar)), McAdmin, NULL, 
	'OLAF Suspension List Reminder: No Active Campaign Assigned', 
	CONCAT('<span style="font-size:10pt;font-family:Helvetica">Hi,<br>Kindly take note that below ID badges will be suspended ON <b>', 
	FORMAT(DATEADD(day, 7, GETDATE()), 'dd-MM-yyyy'), '</b> due to no active campaign assigned to the IC profile in OLAF. Please assign an active campaign to the IC before <b>', FORMAT(DATEADD(day, 7, GETDATE()), 'dd-MM-yyyy'), '</b> to avoid their ID Badge being suspended.<br>Thanks.<br><br>', REPLACE(Badge, ';', '<br>'), '</span>') , GETDATE(), 'Admin' 
	FROM #TEMP_EmailDetails WHERE McAdmin IS NOT NULL

	 --NO SALES 14 DAYS REMINDER EMAIL TO GM & COUNTRY PIC
	IF OBJECT_ID('tempdb..#ICSUSPENDTOGM') IS NOT NULL DROP TABLE #ICSUSPENDTOGM
	SELECT DISTINCT m.CountryCode, STUFF((SELECT ';;' + N.Code + ';' + c.Badge
    FROM #TEMP_MCEmail C INNER JOIN Mst_MarketingCompany N ON C.MarketingCompanyId = N.MarketingCompanyId
	WHERE (N.CountryCode = m.CountryCode ) FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'') as Badge,
	STUFF((SELECT ';' + u.Email FROM Mst_User u WHERE UserRoleId = 6 AND M.CountryCode = U.CountryAccess AND u.IsActive = 1 AND u.IsDeleted = 0
    FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'') as PIC INTO #ICSUSPENDTOGM
	FROM #TEMP_MCEmail d INNER JOIN Mst_MarketingCompany M ON M.MarketingCompanyId = D.MarketingCompanyId

	Insert TXN_EmailQueue (TxnID, Description, Recipient, BCC, Subject, Body, CreateDate, CreateBy)
	SELECT CONCAT('ICSuspend-', CONVERT(NVARCHAR(20),GETDATE(),20), '-', Cast(CountryCode as nvarchar)), 
	CONCAT('MC-', Cast(CountryCode as nvarchar)), PIC, NULL, 
	'OLAF Suspension List Reminder: No Active Campaign Assigned', 
	CONCAT('<span style="font-size:10pt;font-family:Helvetica">Hi,<br>Kindly take note that below ID badges will be suspended on <b>', 
	FORMAT(DATEADD(day, 7, GETDATE()), 'dd-MM-yyyy'), '</b> due to no active campaign assigned to the IC profile in OLAF. Please assign an active campaign to the IC before <b>', FORMAT(DATEADD(day, 7, GETDATE()), 'dd-MM-yyyy'), '</b> to avoid their ID Badge being suspended.<br>Thanks.<br>', REPLACE(Badge, ';', '<br>'), '</span>') 
	, GETDATE(), 'Admin' 
	FROM #ICSUSPENDTOGM WHERE PIC IS NOT NULL

-------------------------------------------------------------------------------------------------------------


	-- Reactivate suspended BA when active campaign assigned
	IF OBJECT_ID('tempdb..#TEMP_IcSuspensionLift') IS NOT NULL DROP TABLE #TEMP_IcSuspensionLift
	SELECT s.IndependentContractorSuspensionId, i.IndependentContractorId, i.BadgeNo, i.IndependentContractorLevelId, (
	SELECT SUBSTRING((SELECT ',' + y.CampaignName AS 'data()' FROM Mst_IndependentContractor_Assignment x
	LEFT JOIN Mst_Campaign y ON x.CampaignId = y.CampaignId  WHERE x.IsDeleted = 0 AND y.IsDeleted = 0 
	AND x.IndependentContractorId = i.IndependentContractorId AND (x.EndDate is null or x.EndDate >= GETDATE()) FOR XML PATH('') ), 2 , 9999)) Campaign 
	INTO #TEMP_IcSuspensionLift
	FROM Mst_IndependentContractor_Suspension s 
	INNER JOIN Mst_IndependentContractor i ON s.IndependentContractorId = i.IndependentContractorId 
	WHERE i.Status = 'Active' AND i.IsSuspended = 1 AND s.IsDeleted = 0 AND IsReactivate = 0 AND s.Description = 'No active campaign assigned' 

	-- ADDED ON 2022-07-27 BECAUSE OF DOUBLE SUSPENSION HAPPENING TO BA FS01079
	IF OBJECT_ID('tempdb..#CurrentlySuspended') IS NOT NULL DROP TABLE #CurrentlySuspended
	SELECT IndependentContractorId INTO #CurrentlySuspended FROM Mst_IndependentContractor_Suspension  A
	WHERE IndependentContractorId in (SELECT IndependentContractorId FROM #TEMP_IcSuspensionLift)
	AND Isdeleted = 0 AND Description NOT IN ('No active campaign assigned')
	AND GETDATE() >= StartDate AND GETDATE() <= EndDate

	UPDATE S SET EndDate = FORMAT(DATEADD(DAY, -1, GETDATE()), 'yyyy-MM-dd'), IsReactivate = 1, UpdatedBy = 'Admin', UpdatedDate = GETDATE()
	FROM Mst_IndependentContractor_Suspension s INNER JOIN #TEMP_IcSuspensionLift e on s.IndependentContractorSuspensionId = e.IndependentContractorSuspensionId
	WHERE Campaign IS NOT NULL 
	AND s.IndependentContractorId NOT IN (SELECT IndependentContractorId FROM #CurrentlySuspended) -- ADDED ON 2022-07-27
	
	UPDATE Mst_IndependentContractor SET IsSuspended = 0, UpdatedBy = 'ICCampaignSuspension', UpdatedDate = GETDATE()
	FROM Mst_IndependentContractor d INNER JOIN #TEMP_IcSuspensionLift e on d.IndependentContractorId = e.IndependentContractorId
	WHERE Campaign IS NOT NULL 
	AND d.IndependentContractorId NOT IN (SELECT IndependentContractorId FROM #CurrentlySuspended) -- ADDED ON 2022-07-27

END
