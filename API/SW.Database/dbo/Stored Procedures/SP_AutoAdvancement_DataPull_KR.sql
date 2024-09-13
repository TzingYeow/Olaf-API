--EXEC SP_AutoAdvancement_DataPull_KR NULL
--=============================
CREATE PROCEDURE [dbo].[SP_AutoAdvancement_DataPull_KR]   
	@WEDate DATE
AS
BEGIN

DECLARE @BADGE as NVARCHAR(20)
DECLARE @LOOP AS BIT = 1	
DECLARE @RTPerc as Decimal(18,2) = 1.0-- 0.7 -- RoadTrip only get 70%
DECLARE @CDate as datetime = GETDATE()

DECLARE @Weekending as Date =    (SELECT TOP 1 WEdate  FROM (
SELECT TOP 1 * FROM Appco360_PROD..MST_Weekending WHERE Country = 'KR' and WEdate <  CAST(GETDATE() as DATE) ORDER BY WEdate desc
) B ORDER BY B.WEdate ASC) 
 
 IF @WEDate IS NOT NULL
 SET @Weekending = @WEDate

 DECLARE @FromDate as Date = ( SELECT TOP 1 FromDate FROM Appco360_PROD..MST_Weekending WHERE WEdate = @Weekending and Country = 'KR')
 
DROP TABLE IF EXISTS #RawData
CREATE Table #RawData
(	  
	MOCode NVARCHAR(10), 
	BadgeNo NVARCHAR(20),  
	PersonalPayable DECIMAL(18,2),
	PersonalSalesPieces INT,
	PersonalSubPieces INT

)
 DROP TABLE IF EXISTS #ActiveBA
SELECT IndependentContractorId, BadgeNo, IndependentContractorLevelId, EffectiveAdvancementDate, B.Code as 'MCCode' INTO #ActiveBA FROM Mst_IndependentContractor A LEFT JOIN Mst_MarketingCompany B ON A.MarketingCompanyId = B.MarketingCompanyId
WHERE B.CountryCode = 'KR' and A.StartDate <=@Weekending and (A.LastDeactivateDate  >=@FromDate or A.LastDeactivateDate is null)
AND ISNULL(A.LastDeactivateDate,'1900-01-01') >= CASE WHEN A.StartDate >=@FromDate THEN @Weekending ELSE '1900-01-01' END
and A.IsDeleted =0

--SELECT A.IndependentContractorId, A.IndependentContractorLevelId, A.EffectiveDate INTO #BAEffectiveDate FROM Mst_IndependentContractor_Movement A INNER JOIN (
--SELECT IndependentContractorId, MAX(EffectiveDate) EffectiveDate FROM Mst_IndependentContractor_Movement
--where Description in ('Advance','Re-activate','New-Recruit','New Recruit','De-advance','New-IC','Re-train','Demote') and IndependentContractorLevelId is not null
--and IndependentContractorId in (SELECT IndependentContractorId from #ActiveBA) and EffectiveDate < @Weekending and IsDeleted = 0 GROUP BY IndependentContractorId
--) B ON A.IndependentContractorId = B.IndependentContractorId and A.EffectiveDate = B.EffectiveDate
--WHERE A.IndependentContractorLevelId is not null and IsDeleted = 0

 DROP TABLE IF EXISTS #Mst_IndependentContractor_Movement
 SELECT * INTO #Mst_IndependentContractor_Movement FROM Mst_IndependentContractor_Movement WHERE IndependentContractorId in (
	SELECT IndependentContractorId FROM #ActiveBA GROUP BY IndependentContractorId
 ) and IsDeleted = 0
 
