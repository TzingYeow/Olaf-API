

-- ==========================================================================================
-- Author:		Syafiqah Ab Manah
-- Create date: 2020-11-05
-- Description:	Regional RC Analysis Report 
-- EXEC SP_RPT_WeeklyHuddleReport '2021-07-22'
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
CREATE PROCEDURE [dbo].[SP_RPT_WeeklyHuddleReportOps]
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

-- =================================================== MALAYSIA (START)====================================================================
-- ========================================================================================================================================

SELECT @weFromDate = FromDate, @weToDate = ToDate, @CountryWeDate = WEdate  FROM NewMYDB_PROD..Tbl_Weekending where WEdate = @weDate

--If not found, Possible short week. check WE -1
IF (@weFromDate is null )
BEGIN 
PRINT 'If not found, Possible short week. check WE -1'
SELECT @weFromDate = FromDate, @weToDate = ToDate, @CountryWeDate = WEdate  FROM NewMYDB_PROD..Tbl_Weekending where WEdate = DATEADD(day, -1 ,@weDate)
END
--If not found, Possible short week. check WE -2
IF (@weFromDate is null )
BEGIN 
PRINT 'If not found, Possible short week. check WE -2'
SELECT @weFromDate = FromDate, @weToDate = ToDate, @CountryWeDate = WEdate  FROM NewMYDB_PROD..Tbl_Weekending where WEdate = DATEADD(day, -2 ,@weDate)
END

--If not found, Possible long week. check WE + 1
IF (@weFromDate is null )
BEGIN 
PRINT 'If not found, Possible long week. check WE + 1'
SELECT @weFromDate = FromDate, @weToDate = ToDate, @CountryWeDate = WEdate  FROM NewMYDB_PROD..Tbl_Weekending where WEdate = DATEADD(day, 1 ,@weDate)
END

--Max Check Possible 2 day short weekending, if no found, no data will be shown
 
IF (@CountryWeDate is not null )
BEGIN
 
SELECT @UniqueSCH = COUNT(Distinct BadgeNo) FROM (
SELECT distinct BadgeID as 'BadgeNo'  FROM  NewMYDB_PROD..VW_CH_SS WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeID,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0 
UNION ALL 
SELECT  Distinct ICBadgeNo_H FROM NewMYDB_PROD..Tbl_TKF_Maintable_StatusSummary WHERE StatusWE = @CountryWeDate and IsDeleted = 0 and Status = 'SubmissionDate'
UNION ALL
SELECT   DISTINCT IC_Code FROM NewMYDB_PROD..TXN_Lif_SalesHeader where MO_Sub_Week = @CountryWeDate and DE_By is not null and IsDeleted = 0 
UNION ALL
SELECT  DISTINCT AgentID  FROM NewMYDB_PROD..TXN_CO_ICE_HASAVA where WEDate = @CountryWeDate
UNION ALL
SELECT distinct A.BadgeID FROM NewMYDB_PROD..Txn_Commercial_StatusSummary A LEFT JOIN NewMYDB_PROD..Txn_Commercial B ON A.TxnID = B.TxnID  and B.Campaign = 'STMMY'
where StatusWEDate = @CountryWeDate and A.Status = 'SubmissionDate' and A.IsDeleted = 0  
) A
 
INSERT INTO #ReportDate (Country, Division, Customer, Weekending, RMonth, RQuarter, CountryUSHC, USCH)
SELECT 'Malaysia' as 'Country', A.Division, B.Campaign as 'Customer', @CountryWeDate as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter', @UniqueSCH as 'CountryUniqueSHC',  A.BadgeNo as 'UniqueSHC' FROM (
SELECT Client as 'Campaign', 'Charity' as Division, COUNT( distinct BadgeID) as 'BadgeNo'  FROM NewMYDB_PROD..VW_CH_SS WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeID,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0 
GROUP BY Client
UNION ALL 
SELECT 'TKF' as 'Campaign', 'Commercial' as Division, COUNT(Distinct ICBadgeNo_H) FROM NewMYDB_PROD..Tbl_TKF_Maintable_StatusSummary WHERE StatusWE = @CountryWeDate and IsDeleted = 0 and Status = 'SubmissionDate'
UNION ALL
SELECT B.Campaign as 'Campaign','Commercial' as Division,COUNT(Distinct B.BadgeID) FROM NewMYDB_PROD..Txn_Commercial_StatusSummary A LEFT JOIN NewMYDB_PROD..Txn_Commercial B ON A.TxnID = B.TxnID  and B.Campaign = 'STMMY'
where StatusWEDate = @CountryWeDate  and A.Status = 'SubmissionDate' and A.IsDeleted = 0   GROUP BY B.Campaign
UNION ALL
SELECT PRDCAT_Code, 'LifeStyle' as Division, COUNT(DISTINCT IC_Code) FROM NewMYDB_PROD..TXN_Lif_SalesHeader where MO_Sub_Week = @CountryWeDate and DE_By is not null and IsDeleted = 0 GROUP BY PRDCAT_Code
UNION ALL 
SELECT 'HS'  as 'Campaign', 'Commercial' as Division,COUNT(DISTINCT AgentID) FROM NewMYDB_PROD..TXN_CO_ICE_HASAVA where WEDate = @CountryWeDate
) A LEFT JOIN NewMYDB_PROD..VW_CampaignList B ON A.Campaign = B.ClientCode 
  
   
INSERT INTO #ReportDate (Country, Division, Customer, Weekending, RMonth, RQuarter, CountryUSHC, USCH)
SELECT  'Malaysia' as 'Country', A.Division, B.Campaign as 'Customer', @CountryWeDate as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter', @UniqueSCH as 'CountryUniqueSHC',  0 as 'UniqueSHC' FROM (
SELECT Client as 'Campaign', 'Charity' as Division FROM NewMYDB_PROD..VW_CH_SS WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeID,'') <> '' and Status <> 'SubmissionDate' and IsDeleted = 0 
GROUP BY Client) A 
LEFT JOIN NewMYDB_PROD..VW_CampaignList B ON A.Campaign = B.ClientCode 
LEFT JOIN #ReportDate Z ON A.Division = Z.Division  and B.Campaign = Z.Customer
WHERE Z.Customer is null
    
INSERT INTO #ReportDate (Country, Division, Customer, Weekending, RMonth, RQuarter, CountryUSHC, USCH)
SELECT  'Malaysia' as 'Country', A.Division, B.Campaign as 'Customer', @CountryWeDate as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter', @UniqueSCH as 'CountryUniqueSHC',  0 as 'UniqueSHC' FROM (
SELECT B.Campaign as 'Campaign', 'Commercial' as Division FROM NewMYDB_PROD..Txn_Commercial_StatusSummary A LEFT JOIN NewMYDB_PROD..Txn_Commercial B ON A.TxnID = B.TxnID  and B.Campaign = 'STMMY'
WHERE StatusWEDate = @CountryWeDate 
and ISNULL(B.BadgeID,'') <> '' and Status <> 'SubmissionDate' and IsDeleted = 0 
GROUP BY Campaign) A 
LEFT JOIN NewMYDB_PROD..VW_CampaignList B ON A.Campaign = B.ClientCode 
LEFT JOIN #ReportDate Z ON A.Division = Z.Division  and B.Campaign = Z.Customer
WHERE Z.Customer is null
  

