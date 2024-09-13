
-- EXEC SP_SGG_Charity_LocationReports 
CREATE PROCEDURE [dbo].[SP_SGG_Charity_LocationReports]      
   
AS      
BEGIN

DECLARE @FromDate DATE
DECLARE @ToDate DATE
SET @FromDate = DATEADD(MONTH,-1,(SELECT DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0) ) )
SET @TODATE = (SELECT DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0) ) 

--SET @FromDate = DATEADD(MONTH,-1,(SELECT DATEADD(month, DATEDIFF(month, 0, '2021-11-01'), 0) ) )
--SET @TODATE = (SELECT DATEADD(month, DATEDIFF(month, 0, '2021-11-01'), 0) ) 

 

 
				IF OBJECT_ID('tempdb..#RawData') IS NOT NULL DROP TABLE #DistList
				select IDENTITY(INT,1,1) AS RUN_NO,CodeID,CodeName INTO #DistList from NEWTHDB_PROD..Mst_MasterCode where codetype ='CHTerritory'
	 

				DECLARE @vCount INT,
							@iCount INT
					SET @vCount = (SELECT MAX(RUN_NO) FROM #DistList)
					SET @iCount = 1

					DECLARE @NewCodeID as NVARCHAR(255)
					DECLARE @Codename as NVARCHAR(255)


					IF OBJECT_ID('tempdb..#LASTLIST') IS NOT NULL DROP TABLE #LASTLIST
					select CAST('' AS int) as 'column_id',CAST('' AS nvarchar(255)) as 'LOCATIONCODE',CAST('' AS nvarchar(255)) as 'value' INTO #LASTLIST 

					delete #LASTLIST

					WHILE(@iCount <= @vCount)
					BEGIN -- 1

						SELECT 
						@NewCodeID = CodeId,
						@Codename = CodeName
						FROM #DistList
						WHERE RUN_NO = @iCount


						INSERT INTO #LASTLIST(column_id,LOCATIONCODE,value)
						select * from NewTHDB_PROD.dbo.fn_split_string_to_column(@NewCodeID,@Codename,',')


				
					SET @iCount = @iCount + 1
					END -- 1

					select 'THAILAND' as 'COUNTRY',
					A.CampaignCode as 'CAMPAIGN',
					SerialNo as 'SERIALNO',
					CAST((CASE WHEN A.Channel <> 'EVE' THEN  A.EventTerritoryCode ELSE '' END) as NVARCHAR(20)) as 'LOCATION',
					(CASE WHEN A.Channel = 'EVE' THEN  A.EventTerritoryCode ELSE '' END) as 'EVENTTERRITORYCODE',
					--C.EventCode,
					 isnull(A.CodeRT,'') as 'TCRT',
					 isnull(D.value,'') as 'TCDISTRICT', 
					 isnull(B.value,'') as 'TCSTATE',
					MainProvince as 'PROVINCE',
					CASE WHEN A.Channel = 'EVE' THEN 'EVE' WHEN A.Channel = 'S' THEN 'STS' ELSE 'B2B' END as 'SALESCHANNEL',
					(CASE WHEN A.Channel = 'EVE' THEN C.SiteName ELSE '' END) as 'EVENTNAME'

					INTO #RawData 
					 from NewTHDB_PROD..VW_CHR_TXN A
					 LEFT OUTER JOIN #LASTLIST B on A.EventTerritoryCode = B.LOCATIONCODE AND B.column_id = 1
					  LEFT OUTER JOIN #LASTLIST D on A.EventTerritoryCode = D.LOCATIONCODE AND D.column_id = 2
					 LEFT OUTER JOIN NewTHDB_PROD..VW_MST_EventCodes C on A.EventTerritoryCode = C.EventCode 
					 INNER JOIN NewTHDB_PROD..Txn_Transaction_StatusSummary E on A.TxnId = E.TxnId AND E.IsDeleted = 0 and E.Status ='SubmissionDate'
					WHERE A.isdeleted = 0 
					and CAST(A.BankSubDate as date) >=@FromDate and CAST(A.BankSubDate as date) <=@ToDate
					order by BankSubDate

					INSERT INTO #RawData 
					select  'Malaysia' as 'COUNTRY', B.Campaign as 'CAMPAIGN', SerialNumber as 'SERIAL NO', Case WHEN A.ChannelId <> 'EVENTS' THEN A.EventCode ELSE '' END as 'LOCATION',
					CASE WHEN A.ChannelId = 'EVENTS' THEN A.EventCode ELSE '' END as 'EVENTTERRITORYCODE','' as 'TCRT', '' as 'TCDISTRICT', '' as 'TCSTATE','' as 'PROVINCE', CASE WHEN A.ChannelId = 'EVENTS' THEN 'EVE' WHEN A.ChannelId = 'S' THEN 'STS' WHEN A.ChannelId = 'TRUCK' THEN 'TRK' WHEN A.ChannelId like 'DM%' THEN 'TRK' WHEN A.ChannelId like 'MIS%' THEN 'MIS' ELSE A.ChannelId END as  'SalesChannel', C.SiteName as 'EventName' from 
					NewMYDB_PROD..VW_CHR_TXN A LEFT JOIN NewMYDB_PROD..VW_CampaignList B ON A.Campaign = B.ID
					LEFT JOIN NewMYDB_PROD..VW_TKF_MalaysiaEventCodes C ON A.EventCode = C.LocationCode
					WHERE Status not in ('AC','MC','N')  
					and A.TxnID in (SELECT TxnID FROM NewMYDB_PROD..TXN_TRANSACTION_statussummary where CAST(StatusDate as date) >= @FromDate and CAST(StatusDate as date) <= @ToDate and Isdeleted = 0 and Status = 'SGSubDate')  
					UPDATE #RawData SET CAMPAIGN = 'YCK' where COUNTRY = 'Malaysia' and CAMPAIGN ='YAYASAN CHOW KIT'
					SELECT * FROM #RawData Order by COUNTRY
END

--EXEC SP_SGG_Charity_LocationReports 