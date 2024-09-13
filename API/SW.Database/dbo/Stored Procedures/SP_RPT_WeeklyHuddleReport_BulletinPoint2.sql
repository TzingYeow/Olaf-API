 
--=============================
CREATE PROCEDURE [dbo].[SP_RPT_WeeklyHuddleReport_BulletinPoint2]
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
 

CREATE TABLE #ReportDate (
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
 
 
 
INSERT INTO #ReportDate (Country, MOCode, MOName, Weekending, RMonth, RQuarter, GrossBAEarning, NetBAEarning, SWBonus )

SELECT 'Malaysia' as 'Country', A.MOCode, B.Name , @CountryWeDate as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter', 0.00,0.00,0.00  FROM (
SELECT DISTINCT MOCode  FROM NewMYDB_PROD..VW_CH_SS WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeID,'') <> '' and   IsDeleted = 0 
GROUP BY MOCode
UNION  
SELECT OfficeId_H FROM NewMYDB_PROD..Tbl_TKF_Maintable_StatusSummary WHERE StatusWE = @CountryWeDate and IsDeleted = 0 and Status = 'SubmissionDate'
UNION ALL
SELECT MOCode FROM NewMYDB_PROD..Txn_Commercial_StatusSummary A LEFT JOIN NewMYDB_PROD..Txn_Commercial B ON A.TxnID = B.TxnID  and B.Campaign = 'STMMY'
where StatusWEDate = @CountryWeDate  and A.Status = 'SubmissionDate' and A.IsDeleted = 0   GROUP BY MOCode
UNION 
SELECT MO_Code FROM NewMYDB_PROD..TXN_Lif_SalesHeader
where MO_Sub_Week = @CountryWeDate and DE_By is not null and IsDeleted = 0 GROUP BY MO_Code
UNION  
SELECT MOCode FROM NewMYDB_PROD..TXN_CO_ICE_HASAVA where WEDate = @CountryWeDate
) A LEFT JOIN NewMYDB_PROD..VW_TKF_MalaysiaMOs B ON A.MOCode = B.MOCode

 
UPDATE A SET A.GrossBAEarning = ISNULL( A.GrossBAEarning,0.00) + ISNULL(B.Gross,0.00), A.NetBAEarning =ISNULL( A.NetBAEarning,0.00) + ISNULL(B.netSales,0.00) FROM #ReportDate A INNER JOIN(
SELECT A.MOCode,
SUM(CASE WHEN A.Status in ('SubmissionDate') THEN ICStroke ELSE 0 END) as 'Gross',
SUM(CASE WHEN A.Status in ('SubmissionDate','ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate') THEN ICStroke WHEN A.Status in ('ClientRejectDate','UpDownRejectDate','RejectDate') THEN ICStroke * -1 ELSE 0 END) as 'NetSales' 
FROM NewMYDB_PROD..VW_CH_SS A  
  WHERE StatusWEDate = @CountryWeDate  and ICStroke > 0
and ISNULL(BadgeID,'') <> '' and A.Status in ('SubmissionDate','ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate','ClientRejectDate','UpDownRejectDate','RejectDate')
and IsDeleted = 0
GROUP BY A.MOCode
) B ON A.Country = 'Malaysia' and A.MOCode = B.MOCode
 
  
UPDATE A SET  A.GrossBAEarning = ISNULL(A.GrossBAEarning,0.00) + ISNULL(B.Gross,0.00), A.NetBAEarning = ISNULL(A.NetBAEarning,0.00) +  ISNULL(B.NetSales,0.00) FROM #ReportDate A INNER JOIN(
SELECT 'TAKAFUL' as 'Campaign',  A.OfficeId_H as 'MOCode',
SUM(Case WHEN A.Status in ('SubmissionDate') THEN D.ICStroke  ELSE 0 END) as 'Gross', 
SUM(Case WHEN A.Status in ('SubmissionDate','ReSubDate','ClientReSubDate') THEN D.ICStroke  ELSE D.ICStroke * -1 END) as 'NetSales'
FROM NewMYDB_PROD..Tbl_TKF_Maintable_StatusSummary A 
LEFT JOIN NewMYDB_PROD..Tbl_TKF_Maintable B ON A.RowId = B.RowId 
LEFT JOIN NewMYDB_PROD..VW_TKF_PackagesName C ON B.MonthlyPremiumId = C.Id
LEFT JOIN NewMYDB_PROD..MST_MSF D ON A.MSFID_H = D.ID
where A.StatusWE = @CountryWeDate and A.IsDeleted = 0
and A.Status in ('SubmissionDate','ReSubDate','ClientReSubDate','ClientRejectDate','RejectDate') 
GROUP BY A.OfficeId_H
) B ON A.Country = 'Malaysia' and A.MOCode = B.MOCode
 

