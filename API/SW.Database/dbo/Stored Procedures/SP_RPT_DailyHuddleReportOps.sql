
  
CREATE PROCEDURE [dbo].[SP_RPT_DailyHuddleReportOps]
	 
AS
BEGIN
	 
DECLARE @ReportWE DATE
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

 SET @ReportWE = CAST(GETDATE() as date)

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
 
 
INSERT INTO #ReportDate (Country, Division, Customer, Weekending, RMonth, RQuarter, CountryUSHC, USCH)
SELECT 'Malaysia' as 'Country', A.Division, B.Campaign as 'Customer', @ReportWE as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter', @UniqueSCH as 'CountryUniqueSHC',  A.BadgeNo as 'UniqueSHC' FROM (
SELECT Client as 'Campaign', 'Charity' as Division, COUNT( distinct BadgeID) as 'BadgeNo'  FROM NewMYDB_PROD..VW_CH_SS 
WHERE StatusDate = @ReportWE 
and ISNULL(BadgeID,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0 
GROUP BY Client
UNION ALL 
SELECT 'TKF' as 'Campaign', 'Commercial' as Division, COUNT(Distinct ICBadgeNo_H) FROM NewMYDB_PROD..Tbl_TKF_Maintable_StatusSummary
WHERE StatusDate = @ReportWE and IsDeleted = 0 and Status = 'SubmissionDate'
UNION ALL
SELECT B.Campaign as 'Campaign','Commercial' as Division,COUNT(Distinct B.BadgeID) FROM NewMYDB_PROD..Txn_Commercial_StatusSummary A LEFT JOIN NewMYDB_PROD..Txn_Commercial B ON A.TxnID = B.TxnID  and B.Campaign = 'STMMY'
where StatusDate = @ReportWE  and A.Status = 'SubmissionDate' and A.IsDeleted = 0   GROUP BY B.Campaign
UNION ALL
SELECT PRDCAT_Code, 'LifeStyle' as Division, COUNT(DISTINCT IC_Code) FROM NewMYDB_PROD..TXN_Lif_SalesHeader where MO_Sub_Week = @ReportWE
and DE_By is not null and IsDeleted = 0 GROUP BY PRDCAT_Code
UNION ALL 
SELECT 'HS'  as 'Campaign', 'Commercial' as Division,COUNT(DISTINCT AgentID) FROM NewMYDB_PROD..TXN_LS_Hasava where SubmissionDate = @ReportWE
) A LEFT JOIN NewMYDB_PROD..VW_CampaignList B ON A.Campaign = B.ClientCode 
  
 
INSERT INTO #ReportDate (Country, Division, Customer, Weekending, RMonth, RQuarter, CountryUSHC, USCH)
SELECT  'Malaysia' as 'Country', A.Division, B.Campaign as 'Customer', @CountryWeDate as 'Weekending', @Month as 'Month' ,
@Quarter as 'Quarter', @UniqueSCH as 'CountryUniqueSHC',  0 as 'UniqueSHC' FROM (
SELECT Client as 'Campaign', 'Charity' as Division FROM NewMYDB_PROD..VW_CH_SS WHERE StatusDate = @ReportWE 
and ISNULL(BadgeID,'') <> '' and Status <> 'SubmissionDate' and IsDeleted = 0 
GROUP BY Client) A 
LEFT JOIN NewMYDB_PROD..VW_CampaignList B ON A.Campaign = B.ClientCode 
LEFT JOIN #ReportDate Z ON A.Division = Z.Division  and B.Campaign = Z.Customer
WHERE Z.Customer is null
 
    
INSERT INTO #ReportDate (Country, Division, Customer, Weekending, RMonth, RQuarter, CountryUSHC, USCH)
SELECT  'Malaysia' as 'Country', A.Division, B.Campaign as 'Customer', @CountryWeDate as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter', @UniqueSCH as 'CountryUniqueSHC',  0 as 'UniqueSHC' FROM (
SELECT B.Campaign as 'Campaign', 'Commercial' as Division FROM NewMYDB_PROD..Txn_Commercial_StatusSummary A LEFT JOIN NewMYDB_PROD..Txn_Commercial B ON A.TxnID = B.TxnID  and B.Campaign = 'STMMY'
WHERE StatusDate = @ReportWE 
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
  WHERE StatusDate = @ReportWE  and ICStroke > 0
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
where A.StatusDate = @ReportWE and A.IsDeleted = 0
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
  WHERE StatusDate = @ReportWE  and ICStroke > 0
