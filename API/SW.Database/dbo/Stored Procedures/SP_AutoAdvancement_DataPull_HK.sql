--3 NULL
--=============================
CREATE PROCEDURE [dbo].[SP_AutoAdvancement_DataPull_HK]  
	@WEDate DATE
AS
BEGIN
	DECLARE @CDate as datetime = GETDATE()
	
 DECLARE @Weekending as Date =    (SELECT TOP 1 WEdate  FROM (
 SELECT TOP 1 * FROM NewHKDB_PROD..MST_Weekending WHERE WEdate <  CAST(GETDATE() as DATE) ORDER BY WEdate desc
 ) B ORDER BY B.WEdate ASC)
 DECLARE @BADGE as NVARCHAR(20)
DECLARE @LOOP AS BIT = 1 
  
 IF @WEDate IS NOT NULL
 SET @Weekending = @WEDate

 DECLARE @FromDate as Date = ( SELECT TOP 1 FromDate FROM NewHKDB_PROD..MST_Weekending WHERE WEdate = @Weekending)

DROP TABLE IF EXISTS #ActiveBA
SELECT IndependentContractorId, BadgeNo, EffectiveAdvancementDate, B.Code as 'MCCode' INTO #ActiveBA FROM Mst_IndependentContractor A LEFT JOIN Mst_MarketingCompany B ON A.MarketingCompanyId = B.MarketingCompanyId
WHERE B.CountryCode = 'HK' and A.StartDate <=@Weekending and (A.LastDeactivateDate >= @FromDate or A.LastDeactivateDate is null)
AND ISNULL(A.LastDeactivateDate,'1900-01-01') >= CASE WHEN A.StartDate >=@FromDate THEN @Weekending ELSE '1900-01-01' END
  
DROP TABLE IF EXISTS #Txn_Transaction_ICE
SELECT A.*,C.IndependentContractorLevelId, E.DirectReportBadgeNumber, E.BadgeNoLink INTO #Txn_Transaction_ICE FROM NewHKDB_PROD..Txn_Transaction_ICE  A 
LEFT JOIN [NewHKDB_PROD].[dbo].[Mst_BARelationship] E ON A.BadgeNo = E.BadgeNo and E.WEDate = @Weekending 
LEFT JOIN NewHKDB_PROD..Level_Mapping B ON A.CurrentLevel = B.OldLevelCode
LEFT JOIN NewOlaf_Prod..Mst_IndependentContractorLevel C ON B.NewLevelCode = C.LevelCode 
WHERE A.WeekendingDate = @Weekending and A.IsDeleted = 0

DROP TABLE IF EXISTS #BARelationship
SELECT * INTO #BARelationship FROM [NewHKDB_PROD].[dbo].[Mst_BARelationship]
WHERE WEDate = @Weekending

DROP TABLE IF EXISTS #Mst_IndependentContractor_Movement
SELECT * INTO #Mst_IndependentContractor_Movement FROM Mst_IndependentContractor_Movement WHERE IndependentContractorId in (
SELECT IndependentContractorId FROM #ActiveBA GROUP BY IndependentContractorId
) and IsDeleted = 0

 SELECT A.BadgeID, SUM(ISNULL(A.TotalEarning,0.00)) as 'NetEarning' INTO #ManualSales FROM Appco360_PROD..Txn_SalesImport A 
 LEFT JOIN NewHKDB_PROD..VW_MST_IC B ON A.BadgeID = B.BadgeNo  
 --LEFT JOIN NewHKDB_PROD..VW_MST_MO C ON B.OfficeCode = C.Id
 WHERE A.Country = 'HK' and A.IsDeleted = 0 
 and WEDate = @Weekending -- and ISNULL(A.netEarning,0.00) > 0
 GROUP BY A.BadgeID


 DELETE FROM #ManualSales where ISNULL(NetEarning,0) = 0

DROP TABLE IF EXISTS #BALatestMovement
SELECT A.IndependentContractorId, MAX(A.PromotionDemotionDate) PromotionDemotionDate INTO #BALatestMovement FROM #Mst_IndependentContractor_Movement A 
INNER JOIN  #ActiveBA B 
	ON A.IndependentContractorId = B.IndependentContractorId and A.IndependentContractorLevelId = B.IndependentContractorId and A.Description='Advance'
--WHERE A.PromotionDemotionDate >=@FromDate
GROUP BY A.IndependentContractorId

UPDATE A SET A.EffectiveAdvancementDate = B.PromotionDemotionDate FROM #ActiveBA A LEFT JOIN #BALatestMovement B ON A.IndependentContractorId = B.IndependentContractorId
WHERE B.PromotionDemotionDate is not null

