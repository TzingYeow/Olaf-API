
 --SP_RPT_WeeklyHuddleReport '2024-01-07'
CREATE PROCEDURE [dbo].[SP_RPT_WeeklyHuddleReport]
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
DECLARE @ScoringHCParam AS INT = 5.0
SET @weDate =  @ReportWE
SET @Month = FORMAT(@weDate,'MMM') + '-' + SUBSTRING(CAST(YEAR(@wedate) as nvarchar),3,2)
SET @Quarter = 'Q' + CAST(DATEPART(QUARTER, @Wedate) as nvarchar) + ' FY' + SUBSTRING(CAST(YEAR(@wedate) as nvarchar),3,2)
--SELECT * FROM VW_CH_SS WHERE StatusWEDate = @weDate 

DROP TABLE IF EXISTS #TempPoint
SELECT B.Country, A.PointConversion as 'Point' INTO #TempPoint FROM MST_countryPoint A LEFT JOIN (
SELECT 'Malaysia' as 'Country', 'MY' as 'CountryCode'  UNION ALL
SELECT 'Singapore' as 'Country', 'SG' as 'CountryCode' UNION ALL
SELECT 'Philippines' as 'Country', 'PH' as 'CountryCode' UNION ALL
SELECT 'Indonesia' as 'Country',  'ID' as 'CountryCode'  UNION ALL
SELECT 'Taiwan' as 'Country',  'TW' as 'CountryCode'  UNION ALL
SELECT 'Hong Kong' as 'Country', 'HK' as 'CountryCode'  UNION ALL
SELECT 'Thailand' as 'Country',  'TH' as 'CountryCode' UNION ALL
SELECT 'Korea' as 'Country',  'KR' as 'CountryCode'
) B ON A.Country = B.CountryCode
WHERE '2023-01-22' > = StartWe AND '2023-01-22' <= EndWe 
 
CREATE TABLE #DailySHC(
	Country NVARCHAR(20),
	Division NVARCHAR(20),
	Customer NVARCHAR(50), 
	SubDate Date,
	USCH INT
) 
CREATE TABLE #ReportDate (
	Country NVARCHAR(20),
	Division NVARCHAR(20),
	Customer NVARCHAR(50), 
	CampaignID INT,
	Weekending Date,
	RMonth NVARCHAR(50),
	RQuarter NVARCHAR(50),
	GrossPiece INT,
	GrossPieceOT INT,
	RejectPiece INT,
	RejectPieceRec INT,
	RejectPieceOT INT,
	ResubPiece INT,
	ResubPieceRec INT,
	ResubPieceOT INT,
	NetPiece INT,
	CountryUSHC INT,
	USCH INT,
	DivUSCH INT,
	CountryHC INT,
	CountryDivHC INT,
	CountryCampaignHC INT,
	GrossSales DECIMAL(18,2),
	GrossBAEarning DECIMAL(18,2),
	NetBAEarning DECIMAL(18,2),
	SWBonus DECIMAL(18,2),
	BuletinPoint DECIMAL(18,2),
	NewStarter INT,
	Leaver INt
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

INSERT INTO #DailySHC
SELECT distinct   'Malaysia' as 'Country', 'Charity', B.Client as 'Customer', StatusDate, COUNT(distinct BadgeID)  
FROM  NewMYDB_PROD..VW_CH_SS A LEFT JOIN newmydb_Prod..VW_Malaysia_Clients B ON A.Client = B.clientCode WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeID,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0  GROUP BY B.Client, StatusDate
 
 
INSERT INTO #DailySHC
SELECT  distinct   'Malaysia' as 'Country', 'Commercial', 'TAKAFUL' as 'Customer', StatusDate, COUNT(distinct ICBadgeNo_H)  FROM NewMYDB_PROD..Tbl_TKF_Maintable_StatusSummary WHERE StatusWE = @CountryWeDate and IsDeleted = 0 and Status = 'SubmissionDate'
GROUP BY StatusDate

INSERT INTO #DailySHC
SELECT  distinct   'Malaysia' as 'Country', 'LifeStyle', B.Client as 'Customer', MO_Sub_Date, 
COUNT(distinct IC_Code)  FROM NewMYDB_PROD..TXN_Lif_SalesHeader A LEFT JOIN newmydb_Prod..VW_Malaysia_Clients B ON A.PRDCAT_CODE = B.ClientCode
where MO_Sub_Week = @CountryWeDate and DE_By is not null and IsDeleted = 0 
 GROUP BY B.Client,MO_Sub_Date

INSERT INTO #DailySHC
SELECT distinct   'Malaysia' as 'Country', 'Commercial', B.Campaign as 'Customer', StatusDate, COUNT(distinct A.BadgeID) FROM NewMYDB_PROD..Txn_Commercial_StatusSummary A LEFT JOIN NewMYDB_PROD..Txn_Commercial B ON A.TxnID = B.TxnID  and B.Campaign = 'STMMY'
where StatusWEDate = @CountryWeDate and A.Status = 'SubmissionDate' and A.IsDeleted = 0  
 GROUP BY B.Campaign,StatusDate

   
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
UNION ALL
SELECT DISTINCT BadgeID FROM Appco360_PROD..Txn_SalesImport WHERE Country = 'MY' and WEDate = @CountryWeDate and IsDeleted = 0 and ISNULL(SignUpPieces,0) > 0
) A
 
 
INSERT INTO #ReportDate (Country, Division, Customer,CampaignID,  Weekending, RMonth, RQuarter, CountryUSHC, USCH)
SELECT 'Malaysia' as 'Country', A.Division, B.Campaign as 'Customer', B.ID, @CountryWeDate as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter', @UniqueSCH as 'CountryUniqueSHC',  A.BadgeNo as 'UniqueSHC' FROM (
SELECT Client as 'Campaign', 'Charity' as Division, COUNT( distinct BadgeID) as 'BadgeNo'  FROM NewMYDB_PROD..VW_CH_SS WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeID,'') <> '' and Status in ('SubmissionDate','ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate','ClientRejectDate','UpDownRejectDate','RejectDate') and IsDeleted = 0 
GROUP BY Client
UNION ALL 
SELECT 'TKF' as 'Campaign', 'Commercial' as Division, COUNT(Distinct ICBadgeNo_H) FROM NewMYDB_PROD..Tbl_TKF_Maintable_StatusSummary WHERE StatusWE = @CountryWeDate and IsDeleted = 0 and Status in ('SubmissionDate','ReSubDate','ClientReSubDate','ClientRejectDate','RejectDate') 
UNION ALL
SELECT B.Campaign as 'Campaign','Commercial' as Division,COUNT(Distinct B.BadgeID) FROM NewMYDB_PROD..Txn_Commercial_StatusSummary A 
LEFT JOIN NewMYDB_PROD..Txn_Commercial B ON A.TxnID = B.TxnID  and B.Campaign = 'STMMY'
where StatusWEDate = @CountryWeDate  and A.Status in ('SubmissionDate','ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate','ClientRejectDate','UpDownRejectDate','RejectDate') and A.IsDeleted = 0   GROUP BY B.Campaign
UNION ALL
SELECT PRDCAT_Code, 'LifeStyle' as Division, COUNT(DISTINCT IC_Code) FROM NewMYDB_PROD..TXN_Lif_SalesHeader where MO_Sub_Week = @CountryWeDate and DE_By is not null and IsDeleted = 0 GROUP BY PRDCAT_Code
UNION ALL 
SELECT 'HS'  as 'Campaign', 'Commercial' as Division,COUNT(DISTINCT AgentID) FROM NewMYDB_PROD..TXN_CO_ICE_HASAVA where WEDate = @CountryWeDate
UNION ALL
SELECT  B.CampaignCode, CASE WHEN C.DivisionCode = 'CO' THEN 'Commercial' WHEN C.DivisionCode = 'CH' THEN 'Charity'
WHEN C.DivisionCode = 'LS' THEN 'LifeStyle' END as 'Division' ,COUNT(DISTINCT BadgeID)
FROM Appco360_PROD..Txn_SalesImport A LEFT JOIN Mst_Campaign B ON A.Campaign = B.CampaignCode 
INNER JOIN Mst_Division C ON B.DivisionId = C.DivisionId
WHERE Country = 'MY' and WEDate =@CountryWeDate and A.IsDeleted = 0 and 
ISNULL(TotalEarning,0.00) > 0.00 and ISNULL(SignUpPieces,0) > 0
GROUP BY B.CampaignCode,CASE WHEN C.DivisionCode = 'CO' THEN 'Commercial' WHEN C.DivisionCode = 'CH' THEN 'Charity'
WHEN C.DivisionCode = 'LS' THEN 'LifeStyle' END 

) A LEFT JOIN NewMYDB_PROD..VW_CampaignList B ON A.Campaign = B.ClientCode 

UPDATE #ReportDate SET USCH = 0 WHERE Country = 'Malaysia'

UPDATE A SET A.USCH = B.UniqueSHC FROM #ReportDate A INNER JOIN (
SELECT 'Malaysia' as 'Country', A.Division, B.Campaign as 'Customer', B.ID, @CountryWeDate as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter', @UniqueSCH as 'CountryUniqueSHC',  A.BadgeNo as 'UniqueSHC' FROM (
SELECT Client as 'Campaign', 'Charity' as Division, COUNT( distinct BadgeID) as 'BadgeNo'  FROM NewMYDB_PROD..VW_CH_SS WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeID,'') <> '' and Status in ('SubmissionDate' ) and IsDeleted = 0 
GROUP BY Client
UNION ALL 
SELECT 'TKF' as 'Campaign', 'Commercial' as Division, COUNT(Distinct ICBadgeNo_H) FROM NewMYDB_PROD..Tbl_TKF_Maintable_StatusSummary WHERE StatusWE = @CountryWeDate and IsDeleted = 0 and Status in ('SubmissionDate' ) 
UNION ALL
SELECT B.Campaign as 'Campaign','Commercial' as Division,COUNT(Distinct B.BadgeID) FROM NewMYDB_PROD..Txn_Commercial_StatusSummary A 
LEFT JOIN NewMYDB_PROD..Txn_Commercial B ON A.TxnID = B.TxnID  and B.Campaign = 'STMMY'
where StatusWEDate = @CountryWeDate  and A.Status in ('SubmissionDate' ) and A.IsDeleted = 0   GROUP BY B.Campaign
UNION ALL
SELECT PRDCAT_Code, 'LifeStyle' as Division, COUNT(DISTINCT IC_Code) FROM NewMYDB_PROD..TXN_Lif_SalesHeader where MO_Sub_Week = @CountryWeDate and DE_By is not null and IsDeleted = 0 GROUP BY PRDCAT_Code
UNION ALL 
SELECT 'HS'  as 'Campaign', 'Commercial' as Division,COUNT(DISTINCT AgentID) FROM NewMYDB_PROD..TXN_CO_ICE_HASAVA where WEDate = @CountryWeDate
UNION ALL
SELECT  B.CampaignCode, CASE WHEN C.DivisionCode = 'CO' THEN 'Commercial' WHEN C.DivisionCode = 'CH' THEN 'Charity'
WHEN C.DivisionCode = 'LS' THEN 'LifeStyle' END as 'Division' ,COUNT(DISTINCT BadgeID)
FROM Appco360_PROD..Txn_SalesImport A LEFT JOIN Mst_Campaign B ON A.Campaign = B.CampaignCode 
INNER JOIN Mst_Division C ON B.DivisionId = C.DivisionId
WHERE Country = 'MY' and WEDate =@CountryWeDate and A.IsDeleted = 0 and 
ISNULL(TotalEarning,0.00) > 0.00 and ISNULL(SignUpPieces,0) > 0
GROUP BY B.CampaignCode,CASE WHEN C.DivisionCode = 'CO' THEN 'Commercial' WHEN C.DivisionCode = 'CH' THEN 'Charity'
WHEN C.DivisionCode = 'LS' THEN 'LifeStyle' END 

) A LEFT JOIN NewMYDB_PROD..VW_CampaignList B ON A.Campaign = B.ClientCode 
) B ON A.Country = B.Country and A.Division = B.Division and A.Customer = B.Customer

   
INSERT INTO #ReportDate (Country, Division, Customer, CampaignID, Weekending, RMonth, RQuarter, CountryUSHC, USCH)
SELECT  'Malaysia' as 'Country', A.Division, B.Campaign as 'Customer', B.ID, @CountryWeDate as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter', @UniqueSCH as 'CountryUniqueSHC',  0 as 'UniqueSHC' FROM (
SELECT Client as 'Campaign', 'Charity' as Division FROM NewMYDB_PROD..VW_CH_SS WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeID,'') <> '' and Status <> 'SubmissionDate' and IsDeleted = 0 
GROUP BY Client) A 
LEFT JOIN NewMYDB_PROD..VW_CampaignList B ON A.Campaign = B.ClientCode 
LEFT JOIN #ReportDate Z ON A.Division = Z.Division  and B.Campaign = Z.Customer
WHERE Z.Customer is null
    