and ISNULL(B.BadgeID,'') <> '' and A.Status in ('SubmissionDate','ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate','ClientRejectDate','UpDownRejectDate','RejectDate')
and IsDeleted = 0
GROUP BY C.Campaign
) B ON A.Country = 'Malaysia' and A.Division = 'Commercial' and A.Customer = B.Campaign


 UPDATE A SET A.GrossPieceOT = 0, A.RejectPiece = 0, A.ResubPiece = 0, A.GrossPiece = B.NetPiece, A.GrossSales = B.Gross, A.NetPiece = B.NetPiece FROM #ReportDate A INNER JOIN(
SELECT B.Campaign as 'Campaign', SUM(TTL_MSF) as 'Gross', SUM(C.Purchase_Qty) as 'NetPiece' FROM NewMYDB_PROD..TXN_Lif_SalesHeader A 
LEFT JOIN NewMYDB_PROD..TXN_Lif_Sales_Detail C ON A.Trxn_No = C.Trxn_No and C.Purchase_Qty > 0
LEFT JOIN NewMYDB_PROD..VW_CampaignList B ON A.PRDCAT_Code = B.ClientCode
 where MO_Sub_Date = @ReportWE and DE_By is not null and A.IsDeleted = 0 and C.IsDeleted = 0
 GROUP BY B.Campaign  

) B ON A.Country = 'Malaysia' and A.Division = 'LifeStyle' and A.Customer = B.Campaign
 
 UPDATE A SET A.GrossPieceOT = 0, A.RejectPiece = 0, A.ResubPiece = 0, A.GrossPiece = B.NetPiece, A.GrossSales = B.Gross, A.NetPiece = B.NetPiece FROM #ReportDate A INNER JOIN(
SELECT B.Campaign as 'Campaign', SUM(OrderItemQuantity) as 'Gross', SUM(OrderItemQuantity) as 'NetPiece' FROM NewMYDB_PROD..TXN_LS_Hasava A  
LEFT JOIN NewMYDB_PROD..VW_CampaignList B ON B.ClientCode = 'HS'
 where WEDate = @ReportWE 
 GROUP BY B.Campaign   
) B ON A.Country = 'Malaysia' and A.Division = 'Commercial' and A.Customer = 'HASAVA'
  

 
 
-- =================================================== MALAYSIA (END  )====================================================================
-- ========================================================================================================================================

-- =================================================== PHILIPPINES (START)====================================================================
-- ===========================================================================================================================================
 
 

SELECT @UniqueSCH = 0
 
INSERT INTO #ReportDate (Country, Division, Customer, Weekending, RMonth, RQuarter, CountryUSHC, USCH)
SELECT 'Philippines' as 'Country', A.Division, A.Campaign as 'Customer', @ReportWE as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter', @UniqueSCH as 'CountryUniqueSHC',  A.BadgeNo as 'UniqueSHC' FROM (
SELECT B.Client as 'Campaign', 'Charity' as Division, COUNT( distinct BadgeNo) as 'BadgeNo'  FROM NewPHDB_PROD..VW_CH_SS A 
LEFT JOIN NewPHDB_PROD..VW_MST_CampaignList B ON A.CampaignCode = B.ID
WHERE StatusDate = @ReportWE  and ISNULL(BadgeNo,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0
GROUP BY  B.Client 
UNION ALL
SELECT  B.Client as 'Campaign', 'Commercial' as Division,COUNT( distinct BadgeNo) as 'BadgeNo'   FROM NewPHDB_PROD..VW_CO_TXN A 
LEFT JOIN NewPHDB_PROD..VW_MST_CampaignList B ON A.CampaignCode = B.ID
WHERE MoSubmissionDate  = @ReportWE   and IsDeleted = 0
GROUP BY  B.Client 
) A 
  
