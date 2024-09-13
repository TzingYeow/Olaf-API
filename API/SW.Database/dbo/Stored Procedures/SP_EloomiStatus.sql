-- =============================================          
-- Author:  Tan Siuk Ching          
-- Create date: 05/03/2021          
-- Description: EXEC [SP_PushicStatusMail]       
--SELECT * FROM TXN_EmailQueue  
-- =============================================          
CREATE PROCEDURE [dbo].[SP_EloomiStatus]           
 -- Add the parameters for the stored procedure here  
AS          
BEGIN          
 -- SET NOCOUNT ON added to prevent extra result sets from          
 -- interfering with SELECT statements.          
 SET NOCOUNT ON;          
       
 DECLARE @LastDataPull as DATETIME
DROP TABLE IF EXISTS #TempResult
CREATE TABLE #TempResult 
(
CountryCode NVARCHAR(2),
TotalCOunt  INT
)


DROP TABLE IF EXISTS #EloomiUser
SELECT A.*, 'ZZ' as 'CountryCode', username as 'EloomiUserName' INTO #EloomiUser FROM [dbo].Eloomi_Users_Data A
 where ISNULL(username,'') not like '%@%' and ISNULL(username,'')  <> '' and id in (
 SELECT MAX(ID) FROM Eloomi_Users_Data WHERE SUBSTRING(username,1,2) in ('TH','KR','HK','MY','SG','TW')
 and LEN(username) >=6 and ISNULL(username,'') not like '%@%' and ISNULL(username,'')  <> ''
 GROUP BY SUBSTRING(username,3,LEN(username)-2)
  UNION
 SELECT MAX(ID) FROM Eloomi_Users_Data WHERE username in (SELECT BadgeNo FROM Mst_IndependentContractor where Status ='Active')
 GROUP BY username
 )
 UPDATE  #EloomiUser SET CountryCode = SUBSTRING(username,1,2),  username = SUBSTRING(username,3,LEN(username)-2) WHERE SUBSTRING(username,1,2) in ('TH','KR','HK','MY','SG','TW')
 and LEN(username) >=8

DROP TABLE IF EXISTS #BAList
SELECT DISTINCT A.id, B.IndependentContractorId, C.CountryCode INTO #BAList 
FROM #EloomiUser A 
LEFT JOIN Mst_IndependentContractor B ON A.username = B.BadgeNo
LEFT JOIN Mst_MarketingCompany C ON B.MarketingCompanyId = C.MarketingCompanyId
WHERE B.IndependentContractorId is not null-- and B.Status ='Active'

SET @LastDataPull = (SELECT MAX(data_inserted_at) FROM Eloomi_Course_Participants_Data)

INSERT INTO #TempResult
SELECT E.CountryCode,COUNT(*) FROM  Eloomi_Course_Participants_Data A 
LEFT JOIN #EloomiUser B ON A.user_id = B.id 
LEFT JOIN #BAList C ON B.id = C.id
LEFT JOIN Mst_IndependentContractor D ON C.IndependentContractorId = D.IndependentContractorId
LEFT JOIN Mst_MarketingCompany E ON E.MarketingCompanyId = D.MarketingCompanyId
where CAST(completed_at as date) >= DATEADD(day, -7, CAST(GETDATE() as date))
GROUP BY E.CountryCode

SELECT @LastDataPull
SELECT * FROM #TempResult where CountryCode is not null
  

   
DECLARE @body_content nvarchar(max);

SET @body_content = N'
<style>
table.GeneratedTable {
  width: 100%;
  background-color: #ffffff;
  border-collapse: collapse;
  border-width: 2px;
  border-color: #EB202A;
  border-style: solid;
  color: #000000;
}

table.GeneratedTable td, table.GeneratedTable th {
  border-width: 2px;
  border-color: #EB202A;
  border-style: solid;
  padding: 3px;
}

table.GeneratedTable thead {
  background-color: #EB202A;
}
</style>

Dear <b>ALL</b>, <br><br> Following are the latest data pulled from Eloomi. <br><br>
 

<table class="GeneratedTable">
  <thead>
    <tr>
      <th style="text-align:left"> Country</th> 
      <th style="text-align:left"> Last Refresh</th> 
      <th style="text-align:left"> Course Completed</th>
    </tr>
  </thead>
  <tbody>' +
CAST(
        (SELECT td = CountryCode, '', 
				td = FORMAT(@LastDataPull,'dd-MMM-yyyy'), '',
                td = CAST(CAST(TotalCOunt as decimal(18,0)) as NVARCHAR) + '', ''
        FROM #TempResult  WHERE CountryCode is not null ORDER BY CountryCode
        FOR XML PATH('tr'), TYPE   
        ) AS nvarchar(max)
    ) +
  N'</tbody>
</table>

<br><br>THIS IS AN AUTOMATED MESSAGE - PLEASE DO NOT REPLY DIRECTLY TO THIS EMAIL.</b>';

SET @body_content = REPLACE(@body_content,'<td>RRJC','<td style="text-align:right">')
SELECT @body_content

 
INSERT INTO TXN_EmailQueue
SELECT FORMAT(GETDATE(),'yyyyMMddHHmmss') + 'EloomiCheck','EloomiCheck','karen.lim@salesworks.asia;adilla.aziz@salesworks.asia;','','','Eloomi Data Pull Summary',@body_content, '',GETDATE(),'Schedular'
 
    
        
END    