UPDATE A SET A.ResubPiece = B.ResubPiece, A.GrossPiece = B.GrossPiece, A.GrossPieceOT = B.GrossPieceOT, A.RejectPiece = B.RejectPiece, A.GrossSales = B.Gross, A.NetPiece = B.NetPiece FROM #ReportDate A INNER JOIN(
SELECT B.Campaign as 'Campaign',SUM(CASE WHEN A.Status in ('SubmissionDate','ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate') THEN ICStroke ELSE 0 END) as 'Gross',
SUM(CASE WHEN A.Status in ('SubmissionDate','ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate') THEN 1 ELSE -1 END) as 'NetPiece' ,
SUM(CASE WHEN A.Status in ('ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate') THEN 1 ELSE 0 END) as 'ResubPiece' ,
SUM(CASE WHEN A.Status in ('SubmissionDate') THEN Case WHEN C.Frequency > 0 THEN 1 ELSE 0 END ELSE 0 END) as 'GrossPiece',
SUM(CASE WHEN A.Status in ('SubmissionDate') THEN Case WHEN C.Frequency = 0 THEN 1 ELSE 0 END ELSE 0 END) as 'GrossPieceOT',
SUM(CASE WHEN A.Status in ('ClientRejectDate','UpDownRejectDate','RejectDate') THEN 1 ELSE 0 END) as 'RejectPiece' FROM NewMYDB_PROD..VW_CH_SS A
LEFT JOIN NewMYDB_PROD..VW_CampaignList B ON A.Client = B.ClientCode
LEFT JOIN NewMYDB_PROD..MST_CHR_Package C ON A.PackageId = C.PackageID
  WHERE StatusWEDate = @CountryWeDate  and ICStroke > 0
and ISNULL(BadgeID,'') <> '' and A.Status in ('SubmissionDate','ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate','ClientRejectDate','UpDownRejectDate','RejectDate')
and IsDeleted = 0
GROUP BY   B.Campaign
) B ON A.Country = 'Malaysia' and A.Division = 'Charity' and A.Customer = B.Campaign

UPDATE A SET A.RejectPiece = B.RejectPiece, A.GrossPieceOT = 0, A.ResubPiece = B.ResubPiece, A.GrossPiece =  B.GrossPiece, A.GrossSales = B.Gross, A.NetPiece = B.NetPiece FROM #ReportDate A INNER JOIN(
SELECT 'TAKAFUL' as 'Campaign', SUM(Case WHEN A.Status in ('SubmissionDate','ReSubDate','ClientReSubDate') THEN ICStroke_H  ELSE 0 END) as 'Gross', 
SUM(Case WHEN A.Status in ('SubmissionDate','ReSubDate','ClientReSubDate') THEN 1 ELSE -1 END) as 'NetPiece',
SUM(Case WHEN A.Status not in ('SubmissionDate','ReSubDate','ClientReSubDate') THEN 1 ELSE 0 END) as 'RejectPiece',
SUM(Case WHEN A.Status in ('SubmissionDate') THEN 1 ELSE 0 END) as 'GrossPiece',
SUM(Case WHEN A.Status in ('ReSubDate','ClientReSubDate') THEN 1 ELSE 0 END) as 'ResubPiece'   FROM NewMYDB_PROD..Tbl_TKF_Maintable_StatusSummary A LEFT JOIN NewMYDB_PROD..Tbl_TKF_Maintable B ON A.RowId = B.RowId LEFT JOIN NewMYDB_PROD..VW_TKF_PackagesName C ON B.MonthlyPremiumId = C.Id
where A.StatusWE = @CountryWeDate and A.IsDeleted = 0
and A.Status in ('SubmissionDate','ReSubDate','ClientReSubDate','ClientRejectDate','RejectDate') 
) B ON A.Country = 'Malaysia' and A.Division = 'Commercial' and A.Customer = B.Campaign



UPDATE A SET A.ResubPiece = B.ResubPiece, A.GrossPiece = B.GrossPiece, A.GrossPieceOT = B.GrossPieceOT, A.RejectPiece = B.RejectPiece, A.GrossSales = B.Gross, A.NetPiece = B.NetPiece FROM #ReportDate A INNER JOIN(
SELECT C.Campaign as 'Campaign',SUM(CASE WHEN A.Status in ('SubmissionDate','ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate') THEN ICStroke ELSE 0 END) as 'Gross',
SUM(CASE WHEN A.Status in ('SubmissionDate','ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate') THEN 1 ELSE -1 END) as 'NetPiece' ,
SUM(CASE WHEN A.Status in ('ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate') THEN 1 ELSE 0 END) as 'ResubPiece' ,
SUM(CASE WHEN A.Status in ('SubmissionDate') THEN   1 ELSE 0  END) as 'GrossPiece',
0 as 'GrossPieceOT',
SUM(CASE WHEN A.Status in ('ClientRejectDate','UpDownRejectDate','RejectDate') THEN 1 ELSE 0 END) as 'RejectPiece' 
FROM NewMYDB_PROD..Txn_Commercial_StatusSummary A LEFT JOIN NewMYDB_PROD..Txn_Commercial B ON A.TxnID = B.TxnID  and B.Campaign = 'STMMY'
LEFT JOIN NewMYDB_PROD..VW_CampaignList C ON B.Campaign = C.ClientCode 
  WHERE StatusWEDate = @CountryWeDate  and ICStroke > 0
and ISNULL(B.BadgeID,'') <> '' and A.Status in ('SubmissionDate','ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate','ClientRejectDate','UpDownRejectDate','RejectDate')
and IsDeleted = 0
GROUP BY C.Campaign
) B ON A.Country = 'Malaysia' and A.Division = 'Commercial' and A.Customer = B.Campaign


 UPDATE A SET A.GrossPieceOT = 0, A.RejectPiece = 0, A.ResubPiece = 0, A.GrossPiece = B.NetPiece, A.GrossSales = B.Gross, A.NetPiece = B.NetPiece FROM #ReportDate A INNER JOIN(
SELECT B.Campaign as 'Campaign', SUM(TTL_MSF) as 'Gross', SUM(C.Purchase_Qty) as 'NetPiece' FROM NewMYDB_PROD..TXN_Lif_SalesHeader A 
LEFT JOIN NewMYDB_PROD..TXN_Lif_Sales_Detail C ON A.Trxn_No = C.Trxn_No and C.Purchase_Qty > 0
LEFT JOIN NewMYDB_PROD..VW_CampaignList B ON A.PRDCAT_Code = B.ClientCode
 where MO_Sub_Week = @CountryWeDate and DE_By is not null and A.IsDeleted = 0 and C.IsDeleted = 0
 GROUP BY B.Campaign  

) B ON A.Country = 'Malaysia' and A.Division = 'LifeStyle' and A.Customer = B.Campaign
 
 UPDATE A SET A.GrossPieceOT = 0, A.RejectPiece = 0, A.ResubPiece = 0, A.GrossPiece = B.NetPiece, A.GrossSales = B.Gross, A.NetPiece = B.NetPiece FROM #ReportDate A INNER JOIN(
SELECT B.Campaign as 'Campaign', SUM(TTLValue) as 'Gross', SUM(TTLPcs) as 'NetPiece' FROM NewMYDB_PROD..TXN_CO_ICE_HASAVA A  
LEFT JOIN NewMYDB_PROD..VW_CampaignList B ON B.ClientCode = 'HS'
 where WEDate = @CountryWeDate 
 GROUP BY B.Campaign   
) B ON A.Country = 'Malaysia' and A.Division = 'Commercial' and A.Customer = 'HASAVA'
  


SET @UniqueDiv1 = 0
SET @UniqueDiv2 = 0
SET @UniqueDiv3 = 0
SELECT @UniqueDiv1 = COUNT(Distinct BadgeNo) FROM (
SELECT distinct BadgeID as 'BadgeNo'  FROM  NewMYDB_PROD..VW_CH_SS WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeID,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0  
) A

SELECT @UniqueDiv2 = COUNT(Distinct ICBadgeNo_H) FROM (
SELECT  Distinct ICBadgeNo_H FROM NewMYDB_PROD..Tbl_TKF_Maintable_StatusSummary WHERE StatusWE = @CountryWeDate and IsDeleted = 0 and Status = 'SubmissionDate' UNION ALL
SELECT  DISTINCT AgentID  FROM NewMYDB_PROD..TXN_CO_ICE_HASAVA where WEDate = @CountryWeDate 
UNION ALL
SELECT distinct A.BadgeID FROM NewMYDB_PROD..Txn_Commercial_StatusSummary A LEFT JOIN NewMYDB_PROD..Txn_Commercial B ON A.TxnID = B.TxnID  and B.Campaign = 'STMMY'
where StatusWEDate = @CountryWeDate and A.Status = 'SubmissionDate' and A.IsDeleted = 0  
) A
 