INSERT INTO #ReportDate (Country, Division, Customer, CampaignID, Weekending, RMonth, RQuarter, CountryUSHC, USCH)
SELECT  'Malaysia' as 'Country', A.Division, B.Campaign as 'Customer', B.ID, @CountryWeDate as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter', @UniqueSCH as 'CountryUniqueSHC',  0 as 'UniqueSHC' FROM (
SELECT B.Campaign as 'Campaign', 'Commercial' as Division FROM NewMYDB_PROD..Txn_Commercial_StatusSummary A LEFT JOIN NewMYDB_PROD..Txn_Commercial B ON A.TxnID = B.TxnID  and B.Campaign = 'STMMY'
WHERE StatusWEDate = @CountryWeDate 
and ISNULL(B.BadgeID,'') <> '' and Status <> 'SubmissionDate' and IsDeleted = 0 
GROUP BY Campaign) A 
LEFT JOIN NewMYDB_PROD..VW_CampaignList B ON A.Campaign = B.ClientCode 
LEFT JOIN #ReportDate Z ON A.Division = Z.Division  and B.Campaign = Z.Customer
WHERE Z.Customer is null
 
  

UPDATE A SET A.ResubPiece = B.ResubPiece,A.ResubPieceOT = B.ResubPieceOT,A.ResubPieceREC = B.ResubPieceREC, A.GrossPiece = B.GrossPiece, A.GrossPieceOT = B.GrossPieceOT, A.RejectPiece = B.RejectPiece, A.GrossSales = B.Gross, A.GrossBAEarning = B.Gross, 
A.NetBAEarning = B.netSales, A.NetPiece = B.NetPiece, A.RejectPieceRec = B.RejectPieceRec, A.RejectPieceOT = B.RejectPieceOT FROM #ReportDate A INNER JOIN(
SELECT B.Campaign as 'Campaign',
SUM(CASE WHEN A.Status in ('SubmissionDate') THEN ICStroke ELSE 0 END) as 'Gross',
SUM(CASE WHEN A.Status in ('SubmissionDate','ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate') THEN ICStroke WHEN A.Status in ('ClientRejectDate','UpDownRejectDate','RejectDate') THEN ICStroke * -1 ELSE 0 END) as 'NetSales',
SUM(CASE WHEN A.Status in ('SubmissionDate','ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate') THEN 1 ELSE -1 END) as 'NetPiece' ,
SUM(CASE WHEN A.Status in ('ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate') THEN 1 ELSE 0 END) as 'ResubPiece' ,
SUM(CASE WHEN A.Status in ('ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate') AND C.Frequency = 0 THEN 1 ELSE 0 END) as 'ResubPieceOT' ,
SUM(CASE WHEN A.Status in ('ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate') AND C.Frequency > 0 THEN 1 ELSE 0 END) as 'ResubPieceREC' ,
SUM(CASE WHEN A.Status in ('SubmissionDate') THEN Case WHEN C.Frequency > 0 THEN 1 ELSE 0 END ELSE 0 END) as 'GrossPiece',
SUM(CASE WHEN A.Status in ('SubmissionDate') THEN Case WHEN C.Frequency = 0 THEN 1 ELSE 0 END ELSE 0 END) as 'GrossPieceOT',
SUM(CASE WHEN A.Status in ('ClientRejectDate','UpDownRejectDate','RejectDate') THEN 1 ELSE 0 END) as 'RejectPiece',
SUM(CASE WHEN A.Status in ('ClientRejectDate','UpDownRejectDate','RejectDate') AND C.Frequency > 0 THEN 1 ELSE 0 END) as 'RejectPieceRec',
SUM(CASE WHEN A.Status in ('ClientRejectDate','UpDownRejectDate','RejectDate') AND C.Frequency = 0 THEN 1 ELSE 0 END) as 'RejectPieceOT' FROM NewMYDB_PROD..VW_CH_SS A
LEFT JOIN NewMYDB_PROD..VW_CampaignList B ON A.Client = B.ClientCode
LEFT JOIN NewMYDB_PROD..MST_CHR_Package C ON A.PackageId = C.PackageID
  WHERE StatusWEDate = @CountryWeDate  and ICStroke > 0
and ISNULL(BadgeID,'') <> '' and A.Status in ('SubmissionDate','ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate','ClientRejectDate','UpDownRejectDate','RejectDate')
and IsDeleted = 0
GROUP BY   B.Campaign
) B ON A.Country = 'Malaysia' and A.Division = 'Charity' and A.Customer = B.Campaign
  
 
UPDATE A SET A.RejectPiece = B.RejectPiece, A.GrossPieceOT = 0, A.ResubPiece = B.ResubPiece, A.GrossPiece =  B.GrossPiece, A.GrossBAEarning = B.Gross, A.NetBAEarning = B.NetSales, A.GrossSales = B.Gross, A.NetPiece = B.NetPiece, A.RejectPieceOT = 0, A.RejectPieceRec = B.RejectPiece, A.ResubPieceOT = 0, A.ResubPieceRec = B.ResubPiece FROM #ReportDate A INNER JOIN(
SELECT 'TAKAFUL' as 'Campaign', 
SUM(Case WHEN A.Status in ('SubmissionDate') THEN D.ICStroke  ELSE 0 END) as 'Gross', 
SUM(Case WHEN A.Status in ('SubmissionDate','ReSubDate','ClientReSubDate') THEN D.ICStroke  ELSE D.ICStroke * -1 END) as 'NetSales',
SUM(Case WHEN A.Status in ('SubmissionDate','ReSubDate','ClientReSubDate') THEN 1 ELSE -1 END) as 'NetPiece',
SUM(Case WHEN A.Status not in ('SubmissionDate','ReSubDate','ClientReSubDate') THEN 1 ELSE 0 END) as 'RejectPiece',
SUM(Case WHEN A.Status in ('SubmissionDate') THEN 1 ELSE 0 END) as 'GrossPiece',
SUM(Case WHEN A.Status in ('ReSubDate','ClientReSubDate') THEN 1 ELSE 0 END) as 'ResubPiece'   
FROM NewMYDB_PROD..Tbl_TKF_Maintable_StatusSummary A 
LEFT JOIN NewMYDB_PROD..Tbl_TKF_Maintable B ON A.RowId = B.RowId 
LEFT JOIN NewMYDB_PROD..VW_TKF_PackagesName C ON B.MonthlyPremiumId = C.Id
LEFT JOIN NewMYDB_PROD..MST_MSF D ON A.MSFID_H = D.ID
where A.StatusWE = @CountryWeDate and A.IsDeleted = 0
and A.Status in ('SubmissionDate','ReSubDate','ClientReSubDate','ClientRejectDate','RejectDate') 
) B ON A.Country = 'Malaysia' and A.Division = 'Commercial' and A.Customer = B.Campaign



UPDATE A SET A.ResubPiece = B.ResubPiece, A.ResubPieceRec = B.ResubPiece, A.ResubPieceOT = 0, A.GrossPiece = B.GrossPiece, A.GrossPieceOT = B.GrossPieceOT, A.RejectPiece = B.RejectPiece,A.RejectPieceOT = 0, A.RejectPieceRec = B.RejectPiece , A.GrossSales = B.Gross, A.GrossBAEarning = B.Gross, A.NetBAEarning = B.NetSales, A.NetPiece = B.NetPiece FROM #ReportDate A INNER JOIN(
SELECT C.Campaign as 'Campaign',
SUM(CASE WHEN A.Status in ('SubmissionDate','ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate') THEN ICStroke ELSE 0 END) as 'Gross',
SUM(CASE WHEN A.Status in ('SubmissionDate','ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate') THEN ICStroke WHEN A.Status in ('ClientRejectDate','UpDownRejectDate','RejectDate') THEN ICStroke * - 1 ELSE 0 END) as 'NetSales',
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


UPDATE A SET A.GrossPieceOT = 0, A.RejectPiece = B.RejectPieces, A.RejectPieceRec = B.RejectPieces, A.RejectPieceOT = 0, A.ResubPiece = B.ResubPieces, A.ResubPieceOT = 0, A.ResubPieceRec = B.ResubPieces, A.GrossPiece = B.SignUpPieces, A.GrossSales = B.TotalEarning, A.GrossBAEarning = B.TotalEarning, A.NetBAEarning = B.NetEarning,  A.NetPiece = B.SignUpPieces + B.ResubPieces - B.RejectPieces 
FROM #ReportDate A INNER JOIN(
SELECT 'Malaysia' as 'Country',CASE WHEN C.DivisionCode = 'CO' THEN 'Commercial' WHEN C.DivisionCode = 'CH' THEN 'Charity'
WHEN C.DivisionCode = 'LS' THEN 'LifeStyle' END as 'Division', B.CampaignName,
SUM(A.SignUpPieces) as 'SignUpPieces', SUM(A.ResubPieces) as 'ResubPieces', SUM(A.RejectPieces) as 'RejectPieces', 
SUM(A.TotalEarning) as 'TotalEarning', SUM(A.SWBonus) as 'SWBonus',SUM( A.NetEarning) as 'NetEarning'
FROM Appco360_PROD..Txn_SalesImport A LEFT JOIN Mst_Campaign B ON A.Campaign = B.CampaignCode 
INNER JOIN Mst_Division C ON B.DivisionId = C.DivisionId
WHERE Country = 'MY' and WEDate =@CountryWeDate and A.IsDeleted = 0 and 
ISNULL(TotalEarning,0.00) > 0.00 and ISNULL(SignUpPieces,0) > 0
GROUP BY CASE WHEN C.DivisionCode = 'CO' THEN 'Commercial' WHEN C.DivisionCode = 'CH' THEN 'Charity'
WHEN C.DivisionCode = 'LS' THEN 'LifeStyle' END, B.CampaignName
) B ON A.Country = 'Malaysia' and A.Division = 'Commercial' and A.Customer = B.CampaignName


 UPDATE A SET A.GrossPieceOT = 0, A.RejectPiece = 0, A.RejectPieceOT = 0, A.RejectPieceRec = 0, A.ResubPiece = 0, A.ResubPieceOT = 0, A.ResubPieceRec = 0, A.GrossPiece = B.NetPiece, A.GrossSales = B.Gross, A.GrossBAEarning = B.Gross, A.NetBAEarning = B.gross, A.NetPiece = B.NetPiece FROM #ReportDate A INNER JOIN(
SELECT B.Campaign as 'Campaign', SUM(TTL_MSF) as 'Gross', SUM(C.Purchase_Qty) as 'NetPiece' FROM NewMYDB_PROD..TXN_Lif_SalesHeader A 
LEFT JOIN NewMYDB_PROD..TXN_Lif_Sales_Detail C ON A.Trxn_No = C.Trxn_No and C.Purchase_Qty > 0
LEFT JOIN NewMYDB_PROD..VW_CampaignList B ON A.PRDCAT_Code = B.ClientCode
 where MO_Sub_Week = @CountryWeDate and DE_By is not null and A.IsDeleted = 0 and C.IsDeleted = 0
 GROUP BY B.Campaign  

) B ON A.Country = 'Malaysia' and A.Division = 'LifeStyle' and A.Customer = B.Campaign
 
UPDATE A SET A.GrossPieceOT = 0, A.RejectPiece = 0, A.RejectPieceRec = 0, A.RejectPieceOT = 0, A.ResubPiece = 0, A.ResubPieceOT = 0, A.ResubPieceRec = 0, A.GrossPiece = B.NetPiece, A.GrossSales = B.Gross, A.GrossBAEarning = B.Gross, A.NetBAEarning = B.gross,  A.NetPiece = B.NetPiece FROM #ReportDate A INNER JOIN(
SELECT B.Campaign as 'Campaign', SUM(TTLValue) as 'Gross', SUM(TTLPcs) as 'NetPiece' FROM NewMYDB_PROD..TXN_CO_ICE_HASAVA A  
LEFT JOIN NewMYDB_PROD..VW_CampaignList B ON B.ClientCode = 'HS'
 where WEDate = @CountryWeDate 
 GROUP BY B.Campaign   
) B ON A.Country = 'Malaysia' and A.Division = 'Commercial' and A.Customer = 'HASAVA'
  
 

UPDATE #ReportDate SET SWBonus = 0.00 where Country = 'Malaysia'

