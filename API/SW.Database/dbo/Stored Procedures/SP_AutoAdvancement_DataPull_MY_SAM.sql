--EXEC [SP_AutoAdvancement_DataPull_MY_SAM] '2023-05-12'
--=============================
CREATE PROCEDURE [dbo].[SP_AutoAdvancement_DataPull_MY_SAM] 
	@WEDate DATE
AS
BEGIN
 
DECLARE @BADGE as NVARCHAR(20)
DECLARE @LOOP AS BIT = 1	   

 DECLARE @Weekending as Date =    (SELECT TOP 1 WEdate  FROM (
 SELECT TOP 1 * FROM NewMYDB_PROD..Tbl_Weekending WHERE WEdate <  CAST(GETDATE() as DATE) ORDER BY WEdate desc
 ) B ORDER BY B.WEdate ASC)
 DECLARE @CDate as datetime = GETDATE()
 
 IF @WEDate IS NOT NULL
 SET @Weekending = @WEDate

 DECLARE @FromDate as Date = ( SELECT TOP 1 FromDate FROM NewMYDB_PROD..TBL_Weekending WHERE WEdate = @Weekending)

  DROP TABLE IF EXISTS #ActiveBA
SELECT IndependentContractorId, BadgeNo,IndependentContractorLevelId, EffectiveAdvancementDate, B.Code as 'MCCode' INTO #ActiveBA FROM Mst_IndependentContractor A LEFT JOIN Mst_MarketingCompany B ON A.MarketingCompanyId = B.MarketingCompanyId
WHERE B.CountryCode = 'MY' and A.StartDate <=@Weekending and (A.LastDeactivateDate  >= @FromDate or A.LastDeactivateDate is null)
AND ISNULL(A.LastDeactivateDate,'1900-01-01') >= CASE WHEN A.StartDate >=@FromDate THEN @Weekending ELSE '1900-01-01' END
 
 SELECT * FROM #ActiveBA where badgeno = 'TT0016'
--SELECT * FROM TXN_CH_ICE where WEDate = '2021-07-15' and OfficeId = 'VP' and channelID = 'TOTAL' and ICbadgeNo = 'VP0319'
IF object_id('tempdb..#FinalData') IS NOT  NULL DROP TABLE #FinalData
CREATE Table #FinalData
(	 
	CountryCode NVARCHAR(10),
	MOCode NVARCHAR(10), 
	BadgeNo NVARCHAR(20), 
	TotalPayable DECIMAL(18,2),  
	PersonalSalesPieces INT 
)