SELECT @UniqueDiv3 = COUNT(Distinct IC_Code) FROM (
SELECT   DISTINCT IC_Code FROM NewMYDB_PROD..TXN_Lif_SalesHeader where MO_Sub_Week = @CountryWeDate and DE_By is not null and IsDeleted = 0 and PRDCAT_Code <>'WTB'
) A

UPDATE #ReportDate SET DivUSCH = @UniqueDiv1 where Country = 'Malaysia' and Division = 'Charity'
UPDATE #ReportDate SET DivUSCH = @UniqueDiv2 where Country = 'Malaysia' and Division = 'Commercial'
UPDATE #ReportDate SET DivUSCH = @UniqueDiv3 where Country = 'Malaysia' and Division = 'LifeStyle'
END
-- =================================================== MALAYSIA (END  )====================================================================
-- ========================================================================================================================================

-- =================================================== PHILIPPINES (START)====================================================================
-- ===========================================================================================================================================
 
SET @weFromDate = NULL
SET @weToDate = null
set @CountryWeDate = null

SELECT @weFromDate = FromDate, @weToDate = ToDate, @CountryWeDate = WEdate  FROM NewPHDB_PROD..Mst_Weekending where WEdate = @weDate

--If not found, Possible short week. check WE -1
IF (@weFromDate is null )
BEGIN 
SELECT @weFromDate = FromDate, @weToDate = ToDate, @CountryWeDate = WEdate  FROM NewPHDB_PROD..Mst_Weekending where WEdate = DATEADD(day, -1 ,@weDate)
END
--If not found, Possible short week. check WE -2
IF (@weFromDate is null )
BEGIN 
SELECT @weFromDate = FromDate, @weToDate = ToDate, @CountryWeDate = WEdate  FROM NewPHDB_PROD..Mst_Weekending where WEdate = DATEADD(day, -2 ,@weDate)
END

--If not found, Possible long week. check WE + 1
IF (@weFromDate is null )
BEGIN 
SELECT @weFromDate = FromDate, @weToDate = ToDate, @CountryWeDate = WEdate  FROM NewPHDB_PROD..Mst_Weekending where WEdate = DATEADD(day, 1 ,@weDate)
END


IF (@CountryWeDate is not null )
BEGIN
 

SELECT @UniqueSCH = COUNT(Distinct BadgeNo) FROM (
SELECT distinct BadgeNo as 'BadgeNo'  FROM  NewPHDB_PROD..VW_CH_SS WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeNo,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0   and IsDeleted = 0   UNION ALL 
SELECT distinct BadgeNo as 'BadgeNo' FROM NewPHDB_PROD..VW_CO_TXN  WHERE MoSubmissionDate >= @weFromDate and MoSubmissionDate <=@weToDate    and IsDeleted = 0
) A
 
INSERT INTO #ReportDate (Country, Division, Customer, Weekending, RMonth, RQuarter, CountryUSHC, USCH)
SELECT 'Philippines' as 'Country', A.Division, A.Campaign as 'Customer', @CountryWeDate as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter', @UniqueSCH as 'CountryUniqueSHC',  A.BadgeNo as 'UniqueSHC' FROM (
SELECT B.Client as 'Campaign', 'Charity' as Division, COUNT( distinct BadgeNo) as 'BadgeNo'  FROM NewPHDB_PROD..VW_CH_SS A 
LEFT JOIN NewPHDB_PROD..VW_MST_CampaignList B ON A.CampaignCode = B.ID
WHERE StatusWEDate = @CountryWeDate  and ISNULL(BadgeNo,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0
GROUP BY  B.Client 
UNION ALL
SELECT  B.Client as 'Campaign', 'Commercial' as Division,COUNT( distinct BadgeNo) as 'BadgeNo'   FROM NewPHDB_PROD..VW_CO_TXN A 
LEFT JOIN NewPHDB_PROD..VW_MST_CampaignList B ON A.CampaignCode = B.ID
WHERE MoSubmissionDate >= @weFromDate and MoSubmissionDate <=@weToDate  and IsDeleted = 0
GROUP BY  B.Client 
) A 


UPDATE A SET A.ResubPiece = B.ResubPiece,  A.RejectPiece = B.RejectPiece, A.GrossPieceOT = B.GrossPieceOT,  A.GrossPiece = B.GrossPiece, A.GrossSales = B.Gross, A.NetPiece = B.NetPiece FROM #ReportDate A INNER JOIN(
SELECT B.Client as 'Campaign',SUM(CASE WHEN A.Status in ('SubmissionDate','ReSubmissionDate','ClientResubmissionDate') THEN A.ICStrokeValue ELSE 0 END) as 'Gross',
SUM(CASE WHEN A.Status in ('SubmissionDate','ReSubmissionDate','ClientResubmissionDate') THEN 1 ELSE -1 END) as 'NetPiece',
SUM(CASE WHEN A.Status in ('SubmissionDate') THEN Case WHEN C.Frequency > 0 THEN 1 END  ELSE 0 END) as 'GrossPiece',
SUM(CASE WHEN A.Status in ('SubmissionDate') THEN Case WHEN C.Frequency = 0 THEN 1 END ELSE 0 END) as 'GrossPieceOT',
SUM(CASE WHEN A.Status in ('ReSubmissionDate','ClientResubmissionDate') THEN 1 ELSE 0 END) as 'ResubPiece' ,
SUM(CASE WHEN A.Status not in ('SubmissionDate','ReSubmissionDate','ClientResubmissionDate') THEN 1 ELSE 0 END) as 'RejectPiece'   FROM NewPHDB_PROD..VW_CH_SS A 
LEFT JOIN NewPHDB_PROD..VW_MST_CampaignList B ON A.CampaignCode = B.ID
LEFT JOIN NewPHDB_PROD..VW_CHR_TXN  C ON A.TxnId = C.TxnID 
WHERE StatusWEDate = @CountryWeDate 
and ISNULL(A.BadgeNo,'') <> '' and A.Status in ('SubmissionDate','ReSubmissionDate','ClientResubmissionDate','RejectDate','ClientRejectDate')
and A.IsDeleted = 0
GROUP BY B.Client 
) B ON A.Country = 'Philippines' and A.Division = 'Charity' and A.Customer = B.Campaign
 

UPDATE A SET A.GrossPieceOT = 0, A.ResubPiece = 0, A.RejectPiece = 0, A.GrossPiece = B.NetPiece, A.GrossSales = B.Gross, A.NetPiece = B.NetPiece FROM #ReportDate A INNER JOIN(
SELECT C.Client as 'Campaign', SUM(Quantity) as 'NetPiece',   SUM(Price * Quantity) + MAX(A.OtherAmount) as 'Gross'  FROM NewPHDB_PROD..VW_CO_TXN A 
LEFT JOIN NewPHDB_PROD..Txn_Co_Campaign_Product B ON A.TxnId = B.TxnId 
LEFT JOIN  NewPHDB_PROD..VW_MST_CampaignList C ON A.CampaignCode = C.ID
  WHERE MoSubmissionDate >= @weFromDate and MoSubmissionDate <=@weToDate  and A.IsDeleted = 0  and B.IsDeleted = 0
  GROUP BY C.Client
) B ON A.Country = 'Philippines' and A.Division = 'Commercial' and A.Customer = B.Campaign
 

SET @UniqueDiv1 = 0
SET @UniqueDiv2 = 0 
SELECT @UniqueDiv1 = COUNT(Distinct BadgeNo) FROM (
SELECT distinct BadgeNo as 'BadgeNo'  FROM  NewPHDB_PROD..VW_CH_SS WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeNo,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0   and IsDeleted = 0) A