UPDATE A SET A.SWBonus = B.Bonus FROM #ReportDate A INNER JOIN (
SELECT B.ID, SUM(Bonus) Bonus FROM NewMYDB_PROD..TXN_CH_ICE A LEFT JOIN NewMYDB_PROD..VW_CampaignList B ON A.Client = B.ClientCode
where WEDate = @CountryWeDate and ChannelId = 'Total'
GROUP BY B.ID ) B ON A.CampaignID = B.ID

UPDATE A SET A.SWBonus = ISNULL(B.Bonus,0.00) FROM #ReportDate A INNER JOIN (
SELECT 1063 as 'ID', SUM(ISNULL(TotalBonusPayable,0.00)) As Bonus FROM NewMYDB_PROD..TXN_CO_ICE where  ISNULL( TotalBonusPayable,0) > 0
and Client  ='STM' and  SubmissionWEDate = '2023-01-01' ) B ON A.CampaignID = B.ID

UPDATE A SET A.SWBonus = ISNULL(B.Bonus,0.00) FROM #ReportDate A INNER JOIN (
SELECT 52 as 'ID', SUM(ISNULL(TotalBonusPayable,0)) As Bonus FROM NewMYDB_PROD..TXN_CO_ICE where  ISNULL( TotalBonusPayable,0) > 0
and Client  ='TKF' and  SubmissionWEDate = '2023-01-01' ) B ON A.CampaignID = B.ID


UPDATE A SET A.SWBonus = ISNULL(B.Bonus,0.00) FROM #ReportDate A INNER JOIN (
 SELECT 'Malaysia' as 'Country',CASE WHEN C.DivisionCode = 'CO' THEN 'Commercial' WHEN C.DivisionCode = 'CH' THEN 'Charity'
WHEN C.DivisionCode = 'LS' THEN 'LifeStyle' END as 'Division', B.CampaignId,
SUM(A.SWBonus) as 'Bonus' 
FROM Appco360_PROD..Txn_SalesImport A LEFT JOIN Mst_Campaign B ON A.Campaign = B.CampaignCode 
INNER JOIN Mst_Division C ON B.DivisionId = C.DivisionId
WHERE Country = 'MY' and WEDate ='2023-03-26' and A.IsDeleted = 0 and 
ISNULL(TotalEarning,0.00) > 0.00 and ISNULL(SignUpPieces,0) > 0
GROUP BY CASE WHEN C.DivisionCode = 'CO' THEN 'Commercial' WHEN C.DivisionCode = 'CH' THEN 'Charity'
WHEN C.DivisionCode = 'LS' THEN 'LifeStyle' END, B.CampaignId
) B ON A.CampaignID = B.CampaignId


SET @UniqueDiv1 = 0
SET @UniqueDiv2 = 0
SET @UniqueDiv3 = 0
SELECT @UniqueDiv1 = COUNT(Distinct BadgeNo) FROM (
SELECT distinct BadgeID as 'BadgeNo'  FROM  NewMYDB_PROD..VW_CH_SS WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeID,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0  
--UNION ALL
--SELECT   DISTINCT IC_Code FROM NewMYDB_PROD..TXN_Lif_SalesHeader where MO_Sub_Week = @CountryWeDate and DE_By is not null and IsDeleted = 0 and PRDCAT_Code ='WTB'
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

 
-- =================================================== Singapore (START)====================================================================
-- ========================================================================================================================================

SELECT @weFromDate = FromDate, @weToDate = ToDate, @CountryWeDate = WEdate  FROM NewSGDB_PROD..Mst_Weekending where WEdate = @weDate

--If not found, Possible short week. check WE -1
IF (@weFromDate is null )
BEGIN 
PRINT 'If not found, Possible short week. check WE -1'
SELECT @weFromDate = FromDate, @weToDate = ToDate, @CountryWeDate = WEdate  FROM NewSGDB_PROD..Mst_Weekending where WEdate = DATEADD(day, -1 ,@weDate)
END
--If not found, Possible short week. check WE -2
IF (@weFromDate is null )
BEGIN 
PRINT 'If not found, Possible short week. check WE -2'
SELECT @weFromDate = FromDate, @weToDate = ToDate, @CountryWeDate = WEdate  FROM NewSGDB_PROD..Mst_Weekending where WEdate = DATEADD(day, -2 ,@weDate)
END

--If not found, Possible long week. check WE + 1
IF (@weFromDate is null )
BEGIN 
PRINT 'If not found, Possible long week. check WE + 1'
SELECT @weFromDate = FromDate, @weToDate = ToDate, @CountryWeDate = WEdate  FROM NewSGDB_PROD..Mst_Weekending where WEdate = DATEADD(day, 1 ,@weDate)
END

--Max Check Possible 2 day short weekending, if no found, no data will be shown
 
IF (@CountryWeDate is not null )
BEGIN



  	DROP TABLE IF EXISTS #StarHubTempResult
	SELECT A.MOCode, A.BadgeNo, A.BAName, /*B.CustType, B.ContractType,*/ B.Payout_Name, B.TCV, /*B.Payout_MSF,*/
			SUM(CASE WHEN (C.[Status] = 'PENDING') THEN 1 
					 ELSE 0 
				END) AS 'GrossQty',
			SUM(CASE WHEN (C.[Status] = 'PENDING') THEN ISNULL(CAST(B.Total_Payout_BA AS DECIMAL(18,2)), 0) 
					 ELSE 0 
				END) AS 'GrossBAFees',
			--SUM(CASE WHEN (C.[Status] = 'PENDING') THEN ISNULL(1 * (TCV * B.Payout_MSF / 100), 0) ELSE 0 END) AS 'GrossMSF',
			SUM(CASE WHEN (C.[Status] = 'REJECT' OR C.[Status] = 'SALESWORKSREJECT' OR C.[Status] = 'CANCELLATIONREJECT') THEN 1
					 ELSE 0 
				END) AS 'RejectQty',
			SUM(CASE WHEN (C.[Status] = 'REJECT' OR C.[Status] = 'SALESWORKSREJECT' OR C.[Status] = 'CANCELLATIONREJECT') THEN ISNULL(CAST(B.Total_Payout_BA AS DECIMAL(18,2)), 0)
					 ELSE 0 
				END) AS 'RejectBAFees',
			--SUM(CASE WHEN (C.[Status] = 'REJECT' OR C.[Status] = 'SALESWORKSREJECT' OR C.[Status] = 'CANCELLATIONREJECT') THEN ISNULL(1 * (TCV * B.Payout_MSF / 100), 0) ELSE 0 END) AS 'RejectMSF',
			SUM(CASE WHEN (C.[Status] = 'RESUB') THEN 1
					 ELSE 0 
				END) AS 'ResubQty',
			SUM(CASE WHEN (C.[Status] = 'RESUB') THEN ISNULL(CAST(B.Total_Payout_BA AS DECIMAL(18,2)), 0)
					 ELSE 0 
				END) AS 'ResubBAFees'--,
			--SUM(CASE WHEN (C.[Status] = 'RESUB') THEN ISNULL(1 * (TCV * B.Payout_MSF / 100), 0) ELSE 0 END) AS 'ResubMSF'
	INTO #StarHubTempResult
	FROM NewSGDB_PROD..TXN_Starhub_Transaction_StatusSummary AS A
	INNER JOIN NewSGDB_PROD..TXN_Starhub_TransStatusSummary_Product AS B ON A.SummaryID = B.SummaryID AND 
															  A.TxnID = B.TxnID
	INNER JOIN NewSGDB_PROD..TXN_Starhub_TransStatusSummary_Status AS C ON A.SummaryID = C.SummaryID AND 
															 A.TxnID = C.TxnID
	WHERE  
		  C.StatusWEDate = @CountryWeDate AND
		  C.[Status] <> 'INVOICED'
	GROUP BY A.MOCode,A.BadgeNo, A.BAName, /*B.CustType, B.ContractType,*/ B.Payout_Name, /*C.[Status],*/ B.TCV--, B.Payout_MSF;



INSERT INTO #DailySHC
SELECT distinct   'Singapore' as 'Country', 'Charity', B.Client as 'Customer', StatusDate, COUNT(distinct BadgeNo)  FROM  NewSGDB_PROD..VW_CH_SS A 
LEFT JOIN NewSGDB_PROD..VW_MST_CampaignList B ON A.CampaignCode = B.ID 
WHERE StatusWEDate = @CountryWeDate  and Status = 'SubmissionDate' and IsDeleted = 0  GROUP BY B.Client, StatusDate
ORDER BY B.Client, StatusDate
 
INSERT INTO #DailySHC
SELECT distinct   'Singapore' as 'Country', 'Commercial', 'STARHUB' as 'Customer',@CountryWeDate, COUNT(distinct BadgeNo)  FROM  #StarHubTempResult A 
WHERE  GrossQty > 0  and Mocode not in ('HQ')
 
 
SELECT @UniqueSCH = COUNT(Distinct BadgeNo) FROM (
SELECT distinct BadgeNo as 'BadgeNo'  FROM  NewSGDB_PROD..VW_CH_SS WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeNo,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0 UNION ALL 
SELECT distinct BadgeNo  FROM  #StarHubTempResult A  WHERE  GrossQty > 0  and Mocode not in ('HQ') 
) A
 
INSERT INTO #ReportDate (Country, Division, Customer, CampaignID, Weekending, RMonth, RQuarter, CountryUSHC, USCH)
SELECT 'Singapore' as 'Country', A.Division, B.Client as 'Customer', B.ID, @CountryWeDate as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter', @UniqueSCH as 'CountryUniqueSHC',  A.BadgeNo as 'UniqueSHC' FROM (
SELECT CampaignCode as 'Campaign', 'Charity' as Division, COUNT( distinct BadgeNo) as 'BadgeNo'  FROM NewSGDB_PROD..VW_CH_SS WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeNo,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0 
GROUP BY CampaignCode
) A LEFT JOIN NewSGDB_PROD..VW_MST_CampaignList B ON A.Campaign = B.ID 
  
   
INSERT INTO #ReportDate (Country, Division, Customer,CampaignID, Weekending, RMonth, RQuarter, CountryUSHC, USCH)
SELECT  'Singapore' as 'Country', A.Division, B.Client as 'Customer', B.ID, @CountryWeDate as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter', @UniqueSCH as 'CountryUniqueSHC',  0 as 'UniqueSHC' FROM (
SELECT CampaignCode as 'Campaign', 'Charity' as Division FROM NewSGDB_PROD..VW_CH_SS WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeNo,'') <> '' and Status <> 'SubmissionDate' and IsDeleted = 0 
GROUP BY CampaignCode) A 
LEFT JOIN NewSGDB_PROD..VW_MST_CampaignList B ON A.Campaign = B.ID 
LEFT JOIN #ReportDate Z ON A.Division = Z.Division  and B.Client = Z.Customer
WHERE Z.Customer is null

 

INSERT INTO #ReportDate (Country, Division, Customer, CampaignID, Weekending, RMonth, RQuarter, CountryUSHC, USCH)
SELECT 'Singapore' as 'Country', 'Commercial', 'STARHUB' as 'Customer', 1125, @CountryWeDate as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter', @UniqueSCH as 'CountryUniqueSHC',  A.BadgeNo as 'UniqueSHC' FROM (
SELECT 'STARHUB' as 'Campaign', 'Commercial' as Division, COUNT( distinct BadgeNo) as 'BadgeNo'  FROM #StarHubTempResult 
WHERE  GrossQty > 0  and Mocode not in ('HQ') 
) A  
 

