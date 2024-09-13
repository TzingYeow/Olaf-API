 -- SP_RPT_TPTReport '2023-10-01','O'
	CREATE PROCEDURE [dbo].[SP_RPT_TPTReport]
		@WEDate as Date	,
		@Level NVARCHAR(5)
	AS
	BEGIN
	
		SET NOCOUNT ON;
		 
		  
DROP TABLE IF EXISTS #ConversionRate
CREATE TABLE #ConversionRate(
CountryCode   NVARCHAR(2),
CurrentLevel NVARCHAR(5),
Rate   DECIMAl(18,2)
)

INSERT INTO #ConversionRate 
SELECT Country, BALevel, PointConversion FROM MST_TPTCountryPoint where StartWE <= @WEDate and EndWE >=@WEDate  and IsActive = 1
order by Country

--IF @Level = 'TL'
--BEGIN
--	INSERT INTO #ConversionRate SELECT 'MY','TL',1200.00
--	INSERT INTO #ConversionRate SELECT 'SG','TL',1200.00
--	INSERT INTO #ConversionRate SELECT 'HK','TL',7500.00
--	INSERT INTO #ConversionRate SELECT 'TH','TL',1200.00
--	INSERT INTO #ConversionRate SELECT 'KR','TL',1200000.00
--	INSERT INTO #ConversionRate SELECT 'TW','TL',27000.00
--END

--IF @Level = 'AO'
--BEGIN
--	INSERT INTO #ConversionRate SELECT 'MY','AO',2400.00
--	INSERT INTO #ConversionRate SELECT 'SG','AO',2400.00
--	INSERT INTO #ConversionRate SELECT 'HK','AO',15000.00
--	INSERT INTO #ConversionRate SELECT 'TH','AO',24000.00
--	INSERT INTO #ConversionRate SELECT 'KR','AO',2400000.00
--	INSERT INTO #ConversionRate SELECT 'TW','AO',54000.00
--END

--IF @Level = 'O'
--BEGIN
--	INSERT INTO #ConversionRate SELECT 'MY','O',6000.00
--	INSERT INTO #ConversionRate SELECT 'SG','O',6000.00
--	INSERT INTO #ConversionRate SELECT 'HK','O',37500.00
--	INSERT INTO #ConversionRate SELECT 'TH','O',60000.00
--	INSERT INTO #ConversionRate SELECT 'KR','O',4000000.00
--	INSERT INTO #ConversionRate SELECT 'TW','O',54000.00
	
--	INSERT INTO #ConversionRate SELECT 'MY','OP',4000.00
--	INSERT INTO #ConversionRate SELECT 'SG','OP',4000.00
--	INSERT INTO #ConversionRate SELECT 'HK','OP',25000.00
--	INSERT INTO #ConversionRate SELECT 'TH','OP',60000.00
--	INSERT INTO #ConversionRate SELECT 'KR','OP1',4000000.00
--	INSERT INTO #ConversionRate SELECT 'KR','OP2',6000000.00
--	INSERT INTO #ConversionRate SELECT 'TW','OP',9000.00

--END

DROP TABLE IF EXISTS #TempBAList
SELECT A.WeDate , A.CountryCode, A.MCCode, B.Name as 'MCName', A.BadgeNo, LTRIM(RTRIM(ISNULL(B.FirstName,'') + ' ' + ISNULL(B.LastName,''))) as 'BAName' , 
A.CurrentLevel, A.BadgeNoLink, CAST(0 as decimal(18,2)) as 'TeamProduction', CAST('' as NVARCHAR(300)) as 'Campaign', 
A.NetValue, CAST(0.00 as decimal(18,2)) as 'Point',CAST(0 as int) as Ranking INTO #TempBAList 
FROM TXN_WeeklyBASummary A with (nolock)  LEFT JOIN VW_ICDetail B ON A.BadgeNO = B.Badgeno and A.CountryCode = B.CountryCode
where A.WeDate = @WeDate and  A.IsDeleted = 0 --and A.CountryCode not in ( 'SG') --and A.MCCode = 'ST'
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

IF @Level = 'O'
BEGIN
	INSERT INTO #BALoop
	SELECT BadgeNo, CountryCode FROM #TempBAList WHERE CurrentLevel in ('OP','O')
	and CountryCode   in ('MY','TW', 'TH','HK','KR','SG') 
END
ELSE
BEGIN
	INSERT INTO #BALoop
	SELECT BadgeNo, CountryCode FROM #TempBAList WHERE CurrentLevel = @Level
	and CountryCode   in ('MY','TW', 'TH','HK','KR','SG') 