INSERT INTO #ReportDate (Country, Division, Customer, Weekending, RMonth, RQuarter, CountryUSHC, USCH) 
SELECT 'Philippines' as 'Country', A.Division, A.Campaign as 'Customer', @ReportWE as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter', @UniqueSCH as 'CountryUniqueSHC',  A.BadgeNo as 'UniqueSHC' FROM (
SELECT B.Client as 'Campaign', 'Charity' as Division, COUNT( distinct BadgeNo) as 'BadgeNo'  FROM NewPHDB_PROD..VW_CH_SS A 
LEFT JOIN NewPHDB_PROD..VW_MST_CampaignList B ON A.CampaignCode = B.ID
LEFT JOIN #ReportDate Z ON Z.Division = 'Charity'  and B.Client = Z.Customer
WHERE StatusDate = @ReportWE  and ISNULL(BadgeNo,'') <> '' and Status <> 'SubmissionDate' and IsDeleted = 0 
and Z.Customer is null
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
WHERE StatusDate = @ReportWE 
and ISNULL(A.BadgeNo,'') <> '' and A.Status in ('SubmissionDate','ReSubmissionDate','ClientResubmissionDate','RejectDate','ClientRejectDate')
and A.IsDeleted = 0
GROUP BY B.Client 
) B ON A.Country = 'Philippines' and A.Division = 'Charity' and A.Customer = B.Campaign
 

UPDATE A SET A.GrossPieceOT = 0, A.ResubPiece = 0, A.RejectPiece = 0, A.GrossPiece = B.NetPiece, A.GrossSales = B.Gross, A.NetPiece = B.NetPiece FROM #ReportDate A INNER JOIN(
SELECT C.Client as 'Campaign', SUM(Quantity) as 'NetPiece',   SUM(Price * Quantity) + MAX(A.OtherAmount) as 'Gross'  FROM NewPHDB_PROD..VW_CO_TXN A 
LEFT JOIN NewPHDB_PROD..Txn_Co_Campaign_Product B ON A.TxnId = B.TxnId 
LEFT JOIN  NewPHDB_PROD..VW_MST_CampaignList C ON A.CampaignCode = C.ID
  WHERE MoSubmissionDate  = @ReportWE   and A.IsDeleted = 0  and B.IsDeleted = 0
  GROUP BY C.Client
) B ON A.Country = 'Philippines' and A.Division = 'Commercial' and A.Customer = B.Campaign
 
  
 
-- =================================================== PHILIPPINES ( END )====================================================================
-- ===========================================================================================================================================




-- =================================================== INDIA (START)==========================================================================
-- ===========================================================================================================================================
 

SELECT @UniqueSCH = 0
 
INSERT INTO #ReportDate (Country, Division, Customer, Weekending, RMonth, RQuarter, CountryUSHC, USCH)
SELECT 'India' as 'Country', A.Division, A.Campaign as 'Customer', @ReportWE as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter', @UniqueSCH as 'CountryUniqueSHC',  A.BadgeNo as 'UniqueSHC' FROM (
SELECT B.Client as 'Campaign', 'Charity' as Division, COUNT( distinct BadgeNo) as 'BadgeNo'  FROM NewIndiaDB_PROD..VW_CH_SS A 
LEFT JOIN NewIndiaDB_PROD..VW_MST_CampaignList B ON A.Client = B.ID
WHERE StatusDate = @ReportWE  and ISNULL(BadgeNo,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0
GROUP BY  B.Client   
) A 