UPDATE A SET A.ResubPiece = B.ResubPiece,A.ResubPieceRec = B.ResubPieceRec,A.ResubPieceOT = B.ResubPieceOT, A.GrossPiece = B.GrossPiece, 
A.GrossPieceOT = B.GrossPieceOT, A.RejectPiece = B.RejectPiece, A.RejectPieceRec = B.RejectPieceRec, 
A.RejectPieceOT = B.RejectPieceOT, A.GrossSales = B.Gross, A.GrossBAEarning = B.gross, 
A.NetBAEarning = B.NetSales, A.NetPiece = B.NetPiece FROM #ReportDate A INNER JOIN(
SELECT B.Client as 'Campaign',
SUM(CASE WHEN A.Status in ('SubmissionDate') THEN ICStrokeValue ELSE 0 END) as 'Gross', 
SUM(CASE WHEN A.Status in ('SubmissionDate','ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate') THEN ICStrokeValue ELSE ICStrokeValue * -1 END) as 'NetSales' ,
SUM(CASE WHEN A.Status in ('SubmissionDate','ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate') THEN 1 ELSE -1 END) as 'NetPiece' ,
SUM(CASE WHEN A.Status in ('ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate') THEN 1 ELSE 0 END) as 'ResubPiece' ,
SUM(CASE WHEN A.Status in ('ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate') and A.Frequency > 0  THEN 1 ELSE 0 END) as 'ResubPieceRec' ,
SUM(CASE WHEN A.Status in ('ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate') and A.Frequency = 0 THEN 1 ELSE 0 END) as 'ResubPieceOT' ,
SUM(CASE WHEN A.Status in ('SubmissionDate') THEN Case WHEN A.Frequency > 0 THEN 1 ELSE 0 END ELSE 0 END) as 'GrossPiece',
SUM(CASE WHEN A.Status in ('SubmissionDate') THEN Case WHEN A.Frequency = 0 THEN 1 ELSE 0 END ELSE 0 END) as 'GrossPieceOT',
SUM(CASE WHEN A.Status in ('ClientRejectDate','UpDownRejectDate','RejectDate') THEN 1 ELSE 0 END) as 'RejectPiece' ,
SUM(CASE WHEN A.Status in ('ClientRejectDate','UpDownRejectDate','RejectDate') and A.Frequency > 0 THEN 1 ELSE 0 END) as 'RejectPieceRec' ,
SUM(CASE WHEN A.Status in ('ClientRejectDate','UpDownRejectDate','RejectDate') and A.Frequency = 0 THEN 1 ELSE 0 END) as 'RejectPieceOT' 
FROM NewSGDB_PROD..VW_CH_SS A
LEFT JOIN NewSGDB_PROD..VW_MST_CampaignList B ON A.CampaignCode = B.ID
LEFT JOIN NewSGDB_PROD..Mst_Ch_Package C ON A.PackageId = C.PackageID
  WHERE StatusWEDate = @CountryWeDate -- and ICStrokeValue > 0
and ISNULL(BadgeNo,'') <> '' and A.Status in ('SubmissionDate','ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate','ClientRejectDate','UpDownRejectDate','RejectDate')
and A.IsDeleted = 0
GROUP BY   B.Client
) B ON A.Country = 'Singapore' and A.Division = 'Charity' and A.Customer = B.Campaign



UPDATE A SET A.ResubPiece = B.ResubPiece,A.ResubPieceRec = B.ResubPieceRec,A.ResubPieceOT = B.ResubPieceOT, A.GrossPiece = B.GrossPiece, 
A.GrossPieceOT = B.GrossPieceOT, A.RejectPiece = B.RejectPiece, A.RejectPieceRec = B.RejectPieceRec, 
A.RejectPieceOT = B.RejectPieceOT, A.GrossSales = B.Gross, A.GrossBAEarning = B.gross, 
A.NetBAEarning = B.NetSales, A.NetPiece = B.NetPiece FROM #ReportDate A INNER JOIN(
SELECT 'STARHUB' as 'Campaign',
SUM(GrossBAFees) as 'Gross', 
SUM(GrossBAFees - RejectBAFees + ResubBAFees) as 'NetSales' ,
SUM(GrossQty - RejectQty + ResubQty) as 'NetPiece' ,
SUM(ResubQty) as 'ResubPiece' ,
0 as 'ResubPieceRec' ,
0 as 'ResubPieceOT' ,
SUM(GrossQty) as 'GrossPiece',
0 as 'GrossPieceOT',
SUM(RejectQty) as 'RejectPiece' ,
0 as 'RejectPieceRec' ,
0 as 'RejectPieceOT' 
FROM #StarHubTempResult A WHERE  GrossQty > 0  and Mocode not in ('HQ')  
) B ON A.Country = 'Singapore' and A.Division = 'Commercial' and A.Customer = 'STARHUB'
 

SET @UniqueDiv1 = 0
SET @UniqueDiv2 = 0
SET @UniqueDiv3 = 0
SELECT @UniqueDiv1 = COUNT(Distinct BadgeNo) FROM (
SELECT distinct BadgeNo as 'BadgeNo'  FROM  NewSGDB_PROD..VW_CH_SS WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeNo,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0  
) A

SELECT @UniqueDiv2 = COUNT(Distinct BadgeNo) FROM (
SELECT distinct BadgeNo as 'BadgeNo'  FROM  #StarHubTempResult WHERE  GrossQty > 0  and Mocode not in ('HQ')  
) A


UPDATE #ReportDate SET DivUSCH = @UniqueDiv1 where Country = 'Singapore' and Division = 'Charity' 
UPDATE #ReportDate SET DivUSCH = @UniqueDiv2 where Country = 'Singapore' and Division = 'Commercial' 
END
-- =================================================== Singapore (END  )====================================================================
-- ========================================================================================================================================

 

-- =================================================== Indonesia (START)====================================================================
-- ========================================================================================================================================

SELECT @weFromDate = FromDate, @weToDate = ToDate, @CountryWeDate = WEdate  FROM NewIndoDB_PROD..TBL_weekending where WEdate = @weDate

--If not found, Possible short week. check WE -1
IF (@weFromDate is null )
BEGIN 
PRINT 'If not found, Possible short week. check WE -1'
SELECT @weFromDate = FromDate, @weToDate = ToDate, @CountryWeDate = WEdate  FROM NewIndoDB_PROD..TBL_weekending where WEdate = DATEADD(day, -1 ,@weDate)
END
--If not found, Possible short week. check WE -2
IF (@weFromDate is null )
BEGIN 
PRINT 'If not found, Possible short week. check WE -2'
SELECT @weFromDate = FromDate, @weToDate = ToDate, @CountryWeDate = WEdate  FROM NewIndoDB_PROD..TBL_weekending where WEdate = DATEADD(day, -2 ,@weDate)
END

--If not found, Possible long week. check WE + 1
IF (@weFromDate is null )
BEGIN 
PRINT 'If not found, Possible long week. check WE + 1'
SELECT @weFromDate = FromDate, @weToDate = ToDate, @CountryWeDate = WEdate  FROM NewIndoDB_PROD..TBL_weekending where WEdate = DATEADD(day, 1 ,@weDate)
END

--Max Check Possible 2 day short weekending, if no found, no data will be shown
 
IF (@CountryWeDate is not null )
BEGIN

INSERT INTO #DailySHC
SELECT distinct   'Indonesia' as 'Country', 'Charity', CampaignCode as 'Customer', StatusDate, COUNT(distinct BadgeID)  FROM  NewIndoDB_PROD..VW_CH_SS WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeID,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0  GROUP BY CampaignCode, StatusDate
ORDER BY CampaignCode, StatusDate
 
 
SELECT @UniqueSCH = COUNT(Distinct BadgeNo) FROM (
SELECT distinct BadgeID as 'BadgeNo'  FROM  NewIndoDB_PROD..VW_CH_SS WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeID,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0 
) A
 
INSERT INTO #ReportDate (Country, Division, Customer, CampaignID, Weekending, RMonth, RQuarter, CountryUSHC, USCH)
SELECT 'Indonesia' as 'Country', A.Division, B.CampaignName as 'Customer', B.CampaignId, @CountryWeDate as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter', @UniqueSCH as 'CountryUniqueSHC',  A.BadgeNo as 'UniqueSHC' FROM (
SELECT CampaignCode as 'Campaign', 'Charity' as Division, COUNT( distinct BadgeID) as 'BadgeNo'  FROM NewIndoDB_PROD..VW_CH_SS WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeID,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0 
GROUP BY CampaignCode
) A LEFT JOIN NewIndoDB_PROD..VW_MST_Campaign B ON A.Campaign = B.CampaignName 
  
   
INSERT INTO #ReportDate (Country, Division, Customer,CampaignID, Weekending, RMonth, RQuarter, CountryUSHC, USCH)
SELECT  'Indonesia' as 'Country', A.Division, B.CampaignName as 'Customer', B.CampaignId, @CountryWeDate as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter', @UniqueSCH as 'CountryUniqueSHC',  0 as 'UniqueSHC' FROM (
SELECT CampaignCode as 'Campaign', 'Charity' as Division FROM NewIndoDB_PROD..VW_CH_SS WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeID,'') <> '' and Status <> 'SubmissionDate' and IsDeleted = 0 
GROUP BY CampaignCode) A 
LEFT JOIN NewIndoDB_PROD..VW_MST_Campaign B ON A.Campaign = B.CampaignName 
LEFT JOIN #ReportDate Z ON A.Division = Z.Division  and B.CampaignName = Z.Customer
WHERE Z.Customer is null
     
  
UPDATE A SET A.ResubPiece = B.ResubPiece,A.ResubPieceRec = B.ResubPieceRec,A.ResubPieceOT = B.ResubPieceOT, A.GrossPiece = B.GrossPiece, 
A.GrossPieceOT = B.GrossPieceOT, A.RejectPiece = B.RejectPiece, A.RejectPieceRec = B.RejectPieceRec, 
A.RejectPieceOT = B.RejectPieceOT, A.GrossSales = B.Gross, A.GrossBAEarning = B.gross, 
A.NetBAEarning = B.NetSales, A.NetPiece = B.NetPiece FROM #ReportDate A INNER JOIN(
SELECT B.CampaignName as 'Campaign',
SUM(CASE WHEN A.Status in ('SubmissionDate') THEN ICStroke ELSE 0 END) as 'Gross', 
SUM(CASE WHEN A.Status in ('SubmissionDate','ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate') THEN ICStroke ELSE ICStroke * -1 END) as 'NetSales' ,
SUM(CASE WHEN A.Status in ('SubmissionDate','ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate') THEN 1 ELSE -1 END) as 'NetPiece' ,
SUM(CASE WHEN A.Status in ('ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate') THEN 1 ELSE 0 END) as 'ResubPiece' ,
SUM(CASE WHEN A.Status in ('ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate') and A.Frequency > 0  THEN 1 ELSE 0 END) as 'ResubPieceRec' ,
SUM(CASE WHEN A.Status in ('ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate') and A.Frequency = 0 THEN 1 ELSE 0 END) as 'ResubPieceOT' ,
SUM(CASE WHEN A.Status in ('SubmissionDate') THEN Case WHEN A.Frequency > 0 THEN 1 ELSE 0 END ELSE 0 END) as 'GrossPiece',
SUM(CASE WHEN A.Status in ('SubmissionDate') THEN Case WHEN A.Frequency = 0 THEN 1 ELSE 0 END ELSE 0 END) as 'GrossPieceOT',
SUM(CASE WHEN A.Status in ('ClientRejectDate','UpDownRejectDate','RejectDate') THEN 1 ELSE 0 END) as 'RejectPiece' ,
SUM(CASE WHEN A.Status in ('ClientRejectDate','UpDownRejectDate','RejectDate') and A.Frequency > 0 THEN 1 ELSE 0 END) as 'RejectPieceRec' ,
SUM(CASE WHEN A.Status in ('ClientRejectDate','UpDownRejectDate','RejectDate') and A.Frequency = 0 THEN 1 ELSE 0 END) as 'RejectPieceOT' 
FROM NewIndoDB_PROD..VW_CH_SS A
LEFT JOIN NewIndoDB_PROD..VW_MST_Campaign B ON A.CampaignCode = B.CampaignName
  WHERE StatusWEDate = @CountryWeDate -- and ICStrokeValue > 0
and ISNULL(BadgeID,'') <> '' and A.Status in ('SubmissionDate','ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate','ClientRejectDate','UpDownRejectDate','RejectDate')
and A.IsDeleted = 0
GROUP BY   B.CampaignName
) B ON A.Country = 'Indonesia' and A.Division = 'Charity' and A.Customer = B.Campaign


SET @UniqueDiv1 = 0
SET @UniqueDiv2 = 0
SET @UniqueDiv3 = 0
SELECT @UniqueDiv1 = COUNT(Distinct BadgeNo) FROM (
SELECT distinct BadgeID as 'BadgeNo'  FROM  NewIndoDB_PROD..VW_CH_SS WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeID,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0  
) A

 

UPDATE #ReportDate SET DivUSCH = @UniqueDiv1 where Country = 'Indonesia' and Division = 'Charity' 
END

-- =================================================== Indonesia (END  )====================================================================
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
 
