--EXEC SP_AutoAdvancement_DataPull_Indo '2023-08-27'
--=============================
CREATE PROCEDURE [dbo].[SP_AutoAdvancement_DataPull_Indo] 
	@WEDate DATE
AS
BEGIN
 
DECLARE @BADGE as NVARCHAR(20)
DECLARE @LOOP AS BIT = 1	   

 
 DECLARE @Weekending as Date =    (SELECT TOP 1 WEdate  FROM (
 SELECT TOP 1 * FROM NewMYDB_PROD..Tbl_Weekending WHERE WEdate <  CAST(getdate() as DATE) ORDER BY WEdate desc
 ) B ORDER BY B.WEdate ASC)
 DECLARE @CDate as datetime = GETDATE()
 
 IF @WEDate IS NOT NULL
 SET @Weekending = @WEDate

 DECLARE @FromDate as Date = ( SELECT TOP 1 FromDate FROM NewMYDB_PROD..TBL_Weekending WHERE WEdate = @Weekending)

  DROP TABLE IF EXISTS #ActiveBA
SELECT IndependentContractorId, BadgeNo,IndependentContractorLevelId, EffectiveAdvancementDate, B.Code as 'MCCode' INTO #ActiveBA FROM Mst_IndependentContractor A LEFT JOIN Mst_MarketingCompany B ON A.MarketingCompanyId = B.MarketingCompanyId AND B.IsActive = 1
WHERE B.CountryCode = 'ID' and A.StartDate <=@Weekending and (A.LastDeactivateDate  >= @FromDate or A.LastDeactivateDate is null) 
AND ISNULL(A.LastDeactivateDate,'1900-01-01') >= CASE WHEN A.StartDate >=@FromDate THEN @Weekending ELSE '1900-01-01' END

 


IF object_id('tempdb..#FinalData') IS NOT  NULL DROP TABLE #FinalData
CREATE Table #FinalData
(	 
	CountryCode NVARCHAR(10),
	MOCode NVARCHAR(10), 
	BadgeNo NVARCHAR(20), 
	TotalPayable DECIMAL(18,2),  
	PersonalSalesPieces INT 
)

IF object_id('tempdb..#BAEffectiveDate') IS NOT  NULL DROP TABLE #BAEffectiveDate

--Removing Re-activate for advancement weekending 2024-01-28 YKW
SELECT A.IndependentContractorId, A.IndependentContractorLevelId, ISNULL(A.PromotionDemotionDate,A.EffectiveDate) as 'EffectiveDate' INTO #BAEffectiveDate  FROM Mst_IndependentContractor_Movement A 
INNER JOIN (
	SELECT Z.IndependentContractorId, ISNULL(Z.PromotionDemotionDate,Z.EffectiveDate) as 'PromotionDemotionDate' ,MAX(Z.CreatedDate) CreatedDate
	FROM Mst_IndependentContractor_Movement Z INNER JOIN (
		SELECT IndependentContractorId, MAX(ISNULL( PromotionDemotionDate, EffectiveDate)) EffectiveDate FROM Mst_IndependentContractor_Movement
		where Description in ('Advance','New-Recruit','New Recruit','De-advance' ,'New-IC','Re-train','Demote') and IndependentContractorLevelId is not null
		and IndependentContractorId in (SELECT IndependentContractorId from #ActiveBA) and ISNULL(PromotionDemotionDate,EffectiveDate) < @Weekending and IsDeleted = 0 GROUP BY IndependentContractorId
	) X ON Z.IndependentContractorId = X.IndependentContractorId and ISNULL(Z.PromotionDemotionDate,Z.EffectiveDate) = X.EffectiveDate
	GROUP BY Z.IndependentContractorId, ISNULL(Z.PromotionDemotionDate,Z.EffectiveDate)
) B ON A.IndependentContractorId = B.IndependentContractorId and ISNULL(A.PromotionDemotionDate,A.EffectiveDate) = B.PromotionDemotionDate and A.CreatedDate = B.CreatedDate
WHERE A.IndependentContractorLevelId is not null and IsDeleted = 0 




DROP TABLE IF EXISTS #Mst_IndependentContractor_Movement
SELECT * INTO #Mst_IndependentContractor_Movement FROM Mst_IndependentContractor_Movement WHERE IndependentContractorId in (
SELECT IndependentContractorId FROM #ActiveBA GROUP BY IndependentContractorId
) and IsDeleted = 0


DROP TABLE IF EXISTS #BALatestMovement
SELECT A.IndependentContractorId, MAX(A.PromotionDemotionDate) PromotionDemotionDate INTO #BALatestMovement FROM #Mst_IndependentContractor_Movement A 
INNER JOIN  #ActiveBA B 
	ON A.IndependentContractorId = B.IndependentContractorId and A.IndependentContractorLevelId = B.IndependentContractorLevelId and A.Description in ('Advance')
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


