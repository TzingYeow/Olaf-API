--EXEC SP_AutoAdvancement_DataPull_TH NULL
--=============================
CREATE PROCEDURE [dbo].[SP_AutoAdvancement_DataPull_TH]  
	@WEDate DATE
AS
BEGIN
	   
	DECLARE @CDate as datetime = GETDATE()
	
 DECLARE @Weekending as Date =    (SELECT TOP 1 WEdate  FROM (
 SELECT TOP 1 * FROM NewTHDB_PROD..MST_Weekending WHERE WEdate < CAST(GETDATE() as date) ORDER BY WEdate desc
 ) B ORDER BY B.WEdate ASC)
 DECLARE @BADGE as NVARCHAR(20)
DECLARE @LOOP AS BIT = 1  

 IF @WEDate IS NOT NULL
 SET @Weekending = @WEDate

   DECLARE @FromDate as Date = ( SELECT TOP 1 FromDate FROM NewHKDB_PROD..MST_Weekending WHERE WEdate = @Weekending)

DROP TABLE IF EXISTS #Result
CREATE TABLE #Result(
	WeekendingDate DATE,
	MOCode NVARCHAR(20),
	CurrentLevel NVARCHAR(20),
	BadgeNo NVARCHAR(20),
	PersonalPoint  Decimal(18,2),
	PersonalSalesValue  Decimal(18,2),
	PersonalPiece  Decimal(18,2),
	TeamPoint Decimal(18,2),
	TeamSalesValue Decimal(18,2),
	TeamSize INT,
	FirstGenLeader INT,
	IndependentContractorLevelId INT
) 

DROP TABLE IF EXISTS #ActiveBA
SELECT IndependentContractorId, BadgeNo,IndependentContractorLevelId, EffectiveAdvancementDate, B.Code as 'MCCode' INTO #ActiveBA FROM Mst_IndependentContractor A LEFT JOIN Mst_MarketingCompany B ON A.MarketingCompanyId = B.MarketingCompanyId
WHERE B.CountryCode = 'TH' and A.StartDate <=@Weekending and (A.LastDeactivateDate  >= @FromDate or A.LastDeactivateDate is null)
AND ISNULL(A.LastDeactivateDate,'1900-01-01') >= CASE WHEN A.StartDate >=@FromDate THEN @Weekending ELSE '1900-01-01' END


--Removing Re-activate for advancement weekending 2024-01-28 YKW
SELECT A.IndependentContractorId, A.IndependentContractorLevelId, A.PromotionDemotionDate as 'EffectiveDate' INTO #BAEffectiveDate  FROM Mst_IndependentContractor_Movement A 
INNER JOIN (
	SELECT Z.IndependentContractorId, Z.PromotionDemotionDate ,MAX(Z.CreatedDate) CreatedDate
	FROM Mst_IndependentContractor_Movement Z INNER JOIN (
		SELECT IndependentContractorId, MAX(PromotionDemotionDate) EffectiveDate FROM Mst_IndependentContractor_Movement
		where Description in ('Advance','New-Recruit', 'De-advance','New-IC','Re-train','Demote') and IndependentContractorLevelId is not null
		and IndependentContractorId in (SELECT IndependentContractorId from #ActiveBA) and PromotionDemotionDate < @Weekending and IsDeleted = 0 GROUP BY IndependentContractorId
	) X ON Z.IndependentContractorId = X.IndependentContractorId and Z.PromotionDemotionDate = X.EffectiveDate
	GROUP BY Z.IndependentContractorId, Z.PromotionDemotionDate
) B ON A.IndependentContractorId = B.IndependentContractorId and A.PromotionDemotionDate = B.PromotionDemotionDate and A.CreatedDate = B.CreatedDate
WHERE A.IndependentContractorLevelId is not null and IsDeleted = 0 


 
DROP TABLE IF EXISTS #Txn_Transaction_ICE
SELECT A.ICBadgeNo as 'BadgeNo', A.CurrentLevel,ISNULL(SUM(ISNULL(QualifiedPoints,0.00) + ISNULL(ResidualPoint,0.00) + ISNULL(Points,0.00)),0.00) as 'PersonalPoint', ISNULL(SUM(ISNULL(SubmissionEarning,0.00) + ISNULL(ICEarnings,0.00)),0.00) as 'TotalSalesValue', SUM(NetPieces) as 'PersonalPieces' INTO #Txn_Transaction_ICE 
FROM NewTHDB_PROD..Txn_Transaction_ICE  A  
WHERE A.WeekendingDate = @Weekending and A.IsDeleted = 0
GROUP BY A.ICBadgeNo , A.CurrentLevel

DROP TABLE IF EXISTS #TempSalesImport
SELECT BadgeID, SignUpPieces, TotalEarning, CASE WHEN TotalEarning = 0 THEN 0 ELSE  TotalEarning/400.00 END as TotalPoint INTO #TempSalesImport
FROM Appco360_PROD..Txn_SalesImport A  
WHERE Country = 'TH' and NetEarning > 0 and WEDate = @WEDate and IsDeleted = 0
order by WEDate desc

DROP TABLE IF EXISTS #Mst_IndependentContractor_Movement
SELECT * INTO #Mst_IndependentContractor_Movement FROM Mst_IndependentContractor_Movement WHERE IndependentContractorId in (
SELECT IndependentContractorId FROM #ActiveBA GROUP BY IndependentContractorId
) and IsDeleted = 0