SELECT @UniqueDiv2 = COUNT(Distinct BadgeNo) FROM (
SELECT distinct BadgeNo as 'BadgeNo' FROM NewPHDB_PROD..VW_CO_TXN  WHERE MoSubmissionDate >= @weFromDate and MoSubmissionDate <=@weToDate    and IsDeleted = 0
) A 

UPDATE #ReportDate SET DivUSCH = @UniqueDiv1 where Country = 'Philippines' and Division = 'Charity'
UPDATE #ReportDate SET DivUSCH = @UniqueDiv2 where Country = 'Philippines' and Division = 'Commercial' 

END
-- =================================================== PHILIPPINES ( END )====================================================================
-- ===========================================================================================================================================




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
 
INSERT INTO #ReportDate (Country, Division, Customer, Weekending, RMonth, RQuarter, CountryUSHC, USCH)
SELECT 'India' as 'Country', A.Division, A.Campaign as 'Customer', @CountryWeDate as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter', @UniqueSCH as 'CountryUniqueSHC',  A.BadgeNo as 'UniqueSHC' FROM (
SELECT B.Client as 'Campaign', 'Charity' as Division, COUNT( distinct BadgeNo) as 'BadgeNo'  FROM NewIndiaDB_PROD..VW_CH_SS A 
LEFT JOIN NewIndiaDB_PROD..VW_MST_CampaignList B ON A.Client = B.ID
WHERE StatusWEDate = @CountryWeDate  and ISNULL(BadgeNo,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0
GROUP BY  B.Client   
) A 



UPDATE A SET A.GrossPieceOT = 0, A.ResubPiece =B.ResubPiece, A.RejectPiece = B.RejectPiece,  A.GrossPiece = B.GrossPiece, A.GrossSales = B.Gross, A.NetPiece = B.NetPiece FROM #ReportDate A INNER JOIN(
SELECT B.Client as 'Campaign',SUM(CASE WHEN Status in ('SubmissionDate','ReSubmissionDate','ClientResubmissionDate') THEN ICStrokeValue ELSE 0 END) as 'Gross',
SUM(CASE WHEN Status in ('SubmissionDate','ReSubmissionDate','ClientResubmissionDate') THEN 1 ELSE -1 END) as 'NetPiece' ,
SUM(CASE WHEN Status in ('SubmissionDate') THEN 1 ELSE 0 END) as 'GrossPiece' ,
SUM(CASE WHEN Status in ('ReSubmissionDate','ClientResubmissionDate') THEN 1 ELSE 0 END) as 'ResubPiece' ,
SUM(CASE WHEN Status not in ('SubmissionDate','ReSubmissionDate','ClientResubmissionDate') THEN 1 ELSE 0 END) as 'RejectPiece' FROM NewIndiaDB_PROD..VW_CH_SS A 
LEFT JOIN NewIndiaDB_PROD..VW_MST_CampaignList B ON A.Client = B.ID
WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeNo,'') <> '' and Status in ('SubmissionDate','ReSubmissionDate','ClientResubmissionDate','RejectDate','ClientRejectDate')
and IsDeleted = 0
GROUP BY B.Client 
) B ON A.Country = 'India' and A.Division = 'Charity' and A.Customer = B.Campaign