INSERT INTO #ReportDate (Country, Division, Customer, CampaignID, Weekending, RMonth, RQuarter, CountryUSHC, USCH)
SELECT 'Philippines' as 'Country', A.Division, A.Campaign as 'Customer',  ID, @CountryWeDate as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter', @UniqueSCH as 'CountryUniqueSHC',  A.BadgeNo as 'UniqueSHC' FROM (
SELECT B.Client as 'Campaign', 'Charity' as Division, B.ID, COUNT( distinct BadgeNo) as 'BadgeNo'  FROM NewPHDB_PROD..VW_CH_SS A 
LEFT JOIN NewPHDB_PROD..VW_MST_CampaignList B ON A.CampaignCode = B.ID
WHERE StatusWEDate = @CountryWeDate  and ISNULL(BadgeNo,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0
GROUP BY  B.Client , B.ID
UNION ALL
SELECT  B.Client as 'Campaign', 'Commercial' as Division, B.ID, COUNT( distinct BadgeNo) as 'BadgeNo'   FROM NewPHDB_PROD..VW_CO_TXN A 
LEFT JOIN NewPHDB_PROD..VW_MST_CampaignList B ON A.CampaignCode = B.ID
WHERE MoSubmissionDate >= @weFromDate and MoSubmissionDate <=@weToDate  and IsDeleted = 0
GROUP BY  B.Client , B.ID
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

DROP TABLE IF EXISTS #IndiaLead
CREATE TABLE #IndiaLead(
WeDate DATE,
SignUp INT,
Unsuccessful INT,
SuccessFul int,
FirstDebit INT
)

DROP TABLE IF EXISTS #RawLead
SELECT distinct CONVERT(DATE, SubmitDate, 103) as 'SubDate', NewIndiaDB_PROD.dbo.WeekedingDate(CONVERT(DATE, SubmitDate, 103)) as 'WeDate' , LeaDID, UserEmpCode, CAST(CAST( Amount as decimal(18,2)) as int) as Amount
INTO #RawLead
FROM NewIndiaDB_PROD..Txn_Temp_ProLeadLeadFile_Archive
WHERE NewIndiaDB_PROD.dbo.WeekedingDate(CONVERT(DATE, SubmitDate, 103)) >= @CountryWeDate and NewIndiaDB_PROD.dbo.WeekedingDate(CONVERT(DATE, SubmitDate, 103)) <=@CountryWeDate
 
DROP TABLE IF EXISTS #UnSuccessFul
SELECT Distinct SerialNumber INTO #UnSuccessFul FROM NewIndiaDB_PROD..Txn_Temp_EnachBillDeskUnsuccessful_Archive WHERE SerialNumber in (

SELECT LeadId FROM #RawLead
) and SerialNumber in (
SELECT LeaDID from #RawLead
)
 
DROP TABLE IF EXISTS #EnachApproved
SELECT DISTINCT REPLACE(SerialNumber,'PRO','') as SerialNumber, CONVERT(DATE, FirstPaymentDate, 103) as 'FirstDebit' INTO #EnachApproved FROM NewIndiaDB_PROD..Txn_Temp_EnachSuccessful_Archive
where FirstPaymentDate is not null  and PledgeStatus = 'Enrolled' and CONVERT(DATE, FirstPaymentDate, 103) >='2023-01-01'
and REPLACE(SerialNumber,'PRO','') in ( 
SELECT LeaDID from #RawLead
)


DROP TABLE IF EXISTS #FirstDebit
SELECT REPLACE(SerialNumber,'PRO','') as 'SerialNumber' INTO #FirstDebit  FROM NewIndiaDB_PROD..VW_CHR_TXN WHERE REPLACE(SerialNumber,'PRO','') in (
SELECT LeadId FROM #RawLead 
) and REPLACE(SerialNumber,'PRO','') in (
SELECT LeaDID from #RawLead
)

DROP TABLE IF EXISTS #Successful
SELECT DISTINCT REPLACE(SerialNumber,'PRO','') as 'SerialNumber' INTO #Successful FROM NewIndiaDB_PROD..Txn_Temp_EnachSuccessful_Archive
WHERE RTRIM(ISNULL(PledgeStatus,'')) = 'Enrolled' and REPLACE(SerialNumber,'PRO','') in (
SELECT LeaDID from #RawLead
)

DROP TABLE IF EXISTS #Final
SELECT A.* , B.SerialNumber as 'UnSuccessFul', C.SerialNumber as 'Successful',   D.SerialNumber as 'FirstDebit' INTO #Final FROM  
#RawLead A 
LEFT JOIN #UnSuccessFul B ON A.LeadId = B.SerialNumber
LEFT JOIN #Successful C ON A.LeadId = C.SerialNumber
LEFT JOIN #EnachApproved D ON A.LeadId = D.SerialNumber

ORDER BY A.WeDate 
 

  INSERT INTO #DailySHC
 SELECT 'India','CHARITY','UNICEF', Subdate, COUNT(distinct UserEmpCode) FROM #RawLead
 GROUP BY Subdate


 --SELECT  *, B.BadgeNO,* FROM (
 --SELECT 'PRO' + SerialNumber as 'SerialNo' FROM #Successful UNION
 --SELECT 'PRO' + SerialNumber as 'SerialNo' FROM #UnSuccessFul
 --) A LEFT JOIN NewIndiaDB_PROD..VW_CHR_TXN B ON A.SerialNo = B.SerialNumber
 --return

UPDATE #Final SET UnSuccessFul = null where Successful is not null 

INSERT INTO #IndiaLead
SELECT WeDate, COUNT(*) as 'SignUp', SUM(CASE WHEN UnSuccessFul is not null THEN 1 ELSE 0 END) as 'Unsuccessful', 
SUM(CASE WHEN Successful is NOT null THEN 1 ELSE 0 END) as 'Successful',
SUM(CASE WHEN FirstDebit is NOT null THEN 1 ELSE 0 END) as 'FirstDebit'  FROM #Final
GROUP BY WeDate


SELECT @UniqueSCH = COUNT(Distinct UserEmpCode)  FROM (
SELECT distinct UserEmpCode FROM #RawLead 
) A
 

DECLARE @SuccessfulEarning as decimal(18,2)	 
SELECT @SuccessfulEarning = SUM(AgencyPayout) FROM  NewIndiaDB_PROD..VW_CHR_TXN  WHERE serialnumber in (  
SELECT 'PRO'+ SerialNumber FROM #Successful  
)  

 
DECLARE @UnSuccessfulEarning as decimal(18,2)
SELECT @UnSuccessfulEarning = SUM(CAST(A.Amount * 12.00 * AI.PayoutPerc / 100.00 as decimal(18,2)))  FROM #RawLead A INNER JOIN #UnSuccessFul B ON A.LeadId = B.SerialNumber
LEFT JOIN NewIndiaDB_PROD..MST_PayoutStroke AI ON AI.FeeType = 'AgencyInvoice' and CAST(A.SubDate as date) >= AI.StartDate and CAST(A.SubDate as date) <= AI.EndDate  
WHERE A.LeadId not in (
SELECT   SerialNumber FROM #Successful 
) 

INSERT INTO #ReportDate (Country, Division, Customer,CampaignID, Weekending, RMonth, RQuarter, CountryUSHC, USCH)
SELECT 'India' as 'Country', A.Division, A.Campaign as 'Customer', ID, @CountryWeDate as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter', @UniqueSCH as 'CountryUniqueSHC',  A.BadgeNo as 'UniqueSHC' FROM (
SELECT B.Client as 'Campaign', 'Charity' as Division,B.ID, COUNT( distinct BadgeNo) as 'BadgeNo'  FROM NewIndiaDB_PROD..VW_CH_SS A 
LEFT JOIN NewIndiaDB_PROD..VW_MST_CampaignList B ON A.Client = B.ID
WHERE StatusWEDate = @CountryWeDate  and ISNULL(BadgeNo,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0
GROUP BY  B.Client   ,B.ID
) A 

UPDATE #ReportDate set CountryUSHC = @UniqueSCH
WHERE Country = 'India'


UPDATE A SET A.GrossPieceOT = 0, A.ResubPiece =B.ResubPiece, A.RejectPiece = B.RejectPiece,A.NetBAEarning = B.NetEarning,A.GrossBAEarning = B.GrossEarning,  A.GrossPiece = B.GrossPiece, A.GrossSales = B.Gross, A.NetPiece = B.NetPiece FROM #ReportDate A INNER JOIN(
SELECT B.Client as 'Campaign',SUM(CASE WHEN Status in ('SubmissionDate','ReSubmissionDate','ClientResubmissionDate') THEN PackageValue ELSE 0 END) as 'Gross',
SUM(CASE WHEN Status in ('SubmissionDate','ReSubmissionDate','ClientResubmissionDate') THEN 1 ELSE -1 END) as 'NetPiece' ,
SUM(CASE WHEN Status in ('SubmissionDate') THEN 1 ELSE 0 END) as 'GrossPiece' ,
--SUM(CASE WHEN Status in ('AgencyApproved') THEN AgencyInvoiceValue ELSE 0 END) as 'GrossEarning' ,
@SuccessfulEarning + @UnSuccessfulEarning as 'GrossEarning' ,
--SUM(CASE WHEN Status in ('AgencyApproved') THEN AgencyInvoiceValue WHEN status in ('AgencyReject') THEN AgencyInvoiceValue * -1.00 ELSE 0 END) as 'NetEarning' ,
@SuccessfulEarning as 'NetEarning',
SUM(CASE WHEN Status in ('ReSubmissionDate','ClientResubmissionDate') THEN 1 ELSE 0 END) as 'ResubPiece' ,
SUM(CASE WHEN Status in ('AgencyReject') THEN 1 ELSE 0 END) as 'RejectPiece' FROM NewIndiaDB_PROD..VW_CH_SS A 
LEFT JOIN NewIndiaDB_PROD..VW_MST_CampaignList B ON A.Client = B.ID
WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeNo,'') <> '' and Status in ('AgencyReject','AgencyApproved','SubmissionDate','ReSubmissionDate','ClientResubmissionDate','RejectDate','ClientRejectDate')
and IsDeleted = 0
GROUP BY B.Client 
) B ON A.Country = 'India' and A.Division = 'Charity' and A.Customer = B.Campaign

UPDATE A SET A.GrossPiece = (B.SuccessFul + B.Unsuccessful), A.GrossPieceOT = 0, A.RejectPiece = B.Unsuccessful, A.RejectPieceOT = 0, 
A.ResubPiece = 0, A.ResubPieceOT = 0, A.ResubPieceRec = 0, A.NetPiece = B.SuccessFul FROM #ReportDate A LEFT JOIN #IndiaLead B ON A.Weekending = B.WeDate
WHERE A.Country = 'India' and A.Division = 'Charity'

--SELECT B.Client as 'Campaign',SUM(CASE WHEN Status in ('SubmissionDate','ReSubmissionDate','ClientResubmissionDate') THEN AgencyInvoiceValue ELSE 0 END) as 'Gross',
--SUM(CASE WHEN Status in ('SubmissionDate','ReSubmissionDate','ClientResubmissionDate') THEN 1 ELSE -1 END) as 'NetPiece' ,
--SUM(CASE WHEN Status in ('SubmissionDate') THEN 1 ELSE 0 END) as 'GrossPiece' ,
--SUM(CASE WHEN Status in ('ReSubmissionDate','ClientResubmissionDate') THEN 1 ELSE 0 END) as 'ResubPiece' ,
--SUM(CASE WHEN Status not in ('SubmissionDate','ReSubmissionDate','ClientResubmissionDate') THEN 1 ELSE 0 END) as 'RejectPiece' FROM NewIndiaDB_PROD..VW_CH_SS A 
--LEFT JOIN NewIndiaDB_PROD..VW_MST_CampaignList B ON A.Client = B.ID
--WHERE StatusWEDate = @CountryWeDate 
--and ISNULL(BadgeNo,'') <> '' and Status in ('SubmissionDate','ReSubmissionDate','ClientResubmissionDate','RejectDate','ClientRejectDate')
--and IsDeleted = 0
--GROUP BY B.Client 

--RETURN

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


INSERT INTO #DailySHC
SELECT distinct   'Taiwan' as 'Country', 'Charity',  B.Campaign as 'Customer', StatusDate, COUNT(distinct BadgeID)  FROM  
NewTWDB_PROD..VW_CH_SS A LEFT JOIN NewTWDB_PROD..VW_CampaignList B ON A.Client = B.ClientCode  WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeID,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0  GROUP BY  B.Campaign, StatusDate
ORDER BY  B.Campaign, StatusDate
 


INSERT INTO #ReportDate (Country, Division, Customer, CampaignID, Weekending, RMonth, RQuarter, CountryUSHC, USCH)
SELECT 'Taiwan' as 'Country', A.Division, B.Campaign as 'Customer', B.ID, @CountryWeDate as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter', @UniqueSCH as 'CountryUniqueSHC', 0  FROM (
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
   + CASE WHEN CTXN.Age < 26 THEN 'Y' ELSE '' END AS PackageName          
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
       
