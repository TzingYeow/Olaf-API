--SP_RPT_RegionalBusiness_charity '2023-01-01','2023-02-21'
--=============================
CREATE PROCEDURE [dbo].[SP_RPT_RegionalBusiness_charity]
	-- Add the parameters for the stored procedure here
	@SignUpFrom  date ,
	@SignUpTo  date 
AS
BEGIN
	  
	  
DROP TABLE IF EXISTS #RawData
CREATE TABLE #RAWData(
	Country NVARCHAR(2),
	SignUpMonth DATE,
	TotalClient INT,
	ClientList NVARCHAR(500),
	GrossSales INT,
	Approved INT,
	AvgDonationAmt DECIMAL(18,2),
	FundRaise36Month DECIMAL(18,2)
)

-- Thailand
DROP TABLE IF EXISTS #SignupData_TH
select a.TxnId,DATEADD(month, DATEDIFF(month, 0, a.SignUpDate), 0) as Signup, b.PackageValue, c.Frequency, CAST(b.PackageValue/IIF(c.Frequency=0,1,c.Frequency) AS decimal(18,2))[PerMonth], a.CampaignCode 
into #SignupData_TH 
from NewTHDB_PROD..VW_CHR_TXN a  with (nolock)
inner join NewTHDB_PROD..Txn_Transaction_StatusSummary b  with (nolock) on b.TxnId = a.TxnId and b.IsDeleted = 0 and b.Status = 'SubmissionDate'
inner join NewTHDB_PROD..Mst_Ch_Package c  with (nolock) on c.PackageId = b.PackageId and c.IsDeleted = 0 and C.Frequency > 0
where a.IsDeleted = 0 and a.SignUpDate between @SignUpFrom and @SignUpTo
--group by a.TxnId
--having count(*) > 1
order by a.TxnId

DROP TABLE IF EXISTS #ClientDetail_TH
SELECT Signup, CampaignCode INTO #ClientDetail_TH   FROM #SignupData_TH
GROUP BY Signup, CampaignCode
ORDER BY Signup DESC, CampaignCode

DROP TABLE IF EXISTS #ClientList_TH
SELECT Signup, CAST(STRING_AGG( CampaignCode,',' )
WITHIN GROUP (order by CampaignCode) as NVARCHAR(MAX) )  as 'Campaign' INTO #ClientList_TH FROM #ClientDetail_TH
GROUP BY Signup 
  

DROP TABLE IF EXISTS #Approve_TH
select Signup, COUNT(*)[Approve] into #Approve_TH from #SignupData_TH A  with (nolock)
INNER JOIN NewTHDB_PROD..Txn_Transaction_StatusSummary b  with (nolock) on b.TxnId = a.TxnId and b.IsDeleted = 0 and b.Status = 'ClientApproved'
GROUP BY Signup

DROP TABLE IF EXISTS #TotalClient_TH
select Signup, COUNT(distinct CampaignCode)[TotalClient] into #TotalClient_TH from #SignupData_TH
GROUP BY Signup

DROP TABLE IF EXISTS #GrossSales_AvgDonationAmount_TH
select signup, COUNT(PackageValue)[GrossSales], SUM(PerMonth)/COUNT(*)[AverageDonationAmount] into #GrossSales_AvgDonationAmount_TH from #SignupData_TH
GROUP BY signup

INSERT INTO #RAWData
select 'TH'[Country], A.Signup, TotalClient, D.Campaign, GrossSales, Approve, AverageDonationAmount, (Approve * AverageDonationAmount * 36)[FundRaise36Month] from #GrossSales_AvgDonationAmount_TH A
inner join #Approve_TH B ON A.Signup = B.Signup
inner join #TotalClient_TH C ON A.Signup = C.Signup
LEFT JOIN #ClientList_TH D ON A.Signup = D.Signup
ORDER BY Country, Signup



-- Hong Kong
DROP TABLE IF EXISTS #SignupData_HK
select a.TxnId,DATEADD(month, DATEDIFF(month, 0, a.SignUpDate), 0) as Signup,  b.PackageValue, c.Frequency, CAST(b.PackageValue/IIF(c.Frequency=0,1,c.Frequency) AS decimal(18,2))[PerMonth], a.CampaignCode into #SignupData_HK
from NewHKDB_PROD..VW_CHR_TXN a with (nolock)
inner join NewHKDB_PROD..Txn_Transaction_StatusSummary b with (nolock) on b.TxnId = a.TxnId and b.IsDeleted = 0 and b.Status = 'SubmissionDate'
inner join NewHKDB_PROD..Mst_Ch_Package c with (nolock) on c.PackageId = b.PackageId and c.IsDeleted = 0 and c.frequency > 0
where a.IsDeleted = 0 and a.SignUpDate between @SignUpFrom and @SignUpTo
order by a.TxnId

