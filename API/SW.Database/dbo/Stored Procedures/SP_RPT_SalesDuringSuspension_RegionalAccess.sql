-- =============================================
-- Author:		Syafiqah Ab Manah
-- Create date: 2023-01-19
-- Description:	This Report list out BA sales during Suspension Period
-- EXEC [SP_RPT_SalesDuringSuspension_RegionalAccess] '2023-01-08','2023-01-29','b2a2a1706a0d403598e9115d5846485d','HK,ID,IN,KR,MY,PH,SG,TH,TW'-- REGIONAL
-- EXEC [SP_RPT_SalesDuringSuspension_RegionalAccess] '2022-10-30','2023-01-29','b2a2a1706a0d403598e9115d5846485d','HK,ID,IN,KR,MY,PH,SG,TH,TW'-- REGIONAL
-- =============================================
CREATE PROCEDURE [dbo].[SP_RPT_SalesDuringSuspension_RegionalAccess]
	 @weFromDate Date,
	 @weToDate Date,
	 @userId NVARCHAR(255),
	 @selectedCountry NVARCHAR(255)

AS
BEGIN
--select * from mst_user where USERNAME = 'SYAFIQAH'
--select * from Mst_UserRole

DECLARE @CountryCode NVARCHAR(255);
DECLARE @IsMOAdminRole BIT;
DECLARE @MCId NVARCHAR(10);

SELECT 
@CountryCode = CountryAccess,
@IsMOAdminRole = CASE WHEN UserRoleId = 3 THEN  1 ELSE 0 END,
@MCId =  MarketingCompanyId
FROM Mst_User WHERE UserId = @userId

IF OBJECT_ID('tempdb..#SubCountry') IS NOT NULL DROP TABLE #SubCountry
SELECT CAST(VALUE as varchar) as 'Country' INTO #SubCountry FROM STRING_SPLIT(@CountryCode, ',') 

IF OBJECT_ID('tempdb..#SelectedCountry') IS NOT NULL DROP TABLE #SelectedCountry
SELECT CAST(VALUE as varchar) as 'Country' INTO #SelectedCountry FROM STRING_SPLIT(@selectedCountry, ',') 

CREATE TABLE #ReportDate (
	Country NVARCHAR(20),
	CountryCode NVARCHAR(20),
	Division NVARCHAR(20),
	Campaign NVARCHAR(50),
	MOCode NVARCHAR(5),
	Weekending Date,
	BadgeNo NVARCHAR(50),
	SerialNumber NVARCHAR(500),
	SignUpDate Date,
	SNStatus NVARCHAR(50),
)

CREATE TABLE #FinalReport (
	Country NVARCHAR(20),
	CountryCode NVARCHAR(20),
	Division NVARCHAR(20),
	Campaign NVARCHAR(50),
	MOCode NVARCHAR(5),
	MOID NVARCHAR(10),
	Weekending Date,
	BadgeNo NVARCHAR(50),
	SerialNumber NVARCHAR(500),
	SignUpDate Date,
	SNStatus NVARCHAR(50),
)

--SELECT @weFromDate, @weToDate

-- MALAYSIA (START)
-- CHARITY
INSERT INTO #ReportDate (Country, CountryCode, Division, Campaign, MOCode, Weekending, BadgeNo, SerialNumber, SignUpDate, SNStatus)
SELECT 'Malaysia', 'MY', 'Charity', Client ,MOCode, StatusWEDate, BadgeID, SerialNumber, SignUpDate, 
CASE WHEN LiveStatus IN ('MS','MR') THEN 'PENDING' WHEN LiveStatus IN ('AR','CC') THEN 'REJECT'  WHEN LiveStatus IN ('AP','CR') THEN 'APPROVE' END AS SNStatus
FROM NewMYDB_PROD..VW_CH_SS 
WHERE IsDeleted = 0 AND Status IN ( 'SubmissionDate' , 'ReSubmissionDate', 'ClientReSubmissionDate') AND StatusWEDate >=  @weFromDate AND StatusWEDate <= @weToDate
AND MOCode IS NOT NULL

 -- COMMERCIAL