SET @UniqueDiv1 = 0 
SELECT @UniqueDiv1 = COUNT(Distinct BadgeNo) FROM (
SELECT  distinct BadgeNo as 'BadgeNo'  FROM NewIndiaDB_PROD..VW_CH_SS A 
LEFT JOIN NewIndiaDB_PROD..VW_MST_CampaignList B ON A.Client = B.ID
WHERE StatusWEDate = @CountryWeDate  and ISNULL(BadgeNo,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0  ) A

UPDATE #ReportDate SET DivUSCH = @UniqueDiv1 where Country = 'India' and Division = 'Charity' 

END
-- =================================================== INDIA (END)==========================================================================
-- ===========================================================================================================================================



-- =================================================== TAIWAN (START)=========================================================================
-- ===========================================================================================================================================


SET @weFromDate = NULL
SET @weToDate = null
set @CountryWeDate = null

SELECT @weFromDate = FromDate, @weToDate = ToDate, @CountryWeDate = WEdate  FROM NewTWDB_PROD..tbl_Weekending where WEdate = @weDate

--If not found, Possible short week. check WE -1
IF (@weFromDate is null )
BEGIN 
SELECT @weFromDate = FromDate, @weToDate = ToDate, @CountryWeDate = WEdate  FROM NewTWDB_PROD..tbl_Weekending where WEdate = DATEADD(day, -1 ,@weDate)
END
--If not found, Possible short week. check WE -2
IF (@weFromDate is null )
BEGIN 
SELECT @weFromDate = FromDate, @weToDate = ToDate, @CountryWeDate = WEdate  FROM NewTWDB_PROD..tbl_Weekending where WEdate = DATEADD(day, -2 ,@weDate)
END

--If not found, Possible long week. check WE + 1
IF (@weFromDate is null )
BEGIN 
SELECT @weFromDate = FromDate, @weToDate = ToDate, @CountryWeDate = WEdate  FROM NewTWDB_PROD..tbl_Weekending where WEdate = DATEADD(day, 1 ,@weDate)
END


IF (@CountryWeDate is not null )
BEGIN
 
SELECT @UniqueSCH = COUNT(Distinct BadgeNo) FROM (
SELECT distinct BadgeID as 'BadgeNo'  FROM  NewTWDB_PROD..VW_CH_SS WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeID,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0   and IsDeleted = 0   
) A


INSERT INTO #ReportDate (Country, Division, Customer, Weekending, RMonth, RQuarter, CountryUSHC, USCH)
SELECT 'Taiwan' as 'Country', A.Division, B.Campaign as 'Customer', @CountryWeDate as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter', @UniqueSCH as 'CountryUniqueSHC', 0  FROM (
SELECT Client as 'Campaign', 'Charity' as Division, COUNT( distinct BadgeID) as 'BadgeNo'  FROM NewTWDB_PROD..VW_CH_SS WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeID,'') <> '' and Status IN ('SubmissionDate','RejectDate','ReSubmissionDate','ClientRejectDate','ClientReSubmissionDate','UpDownResubDate','UpDownRejectDate', 'ClientClawBack60') and IsDeleted = 0
GROUP BY Client
) A LEFT JOIN NewTWDB_PROD..VW_CampaignList B ON A.Campaign = B.ClientCode 
 
 SELECT           
    MAIN.[TxnID]          
   ,CASE WHEN MAIN.Status IN('SubmissionDate') THEN '0SUBMISSION'    
      WHEN MAIN.Status IN ('RejectDate','UpDownRejectDate') THEN '1APPCOREJECT'    
   WHEN MAIN.Status IN ('ClientRejectDate', 'ClientClawBack60') THEN '2CLIENTREJECT'    
   WHEN MAIN.Status IN('ReSubmissionDate','UpDownResubDate') THEN '3APPCORESUB'    
   WHEN MAIN.Status IN('ClientReSubmissionDate') THEN '4CLIENTRESUB'     
   END AS Type    
   ,CTXN.SerialNumber    
   ,C.Client Campaign    
   ,UPPER(MAIN.[MOCode]) [MOCode]          
   ,UPPER(MAIN.[BadgeID]) [BadgeID]      
   ,MAIN.BAlevel        
   ,CTXN.SignUpDate    
   ,MAIN.BAStatus     
   ,G.Frequency          
   ,G.PackageID    
   ,H.Campaign + CONVERT(VARCHAR(2),G.Frequency) + '_' + CASE WHEN MAIN.PackageValue < 500 THEN 'Below'     
           WHEN MAIN.PackageValue > 1500 THEN 'Above'     
           ELSE '' END +     
           CASE WHEN G.Frequency = 1 AND MAIN.PackageValue < 500 THEN '500'    
             WHEN G.Frequency = 6 AND MAIN.PackageValue < 3000 THEN '3000'    
           ELSE    
           CONVERT(VARCHAR(10), CONVERT(INT,MAIN.PackageValue)) END    
   + CASE WHEN Age < 26 THEN 'Y' ELSE '' END AS PackageName          
   ,MAIN.PackageValue [PackageValue]          
   ,MAIN.ICStroke        
   ,MAIN.[TXN_Status]    
   ,CTXN.Age    
   ,ISNULL(CTXN.MOResubDate, CTXN.SubmissionDate) AS MOSubDate          
   ,CASE WHEN MAIN.STATUS IN ('RejectDate','UpDownRejectDate') OR (MAIN.RejectCode IS NOT NULL AND MAin.Txn_Status != 'OR') THEN MAIN.StatusDate ELSE NULL END AS AppcoRejDate --[AppcoRejDate]     
   ,CASE WHEN MAIN.STATUS IN ('ClientRejectDate', 'ClientClawBack60') THEN MAIN.StatusDate ELSE NULL END AS ClientRejDate--[ClientRejDate]    
   ,CTXN.DateOfBirth    
   ,CASE WHEN MAIN.STATUS IN ('RejectDate','UpDownRejectDate','ClientRejectDate') OR (MAIN.RejectCode IS NOT NULL AND MAin.Txn_Status != 'OR') 
			THEN CASE WHEN ISNULL(MAIN.RejectCode,'') = '' THEN TXN.BankReason ELSE MAIN.RejectCode END
		WHEN MAIN.STATUS IN ('ClientClawBack60') OR (MAIN.RejectCode IS NOT NULL AND MAin.Txn_Status != 'OR') THEN 'C'
		ELSE NULL END 'RejectCode'  
   ,CASE WHEN MAIN.STATUS IN ('RejectDate','UpDownRejectDate','ClientRejectDate') OR (MAIN.RejectCode IS NOT NULL AND MAin.Txn_Status != 'OR') 
			THEN CASE WHEN ISNULL(MAIN.RejectReason,'') = '' THEN TXN.ReasonDesc ELSE MAIN.RejectReason END
		WHEN MAIN.STATUS IN ('ClientClawBack60') OR (MAIN.RejectCode IS NOT NULL AND MAin.Txn_Status != 'OR') THEN 'Donor Cancellation'
		ELSE NULL END 'RejectReason'
	,MAIN.ChannelId
   INTO #MainTransaction    
 FROM NewTWDB_PROD..[Txn_Transaction_StatusSummary] MAIN        
 INNER JOIN NewTWDB_PROD..[TXN_TRANSACTION] TXN on MAIN.TxnID = TXN.TxnID  AND TXN.Status NOT IN ('AC', 'MC')
 LEFT JOIN NewTWDB_PROD..VW_CHR_TXN CTXN ON CTXN.TXNID = MAIN.TxnID    
 LEFT JOIN NewTWDB_PROD..[MST_CHR_Package] G ON G.PackageID = MAIN.PackageID     
 LEFT OUTER JOIN NewTWDB_PROD..VW_CampaignList H on CTXN.Client = H.ClientCode
 INNER JOIN NewTWDB_PROD..VW_ALL_Clients C ON CTXN.Client = C.ClientCode AND C.CountryCode = 'TW' AND C.IsDeleted = 0         
 WHERE (   MAIN.STATUS in('SubmissionDate','RejectDate','ReSubmissionDate','ClientRejectDate','ClientReSubmissionDate','UpDownResubDate','UpDownRejectDate', 'ClientClawBack60')        
	  AND StatusWEDate = @CountryWeDate    
	  AND MAIN.IsDeleted = 0
	  AND ISNULL(MAIN.RejectReason, '') NOT IN ('Pending more than 65 days')
  )
  -- quick fix for pending more than 65 days reject under HQ
  OR ( MAIN.STATUS in('RejectDate')     
	  AND StatusWEDate = @CountryWeDate    
	  AND MAIN.IsDeleted = 0
	  AND ISNULL(MAIN.RejectReason, '') IN ('Pending more than 65 days')
	  AND MAIN.ICStroke > 0
  )
    
 SELECT     
  A.Type    
    ,A.SerialNumber    
    ,A.Campaign    
    ,A.[MOCode]          
    ,A.[BadgeID]       
    ,A.SignUpDate    
    ,A.Frequency                 
    ,A.PackageValue    
    ,A.Age    
    ,A.PackageName    
    ,A.ICStroke AS Commission    
    ,A.MOSubDate     
    ,CASE WHEN ISNULL(A.RejectReason,'') <> '' THEN A.AppcoRejDate     
    WHEN A.Type = '2CLIENTREJECT' THEN ClientRejDate    
     ELSE NULL END AS RejectDate    
    ,A.ClientRejDate    
    ,A.RejectCode    
    ,A.RejectReason
	,A.ChannelId    
 INTO #ICETable    
 FROM #MainTransaction A    
 WHERE (Type IN ('0SUBMISSION', '1APPCOREJECT') OR (Type IN ('4CLIENTRESUB','3APPCORESUB', '2CLIENTREJECT') AND ICStroke > 0)) -- resub only show icstroke more than 0, request by Jane    
     
 -- UPDATE the Appco Reject date in Submission tab    
 UPDATE A    
 SET A.RejectDate = B.RejectDate    
 FROM #ICETable A     
 INNER JOIN #ICETable B ON A.SerialNumber = B.SerialNumber AND B.Type = '1APPCOREJECT'    
       
UPDATE A SET  A.GrossPieceOT = B.GrossPieceOT ,A.RejectPiece = B.RejectPiece, A.ResubPiece = B.ResubPiece, A.GrossPiece = B.GrossPiece, 
A.GrossSales = B.Gross, A.NetPiece = B.NetPiece FROM #ReportDate A INNER JOIN(
 SELECT Campaign, COUNT(Distinct BadgeID) as 'BadgeNo',  SUM(CASE WHEN Type = '0SUBMISSION' and Frequency> 0 THEN 1 ELSE 0 END) as 'GrossPiece',
 SUM(CASE WHEN Type = '0SUBMISSION' and Frequency = 0 THEN 1 ELSE 0 END) as 'GrossPieceOT' ,
 SUM(CASE WHEN Type IN ( '0SUBMISSION','3APPCORESUB') THEN Commission ELSE 0 END) as 'Gross' ,
 SUM(CASE WHEN Type IN ( '2CLIENTREJECT','1APPCOREJECT')   THEN 1 ELSE 0 END) as 'RejectPiece' ,
 SUM(CASE WHEN Type IN ( '2CLIENTREJECT','1APPCOREJECT')   THEN -1 ELSE 1 END) as 'NetPiece' ,
 SUM(CASE WHEN Type IN ( '3APPCORESUB')   THEN 1 ELSE 0 END) as 'ResubPiece'  FROM #ICETable 
 GROUP BY Campaign  
) B ON A.Country = 'Taiwan' and A.Division = 'Charity' and A.Customer = B.Campaign
 
 UPDATE A SET  A.USCH =  ISNULL(B.BadgeNo,0) FROM #ReportDate A INNER JOIN(
 SELECT  Campaign, COUNT(Distinct BadgeID) as 'BadgeNo'   FROM #ICETable WHERE Type ='0SUBMISSION'
    GROUP BY Campaign  
) B ON A.Country = 'Taiwan' and A.Division = 'Charity' and A.Customer = B.Campaign
 
UPDATE #ReportDate SET DivUSCH = CountryUSHC where Country = 'Taiwan' and Division = 'Charity' 


END
-- =================================================== TAIWAN (END)=========================================================================
-- ===========================================================================================================================================




-- =================================================== HONG KONG(START)=======================================================================
-- ===========================================================================================================================================



SET @weFromDate = NULL
SET @weToDate = null
set @CountryWeDate = null