DROP TABLE IF EXISTS #ClientDetail_HK
SELECT Signup, CampaignCode INTO #ClientDetail_HK   FROM #SignupData_HK
GROUP BY Signup, CampaignCode
ORDER BY Signup DESC, CampaignCode

DROP TABLE IF EXISTS #ClientList_HK
SELECT Signup, CAST(STRING_AGG( CampaignCode,',' )
WITHIN GROUP (order by CampaignCode) as NVARCHAR(MAX) )  as 'Campaign' INTO #ClientList_HK FROM #ClientDetail_HK
GROUP BY Signup 
  

DROP TABLE IF EXISTS #Approve_HK
select Signup, COUNT(*)[Approve] into #Approve_HK from #SignupData_HK A
INNER JOIN NewHKDB_PROD..Txn_Transaction_StatusSummary b with (nolock) on b.TxnId = a.TxnId and b.IsDeleted = 0 and b.Status = 'ClientApproved'
GROUP BY Signup

DROP TABLE IF EXISTS #TotalClient_HK
select signup, COUNT(distinct CampaignCode)[TotalClient] into #TotalClient_HK from #SignupData_HK
GROUP BY Signup
 

DROP TABLE IF EXISTS #GrossSales_AvgDonationAmount_HK
select signup, COUNT(PackageValue)[GrossSales], SUM(PerMonth)/COUNT(*)[AverageDonationAmount] into #GrossSales_AvgDonationAmount_HK from #SignupData_HK
GROUP BY Signup
 

INSERT INTO #RAWData
select 'HK'[Country],A.Signup, TotalClient, D.Campaign, GrossSales, Approve, AverageDonationAmount, (Approve * AverageDonationAmount * 36)[FundRaise36Month] from #GrossSales_AvgDonationAmount_HK A
inner join #Approve_HK B ON  A.Signup = B.Signup
inner join #TotalClient_HK C ON  A.Signup = C.Signup
LEFT JOIN #ClientList_HK D ON A.Signup = D.Signup
ORDER BY Country, Signup
 

-- Taiwan
DROP TABLE IF EXISTS #SignupData_TW
select a.TxnId,DATEADD(month, DATEDIFF(month, 0, a.SignUpDate), 0) as Signup, b.PackageValue, c.Frequency, CAST(b.PackageValue/IIF(c.Frequency=0,1,c.Frequency) AS decimal(18,2))[PerMonth], a.CLient as CampaignCode into #SignupData_TW
from NewTWDB_PROD..VW_CHR_TXN a with (nolock)
inner join NewTWDB_PROD..Txn_Transaction_StatusSummary b with (nolock) on b.TxnId = a.TxnId and b.IsDeleted = 0 and b.Status = 'SubmissionDate'
inner join NewTWDB_PROD..MST_CHR_Package c with (nolock) on c.PackageId = b.PackageId and c.frequency > 0
where --a.IsDeleted = 0 and 
a.SignUpDate between @SignUpFrom and @SignUpTo
order by a.TxnId

DROP TABLE IF EXISTS #ClientDetail_TW
SELECT Signup, CampaignCode INTO #ClientDetail_TW   FROM #SignupData_TW
GROUP BY Signup, CampaignCode
ORDER BY Signup DESC, CampaignCode

DROP TABLE IF EXISTS #ClientList_TW
SELECT Signup, CAST(STRING_AGG( CampaignCode,',' )
WITHIN GROUP (order by CampaignCode) as NVARCHAR(MAX) )  as 'Campaign' INTO #ClientList_TW FROM #ClientDetail_TW
GROUP BY Signup 
  

DROP TABLE IF EXISTS #Approve_TW
select signup, COUNT(*)[Approve] into #Approve_TW from #SignupData_TW A
INNER JOIN NewTWDB_PROD..Txn_Transaction_StatusSummary b on b.TxnId = a.TxnId and b.IsDeleted = 0 and b.Status = 'ClientApproved'
GROUP BY Signup

DROP TABLE IF EXISTS #TotalClient_TW
select signup, COUNT(distinct CampaignCode)[TotalClient] into #TotalClient_TW from #SignupData_TW
GROUP BY Signup

DROP TABLE IF EXISTS #GrossSales_AvgDonationAmount_TW
select signup, COUNT(PackageValue)[GrossSales], SUM(PerMonth)/COUNT(*)[AverageDonationAmount] into #GrossSales_AvgDonationAmount_TW from #SignupData_TW
GROUP BY Signup