UPDATE A SET A.GrossBAEarning = ISNULL(A.GrossBAEarning,0.00) + ISNULL(B.Gross,0.00), A.NetBAEarning = ISNULL(A.NetBAEarning,0.00) +  ISNULL(B.NetSales,0.00)  FROM #ReportDate A INNER JOIN(
SELECT A.MOCode ,
SUM(CASE WHEN A.Status in ('SubmissionDate','ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate') THEN ICStroke ELSE 0 END) as 'Gross',
SUM(CASE WHEN A.Status in ('SubmissionDate','ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate') THEN ICStroke WHEN A.Status in ('ClientRejectDate','UpDownRejectDate','RejectDate') THEN ICStroke * - 1 ELSE 0 END) as 'NetSales' 
FROM NewMYDB_PROD..Txn_Commercial_StatusSummary A LEFT JOIN NewMYDB_PROD..Txn_Commercial B ON A.TxnID = B.TxnID  and B.Campaign = 'STMMY'
  WHERE StatusWEDate = @CountryWeDate  and ICStroke > 0
and ISNULL(B.BadgeID,'') <> '' and A.Status in ('SubmissionDate','ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate','ClientRejectDate','UpDownRejectDate','RejectDate')
and IsDeleted = 0
GROUP BY A.MOCode
) B ON A.Country = 'Malaysia' and A.MOCode = B.MOCode

 UPDATE A SET A.GrossBAEarning = ISNULL(A.GrossBAEarning,0.00) + ISNULL(B.Gross,0.00), A.NetBAEarning = ISNULL(A.NetBAEarning,0.00) + ISNULL(B.Gross,0.00) FROM #ReportDate A INNER JOIN(
SELECT A.MO_Code, SUM(TTL_MSF) as 'Gross' FROM NewMYDB_PROD..TXN_Lif_SalesHeader A 
LEFT JOIN NewMYDB_PROD..TXN_Lif_Sales_Detail C ON A.Trxn_No = C.Trxn_No and C.Purchase_Qty > 0
LEFT JOIN NewMYDB_PROD..VW_CampaignList B ON A.PRDCAT_Code = B.ClientCode
 where MO_Sub_Week = @CountryWeDate and DE_By is not null and A.IsDeleted = 0 and C.IsDeleted = 0
 GROUP BY A.MO_Code  
) B ON A.Country = 'Malaysia' and A.MOCode = B.MO_Code

  
 UPDATE A SET A.GrossBAEarning = ISNULL(A.GrossBAEarning,0.00) + ISNULL(B.gross,0.00), A.NetBAEarning = ISNULL(A.NetBAEarning,0.00) + ISNULL(B.gross,0.00) FROM #ReportDate A INNER JOIN(
SELECT A.MOCode, SUM(TTLValue) as 'Gross'  FROM NewMYDB_PROD..TXN_CO_ICE_HASAVA A  
LEFT JOIN NewMYDB_PROD..VW_CampaignList B ON B.ClientCode = 'HS'
 where WEDate = @CountryWeDate 
 GROUP BY A.MOCode   
) B ON A.Country = 'Malaysia' and A.MOCode = B.MOCode
  