--SELECT A.IndependentContractorId, A.IndependentContractorLevelId, A.PromotionDemotionDate as 'EffectiveDate' INTO #BAEffectiveDate  FROM Mst_IndependentContractor_Movement A 
--INNER JOIN (
--	SELECT Z.IndependentContractorId, Z.PromotionDemotionDate ,MAX(Z.CreatedDate) CreatedDate
--	FROM Mst_IndependentContractor_Movement Z INNER JOIN (
--		SELECT IndependentContractorId, MAX(PromotionDemotionDate) EffectiveDate FROM Mst_IndependentContractor_Movement
--		where Description in ('Advance','Re-activate','New-Recruit','New Recruit','De-advance','New-IC','Re-train','Demote') and IndependentContractorLevelId is not null
--		and IndependentContractorId in (SELECT IndependentContractorId from #ActiveBA) and PromotionDemotionDate < @Weekending and IsDeleted = 0 GROUP BY IndependentContractorId
--	) X ON Z.IndependentContractorId = X.IndependentContractorId and Z.PromotionDemotionDate = X.EffectiveDate
--	GROUP BY Z.IndependentContractorId, Z.PromotionDemotionDate
--) B ON A.IndependentContractorId = B.IndependentContractorId and A.PromotionDemotionDate = B.PromotionDemotionDate and A.CreatedDate = B.CreatedDate
--WHERE A.IndependentContractorLevelId is not null and IsDeleted = 0 


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

 

DROP TABLE IF EXISTS #BALatestMovement
SELECT A.IndependentContractorId, MAX(A.PromotionDemotionDate) PromotionDemotionDate INTO #BALatestMovement FROM #Mst_IndependentContractor_Movement A 
INNER JOIN  #ActiveBA B 
	ON A.IndependentContractorId = B.IndependentContractorId and A.IndependentContractorLevelId = B.IndependentContractorLevelId and A.Description='Advance'
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


DROP TABLE IF EXISTS #TXN_ReportingBadge
SELECT WeDate, C.BadgeNo as 'DirectReportBadgeNumber', B.BadgeNo as 'BadgeNo', A.IndependentContractorLevelId, BadgeNolink INTO #TXN_ReportingBadge FROM Appco360_PROD..TXN_ReportingBadge_KR A 
LEFT JOIN NewOlaf_Prod..Mst_IndependentContractor B ON A.IndependentContractorId = B.IndependentContractorId
LEFT JOIN NewOlaf_Prod..Mst_IndependentContractor C ON A.ReportToIndependentContractorId = C.IndependentContractorId
WHERE A.WeDate = @Weekending and B.IndependentContractorId in (SELECT IndependentContractorId from #ActiveBA)


  
INSERT INTO #RawData (MOCode, BadgeNo, PersonalPayable, PersonalSalesPieces,PersonalSubPieces )
SELECT C.Code as 'MOCode', A.FRID as 'BadgeNo', 
SUM(CASE WHEN A.Type in('Sub','Resub') THEN A.Amount ELSE A.Amount * -1 END) as 'PersonalPayable',
SUM(CASE WHEN A.Type = 'Sub' THEN A.Pieces WHEN A.Type = 'Reject' THEN  A.Pieces * -1 ELSE 0  END) as 'PersonalPieces',
SUM(A.SubPieces) as 'PersonalSubPieces'
FROM (
	SELECT CASE WHEN ISNULL(SubType,'') = 'CLIENTRESUB' THEN 'Resub' ELSE 'Sub' end as 'Type',  
	SUM(CASE WHEN ISNULL(SubType,'') = '' THEN 1 ELSE 0 END) as 'SubPieces',
	FRID, SUM(FRStroke *  CASE WHEN ISNULL(RoadTrip,'') = 'Yes' THEN @RTPerc ELSE 1 END) + SUM(ISNULL(AdditionalFRStroke,0.00)) as 'Amount', 
	COUNT(*) as 'Pieces' FROM Appco360_PROD..MainTable WHERE MOSubWE  = @Weekending and PaidAmount <> 0 and OfficeID <> 'HQ'
	GROUP BY FRID,SubType
	UNION ALL
	SELECT CASE WHEN  appcostatus ='CLIENTREJECT' THEN 'ClientReject' ELSE  'Reject' END as 'Type',0 as 'SubPieces', 
	FRID, SUM(FRStroke  *  CASE WHEN ISNULL(RoadTrip,'') = 'Yes' THEN @RTPerc ELSE 1 END) + SUM(ISNULL(AdditionalFRStroke,0.00)) as 'Amount', COUNT(*) as 'Pieces' FROM Appco360_PROD..MainTable WHERE MORejectWE  = @Weekending and PaidAmount <> 0 and OfficeID <> 'HQ'
	GROUP BY FRID, appcostatus
) A 
LEFT JOIN NewOlaf_PROD..MST_IndependentContractor B ON A.FRID = B.BadgeNo collate Latin1_General_CI_AI
LEFT JOIN NewOlaf_Prod..Mst_MarketingCompany C ON B.MarketingCompanyId = C.MarketingCompanyId
WHERE C.CountryCode = 'KR' and B.IsDeleted = 0 --and B.Status = 'Active'
GROUP BY C.Code, A.FRID 
 
  
UPDATE TXN_WeeklyBASummary SET isdeleted = 1 where WEdate = @Weekending and CountryCode = 'KR'

INSERT INTO TXN_WeeklyBASummary(WeDate,CountryCode,MCCode,IndependentContractorID,BadgeNo,CurrentLevel,WELevel,
BadgeNoLink,DirectReportBadgeNo,LevelPromotionDate,NetPoint,NetValue,NetPcs,CreatedDate,IsDeleted, SubPcs) 
SELECT @Weekending,'KR', A.MCCode, A.IndependentContractorId, A.BadgeNo, ISNULL(E.levelCode, D.levelCode),ISNULL(G.LevelCode,ISNULL(E.levelCode, D.levelCode)) ,F.BadgeNolink,
F.DirectReportBadgeNumber, ISNULL(C.EffectiveDate, A.EffectiveAdvancementDate), 0.00, ISNULL(PersonalPayable,0.00), ISNULL(PersonalSalesPieces,0), @CDate, 0 ,
ISNULL(B.PersonalSubPieces,0)
FROM #ActiveBA A 
LEFT JOIN #RawData B ON A.BadgeNo = B.BadgeNo
LEFT JOIN #BAEffectiveDate C ON A.IndependentContractorId = C.IndependentContractorId
LEFT JOIN Mst_IndependentContractorLevel D ON A.IndependentContractorLevelId = D.IndependentContractorLevelId
LEFT JOIN Mst_IndependentContractorLevel E ON C.IndependentContractorLevelId = E.IndependentContractorLevelId
LEFT JOIN #TXN_ReportingBadge F ON A.BadgeNo = F.BadgeNo
LEFT JOIN #BAWeekendingLevel G ON A.IndependentContractorId = G.IndependentContractorId 
--WHERE A.BadgeNo = 'NX00002'

SELECT @Weekending,'KR', A.MCCode, A.IndependentContractorId, A.BadgeNo, ISNULL(E.levelCode, D.levelCode),ISNULL(G.LevelCode,ISNULL(E.levelCode, D.levelCode)) ,F.BadgeNolink,
F.DirectReportBadgeNumber, ISNULL(C.EffectiveDate, A.EffectiveAdvancementDate), 0.00, ISNULL(PersonalPayable,0.00), ISNULL(PersonalSalesPieces,0), @CDate, 0 ,
ISNULL(B.PersonalSubPieces,0)
FROM #ActiveBA A 
LEFT JOIN #RawData B ON A.BadgeNo = B.BadgeNo
LEFT JOIN #BAEffectiveDate C ON A.IndependentContractorId = C.IndependentContractorId
LEFT JOIN Mst_IndependentContractorLevel D ON A.IndependentContractorLevelId = D.IndependentContractorLevelId
LEFT JOIN Mst_IndependentContractorLevel E ON C.IndependentContractorLevelId = E.IndependentContractorLevelId
LEFT JOIN #TXN_ReportingBadge F ON A.BadgeNo = F.BadgeNo
LEFT JOIN #BAWeekendingLevel G ON A.IndependentContractorId = G.IndependentContractorId 
WHERE A.BadgeNo = 'IN00007'

SELECT * FROM #BAEffectiveDate  where IndependentContractorId =73943
  
	END  
 --EXEC SP_AutoAdvancement_DataPull_KR NULL
  