INSERT INTO #RAWData
select 'TW'[Country],A.Signup, TotalClient, D.Campaign, GrossSales, Approve, AverageDonationAmount, (Approve * AverageDonationAmount * 36)[FundRaise36Month] from #GrossSales_AvgDonationAmount_TW A
inner join #Approve_TW B ON A.Signup = B.Signup
inner join #TotalClient_TW C ON A.Signup = C.Signup
LEFT JOIN #ClientList_TW D ON A.Signup = D.Signup
ORDER BY Country, Signup



-- Singapore
DROP TABLE IF EXISTS #SignupData_SG
select a.TxnId,DATEADD(month, DATEDIFF(month, 0, a.SignUpDate), 0) as Signup, b.PackageValue, A.Frequency, CAST(b.PackageValue/IIF(A.Frequency=0,1,A.Frequency) AS decimal(18,2))[PerMonth], C.CampaignCode as  CampaignCode, ApprovedDate into #SignupData_SG
from NewSGDB_PROD..VW_CHR_TXN a with (nolock)
inner join NewSGDB_PROD..Txn_Transaction_StatusSummary b with (nolock) on b.TxnId = a.TxnId and b.IsDeleted = 0 and b.Status = 'SubmissionDate'
LEFT JOIN NewSGDB_PROD..VW_MST_CampaignList C ON A.CampaignCode = C.ID
where 
a.SignUpDate between @SignUpFrom and @SignUpTo 
order by a.TxnId

DROP TABLE IF EXISTS #ClientDetail_SG
SELECT Signup, CampaignCode INTO #ClientDetail_SG   FROM #SignupData_SG
GROUP BY Signup, CampaignCode
ORDER BY Signup DESC, CampaignCode

DROP TABLE IF EXISTS #ClientList_SG
SELECT Signup, CAST(STRING_AGG( CampaignCode,',' )
WITHIN GROUP (order by CampaignCode) as NVARCHAR(MAX) )  as 'Campaign' INTO #ClientList_SG FROM #ClientDetail_SG
GROUP BY Signup 
  
DROP TABLE IF EXISTS #Approve_SG
select signup, COUNT(*)[Approve] into #Approve_SG from #SignupData_SG A
WHERE ApprovedDate is not null
GROUP BY Signup

DROP TABLE IF EXISTS #TotalClient_SG
select signup, COUNT(distinct CampaignCode)[TotalClient] into #TotalClient_SG from #SignupData_SG
GROUP BY Signup

DROP TABLE IF EXISTS #GrossSales_AvgDonationAmount_SG
select signup, COUNT(PackageValue)[GrossSales], SUM(PerMonth)/COUNT(*)[AverageDonationAmount] into #GrossSales_AvgDonationAmount_SG from #SignupData_SG
GROUP BY Signup


INSERT INTO #RAWData
select 'SG'[Country],A.Signup, TotalClient, D.Campaign, GrossSales, Approve, AverageDonationAmount, (Approve * AverageDonationAmount * 36)[FundRaise36Month] 
from #GrossSales_AvgDonationAmount_SG A
inner join #Approve_SG B ON A.Signup = B.Signup
inner join #TotalClient_SG C ON A.Signup = C.Signup
LEFT JOIN #ClientList_SG D ON A.Signup = D.Signup
ORDER BY Country, Signup

----select 'SG'[Country],A.Signup, TotalClient, GrossSales, Approve, AverageDonationAmount, (Approve * AverageDonationAmount * 36)[FundRaise36Month] 
----from #GrossSales_AvgDonationAmount_SG A
----LEFT join #Approve_SG B ON A.Signup = B.Signup
----LEFT join #TotalClient_SG C ON A.Signup = C.Signup
----ORDER BY Country, Signup
  
-- Malaysia
DROP TABLE IF EXISTS #SignupData_MY
select a.TxnId,DATEADD(month, DATEDIFF(month, 0, a.SignUpDate), 0) as Signup, b.PackageValue, c.Frequency, CAST(b.PackageValue/IIF(c.Frequency=0,1,c.Frequency) AS decimal(18,2))[PerMonth], D.Campaign as  CampaignCode into #SignupData_MY
from NewMYDB_PROD..VW_CHR_TXN a with (nolock)
inner join NewMYDB_PROD..Txn_Transaction_StatusSummary b with (nolock) on b.TxnId = a.TxnId and b.IsDeleted = 0 and b.Status = 'SubmissionDate'
inner join NewMYDB_PROD..MST_CHR_Package c with (nolock) on c.PackageId = b.PackageId and c.frequency > 0
LEFT JOIN NewMYDB_PROD..VW_CampaignList D ON A.Client = D.ClientCode
where 
a.SignUpDate between @SignUpFrom and @SignUpTo 
order by a.TxnId

DROP TABLE IF EXISTS #ClientDetail_MY
SELECT Signup, CampaignCode INTO #ClientDetail_MY   FROM #SignupData_MY
GROUP BY Signup, CampaignCode
ORDER BY Signup DESC, CampaignCode

