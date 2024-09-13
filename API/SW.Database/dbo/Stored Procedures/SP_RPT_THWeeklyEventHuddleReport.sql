

-- ==========================================================================================
-- EXEC SP_RPT_THWeeklyEventHuddleReport '2021-07-22'
-- ==========================================================================================
 

--=============================
CREATE PROCEDURE [dbo].[SP_RPT_THWeeklyEventHuddleReport]
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
	MoCode NVARCHAR(20),
	Division NVARCHAR(20),
	Customer NVARCHAR(50),
	AvgPackage decimal(18,2),
	Weekending Date,
	RMonth NVARCHAR(50),
	RQuarter NVARCHAR(50),
	EventCode NVARCHAR(50),
	EventName NVARCHAR(100),
	EVENTStartDate DATE,
	EVENTEndDate DATE,
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
WHERE StatusWEDate = @CountryWeDate and A.Channel = 'EVE'
and ISNULL(A.BadgeNo,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0

IF object_id('tempdb..#USHC_Commercial') IS NOT NULL DROP TABLE #USHC_Commercial
select distinct A.BadgeNo as 'BadgeNo' INTO #USHC_Commercial from NewTHDB_PROD..Txn_Transaction a
inner join NewTHDB_PROD..Txn_Co_CampaignTransaction b on b.TxnId = a.TxnId and b.IsDeleted = 0
INNER JOIN NewTHDB_PROD..Mst_BARelationship R ON R.BadgeNo = A.BadgeNo AND R.WEDate = A.MoSubmissionWEDate AND R.CurrentLevel NOT IN ('O','BM')
where a.IsDeleted = 0 and MoSubmissionWEDate = @CountryWeDate  and A.Channel = 'EVE'


SELECT @UniqueSCH_Charity = COUNT(Distinct BadgeNo) FROM #USHC_Charity

SELECT @UniqueSCH_Commercial = COUNT(Distinct BadgeNo) FROM #USHC_Commercial

SELECT @UniqueSCH = COUNT(Distinct BadgeNo) FROM (
SELECT BadgeNo FROM #USHC_Charity
UNION ALL
SELECT BadgeNo FROM #USHC_Commercial
) A

INSERT INTO #ReportDate (Country, MoCode, Division, Customer, Weekending, RMonth, RQuarter, CountryUSHC, DivUSCH, USCH, EventCode, EventName, EVENTStartDate, EVENTEndDate)
SELECT 'Thailand' as 'Country', A.MOCode ,A.Division, A.Campaign as 'Customer', @CountryWeDate as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter', @UniqueSCH as 'CountryUniqueSHC', A.DivisionUSHC,  A.BadgeNo as 'UniqueSHC',A.EventTerritoryCode, A.SiteName, A.StartDate, A.EndDate FROM (
SELECT A.MOCode, A.CampaignCode as 'Campaign', 'Charity' as Division, COUNT( distinct A.BadgeNo) as 'BadgeNo', @UniqueSCH_Charity as 'DivisionUSHC' , B.EventTerritoryCode, C.SiteName, C.StartDate, C.EndDate 
FROM NewTHDB_PROD..Txn_Transaction_StatusSummary A 
LEFT JOIN NewTHDB_PROD..Txn_Transaction B ON A.TxnId = B.TxnId  
LEFT JOIN NewTHDB_PROD..VW_MST_EventCodes C ON B.EventTerritoryCode = C.EventCode
WHERE A.StatusWEDate = @CountryWeDate 
and ISNULL(A.BadgeNo,'') <> '' and A.Status = 'SubmissionDate' and A.IsDeleted = 0  and  A.Channel = 'EVE'
GROUP BY A.MOCode, A.CampaignCode,B.EventTerritoryCode, C.SiteName, C.StartDate, C.EndDate 
UNION ALL
select A.MOCode, d.Client as 'Campaign', CASE WHEN d.Division = 'CO' THEN 'Commercial' ELSE d.Division END 'Division', COUNT( distinct a.BadgeNO) as 'BadgeNo', @UniqueSCH_Commercial as 'DivisionUSHC' 
,A.EventTerritoryCode, C.SiteName, C.StartDate, C.EndDate from NewTHDB_PROD..Txn_Transaction a
inner join NewTHDB_PROD..Txn_Co_CampaignTransaction b on b.TxnId = a.TxnId and b.IsDeleted = 0
--inner join NewTHDB_PROD..Txn_Co_Campaign_Product c on c.TxnId = a.TxnId and c.IsDeleted = 0
inner join NewTHDB_PROD..VW_MST_CampaignList d on d.ID = b.CampaignId
LEFT JOIN NewTHDB_PROD..VW_MST_EventCodes C ON A.EventTerritoryCode = C.EventCode
where a.IsDeleted = 0 and MoSubmissionWEDate = @CountryWeDate  and  Channel = 'EVE'
GROUP BY a.MOCode, d.Client, d.Division ,A.EventTerritoryCode, C.SiteName, C.StartDate, C.EndDate
) A  