END 


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
		and CountryCode = @LoopCountrycode
		--and CountryCode not in ('KR') 
		)
	) WHERE BadgeNo = @BadgeNoLoop


	UPDATE #TempBAList set TeamProduction = ISNULL(TeamProduction,0.00) + ISNULL(NetValue,0.00) WHERE BadgeNo = @BadgeNoLoop

	IF @LoopCountrycode = 'MY'
	BEGIN
		SELECT @LoopCampaign = (SELECT STRING_AGG(Client,',') FROM (
		SELECT distinct Client FROM NewMYDB_PROD..VW_CH_SS where statuswedate = @WeDate and 
		BadgeID in (SELECT BadgeNo FROM #TempBAList WHERE BadgeNoLink like '%' + @BadgeNoLoop + '%')
		and status in ('ReSubmissionDate','SubmissionDate','ClientRejectDate','ClientReSubmissionDate')
		UNION 
		SELECT 'TKF' FROM NewMYDB_PROD..Tbl_TKF_Maintable_StatusSummary where StatusWE = @WeDate and 
		ICBadgeNo_H in (SELECT BadgeNo FROM #TempBAList WHERE  BadgeNoLink like '%' + @BadgeNoLoop + '%')
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

		--UPDATE #TempBAList set Campaign = @LoopCampaign, TeamProduction = ISNULL(TeamProduction,0.00) + 
		--(SELECT SUM(ISNULL(AdditionalStroke,0.00)) FROM NewTWDB_PROD..Txn_Transaction_ICE where BadgeRelationship like '%' + @BadgeNoLoop + '%'
		-- and WeekendingDate = @WeDate
		-- )
		--WHERE BadgeNo = @BadgeNoLoop and CountryCode = @LoopCountrycode



	END

	IF @LoopCountrycode = 'KR'
	BEGIN
		SELECT @LoopCampaign = (SELECT STRING_AGG(CampaignCode,',') FROM (
		 SELECT distinct CampaignCode FROM NewHKDB_PROD..Txn_Transaction_StatusSummary 
		 where BadgeNO in (SELECT BadgeNo FROM #TempBAList WHERE BadgeNoLink like '%' + @BadgeNoLoop + '%')
		 and StatusWEDate = @WeDate
		) A
		) 
		
		SELECT @LoopCampaign = (SELECT STRING_AGG(Campaign,',') FROM (
		SELECT distinct Campaign FROM Appco360_PROD..Maintable where FRID  collate SQL_Latin1_General_CP1_CI_AS in (SELECT BadgeNo FROM #TempBAList WHERE  BadgeNoLink like '%' + @BadgeNoLoop + '%')
		and (MOSubWE = @WeDate OR MORejectWE = @WEDate)
		) A
		)
		UPDATE #TempBAList set Campaign = @LoopCampaign 
		WHERE BadgeNo = @BadgeNoLoop and CountryCode = @LoopCountrycode
		 
	END 

	IF @LoopCountrycode = 'HK'
	BEGIN
		SELECT @LoopCampaign = (SELECT STRING_AGG(CampaignCode,',') FROM (
		 SELECT distinct CampaignCode FROM NewHKDB_PROD..Txn_Transaction_StatusSummary 
		 where BadgeNO in (SELECT BadgeNo FROM #TempBAList WHERE  BadgeNoLink like '%' + @BadgeNoLoop + '%')
		 and StatusWEDate = @WeDate
		) A
		)

		
		UPDATE #TempBAList set Campaign = @LoopCampaign 
		WHERE BadgeNo = @BadgeNoLoop and CountryCode = @LoopCountrycode
		 
	END 



	IF @LoopCountrycode = 'TH'
	BEGIN
		--SELECT @LoopCampaign = STRING_AGG(CampaignCode,',') FROM(
		-- SELECT  distinct CampaignCode  FROM NewTHDB_PROD..Txn_Transaction_StatusSummary where StatusWEDate = @WeDate
	
		-- and status in ('ClientRejectDate','ClientReSubmissionDate','RejectDate','ReSubmissionDate','SubmissionDate')

		--	and BadgeNo = @BadgeNoLoop
		-- ) B

		-- 		SELECT @LoopCampaign = STRING_AGG(CampaignCode,',') FROM(
		--		SELECT  distinct CampaignCode  FROM NewTHDB_PROD..Txn_Transaction_StatusSummary where StatusWEDate = @WeDate 
		--		and status in ('ClientRejectDate','ClientReSubmissionDate','RejectDate','ReSubmissionDate','SubmissionDate') 
		--		and BadgeNo = @BadgeNoLoop


				
				SELECT @LoopCampaign = STRING_AGG(  B.Client,',')   
				FROM (
				SELECT DISTINCT B.Client
				FROM NewTHDB_PROD..Txn_Transaction_ICE A LEFT JOIN NewTHDB_PROD..VW_MST_CampaignList B ON A.CampaignId = B.ID
				WHERE A.ICBadgeNo = @BadgeNoLoop
				) B

				--UNION 
				--SELECT distinct CampaignCode FROM NewTHDB_PROD..Txn_Transaction where BadgeNO = 'RN0376' and WeDate =@WeDate
		 --) B


		UPDATE #TempBAList set Campaign = @LoopCampaign, TeamProduction = ISNULL(TeamProduction,0.00) + 
		(SELECT SUM(ISNULL(AdditionalStroke,0.00)) FROM NewTHDB_PROD..Txn_Transaction_ICE where BadgeRelationship like '%' + @BadgeNoLoop + '%'
		 and WeekendingDate = @WeDate
		 )
		WHERE BadgeNo = @BadgeNoLoop and CountryCode = @LoopCountrycode




 
	END

	
	 
	
	DELETE FROM #BALoop where BadgeNo = @BadgeNoLoop
	SELECT @Loop = COUNT(*) FROM #BALoop
END

UPDATE #TempBAList SET CurrentLevel = 'OP1' WHERE CountryCode = 'KR' and CurrentLevel = 'OP'
UPDATE A SET A.CurrentLevel = C.OverrideIcLevelCode FROM #TempBAList A LEFT JOIN VW_ICDetail B ON A.BadgeNo = B.BadgeNo and B.CountryCode = 'KR'
INNER JOIN (
SELECT IndependentContractorId, OverrideIcLevelCode FROM [Appco360_PROD]..[TXN_ReportingBadge_KR] 
where wedate =@WEDate and OverrideIcLevelCode is not null
) C ON B.IndependentContractorId = C.IndependentContractorId


 UPDATE A SET A.Point =  CAST((A.TeamProduction / C.Rate) * 100.00 as decimal(18,2))  FROM #TempBAList a  
 LEFT JOIN #ConversionRate C ON A.CountryCode = C.CountryCode and A.CurrentLevel = C.CurrentLevel

  IF @Level = 'O'
 BEGIN
  UPDATE A SET A.Ranking = B.Row# FROM #TempBAList A INNER JOIN (
 SELECT  ROW_NUMBER() OVER(ORDER BY point DESC) AS Row#,BadgeNo FROM #TempBAList WHERE CurrentLevel in ('OP','O')
 ) B ON A.BadgeNo = B.BadgeNo
 END
 BEGIN
  UPDATE A SET A.Ranking = B.Row# FROM #TempBAList A INNER JOIN (
 SELECT  ROW_NUMBER() OVER(ORDER BY point DESC) AS Row#,BadgeNo FROM #TempBAList WHERE CurrentLevel = @Level
 ) B ON A.BadgeNo = B.BadgeNo
 END


 UPDATE A SET A.Ranking = B.ranking FROM #TempBAList A INNER JOIN (
 SELECT  POINT, Min(ranking) ranking  FROM #TempBAList
 group by POINT
 having COUNT(*)>1
 ) B ON A.Point = B.Point 
 
 
 -- DELETE FROM TXN_TPTSummary where WeDate =@WEDate and CurrentLevel = @Level

 --INSERT INTO TXN_TPTSummary
 IF @Level = 'O'
 BEGIN
  SELECT A.*, B.Level, C.Rate  FROM #TempBAList a 
 LEFT JOIN Mst_IndependentContractorLevel B ON A.CurrentLevel = B.LevelCode 
 LEFT JOIN #ConversionRate C ON A.CountryCode = C.CountryCode and A.CurrentLevel = C.CurrentLevel
 WHERE A.CurrentLevel in ('O','OP','OP1','OP2') and RAnking > 0-- and BadgeNo = 'DD0005'
 ORDER BY Ranking  
  
 END
 ELSE
 BEGIN
  SELECT A.*, B.Level, C.Rate  FROM #TempBAList a 
 LEFT JOIN Mst_IndependentContractorLevel B ON A.CurrentLevel = B.LevelCode 
 LEFT JOIN #ConversionRate C ON A.CountryCode = C.CountryCode and A.CurrentLevel = C.CurrentLevel
 WHERE A.CurrentLevel= @Level and RAnking > 0-- and BadgeNo = 'DD0005'
 ORDER BY Ranking  
  
 END

 

	END

	--SELECT * FROM TXN_TPTSummary
	--TRUNCATE TABLE TXN_TPTSummary

  
  