DROP TABLE IF EXISTS #ClientList_MY
SELECT Signup, CAST(STRING_AGG( CampaignCode,',' )
WITHIN GROUP (order by CampaignCode) as NVARCHAR(MAX) )  as 'Campaign' INTO #ClientList_MY FROM #ClientDetail_MY
GROUP BY Signup 
  

DROP TABLE IF EXISTS #Approve_MY
select signup, COUNT(*)[Approve] into #Approve_MY from #SignupData_MY A
INNER JOIN NewmyDB_PROD..Txn_Transaction_StatusSummary b on b.TxnId = a.TxnId and b.IsDeleted = 0 and b.Status = 'ClientApproved'
GROUP BY Signup

DROP TABLE IF EXISTS #TotalClient_MY
select signup, COUNT(distinct CampaignCode)[TotalClient] into #TotalClient_MY from #SignupData_MY
GROUP BY Signup

DROP TABLE IF EXISTS #GrossSales_AvgDonationAmount_MY
select signup, COUNT(PackageValue)[GrossSales], SUM(PerMonth)/COUNT(*)[AverageDonationAmount] into #GrossSales_AvgDonationAmount_MY from #SignupData_MY
GROUP BY Signup


INSERT INTO #RAWData
select 'MY'[Country],A.Signup, TotalClient, D.Campaign, GrossSales, Approve, AverageDonationAmount, (Approve * AverageDonationAmount * 36)[FundRaise36Month] 
from #GrossSales_AvgDonationAmount_MY A
inner join #Approve_MY B ON A.Signup = B.Signup
inner join #TotalClient_MY C ON A.Signup = C.Signup
LEFT JOIN #ClientList_MY D ON A.Signup = D.Signup
ORDER BY Country, Signup
 

DROP TABLE IF EXISTS #SignupData_KR
SELECT A.SerialNo, DATEADD(month, DATEDIFF(month, 0, A.SignUpDate), 0) as Signup, Amount, Frequency, 
CAST(A.Amount/IIF(Frequency=0,1,Frequency) AS decimal(18,2))[PerMonth], Campaign INTO #SignupData_KR
FROM Appco360_PROD..MainTable A where SignUpDate >=@SignUpFrom and TimesSubmitted = 1 and SignUpDate < = @SignUpTo
 
DROP TABLE IF EXISTS #Approved_KRTemp
SELECT SerialNo INTO #Approved_KRTemp FROm Appco360_PROD..MainTable A where AppcoStatus ='APPROVED' and SerialNo in (
SELECT SerialNo FROM #SignupData_KR
) GROUP BY SerialNo


DROP TABLE IF EXISTS #ClientDetail_KR
SELECT Signup, Campaign INTO #ClientDetail_KR  FROM #SignupData_KR
GROUP BY Signup, Campaign
ORDER BY Signup DESC, Campaign

DROP TABLE IF EXISTS #ClientList_KR
SELECT Signup, CAST(STRING_AGG( Campaign,',' )
WITHIN GROUP (order by Campaign) as NVARCHAR(MAX) )  as 'Campaign' INTO #ClientList_KR FROM #ClientDetail_KR
GROUP BY Signup 


DROP TABLE IF EXISTS #Approve_KR
select signup, COUNT(*)[Approve] into #Approve_KR from #SignupData_KR A
INNER JOIN #Approved_KRTemp b on b.SerialNo = a.SerialNo 
GROUP BY Signup

DROP TABLE IF EXISTS #TotalClient_KR
select signup, COUNT(distinct Campaign)[TotalClient] into #TotalClient_KR from #SignupData_KR
GROUP BY Signup


DROP TABLE IF EXISTS #GrossSales_AvgDonationAmount_KR
select signup, COUNT(Amount)[GrossSales], SUM(PerMonth)/COUNT(*)[AverageDonationAmount] into #GrossSales_AvgDonationAmount_KR from #SignupData_KR
GROUP BY Signup
 

INSERT INTO #RAWData
select 'KR'[Country],A.Signup, TotalClient,D.Campaign, GrossSales, Approve, AverageDonationAmount, (Approve * AverageDonationAmount * 36)[FundRaise36Month] 
from #GrossSales_AvgDonationAmount_KR A
LEFT join #Approve_KR B ON A.Signup = B.Signup
LEFT join #TotalClient_KR C ON A.Signup = C.Signup
LEFT JOIN #ClientList_KR D ON A.Signup = D.Signup
ORDER BY Country, Signup



SELECT * FROM #RAWData
ORDER BY Country, SignUpMonth

 


END
 

 --SP_RPT_RegionalBusiness_charity '2023-01-01','2023-04-21'