UPDATE A SET A.GrossPieceOT = 0, A.ResubPiece =B.ResubPiece, A.RejectPiece = B.RejectPiece,  A.GrossPiece = B.GrossPiece, A.GrossSales = B.Gross, A.NetPiece = B.NetPiece FROM #ReportDate A INNER JOIN(
SELECT B.Client as 'Campaign',SUM(CASE WHEN Status in ('SubmissionDate','ReSubmissionDate','ClientResubmissionDate') THEN ICStrokeValue ELSE 0 END) as 'Gross',
SUM(CASE WHEN Status in ('SubmissionDate','ReSubmissionDate','ClientResubmissionDate') THEN 1 ELSE -1 END) as 'NetPiece' ,
SUM(CASE WHEN Status in ('SubmissionDate') THEN 1 ELSE 0 END) as 'GrossPiece' ,
SUM(CASE WHEN Status in ('ReSubmissionDate','ClientResubmissionDate') THEN 1 ELSE 0 END) as 'ResubPiece' ,
SUM(CASE WHEN Status not in ('SubmissionDate','ReSubmissionDate','ClientResubmissionDate') THEN 1 ELSE 0 END) as 'RejectPiece' FROM NewIndiaDB_PROD..VW_CH_SS A 
LEFT JOIN NewIndiaDB_PROD..VW_MST_CampaignList B ON A.Client = B.ID
WHERE StatusDate = @ReportWE 
and ISNULL(BadgeNo,'') <> '' and Status in ('SubmissionDate','ReSubmissionDate','ClientResubmissionDate','RejectDate','ClientRejectDate')
and IsDeleted = 0
GROUP BY B.Client 
) B ON A.Country = 'India' and A.Division = 'Charity' and A.Customer = B.Campaign

 
-- =================================================== INDIA (END)==========================================================================
-- ===========================================================================================================================================



-- =================================================== TAIWAN (START)=========================================================================
-- ===========================================================================================================================================
 
SELECT @UniqueSCH = COUNT(Distinct BadgeNo) FROM (
SELECT distinct BadgeID as 'BadgeNo'  FROM  NewTWDB_PROD..VW_CH_SS WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeID,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0   and IsDeleted = 0   
) A


INSERT INTO #ReportDate (Country, Division, Customer, Weekending, RMonth, RQuarter, CountryUSHC, USCH)
SELECT 'Taiwan' as 'Country', A.Division, B.Campaign as 'Customer', @ReportWE as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter', @UniqueSCH as 'CountryUniqueSHC', 0  FROM (
SELECT Client as 'Campaign', 'Charity' as Division, COUNT( distinct BadgeID) as 'BadgeNo'  FROM NewTWDB_PROD..VW_CH_SS WHERE StatusDate = @ReportWE 
and ISNULL(BadgeID,'') <> '' and Status IN ('SubmissionDate','RejectDate','ReSubmissionDate','ClientRejectDate','ClientReSubmissionDate','UpDownResubDate','UpDownRejectDate', 'ClientClawBack60') and IsDeleted = 0
GROUP BY Client
) A LEFT JOIN NewTWDB_PROD..VW_CampaignList B ON A.Campaign = B.ClientCode 
 

 UPDATE A SET A.ResubPiece = B.ResubPiece, A.GrossPiece = B.GrossPiece, A.GrossPieceOT = B.GrossPieceOT, A.RejectPiece = B.RejectPiece, A.GrossSales = B.Gross, A.NetPiece = B.NetPiece FROM #ReportDate A INNER JOIN(
SELECT B.Campaign as 'Campaign',SUM(CASE WHEN A.Status in ('SubmissionDate','ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate') THEN ICStroke ELSE 0 END) as 'Gross',
SUM(CASE WHEN A.Status in ('SubmissionDate','ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate') THEN 1 ELSE -1 END) as 'NetPiece' ,
SUM(CASE WHEN A.Status in ('ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate') THEN 1 ELSE 0 END) as 'ResubPiece' ,
SUM(CASE WHEN A.Status in ('SubmissionDate') THEN Case WHEN C.Frequency > 0 THEN 1 ELSE 0 END ELSE 0 END) as 'GrossPiece',
SUM(CASE WHEN A.Status in ('SubmissionDate') THEN Case WHEN C.Frequency = 0 THEN 1 ELSE 0 END ELSE 0 END) as 'GrossPieceOT',
SUM(CASE WHEN A.Status in ('ClientRejectDate','UpDownRejectDate','RejectDate') THEN 1 ELSE 0 END) as 'RejectPiece' FROM NewTWDB_PROD..VW_CH_SS A
LEFT JOIN NewTWDB_PROD..VW_CampaignList B ON A.Client = B.ClientCode
LEFT JOIN NewTWDB_PROD..MST_CHR_Package C ON A.PackageId = C.PackageID
  WHERE StatusDate = @ReportWE  and ICStroke > 0