INSERT INTO #ReportDate (Country, CountryCode, Division, Campaign, MOCode, Weekending, BadgeNo, SerialNumber, SignUpDate, SNStatus)
SELECT 'Malaysia' Country,'MY', 'Commercial' Division, 'TKF' Campaign, OfficeId_H MOCode, StatusWE Weekending, ICBadgeNo_H BadgeNo, A.RowId SerialNumber, CAST(SignUpDateTime AS DATE) 'SignUpDate', 
CASE WHEN Status IN ('SubmissionDate','ReSubDate') THEN 'PENDING' WHEN Status IN ('ClientRejectDate') THEN 'REJECT'  WHEN Status IN ('ClientReSubDate') THEN 'APPROVE' END AS SNStatus
FROM NewMYDB_PROD..Tbl_TKF_Maintable_StatusSummary A LEFT JOIN NewMYDB_PROD..Tbl_TKF_Maintable B ON A.RowId = B.ROWID 
WHERE A.IsDeleted = 0 AND Status IN ( 'SubmissionDate' , 'ReSubmissionDate', 'ClientReSubmissionDate') AND StatusWE >=  @weFromDate AND StatusWE <= @weToDate

INSERT INTO #ReportDate (Country, CountryCode, Division, Campaign, MOCode, Weekending, BadgeNo, SerialNumber, SignUpDate, SNStatus)
SELECT 'Malaysia' Country,'MY', 'Commercial' Division, B.Campaign, MOCode, StatusWEDate Weekending, A.BadgeID BadgeNo, B.RowId SerialNumber, CAST(SignUpDate AS DATE) 'SignUpDate', NULL SNStatus
FROM NewMYDB_PROD..Txn_Commercial_StatusSummary A LEFT JOIN NewMYDB_PROD..Txn_Commercial B ON A.TxnID = B.TxnID
WHERE A.IsDeleted = 0 AND Status IN ( 'SubmissionDate' , 'ReSubmissionDate', 'ClientReSubmissionDate') AND A.StatusWEDate >=  @weFromDate AND StatusWEDate <= @weToDate

 -- LIFESTYLE
INSERT INTO #ReportDate (Country, CountryCode, Division, Campaign, MOCode, Weekending, BadgeNo, SerialNumber, SignUpDate, SNStatus)
SELECT 'Malaysia' Country, 'MY', 'LifeStyle' Division, PRDCAT_Code Campaign, MO_Code MOCode, MO_Sub_Week Weekending, IC_Code BadgeNo, Trxn_No SerialNumber, Trxn_Date, NULL SNStatus
FROM NewMYDB_PROD..TXN_Lif_SalesHeader
WHERE IsDeleted = 0 AND MO_Sub_Week >=  @weFromDate AND MO_Sub_Week <= @weToDate

INSERT INTO #ReportDate (Country,CountryCode, Division, Campaign, MOCode, Weekending, BadgeNo, SerialNumber, SignUpDate, SNStatus)
SELECT 'Malaysia' Country,'MY', 'LifeStyle' Division, 'HS' Campaign, MOCode, WEDate Weekending, AgentID BadgeNo, OrderID SerialNumber, CAST(SignUpDate AS DATE) 'SignUpDate', NULL SNStatus
FROM NewMYDB_PROD..TXN_LS_Hasava
WHERE IsDeleted = 0  AND WEdate >=  @weFromDate AND WEdate <= @weToDate
-- MALAYSIA (END)

-- SINGAPORE (START)
-- CHARITY
INSERT INTO #ReportDate (Country, CountryCode, Division, Campaign, MOCode, Weekending, BadgeNo, SerialNumber, SignUpDate, SNStatus)
SELECT 'Singapore' Country,'SG', 'Charity' Division, A.CampaignCode Campaign, A.MOCode, StatusWEDate Weekending, A.BadgeNo, A.SerialNo SerialNumber, CAST(B.SignUpDate AS DATE) 'SignUpDate',
CASE WHEN A.Status IN ('SubmissionDate','ReSubmissionDate') THEN 'PENDING' WHEN A.Status IN ('ClientRejectDate','RejectDate') THEN 'REJECT'  WHEN A.Status IN ('ClientApproved','ClientReSubmissionDate') THEN 'APPROVE' END AS SNStatus
FROM NewSGDB_PROD..VW_CH_SS A LEFT JOIN NewSGDB_PROD..VW_CHR_TXN B ON A.TxnId = B.TXNID 
WHERE A.IsDeleted = 0 AND A.Status IN ( 'SubmissionDate' , 'ReSubmissionDate', 'ClientReSubmissionDate') AND A.StatusWEDate >=  @weFromDate AND StatusWEDate <= @weToDate
-- SINGAPORE (END)