---- Update BOnus

UPDATE #ReportDate SET SWBonus = 0.00 where Country = 'Malaysia'

UPDATE A SET A.SWBonus = ISNULL(A.SWBonus,0.00) + ISNULL(B.Bonus,0.00) FROM #ReportDate A INNER JOIN (
SELECT A.OfficeId, SUM(ISNULL(AcwireBonus,0.00) + ISNULL(AcwireDeductionBonus,0.00) + ISNULL(APPCO_ExtraCommision,0.00)) Bonus FROM NewMYDB_PROD..TXN_CH_ICE A LEFT JOIN NewMYDB_PROD..VW_CampaignList B ON A.Client = B.ClientCode
where WEDate = @CountryWeDate and ChannelId = 'Total'
GROUP BY A.OfficeId ) B ON A.MOCode = B.OfficeId and A.Country = 'Malaysia'

UPDATE A SET A.SWBonus = ISNULL(A.SWBonus,0.00) + ISNULL(B.Bonus,0.00) FROM #ReportDate A INNER JOIN (
SELECT OfficeId, SUM(ISNULL(TotalBonusPayable,0.00)) As Bonus FROM NewMYDB_PROD..TXN_CO_ICE where  ISNULL( TotalBonusPayable,0) > 0
and Client  ='STM' and  SubmissionWEDate = @CountryWeDate GROUP BY OfficeId ) B ON A.MOCode = B.OfficeId and A.Country = 'Malaysia'


UPDATE A SET A.SWBonus = ISNULL(A.SWBonus,0.00) + ISNULL(B.Bonus,0.00) FROM #ReportDate A INNER JOIN (
SELECT OfficeId, SUM(ISNULL(TotalBonusPayable,0)) As Bonus FROM NewMYDB_PROD..TXN_CO_ICE where  ISNULL( TotalBonusPayable,0) > 0
and Client  ='TKF' and  SubmissionWEDate = @CountryWeDate GROUP BY OfficeId ) B ON A.MOCode = B.OfficeId and A.Country = 'Malaysia'


--SELECT * FROM #ReportDate
--  return
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
 
SELECT @UniqueSCH = COUNT(Distinct BadgeNo) FROM (
SELECT distinct BadgeNo as 'BadgeNo'  FROM  NewSGDB_PROD..VW_CH_SS WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeNo,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0 
) A
 
INSERT INTO #ReportDate (Country, MOCode, MOName, Weekending, RMonth, RQuarter, GrossBAEarning, NetBAEarning, SWBonus )
SELECT 'Singapore' as 'Country', A.MOCode, A.Name , @CountryWeDate as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter',0.00,0.00,0.00 FROM (
SELECT DISTINCT A.MOCode, B.Name FROM NewSGDB_PROD..VW_CH_SS A LEFT JOIN NewSGDB_PROD..VW_MST_MO B ON A.MOCode = B.MOCode WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeNo,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0  
) A 
  
   
INSERT INTO #ReportDate (Country, MOCode, MOName, Weekending, RMonth, RQuarter, GrossBAEarning, NetBAEarning, SWBonus )
SELECT  'Singapore' as 'Country',A.MOCode, A.Name, @CountryWeDate as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter',0.00,0.00,0.00 FROM (
SELECT DISTINCT A.MOCode, B.Name FROM NewSGDB_PROD..VW_CH_SS A LEFT JOIN NewSGDB_PROD..VW_MST_MO B ON A.MOCode = B.MOCode WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeNo,'') <> '' and Status <> 'SubmissionDate' and IsDeleted = 0 ) A  
LEFT JOIN #ReportDate Z ON A.MOCode = Z.MOCode  and Z.Country = 'Singapore'
WHERE Z.MOCode is null 
      