and ISNULL(BadgeID,'') <> '' and A.Status in ('SubmissionDate','ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate','ClientRejectDate','UpDownRejectDate','RejectDate')
and IsDeleted = 0
GROUP BY   B.Campaign
) B ON A.Country = 'Taiwan' and A.Division = 'Charity' and A.Customer = B.Campaign

 
-- =================================================== TAIWAN (END)=========================================================================
-- ===========================================================================================================================================




-- =================================================== HONG KONG(START)=======================================================================
-- ===========================================================================================================================================
 
SELECT @UniqueSCH = 0

INSERT INTO #ReportDate (Country, Division, Customer, Weekending, RMonth, RQuarter, CountryUSHC, USCH)
SELECT 'Hong Kong' as 'Country', A.Division, A.Campaign as 'Customer', @ReportWE as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter', @UniqueSCH as 'CountryUniqueSHC',  A.BadgeNo as 'UniqueSHC' FROM (
SELECT CampaignCode as 'Campaign', 'Charity' as Division, COUNT( distinct BadgeNo) as 'BadgeNo'  FROM NewHKDB_PROD..Txn_Transaction_StatusSummary 
WHERE StatusDate = @ReportWE 
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
WHERE StatusDate = @ReportWE 
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

-- =================================================== HONG KONG END)=========================================================================
-- ===========================================================================================================================================



-- =================================================== THAILAND (START)=======================================================================
-- ===========================================================================================================================================
 

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

 

INSERT INTO #ReportDate (Country, Division, Customer, Weekending, RMonth, RQuarter, CountryUSHC, DivUSCH, USCH)
SELECT 'Thailand' as 'Country', A.Division, A.Campaign as 'Customer', @ReportWE as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter', @UniqueSCH as 'CountryUniqueSHC', A.DivisionUSHC,  A.BadgeNo as 'UniqueSHC' FROM (
SELECT CampaignCode as 'Campaign', 'Charity' as Division, COUNT( distinct BadgeNo) as 'BadgeNo', @UniqueSCH_Charity as 'DivisionUSHC'  
FROM NewTHDB_PROD..Txn_Transaction_StatusSummary WHERE StatusDate = @ReportWE 
and ISNULL(BadgeNo,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0
GROUP BY CampaignCode
UNION ALL
select d.Client as 'Campaign', CASE WHEN d.Division = 'CO' THEN 'Commercial' ELSE d.Division END 'Division', COUNT( distinct a.BadgeNO) as 'BadgeNo', @UniqueSCH_Commercial as 'DivisionUSHC' 
from NewTHDB_PROD..Txn_Transaction a
inner join NewTHDB_PROD..Txn_Co_CampaignTransaction b on b.TxnId = a.TxnId and b.IsDeleted = 0
--inner join NewTHDB_PROD..Txn_Co_Campaign_Product c on c.TxnId = a.TxnId and c.IsDeleted = 0
inner join NewTHDB_PROD..VW_MST_CampaignList d on d.ID = b.CampaignId
where a.IsDeleted = 0 and MoSubmissionDate = @ReportWE
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
			and StatusDate = @ReportWE) B on b.TxnId = a.TxnId and a.Status = 'ClientApproved' AND A.PaymentMode = 'AD'
LEFT JOIN (SELECT TxnId FROM NewTHDB_PROD..Txn_Transaction_StatusSummary 
		  WHERE IsDeleted = 0 and Status in ('SubmissionDate') and StatusDate = @ReportWE AND MOCode = 'AP') HQ ON HQ.TxnId = A.TxnId