SELECT @weFromDate = FromDate, @weToDate = ToDate, @CountryWeDate = WEdate  FROM NewHKDB_PROD..Mst_Weekending where WEdate = @weDate

--If not found, Possible short week. check WE -1
IF (@weFromDate is null )
BEGIN 
SELECT @weFromDate = FromDate, @weToDate = ToDate, @CountryWeDate = WEdate  FROM NewHKDB_PROD..Mst_Weekending where WEdate = DATEADD(day, -1 ,@weDate)
END
--If not found, Possible short week. check WE -2
IF (@weFromDate is null )
BEGIN 
SELECT @weFromDate = FromDate, @weToDate = ToDate, @CountryWeDate = WEdate  FROM NewHKDB_PROD..Mst_Weekending where WEdate = DATEADD(day, -2 ,@weDate)
END

--If not found, Possible long week. check WE + 1
IF (@weFromDate is null )
BEGIN 
SELECT @weFromDate = FromDate, @weToDate = ToDate, @CountryWeDate = WEdate  FROM NewHKDB_PROD..Mst_Weekending where WEdate = DATEADD(day, 1 ,@weDate)
END


IF (@CountryWeDate is not null )
BEGIN
SELECT @UniqueSCH = COUNT(Distinct BadgeNo) FROM (
SELECT distinct BadgeNo as 'BadgeNo'  FROM  NewHKDB_PROD..Txn_Transaction_StatusSummary WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeNo,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0   and IsDeleted = 0  
UNION ALL
SELECT DISTINCT BADGEID  as 'BadgeNo'  FROM Appco360_PROD..[Txn_SalesImport] A where A.Country = 'HK' and A.Campaign in ('Viospace','Home Cuisine') and A.IsDeleted = 0 and A.WEDate = @CountryWeDate
) A

INSERT INTO #ReportDate (Country, Division, Customer, Weekending, RMonth, RQuarter, CountryUSHC, USCH)
SELECT 'Hong Kong' as 'Country', A.Division, A.Campaign as 'Customer', @CountryWeDate as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter', @UniqueSCH as 'CountryUniqueSHC',  A.BadgeNo as 'UniqueSHC' FROM (
SELECT CampaignCode as 'Campaign', 'Charity' as Division, COUNT( distinct BadgeNo) as 'BadgeNo'  FROM NewHKDB_PROD..Txn_Transaction_StatusSummary WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeNo,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0
GROUP BY CampaignCode
) A  

UPDATE A SET A.GrossPieceOT = B.GrossPieceOT, A.ResubPiece = B.ResubPiece, A.RejectPiece = B.RejectPiece,  A.GrossPiece = B.GrossPiece, A.GrossSales = B.Gross, A.NetPiece = B.NetPiece FROM #ReportDate A INNER JOIN(
SELECT CampaignCode as 'Campaign',SUM(CASE WHEN Status in ('SubmissionDate','ReSubmissionDate') THEN A.PackageValue ELSE 0 END) as 'Gross',
SUM(CASE WHEN Status in ('SubmissionDate','ReSubmissionDate') THEN 1 ELSE -1 END) as 'NetPiece',
SUM(CASE WHEN Status in ('SubmissionDate') THEN Case WHEN B.Frequency > 0 THEN 1 ELSE 0 END ELSE 0 END) as 'GrossPiece' ,
SUM(CASE WHEN Status in ('SubmissionDate') THEN Case WHEN B.Frequency = 0 THEN 1 ELSE 0 END ELSE 0 END) as 'GrossPieceOT' ,
SUM(CASE WHEN Status in ('ReSubmissionDate') THEN 1 ELSE 0 END) as 'ResubPiece' ,
SUM(CASE WHEN Status not in ('SubmissionDate','ReSubmissionDate') THEN 1 ELSE 0 END) as 'RejectPiece'  FROM NewHKDB_PROD..Txn_Transaction_StatusSummary A
LEFT JOIN NewHKDB_PROD..Mst_Ch_Package B ON A.PackageId = B.PackageId
WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeNo,'') <> '' and Status in ('SubmissionDate','ReSubmissionDate','RejectDate')
and A.IsDeleted = 0
GROUP BY   CampaignCode
) B ON A.Country = 'Hong Kong' and A.Division = 'Charity' and A.Customer = B.Campaign




INSERT INTO #ReportDate (Country, Division, Customer, Weekending, RMonth, RQuarter, CountryUSHC, USCH)
SELECT 'Hong Kong' as 'Country', A.Division, A.Campaign as 'Customer', @CountryWeDate as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter', @UniqueSCH as 'CountryUniqueSHC',  A.BadgeNo as 'UniqueSHC' FROM (
SELECT 'Hong Kong' as 'Country','Commercial' as 'Division' , A.Campaign ,COUNT( distinct BadgeID) as 'BadgeNo'  FROM Appco360_PROD..Txn_SalesImport A
where A.Country = 'HK' and A.Campaign in ('Viospace','Home Cuisine') and IsDeleted = 0 and WEDate = @CountryWeDate
GROUP BY A.Campaign
) A  

UPDATE A SET A.GrossPiece = B.Gross, A.GrossPieceOT = 0, A.RejectPiece = B.RejectPieces, A.ResubPiece = B.ResubPieces,
A.NetPiece = B.Net, A.GrossSales = B.GrossEarning  FROM #ReportDate A INNER JOIN 
 (SELECT 'Hong Kong' as  Country, Campaign, SUM(Signuppieces) as 'Gross', 0 as 'OT',SUM(RejectPieces) as 'RejectPieces', SUM(ResubPieces) as 'ResubPieces', SUM(Signuppieces) + SUM(ResubPieces) - SUM(RejectPieces)  as 'Net',
 SUM(Totalearning) as 'GrossEarning'  FROM Appco360_PROD..[Txn_SalesImport]
 where Country = 'HK' and WEDate = @CountryWeDate and IsDeleted = 0
 GROUP BY Country, Campaign) B ON A.Country = B.Country  COLLATE Latin1_General_CI_AS  and A.Customer = B.Campaign COLLATE Latin1_General_CI_AS 
 WHERE A.Country = 'Hong Kong' and A.Division = 'Commercial' 

SET @UniqueDiv2 = (SELECT COUNT(distinct BadgeNo)  FROM  NewHKDB_PROD..Txn_Transaction_StatusSummary WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeNo,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0   and IsDeleted = 0  )
UPDATE #ReportDate SET DivUSCH = @UniqueDiv2 where Country = 'Hong Kong' and Division = 'Charity' 
 
SET @UniqueDiv1 = (SELECT COUNT(DISTINCT BadgeID) FROM  Appco360_PROD..[Txn_SalesImport] WHERE Country = 'HK' and WEDate = @CountryWeDate and IsDeleted = 0 and Campaign in ('Viospace','Home Cuisine'))
UPDATE #ReportDate SET DivUSCH = @UniqueDiv1 where Country = 'Hong Kong' and Division = 'Commercial' 
 END
-- =================================================== HONG KONG END)=========================================================================
-- ===========================================================================================================================================



-- =================================================== THAILAND (START)=======================================================================
-- ===========================================================================================================================================



SET @weFromDate = NULL
SET @weToDate = null
set @CountryWeDate = null

SELECT @weFromDate = FromDate, @weToDate = ToDate, @CountryWeDate = WEdate  FROM NewTHDB_PROD..Mst_Weekending where WEdate = @weDate

--If not found, Possible short week. check WE -1
IF (@weFromDate is null )
BEGIN 
SELECT @weFromDate = FromDate, @weToDate = ToDate, @CountryWeDate = WEdate  FROM NewTHDB_PROD..Mst_Weekending where WEdate = DATEADD(day, -1 ,@weDate)
END
--If not found, Possible short week. check WE -2
IF (@weFromDate is null )
BEGIN 
SELECT @weFromDate = FromDate, @weToDate = ToDate, @CountryWeDate = WEdate  FROM NewTHDB_PROD..Mst_Weekending where WEdate = DATEADD(day, -2 ,@weDate)
END