UPDATE A SET A.GrossBAEarning = B.gross, A.NetBAEarning = B.NetSales  FROM #ReportDate A INNER JOIN(
SELECT A.MOCode ,SUM(CASE WHEN A.Status in ('SubmissionDate') THEN ICStrokeValue ELSE 0 END) as 'Gross', 
SUM(CASE WHEN A.Status in ('SubmissionDate','ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate') THEN ICStrokeValue ELSE ICStrokeValue * -1 END) as 'NetSales' 
FROM NewSGDB_PROD..VW_CH_SS A 
LEFT JOIN NewSGDB_PROD..Mst_Ch_Package C ON A.PackageId = C.PackageID
  WHERE StatusWEDate = @CountryWeDate -- and ICStrokeValue > 0
and ISNULL(BadgeNo,'') <> '' and A.Status in ('SubmissionDate','ReSubmissionDate','ClientReSubmissionDate','UpDownResubDate','ClientRejectDate','UpDownRejectDate','RejectDate')
and A.IsDeleted = 0
GROUP BY A.MOCode 
) B ON A.Country = 'Singapore' and A.MOCode = B.MOCode
 
UPDATE A SET A.SWBonus = ISNULL(A.SWBonus,0.00) + ISNULL(B.Bonus,0.00)  FROM #ReportDate A INNER JOIN (
SELECT MoCode, SUM(ISNULL(AppcoBonusNET,0.00)) Bonus FROM NewSGDB_PROD..TXN_CH_ICE where WeekendingDate = @CountryWeDate
GROUP BY MoCode
) B ON A.Country = 'Singapore' and A.MOCode = B.MoCode
  


---- =================================================== KOREA (START)==========================================================================
---- ===========================================================================================================================================


INSERT INTO #ReportDate (Country, MOCode, MOName, Weekending, RMonth, RQuarter, GrossBAEarning, NetBAEarning, SWBonus ) 
SELECT   'Korea' as 'Country', A.OfficeID, A.OfficeName,  @weDate, @Month, @Quarter, 
SUM(ISNULL(A.FRStroke,0.00 )) + SUM(ISNULL(A.AdditionalFRStroke,0.00 )),SUM(ISNULL(A.FRStroke,0.00 )) + SUM(ISNULL(A.AdditionalFRStroke,0.00 )),0.00
from Appco360_PROD..SSIS_Maintable  A 
LEFT JOIN NewOlaf_Prod..Mst_Campaign B ON B.CountryCode = 'KR' and A.Campaign = B.CampaignName collate SQL_Latin1_General_CP1_CI_AS
WHERE MOSubWE = @weDate and OfficeID <> 'HQ'  and PaidAmount > 0
GROUP BY  A.OfficeID, A.OfficeName
 
 
UPDATE A SET  A.NetBAEarning = ISNULL(A.GrossBAEarning,0.00) - ISNULL(FRStroke,0.00) FROM #ReportDate A  INNER JOIN (
SELECT OfficeID, SUM(ISNULL(A.FRStroke,0.00 )) + SUM(ISNULL(A.AdditionalFRStroke,0.00 )) FRStroke
from Appco360_PROD..SSIS_Maintable A
WHERE MORejectWE = @weDate  and OfficeID <> 'HQ'  and PaidAmount > 0 
GROUP BY OfficeID
) B ON A.MOCode Collate   SQL_Latin1_General_CP1_CI_AS = B.OfficeID Collate   SQL_Latin1_General_CP1_CI_AS
WHERE A.Country = 'Korea'
    
UPDATE A SET A.SWBonus = ISNULL(A.SWBonus,0.00) + ISNULL(B.Bonus,0.00)  FROM #ReportDate A INNER JOIN (
SELECT OfficeID, SUM(ISNULL(appcoAdjValue,0.00)) Bonus FROM Appco360_PROD..tblWeeklyICE where mosubwe = @ReportWE
GROUP BY OfficeID 
) B ON A.Country = 'Korea' and A.MOCode collate SQL_Latin1_General_CP1_CI_AS = B.OfficeID Collate   SQL_Latin1_General_CP1_CI_AS

 
---- =================================================== KOREA ( END )==========================================================================
---- ===========================================================================================================================================