DROP TABLE IF EXISTS #BAWeekendingLevel
SELECT A.IndependentContractorId, D.LevelCode INTO #BAWeekendingLevel FROM Mst_IndependentContractor A INNER JOIN (
SELECT * FROM #BALatestMovement WHERE PromotionDemotionDate   >=@FromDate
) B ON A.IndependentContractorId = B.IndependentContractorId
LEFT JOIN Mst_IndependentContractorLevel C ON A.IndependentContractorLevelId = C.IndependentContractorLevelId
LEFT JOIN Mst_IndependentContractorLevel D ON C.LevelOrdinal - 1 = D.LevelOrdinal
WHERE A.IndependentContractorLevelId = 4



UPDATE TXN_WeeklyBASummary SET isdeleted = 1 where WEdate = @Weekending and CountryCode = 'HK'

IF @Weekending < '2023-12-03'
BEGIN
	INSERT INTO TXN_WeeklyBASummary(WeDate,CountryCode, MCCode, IndependentContractorID,BadgeNo,CurrentLevel,WELevel,
	BadgeNoLink,DirectReportBadgeNo,LevelPromotionDate,NetPoint,NetValue,CreatedDate,IsDeleted) 
	SELECT @Weekending, 'HK' as 'CountryCode', A.MCCode, A.IndependentContractorId, A.BadgeNo, D.NewLevelCode as 'CurrentLevel', ISNULL(G.LevelCode,D.NewLevelCode),UPPER(C.BadgeNoLink) as 'BadgeNoLink' , UPPER(C.DirectReportBadgeNumber) as DirectReportBadgeNumber , C.PromotionDate, 
	SUM(ISNULL( ISNULL(B.GrossPoints,0.00 ),0.00)) as 'NetPoint', SUM(ISNULL(PaidCommission,0.00) + ISNULL(M.NetEarning,0.00)) as 'NetValue', @CDate,0
	FROM #ActiveBA A LEFT JOIN #Txn_Transaction_ICE B ON A.BadgeNo = B.BadgeNo
	LEFT JOIn #ManualSales M ON A.BadgeNo = M.BadgeID
	LEFT JOIN #BARelationship C ON A.BadgeNo = C.BadgeNo
	LEFT JOIN [NewHKDB_PROD]..Level_Mapping D ON C.CurrentLevel = D.OldLevelCode 
	LEFT JOIN #BAWeekendingLevel G ON A.IndependentContractorId = G.IndependentContractorId 
	GROUP BY MCCode,A.IndependentContractorId, A.BadgeNo, D.NewLevelCode, C.BadgeNoLink, C.DirectReportBadgeNumber, C.PromotionDate, G.LevelCode
 END

IF @Weekending >= '2023-12-03'
BEGIN
	INSERT INTO TXN_WeeklyBASummary(WeDate,CountryCode, MCCode, IndependentContractorID,BadgeNo,CurrentLevel,WELevel,
	BadgeNoLink,DirectReportBadgeNo,LevelPromotionDate,NetPoint,NetValue,CreatedDate,IsDeleted) 
	SELECT @Weekending, 'HK' as 'CountryCode', A.MCCode, A.IndependentContractorId, A.BadgeNo, D.NewLevelCode as 'CurrentLevel', ISNULL(G.LevelCode,D.NewLevelCode),UPPER(C.BadgeNoLink) as 'BadgeNoLink' , UPPER(C.DirectReportBadgeNumber) as DirectReportBadgeNumber , C.PromotionDate, 
	SUM(ISNULL( ISNULL(B.GrossPoints,0.00 ),0.00)) as 'NetPoint', SUM(ISNULL(NetEarnings,0.00)+ ISNULL(M.NetEarning,0.00)) as 'NetValue', @CDate,0
	FROM #ActiveBA A LEFT JOIN #Txn_Transaction_ICE B ON A.BadgeNo = B.BadgeNo
	LEFT JOIN #BARelationship C ON A.BadgeNo = C.BadgeNo
	LEFT JOIn #ManualSales M ON A.BadgeNo = M.BadgeID
	LEFT JOIN [NewHKDB_PROD]..Level_Mapping D ON C.CurrentLevel = D.OldLevelCode 
	LEFT JOIN #BAWeekendingLevel G ON A.IndependentContractorId = G.IndependentContractorId 
	GROUP BY MCCode,A.IndependentContractorId, A.BadgeNo, D.NewLevelCode, C.BadgeNoLink, C.DirectReportBadgeNumber, C.PromotionDate, G.LevelCode
 END
 
END
 