UPDATE A SET  A.GrossPieceOT = B.GrossPieceOT ,A.RejectPiece = B.RejectPiece,A.RejectPieceOT = B.RejectPieceOT,A.RejectPieceRec = B.RejectPieceREC, A.ResubPiece = B.ResubPiece, A.ResubPieceOT = B.ResubPieceOT, A.ResubPieceRec = B.ResubPieceREC, A.GrossPiece = B.GrossPiece, 
A.GrossSales = B.Gross, A.GrossBAEarning = B.Gross, A.NetBAEarning = B.NetSales ,A.NetPiece = B.NetPiece FROM #ReportDate A INNER JOIN(
 SELECT Campaign, COUNT(Distinct BadgeID) as 'BadgeNo',  
 SUM(CASE WHEN Type = '0SUBMISSION' and Frequency> 0 THEN 1 ELSE 0 END) as 'GrossPiece',
 SUM(CASE WHEN Type = '0SUBMISSION' and Frequency = 0 THEN 1 ELSE 0 END) as 'GrossPieceOT' ,
 SUM(CASE WHEN Type IN ( '0SUBMISSION') THEN Commission ELSE 0 END) as 'Gross' ,
 SUM(CASE WHEN Type IN ( '2CLIENTREJECT','1APPCOREJECT')   THEN Commission * -1 ELSE Commission END) as 'NetSales' ,
 SUM(CASE WHEN Type IN ( '2CLIENTREJECT','1APPCOREJECT')   THEN 1 ELSE 0 END) as 'RejectPiece' ,
 SUM(CASE WHEN Type IN ( '2CLIENTREJECT','1APPCOREJECT')  and Frequency = 0  THEN 1 ELSE 0 END) as 'RejectPieceOT' ,
 SUM(CASE WHEN Type IN ( '2CLIENTREJECT','1APPCOREJECT')  and Frequency > 0 THEN 1 ELSE 0 END) as 'RejectPieceREC' ,
 SUM(CASE WHEN Type IN ( '2CLIENTREJECT','1APPCOREJECT')   THEN -1 ELSE 1 END) as 'NetPiece' ,
 SUM(CASE WHEN Type IN ( '3APPCORESUB','4CLIENTRESUB')   THEN 1 ELSE 0 END) as 'ResubPiece',
 SUM(CASE WHEN Type IN ( '3APPCORESUB','4CLIENTRESUB') and Frequency = 0  THEN 1 ELSE 0 END) as 'ResubPieceOT',
 SUM(CASE WHEN Type IN ( '3APPCORESUB','4CLIENTRESUB') and Frequency > 0  THEN 1 ELSE 0 END) as 'ResubPieceREC'  FROM #ICETable 
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

INSERT INTO #DailySHC
SELECT distinct   'Hong Kong' as 'Country', 'Charity', CampaignCode as 'Customer', StatusDate, COUNT(distinct BadgeNo)  FROM  NewHKDB_PROD..Txn_Transaction_StatusSummary WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeNo,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0  GROUP BY CampaignCode, StatusDate
ORDER BY CampaignCode, StatusDate
  

SELECT @UniqueSCH = COUNT(Distinct BadgeNo) FROM (
SELECT distinct BadgeNo as 'BadgeNo'  FROM  NewHKDB_PROD..Txn_Transaction_StatusSummary WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeNo,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0   and IsDeleted = 0  
UNION ALL
SELECT DISTINCT BADGEID  as 'BadgeNo'  FROM Appco360_PROD..[Txn_SalesImport] A where A.Country = 'HK' and ISNULL(A.SignUpPieces,0)  > 0 and A.Campaign in ('Viospace','Home Cuisine') and A.IsDeleted = 0 and A.WEDate = @CountryWeDate
) A

INSERT INTO #ReportDate (Country, Division, Customer, CampaignID, Weekending, RMonth, RQuarter, CountryUSHC, USCH)
SELECT 'Hong Kong' as 'Country', A.Division, A.Campaign as 'Customer', ID, @CountryWeDate as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter', @UniqueSCH as 'CountryUniqueSHC',  A.BadgeNo as 'UniqueSHC' FROM (
SELECT CampaignCode as 'Campaign', 'Charity' as Division, B.ID, COUNT( distinct IIF(Status = 'SubmissionDate', BadgeNo, NULL)) as 'BadgeNo'  
FROM NewHKDB_PROD..Txn_Transaction_StatusSummary  A LEFT JOIN NewHKDB_PROD..VW_MST_CampaignList B ON A.CampaignCode = B.Client
WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeNo,'') <> '' and Status IN ('SubmissionDate','RejectDate','RsubmissionDate')  and IsDeleted = 0
GROUP BY CampaignCode, B.ID 
) A  

UPDATE A SET A.GrossPieceOT = B.GrossPieceOT, A.ResubPiece = B.ResubPiece, A.ResubPieceOT = B.ResubPieceOT, A.ResubPieceREC = B.ResubPieceREC, 
A.RejectPiece = B.RejectPiece, A.RejectPieceOT = B.RejectPieceOT, A.RejectPieceREC = B.RejectPieceREC,  A.GrossPiece = B.GrossPiece, A.GrossSales = B.Gross, 
A.GrossBAEarning = B.GrossBAEarning, A.NetBAEarning = B.NetBAEarning, A.NetPiece = B.NetPiece FROM #ReportDate A INNER JOIN(
SELECT CampaignCode as 'Campaign',SUM(CASE WHEN Status in ('SubmissionDate','ReSubmissionDate') THEN A.PackageValue ELSE 0 END) as 'Gross',
SUM(CASE WHEN Status in ('SubmissionDate','ReSubmissionDate' ) THEN A.PackageValue ELSE A.PackageValue * -1 END) as 'NetSales',
SUM(CASE WHEN Status in ('SubmissionDate','ReSubmissionDate' ) THEN 1 ELSE -1 END) as 'NetPiece',
SUM(CASE WHEN Status in ('SubmissionDate') THEN Case WHEN B.Frequency > 0 THEN 1 ELSE 0 END ELSE 0 END) as 'GrossPiece' ,
SUM(CASE WHEN Status in ('SubmissionDate') THEN Case WHEN B.Frequency = 0 THEN 1 ELSE 0 END ELSE 0 END) as 'GrossPieceOT' ,
SUM(CASE WHEN Status in ('ReSubmissionDate') THEN 1 ELSE 0 END) as 'ResubPiece' ,
SUM(CASE WHEN Status in ('ReSubmissionDate') and Frequency = 0 THEN 1 ELSE 0 END) as 'ResubPieceOT' ,
SUM(CASE WHEN Status in ('ReSubmissionDate') and Frequency > 0 THEN 1 ELSE 0 END) as 'ResubPieceREC' ,
SUM(CASE WHEN Status not in ('SubmissionDate','ReSubmissionDate') THEN 1 ELSE 0 END) as 'RejectPiece',
SUM(CASE WHEN Status not in ('SubmissionDate','ReSubmissionDate') and Frequency = 0 THEN 1 ELSE 0 END) as 'RejectPieceOT',
SUM(CASE WHEN Status not in ('SubmissionDate','ReSubmissionDate') and Frequency > 0 THEN 1 ELSE 0 END) as 'RejectPieceREC',
--SUM(CAST(CASE WHEN Status in ('SubmissionDate','ReSubmissionDate' ) THEN A.ICStrokePoints * 250.00 ELSE 0 END  as decimal(18,2))) as 'GrossBAEarning', -- MSF model rollout point will convert into comm will stamp in strokevalue
--SUM(CAST(CASE WHEN Status in ('SubmissionDate','ReSubmissionDate' ) THEN A.ICStrokePoints * 250.00 ELSE A.ICStrokePoints * 250.00 * -1 END as decimal(18,2)))  as 'NetBAEarning'
SUM(CAST(CASE WHEN Status in ('SubmissionDate','ReSubmissionDate' ) THEN A.ICStrokeValue ELSE 0 END  as decimal(18,2))) as 'GrossBAEarning',
SUM(CAST(CASE WHEN Status in ('SubmissionDate','ReSubmissionDate' ) THEN A.ICStrokeValue ELSE A.ICStrokeValue * -1 END as decimal(18,2)))  as 'NetBAEarning'
FROM NewHKDB_PROD..Txn_Transaction_StatusSummary A
LEFT JOIN NewHKDB_PROD..Mst_Ch_Package B ON A.PackageId = B.PackageId
WHERE StatusWEDate = @CountryWeDate --and A.MOCode NOT in ('HQHK')
and ISNULL(BadgeNo,'') <> '' and (Status in ('SubmissionDate','ReSubmissionDate','RejectDate'))
and A.IsDeleted = 0
GROUP BY   CampaignCode
) B ON A.Country = 'Hong Kong' and A.Division = 'Charity' and A.Customer = B.Campaign
 
INSERT INTO #ReportDate (Country, Division, Customer, CampaignID, Weekending, RMonth, RQuarter, CountryUSHC, USCH)
SELECT 'Hong Kong' as 'Country', A.Division, A.Campaign as 'Customer', ID, @CountryWeDate as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter', @UniqueSCH as 'CountryUniqueSHC',  A.BadgeNo as 'UniqueSHC' FROM (
SELECT 'Hong Kong' as 'Country','Commercial' as 'Division' , A.Campaign, B.ID ,SUM( CASE WHEN ISNULL(SignUpPieces,0) > 0 THEN 1 ELSE 0 END) as 'BadgeNo'  
FROM Appco360_PROD..Txn_SalesImport A LEFT JOIn NewHKDB_PROD..VW_MST_CampaignList B ON A.Campaign = B.Client
where A.Country = 'HK' --and A.SignUpPieces > 0 and --A.Campaign in ('Viospace','Home Cuisine') and 
and IsDeleted = 0 and WEDate = @CountryWeDate

 
GROUP BY A.Campaign, B.ID
) A  
 

UPDATE A SET A.GrossPiece = B.Gross, A.GrossPieceOT = 0, A.RejectPiece = B.RejectPieces, A.RejectPieceOT = 0, A.RejectPieceREC = B.RejectPieces, A.ResubPiece = B.ResubPieces, A.ResubPieceOT = 0, A.ResubPieceREC = B.ResubPieces,
A.NetPiece = B.Net, A.GrossSales = B.GrossEarning, A.GrossBAEarning = B.GrossEarning, A.NetBAEarning = B.NetEarning  FROM #ReportDate A INNER JOIN 
 (SELECT 'Hong Kong' as  Country, Campaign, SUM(Signuppieces) as 'Gross', 0 as 'OT',SUM(RejectPieces) as 'RejectPieces', SUM(ResubPieces) as 'ResubPieces', SUM(Signuppieces) + SUM(ResubPieces) - SUM(RejectPieces)  as 'Net',
 SUM(ISNULL(Totalearning,0.00)) as 'GrossEarning', SUM(ISNULL(NetEarning,0.00) + ISNULL(BOND,0.00)) as 'NetEarning'  FROM Appco360_PROD..[Txn_SalesImport]
 where Country = 'HK' and WEDate = @CountryWeDate and IsDeleted = 0 --AND SignUpPieces > 0
 GROUP BY Country, Campaign) B ON A.Country = B.Country  COLLATE Latin1_General_CI_AS  and A.Customer = B.Campaign COLLATE Latin1_General_CI_AS 
 WHERE A.Country = 'Hong Kong' and A.Division = 'Commercial' 

SET @UniqueDiv2 = (SELECT COUNT(distinct BadgeNo)  FROM  NewHKDB_PROD..Txn_Transaction_StatusSummary WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeNo,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0   and IsDeleted = 0  )
UPDATE #ReportDate SET DivUSCH = @UniqueDiv2 where Country = 'Hong Kong' and Division = 'Charity' 
 
SET @UniqueDiv1 = (SELECT COUNT(DISTINCT BadgeID) FROM  Appco360_PROD..[Txn_SalesImport] WHERE Country = 'HK' and WEDate = @CountryWeDate and IsDeleted = 0 and SignUpPieces > 0 and Campaign in ('Viospace','Home Cuisine'))
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

INSERT INTO #DailySHC
SELECT distinct   'Thailand' as 'Country', 'Charity', CampaignCode as 'Customer', StatusDate, COUNT(distinct BadgeNo)  FROM  NewTHDB_PROD..Txn_Transaction_StatusSummary
WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeNo,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0  GROUP BY CampaignCode, StatusDate
ORDER BY CampaignCode, StatusDate
 

 INSERT INTO #DailySHC

 select 'Thailand' as 'Country', CASE WHEN d.Division = 'CO' THEN 'Commercial' ELSE d.Division END 'Division',  A.CampaignCode, A.MoSubmissionDate, COUNT(distinct A.BadgeNo)  from NewTHDB_PROD..Txn_Transaction a
