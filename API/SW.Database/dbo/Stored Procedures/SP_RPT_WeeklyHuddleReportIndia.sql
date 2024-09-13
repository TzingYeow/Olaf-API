

-- ==========================================================================================
-- Author:		Syafiqah Ab Manah
-- Create date: 2020-11-05
-- Description:	Regional RC Analysis Report 
-- EXEC SP_RPT_WeeklyHuddleReport '2021-01-14'
-- ==========================================================================================

--================================
-- MULTIPLE WEEKENDING (START)
--================================
--DECLARE @RangeFrom as Date
--DECLARE @RangeTo as Date
--DECLARE @LoopWe as Date
--DECLARE @Loop as bit

--SET @RangeFrom='2020-11-01'
--SET @RangeTo = '2021-01-14'
 
--CREATE TABLE #ReportDateRage (
--	Country NVARCHAR(20),
--	Division NVARCHAR(20),
--	Customer NVARCHAR(50),
--	Weekending Date,
--	RMonth NVARCHAR(50),
--	RQuarter NVARCHAR(50),
--	GrossPiece INT,
--	GrossPieceOT INT,
--	RejectPiece INT,
--	ResubPiece INT,
--	NetPiece INT,
--	CountryUSHC INT,
--	DivUSCH INT,
--	USCH INT,
--	GrossSales DECIMAL(18,2),
--	NewStarter INT 
--)
 

--SELECT TOP 1 @LoopWE = WEDate  FROM MST_weekending Where WeDate >= @RangeFrom and WEdate <=@RangeTo order by WeDate
--SET @Loop = 1
--WHILE @Loop = 1
--BEGIN
--	INSERT INTO #ReportDateRage EXEC  SP_RPT_WeeklyHuddleReport @LoopWE
 
--SET @Loop = 0
 
--  if (SELECT COUNT(*) FROM MST_weekending Where WEdate > @LoopWE and WEdate <= @RangeTo ) > 0
--  BEGIN
--	SET @Loop = 1
--  END
--  ELSE
--  BEGIN
--	SET @Loop = 0
--  END
--SELECT TOP 1 @LoopWE = WEDate  FROM MST_weekending Where WEdate > @LoopWE and WEdate <= @RangeTo   order by WeDate

--END

--SELECT Country, Division, Customer, Weekending, RMonth, RQuarter, ISNULL(GrossPiece,0) as 'GrossPiece', ISNULL(GrossPieceOT,0) as 'One Time Pieces', ISNULL(RejectPiece,0) as 'Reject Pieces',
--ISNULL(ResubPiece,0) as 'Resub Pieces', ISNULL(NetPiece,0) as 'NetPiece', CountryUSHC, DivUSCH, USCH as 'Campaign USHC', GrossSales 'BA Earnings', NewStarter  FROM #ReportDateRage 
 
-- DROP TABLE #ReportDateRage
--================================
-- MULTIPLE WEEKENDING (END)
--================================


--=============================
CREATE PROCEDURE [dbo].[SP_RPT_WeeklyHuddleReportIndia]
	-- Add the parameters for the stored procedure here
	@ReportWE  date 
AS
BEGIN
	 
DECLARE @weDate DATE
DECLARE @CountryWeDate DATE
DECLARE @weFromDate DATE
DECLARE @weToDate DATE
DECLARE @Month as NVARCHAR(10)
DECLARE @Quarter as NVARCHAR(10)
DECLARE @UniqueSCH as INT
DECLARE @UniqueDiv1 as INT
DECLARE @UniqueDiv2 as INT
DECLARE @UniqueDiv3 as INT
DECLARE @UniqueSCH_Charity as INT
DECLARE @UniqueSCH_Commercial as INT

SET @weDate =  @ReportWE
SET @Month = FORMAT(@weDate,'MMM') + '-' + SUBSTRING(CAST(YEAR(@wedate) as nvarchar),3,2)
SET @Quarter = 'Q' + CAST(DATEPART(QUARTER, @Wedate) as nvarchar) + ' FY' + SUBSTRING(CAST(YEAR(@wedate) as nvarchar),3,2)
--SELECT * FROM VW_CH_SS WHERE StatusWEDate = @weDate 