DELETE FROM #ReportDate where MoCode = 'AP'
  --A.AvgPackage = B.Gross /B.GrossPiece,
UPDATE A SET A.AvgPackage = B.AvgPrice , A.GrossPieceOT = B.GrossPieceOT, A.GrossSales = B.Gross,   A.GrossPiece = B.GrossPiece FROM #ReportDate A INNER JOIN(
SELECT A.MOCode, F.EventCode, A.CampaignCode as 'Campaign',
SUM(CASE WHEN a.Status in ('SubmissionDate') AND a.MOCode <> 'AP' AND HQ.TxnId IS NULL AND CH.PaidStage IS NULL  THEN A.ICStrokeValue 
		 WHEN a.Status in ('SubmissionDate') AND a.MOCode = 'AP'  THEN A.ICStrokeValue 
	     WHEN a.Status in ('ReSubmissionDate','ClientReSubmissionDate') AND a.MOCode <> 'AP' THEN A.ICStrokeValue 
		 WHEN (CH.PaidStage IS NOT NULL and b.TxnId IS NULL AND a.Status = 'ClientApproved' AND A.PaymentMode = 'AD' AND a.MOCode <> 'AP') THEN A.ICStrokeValue
		 WHEN (v.BankAccountIssueBank LIKE '%Bangkok%' and b.TxnId IS NULL AND a.Status = 'ClientApproved' AND A.PaymentMode = 'AD' AND a.MOCode <> 'AP') THEN A.ICStrokeValue
		 ELSE 0 END) as 'Gross', 
SUM(CASE WHEN V.Frequency > 0 and A.Status = 'SubmissionDate' THEN V.PackageValue / V.Frequency ELSE 0 END) as AvgPrice, 
SUM(CASE WHEN a.Status in ('SubmissionDate') AND a.MOCode <> 'AP' THEN CASE WHEN v.Frequency > 0 THEN 1 ELSE 0 END ELSE 0 END) as 'GrossPiece' ,
SUM(CASE WHEN a.Status in ('SubmissionDate') AND a.MOCode <> 'AP' THEN CASE WHEN v.Frequency = 0 THEN 1 ELSE 0 END ELSE 0 END) as 'GrossPieceOT'
FROM NewTHDB_PROD..Txn_Transaction_StatusSummary A
inner join NewTHDB_PROD..VW_CHR_TXN v on v.TxnId = a.TxnId AND v.IsDeleted = 0
LEFT JOIN NewTHDB_PROD..VW_MST_EventCodes F ON V.EventTerritoryCode = F.EventCode
--LEFT JOIN NewTHDB_PROD..Mst_MasterCode M on m.CodeType = 'SCB_KBank_ApprovedPaid' and CAST(m.CodeId AS DATE) <= v.MoSubmissionWEDate and (v.BankAccountIssueBank LIKE '%Kasikorn%' OR v.BankAccountIssueBank LIKE '%Siam Commercial%')
LEFT JOIN NewTHDB_PROD..Mst_Ch_ADPaymentStage CH ON CH.BankName = V.BankAccountIssueBank AND V.SignUpDate BETWEEN CH.StartDate AND CH.EndDate AND CH.PaidStage = 'Approve'
LEFT JOIN (select TxnId from NewTHDB_PROD..Txn_Transaction_StatusSummary 
			where IsDeleted = 0 and Status in ('ReSubmissionDate', 'ClientReSubmissionDate') and PaymentMode = 'AD' and Channel = 'EVE'
			and StatusWEDate = @CountryWeDate) B on b.TxnId = a.TxnId and a.Status = 'ClientApproved' AND A.PaymentMode = 'AD'
LEFT JOIN (SELECT TxnId FROM NewTHDB_PROD..Txn_Transaction_StatusSummary 
		  WHERE IsDeleted = 0  and Channel = 'EVE' and Status in ('SubmissionDate') and StatusWEDate = @CountryWeDate AND MOCode = 'AP') HQ ON HQ.TxnId = A.TxnId
