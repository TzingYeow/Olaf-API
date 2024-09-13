-- =============================================            
-- Author:  Teh Zhan Hui             
-- Create date: 2018-03-02            
-- Description: Get a charity weekending adjustment            
-- =============================================            
--EXEC SP_CH_RPT_IndiaHuddleRaw '2023-05-07', '2023-05-07'
CREATE PROCEDURE [dbo].[SP_CH_RPT_IndiaHuddleRaw]            
 @FromWE date , @ToWe  date
AS            
BEGIN            
 DROP TABLE IF EXISTS #RawLead
SELECT distinct CONVERT(DATE, SubmitDate, 103) as 'SubDate', NewIndiaDB_PROD.dbo.WeekedingDate(CONVERT(DATE, SubmitDate, 103)) as 'WeDate' , LeaDID
INTO #RawLead
FROM NewIndiaDB_PROD..Txn_Temp_ProLeadLeadFile_Archive
WHERE NewIndiaDB_PROD.dbo.WeekedingDate(CONVERT(DATE, SubmitDate, 103)) >= @FromWe and NewIndiaDB_PROD.dbo.WeekedingDate(CONVERT(DATE, SubmitDate, 103)) <=@ToWe

DROP TABLE IF EXISTS #UnSuccessFul
SELECT  distinct SerialNumber, FirstName, LastName INTO #UnSuccessFul  FROM NewIndiaDB_PROD..Txn_Temp_EnachBillDeskUnsuccessful_Archive
WHERE SerialNumber in (

SELECT LeadId FROM #RawLead
) and SerialNumber in (
SELECT LeaDID from #RawLead
) ORDER BY SerialNumber

SELECT * FROM #UnSuccessFul
 

 
DROP TABLE IF EXISTS #EnachApproved
SELECT DISTINCT REPLACE(SerialNumber,'PRO','') as SerialNumber, CONVERT(DATE, FirstPaymentDate, 103) as 'FirstDebit' INTO #EnachApproved 
FROM NewIndiaDB_PROD..Txn_Temp_EnachSuccessful_Archive
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
 
 SELECT 'Lead File' as 'Source', * FROM #RawLead
SELECT 'Unsuccessful File' as 'Source',* FROm #UnSuccessFul
SELECT 'Sucessfull File' as 'Source',* FROM #EnachApproved 
END     
     