CREATE TABLE #ReportDate (
	Country NVARCHAR(20),
	Division NVARCHAR(20),
	MOCode NVARCHAR(20),
	BadgeNo NVARCHAR(20),
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
	USCH INT,
	DivUSCH INT,
	GrossSales DECIMAL(18,2),
	NewStarter INT 
)
 



-- =================================================== INDIA (START)==========================================================================
-- ===========================================================================================================================================


SET @weFromDate = NULL
SET @weToDate = null
set @CountryWeDate = null

SELECT @weFromDate = FromDate, @weToDate = ToDate, @CountryWeDate = WEdate  FROM NewIndiaDB_PROD..Mst_Weekending where WEdate = @weDate

--If not found, Possible short week. check WE -1
IF (@weFromDate is null )
BEGIN 
SELECT @weFromDate = FromDate, @weToDate = ToDate, @CountryWeDate = WEdate  FROM NewIndiaDB_PROD..Mst_Weekending where WEdate = DATEADD(day, -1 ,@weDate)
END
--If not found, Possible short week. check WE -2
IF (@weFromDate is null )
BEGIN 
SELECT @weFromDate = FromDate, @weToDate = ToDate, @CountryWeDate = WEdate  FROM NewIndiaDB_PROD..Mst_Weekending where WEdate = DATEADD(day, -2 ,@weDate)
END

--If not found, Possible long week. check WE + 1
IF (@weFromDate is null )
BEGIN 
SELECT @weFromDate = FromDate, @weToDate = ToDate, @CountryWeDate = WEdate  FROM NewIndiaDB_PROD..Mst_Weekending where WEdate = DATEADD(day, 1 ,@weDate)
END


IF (@CountryWeDate is not null )
BEGIN
 

SELECT @UniqueSCH = COUNT(Distinct BadgeNo) FROM (
SELECT distinct BadgeNo as 'BadgeNo'  FROM  NewIndiaDB_PROD..VW_CH_SS WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeNo,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0   and IsDeleted = 0   
) A
 
INSERT INTO #ReportDate (Country, Division, MOCode, BadgeNo, Customer, Weekending, RMonth, RQuarter, CountryUSHC, USCH)
SELECT 'India' as 'Country', A.Division,A.MOCode, A.AA,  A.Campaign as 'Customer', @CountryWeDate as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter', @UniqueSCH as 'CountryUniqueSHC',  A.BadgeNo as 'UniqueSHC' FROM (
SELECT B.Client as 'Campaign', 'Charity' as Division, MoCode,BadgeNo as 'AA', COUNT( distinct BadgeNo) as 'BadgeNo'  FROM NewIndiaDB_PROD..VW_CH_SS A 
LEFT JOIN NewIndiaDB_PROD..VW_MST_CampaignList B ON A.Client = B.ID
WHERE StatusWEDate = @CountryWeDate  and ISNULL(BadgeNo,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0
GROUP BY  B.Client  , MoCode,BadgeNo 
) A 
 

UPDATE A SET A.GrossPieceOT = 0, A.ResubPiece =B.ResubPiece, A.RejectPiece = B.RejectPiece,  A.GrossPiece = B.GrossPiece, A.GrossSales = B.Gross, A.NetPiece = B.NetPiece FROM #ReportDate A INNER JOIN(
SELECT BadgeNo, B.Client as 'Campaign',SUM(CASE WHEN Status in ('SubmissionDate','ReSubmissionDate','ClientResubmissionDate') THEN ICStrokeValue ELSE 0 END) as 'Gross',
SUM(CASE WHEN Status in ('SubmissionDate','ReSubmissionDate','ClientResubmissionDate') THEN 1 ELSE -1 END) as 'NetPiece' ,
SUM(CASE WHEN Status in ('SubmissionDate') THEN 1 ELSE 0 END) as 'GrossPiece' ,
SUM(CASE WHEN Status in ('ReSubmissionDate','ClientResubmissionDate') THEN 1 ELSE 0 END) as 'ResubPiece' ,
SUM(CASE WHEN Status not in ('SubmissionDate','ReSubmissionDate','ClientResubmissionDate') THEN 1 ELSE 0 END) as 'RejectPiece' FROM NewIndiaDB_PROD..VW_CH_SS A 
LEFT JOIN NewIndiaDB_PROD..VW_MST_CampaignList B ON A.Client = B.ID
WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeNo,'') <> '' and Status in ('SubmissionDate','ReSubmissionDate','ClientResubmissionDate','RejectDate','ClientRejectDate')
and IsDeleted = 0
GROUP BY B.Client ,BadgeNo
) B ON A.Country = 'India' and A.Division = 'Charity' and A.Customer = B.Campaign and A.BadgeNo= B.BadgeNo



