 --SP_RPT_TPTReport_TL '2023-07-23'
	CREATE PROCEDURE [dbo].[SP_RPT_TPTReport_TL]
		@WEDate as Date	
	AS
	BEGIN
	
		SET NOCOUNT ON;
		 
		  
DROP TABLE IF EXISTS #ConversionRate
CREATE TABLE #ConversionRate(
CountryCode   NVARCHAR(2),
Rate   DECIMAl(18,2)
)

INSERT INTO #ConversionRate SELECT 'MY',1200.00
INSERT INTO #ConversionRate SELECT 'SG',1200.00
INSERT INTO #ConversionRate SELECT 'HK',7500.00
INSERT INTO #ConversionRate SELECT 'TH',12000.00
INSERT INTO #ConversionRate SELECT 'KR',1200000.00
INSERT INTO #ConversionRate SELECT 'TW',27000.00
  
DROP TABLE IF EXISTS #TempBAList
SELECT A.WeDate , A.CountryCode, A.MCCode, B.Name as 'MCName', A.BadgeNo, LTRIM(RTRIM(ISNULL(B.FirstName,'') + ' ' + ISNULL(B.LastName,''))) as 'BAName' , 
A.CurrentLevel, A.BadgeNoLink, CAST(0 as decimal(18,2)) as 'TeamProduction', CAST('' as NVARCHAR(300)) as 'Campaign', 
A.NetValue, CAST(0.00 as decimal(18,2)) as 'Point',CAST(0 as int) as Ranking INTO #TempBAList 
FROM TXN_WeeklyBASummary A with (nolock)  LEFT JOIN VW_ICDetail B ON A.BadgeNO = B.Badgeno and A.CountryCode = B.CountryCode
where A.WeDate = @WeDate and  A.IsDeleted = 0 and A.CountryCode not in ('KR','SG')
GROUP BY A.WeDate , A.CountryCode, A.MCCode, A.BadgeNo,LTRIM(RTRIM(ISNULL(B.FirstName,'') + ' ' + ISNULL(B.LastName,''))), A.CurrentLevel, B.Name, A.BadgeNoLink, A.NetValue

  
DROP TABLE IF EXISTS #BALoop
CREATE TABLE #BALoop(
	BadgeNo NVARCHAR(10),
	CountryCode NVARCHAR(2)
)
DECLARE @Loop INT
DECLARE @BadgeNoLoop NVARCHAR(10)
DECLARE @LoopCountrycode NVARCHAR(2)
DECLARE @LoopCampaign NVARCHAR(200)
INSERT INTO #BALoop
SELECT BadgeNo, CountryCode FROM #TempBAList WHERE CurrentLevel = 'TL'
and CountryCode   in ('MY','TW', 'TH','HK') 


