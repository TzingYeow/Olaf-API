

-- ==========================================================================================
-- Author:		Syafiqah Ab Manah
-- Create date: 2020-11-05
-- Description:	Regional RC Analysis Report 
-- EXEC SP_RPT_WeeklyHuddleReport '2021-01-14'
-- ==========================================================================================
--SP_RPT_WeeklyHuddleReportPass3Week_BulletinPoint
CREATE PROCEDURE [dbo].[SP_RPT_WeeklyHuddleReportPass3Week_BulletinPoint]
 
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
	MOCode NVARCHAR(20),
	MOName NVARCHAR(100),  
	Weekending Date,
	RMonth NVARCHAR(50),
	RQuarter NVARCHAR(50),
	GrossBAEarning DECIMAL(18,2),
	NetBAEarning DECIMAL(18,2),
	SWBonus DECIMAL(18,2),
	ConversionRate DECIMAL(18,2),
	BuletinPoint DECIMAL(18,2) 
)
 

SELECT TOP 1 @LoopWE = WEDate  FROM MST_weekending Where WeDate >= @RangeFrom and WEdate <=@RangeTo order by WeDate
SET @Loop = 1
WHILE @Loop = 1
BEGIN
PRINT @LoopWE
	INSERT INTO #ReportDateRage EXEC  SP_RPT_WeeklyHuddleReport_BulletinPoint @LoopWE
 
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

DELETE FROM #ReportDateRage WHERE ISNULL(GrossBAEarning,0.00) = 0.00 and ISNULL(NetBAEarning,0.00) = 0.00 and ISNULL(SWBonus,0.00) = 0.00

SELECT * FROM #ReportDateRage 
ORDER BY Weekending, Country, MOCode 
 
 DROP TABLE #ReportDateRage

END