--If not found, Possible long week. check WE + 1
IF (@weFromDate is null )
BEGIN 
SELECT @weFromDate = FromDate, @weToDate = ToDate, @CountryWeDate = WEdate  FROM NewTHDB_PROD..Mst_Weekending where WEdate = DATEADD(day, 1 ,@weDate)
END


IF (@CountryWeDate is not null )
BEGIN

IF object_id('tempdb..#USHC_Charity') IS NOT NULL DROP TABLE #USHC_Charity
SELECT distinct A.BadgeNo as 'BadgeNo' INTO #USHC_Charity FROM  NewTHDB_PROD..Txn_Transaction_StatusSummary A
INNER JOIN NewTHDB_PROD..Mst_BARelationship R ON R.BadgeNo = A.BadgeNo AND R.WEDate = A.StatusWEDate AND R.CurrentLevel NOT IN ('O','BM')
WHERE StatusWEDate = @CountryWeDate 
and ISNULL(A.BadgeNo,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0

IF object_id('tempdb..#USHC_Commercial') IS NOT NULL DROP TABLE #USHC_Commercial
select distinct A.BadgeNo as 'BadgeNo' INTO #USHC_Commercial from NewTHDB_PROD..Txn_Transaction a
inner join NewTHDB_PROD..Txn_Co_CampaignTransaction b on b.TxnId = a.TxnId and b.IsDeleted = 0
INNER JOIN NewTHDB_PROD..Mst_BARelationship R ON R.BadgeNo = A.BadgeNo AND R.WEDate = A.MoSubmissionWEDate AND R.CurrentLevel NOT IN ('O','BM')
where a.IsDeleted = 0 and MoSubmissionWEDate = @CountryWeDate


SELECT @UniqueSCH_Charity = COUNT(Distinct BadgeNo) FROM #USHC_Charity

SELECT @UniqueSCH_Commercial = COUNT(Distinct BadgeNo) FROM #USHC_Commercial

SELECT @UniqueSCH = COUNT(Distinct BadgeNo) FROM (
SELECT BadgeNo FROM #USHC_Charity
UNION ALL
SELECT BadgeNo FROM #USHC_Commercial
) A

INSERT INTO #ReportDate (Country, Division, Customer, Weekending, RMonth, RQuarter, CountryUSHC, DivUSCH, USCH)
SELECT 'Thailand' as 'Country', A.Division, A.Campaign as 'Customer', @CountryWeDate as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter', @UniqueSCH as 'CountryUniqueSHC', A.DivisionUSHC,  A.BadgeNo as 'UniqueSHC' FROM (
SELECT CampaignCode as 'Campaign', 'Charity' as Division, COUNT( distinct BadgeNo) as 'BadgeNo', @UniqueSCH_Charity as 'DivisionUSHC'  FROM NewTHDB_PROD..Txn_Transaction_StatusSummary WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeNo,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0
GROUP BY CampaignCode
UNION ALL
select d.Client as 'Campaign', CASE WHEN d.Division = 'CO' THEN 'Commercial' ELSE d.Division END 'Division', COUNT( distinct a.BadgeNO) as 'BadgeNo', @UniqueSCH_Commercial as 'DivisionUSHC' 
from NewTHDB_PROD..Txn_Transaction a
inner join NewTHDB_PROD..Txn_Co_CampaignTransaction b on b.TxnId = a.TxnId and b.IsDeleted = 0
--inner join NewTHDB_PROD..Txn_Co_Campaign_Product c on c.TxnId = a.TxnId and c.IsDeleted = 0
inner join NewTHDB_PROD..VW_MST_CampaignList d on d.ID = b.CampaignId
where a.IsDeleted = 0 and MoSubmissionWEDate = @CountryWeDate
GROUP BY  d.Client, d.Division 
) A  

UPDATE A SET A.GrossPieceOT = B.GrossPieceOT, A.ResubPiece = B.ResubPiece, A.RejectPiece = B.RejectPiece, A.GrossSales = B.Gross, A.NetPiece = B.NetPiece, A.GrossPiece = B.GrossPiece FROM #ReportDate A INNER JOIN(
SELECT A.CampaignCode as 'Campaign',
SUM(CASE WHEN a.Status in ('SubmissionDate') AND a.MOCode <> 'AP' AND HQ.TxnId IS NULL AND CH.PaidStage IS NULL  THEN A.ICStrokeValue 
		 WHEN a.Status in ('SubmissionDate') AND a.MOCode = 'AP'  THEN A.ICStrokeValue 
	     WHEN a.Status in ('ReSubmissionDate','ClientReSubmissionDate') AND a.MOCode <> 'AP' THEN A.ICStrokeValue 
		 WHEN (CH.PaidStage IS NOT NULL and b.TxnId IS NULL AND a.Status = 'ClientApproved' AND A.PaymentMode = 'AD' AND a.MOCode <> 'AP') THEN A.ICStrokeValue
		 WHEN (v.BankAccountIssueBank LIKE '%Bangkok%' and b.TxnId IS NULL AND a.Status = 'ClientApproved' AND A.PaymentMode = 'AD' AND a.MOCode <> 'AP') THEN A.ICStrokeValue
		 ELSE 0 END) as 'Gross', 
SUM(CASE WHEN a.Status in ('ReSubmissionDate','ClientReSubmissionDate') THEN 1
	 WHEN a.Status in ('SubmissionDate') AND a.MOCode <> 'AP' THEN 1
	 WHEN a.Status in ('RejectDate','ClientRejectDate') THEN -1
     WHEN (CH.PaidStage IS NOT NULL and b.TxnId IS NULL AND a.Status = 'ClientApproved' AND A.PaymentMode = 'AD') THEN 1
	 WHEN (v.BankAccountIssueBank LIKE '%Bangkok%' and b.TxnId IS NULL AND a.Status = 'ClientApproved' AND A.PaymentMode = 'AD') THEN 1
	 END) as 'NetPiece',
SUM(CASE WHEN a.Status in ('SubmissionDate') AND a.MOCode <> 'AP' THEN CASE WHEN v.Frequency > 0 THEN 1 ELSE 0 END ELSE 0 END) as 'GrossPiece' ,
SUM(CASE WHEN a.Status in ('SubmissionDate') AND a.MOCode <> 'AP' THEN CASE WHEN v.Frequency = 0 THEN 1 ELSE 0 END ELSE 0 END) as 'GrossPieceOT' ,
SUM(CASE WHEN a.Status in ('ReSubmissionDate','ClientReSubmissionDate') THEN 1
		 WHEN (CH.PaidStage IS NOT NULL and b.TxnId IS NULL AND a.Status = 'ClientApproved' AND A.PaymentMode = 'AD') THEN 1
		 WHEN (v.BankAccountIssueBank LIKE '%Bangkok%' and b.TxnId IS NULL AND a.Status = 'ClientApproved' AND A.PaymentMode = 'AD') THEN 1 
		 ELSE 0 END) as 'ResubPiece',
SUM(CASE WHEN a.Status in ('RejectDate','ClientRejectDate') THEN 1 ELSE 0 END) as 'RejectPiece' 
FROM NewTHDB_PROD..Txn_Transaction_StatusSummary A
inner join NewTHDB_PROD..VW_CHR_TXN v on v.TxnId = a.TxnId AND v.IsDeleted = 0
--LEFT JOIN NewTHDB_PROD..Mst_MasterCode M on m.CodeType = 'SCB_KBank_ApprovedPaid' and CAST(m.CodeId AS DATE) <= v.MoSubmissionWEDate and (v.BankAccountIssueBank LIKE '%Kasikorn%' OR v.BankAccountIssueBank LIKE '%Siam Commercial%')
LEFT JOIN NewTHDB_PROD..Mst_Ch_ADPaymentStage CH ON CH.BankName = V.BankAccountIssueBank AND V.SignUpDate BETWEEN CH.StartDate AND CH.EndDate AND CH.PaidStage = 'Approve'
LEFT JOIN (select TxnId from NewTHDB_PROD..Txn_Transaction_StatusSummary 
			where IsDeleted = 0 and Status in ('ReSubmissionDate', 'ClientReSubmissionDate') and PaymentMode = 'AD'
			and StatusWEDate = @CountryWeDate) B on b.TxnId = a.TxnId and a.Status = 'ClientApproved' AND A.PaymentMode = 'AD'