SELECT @Loop = COUNT(*) FROM #BALoop
while @Loop > 0
BEGIN
		SELECT TOP 1 @BadgeNoLoop = BadgeNo, @LoopCountrycode = CountryCode FROM #BALoop
 
	--SELECT BadgeNo FROM #TempBAList WHERE BadgeNo <> @BadgeNoLoop and BadgeNoLink like '%' + @BadgeNoLoop + '%'
	--and CountryCode not in ('KR') 

 
	UPDATE #TempBAList set TeamProduction = 
	( 
		SELECT sum(isnull(netvalue,0.00)) FROM #TempBAList where BadgeNo in (
		SELECT BadgeNo FROM #TempBAList WHERE BadgeNo <> @BadgeNoLoop and BadgeNoLink like '%' + @BadgeNoLoop + '%'
		and CountryCode not in ('KR') 
		)
	) WHERE BadgeNo = @BadgeNoLoop

	UPDATE #TempBAList set TeamProduction = ISNULL(TeamProduction,0.00) + NetValue WHERE BadgeNo = @BadgeNoLoop

	IF @LoopCountrycode = 'MY'
	BEGIN
		SELECT @LoopCampaign = (SELECT STRING_AGG(Client,',') FROM (
		SELECT distinct Client FROM NewMYDB_PROD..VW_CH_SS where statuswedate = @WeDate and BadgeID = @BadgeNoLoop
		and status in ('ReSubmissionDate','SubmissionDate','ClientRejectDate','ClientReSubmissionDate')
		UNION 
		SELECT 'TKF' FROM NewMYDB_PROD..Tbl_TKF_Maintable_StatusSummary where StatusWE = @WeDate and ICBadgeNo_H = @BadgeNoLoop
		) A
		)

		
		UPDATE #TempBAList set Campaign = @LoopCampaign 
		WHERE BadgeNo = @BadgeNoLoop and CountryCode = @LoopCountrycode
 

	END

	IF @LoopCountrycode = 'TW'
	BEGIN
		SELECT @LoopCampaign = (SELECT STRING_AGG(Client,',') FROM (
		 SELECT distinct Client  FROM NewTWDB_PROD..VW_CH_SS where BadgeID = @BadgeNoLoop and StatusWEDate = @WeDate 
		) A
		)

		
		UPDATE #TempBAList set Campaign = @LoopCampaign 
		WHERE BadgeNo = @BadgeNoLoop and CountryCode = @LoopCountrycode


	END

	IF @LoopCountrycode = 'HK'
	BEGIN
		SELECT @LoopCampaign = (SELECT STRING_AGG(CampaignCode,',') FROM (
		 SELECT distinct CampaignCode FROM NewHKDB_PROD..Txn_Transaction_StatusSummary where BadgeNO = @BadgeNoLoop and StatusWEDate = @WeDate
		) A
		)

		
		UPDATE #TempBAList set Campaign = @LoopCampaign 
		WHERE BadgeNo = @BadgeNoLoop and CountryCode = @LoopCountrycode

		
	END 


	IF @LoopCountrycode = 'TH'
	BEGIN
		SELECT @LoopCampaign = STRING_AGG(CampaignCode,',') FROM(
		 SELECT  distinct CampaignCode  FROM NewTHDB_PROD..Txn_Transaction_StatusSummary where StatusWEDate = @WeDate
	
		 and status in ('ClientRejectDate','ClientReSubmissionDate','RejectDate','ReSubmissionDate','SubmissionDate')

			and BadgeNo = @BadgeNoLoop
		 ) B

		 		SELECT @LoopCampaign = STRING_AGG(CampaignCode,',') FROM(
				SELECT  distinct CampaignCode  FROM NewTHDB_PROD..Txn_Transaction_StatusSummary where StatusWEDate = @WeDate 
				and status in ('ClientRejectDate','ClientReSubmissionDate','RejectDate','ReSubmissionDate','SubmissionDate') 
				and BadgeNo = @BadgeNoLoop
				UNION 
				SELECT distinct CampaignCode FROM NewTHDB_PROD..Txn_Transaction where BadgeNO = 'RN0376' and WeDate =@WeDate
		 ) B


		UPDATE #TempBAList set Campaign = @LoopCampaign, TeamProduction = ISNULL(TeamProduction,0.00) + 
		(SELECT SUM(ISNULL(AdditionalStroke,0.00)) FROM NewTHDB_PROD..Txn_Transaction_ICE where BadgeRelationship like '%' + @BadgeNoLoop + '%'
		 and WeekendingDate = @WeDate
		 )
		WHERE BadgeNo = @BadgeNoLoop and CountryCode = @LoopCountrycode




 
	END

	
	 
	
	DELETE FROM #BALoop where BadgeNo = @BadgeNoLoop
	SELECT @Loop = COUNT(*) FROM #BALoop
END

 UPDATE A SET A.Point =  CAST((A.TeamProduction / C.Rate) * 100.00 as decimal(18,2))  FROM #TempBAList a  
 LEFT JOIN #ConversionRate C ON A.CountryCode = C.CountryCode

 UPDATE A SET A.Ranking = B.Row# FROM #TempBAList A INNER JOIN (
 SELECT  ROW_NUMBER() OVER(ORDER BY point DESC) AS Row#,BadgeNo FROM #TempBAList WHERE CurrentLevel = 'TL'
 ) B ON A.BadgeNo = B.BadgeNo

 UPDATE A SET A.Ranking = B.ranking FROM #TempBAList A INNER JOIN (
 SELECT  POINT, Min(ranking) ranking  FROM #TempBAList
 group by POINT
 having COUNT(*)>1
 ) B ON A.Point = B.Point 
 
 --SELECT A.*, B.Level  FROM #TempBAList a 
 --LEFT JOIN Mst_IndependentContractorLevel B ON A.CurrentLevel = B.LevelCode 
 
 --where CurrentLevel = 'TL' and BadgeNo in ('FS00585','AB0013','AR3309')
 --order by BadgeNo
 
 
 SELECT A.*, B.Level  FROM #TempBAList a 
 LEFT JOIN Mst_IndependentContractorLevel B ON A.CurrentLevel = B.LevelCode 
 WHERE A.CurrentLevel= 'TL' and RAnking > 0
 ORDER BY Ranking  
 
 --SELECT * FROM NewTHDB_PROD..Txn_Transaction_ICE where ICBadgeNo = 'AB0013'
 --and WeekendingDate = '2023-07-23'

 --SELECT * FROM NewTHDB_PROD..Txn_Transaction_ICE where BadgeRelationship like '%AB0013%'
 --and WeekendingDate = '2023-07-23'
 
 
 --SELECT * FROM #TempBAList where   BadgeNoLink like '%AB0013%'
 --order by BadgeNo
 
 --SELECT SUM(AdditionalStroke) FROM NewTHDB_PROD..Txn_Transaction_ICE where BadgeRelationship like '%AB0013%'
 --and WeekendingDate = '2023-07-23'
 
 

	END

  
  
