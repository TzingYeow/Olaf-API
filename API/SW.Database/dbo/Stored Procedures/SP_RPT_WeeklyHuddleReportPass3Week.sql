

-- ==========================================================================================
-- Author:		Syafiqah Ab Manah
-- Create date: 2020-11-05
-- Description:	Regional RC Analysis Report 
-- EXEC SP_RPT_WeeklyHuddleReport '2023-01-29'
-- ==========================================================================================
--SP_RPT_WeeklyHuddleReportPass3Week
CREATE PROCEDURE [dbo].[SP_RPT_WeeklyHuddleReportPass3Week]
 
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
	Customer NVARCHAR(50),
	Weekending Date,
	RMonth NVARCHAR(50),
	RQuarter NVARCHAR(50),
	GrossPiece INT,
	GrossPieceOT INT,
	RejectPiece INT,
	ResubPiece INT,
	NetPiece INT,
	CountryUSHC INT,
	DivUSCH INT,
	USCH INT,
	GrossSales DECIMAL(18,2),
	NewStarter INT ,
	Leaver INt,
	CountryHC INT,
	CountryDivHC INT,
	CountryCampaignHC INT, 
	GrossBAEarning DECIMAL(18,2),
	NetBAEarning DECIMAL(18,2),
	SWBonus DECIMAL(18,2),
	BuletinPoint DECIMAL(18,2),
	RejectPieceOT INT,
	RejectPieceREC INT,
	ResubPieceOT INT,
	ResubPieceREC INT,
	AvgSCR INT
)
 
SELECT TOP 1 @LoopWE = WEDate  FROM MST_weekending Where WeDate >= @RangeFrom and WEdate <=@RangeTo order by WeDate
SET @Loop = 1
WHILE @Loop = 1
BEGIN
PRINT @LoopWE
	INSERT INTO #ReportDateRage EXEC  SP_RPT_WeeklyHuddleReport @LoopWE
 
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

SELECT Country, Division, Customer, Weekending, RMonth, RQuarter, ISNULL(GrossPiece,0) as 'GrossPiece', ISNULL(GrossPieceOT,0) as 'One Time Pieces', ISNULL(RejectPiece,0) as 'Reject Pieces',
ISNULL(ResubPiece,0) as 'Resub Pieces', ISNULL(NetPiece,0) as 'NetPiece', CountryUSHC, DivUSCH, USCH as 'Campaign USHC', GrossSales 'BA Earnings', NewStarter, Leaver,ISNULL(CountryHC,0) as CountryHC, ISNULL(CountryDivHC,0) as CountryDivHC, ISNULL(CountryCampaignHC,0) as CountryCampaignHC, ISNULL(GrossBAEarning,0.00) as  GrossBAEarning, ISNULL(NetBAEarning,0.00) as NetBAEarning, ISNULL(SWBonus,0.00) as SWBonus, ISNULL(BuletinPoint,0.00) as  BuletinPoint 
, ISNULL(RejectPieceOT,0.00) as  RejectPieceOT, ISNULL(RejectPieceREC,0.00) as  RejectPieceREC, ISNULL(ResubPieceOT,0.00) as  ResubPieceOT, ISNULL(ResubPieceREC,0.00) as  ResubPieceREC, AvgSCR FROM #ReportDateRage 
 
ORDER BY Weekending, Country, Customer
 
 DROP TABLE #ReportDateRage

END