-- TAIWAN (START)
-- CHARITY
INSERT INTO #ReportDate (Country, CountryCode, Division, Campaign, MOCode, Weekending, BadgeNo, SerialNumber, SignUpDate, SNStatus)
SELECT 'Taiwan' Country,'TW', 'Charity' Division, B.CampaignCode Campaign, A.MOCode, StatusWEDate Weekending, B.BadgeNo, B.SerialNumber, CAST(B.SignUpDate AS DATE) 'SignUpDate', 
CASE WHEN A.Status IN ('SubmissionDate','ReSubmissionDate') THEN 'PENDING' WHEN A.Status IN ('ClientRejectDate','RejectDate','OfficeRejectDate') THEN 'REJECT'  WHEN A.Status IN ('ClientApproved','ClientReSubmissionDate') THEN 'APPROVE' END AS SNStatus
FROM NewTWDB_PROD..VW_CH_SS A LEFT JOIN NewTWDB_PROD..VW_CHR_TXN B ON A.TxnId = B.TXNID 
WHERE A.IsDeleted = 0 AND A.Status IN ( 'SubmissionDate' , 'ReSubmissionDate', 'ClientReSubmissionDate') AND A.StatusWEDate >=  @weFromDate AND StatusWEDate <= @weToDate
-- TAIWAN (END)

-- HONG KONG (START)
-- CHARITY
INSERT INTO #ReportDate (Country, CountryCode, Division, Campaign, MOCode, Weekending, BadgeNo, SerialNumber, SignUpDate, SNStatus)
SELECT 'Hong Kong' Country, 'HK','Charity' Division, A.CampaignCode Campaign, A.MOCode, StatusWEDate, A.BadgeNo, B.SerialNo, CAST(B.SignUpDate AS DATE) 'SignUpDate', 
CASE WHEN A.Status IN ('SubmissionDate','ReSubmissionDate') THEN 'PENDING' WHEN A.Status IN ('ClientRejectDate','RejectDate','OfficeRejectDate') THEN 'REJECT' END AS SNStatus
FROM NewHKDB_PROD..Txn_Transaction_StatusSummary  A LEFT JOIN NewHKDB_PROD..VW_CHR_TXN B ON A.TXNID = B.TXNID
WHERE A.IsDeleted = 0 AND A.Status IN ( 'SubmissionDate' , 'ReSubmissionDate') AND A.StatusWEDate >=  @weFromDate AND StatusWEDate <= @weToDate

-- COMMERCIAL
INSERT INTO #ReportDate (Country, CountryCode, Division, Campaign, MOCode, Weekending, BadgeNo, SerialNumber, SignUpDate, SNStatus)
SELECT 'Hong Kong' Country, 'HK','Commercial' Division, A.Campaign Campaign, B.OfficeCode MOCode, A.WEDate StatusWEDate, A.BadgeID BadgeNo, NULL SerialNo, WEDate 'SignUpDate', NULL Status
FROM Appco360_PROD..Txn_SalesImport A LEFT JOIN NewHKDB_PROD..VW_MST_IC B ON A.BadgeID = B.BadgeNo
WHERE A.Country = 'HK' and A.SignUpPieces > 0 and A.Campaign in ('Viospace','Home Cuisine') and IsDeleted = 0 AND A.wedate >=  @weFromDate AND wedate <= @weToDate

-- HONG KONG (END)

-- THAILAND (START)
-- CHARITY
INSERT INTO #ReportDate (Country, CountryCode, Division, Campaign, MOCode, Weekending, BadgeNo, SerialNumber, SignUpDate, SNStatus)
SELECT 'Thailand' Country, 'TH','Charity' Division, A.CampaignCode Campaign, A.MOCode, StatusWEDate, A.BadgeNo, B.SerialNo, CAST(B.SignUpDate AS DATE) 'SignUpDate',
CASE WHEN A.Status IN ('SubmissionDate','ReSubmissionDate') THEN 'PENDING' WHEN A.Status IN ('ClientRejectDate','RejectDate','OfficeRejectDate') THEN 'REJECT'  WHEN A.Status IN ('ClientApproved','ClientReSubmissionDate') THEN 'APPROVE' END AS SNStatus
FROM NewTHDB_PROD..Txn_Transaction_StatusSummary A LEFT JOIN NewTHDB_PROD..VW_CHR_TXN B ON A.TxnId = B.TxnId
WHERE A.IsDeleted = 0 AND A.Status IN ( 'SubmissionDate' , 'ReSubmissionDate', 'ClientReSubmissionDate') AND A.StatusWEDate >=  @weFromDate AND StatusWEDate <= @weToDate

