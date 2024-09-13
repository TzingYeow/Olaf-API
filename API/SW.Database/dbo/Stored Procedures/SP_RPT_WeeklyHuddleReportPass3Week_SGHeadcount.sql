

-- ==========================================================================================
-- Author:		Syafiqah Ab Manah
-- Create date: 2020-11-05
-- Description:	Regional RC Analysis Report 
-- EXEC SP_RPT_WeeklyHuddleReport '2021-01-14'
-- ==========================================================================================
--SP_RPT_WeeklyHuddleReportPass3Week_SGHeadcount
CREATE PROCEDURE [dbo].[SP_RPT_WeeklyHuddleReportPass3Week_SGHeadcount]
 
AS
BEGIN
DECLARE @RangeFrom as Date
DECLARE @RangeTo as Date
DECLARE @LoopWe as Date
DECLARE @Loop as bit


SET @RangeFrom= DATEADD(day, -28,GETDATE())
SET @RangeTo = GETDATE() 
--SET @RangeFrom= '2024-01-01'
--SET @RangeTo = '2023-11-01'
 
CREATE TABLE #ReportDateRage (
	Country NVARCHAR(20),
	Division NVARCHAR(20),  
	Weekending Date, 
	CountryHC INT,
	CountryDivHC INT ,
	CountryCampaignHC INT ,
	CampaignName NVARCHAR(100)
)
 

SELECT TOP 1 @LoopWE = WEDate  FROM MST_weekending Where WeDate >= @RangeFrom and WEdate <=@RangeTo order by WeDate
SET @Loop = 1
WHILE @Loop = 1
BEGIN
PRINT @LoopWE
	INSERT INTO #ReportDateRage EXEC  SP_RPT_WeeklyHuddleReport_SGHeadcount @LoopWE
 
SET @Loop = 0
 
  if (SELECT COUNT(*) FROM MST_weekending Where WEdate > @LoopWE and WEdate <= @RangeTo ) > 0
  BEGIN
	SET @Loop = 1
  END
  ELSE
  BEGIN
	SET @Loop = 0
  END
SELECT TOP 1 @LoopWE = WEDate  FROM MST_weekending Where WEdate > @LoopWE and WEdate <= @RangeTo   order by WeDate

END

SELECT Country, Division, Weekending,ISNULL(CountryHC,0) as CountryHC, ISNULL(CountryDivHC,0) as CountryDivHC, ISNULL(CountryCampaignHC,0) as CountryCampaignHC,CampaignName FROM #ReportDateRage 
ORDER BY Weekending, Country 
 
 DROP TABLE #ReportDateRage

END