--Removing Re-activate for advancement weekending 2024-01-28 YKW
SELECT A.IndependentContractorId, A.IndependentContractorLevelId, ISNULL(A.PromotionDemotionDate,A.EffectiveDate) as 'EffectiveDate' INTO #BAEffectiveDate  FROM Mst_IndependentContractor_Movement A 
INNER JOIN (
	SELECT Z.IndependentContractorId, ISNULL(Z.PromotionDemotionDate,Z.EffectiveDate) as 'PromotionDemotionDate' ,MAX(Z.CreatedDate) CreatedDate
	FROM Mst_IndependentContractor_Movement Z INNER JOIN (
		SELECT IndependentContractorId, MAX(ISNULL( PromotionDemotionDate, EffectiveDate)) EffectiveDate FROM Mst_IndependentContractor_Movement
		where Description in ('Advance','New-Recruit','New Recruit','De-advance','New-IC','Re-train','Demote') and IndependentContractorLevelId is not null
		and IndependentContractorId in (SELECT IndependentContractorId from #ActiveBA) and ISNULL(PromotionDemotionDate,EffectiveDate) < @Weekending and IsDeleted = 0 GROUP BY IndependentContractorId
	) X ON Z.IndependentContractorId = X.IndependentContractorId and ISNULL(Z.PromotionDemotionDate,Z.EffectiveDate) = X.EffectiveDate
	GROUP BY Z.IndependentContractorId, ISNULL(Z.PromotionDemotionDate,Z.EffectiveDate)
) B ON A.IndependentContractorId = B.IndependentContractorId and ISNULL(A.PromotionDemotionDate,A.EffectiveDate) = B.PromotionDemotionDate and A.CreatedDate = B.CreatedDate
WHERE A.IndependentContractorLevelId is not null and IsDeleted = 0 


	SELECT '1', Z.IndependentContractorId, ISNULL(Z.PromotionDemotionDate,Z.EffectiveDate) as 'PromotionDemotionDate' ,MAX(Z.CreatedDate) CreatedDate
	FROM Mst_IndependentContractor_Movement Z INNER JOIN (
		SELECT IndependentContractorId, MAX(ISNULL( PromotionDemotionDate, EffectiveDate)) EffectiveDate FROM Mst_IndependentContractor_Movement
		where Description in ('Advance','Re-activate','New-Recruit','New Recruit','De-advance','Re-activate','Reactivate','New-IC','Re-train','Demote') and IndependentContractorLevelId is not null
		and IndependentContractorId in (SELECT IndependentContractorId from #ActiveBA) and PromotionDemotionDate < @Weekending and IsDeleted = 0 GROUP BY IndependentContractorId
	) X ON Z.IndependentContractorId = X.IndependentContractorId and ISNULL(Z.PromotionDemotionDate,Z.EffectiveDate) = X.EffectiveDate
	where Z.IndependentContractorId = 11718
	GROUP BY Z.IndependentContractorId, ISNULL(Z.PromotionDemotionDate,Z.EffectiveDate)


		SELECT '2', IndependentContractorId, MAX(ISNULL( PromotionDemotionDate, EffectiveDate)) EffectiveDate FROM Mst_IndependentContractor_Movement
		where Description in ('Advance','Re-activate','New-Recruit','New Recruit','De-advance','Re-activate','Reactivate','New-IC','Re-train','Demote') and IndependentContractorLevelId is not null
		and IndependentContractorId in (SELECT IndependentContractorId from #ActiveBA) and PromotionDemotionDate < @Weekending and IsDeleted = 0 		and IndependentContractorId = 11718 GROUP BY IndependentContractorId


				SELECT '3', * FROM Mst_IndependentContractor_Movement
		where Description in ('Advance','Re-activate','New-Recruit','New Recruit','De-advance','Re-activate','Reactivate','New-IC','Re-train','Demote') and IndependentContractorLevelId is not null
		and IndependentContractorId in (SELECT IndependentContractorId from #ActiveBA) and PromotionDemotionDate < @Weekending 
		and IsDeleted = 0 		and IndependentContractorId = 11718 


SELECT * FROM #BAEffectiveDate where IndependentContractorId = 11718


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

UPDATE A SET A.EffectiveAdvancementDate = B.PromotionDemotionDate FROM #ActiveBA A 
LEFT JOIN #BALatestMovement B ON A.IndependentContractorId = B.IndependentContractorId
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
SELECT Country, MOCode, ICBadgeNo as 'BadgeNo' , SUM(Pcs) as Pcs, 
--SUM(ActualPay) as 'ActualPay'
CASE WHEN @Weekending >= B.StartDate AND @Weekending <= EndDate AND MOCode IN  ('AR','MV','BH','JD','JV','VJ ','ND','GB','MP','VP','MB') THEN SUM(ActualPay) + SUM(SWBONUS) 
ELSE SUM(ActualPay) END as 'ActualPay'---- Ticket#2024051413000021 GETTING SW BONUS DETAILS
INTO #CharityRawData FROM (
SELECT 'MY' as 'Country', OfficeId as 'MOCode', ICBadgeNo, SUM(Sub_Pieces) as 'Pcs',
SUM(NET_ICStroke) as 'ActualPay' , SUM(APPCO_ExtraCommision) AS 'SWBONUS'
  FROM NewMYDB_PROD..TXN_CH_ICE A  WHERE WEDate = @Weekending and ChannelId = 'TOTAL'
  GROUP BY OfficeId, ICBadgeNo
union ALL
 SELECT Country , C.MOCode, A.BadgeID, SUM(SignUpPieces) as 'Pcs', SUM(TotalEarning) as 'ActualPay',0 AS 'SWBONUS' FROM Appco360_PROD..Txn_SalesImport A 
 LEFT JOIN NewMYDB_PROD..VW_ALLIC B ON A.BadgeID = B.BadgeNo
 LEFT JOIN NewMYDB_PROD..VW_MO C ON B.MOId = C.Id
 WHERE Country = 'MY' and    A.IsDeleted = 0 and A.Campaign in (SELECT ClientCode from  NewMYDB_PROD..VW_CampaignList where Division = 'CH') and WEDate = @Weekending
 GROUP BY Country , C.MOCode, A.BadgeID
 ) A
 LEFT JOIN TXN_BONUS B ON B.BonusType = 'SW BONUS' ---- Ticket#2024051413000021 GETTING SW BONUS DETAILS 
GROUP BY Country, MOCode, ICBadgeNo, B.StartDate, B.EndDate
 order by MOCode 

 SELECT @Weekending
IF object_id('tempdb..#TKFRawData') IS NOT NULL DROP TABLE #TKFRawData 
SELECT 'MY' as 'Country',OfficeId as 'MOCode', ICBadgeNo as 'BadgeNo', SUM(Gross_Pieces) as 'Pcs', SUM(NETT_ICStrokeValue) as ActualPay  INTO #TKFRawData
FROM NewMYDB_PROD..TXN_CO_ICE A  WHERE Client='TKF' and SubmissionWEDate = @Weekending
GROUP BY OfficeId,ICBadgeNo

IF object_id('tempdb..#STMBRawData') IS NOT NULL DROP TABLE #STMBRawData
SELECT 'MY' as 'Country',MoCode, BadgeID as 'BadgeNo', SUM(CASE WHEN Status ='SubmissionDate' THEN 1 ELSE 0 END) as 'Pcs',  SUM(icstroke * CASE WHEN Status in ('ClientRejectDate','RejectDate') THEN -1 ELSE 1 END) as 'ActualPay' INTO #STMBRawData
FROM NewMYDB_PROD..txn_commercial_statussummary WHERE statuswedate	 = @Weekending   and IsDeleted = 0
GROUP BY MOCode,BadgeID

IF object_id('tempdb..#ManualCO') IS NOT NULL DROP TABLE #ManualCO
 SELECT Country , C.MOCode, A.BadgeID as 'BadgeNo',  SUM(SignUpPieces) as 'Pcs', SUM(TotalEarning) as 'ActualPay' INTO #ManualCO FROM Appco360_PROD..Txn_SalesImport A 
 LEFT JOIN NewMYDB_PROD..VW_ALLIC B ON A.BadgeID = B.BadgeNo
 LEFT JOIN NewMYDB_PROD..VW_MO C ON B.MOId = C.Id
 WHERE Country = 'MY' and A.IsDeleted = 0-- and A.Campaign = 'My Term CI' 
 and WEDate = @Weekending --and Campaign = 'My Term CI'
 GROUP BY Country , C.MOCode, A.BadgeID

  
IF object_id('tempdb..#HASAVARawData') IS NOT NULL DROP TABLE #HASAVARawData
SELECT 'MY' as 'Country',MoCode, Agentid as 'BadgeNo', SUM(TTLPcs) as 'Pcs', SUM( TTLEarning) as 'ActualPay' INTO #HASAVARawData
FROM NewMYDB_PROD..TXN_CO_ICE_HASAVA WHERE WEDate	 = @Weekending  
GROUP BY MOCode,Agentid
 
IF object_id('tempdb..#LIFRawData') IS NOT NULL DROP TABLE #LIFRawData 
SELECT 'MY' as 'Country',A.MO_Code as 'MOCode', A.IC_Code as 'BadgeNo', SUM(Pieces) as 'Pcs',  SUM(ICStroke) as ActualPay  INTO #LIFRawData
FROM NewMYDB_PROD..TXN_LS_ICE A  WHERE  SubmissionWE = @Weekending --and A.Client ='S2U'
GROUP BY MO_Code, A.IC_Code 
 
 SELECT 'CharityRawData' INFO, * FROM #CharityRawData WHERE BadgeNo IN ('GN0102','NA3547','JD0194','LO0804') 
   --EXEC [SP_AutoAdvancement_DataPull_MY_SAM] '2024-05-12'
	INSERT INTO #FinalData (CountryCode, MOCode,BadgeNo,PersonalSalesPieces,TotalPayable)
	SELECT 'MY',MOCode, BadgeNo, SUM(Pcs), SUM(ActualPay) as 'ActualPay' FROM (
	SELECT MOCode, BadgeNo, Pcs, ActualPay FROM #CharityRawData UNION ALL
	SELECT MOCode, BadgeNo, Pcs, ActualPay FROM #TKFRawData UNION ALL
	SELECT MOCode, BadgeNo, Pcs, ActualPay FROM #STMBRawData UNION ALL
	SELECT MOCode, BadgeNo, Pcs, ActualPay FROM #ManualCO UNION ALL
	SELECT MOCode, BadgeNo, Pcs, ActualPay FROM #HASAVARawData UNION ALL
	SELECT MOCode, BadgeNo, Pcs, ActualPay FROM #LIFRawData
	) A GROUP BY MOCode, BadgeNo
	 

DROP TABLE IF EXISTS #TXN_ReportingBadge
SELECT A.*, C.IndependentContractorLevelId INTO #TXN_ReportingBadge FROM NewMYDB_PROD..TXN_ReportingBadge A 
LEFT JOIN NewOlaf_Prod..Mst_IndependentContractorLevel C ON A.CurrentLevel = C.LevelCode where wedate = @Weekending
and A.BadgeNo in (SELECT BadgeNo FROM #ActiveBA)
 
 
--UPDATE TXN_WeeklyBASummary SET isdeleted = 1 where WEdate = @Weekending and CountryCode = 'MY'
 
--INSERT INTO TXN_WeeklyBASummary(WeDate,CountryCode,MCCode,IndependentContractorID,BadgeNo,CurrentLevel,WELevel,
--BadgeNoLink,DirectReportBadgeNo,LevelPromotionDate,NetPoint,NetValue,SubPcs,CreatedDate,IsDeleted)

 SELECT  @Weekending 'WeDate','MY' 'CountryCode',A.MCCode, A.IndependentContractorId, A.BadgeNo, ISNULL(E.levelCode, D.LevelCode) CurrentLevel,
 ISNULL(G.LevelCode,ISNULL(E.levelCode, D.levelCode))WELevel, F.BadgeNolink, F.DirectReportBadgeNumber,
 ISNULL(C.EffectiveDate, A.EffectiveAdvancementDate)LevelPromotionDate, 0.00 NetPoint, B.TotalPayable NetValue, PersonalSalesPieces SubPcs ,@CDate CreatedDate, 0 IsDeleted FROM #ActiveBA A 
 LEFT JOIN #FinalData B ON A.BadgeNo = B.BadgeNo
LEFT JOIN #BAEffectiveDate C ON A.IndependentContractorId = C.IndependentContractorId
LEFT JOIN Mst_IndependentContractorLevel D ON A.IndependentContractorLevelId = D.IndependentContractorLevelId
LEFT JOIN Mst_IndependentContractorLevel E ON C.IndependentContractorLevelId = E.IndependentContractorLevelId
 LEFT JOIN #TXN_ReportingBadge F ON A.BadgeNo = F.BadgeNo
LEFT JOIN #BAWeekendingLevel G ON A.IndependentContractorId = G.IndependentContractorId 


DROP TABLE #FinalData 

END
  