inner join NewTHDB_PROD..Txn_Co_CampaignTransaction b on b.TxnId = a.TxnId and b.IsDeleted = 0
INNER JOIN NewTHDB_PROD..Mst_BARelationship R ON R.BadgeNo = A.BadgeNo AND R.WEDate = A.MoSubmissionWEDate AND R.CurrentLevel NOT IN ('O','BM')
inner join NewTHDB_PROD..VW_MST_CampaignList d on d.ID = b.CampaignId
where a.IsDeleted = 0 and MoSubmissionWEDate =@CountryWeDate  
GROUP BY CASE WHEN d.Division = 'CO' THEN 'Commercial' ELSE d.Division END,A.CampaignCode, A.MoSubmissionDate


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

INSERT INTO #ReportDate (Country, Division, Customer, CampaignID, Weekending, RMonth, RQuarter, CountryUSHC, DivUSCH, USCH)
SELECT 'Thailand' as 'Country', A.Division, A.Campaign as 'Customer', ID,  @CountryWeDate as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter', @UniqueSCH as 'CountryUniqueSHC', A.DivisionUSHC,  A.BadgeNo as 'UniqueSHC' FROM (
SELECT CampaignCode as 'Campaign', 'Charity' as Division, B.ID, COUNT( distinct IIF(Status = 'SubmissionDate', BadgeNo, NULL)) as 'BadgeNo', @UniqueSCH_Charity as 'DivisionUSHC'  
	FROM NewTHDB_PROD..Txn_Transaction_StatusSummary A  
	LEFT JOIN NewTHDB_PROD..VW_MST_CampaignList B ON A.CampaignCode = B.client WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeNo,'') <> '' and Status IN ('SubmissionDate','RejectDate','ClientRejectDate','ResubmissionDate','ClientResubmissionDate') and IsDeleted = 0
 
GROUP BY CampaignCode, B.ID 
UNION ALL
select d.Client as 'Campaign', CASE WHEN d.Division = 'CO' THEN 'Commercial' ELSE d.Division END 'Division', D.id, COUNT( distinct a.BadgeNO) as 'BadgeNo', @UniqueSCH_Commercial as 'DivisionUSHC' 
from NewTHDB_PROD..Txn_Transaction a
inner join NewTHDB_PROD..Txn_Co_CampaignTransaction b on b.TxnId = a.TxnId and b.IsDeleted = 0
--inner join NewTHDB_PROD..Txn_Co_Campaign_Product c on c.TxnId = a.TxnId and c.IsDeleted = 0
inner join NewTHDB_PROD..VW_MST_CampaignList d on d.ID = b.CampaignId
where a.IsDeleted = 0 and MoSubmissionWEDate = @CountryWeDate
and mocode = 'CA'
GROUP BY  d.Client, d.Division , D.id
) A  


 



UPDATE A SET A.GrossPieceOT = B.GrossPieceOT, A.ResubPiece = B.ResubPiece, A.ResubPieceOT = B.ResubPieceOT, A.ResubPieceREC = B.ResubPieceREC, A.RejectPiece = B.RejectPiece, A.RejectPieceOT = B.RejectPieceOT, A.RejectPieceREC = B.RejectPieceREC, A.GrossSales = B.Gross, A.GrossBAEarning = B.Gross, 
A.NetBAEarning = B.NetSales, A.NetPiece = B.NetPiece, A.GrossPiece = B.GrossPiece FROM #ReportDate A INNER JOIN(
SELECT A.CampaignCode as 'Campaign',
SUM(CASE WHEN A.TypeSub in ('SUBMISSION','RESUB') THEN A.Commission ELSE 0 END) as 'Gross',
SUM(CASE WHEN A.TypeSub in ('SUBMISSION','RESUB') THEN A.Commission
		 WHEN A.TypeSub in ('REJECT') THEN A.Commission END) as 'NetSales',
SUM(CASE WHEN A.TypeSub in ('SUBMISSION','RESUB') THEN 1 
		 WHEN A.TypeSub in ('REJECT') THEN -1 END) as 'NetPiece',
SUM(CASE WHEN A.TypeSub in ('SUBMISSION') THEN Case WHEN A.Frequency > 0 THEN 1 ELSE 0 END ELSE 0 END) as 'GrossPiece' ,
SUM(CASE WHEN A.TypeSub in ('SUBMISSION') THEN Case WHEN A.Frequency = 0 THEN 1 ELSE 0 END ELSE 0 END) as 'GrossPieceOT' ,
SUM(CASE WHEN A.TypeSub in ('RESUB') THEN 1 ELSE 0 END) as 'ResubPiece' ,
SUM(CASE WHEN A.TypeSub in ('RESUB') and A.Frequency > 0 THEN 1 ELSE 0 END) as 'ResubPieceREC' ,
SUM(CASE WHEN A.TypeSub in ('RESUB') and A.Frequency = 0 THEN 1 ELSE 0 END) as 'ResubPieceOT' ,
SUM(CASE WHEN A.TypeSub in ('REJECT') THEN 1 ELSE 0 END) as 'RejectPiece',
SUM(CASE WHEN A.TypeSub in ('REJECT') and A.Frequency > 0 THEN 1 ELSE 0 END) as 'RejectPieceREC',
SUM(CASE WHEN A.TypeSub in ('REJECT') and A.Frequency = 0 THEN 1 ELSE 0 END) as 'RejectPieceOT'
FROM NewTHDB_PROD..Txn_PiecesHistory A
WHERE StatusWEDate = @CountryWeDate 
and ISNULL(A.BadgeNo,'') <> ''  
and A.TypeSub in ('SUBMISSION','REJECT','RESUB')
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


UPDATE A SET A.GrossSales = B.Gross, A.GrossBAEarning = B.Gross, A.NetBAEarning = B.Gross FROM #ReportDate A INNER JOIN(
select CampaignCode as 'Campaign', SUM(c.ICStrokeValue) as 'Gross' from 
NewTHDB_PROD..Txn_Transaction a 
inner join NewTHDB_PROD..Txn_Co_CampaignTransaction b on b.TxnId = a.TxnId and b.IsDeleted = 0
inner join NewTHDB_PROD..Txn_Co_Campaign_Product c on c.TxnId = a.TxnId and c.IsDeleted = 0 and ParentCampaignProductId IS NULL
where a.MoSubmissionWEDate = @CountryWeDate  
 GROUP BY CampaignCode
) B ON A.Country = 'Thailand' and A.Division in ('Commercial', 'CSR') and A.Customer = B.Campaign

END
-- =================================================== THAILAND (END)=========================================================================
-- ===========================================================================================================================================
 

-- =================================================== KOREA(START)===========================================================================
-- ===========================================================================================================================================

INSERT INTO #DailySHC
SELECT 'Korea','Charity', A.Campaign, A.MOSubDate, COUNT(DISTINCT FRID) from Appco360_PROD..Maintable A
LEFT JOIN NewOlaf_Prod..Mst_Campaign B ON B.CountryCode = 'KR' and A.Campaign = B.CampaignName collate SQL_Latin1_General_CP1_CI_AS
WHERE MOSubWE = @weDate and OfficeID <> 'HQ'  and PaidAmount > 0  and SubType is null
GROUP BY A.Campaign, B.CampaignId, A.MOSubDate
 

SELECT @UniqueSCH = (SELECT COUNT(Distinct FRID) from Appco360_PROD..Maintable WHERE MOSubWE = @weDate and SubType is null)

--Insert Scoring headcount & Gross Sales
INSERT INTO #ReportDate (Country, Division, Customer, CampaignID, Weekending, RMonth, RQuarter, CountryUSHC, USCH, GrossSales, GrossBAEarning)
SELECT   'Korea' as 'Country', 'Charity' as Division, A.Campaign, B.CampaignId, @weDate, @Month, @Quarter, @UniqueSCH, COUNT(Distinct FRID), 
SUM(ISNULL(A.Amount,0.00)),
SUM(ISNULL(A.FRStroke,0.00 )) + SUM(ISNULL(A.AdditionalFRStroke,0.00 ))
from Appco360_PROD..Maintable  A 
LEFT JOIN NewOlaf_Prod..Mst_Campaign B ON B.CountryCode = 'KR' and A.Campaign = B.CampaignName collate SQL_Latin1_General_CP1_CI_AS
WHERE MOSubWE = @weDate and OfficeID <> 'HQ'  and PaidAmount > 0 --and TimesSubmitted = 1
GROUP BY A.Campaign, B.CampaignId
 
INSERT INTO #ReportDate (Country, Division, Customer, CampaignID, Weekending, RMonth, RQuarter, CountryUSHC, USCH, GrossSales)
SELECT   'Korea' as 'Country', 'Charity' as Division, A.Campaign, C.CampaignId, @weDate, @Month, @Quarter, @UniqueSCH, 0, 0   
from Appco360_PROD..Maintable A 
LEFT JOIN #ReportDate B ON B.Country = 'Korea' and B.Division = 'Charity' and B.Customer COLLATE Latin1_General_CI_AS = A.Campaign 
LEFT JOIN NewOlaf_Prod..Mst_Campaign C ON C.CountryCode = 'KR' and A.Campaign = C.CampaignName collate SQL_Latin1_General_CP1_CI_AS 
WHERE MOSubWE = @weDate and SubType is not null and B.Customer is null
GROUP BY A.Campaign, C.CampaignId



INSERT INTO #ReportDate (Country, Division, Customer, CampaignID, Weekending, RMonth, RQuarter, CountryUSHC, USCH, GrossSales, GrossBAEarning)
SELECT   'Korea' as 'Country', 'Charity' as Division, A.Campaign, B.CampaignId, @weDate, @Month, @Quarter, 0, 0, 
0,0
from Appco360_PROD..Maintable  A 
LEFT JOIN NewOlaf_Prod..Mst_Campaign B ON B.CountryCode = 'KR' and A.Campaign = B.CampaignName collate SQL_Latin1_General_CP1_CI_AS
WHERE MORejectWE = @weDate  and OfficeID <> 'HQ'  and PaidAmount > 0 and A.Campaign collate SQL_Latin1_General_CP1_CI_AS NOT IN (
SELECT Customer collate SQL_Latin1_General_CP1_CI_AS from #ReportDate WHERE country = 'Korea'
)
GROUP BY A.Campaign, B.CampaignId

 
UPDATE A SET A.NetBAEarning = ISNULL(A.GrossBAEarning,0.00) - ISNULL(FRStroke,0.00) FROM #ReportDate A  LEFT JOIN (
 SELECT CampaignId, SUM(ISNULL(A.FRStroke,0.00 )) + SUM(ISNULL(A.AdditionalFRStroke,0.00 )) FRStroke
from Appco360_PROD..Maintable  A LEFT JOIN NewOlaf_Prod..Mst_Campaign B ON B.CountryCode = 'KR' and A.Campaign = B.CampaignName collate SQL_Latin1_General_CP1_CI_AS 
WHERE MORejectWE = @weDate  and OfficeID <> 'HQ'  and PaidAmount > 0 
 GROUP BY Campaign, B.CampaignId 
 ) B ON A.CampaignID = B.CampaignID
 WHERE A.Country = 'Korea'
  
-- Calculate Net Piece
SELECT distinct A.Campaign,'Charity' as Division,  0 as 'NetPiece', 0 as 'GrossPiece', 0 as 'GrossPieceOT', 0 as 'RejectPiece', 0 as 'ResubPiece', 0 as 'RejectPieceOT', 0 as 'RejectPieceREC', 0 as 'ResubPieceOT', 0 as 'ResubPieceREC' INTO #TempKoreaNet from Appco360_PROD..Maintable A 
WHERE MOSubWE = @weDate   OR  MORejectWE = @weDate

UPDATE A SET A.GrossPiece = B.Sub,  A.NetPiece = B.Sub FROM #TempKoreaNet A INNER JOIN 
(SELECT   Campaign,'Charity' as Division,COUNT(*) as 'Sub' from Appco360_PROD..Maintable WHERE MOSubWE = @weDate and Frequency = 1 and SubType is null
 and PaidAmount <> 0
GROUP BY Campaign
) B ON A.Campaign = B.Campaign

