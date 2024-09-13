--EXEC SP_AutoAdvancement_DataPull_TW NULL
--=============================
CREATE PROCEDURE [dbo].[SP_AutoAdvancement_DataPull_TW] 
	@WEDate DATE
AS
BEGIN
 
DECLARE @BADGE as NVARCHAR(20)
DECLARE @LOOP AS BIT = 1
	DECLARE @CDate as datetime = GETDATE()
DROP TABLE IF EXISTS #RawData
CREATE Table #RawData
(	  
	MOCode NVARCHAR(10), 
	BadgeNo NVARCHAR(20),  
	PersonalPayable DECIMAL(18,2),
	PersonalSalesPieces INT,
	TeamPayable DECIMAL(18,2),
	TeamSalesPieces INT,
	FirstGenLeader INT,
	TeamSize INT,
	IndependentContractorLevelId INT
)


 DECLARE @Weekending as Date =    (SELECT TOP 1 WEdate  FROM (
 SELECT TOP 1 * FROM NewTWDB_PROD..Tbl_Weekending WHERE WEdate <= GETDATE() ORDER BY WEdate desc
 ) B ORDER BY B.WEdate ASC) 
 
 IF @WEDate IS NOT NULL
 SET @Weekending = @WEDate
 --SELECT  @Weekending
 
 DECLARE @FromDate as Date = ( SELECT TOP 1 FromDate FROM NewMYDB_PROD..TBL_Weekending WHERE WEdate = @Weekending)


 DROP TABLE IF EXISTS #ActiveBA
SELECT IndependentContractorId, BadgeNo,IndependentContractorLevelId, EffectiveAdvancementDate, B.Code as 'MCCode' INTO #ActiveBA FROM Mst_IndependentContractor A LEFT JOIN Mst_MarketingCompany B ON A.MarketingCompanyId = B.MarketingCompanyId
WHERE B.CountryCode = 'TW' and A.StartDate <=@Weekending and (A.LastDeactivateDate  >= @FromDate or A.LastDeactivateDate is null)
AND ISNULL(A.LastDeactivateDate,'1900-01-01') >= CASE WHEN A.StartDate >=@FromDate THEN @Weekending ELSE '1900-01-01' END


--Removing Re-activate for advancement weekending 2024-01-28 YKW
SELECT A.IndependentContractorId, A.IndependentContractorLevelId, A.PromotionDemotionDate as 'EffectiveDate' INTO #BAEffectiveDate  FROM Mst_IndependentContractor_Movement A 
INNER JOIN (
	SELECT Z.IndependentContractorId, Z.PromotionDemotionDate ,MAX(Z.CreatedDate) CreatedDate
	FROM Mst_IndependentContractor_Movement Z INNER JOIN (
		SELECT IndependentContractorId, MAX(PromotionDemotionDate) EffectiveDate FROM Mst_IndependentContractor_Movement
		where Description in ('Advance','New-Recruit','New Recruit','De-advance','New-IC','Re-train','Demote') and IndependentContractorLevelId is not null
		and IndependentContractorId in (SELECT IndependentContractorId from #ActiveBA) and PromotionDemotionDate < @Weekending and IsDeleted = 0 GROUP BY IndependentContractorId
	) X ON Z.IndependentContractorId = X.IndependentContractorId and Z.PromotionDemotionDate = X.EffectiveDate
	GROUP BY Z.IndependentContractorId, Z.PromotionDemotionDate
) B ON A.IndependentContractorId = B.IndependentContractorId and A.PromotionDemotionDate = B.PromotionDemotionDate and A.CreatedDate = B.CreatedDate
WHERE A.IndependentContractorLevelId is not null and IsDeleted = 0 
 



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



 -- Populating Relationship -------------------------------------------------------------------------
 -- (START)
 -- -------------------------------------------------------------------------------------------------
SELECT WeDate, DirectReportBadgeNo, BadgeNo,A.LevelCode, B.LevelID, BadgeNoLink INTO #TXN_ReportingBadge FROM NewTWDB_PROD..Mst_TeamStructure A 
LEFT JOIN NewTWDB_PROD..VW_MST_LEVEL B
ON CASE WHEN A.LevelCode = 'FR' THEN 'IC' ELSE A.LevelCode END = B.LevelCode
where wedate = @Weekending and A.BadgeNo in (SELECT BadgeNo FROM #ActiveBA)

 INSERT INTO #RawData (MOCode, BadgeNo, PersonalPayable, PersonalSalesPieces ) 
SELECT MOCode, BadgeID, SUM_ICSTROKE, SUM_Pieces FROM NewTWDB_PROD..Txn_CH_ICE A LEFT JOIN NewTWDB_PROD..VW_MST_LEVEL B ON A.BAlevel = B.LevelCode
where wedate = @Weekending



 
UPDATE TXN_WeeklyBASummary SET isdeleted = 1 where WEdate = @Weekending and CountryCode = 'TW'
 
INSERT INTO TXN_WeeklyBASummary(WeDate,CountryCode, MCCode, IndependentContractorID,BadgeNo,CurrentLevel,WELevel,
BadgeNoLink,DirectReportBadgeNo,LevelPromotionDate,NetPoint,NetValue,NetPcs,SubPcs, CreatedDate,IsDeleted)
 SELECT @Weekending,'TW',A.MCCode, A.IndependentContractorId, A.BadgeNo, ISNULL(E.levelCode, D.LevelCode),ISNULL(G.LevelCode,ISNULL(E.levelCode, D.levelCode)),
 F.BadgeNoLink,F.DirectReportBadgeNo,ISNULL(C.EffectiveDate, A.EffectiveAdvancementDate), 
 0.00,B.PersonalPayable,B.PersonalSalesPieces,B.PersonalSalesPieces, @CDate, 0 FROM #ActiveBA A 
 LEFT JOIN #RawData B ON A.BadgeNo = B.BadgeNo
LEFT JOIN #BAEffectiveDate C ON A.IndependentContractorId = C.IndependentContractorId
LEFT JOIN Mst_IndependentContractorLevel D ON A.IndependentContractorLevelId = D.IndependentContractorLevelId
LEFT JOIN Mst_IndependentContractorLevel E ON C.IndependentContractorLevelId = E.IndependentContractorLevelId
LEFT JOIN #TXN_ReportingBadge F ON A.BadgeNo = F.BadgeNo
LEFT JOIN #BAWeekendingLevel G ON A.IndependentContractorId = G.IndependentContractorId 
 

END 