END
 

--SET @UniqueDiv1 = 0
--SET @UniqueDiv2 = 0
--SET @UniqueDiv3 = 0
--SELECT @UniqueDiv1 = COUNT(Distinct BadgeNo) FROM (
--SELECT distinct BadgeNo as 'BadgeNo'  FROM  NewSGDB_PROD..VW_CH_SS WHERE StatusWEDate = @CountryWeDate 
--and ISNULL(BadgeNo,'') <> '' and Status = 'SubmissionDate' and IsDeleted = 0  
--) A

 

--UPDATE #ReportDate SET DivUSCH = @UniqueDiv1 where Country = 'Singapore' and Division = 'Charity' 
--END
---- =================================================== Singapore (END  )====================================================================
---- ========================================================================================================================================


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
 
 
INSERT INTO #ReportDate (Country, MOCode, MOName, Weekending, RMonth, RQuarter, GrossBAEarning, NetBAEarning, SWBonus ) 
--INSERT INTO #ReportDate (Country, Division, Customer, CampaignID, Weekending, RMonth, RQuarter, CountryUSHC, USCH)
SELECT 'Taiwan' as 'Country', A.Mocode, B.Name, @CountryWeDate as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter', 0.00,0.00,0.00  FROM (
SELECT Mocode FROM NewTWDB_PROD..VW_CH_SS WHERE StatusWEDate = @CountryWeDate 
and ISNULL(BadgeID,'') <> '' and Status IN ('SubmissionDate','RejectDate','ReSubmissionDate','ClientRejectDate','ClientReSubmissionDate','UpDownResubDate','UpDownRejectDate', 'ClientClawBack60') and IsDeleted = 0
GROUP BY Mocode
) A LEFT JOIN MST_marketingcompany B ON B.countrycode = 'TW' and B.Code = A.MoCode
 
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
       
UPDATE A SET   A.GrossBAEarning = B.Gross, A.NetBAEarning = B.NetSales FROM #ReportDate A INNER JOIN(
 SELECT MOCode,  
 SUM(CASE WHEN Type IN ( '0SUBMISSION' ) THEN Commission ELSE 0 END) as 'Gross' ,
 SUM(CASE WHEN Type IN ( '2CLIENTREJECT','1APPCOREJECT')   THEN Commission * -1 ELSE Commission END) as 'NetSales'  FROM #ICETable 
 GROUP BY MOCode  
) B ON A.Country = 'Taiwan' and A.MOCode = B.MOCode
 
 UPDATE A SET A.SWBonus = ISNULL(A.SWBonus,0.00) + ISNULL(B.Bonus,0.00)  FROM #ReportDate A INNER JOIN ( 
select MOCode, SUM(ISNULL(AppcoAdjValue,0.00)) as 'Bonus' from NewTWDB_PROD..Txn_CH_ICE
where AppcoAdjValue > 0 and WeDate = @CountryWeDate GROUP BY MOCode 
) B ON A.Country = 'Taiwan' and A.MOCode collate SQL_Latin1_General_CP1_CI_AS = B.MOCode Collate   SQL_Latin1_General_CP1_CI_AS



END
--END
---- =================================================== TAIWAN (END)=========================================================================
---- ===========================================================================================================================================



---- =================================================== HONG KONG(START)=======================================================================
---- ===========================================================================================================================================



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

