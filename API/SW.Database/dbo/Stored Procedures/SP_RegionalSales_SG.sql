--3 NULL
--=============================
CREATE PROCEDURE [dbo].[SP_RegionalSales_SG]   
AS
BEGIN
	truncate table TXN_RegionalSalesSummary

SELECT DISTINCT CountryCode,MAX(statuswedate) from TXN_RegionalSalesSummary GROUP BY CountryCode

DROP TABLE IF EXISTS #StatusName
CREATE TABLE #StatusName(
	Country NVARCHAR(2),
	StatusCode NVARCHAR(50),
	CustomDesc NVARCHAR(50)
)

INSERT INTO #StatusName SELECT 'TW','ClientClawBack60','ClientRejectDate'

DROP TABLE IF EXISTS #PaymentTypeName
CREATE TABLE #PaymentTypeName(
	Country NVARCHAR(2),
	PaymentType NVARCHAR(50), 
	CustomDesc NVARCHAR(50)
)

INSERT INTO #PaymentTypeName SELECT 'MY','CASH','CS'

 

-----------------------------------------------------------------------------------------------------------------
-- Singapore (START)
-----------------------------------------------------------------------------------------------------------------
 
DROP TABLE IF EXISTS #RawSG
SELECT TXNID INTO #RawSG FROM NewSGDB_PROD..VW_CH_SS WHERE status = 'SubmissionDate' and StatusDate >='2022-01-01' 

DELETE FROM TXN_RegionalSalesSummary where CountryCode = 'SG'
INSERT INTO TXN_RegionalSalesSummary
SELECT   NEWID(), 'SG' as 'Country', A.TXNID ,  C.CampaignId,  C.CampaignId, C.DivisionId, A.MOCode, A.BadgeNo, A.LiveStatus, ISNULL(D.CustomDesc, A.Status) as 'Status', A.StatusDate, A.StatusWEDate, 
A.PackageValue, A.Frequency, CAST(B.TxnDate as date) as 'SignupDate', NewSGDB_PROD.dbo.WeekedingDate(B.TxnDate),
B.MoSubmissionDate, NewSGDB_PROD.dbo.WeekedingDate(B.MoSubmissionDate), A.PaymentMode, CASE WHEN A.Channel = 'EVENTS' THEN 'EVE' ELSE A.Channel  END as 'Channel',
'','', B.MainBirthday, CASE WHEN (CAST(FORMAT(B.TxnDate,'yyyyMMdd') as bigint) - cast(FORMAT(CAST(B.MainBirthday as date),'yyyyMMdd') as bigint))/10000   < 26 THEN 'Y' ELSE 'N' END as 'Underage',
(CAST(FORMAT(B.TxnDate,'yyyyMMdd') as bigint) - cast(FORMAT(CAST(B.MainBirthday as date),'yyyyMMdd') as bigint))/10000 as 'Age',  '' , B.DOBOType as 'DoboType',
 A.MSFID - A.ICStrokeValue, A.ICStrokeValue, 'N',NULL, NULL,NULL, A.CreatedDate
FROM NewSGDB_PROD..VW_CH_SS A LEFT JOIN NewSGDB_PROD..VW_CHR_TXN B ON A.TXNID = B.TXNID  
LEFT JOIN Mst_Campaign C ON A.CampaignCode = C.CampaignId 
LEFT JOIN #StatusName D ON A.status = D.StatusCode and D.Country = 'SG' 
WHERE A.IsDeleted = 0 and A.TXNID IN (SELECT TXNID FROM #RawSG) AND A.Status not in ('OfficeRejectDate','BanknStatus_61', 'ClientClawBack90','SGSubDate','BanknStatus_66','BanknStatus_59','PendingCheque')
 
order by A.TXNID
 

-----------------------------------------------------------------------------------------------------------------
-- Singapore (END)
-----------------------------------------------------------------------------------------------------------------

   

END
 

--DELETE FROM TXN_RegionalSalesSummary where   Campaign = '1264'


-- SELECT * FROM MST_campaign where CampaignName like '%futu%'