LEFT JOIN (SELECT TxnId FROM NewTHDB_PROD..Txn_Transaction_StatusSummary 
		  WHERE IsDeleted = 0 and Status in ('SubmissionDate') and StatusWEDate = @CountryWeDate AND MOCode = 'AP') HQ ON HQ.TxnId = A.TxnId
WHERE StatusWEDate = @CountryWeDate 
and ISNULL(A.BadgeNo,'') <> '' and A.Status in ('SubmissionDate','ReSubmissionDate','ClientReSubmissionDate','RejectDate','ClientRejectDate','ClientApproved')
and A.IsDeleted = 0
GROUP BY   A.CampaignCode
) B ON A.Country = 'Thailand' and A.Division = 'Charity' and A.Customer = B.Campaign


UPDATE A SET A.NetPiece = B.NetPiece, A.GrossPiece = B.NetPiece FROM #ReportDate A INNER JOIN(
select d.Client[Campaign], SUM(c.Price)[Gross], 
SUM(IIF(c.ParentCampaignProductId IS NOT NULL AND p.ProductType = 'Product' , c.Quantity, 0))[NetPiece]
from NewTHDB_PROD..Txn_Transaction a
inner join NewTHDB_PROD..Txn_Co_CampaignTransaction b on b.TxnId = a.TxnId and b.IsDeleted = 0 and b.RecordTypeCode = 'MAIN'
inner join NewTHDB_PROD..Txn_Co_Campaign_Product c on c.TxnId = a.TxnId and c.IsDeleted = 0 --and ParentCampaignProductId is null
inner join NewTHDB_PROD..Mst_Co_Product p on p.ProductId = c.ProductId
inner join NewTHDB_PROD..VW_MST_CampaignList d on d.ID = b.CampaignId
where a.IsDeleted = 0 and MoSubmissionWEDate = @CountryWeDate
GROUP BY  d.Client 
) B ON A.Country = 'Thailand' and A.Division in ('Commercial', 'CSR') and A.Customer = B.Campaign


UPDATE A SET A.GrossSales = B.Gross FROM #ReportDate A INNER JOIN(
select b.Client[Campaign], SUM(TotalAmount)[Gross]
from NewTHDB_PROD..Txn_Co_Deposit a
inner join NewTHDB_PROD..VW_MST_CampaignList b on b.ID = a.CampaignID
inner join NewTHDB_PROD..Mst_Weekending c on c.WEdate = @CountryWeDate and a.SalesDate between c.FromDate and c.ToDate
group by b.Client
) B ON A.Country = 'Thailand' and A.Division in ('Commercial', 'CSR') and A.Customer = B.Campaign

END
-- =================================================== THAILAND (END)=========================================================================
-- ===========================================================================================================================================


-- =================================================== KOREA(START)===========================================================================
-- ===========================================================================================================================================

SELECT @UniqueSCH = (SELECT COUNT(Distinct FRID) from Appco360_PROD..SSIS_Maintable WHERE MOSubWE = @weDate and SubType is null)

--Insert Scoring headcount & Gross Sales
INSERT INTO #ReportDate (Country, Division, Customer, Weekending, RMonth, RQuarter, CountryUSHC, USCH, GrossSales)
SELECT   'Korea' as 'Country', 'Charity' as Division, Campaign, @weDate, @Month, @Quarter, @UniqueSCH, COUNT(Distinct FRID), SUM(FRStroke)   
from Appco360_PROD..SSIS_Maintable WHERE MOSubWE = @weDate and SubType is null 
GROUP BY Campaign


-- Calculate Net Piece
SELECT distinct A.Campaign,'Charity' as Division,  0 as 'NetPiece', 0 as 'GrossPiece', 0 as 'GrossPieceOT', 0 as 'RejectPiece', 0 as 'ResubPiece' INTO #TempKoreaNet from Appco360_PROD..SSIS_Maintable A 
WHERE MOSubWE = @weDate   OR  MORejectWE = @weDate

UPDATE A SET A.GrossPiece = B.Sub,  A.NetPiece = B.Sub FROM #TempKoreaNet A INNER JOIN 
(SELECT   Campaign,'Charity' as Division,COUNT(*) as 'Sub' from Appco360_PROD..SSIS_Maintable WHERE MOSubWE = @weDate and Frequency = 1 and SubType is null
 and PaidAmount <> 0
GROUP BY Campaign
) B ON A.Campaign = B.Campaign

UPDATE A SET A.GrossPieceOT = B.Sub,  A.NetPiece = A.NetPiece + B.Sub FROM #TempKoreaNet A INNER JOIN 
(SELECT   Campaign,'Charity' as Division,COUNT(*) as 'Sub' from Appco360_PROD..SSIS_Maintable WHERE MOSubWE = @weDate and Frequency = 0  and SubType is null
   and PaidAmount <> 0
GROUP BY Campaign
) B ON A.Campaign = B.Campaign
 
 
UPDATE A SET A.ResubPiece = B.Sub,  A.NetPiece = A.NetPiece + B.Sub FROM #TempKoreaNet A INNER JOIN 
(SELECT   Campaign,'Charity' as Division,COUNT(*) as 'Sub' from Appco360_PROD..SSIS_Maintable WHERE MOSubWE = @weDate and SubType in ('APPCORESUB','CLIENTRESUB')
  and PaidAmount <> 0
GROUP BY Campaign
) B ON A.Campaign = B.Campaign


 
UPDATE A SET A.RejectPiece = B.Rej,  A.NetPiece = A.NetPiece - B.Rej FROM #TempKoreaNet A INNER JOIN 
(SELECT   Campaign,'Charity' as Division,COUNT(*) as 'Rej' from Appco360_PROD..SSIS_Maintable WHERE MORejectWE = @weDate-- and FRStroke <> 0
  and PaidAmount <> 0
GROUP BY Campaign
) B ON A.Campaign = B.Campaign
 

UPDATE a set a.RejectPiece = B.RejectPiece, a.ResubPiece = B.ResubPiece, a.GrossPieceOT =B.GrossPieceOT, a.GrossPiece = B.GrossPiece, a.NetPiece = B.NetPiece FROM #ReportDate a INNER JOIN #TempKoreaNet B ON A.Customer = B.Campaign collate Latin1_General_CI_AI  WHERE Country = 'Korea'
UPDATE #ReportDate SET DivUSCH = CountryUSHC where Country = 'Korea' and Division = 'Charity' 
-- =================================================== KOREA(END  )===========================================================================
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

DELETE FROM #ReportDate WHERE ISNULL(GrossPiece,0) = 0 and ISNULL(GrossPieceOT,0) = 0 and ISNULL(RejectPiece,0)  = 0
and ISNULL(ResubPiece,0) = 0 and ISNULL(GrossSales,0) = 0

SELECT Country, Division, Customer, Weekending,   ISNULL(GrossPiece,0) as 'GrossPiece', ISNULL(GrossPieceOT,0) as 'One Time Pieces', ISNULL(RejectPiece,0) as 'Reject Pieces',
ISNULL(ResubPiece,0) as 'Resub Pieces', ISNULL(NetPiece,0) as 'NetPiece'  FROM #ReportDate 
 
--DROP TABLE #ReportDate
--DROP TABLE #TempKoreaNet  
--DROP TABLE #MainTransaction    
--DROP TABLE #ICETable    
 

END