INSERT INTO #ReportDate (Country, MOCode, MOName, Weekending, RMonth, RQuarter, GrossBAEarning, NetBAEarning, SWBonus ) 
SELECT 'Hong Kong' as 'Country', MOCode, Name, @CountryWeDate as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter',Gross,NetEarnings,SWBonus FROM (
 SELECT MOCODE, B.Name,CAST(SUM(CASE WHEN NetEarnings = 0 OR NetPoints = 0 THEN 0.00 ELSE  (NetEarnings / NetPoints) * GrossPoints END) as decimal(18,2)) as 'Gross', 
 CAST(SUM(NetEarnings) as decimal(18,2)) as 'NetEarnings' , CAST(SUM(ISNULL(appcoBonus,0.00))  as decimal(18,2)) + CAST(SUM(ISNULL(appcoBonus1,0.00))  as decimal(18,2)) SWBonus
 FROM NewHKDB_PROD..Txn_Transaction_ICE A LEFT JOIN NewOlaf_Prod..Mst_MarketingCompany B ON A.MOCode = B.Code and B.CountryCode = 'HK'
 where WeekendingDate = @CountryWeDate and A.IsDeleted = 0  
 GROUP BY MOCODE  , B.Name 
) A  
 
-- Gross Earning
UPDATE A SET GrossBAEarning = B.Gross
FROM #ReportDate A
INNER JOIN (SELECT MOCode, SUM(CASE WHEN TypeSub IN ('SUBMISSION','RESUB') THEN ComissionPaid END)[Gross]  
			FROM NewHKDB_PROD..Txn_PiecesHistory 
			WHERE StatusWEDate = @CountryWeDate 
			GROUP BY MOCode) B ON B.MOCode = A.MOCode
WHERE A.Country = 'Hong Kong'
			
 END
---- =================================================== HONG KONG END)=========================================================================
---- ===========================================================================================================================================
 
---- =================================================== THAILAND (START)=======================================================================
---- ===========================================================================================================================================



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
 
 
INSERT INTO #ReportDate (Country, MOCode, MOName, Weekending, RMonth, RQuarter, GrossBAEarning, NetBAEarning, SWBonus ) 
SELECT 'Thailand' as 'Country', A.MOCode, B.Name, @CountryWeDate as 'Weekending', @Month as 'Month' ,@Quarter as 'Quarter', Gross,NetEarning,Bonus FROM (
 SELECT A.MOCode, SUM(GrossEarning) as 'Gross', SUM(NetEarning) as 'NetEarning', SUM(Bonus) as 'Bonus' FROM (
 SELECT MOCode, SUM(ISNULL(SubmissionEarning,0.00) + ISNULL(ResubEarning,0.00)) as 'GrossEarning',SUM(ISNULL(NetEarnings,0.00)) as 'NetEarning', SUM(ISNULL(AppcoBonus,0.00)) as 'Bonus' 
 FROM NewTHDB_PROD..Txn_Transaction_ICE where WeekendingDate = @CountryWeDate
 and IsDeleted = 0   --and CampaignId = 2
 GROUP BY MOCODE 
 UNION
select A.MOCode, SUM(c.ICStrokeValue),SUM(c.ICStrokeValue), 0 from 
NewTHDB_PROD..Txn_Transaction a 
inner join NewTHDB_PROD..Txn_Co_CampaignTransaction b on b.TxnId = a.TxnId and b.IsDeleted = 0
inner join NewTHDB_PROD..Txn_Co_Campaign_Product c on c.TxnId = a.TxnId and c.IsDeleted = 0 and ParentCampaignProductId IS NULL
where a.MoSubmissionWEDate = @CountryWeDate
GROUP BY A.MOCode
) A  GROUP BY A.MOCode
) A  LEFT JOIN NewOlaf_Prod..Mst_MarketingCompany B ON A.MOCode = B.Code and B.CountryCode = 'TH'

 

END
---- =================================================== THAILAND (END)=========================================================================
---- ===========================================================================================================================================
 
  
 DELETE FROM #ReportDate WHERE ISNULL(GrossBAEarning,0.00) + ISNULL(NetBAEarning,0.00) + ISNULL(SWBonus,0.00) = 0.00
 
UPDATE A SET A.ConversionRate = B.Point, A.BuletinPoint =  (A.NetBAEarning + A.SWBonus) / B.Point FROM #ReportDate A LEFT JOIN #TempPoint B ON A.Country = B.Country

 
SELECT * FROM #ReportDate
ORDER BY Country, MOCode



END