UPDATE A SET A.GrossPieceOT = B.Sub,  A.NetPiece = A.NetPiece + B.Sub FROM #TempKoreaNet A INNER JOIN 
(SELECT   Campaign,'Charity' as Division,COUNT(*) as 'Sub' from Appco360_PROD..Maintable WHERE MOSubWE = @weDate and Frequency = 0  and SubType is null
   and PaidAmount <> 0
GROUP BY Campaign
) B ON A.Campaign = B.Campaign
 
 
UPDATE A SET A.ResubPiece = B.Sub,  A.NetPiece = A.NetPiece + B.Sub FROM #TempKoreaNet A INNER JOIN 
(SELECT   Campaign,'Charity' as Division,COUNT(*) as 'Sub' from Appco360_PROD..Maintable WHERE MOSubWE = @weDate and SubType in ('APPCORESUB','CLIENTRESUB')
  and PaidAmount <> 0
GROUP BY Campaign
) B ON A.Campaign = B.Campaign

 
UPDATE A SET A.ResubPieceOT = B.Sub FROM #TempKoreaNet A INNER JOIN 
(SELECT   Campaign,'Charity' as Division,COUNT(*) as 'Sub' from Appco360_PROD..Maintable WHERE MOSubWE = @weDate and SubType in ('APPCORESUB','CLIENTRESUB')
  and PaidAmount <> 0 AND Frequency = 0
GROUP BY Campaign
) B ON A.Campaign = B.Campaign

UPDATE A SET A.ResubPieceREC = B.Sub FROM #TempKoreaNet A INNER JOIN 
(SELECT   Campaign,'Charity' as Division,COUNT(*) as 'Sub' from Appco360_PROD..Maintable WHERE MOSubWE = @weDate and SubType in ('APPCORESUB','CLIENTRESUB')
  and PaidAmount <> 0 AND Frequency > 0
GROUP BY Campaign
) B ON A.Campaign = B.Campaign

 
UPDATE A SET A.RejectPiece = B.Rej,  A.NetPiece = A.NetPiece - B.Rej FROM #TempKoreaNet A INNER JOIN 
(SELECT   Campaign,'Charity' as Division,COUNT(*) as 'Rej' from Appco360_PROD..Maintable WHERE MORejectWE = @weDate-- and FRStroke <> 0
  and PaidAmount <> 0
GROUP BY Campaign
) B ON A.Campaign = B.Campaign

UPDATE A SET A.RejectPieceOT = B.Rej FROM #TempKoreaNet A INNER JOIN 
(SELECT   Campaign,'Charity' as Division,COUNT(*) as 'Rej' from Appco360_PROD..Maintable WHERE MORejectWE = @weDate-- and FRStroke <> 0
  and PaidAmount <> 0 AND Frequency = 0
GROUP BY Campaign
) B ON A.Campaign = B.Campaign
 
UPDATE A SET A.RejectPieceREC = B.Rej FROM #TempKoreaNet A INNER JOIN 
(SELECT   Campaign,'Charity' as Division,COUNT(*) as 'Rej' from Appco360_PROD..Maintable WHERE MORejectWE = @weDate-- and FRStroke <> 0
  and PaidAmount <> 0 AND Frequency > 0
GROUP BY Campaign
) B ON A.Campaign = B.Campaign

UPDATE a set a.RejectPiece = B.RejectPiece,a.RejectPieceOT = B.RejectPieceOT,  a.RejectPieceREC = B.RejectPieceREC, a.ResubPiece = B.ResubPiece, a.ResubPieceOT = B.ResubPieceOT, a.ResubPieceRec = B.ResubPieceREC, a.GrossPieceOT =B.GrossPieceOT, a.GrossPiece = B.GrossPiece, a.NetPiece = B.NetPiece FROM #ReportDate a INNER JOIN #TempKoreaNet B ON A.Customer = B.Campaign collate Latin1_General_CI_AI  WHERE Country = 'Korea'
 
UPDATE A SET A.USCH = B.CT FROM #ReportDate A INNER JOIN (
 SELECT  A.Campaign, COUNT(Distinct FRID) 'CT'
from Appco360_PROD..Maintable  A 
LEFT JOIN NewOlaf_Prod..Mst_Campaign B ON B.CountryCode = 'KR' and A.Campaign = B.CampaignName collate SQL_Latin1_General_CP1_CI_AS
WHERE MOSubWE = @weDate and OfficeID <> 'HQ'  and PaidAmount > 0 and A.SubType is null
GROUP BY A.Campaign ) B ON A.Customer = B.Campaign  collate Latin1_General_CI_AI
WHERE A.Country = 'Korea'
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


-- =================================================== UPDATE ALL COUNTRY Leaver (START)==================================================
-- ===========================================================================================================================================
UPDATE A SET A.Leaver = ISNULL( B.Leaver,0) FROM #ReportDate A LEFT JOIN
(
SELECT Case WHEN  B.CountryCode = 'TH' THEN 'Thailand' WHEN B.CountryCode = 'KR' THEN 'Korea' WHEN B.CountryCode = 'SG' THEN 'Singapore' WHEN B.CountryCode = 'IN' THEN 'India'   WHEN B.CountryCode = 'PH' THEN 'Philippines'  WHEN B.CountryCode = 'TW' THEN 'Taiwan'  WHEN B.CountryCode = 'HK' THEN 'Hong Kong' WHEN B.CountryCode = 'MY' THEN 'Malaysia' ELSE '' END as 'Country', COUNT(*) as 'Leaver' FROM NewOlaf_Prod..Mst_IndependentContractor A LEFT JOIN NewOlaf_Prod..Mst_MarketingCompany B ON A.MarketingCompanyId = B.MarketingCompanyId
where LastDeactivateDate >= @weFromDate and LastDeactivateDate <=@weToDate and a.IsDeleted = 0
GROUP BY Case WHEN  B.CountryCode = 'TH' THEN 'Thailand' WHEN B.CountryCode = 'KR' THEN 'Korea' WHEN B.CountryCode = 'SG' THEN 'Singapore' WHEN B.CountryCode = 'IN' THEN 'India'   WHEN B.CountryCode = 'PH' THEN 'Philippines'  WHEN B.CountryCode = 'TW' THEN 'Taiwan'  WHEN B.CountryCode = 'HK' THEN 'Hong Kong' WHEN B.CountryCode = 'MY' THEN 'Malaysia' ELSE '' END 
 ) B ON A.Country = B.Country 
-- =================================================== UPDATE ALL COUNTRY Leaver (END  )==================================================
-- ===========================================================================================================================================

DROP TABLE IF EXISTS #Mst_IndependentContractor
SELECT CAST(B.CountryCode as NVARCHAR(50)) as 'Country', A.IndependentContractorId, A.BadgeNo, A.LastDeactivateDate INTO #Mst_IndependentContractor FROM Mst_IndependentContractor A 
LEFT JOIN Mst_MarketingCompany B ON A.MarketingCompanyId = B.MarketingCompanyId
where IndependentContractorId not in (SELECT IndependentContractorId FROM Mst_IndependentContractor where  LastDeactivateDate is null and status = 'Inactive')
and 
IndependentContractorId not in (SELECT IndependentContractorId FROM Mst_IndependentContractor where StartDate > @weToDate)
and A.IsDeleted = 0 and B.IsDeleted = 0
AND B.Code not in ('HQ')
 
 
UPDATE #Mst_IndependentContractor SET Country = 'Hong Kong' where country = 'HK'
UPDATE #Mst_IndependentContractor SET Country = 'Korea' where country = 'KR'
UPDATE #Mst_IndependentContractor SET Country = 'Malaysia' where country = 'MY'
UPDATE #Mst_IndependentContractor SET Country = 'Philippines' where country = 'PH'
UPDATE #Mst_IndependentContractor SET Country = 'Singapore' where country = 'SG'
UPDATE #Mst_IndependentContractor SET Country = 'Thailand' where country = 'TH'
UPDATE #Mst_IndependentContractor SET Country = 'Taiwan' where country = 'TW'
UPDATE #Mst_IndependentContractor SET Country = 'India' where country = 'IN'
UPDATE #Mst_IndependentContractor SET Country = 'Indonesia' where country = 'ID'
 
DELETE FROM #Mst_IndependentContractor WHERE ISNULL(LastDeactivateDate,'3000-01-01') < @weFromDate

DROP TABLE IF EXISTS #TempHCDetail
SELECT A.Country, B.CampaignId, A.IndependentContractorId, A.BadgeNo,  D.DivisionName  INTO #TempHCDetail FROM #Mst_IndependentContractor A
LEFT JOIN Mst_IndependentContractor_Assignment B ON A.IndependentContractorId = B.IndependentContractorId 
and B.IsDeleted = 0 and ISNULL(B.EndDate,'4000-01-01') >= @weFromDate and B.StartDate < @weToDate
LEFT JOIN Mst_Campaign C ON B.CampaignId = C.CampaignId
LEFT JOIN Mst_Division D ON C.DivisionId = D.DivisionId
WHERE B.CampaignId is not null
 
 UPDATE #TempHCDetail SET DivisionName = 'Commercial' WHERE DivisionName = 'TELCO'
 
-- Update county Level HC
UPDATE A SET A.CountryHC = B.HC FROM #ReportDate A 
INNER JOIN (SELECT Country, count(distinct BadgeNo) HC FROM #Mst_IndependentContractor   GROUP BY Country)
B ON A.Country = B.Country

UPDATE A SET A.CountryDivHC = B.HC FROM #ReportDate A 
INNER JOIN (SELECT Country, DivisionName, count(distinct BadgeNo) HC FROM #TempHCDetail   GROUP BY Country, DivisionName)
B ON A.Country = B.Country and A.Division =B.DivisionName

UPDATE A SET A.CountryCampaignHC = B.HC FROM #ReportDate A 
INNER JOIN (SELECT Country, CampaignId, count(distinct BadgeNo) HC FROM #TempHCDetail   GROUP BY Country, CampaignId)
B ON A.Country = B.Country and A.CampaignId =B.CampaignId

--SELECT A.Country , B.Country, A.CampaignId ,B.CampaignId, A.*
-- FROM #ReportDate A 
--LEFT JOIN (SELECT Country, CampaignId, count(distinct BadgeNo) HC FROM #TempHCDetail   GROUP BY Country, CampaignId)
--B ON A.Country = B.Country and A.CampaignId =B.CampaignId
--where A.Country = 'India'


--SELECT Country, CampaignId, count(distinct BadgeNo) HC FROM #TempHCDetail   GROUP BY Country, CampaignId
--return
--SELECT * FROM #ReportDate A 
--LEFT JOIN (SELECT Country, CampaignId, count(distinct BadgeNo) HC FROM #TempHCDetail   GROUP BY Country, CampaignId)
--B ON A.Country = B.Country and A.CampaignId =B.CampaignId
--WHERE A.Country = 'India'
--return
 
UPDATE #ReportDate SET SWBonus =  ISNULL(SWBonus,0.00)
--UPDATE #ReportDate SET NetBAEarning = ISNULL(NetBAEarning,0.00) + ISNULL(SWBonus,0.00)

UPDATE A SET A.BuletinPoint = NetBAEarning / B.Point FROM #ReportDate A LEFT JOIN #TempPoint B ON A.Country = B.Country
 
 
SELECT Country, Division, Customer, Weekending, RMonth, RQuarter, ISNULL(GrossPiece,0) as 'GrossPiece', ISNULL(GrossPieceOT,0) as 'One Time Pieces', ISNULL(RejectPiece,0) as 'Reject Pieces',
ISNULL(ResubPiece,0) as 'Resub Pieces', ISNULL(NetPiece,0) as 'NetPiece', CountryUSHC, DivUSCH, USCH, GrossSales, NewStarter, Leaver, ISNULL(CountryHC,0) as CountryHC, ISNULL(CountryDivHC,0) as CountryDivHC, ISNULL(CountryCampaignHC,0) as CountryCampaignHC, ISNULL(GrossBAEarning,0.00) as  GrossBAEarning, ISNULL(NetBAEarning,0.00) as NetBAEarning, ISNULL(SWBonus,0.00) as SWBonus, ISNULL(BuletinPoint,0.00) as  BuletinPoint
, ISNULL(RejectPieceOT,0.00) as  RejectPieceOT, ISNULL(RejectPieceREC,0.00) as  RejectPieceREC, ISNULL(ResubPieceOT,0.00) as  ResubPieceOT, ISNULL(ResubPieceREC,0.00) as  ResubPieceREC, B.AvgSCH  FROM #ReportDate  A
LEFT JOIN ( SELECT Country as Country1 , Division as Division1,Customer as Customer1, SUM(USCH)/5 as 'AvgSCH' FROM #DailySHC GROUP BY Country, Division,Customer) 
B ON A.country = B.country1 and A.division = B.Division1 and A.customer = B.customer1
-- WHERE Country <> 'India'
--DROP TABLE #ReportDate
--DROP TABLE #TempKoreaNet  
--DROP TABLE #MainTransaction    
--DROP TABLE #ICETable    
 

END