DROP TABLE IF EXISTS #BALatestMovement
SELECT A.IndependentContractorId, MAX(A.PromotionDemotionDate) PromotionDemotionDate INTO #BALatestMovement FROM #Mst_IndependentContractor_Movement A 
INNER JOIN  #ActiveBA B 
	ON A.IndependentContractorId = B.IndependentContractorId and A.IndependentContractorLevelId = B.IndependentContractorLevelId and A.Description='Advance'
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


UPDATE A SET A.PersonalPieces = ISNULL(A.PersonalPieces,0) + ISNULL(B.SignUpPieces,0),
A.TotalSalesValue = ISNULL(A.TotalSalesValue,0.00) + ISNULL(B.TotalEarning,0.00),
A.PersonalPoint = ISNULL(A.PersonalPoint,0.00) + CAST(ISNULL(B.TotalPoint,0.00) as decimal(18,4))
FROM #Txn_Transaction_ICE A INNER JOIN #TempSalesImport B ON A.BadgeNo = B.BadgeID
 
INSERT INTO #Txn_Transaction_ICE
SELECT  BadgeID, LevelCode,TotalPoint, TotalEarning, SignUpPieces 
FROM #TempSalesImport A LEFT JOIN #Txn_Transaction_ICE B ON A.BadgeID = B.BadgeNo
LEFT JOIN Mst_IndependentContractor C ON A.BadgeID = C.BadgeNo
LEFT JOIN Mst_MarketingCompany D ON C.MarketingCompanyId = D.MarketingCompanyId
LEFT JOIN Mst_IndependentContractorLevel F ON C.IndependentContractorLevelId = F.IndependentContractorLevelId
WHERE B.BadgeNo is null and D.CountryCode = 'TH'
 

--SELECT * FROM #Txn_Transaction_ICE A LEFT JOIN #TempSalesImport B ON A.BadgeNo = B.BadgeID


 
DROP TABLE IF EXISTS #Relationship
SELECT A.* INTO #Relationship FROM NewTHDB_PROD..Mst_BARelationship  A 
LEFT JOIN NewOlaf_Prod..Mst_IndependentContractor B ON A.BadgeNo = B.BadgeNo 
LEFT JOIN NewOlaf_Prod..Mst_MarketingCompany C ON B.MarketingCompanyId = C.MarketingCompanyId 
WHERE C.CountryCode = 'TH' and B.IsDeleted = 0 and B.IndependentContractorId in (SELECT IndependentContractorId from #ActiveBA)
and A.WEDate = @Weekending
 
 
UPDATE TXN_WeeklyBASummary SET isdeleted = 1 where WEdate = @Weekending and CountryCode = 'TH'
 
INSERT INTO TXN_WeeklyBASummary(WeDate,CountryCode,MCCode,IndependentContractorID,BadgeNo,CurrentLevel,WELevel,
BadgeNoLink,DirectReportBadgeNo,LevelPromotionDate,NetPoint,NetValue,NetPcs,CreatedDate,IsDeleted)
 SELECT @Weekending,'TH',A.MCCode, A.IndependentContractorId, A.BadgeNo, ISNULL(E.levelCode, D.LevelCode),ISNULL(G.LevelCode,ISNULL(E.levelCode, D.levelCode)),
 F.BadgeNoLink,F.DirectReportBadgeNumber,ISNULL(C.EffectiveDate, A.EffectiveAdvancementDate), 
 B.PersonalPoint,B.TotalSalesValue,B.PersonalPieces, @CDate, 0 FROM #ActiveBA A 
 LEFT JOIN #Txn_Transaction_ICE B ON A.BadgeNo = B.BadgeNo
LEFT JOIN #BAEffectiveDate C ON A.IndependentContractorId = C.IndependentContractorId
LEFT JOIN Mst_IndependentContractorLevel D ON A.IndependentContractorLevelId = D.IndependentContractorLevelId
LEFT JOIN Mst_IndependentContractorLevel E ON C.IndependentContractorLevelId = E.IndependentContractorLevelId
LEFT JOIN #Relationship F ON A.BadgeNo = F.BadgeNo
LEFT JOIN #BAWeekendingLevel G ON A.IndependentContractorId = G.IndependentContractorId 


 SELECT @Weekending,'TH',A.MCCode, A.IndependentContractorId, A.BadgeNo, ISNULL(E.levelCode, D.LevelCode),ISNULL(G.LevelCode,ISNULL(E.levelCode, D.levelCode)),
 F.BadgeNoLink,F.DirectReportBadgeNumber,ISNULL(C.EffectiveDate, A.EffectiveAdvancementDate), 
 B.PersonalPoint,B.TotalSalesValue,B.PersonalPieces, @CDate, 0 FROM #ActiveBA A 
 LEFT JOIN #Txn_Transaction_ICE B ON A.BadgeNo = B.BadgeNo
LEFT JOIN #BAEffectiveDate C ON A.IndependentContractorId = C.IndependentContractorId
LEFT JOIN Mst_IndependentContractorLevel D ON A.IndependentContractorLevelId = D.IndependentContractorLevelId
LEFT JOIN Mst_IndependentContractorLevel E ON C.IndependentContractorLevelId = E.IndependentContractorLevelId
LEFT JOIN #Relationship F ON A.BadgeNo = F.BadgeNo
LEFT JOIN #BAWeekendingLevel G ON A.IndependentContractorId = G.IndependentContractorId 

END
 