DROP TABLE IF EXISTS #Result
CREATE TABLE #Result(
	WeekendingDate DATE,
	MOCode NVARCHAR(20),
	CurrentLevel NVARCHAR(20),
	BadgeNo NVARCHAR(20),
	PersonalPayable  Decimal(18,2),
	TotalPayable  Decimal(18,2),
	TeamPoint Decimal(18,2),
	TeamSize INT,
	FirstGenLeader INT
)
 


IF object_id('tempdb..#CharityRawData') IS NOT NULL DROP TABLE #CharityRawData  
SELECT Country, MOCode, BadgeNo as 'BadgeNo' , SUM(Pcs) as Pcs, SUM(ActualPay) as 'ActualPay' INTO #CharityRawData FROM 
(SELECT 'ID' as 'Country', MOCode as 'MOCode', BadgeNo, SUM(SubsTotal) as 'Pcs',
SUM(GrossEarning) as 'ActualPay' FROM NewIndoDB_PROD..TXN_CH_ICE A  
INNER JOIN Mst_MarketingCompany B on A.MOCode = B.Code and B.CountryCode = 'ID' AND B.MarketingCompanyType <> 'RoadTrip'
WHERE WEDate = @Weekending GROUP BY MOCode, BadgeNo) A
GROUP BY Country, MOCode, BadgeNo 
order by MOCode

INSERT INTO #CharityRawData
SELECT Country, MOCode, BadgeNo as 'BadgeNo' , SUM(Pcs) as Pcs, SUM(ActualPay) as 'ActualPay'  FROM 
(SELECT 'ID' as 'Country', OfficeId as 'MOCode', ICBadgeNo as 'BadgeNo', SUM(Sub_Pieces) as 'Pcs',
SUM(NET_ICStroke) as 'ActualPay' FROM NewIndoDB_PROD..TXN_CH_ICE_MSFMODEL A  
INNER JOIN Mst_MarketingCompany B on A.OfficeId = B.Code and B.CountryCode = 'ID' AND B.MarketingCompanyType = 'RoadTrip'
WHERE WEDate = @Weekending AND A.ChannelId ='Total' GROUP BY OfficeId, ICBadgeNo) A
GROUP BY Country, MOCode, BadgeNo 
order by MOCode



INSERT INTO #FinalData (CountryCode, MOCode,BadgeNo,PersonalSalesPieces,TotalPayable)
SELECT 'ID',MOCode, BadgeNo, SUM(Pcs), SUM(ActualPay) as 'ActualPay' FROM (
SELECT MOCode, BadgeNo, Pcs, ActualPay FROM #CharityRawData 
) A GROUP BY MOCode, BadgeNo
	 

DROP TABLE IF EXISTS #TXN_ReportingBadge
SELECT A.*, C.IndependentContractorLevelId INTO #TXN_ReportingBadge FROM NewIndoDB_PROD..TXN_ReportingBadge A 
LEFT JOIN NewOlaf_Prod..Mst_IndependentContractorLevel C ON A.CurrentLevel = C.LevelCode where wedate = @Weekending
and A.BadgeNo in (SELECT BadgeNo FROM #ActiveBA)
 
 
UPDATE TXN_WeeklyBASummary SET isdeleted = 1 where WEdate = @Weekending and CountryCode = 'ID'
 
INSERT INTO TXN_WeeklyBASummary(WeDate,CountryCode,MCCode,IndependentContractorID,BadgeNo,CurrentLevel,WELevel,
BadgeNoLink,DirectReportBadgeNo,LevelPromotionDate,NetPoint,NetValue,SubPcs,CreatedDate,IsDeleted)


 SELECT  @Weekending as 'WeDate','ID' as 'CountryCode',A.MCCode, A.IndependentContractorId, A.BadgeNo, ISNULL(E.levelCode, D.LevelCode) as 'CurrentLevel',ISNULL(G.LevelCode,ISNULL(E.levelCode, D.levelCode)) as 'WELevel',
 F.BadgeNolink, F.DirectReportBadgeNumber,
 ISNULL(C.EffectiveDate, A.EffectiveAdvancementDate) as 'LevelPromotionDate', 0.00 as 'NetPoint', B.TotalPayable, PersonalSalesPieces ,@CDate as 'CreatedDate', 0 as 'IsDeleted' FROM #ActiveBA A 
LEFT JOIN #FinalData B ON A.BadgeNo = B.BadgeNo
LEFT JOIN #BAEffectiveDate C ON A.IndependentContractorId = C.IndependentContractorId
LEFT JOIN Mst_IndependentContractorLevel D ON A.IndependentContractorLevelId = D.IndependentContractorLevelId
LEFT JOIN Mst_IndependentContractorLevel E ON C.IndependentContractorLevelId = E.IndependentContractorLevelId
LEFT JOIN #TXN_ReportingBadge F ON A.BadgeNo = F.BadgeNo
LEFT JOIN #BAWeekendingLevel G ON A.IndependentContractorId = G.IndependentContractorId 


END
  