SET @UniqueDiv1 = 0 
SELECT @UniqueDiv1 = COUNT(Distinct BadgeNo) FROM (
SELECT  distinct BadgeNo as 'BadgeNo'  FROM NewIndiaDB_PROD..VW_CH_SS A 
LEFT JOIN NewIndiaDB_PROD..VW_MST_CampaignList B ON A.Client = B.ID
WHERE StatusWEDate = @CountryWeDate  and ISNULL(BadgeNo,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0  ) A

UPDATE #ReportDate SET DivUSCH = @UniqueDiv1 where Country = 'India' and Division = 'Charity' 

END
-- =================================================== INDIA (END)==========================================================================
-- ===========================================================================================================================================


 
SELECT @weFromDate = FromDate, @weToDate = ToDate FROM NewOlaf_Prod..Mst_Weekending where WEdate = @weDate
 
-- =================================================== UPDATE ALL COUNTRY NEW JOUNER (START)==================================================
-- ===========================================================================================================================================
UPDATE A SET A.NewStarter = ISNULL( B.NewStarter,0) FROM #ReportDate A LEFT JOIN
(
SELECT Case WHEN  B.CountryCode = 'TH' THEN 'Thailand' WHEN B.CountryCode = 'KR' THEN 'Korea' WHEN B.CountryCode = 'SG' THEN 'Singapore' WHEN B.CountryCode = 'IN' THEN 'India'   WHEN B.CountryCode = 'PH' THEN 'Philippines'  WHEN B.CountryCode = 'TW' THEN 'Taiwan'  WHEN B.CountryCode = 'HK' THEN 'Hong Kong' WHEN B.CountryCode = 'MY' THEN 'Malaysia' ELSE '' END as 'Country', COUNT(*) as 'NewStarter' FROM NewOlaf_Prod..Mst_IndependentContractor A LEFT JOIN NewOlaf_Prod..Mst_MarketingCompany B ON A.MarketingCompanyId = B.MarketingCompanyId
where StartDate >= @weFromDate and StartDate <=@weToDate and a.IsDeleted = 0
GROUP BY Case WHEN  B.CountryCode = 'TH' THEN 'Thailand' WHEN B.CountryCode = 'KR' THEN 'Korea' WHEN B.CountryCode = 'SG' THEN 'Singapore' WHEN B.CountryCode = 'IN' THEN 'India'   WHEN B.CountryCode = 'PH' THEN 'Philippines'  WHEN B.CountryCode = 'TW' THEN 'Taiwan'  WHEN B.CountryCode = 'HK' THEN 'Hong Kong' WHEN B.CountryCode = 'MY' THEN 'Malaysia' ELSE '' END 
 ) B ON A.Country = B.Country 
-- =================================================== UPDATE ALL COUNTRY NEW JOUNER (END  )==================================================
-- ===========================================================================================================================================


SELECT Country, Division, MOCode, BadgeNo, Customer, Weekending, RMonth, RQuarter, ISNULL(GrossPiece,0) as 'GrossPiece', ISNULL(GrossPieceOT,0) as 'One Time Pieces', ISNULL(RejectPiece,0) as 'Reject Pieces',
ISNULL(ResubPiece,0) as 'Resub Pieces', ISNULL(NetPiece,0) as 'NetPiece', CountryUSHC, DivUSCH, USCH, GrossSales, NewStarter  FROM #ReportDate 

--DROP TABLE #ReportDate
--DROP TABLE #TempKoreaNet  
--DROP TABLE #MainTransaction    
--DROP TABLE #ICETable    
 

END


