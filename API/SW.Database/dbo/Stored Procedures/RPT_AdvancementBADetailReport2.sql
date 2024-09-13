

-- ==========================================================================================
-- Author:		Syafiqah Ab Manah
-- Create date: 2020-11-05
-- Description:	Regional RC Analysis Report 
-- EXEC RPT_AdvancementBADetailReport '2022-04-17' ,'KK0031','TH'
-- ==========================================================================================
--EXEC RPT_AdvancementBADetailReport2 '2022-09-11','UR0005','MY' 
CREATE PROCEDURE [dbo].[RPT_AdvancementBADetailReport2]
 @Weekending DATE,
 @BadgeNo NVARCHAR(10),
 @CountryCode NVARCHAR(2)
AS
BEGIN 

	DECLARE @WEDate1 as DATE
	DECLARE @WEDate2 as DATE

	SET @WEDate1 = @Weekending
	SET @WEDate2 = (SELECT TOP 1 WeDate FROM TXN_WeeklyBASummary 
			WHERE IsDeleted = 0 and CountryCode = @CountryCode and  WeDate > @Weekending ORDER BY WeDate ASC
			)
			 SELECT @WEDate1, @WEDate2
	DROP TABLE IF EXISTS #TXN_ReportingBadge
	CREATE TABLE #TXN_ReportingBadge
	(
		WeDate DATE,
		DirectReportBadgeNumber NVARCHAR(20),
		BadgeNo NVARCHAR(20),
		CurrentLevel  NVARCHAR(20),
		BadgeNoLink  NVARCHAR(200)
	)

 	INSERT INTO #TXN_ReportingBadge
	SELECT WeDate, C.BadgeNo as 'DirectReportBadgeNumber', B.BadgeNo as 'BadgeNo', D.LevelCode  IndependentContractorLevelId, REPLACE(BadgeNolink,'\','~') FROM Appco360_PROD..TXN_ReportingBadge_KR A 
	LEFT JOIN NewOlaf_Prod..Mst_IndependentContractor B ON A.IndependentContractorId = B.IndependentContractorId
	LEFT JOIN NewOlaf_Prod..Mst_IndependentContractor C ON A.ReportToIndependentContractorId = C.IndependentContractorId
	LEFT JOIN NewOlaf_Prod..Mst_IndependentContractorLevel D ON A.IndependentContractorLevelId = D.IndependentContractorLevelId
	WHERE A.WeDate in (@WEDate1, @WEDate2) and A.IsActive = 1 and BadgeNolink like '%'  + @BadgeNo + '%' and @CountryCode = 'KR'
	  
	INSERT INTO #TXN_ReportingBadge
	SELECT WEDate, DirectReportBadgeNumber, BadgeNo, CurrentLevel, BadgeNolink  FROM NewMYDB_PROD..TXN_ReportingBadge
	WHERE WEDate  in (@WEDate1, @WEDate2) and BadgeNolink like '%'  + @BadgeNo + '%'  and @CountryCode = 'MY' 
	 and BadgeNolink like '%'  + @BadgeNo + '%' 

	INSERT INTO #TXN_ReportingBadge
	SELECT WeDate, DirectReportBadgeNo, UPPER(BadgeNo),A.LevelCode, BadgeNoLink   FROM NewTWDB_PROD..Mst_TeamStructure A 
	LEFT JOIN NewTWDB_PROD..VW_MST_LEVEL B
	ON CASE WHEN A.LevelCode = 'FR' THEN 'IC' ELSE A.LevelCode END = B.LevelCode
	where wedate  in (@WEDate1, @WEDate2) and @CountryCode = 'TW'  and BadgeNolink like '%'  + @BadgeNo + '%' 
	
	INSERT INTO #TXN_ReportingBadge
	SELECT WeekendingDate, DirectReportBadgeNo, ICBadgeNo, CurrentLevel, BadgeRelationship  FROM NewTHDB_PROD..Txn_Transaction_ICE
	WHERE WeekendingDate  in (@WEDate1, @WEDate2) and IsDeleted = 0 and @CountryCode = 'TH'  and BadgeRelationship like '%'  + @BadgeNo + '%'  
	 
	 
 SELECT * FROM #TXN_ReportingBadge
	 

	 SELECT A.CountryCode, A.Weekending, A.BadgeNo, A.CurrentLevel as 'CurrentLevel', A.BadgeNoLink, A.PersonalPayable, A.BulletinPoint FROM (
	SELECT A.CountryCode, A.Weekending, A.BadgeNo, B.CurrentLevel, B.BadgeNoLink, A.PersonalPayable , A.BulletinPoint
	FROM Mst_AutoAdvancementSales A INNER JOIN #TXN_ReportingBadge B ON A.BadgeNo = B.BadgeNo and A.Weekending = B.WeDate
	where A.CountryCode = @CountryCode and  A.Weekending  = @WEDate1  --and A.BadgeNo <> @BadgeNo
	UNION ALL
	SELECT A.CountryCode, A.Weekending, A.BadgeNo, B.CurrentLevel, B.BadgeNoLink, A.PersonalPayable  , A.BulletinPoint 
	FROM Mst_AutoAdvancementSales A INNER JOIN #TXN_ReportingBadge B ON A.BadgeNo = B.BadgeNo and A.Weekending = B.WeDate
	where A.CountryCode = @CountryCode and  A.Weekending  = @WEDate2  --and A.BadgeNo <> @BadgeNo
	) A --LEFT JOIN Mst_IndependentContractorLevel B ON A.CurrentLevel = B.IndependentContractorLevelId
	 
END

--EXEC RPT_AdvancementBADetailReport '2022-04-10','MB0434','MY' 