-- COMMERCIAL
INSERT INTO #ReportDate (Country, CountryCode, Division, Campaign, MOCode, Weekending, BadgeNo, SerialNumber, SignUpDate, SNStatus)
SELECT 'Thailand' Country,  'TH',CASE WHEN D.Division = 'CO' THEN 'Commercial' ELSE d.Division END 'Division', 
A.CampaignCode Campaign, A.MOCode, MoSubmissionWEDate, A.BadgeNo, B.SerialNo, CAST(SignUpDate AS DATE) 'SignUpDate', NULL SNStatus
from NewTHDB_PROD..Txn_Transaction a
inner join NewTHDB_PROD..Txn_Co_CampaignTransaction b on b.TxnId = a.TxnId and b.IsDeleted = 0
inner join NewTHDB_PROD..VW_MST_CampaignList d on d.ID = b.CampaignId
where A.IsDeleted = 0 AND A.MoSubmissionWEDate >=  @weFromDate AND MoSubmissionWEDate <= @weToDate

-- THAILAND (END)

-- KOREA (START)
-- CHARITY
INSERT INTO #ReportDate (Country, CountryCode, Division, Campaign, MOCode, Weekending, BadgeNo, SerialNumber, SignUpDate, SNStatus)
SELECT 'Korea' Country,  'KR','Charity' Division, A.Campaign, A.OfficeId, A.MOSubWE StatusWEDate, A.FRID BadgeNo, A.SerialNo, CAST(A.SignUpDate AS DATE) 'SignUpDate', 
CASE WHEN AppcoStatus IN ('PENDING') THEN 'PENDING' WHEN AppcoStatus IN('CLIENTREJECT','APPCOREJECT') THEN 'REJECT' WHEN AppcoStatus IN ('APPROVED') THEN 'APPROVED' END AS SNStatus
from Appco360_PROD..SSIS_Maintable  A 
LEFT JOIN NewOlaf_Prod..Mst_Campaign B ON B.CountryCode = 'KR' and A.Campaign = B.CampaignName collate SQL_Latin1_General_CP1_CI_AS
WHERE A.MOSubWE >=  @weFromDate AND MOSubWE <= @weToDate
-- KOREA (END) 

SELECT CASE WHEN CountryCode = 'HK' THEN 'Hong Kong' WHEN CountryCode = 'KR' THEN 'Korea'  WHEN CountryCode = 'MY' THEN 'Malaysia' 
WHEN CountryCode = 'SG' THEN 'Singapore' WHEN CountryCode = 'TW' THEN 'Taiwan' WHEN CountryCode = 'TH' THEN 'Thailand' END AS 'Country', 
m.Code, m.Name, i.BadgeNo,CONCAT(i.FirstName, i.MiddleName, ' ', i.LastName) AS 'BadgeName',i.Status, 
s.StartDate as StartDate, s.EndDate as EndDate, s.Description
INTO #SuspensionList
FROM Mst_IndependentContractor_Suspension s 
INNER JOIN Mst_IndependentContractor i ON s.IndependentContractorId = i.IndependentContractorId
INNER JOIN Mst_MarketingCompany m ON i.MarketingCompanyId = m.MarketingCompanyId
WHERE s.IsDeleted = 0
ORDER BY m.CountryCode, m.Code, i.BadgeNo, i.Status, s.StartDate asc

INSERT INTO #FinalReport (Country, CountryCode, Division, Campaign, MOCode, MOID, Weekending, BadgeNo, SerialNumber, SignUpDate, SNStatus)
SELECT A.Country, A.CountryCode, Division, Campaign, MOCode, C.MarketingCompanyId, Weekending, A.BadgeNo, SerialNumber, SignUpDate, SNStatus FROM #ReportDate A
LEFT JOIN #SuspensionList B ON A.Country = B.Country AND A.MOCode = B.Code AND A.BadgeNo = B.BadgeNo
INNER JOIN Mst_MarketingCompany C ON A.CountryCode = C.CountryCode AND A.MOCode = C.Code
WHERE SignUpDate >= StartDate AND  SignUpDate <= EndDate

--SELECT * FROM #ReportDate ORDER BY Country,SignUpDate ASC
--SELECT * FROM #FinalReport ORDER BY COUNTRY, SignUpDate ASC
--SELECT * FROM #SuspensionList WHERE BadgeNo IN (SELECT DISTINCT BADGENO FROM #FinalReport)
--SELECT * FROM #SubCountry

SELECT * FROM #FinalReport A WHERE A.CountryCode IN (SELECT Country FROM #SelectedCountry)

DROP TABLE #ReportDate
DROP TABLE #SuspensionList
DROP TABLE #FinalReport
END

--EXEC [SP_RPT_Suspension_RegionalAccess] '2023-01-08','2023-01-08','MY,SG'-- REGIONAL