WHERE StatusDate = @ReportWE 
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
where a.IsDeleted = 0 and MoSubmissionDate = @ReportWE
GROUP BY  d.Client 
) B ON A.Country = 'Thailand' and A.Division in ('Commercial', 'CSR') and A.Customer = B.Campaign

 
-- =================================================== THAILAND (END)=========================================================================
-- ===========================================================================================================================================


-- =================================================== KOREA(START)===========================================================================
-- ===========================================================================================================================================

 

--Insert Scoring headcount & Gross Sales
INSERT INTO #ReportDate (Country, Division, Customer, Weekending, RMonth, RQuarter, CountryUSHC, USCH, GrossSales)
SELECT   'Korea' as 'Country', 'Charity' as Division, Campaign, @ReportWE, @Month, @Quarter, @UniqueSCH, COUNT(Distinct FRID), SUM(FRStroke)   
from Appco360_PROD..SSIS_Maintable WHERE MOSubDate = @ReportWE and SubType is null 
GROUP BY Campaign


-- Calculate Net Piece
SELECT distinct A.Campaign,'Charity' as Division,  0 as 'NetPiece', 0 as 'GrossPiece', 0 as 'GrossPieceOT', 0 as 'RejectPiece', 0 as 'ResubPiece' INTO #TempKoreaNet from Appco360_PROD..SSIS_Maintable A 
WHERE MOSubDate = @ReportWE   OR  MOSubDate = @ReportWE

UPDATE A SET A.GrossPiece = B.Sub,  A.NetPiece = B.Sub FROM #TempKoreaNet A INNER JOIN 
(SELECT   Campaign,'Charity' as Division,COUNT(*) as 'Sub' from Appco360_PROD..SSIS_Maintable 
WHERE MOSubDate = @ReportWE and Frequency = 1 and SubType is null
 and PaidAmount <> 0
GROUP BY Campaign
) B ON A.Campaign = B.Campaign

UPDATE A SET A.GrossPieceOT = B.Sub,  A.NetPiece = A.NetPiece + B.Sub FROM #TempKoreaNet A INNER JOIN 
(SELECT   Campaign,'Charity' as Division,COUNT(*) as 'Sub' from Appco360_PROD..SSIS_Maintable
WHERE MOSubDate = @ReportWE and Frequency = 0  and SubType is null
   and PaidAmount <> 0
GROUP BY Campaign
) B ON A.Campaign = B.Campaign
 
 
UPDATE A SET A.ResubPiece = B.Sub,  A.NetPiece = A.NetPiece + B.Sub FROM #TempKoreaNet A INNER JOIN 
(SELECT   Campaign,'Charity' as Division,COUNT(*) as 'Sub' from Appco360_PROD..SSIS_Maintable 
WHERE MOSubDate = @ReportWE and SubType in ('APPCORESUB','CLIENTRESUB')
  and PaidAmount <> 0
GROUP BY Campaign
) B ON A.Campaign = B.Campaign


 
UPDATE A SET A.RejectPiece = B.Rej,  A.NetPiece = A.NetPiece - B.Rej FROM #TempKoreaNet A INNER JOIN 
(SELECT   Campaign,'Charity' as Division,COUNT(*) as 'Rej' from Appco360_PROD..SSIS_Maintable WHERE MORejectWE = @ReportWE-- and FRStroke <> 0
  and PaidAmount <> 0
GROUP BY Campaign
) B ON A.Campaign = B.Campaign
 

UPDATE a set a.RejectPiece = B.RejectPiece, a.ResubPiece = B.ResubPiece, a.GrossPieceOT =B.GrossPieceOT, a.GrossPiece = B.GrossPiece, a.NetPiece = B.NetPiece FROM #ReportDate a INNER JOIN #TempKoreaNet B ON A.Customer = B.Campaign collate Latin1_General_CI_AI  WHERE Country = 'Korea'
UPDATE #ReportDate SET DivUSCH = CountryUSHC where Country = 'Korea' and Division = 'Charity' 
-- =================================================== KOREA(END  )===========================================================================
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


