--SP_RPT_RegionalBusiness_commercial2 '2022-01-01','2022-06-01'
--=============================
CREATE PROCEDURE [dbo].[SP_RPT_RegionalBusiness_commercial]
	-- Add the parameters for the stored procedure here
	@SignUpFrom  date ,
	@SignUpTo  date 
AS
BEGIN

SELECT * INTO #Raw FROM (
SELECT 'MY' as 'Country', 'STMB' as 'Campaign', DATEADD(month, DATEDIFF(month, 0, a.txndate), 0) as Signup, COUNT(*) as 'GrossPcs', SUM(B.amount) as 'Gross', 
SUM(CASE WHEN A.status in ('AC','AR','CC') THEN 0.00 ELSE B.amount END) as 'Nett' 
FROM NewMYDB_PROD..TXN_Transaction A 
LEFT JOIN NewMYDB_PROD..Txn_Commercial C ON A.TxnID = C.txnid 
LEFT JOIN NewMYDB_PROD..MST_CO_Product B ON C.PackageId = B.PackageID
where  DivisionCode = 'CO' and A.txnid in (
SELECT txnid FROM NewMYDB_PROD..Txn_Commercial_StatusSummary  where status = 'SubmissionDate' and IsDeleted = 0
) and TxnDate >=@SignUpFrom and TxnDate <= @SignUpTo and status not in ('AC')
GROUP BY  DATEADD(month, DATEDIFF(month, 0, a.txndate), 0)
UNION ALL
SELECT 'MY' as 'Country',B.Campaign as 'Campaign',DATEADD(month, DATEDIFF(month, 0, a.Trxn_Date), 0) as Signup, COUNT(*) as 'GrossPcs',  SUM(TTL_GrossPrice) 'Gross',  
SUM(TTL_GrossPrice) 'Nett'  FROM NewMYDB_PROD..TXN_Lif_SalesHeader A 
LEFT JOIN NewMYDB_PROD..TXN_Lif_Sales_Detail C ON A.Trxn_No = C.Trxn_No and C.Purchase_Qty > 0
LEFT JOIN NewMYDB_PROD..VW_CampaignList B ON A.PRDCAT_Code = B.ClientCode
 where CAST(Trxn_Date as date) >=@SignUpFrom and CAST(Trxn_Date as date) <= @SignUpTo and DE_By is not null and A.IsDeleted = 0 and C.IsDeleted = 0
 GROUP BY B.Campaign ,DATEADD(month, DATEDIFF(month, 0, a.Trxn_Date), 0)
UNION  
 SELECT 'MY' as 'Country', Campaign ,DATEADD(month, DATEDIFF(month, 0, a.SignupDate), 0) as Signup, COUNT(*) as 'GrossPcs', SUM(SubTotal) as 'Gross', SUM(SubTotal) as 'Nett'
 FROM NewMYDB_PROD..TXN_LS_Hasava A
 WHERE SignupDate >= @SignUpFrom and SignupDate <=@SignUpTo
 GROUP BY Campaign, DATEADD(month, DATEDIFF(month, 0, a.SignupDate), 0)
 UNION
 
select 'TH' as 'Country', d.Client[Campaign],DATEADD(month, DATEDIFF(month, 0, a.SignUpDate), 0) as Signup, COUNT(*) as 'GrossPcs', SUM(c.Price)[Gross],  SUM(c.Price)[Gross]   
from NewTHDB_PROD..Txn_Transaction a
inner join NewTHDB_PROD..Txn_Co_CampaignTransaction b on b.TxnId = a.TxnId and b.IsDeleted = 0 and b.RecordTypeCode = 'MAIN'
inner join NewTHDB_PROD..Txn_Co_Campaign_Product c on c.TxnId = a.TxnId and c.IsDeleted = 0 --and ParentCampaignProductId is null
inner join NewTHDB_PROD..Mst_Co_Product p on p.ProductId = c.ProductId
inner join NewTHDB_PROD..VW_MST_CampaignList d on d.ID = b.CampaignId
where a.IsDeleted = 0 and SignupDate >= @SignUpFrom and SignupDate <=@SignUpTo
GROUP BY  d.Client, DATEADD(month, DATEDIFF(month, 0, a.SignUpDate), 0)
) A  
 
DROP TABLE IF EXISTS #CampaignDetail
SELECT Country, Signup, CAST(STRING_AGG( Campaign,',' ) WITHIN GROUP (order by Campaign) as NVARCHAR(MAX) )  as 'Campaign' INTO #CampaignDetail FROM (
SELECT country, signup, campaign FROM #Raw GROUP BY country, signup, campaign
) A GROUP BY Country, Signup ORDER BY Country, Signup
  
SELECT A.Country, A.Signup, COUNT(Distinct A.Campaign) as 'Campaign', UPPER(MAX(B.Campaign)) as 'CampaignDetail', SUM(GrossPcs) as 'Grosspcs', SUM(gross) gross, SUM(Nett) Nett  
FROM #Raw A LEFT JOIN #CampaignDetail B ON A.country= B.country and A.signup = B.signup
GROUP BY A.Country, A.Signup
ORDER BY A.Country, A.Signup

 
END

--SP_RPT_RegionalBusiness_commercial2 '2022-01-01','2023-04-01'
 

  