WHERE StatusWEDate = @CountryWeDate   and  A.Channel = 'EVE'
and ISNULL(A.BadgeNo,'') <> '' and A.Status in ('SubmissionDate','ReSubmissionDate','ClientReSubmissionDate','RejectDate','ClientRejectDate','ClientApproved')
and A.IsDeleted = 0
GROUP BY  A.MOCode, A.CampaignCode, F.EventCode
) B ON A.MoCode = B.MOCode and A.Country = 'Thailand' and A.Division = 'Charity' and A.Customer = B.Campaign and A.EventCode = B.EventCode
WHERE B.GrossPiece + B.GrossPieceOT <> 0
SELECT A.MOCode, A.CampaignCode, F.EventCode, 
SUM( CASE WHEN A.status in('RejectDate','ClientRejectDate') THEN 1 ELSE 0 END) as 'RejectPcs',
SUM( CASE WHEN A.status in('ReSubmissionDate','ClientReSubmissionDate') THEN 1 ELSE 0 END) as 'ResubPcs',
SUM( CASE WHEN A.status in('RejectDate','ClientRejectDate') THEN A.ICStrokeValue ELSE 0 END) as 'RejectValue',
SUM( CASE WHEN A.status in('ReSubmissionDate','ClientReSubmissionDate') THEN A.ICStrokeValue ELSE 0 END) as 'ResubValue'  INTO #CharityRejectResub FROM NewTHDB_PROD..Txn_Transaction_StatusSummary A 
INNER JOIN
(
SELECT TXNID, Channel, EventTerritoryCode FROM NewTHDB_PROD..Txn_Transaction_StatusSummary A 
WHERE StatusWEDate  = @CountryWeDate  and Status ='SubmissionDate' and A.IsDeleted = 0   and  A.Channel = 'EVE')
B ON A.TxnId = B.TxnId 
LEFT JOIN NewTHDB_PROD..VW_CHR_TXN V ON A.TxnId = V.txnid
LEFT JOIN NewTHDB_PROD..VW_MST_EventCodes F ON V.EventTerritoryCode = F.EventCode
WHERE A.Status in ('ReSubmissionDate','ClientReSubmissionDate','RejectDate','ClientRejectDate')
and A.IsDeleted = 0   and V.Frequency > 0
GROUP BY  A.MOCode, A.CampaignCode, F.EventCode 


UPDATE A SET A.RejectPiece = B.RejectPcs , A.ResubPiece = B.ResubPcs FROM #ReportDate A INNER JOIN #CharityRejectResub B ON A.MoCode = B.MOCode and A.Customer = B.CampaignCode and A.EventCode = B.EventCode

 
UPDATE A SET A.AvgPackage = B.AVGPrice, A.NetPiece = B.NetPiece, A.GrossPiece = B.NetPiece, A.GrossSales = ICStrokeValue FROM #ReportDate A INNER JOIN(
select A.MOCode, A.EventTerritoryCode, d.Client[Campaign], SUM(c.Price)[Gross], 
SUM(IIF(c.ParentCampaignProductId IS NOT NULL AND p.ProductType = 'Product' , c.Quantity, 0))[NetPiece],
SUM(c.ICStrokeValue) as 'ICStrokeValue', AVG(c.ICStrokeValue) as 'AVGPrice'
from NewTHDB_PROD..Txn_Transaction a
inner join NewTHDB_PROD..Txn_Co_CampaignTransaction b on b.TxnId = a.TxnId and b.IsDeleted = 0 and b.RecordTypeCode = 'MAIN'
inner join NewTHDB_PROD..Txn_Co_Campaign_Product c on c.TxnId = a.TxnId and c.IsDeleted = 0 --and ParentCampaignProductId is null
inner join NewTHDB_PROD..Mst_Co_Product p on p.ProductId = c.ProductId
inner join NewTHDB_PROD..VW_MST_CampaignList d on d.ID = b.CampaignId
where a.IsDeleted = 0 and MoSubmissionWEDate = @CountryWeDate and  a.Channel = 'EVE'
GROUP BY a.MOCode,  d.Client , A.EventTerritoryCode
) B ON A.MoCode = B.MOCode and A.Country = 'Thailand' and A.Division in ('Commercial', 'CSR') and A.Customer = B.Campaign 
and A.EventCode = B.EventTerritoryCode
 
END
-- =================================================== THAILAND (END)=========================================================================
-- ===========================================================================================================================================
  UPDATE #ReportDate SET NetPiece = ISNULL(GrossPiece,0) + ISNULL(GrossPieceOT,0) - ISNULL(RejectPiece,0) + ISNULL(ResubPiece,0)

SELECT Country, Division, Customer, MoCode as 'MO ID', A.EventCode, EventName,   Weekending, RMonth, RQuarter, AvgPackage as AveragePackage,  ISNULL(GrossPiece,0) as 'GrossPiece', ISNULL(GrossPieceOT,0) as 'One Time Pieces', ISNULL(RejectPiece,0) as 'Aged Reject Pieces',
ISNULL(ResubPiece,0) as 'Aged Resub Pieces', ISNULL(NetPiece,0) as 'NetPiece', USCH, GrossSales  FROM #ReportDate  A 
ORder by Division, Customer
--DROP TABLE #ReportDate
--DROP TABLE #TempKoreaNet  
--DROP TABLE #MainTransaction    
--DROP TABLE #ICETable    
 

END


