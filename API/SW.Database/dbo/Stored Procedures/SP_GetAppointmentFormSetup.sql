
-- =============================================
-- Author:		Asyraf Bakar
-- Create date: 18 October 2018
-- Description:	To get the list of missing information for all Independent Contractors
-- =============================================
--EXEC SP_GetAppointmentFormSetup
CREATE PROCEDURE [dbo].[SP_GetAppointmentFormSetup]
AS
BEGIN
	SET NOCOUNT ON; 
	 
	  
select CountryCode, code, name,
isnull(CASE WHEN d.TriggerPoint  = '|' THEN 'Not Setup' ELSE REPLACE(d.TriggerPoint,'|','-') END, 'Not Setup')  as 'SetupStatus'  INTO #Raw
from Mst_MarketingCompany m left join Mst_DigitalFormSettings d on m.MarketingCompanyId = d.MarketingCompanyId
and d.FormType = 'OR'  and m.IsActive = 1
WHERE m.IsActive = 1 and Code not in ( 'A','HQ','AP','00','SGX' ,'UIX')
Order by CountryCode , Code


IF OBJECT_ID('tempdb..#testtemp') IS NOT NULL Drop table #testtemp
DECLARE @cols AS NVARCHAR(MAX),
    @query  AS NVARCHAR(MAX);

	SELECT c.name into #testtemp
	FROM    
		sys.columns c
	INNER JOIN 
		sys.types t ON c.user_type_id = t.user_type_id
	WHERE
		c.object_id = OBJECT_ID('Mst_DigitalFormSettings') and t.name = 'bit'

	SET @cols = STUFF((SELECT distinct '+' + 'CAST(d.' + QUOTENAME(c.name) + 'as int)'
            FROM #testtemp c
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

		
set @query = 'select m.CountryCode, m.code as MCCode, m.name as MCName, 
isnull(CASE WHEN d.TriggerPoint  = ''|'' THEN ''Not Setup'' ELSE REPLACE(d.TriggerPoint,''|'',''-'') END, ''Not Setup'')  as ''SetupStatus'', d.FormType,
'+ @cols +' as ''Total Questions'', d.UpdatedBy 
from Mst_MarketingCompany m left join Mst_DigitalFormSettings d on m.MarketingCompanyId = d.MarketingCompanyId
WHERE m.IsActive = 1
Order by CountryCode , Code
'

CREATE TABLE #Temp
(
CountryCode   NVARCHAR(100),
MCCode   NVARCHAR(100),
MCName   NVARCHAR(100),
SetupStatus   NVARCHAR(100),
FormType   NVARCHAR(100),
TotalQuestion  INT,
UpdatedBy   NVARCHAR(100)
)

INSERT INTO #Temp
EXEC (@query)
 
 SELECT A.*, isnull(B.TotalQuestion,70) as 'FullFormQue', ISNULL(C.TotalQuestion,4) as 'SimpFormQue'
 , CASE WHEN B.UpdatedBy IS NULL THEN C.UpdatedBy ELSE B.UpdatedBy END  as 'UpdatedBy' 
  FROM #Raw A 
 Left jOIN (SELECT * FROM #Temp WHERE FormType = 'OR') B ON A.CountryCode = B.CountryCode and A.Code = B.MCCode
 Left jOIN (SELECT * FROM #Temp WHERE FormType = 'PR') C ON A.CountryCode = C.CountryCode and A.Code = C.MCCode
  ORDER BY A.CountryCode , A.Code
   
END
