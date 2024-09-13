--EXEC SP_RPT_TeamPerformanceTracking_Test
--=============================
CREATE PROCEDURE [dbo].[SP_RPT_TeamPerformanceTracking_Test]
 
AS
BEGIN
	  
	   

 DECLARE @Weekending as Date =    (SELECT TOP 1 WEdate  FROM (
 SELECT TOP 2 * FROM NewMYDB_PROD..Tbl_Weekending WHERE WEdate <= GETDATE() ORDER BY WEdate desc
 ) B ORDER BY B.WEdate ASC)

--SELECT * FROM TXN_CH_ICE where WEDate = '2021-07-15' and OfficeId = 'VP' and channelID = 'TOTAL' and ICbadgeNo = 'VP0319'
IF object_id('tempdb..#FinalData') IS NOT  NULL DROP TABLE #FinalData
CREATE Table #FinalData
(	 
	CountryCode NVARCHAR(10),
	MOCode NVARCHAR(10),
	MOName NVARCHAR(200),
	Campaign NVARCHAR(50),
	TotalPayable DECIMAL(18,2),
	AcwireBonus DECIMAL(18,2),
	GrandTotal DECIMAL(18,2),
	BulletinPoint DECIMAL(18,2)
)


--IF object_id('tempdb..#Rate') IS NOT NULL DROP TABLE #Rate 
--SELECT CodeId, CAST(CodeName as decimal(18,2)) as 'Rate' INTO #Rate FROM MST_MASTERCODE WHERE CodeType = 'PerfTrack'

IF object_id('tempdb..#CharityRawData') IS NOT NULL DROP TABLE #CharityRawData 
--SELECT 'MY' as 'Country', OfficeId as 'MOCode', Client, SUM(AcwireBonus) + SUM(AcwireDeductionBonus)  as 'AcwireBonus',
--SUM(NET_ICStroke) as 'ActualPay' 
--INTO #CharityRawData FROM NewMYDB_PROD..TXN_CH_ICE A  WHERE WEDate = @Weekending and ChannelId = 'TOTAL'
--GROUP BY OfficeId, Client
SELECT Country, MOCode, Client , SUM(AcwireBonus) as 'AcwireBonus', SUM(ActualPay) as 'ActualPay' INTO #CharityRawData FROM (
SELECT 'MY' as 'Country', OfficeId as 'MOCode', Client, SUM(AcwireBonus) + SUM(AcwireDeductionBonus)  as 'AcwireBonus',
SUM(NET_ICStroke) as 'ActualPay' 
  FROM NewMYDB_PROD..TXN_CH_ICE A  WHERE WEDate = @Weekending and ChannelId = 'TOTAL'
  GROUP BY OfficeId, Client
union ALL
 SELECT Country , C.MOCode, Campaign, SUM(DigitalBonus) as 'AcwireBonus', SUM(TotalEarning) as 'ActualPay' FROM Appco360_PROD..Txn_SalesImport A 
 LEFT JOIN NewMYDB_PROD..VW_ALLIC B ON A.BadgeID = B.BadgeNo
 LEFT JOIN NewMYDB_PROD..VW_MO C ON B.MOId = C.Id
 WHERE Country = 'MY' and    A.IsDeleted = 0 and A.Campaign in (SELECT ClientCode from  NewMYDB_PROD..VW_CampaignList where Division = 'CH') and WEDate = @Weekending
 GROUP BY Country , C.MOCode, Campaign
 ) A
 GROUP BY Country, MOCode, Client 
 order by MOCode
 

IF object_id('tempdb..#TKFRawData') IS NOT NULL DROP TABLE #TKFRawData 
SELECT OfficeId as 'MOCode', SUM(NETT_ICStrokeValue) as ActualPay  INTO #TKFRawData
FROM NewMYDB_PROD..TXN_CO_ICE A  WHERE Client='TKF' and SubmissionWEDate = @Weekending
GROUP BY OfficeId

IF object_id('tempdb..#STMBRawData') IS NOT NULL DROP TABLE #STMBRawData
SELECT MoCode, SUM( icstroke * CASE WHEN Status in ('ClientRejectDate','RejectDate') THEN -1 ELSE 1 END) as 'ActualPay' INTO #STMBRawData
FROM NewMYDB_PROD..txn_commercial_statussummary WHERE statuswedate	 = @Weekending   and IsDeleted = 0
GROUP BY MOCode

IF object_id('tempdb..#ManualCO') IS NOT NULL DROP TABLE #ManualCO
 SELECT Country , C.MOCode, Campaign, SUM(DigitalBonus) as 'AcwireBonus', SUM(TotalEarning) as 'ActualPay' INTO #ManualCO FROM Appco360_PROD..Txn_SalesImport A 
 LEFT JOIN NewMYDB_PROD..VW_ALLIC B ON A.BadgeID = B.BadgeNo
 LEFT JOIN NewMYDB_PROD..VW_MO C ON B.MOId = C.Id
 WHERE Country = 'MY' and A.Campaign = 'My Term CI' and A.IsDeleted = 0
 and WEDate = @Weekending and Campaign = 'My Term CI'
 GROUP BY Country , C.MOCode, Campaign



IF object_id('tempdb..#HASAVARawData') IS NOT NULL DROP TABLE #HASAVARawData
SELECT MoCode, SUM( TTLEarning) as 'ActualPay' INTO #HASAVARawData
FROM NewMYDB_PROD..TXN_CO_ICE_HASAVA WHERE WEDate	 = @Weekending  
GROUP BY MOCode
 

INSERT INTO #FinalData(CountryCode, Campaign, MOCode)
select distinct 'MY' as 'CountryCode',         
stuff((select ', ' + t.Client from #CharityRawData t where t.MOCode = p.MOCode order by MOCode for xml path('')),1,2,'') as taglist        
,MOCode       
from #CharityRawData p        
order by MOCode; 


UPDATE A SET A.TotalPayable = B.ActualPay , A.AcwireBonus = B.AcwireBonus, A.GrandTotal = B.ActualPay + B.AcwireBonus FROM #FinalData A LEFT JOIN (SELECT MOCode, SUM(ActualPay) as ActualPay, SUM(AcwireBonus) as AcwireBonus  FROM #CharityRawData GROUP BY MOCode) B ON A.MOCode = B.MOCode

SELECT * FROM #FinalData  where MOCode = 'CM'
SELECT  * FROM #TKFRawData where MOCode = 'CM'
--Add TAKAFUL
UPDATE A SET A.TotalPayable = A.TotalPayable + B.ActualPay, A.GrandTotal = A.GrandTotal + B.ActualPay,   A.Campaign = A.Campaign + ', TKF' FROM #FinalData A INNER JOIN #TKFRawData B ON A.MOCode = B.MOCode
INSERT INTO #FinalData 
SELECT  'MY',  A.MOCode, '', 'TKF', A.ActualPay, 0.00, A.ActualPay,0.00  FROM #TKFRawData A LEFT JOIN #FinalData B ON A.MOCode = B.MOCode
WHERE B.MOCode is null

--Add STMB
UPDATE A SET A.TotalPayable = A.TotalPayable + B.ActualPay, A.GrandTotal = A.GrandTotal + B.ActualPay,   A.Campaign = A.Campaign + ', STMB' FROM #FinalData A INNER JOIN #STMBRawData B ON A.MOCode = B.MOCode
INSERT INTO #FinalData 
SELECT  'MY',  A.MOCode, '', 'STMB', A.ActualPay, 0.00, A.ActualPay,0.00  FROM #STMBRawData A LEFT JOIN #FinalData B ON A.MOCode = B.MOCode
WHERE B.MOCode is null

--#ManualCO
UPDATE A SET A.TotalPayable = A.TotalPayable + B.ActualPay, A.GrandTotal = A.GrandTotal + B.ActualPay,   A.Campaign = A.Campaign + ', TermCI' FROM #FinalData A INNER JOIN #ManualCO B ON A.MOCode = B.MOCode
INSERT INTO #FinalData 
SELECT  'MY',  A.MOCode, '', 'TermCI', A.ActualPay, 0.00, A.ActualPay,0.00  FROM #ManualCO A LEFT JOIN #FinalData B ON A.MOCode = B.MOCode
WHERE B.MOCode is null

--Add HASAVA
UPDATE A SET A.TotalPayable = A.TotalPayable + B.ActualPay, A.GrandTotal = A.GrandTotal + B.ActualPay,   A.Campaign = A.Campaign + ', HASAVA' FROM #FinalData A INNER JOIN #HASAVARawData B ON A.MOCode = B.MOCode
INSERT INTO #FinalData 
SELECT  'MY',  A.MOCode, '', 'HASAVA', A.ActualPay, 0.00, A.ActualPay,0.00  FROM #HASAVARawData A LEFT JOIN #FinalData B ON A.MOCode = B.MOCode
WHERE B.MOCode is null


-- ADD LIFESTYLE LOOPING
 IF object_id('tempdb..#LIFCLient') IS NOT NULL DROP TABLE #LIFCLient 
SELECT distinct client INTO #LIFCLient FROM NewMYDB_PROD..TXN_LS_ICE  where SubmissionWE = '2021-09-16'

 
DECLARE @LoopCampaign as NVARCHAR(25)
DECLARE @Loop as INT 
SET @Loop = 1
WHILE @Loop = 1
BEGIN
 
 SELECT TOP 1 @LoopCampaign = Client  FROM #LIFCLient   order by Client
 
SET @Loop = 0

 IF object_id('tempdb..#LIFRawData') IS NOT NULL DROP TABLE #LIFRawData 
SELECT A.MO_Code as 'MOCode', A.Client,  SUM(ICStroke) as ActualPay  INTO #LIFRawData
FROM NewMYDB_PROD..TXN_LS_ICE A  WHERE  SubmissionWE = @Weekending and A.Client = @LoopCampaign
GROUP BY MO_Code,Client 

UPDATE A SET A.TotalPayable = A.TotalPayable + B.ActualPay, A.GrandTotal = A.GrandTotal + B.ActualPay,   A.Campaign = A.Campaign + ', ' + B.Client FROM #FinalData A INNER JOIN #LIFRawData B ON A.MOCode = B.MOCode
INSERT INTO #FinalData 
SELECT  'MY',  A.MOCode, '',A.Client, A.ActualPay, 0.00, A.ActualPay,0.00  FROM #LIFRawData A LEFT JOIN #FinalData B ON A.MOCode = B.MOCode
WHERE B.MOCode is null



DELETE FROM #LIFCLient WHERE Client = @LoopCampaign

  if (SELECT COUNT(*) FROM #LIFCLient ) > 0
  BEGIN
	SET @Loop = 1
  END
  ELSE
  BEGIN
	SET @Loop = 0
  END

END


----Add LIFESTYLE
--UPDATE A SET A.TotalPayable = A.TotalPayable + B.ActualPay, A.GrandTotal = A.GrandTotal + B.ActualPay,   A.Campaign = A.Campaign + ', ' + B.Client FROM #FinalData A INNER JOIN #LIFRawData B ON A.MOCode = B.MOCode
--INSERT INTO #FinalData 
--SELECT  'MY',  A.MOCode, '',A.Client, A.ActualPay, 0.00, A.ActualPay,0.00  FROM #LIFRawData A LEFT JOIN #FinalData B ON A.MOCode = B.MOCode
--WHERE B.MOCode is null


----Add Bubble Bee
--UPDATE A SET A.TotalPayable = A.TotalPayable + B.ActualPay, A.GrandTotal = A.GrandTotal + B.ActualPay,   A.Campaign = A.Campaign + ', ' + B.Client FROM #FinalData A INNER JOIN #BBRawData B ON A.MOCode = B.MOCode
--INSERT INTO #FinalData 
--SELECT  'MY',  A.MOCode, '',A.Client, A.ActualPay, 0.00, A.ActualPay,0.00  FROM #BBRawData A LEFT JOIN #FinalData B ON A.MOCode = B.MOCode
--WHERE B.MOCode is null



----Add Bubble Bee
--UPDATE A SET A.TotalPayable = A.TotalPayable + B.ActualPay, A.GrandTotal = A.GrandTotal + B.ActualPay,   A.Campaign = A.Campaign + ', ' + B.Client FROM #FinalData A INNER JOIN #WTBRawData B ON A.MOCode = B.MOCode
--INSERT INTO #FinalData 
--SELECT  'MY',  A.MOCode, '',A.Client, A.ActualPay, 0.00, A.ActualPay,0.00  FROM #WTBRawData A LEFT JOIN #FinalData B ON A.MOCode = B.MOCode
--WHERE B.MOCode is null
 
UPDATE A SET A.MoName = B.Name FROM #FinalData A LEFT JOIN Mst_MarketingCompany B ON A.MOCode = B.Code and B.CountryCode = 'MY' and B.IsDeleted = 0 and IsActive = 1

UPDATE #FinalData SET BulletinPoint = CAST((GrandTotal / 6000.00) * 100.00 as decimal(18,2))
SELECT ROW_NUMBER() OVER(ORDER BY A.MOCode ASC) AS RowNo, @Weekending as 'Weekending', * FROM #FinalData A 
ORDER BY A.MOCode ASC


END


