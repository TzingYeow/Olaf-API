--3 NULL
--=============================
CREATE PROCEDURE [dbo].[SP_RegionalSales]   
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


DROP TABLE IF EXISTS #ChannelName
CREATE TABLE #ChannelName(
	Country NVARCHAR(2),
	Channel NVARCHAR(50),
	CustomChannel NVARCHAR(50)
)

INSERT INTO #ChannelName SELECT 'MY','STREET','STR'
INSERT INTO #ChannelName SELECT 'MY','S','STR'
INSERT INTO #ChannelName SELECT 'MY','EVENTS','EVE'
INSERT INTO #ChannelName SELECT 'MY','TRUCK','TRK'
INSERT INTO #ChannelName SELECT 'MY','TRUCK','TRK'
INSERT INTO #ChannelName SELECT 'MY','TRUCK','TRK'
INSERT INTO #ChannelName SELECT 'TH','S','STR'
INSERT INTO #ChannelName SELECT 'TH','TEL99','TEL'
INSERT INTO #ChannelName SELECT 'KR','STREET','STR'
INSERT INTO #ChannelName SELECT 'KR','EVENTS','EVE'
INSERT INTO #ChannelName SELECT 'HK','S','STR'
INSERT INTO #ChannelName SELECT 'ID','EVENTS','EVE'
INSERT INTO #ChannelName SELECT 'ID','S','STR'

DROP TABLE IF EXISTS #PaymentTypeName
CREATE TABLE #PaymentTypeName(
	Country NVARCHAR(2),
	PaymentType NVARCHAR(50), 
	CustomDesc NVARCHAR(50)
)


INSERT INTO #PaymentTypeName SELECT 'MY','CASH','CS'
INSERT INTO #PaymentTypeName SELECT 'MY','CHQ','CQ'
INSERT INTO #PaymentTypeName SELECT 'MY','Credit Card','CC'
INSERT INTO #PaymentTypeName SELECT 'MY','Debit Card','DC'
INSERT INTO #PaymentTypeName SELECT 'TW','Credit Card','CC'
INSERT INTO #PaymentTypeName SELECT 'TW','Debit Card','DC'
INSERT INTO #PaymentTypeName SELECT 'SG','CHQ','CQ'
INSERT INTO #PaymentTypeName SELECT 'HK','other','OR'
INSERT INTO #PaymentTypeName SELECT 'ID','CASH','OR'
INSERT INTO #PaymentTypeName SELECT 'ID','CHQ','CQ'


-----------------------------------------------------------------------------------------------------------------
-- MALAYSIA (START)
-----------------------------------------------------------------------------------------------------------------
  
DROP TABLE IF EXISTS #RawMY
SELECT TXNID INTO #RawMY FROM NewMYDB_PROD..VW_CH_SS WHERE status = 'SubmissionDate' and StatusDate >='2022-01-01'

DELETE FROM TXN_RegionalSalesSummary where CountryCode = 'MY'

INSERT INTO dbo.TXN_RegionalSalesSummary
(GUID,CountryCode,TxnID,Client,Campaign,Division,MOCode,BadgeNo,LiveStatus,Status,StatusDate,StatusWeDate,DonationAmount
,Frequency,SignUpDate,SignUpWeDate,SubmissionDate,SubmissionWeDate,PaymentMode,Channel,TeritoryCode,EventCode,DateOfBirth,IsUnderAge
,Age,IsDobo,DoboType,OwnerStroke,ICStroke,IsDeleted,Qty,RejQty,ResubQty,TxnCreatedDate,TCV)
SELECT  NEWID(), 'MY' as 'Country', A.TXNID ,  C.CampaignId,  C.CampaignId, C.DivisionId, A.MOCode, A.BadgeID, A.LiveStatus, ISNULL(D.CustomDesc, A.Status) as 'Status', A.StatusDate, A.StatusWEDate, 
A.PackageValue, A.Frequency, CAST(B.TxnDate as date) as 'SignupDate', NewMYDB_PROD.dbo.GetWeekendingDate(B.TxnDate),
B.Submissiondate, NewMYDB_PROD.dbo.GetWeekendingDate(B.SubmissionDate), ISNULL(I.CustomDesc, A.PaymentMode), ISNULL(E.CustomChannel,A.ChannelId),
B.EventCode,J.SiteName as 'EventName', B.DateOfBirth, CASE WHEN (CAST(FORMAT(B.TxnDate,'yyyyMMdd') as bigint) - cast(FORMAT(CAST(B.DateOfBirth as date),'yyyyMMdd') as bigint))/10000   < 26 THEN 'Y' ELSE 'N' END as 'Underage',
(CAST(FORMAT(B.TxnDate,'yyyyMMdd') as bigint) - cast(FORMAT(CAST(B.DateOfBirth as date),'yyyyMMdd') as bigint))/10000 as 'Age', B.DOBO, B.DoboType,
 A.MSFID - A.ICStroke, A.ICStroke, 'N',NULL, NULL,NULL, A.CreatedDate, A.PackageValue
FROM NewMYDB_PROD..VW_CH_SS A LEFT JOIN NewMYDB_PROD..VW_CHR_TXN B ON A.TXNID = B.TXNID 
LEFT JOIN Mst_Campaign C ON A.Client = C.ClientCode 
LEFT JOIN #StatusName D ON A.status = D.StatusCode and D.Country = 'MY'
LEFT JOIN #ChannelName E ON E.Country = 'MY' and A.ChannelId = E.Channel
LEFT JOIN #PaymentTypeName I ON  I.PaymentType = A.PaymentMode  and I.Country = 'MY'
LEFT JOIN NewMYDB_PROD..VW_TKF_MalaysiaEventCodes J ON B.EventCode = J.LocationCode
WHERE A.IsDeleted = 0 and A.TXNID IN (SELECT TXNID FROM #RawMY) AND A.Status not in ('ClientClawBack60','ClientClawBack90','SGSubDate')
order by A.TXNID



INSERT INTO dbo.TXN_RegionalSalesSummary
(GUID,CountryCode,TxnID,Client,Campaign,Division,MOCode,BadgeNo,LiveStatus,Status,StatusDate,StatusWeDate,DonationAmount
,Frequency,SignUpDate,SignUpWeDate,SubmissionDate,SubmissionWeDate,PaymentMode,Channel,TeritoryCode,EventCode,DateOfBirth,IsUnderAge
,Age,IsDobo,DoboType,OwnerStroke,ICStroke,IsDeleted,Qty,RejQty,ResubQty,TxnCreatedDate,TCV)
SELECT  NEWID(), 'MY' as 'CountryCode', A.RowId , 52, 52, 2, OfficeId_H, ICBadgeNo_H, 'MS', A.Status,  A.StatusDate, A.StatusWE, C.Amount, 1, 
CAST( B.SignUpDateTime as date) as 'SignUp', dbo.GetWeekendingDate(CAST( B.SignUpDateTime as date)) as 'SignupWe', B.SubmissionDate, B.SubmissionWEDate,
ISNULL(I.CustomDesc, F.CodeName) as 'PaymentMode', ISNULL(H.CustomChannel,G.CodeName), B.TerritoryCode, B.EventCode,
CAST(B.Main_DateOfBirth as Date), 'N',(CAST(FORMAT(B.SignUpDateTime,'yyyyMMdd') as bigint) - cast(FORMAT(CAST(B.Main_DateOfBirth as date),'yyyyMMdd') as bigint))/10000 as 'Age',
'N', '',D.OwnerStroke, D.ICStroke,'N',NULL, NULL,NULL, A.CreatedDate,C.Amount
FROM NewMYDB_PROD..Tbl_TKF_Maintable_StatusSummary A 
LEFT JOIN NewMYDB_PROD..Tbl_TKF_Maintable B ON A.RowId = B.RowId 
LEFT JOIN NewMYDB_PROD..VW_TKF_PackagesName C ON B.MonthlyPremiumId = C.Id
LEFT JOIN NewMYDB_PROD..MST_MSF D ON A.MSFID_H = D.ID
LEFT JOIN NewMYDB_PROD..Tbl_MasterCode E ON B.AppcoStatusId = E.Code and E.CodeType = 'Status'
LEFT JOIN NewMYDB_PROD..Tbl_MasterCode F ON B.CardTransTypeId = F.ID and F.CodeType = 'Card'
LEFT JOIN NewMYDB_PROD..Tbl_MasterCode G ON A.ChannelId_H = G.ID and G.CodeType = 'Channel'
LEFT JOIN #ChannelName H ON H.Country = 'MY' and G.CodeName = H.Channel
LEFT JOIN #PaymentTypeName I ON  I.PaymentType = F.CodeName and I.Country = 'MY'
where A.StatusWE >= '2022-01-01' and A.IsDeleted = 0
and A.Status in ('SubmissionDate','ReSubDate','ClientReSubDate','ClientRejectDate','RejectDate')  and A.IsDeleted = 0


INSERT INTO dbo.TXN_RegionalSalesSummary
(GUID,CountryCode,TxnID,Client,Campaign,Division,MOCode,BadgeNo,LiveStatus,Status,StatusDate,StatusWeDate,DonationAmount
,Frequency,SignUpDate,SignUpWeDate,SubmissionDate,SubmissionWeDate,PaymentMode,Channel,TeritoryCode,EventCode,DateOfBirth,IsUnderAge
,Age,IsDobo,DoboType,OwnerStroke,ICStroke,IsDeleted,Qty,RejQty,ResubQty,TxnCreatedDate,TCV)
SELECT  NEWID(), 'MY', A.Trxn_No, B.ID, B.id, B.Division, A.MO_Code, A.IC_Code,'AP', 'SubmissionDate', A.MO_Sub_Date, A.MO_Sub_Week, A.TTL_NettPrice, 0, 
CAST(A.Trxn_Date as date), dbo.GetWeekendingDate(A.Trxn_Date), A.MO_Sub_Date, A.MO_Sub_Week, ISNULL(E.CustomDesc,A.PaymentType) , ISNULL(H.CustomChannel,A.ChannelType ), 
A.locationCode, J.SiteName, NULL,NULL,NULL, NULL,NULL, NULL,SUM(TTL_MSF), 'N', SUM(Purchase_Qty), NULL,NULL, A.CreatedDate,A.TTL_NettPrice FROM NewMYDB_PROD..TXN_Lif_SalesHeader A 
LEFT JOIN NewMYDB_PROD..TXN_Lif_Sales_Detail C ON A.Trxn_No = C.Trxn_No and C.Purchase_Qty > 0
LEFT JOIN NewMYDB_PROD..VW_CampaignList B ON A.PRDCAT_Code = B.ClientCode
LEFT JOIN #PaymentTypeName E ON A.PaymentType = E.PaymentType and E.Country = 'MY'
LEFT JOIN #ChannelName H ON H.Country = 'MY' and A.ChannelType = H.Channel
LEFT JOIN NewMYDB_PROD..VW_TKF_MalaysiaEventCodes J ON A.EventCode = J.LocationCode
 where MO_Sub_Week > '2022-01-01' and DE_By is not null and A.IsDeleted = 0 and C.IsDeleted = 0
 GROUP BY   A.Trxn_No, B.ID,  B.Division, A.MO_Code, A.IC_Code, A.MO_Sub_Date, A.MO_Sub_Week, A.TTL_NettPrice,  
CAST(A.Trxn_Date as date), dbo.GetWeekendingDate(A.Trxn_Date), A.MO_Sub_Date, A.MO_Sub_Week, ISNULL(E.CustomDesc,A.PaymentType),ISNULL(H.CustomChannel,A.ChannelType ),A.locationCode, J.SiteName , A.CreatedDate
 
 
-----------------------------------------------------------------------------------------------------------------
-- MALAYSIA (END)
-----------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------
-- TAIWAN (START)
-----------------------------------------------------------------------------------------------------------------


DROP TABLE IF EXISTS #RawTW
SELECT TXNID INTO #RawTW FROM NewTWDB_PROD..VW_CH_SS WHERE status = 'SubmissionDate' and StatusDate >='2022-01-01' 

DELETE FROM TXN_RegionalSalesSummary where CountryCode = 'TW'
INSERT INTO dbo.TXN_RegionalSalesSummary
(GUID,CountryCode,TxnID,Client,Campaign,Division,MOCode,BadgeNo,LiveStatus,Status,StatusDate,StatusWeDate,DonationAmount
,Frequency,SignUpDate,SignUpWeDate,SubmissionDate,SubmissionWeDate,PaymentMode,Channel,TeritoryCode,EventCode,DateOfBirth,IsUnderAge
,Age,IsDobo,DoboType,OwnerStroke,ICStroke,IsDeleted,Qty,RejQty,ResubQty,TxnCreatedDate,TCV)
SELECT  NEWID(), 'TW' as 'Country', A.TXNID ,  C.CampaignId,  C.CampaignId, C.DivisionId, A.MOCode, A.BadgeID, A.LiveStatus, ISNULL(D.CustomDesc, A.Status) as 'Status', A.StatusDate, A.StatusWEDate, 
A.PackageValue, E.Frequency, CAST(B.TxnDate as date) as 'SignupDate', NewTWDB_PROD.dbo.GetWeekendingDate(B.TxnDate),
B.Submissiondate, NewMYDB_PROD.dbo.GetWeekendingDate(B.SubmissionDate), ISNULL(I.CustomDesc, A.PaymentMode) as 'PaymentMode', ISNULL(H.CustomChannel,A.ChannelId) as 'Channel',
CASE  WHEN channel not in ('EVE') THEN J.CodeName ELSE '' END,CASE  WHEN channel in ('EVE') THEN J.CodeName ELSE '' END, B.DateOfBirth, CASE WHEN (CAST(FORMAT(B.TxnDate,'yyyyMMdd') as bigint) - cast(FORMAT(CAST(B.DateOfBirth as date),'yyyyMMdd') as bigint))/10000   < 26 THEN 'Y' ELSE 'N' END as 'Underage',
(CAST(FORMAT(B.TxnDate,'yyyyMMdd') as bigint) - cast(FORMAT(CAST(B.DateOfBirth as date),'yyyyMMdd') as bigint))/10000 as 'Age',  B.DOBO, F.CodeName as 'DoboType',
 A.MSFID - A.ICStroke, A.ICStroke, 'N',NULL, NULL,NULL, A.CreatedDate,A.PackageValue
FROM NewTWDB_PROD..VW_CH_SS A LEFT JOIN NewTWDB_PROD..VW_CHR_TXN B ON A.TXNID = B.TXNID 
LEFT JOIN NewTWDB_PROD..MST_CHR_Package E ON A.PackageId = E.PackageID
LEFT JOIN Mst_Campaign C ON A.Client = C.ClientCode 
LEFT JOIN #StatusName D ON A.status = D.StatusCode and D.Country = 'TW'
LEFT JOIN NewTWDB_PROD..Tbl_MasterCode F ON B.DoboType = F.ID and F.CodeType = 'DOBOType'
LEFT JOIN #ChannelName H ON H.Country = 'TW' and A.ChannelId = H.Channel
LEFT JOIN #PaymentTypeName I ON  I.PaymentType = A.PaymentMode and I.Country = 'TW'
LEFT JOIN NewTWDB_PROD..Tbl_MasterCode J ON B.LocationCode = J.Code and J.CodeType = 'CHLocationCode'
WHERE A.IsDeleted = 0 and A.TXNID IN (SELECT TXNID FROM #RawTW) AND A.Status not in ('OfficeRejectDate','BanknStatus_61', 'ClientClawBack90','SGSubDate','BanknStatus_66','BanknStatus_59')

order by A.TXNID
  
-----------------------------------------------------------------------------------------------------------------
-- TAIWAN (END)
-----------------------------------------------------------------------------------------------------------------
 

-----------------------------------------------------------------------------------------------------------------
-- Singapore (START)
-----------------------------------------------------------------------------------------------------------------
 
DROP TABLE IF EXISTS #RawSG
SELECT TXNID INTO #RawSG FROM NewSGDB_PROD..VW_CH_SS WHERE status = 'SubmissionDate' and StatusDate >='2022-01-01' 

DELETE FROM TXN_RegionalSalesSummary where CountryCode = 'SG'
INSERT INTO dbo.TXN_RegionalSalesSummary
(GUID,CountryCode,TxnID,Client,Campaign,Division,MOCode,BadgeNo,LiveStatus,Status,StatusDate,StatusWeDate,DonationAmount
,Frequency,SignUpDate,SignUpWeDate,SubmissionDate,SubmissionWeDate,PaymentMode,Channel,TeritoryCode,EventCode,DateOfBirth,IsUnderAge
,Age,IsDobo,DoboType,OwnerStroke,ICStroke,IsDeleted,Qty,RejQty,ResubQty,TxnCreatedDate,TCV)
SELECT   NEWID(), 'SG' as 'Country', A.TXNID ,  C.CampaignId,  C.CampaignId, C.DivisionId, A.MOCode, A.BadgeNo, A.LiveStatus, ISNULL(D.CustomDesc, A.Status) as 'Status', A.StatusDate, A.StatusWEDate, 
A.PackageValue, A.Frequency, CAST(B.TxnDate as date) as 'SignupDate', NewSGDB_PROD.dbo.WeekedingDate(B.TxnDate),
B.MoSubmissionDate, NewSGDB_PROD.dbo.WeekedingDate(B.MoSubmissionDate), ISNULL(I.CustomDesc, A.PaymentMode) as 'PaymentMode', ISNULL(H.CustomChannel,A.Channel) as 'Channel',
CASE WHEN B.Channel NOT IN('EVE') THEN ISNULL(J.Description,B.Location) ELSE '' END  ,CASE WHEN B.Channel  IN('EVE') THEN ISNULL(J.Description,B.Location) ELSE '' END , B.MainBirthday, CASE WHEN (CAST(FORMAT(B.TxnDate,'yyyyMMdd') as bigint) - cast(FORMAT(CAST(B.MainBirthday as date),'yyyyMMdd') as bigint))/10000   < 26 THEN 'Y' ELSE 'N' END as 'Underage',
(CAST(FORMAT(B.TxnDate,'yyyyMMdd') as bigint) - cast(FORMAT(CAST(B.MainBirthday as date),'yyyyMMdd') as bigint))/10000 as 'Age',  '' , B.DOBOType as 'DoboType',
 A.MSFID - A.ICStrokeValue, A.ICStrokeValue, 'N',NULL, NULL,NULL, A.CreatedDate,A.PackageValue
FROM NewSGDB_PROD..VW_CH_SS A LEFT JOIN NewSGDB_PROD..VW_CHR_TXN B ON A.TXNID = B.TXNID  
LEFT JOIN Mst_Campaign C ON A.CampaignCode = C.CampaignId 
LEFT JOIN #StatusName D ON A.status = D.StatusCode and D.Country = 'SG' 
LEFT JOIN #ChannelName H ON H.Country = 'SG' and A.Channel = H.Channel
LEFT JOIN #PaymentTypeName I ON  I.PaymentType = A.PaymentMode  and I.Country = 'SG'
LEFT JOIN NewSGDB_PROD..Mst_Locations J ON B.Location = J.Code and J.IsDeleted = 0 and J.IsActive = 1

WHERE A.IsDeleted = 0 and A.TXNID IN (SELECT TXNID FROM #RawSG) AND A.Status not in ('OfficeRejectDate','BanknStatus_61', 'ClientClawBack90','SGSubDate','BanknStatus_66','BanknStatus_59','PendingCheque')
 
order by A.TXNID

INSERT INTO dbo.TXN_RegionalSalesSummary
(GUID,CountryCode,TxnID,Client,Campaign,Division,MOCode,BadgeNo,LiveStatus,Status,StatusDate,StatusWeDate,DonationAmount
,Frequency,SignUpDate,SignUpWeDate,SubmissionDate,SubmissionWeDate,PaymentMode,Channel,TeritoryCode,EventCode,DateOfBirth,IsUnderAge
,Age,IsDobo,DoboType,OwnerStroke,ICStroke,IsDeleted,Qty,RejQty,ResubQty,TxnCreatedDate, TCV)
SELECT 
NEWID(), 'SG' as 'Country',A.TxnID, '1125' as 'Client','1125' as 'Campaign', 7 as 'Division', A.MOCode, A.BadgeNo,
E.SalesworksStatus as 'LiveStatus',CASE WHEN C.Status = 'PENDING' THEN 'SubmissionDate' WHEN C.Status = 'SALESWORKSREJECT' THEN 'RejectDate' 
WHEN C.Status = 'CANCELLATIONREJECT' THEN 'RejectDate'  WHEN C.Status = 'INVOICED' THEN 'ClientApproved'
WHEN C.Status = 'RESUB' THEN 'ReSubmissionDate' ELSE C.Status END, C.StatusDate, C.StatusWEDate, B.TCV as 'DonationAmount', NULL as'Frequency', D.SignUpDate,
NewSGDB_PROD.dbo.WeekedingDate(D.SignUpDate) as 'SignupWeDate', E.SubmissionDate, E.SubmissionWEDate, NULL as 'PaymentMode', 
NULL as 'Channel',NULL as 'TerritoryCode',NULL as 'EventCode',  NULL as DateOFBirth,NULL as 'IsUnderAge',NULL as 'Age',NULL as 'IsDOBO',NULL as 'DoboType', 
CAST(CAST((TCV * Payout_MSF ) / 100 as decimal(18,2)) as decimal(18,4)) - B.Total_Payout_BA as 'Owner' , B.Total_Payout_BA 
, 'N' as 'IsDeleted',NULL as 'Qty',NULL as 'RejQty',NULL as 'ResubQty', C.CreatedDate , B.TCV  
FROM NewSGDB_PROD..TXN_Starhub_Transaction_StatusSummary AS A
INNER JOIN NewSGDB_PROD..TXN_Starhub_TransStatusSummary_Product AS B ON A.SummaryID = B.SummaryID AND 
														A.TxnID = B.TxnID
INNER JOIN NewSGDB_PROD..TXN_Starhub_TransStatusSummary_Status AS C ON A.SummaryID = C.SummaryID AND 
														A.TxnID = C.TxnID
LEFT JOIN NewSGDB_PROD..TXN_Starhub_Transaction   D ON A.TxnID = D.TxnID 
LEFT JOIN NewSGDB_PROD..TXN_Starhub_Transaction_Status E ON A.TxnID =E.TxnID  
WHERE  C.StatusWEDate > '2023-01-01' 
	 
	  

 

-----------------------------------------------------------------------------------------------------------------
-- Singapore (END)
-----------------------------------------------------------------------------------------------------------------

 
-----------------------------------------------------------------------------------------------------------------
-- INDONESIA (START)
-----------------------------------------------------------------------------------------------------------------

 
DROP TABLE IF EXISTS #RAWINDO
SELECT TXNID INTO #RAWINDO FROM NewIndoDB_PROD..VW_CH_SS WHERE status = 'SubmissionDate' and StatusDate >='2022-01-01'

  DELETE FROM TXN_RegionalSalesSummary where CountryCode = 'ID'
INSERT INTO dbo.TXN_RegionalSalesSummary
(GUID,CountryCode,TxnID,Client,Campaign,Division,MOCode,BadgeNo,LiveStatus,Status,StatusDate,StatusWeDate,DonationAmount
,Frequency,SignUpDate,SignUpWeDate,SubmissionDate,SubmissionWeDate,PaymentMode,Channel,TeritoryCode,EventCode,DateOfBirth,IsUnderAge
,Age,IsDobo,DoboType,OwnerStroke,ICStroke,IsDeleted,Qty,RejQty,ResubQty,TxnCreatedDate, TCV)
SELECT  NEWID(), 'ID' as 'Country', A.TXNID ,  C.CampaignId,  C.CampaignId, C.DivisionId, A.MOCode, A.BadgeID, A.LiveStatus, ISNULL(D.CustomDesc, A.Status) as 'Status', A.StatusDate, A.StatusWEDate, 
A.PackageValue, A.Frequency, CAST(B.SignupDate as date) as 'SignupDate', NewMYDB_PROD.dbo.GetWeekendingDate(B.SubmissionDate),
B.Submissiondate, NewIndoDB_PROD.dbo.GetWeekendingDate(B.SubmissionDate), ISNULL(J.CustomDesc, I.Code) as 'PaymentMode', ISNULL(H.CustomChannel,F.Code) as 'Channel',
'','', B.DateOfBirth, CASE WHEN (CAST(FORMAT(B.SignupDate,'yyyyMMdd') as bigint) - cast(FORMAT(CAST(B.DateOfBirth as date),'yyyyMMdd') as bigint))/10000   < 26 THEN 'Y' ELSE 'N' END as 'Underage',
(CAST(FORMAT(B.SignupDate,'yyyyMMdd') as bigint) - cast(FORMAT(CAST(B.DateOfBirth as date),'yyyyMMdd') as bigint))/10000 as 'Age', B.DOBO, B.DoboType,
 A.MSFID - A.ICStroke, A.ICStroke, 'N',NULL, NULL,NULL, A.CreatedDate,A.PackageValue
FROM NewIndoDB_PROD..VW_CH_SS A LEFT JOIN NewIndoDB_PROD..VW_CHR_TXN B ON A.TXNID = B.TXNID 
LEFT JOIN Mst_Campaign C ON A.CampaignCode = C.CampaignName and C.CountryCode = 'ID'
LEFT JOIN #StatusName D ON A.status = D.StatusCode and D.Country = 'ID'
LEFT JOIn NewIndoDB_PROD..TBL_Mastercode F ON F.CodeType='CHChannelCode' and A.ChannelId = F.ID 
LEFT JOIN #ChannelName H ON H.Country = 'ID' and F.Code = H.Channel
LEFT JOIN NewIndoDB_PROD..TBL_Mastercode I ON I.Id = A.PaymentMode
LEFT JOIN #PaymentTypeName J ON  J.PaymentType = I.Code  and J.Country = 'ID'
WHERE A.IsDeleted = 0 and A.TXNID IN (SELECT TXNID FROM #RAWINDO) AND A.Status not in ('ClientClawBack60','ClientClawBack90','SGSubDate')
order by A.TXNID
  
 -----------------------------------------------------------------------------------------------------------------
-- INDONESIA (END)
-----------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------
-- THAILAND (START)
-----------------------------------------------------------------------------------------------------------------


--IF OBJECT_ID('tempdb..#RawData') IS NOT NULL DROP TABLE #DistList
--select IDENTITY(INT,1,1) AS RUN_NO,CodeID,CodeName INTO #DistList from NEWTHDB_PROD..Mst_MasterCode where codetype ='CHTerritory'
	 

--	DECLARE @vCount INT,
--	@iCount INT
--	SET @vCount = (SELECT MAX(RUN_NO) FROM #DistList)
--	SET @iCount = 1

--	DECLARE @NewCodeID as NVARCHAR(255)
--	DECLARE @Codename as NVARCHAR(255)


--	IF OBJECT_ID('tempdb..#LASTLIST') IS NOT NULL DROP TABLE #LASTLIST
--	select CAST('' AS int) as 'column_id',CAST('' AS nvarchar(255)) as 'LOCATIONCODE',CAST('' AS nvarchar(255)) as 'value' INTO #LASTLIST 

--	delete #LASTLIST

--	WHILE(@iCount <= @vCount)
--	BEGIN -- 1

--	SELECT 
--	@NewCodeID = CodeId,
--	@Codename = CodeName
--	FROM #DistList
--	WHERE RUN_NO = @iCount


--	INSERT INTO #LASTLIST(column_id,LOCATIONCODE,value)
--	select * from NewTHDB_PROD.dbo.fn_split_string_to_column(@NewCodeID,@Codename,',')
	 		
--	SET @iCount = @iCount + 1
--	END  
 

DROP TABLE IF EXISTS #RAWTH
SELECT TXNID INTO #RAWTH FROM NewTHDB_PROD..TXN_TRANSACTION_STATUSSUMMARY WHERE status = 'SubmissionDate' and StatusDate >='2022-01-01'

DELETE FROM TXN_RegionalSalesSummary where CountryCode = 'TH'
INSERT INTO dbo.TXN_RegionalSalesSummary
(GUID,CountryCode,TxnID,Client,Campaign,Division,MOCode,BadgeNo,LiveStatus,Status,StatusDate,StatusWeDate,DonationAmount
,Frequency,SignUpDate,SignUpWeDate,SubmissionDate,SubmissionWeDate,PaymentMode,Channel,TeritoryCode,EventCode,DateOfBirth,IsUnderAge
,Age,IsDobo,DoboType,OwnerStroke,ICStroke,IsDeleted,Qty,RejQty,ResubQty,TxnCreatedDate,TCV)
SELECT  NEWID(), 'TH' as 'Country', A.TXNID ,  E.CampaignId,  E.CampaignId, E.DivisionId, A.MOCode, A.BadgeNo, B.Status, ISNULL(D.CustomDesc, A.Status) as 'Status', A.StatusDate, A.StatusWEDate, 
A.PackageValue, C.Frequency, CAST(B.SignupDate as date) as 'SignupDate', NewIndoDB_PROD.dbo.GetWeekendingDate(B.MoSubmissionDate),
B.MoSubmissionDate, NewIndoDB_PROD.dbo.GetWeekendingDate(B.MoSubmissionDate),  ISNULL(I.CustomDesc, A.PaymentMode) as 'PaymentMode', ISNULL(H.CustomChannel,B.Channel) as 'Channel',
B.MainProvince,(CASE WHEN B.Channel = 'EVE' THEN L.SiteName ELSE '' END), B.MainBirthday, CASE WHEN (CAST(FORMAT(B.SignupDate,'yyyyMMdd') as bigint) - cast(FORMAT(CAST(B.MainBirthday as date),'yyyyMMdd') as bigint))/10000   < 26 THEN 'Y' ELSE 'N' END as 'Underage',
(CAST(FORMAT(B.SignupDate,'yyyyMMdd') as bigint) - cast(FORMAT(CAST(B.MainBirthday as date),'yyyyMMdd') as bigint))/10000 as 'Age', B.DOBO, B.DoboType,
isnull(OwnerStrokeValue,0.00) + isnull(AdditionalOwnerStrokeValue,0.00), A.ICStrokeValue, 'N',NULL, NULL,NULL, A.CreatedDate,A.PackageValue
FROM NewTHDB_PROD..TXN_TRANSACTION_STATUSSUMMARY A LEFT JOIN NewTHDB_PROD..VW_CHR_TXN B ON A.TXNID = B.TXNID 
LEFT JOIN NewTHDB_PROD..Mst_Ch_Package C ON A.packageid = C.PackageID
LEFT JOIN MST_Campaign E ON E.countrycode = 'TH' and A.CampaignCode = E.CampaignName
LEFT JOIN #StatusName D ON A.status = D.StatusCode and D.Country = 'TH' 
LEFT JOIN #ChannelName H ON H.Country = 'TH' and B.Channel = H.Channel
LEFT JOIN #PaymentTypeName I ON  I.PaymentType = A.PaymentMode  and I.Country = 'TH' 
--LEFT OUTER JOIN #LASTLIST J on A.EventTerritoryCode = J.LOCATIONCODE AND J.column_id = 1
--LEFT OUTER JOIN #LASTLIST K on A.EventTerritoryCode = K.LOCATIONCODE AND K.column_id = 2
LEFT OUTER JOIN NewTHDB_PROD..VW_MST_EventCodes L on L.EventCode = B.EventTerritoryCode 
WHERE A.IsDeleted = 0 and A.TXNID IN (SELECT TXNID FROM #RAWTH) AND A.Status not in ('ClientClawBack60','ClientClawBack90','SGSubDate')
order by A.TXNID


INSERT INTO dbo.TXN_RegionalSalesSummary
(GUID,CountryCode,TxnID,Client,Campaign,Division,MOCode,BadgeNo,LiveStatus,Status,StatusDate,StatusWeDate,DonationAmount
,Frequency,SignUpDate,SignUpWeDate,SubmissionDate,SubmissionWeDate,PaymentMode,Channel,TeritoryCode,EventCode,DateOfBirth,IsUnderAge
,Age,IsDobo,DoboType,OwnerStroke,ICStroke,IsDeleted,Qty,RejQty,ResubQty,TxnCreatedDate,TCV)
select NEWID(), 'TH', A.TXNID, D.CampaignId,D.CampaignId,D.DivisionId, A.MOCode, A.BadgeNO, 'AP','SubmissionDate',a.MoSubmissionDate, A.MoSubmissionWEDate, NULL, 0, CAST(A.SignUpDate as date), dbo.GetWeekendingDate( CAST(A.SignUpDate as date)),
A.MoSubmissionDate, A.MoSubmissionWEDate, ISNULL(I.CustomDesc, B.PaymentMode) as 'PaymentMode', ISNULL(H.CustomChannel,A.Channel), EventTerritoryCode, (CASE WHEN A.Channel = 'EVE' THEN L.SiteName ELSE '' END), null, null,null,null,null,  null, 
SUM(C.ICStrokeValue), 'N', SUM(IIF(c.ParentCampaignProductId IS NOT NULL AND p.ProductType = 'Product' , c.Quantity, 0)), 
NULL,NULL, A.CreatedDate, NULL
from NewTHDB_PROD..Txn_Transaction a
inner join NewTHDB_PROD..Txn_Co_CampaignTransaction b on b.TxnId = a.TxnId and b.IsDeleted = 0 and b.RecordTypeCode = 'MAIN'
inner join NewTHDB_PROD..Txn_Co_Campaign_Product c on c.TxnId = a.TxnId and c.IsDeleted = 0 -- and ParentCampaignProductId is null
inner join NewTHDB_PROD..Mst_Co_Product p on p.ProductId = c.ProductId
inner join Mst_Campaign d on d.CampaignId = b.CampaignId
LEFT JOIN #ChannelName H ON H.Country = 'TH' and A.Channel = H.Channel
LEFT JOIN #PaymentTypeName I ON  I.PaymentType = B.PaymentMode  and I.Country = 'TH'
LEFT OUTER JOIN NewTHDB_PROD..VW_MST_EventCodes L on L.EventCode = A.EventTerritoryCode
where a.IsDeleted = 0 and MoSubmissionWEDate >= '2023-01-01' 
 
GROUP BY A.TXNID, D.CampaignId,D.CampaignId,D.DivisionId, A.MOCode, A.BadgeNO,a.MoSubmissionDate, A.MoSubmissionWEDate,CAST(A.SignUpDate as date), dbo.GetWeekendingDate( CAST(A.SignUpDate as date)),
A.MoResubmissionDate, A.MoSubmissionWEDate, ISNULL(I.CustomDesc, B.PaymentMode), ISNULL(H.CustomChannel,A.Channel), EventTerritoryCode, (CASE WHEN A.Channel = 'EVE' THEN L.SiteName ELSE '' END) ,A.CreatedDate


 
-----------------------------------------------------------------------------------------------------------------
-- THAILAND (END)
-----------------------------------------------------------------------------------------------------------------

  
 
-----------------------------------------------------------------------------------------------------------------
-- HONG KONG (START)
-----------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #RAWHK
SELECT TXNID INTO #RAWHK FROM NewHKDB_PROD..TXN_TRANSACTION_STATUSSUMMARY WHERE status = 'SubmissionDate' and StatusDate >='2022-01-01'

DELETE FROM TXN_RegionalSalesSummary where CountryCode = 'HK'
INSERT INTO dbo.TXN_RegionalSalesSummary
(GUID,CountryCode,TxnID,Client,Campaign,Division,MOCode,BadgeNo,LiveStatus,Status,StatusDate,StatusWeDate,DonationAmount
,Frequency,SignUpDate,SignUpWeDate,SubmissionDate,SubmissionWeDate,PaymentMode,Channel,TeritoryCode,EventCode,DateOfBirth,IsUnderAge
,Age,IsDobo,DoboType,OwnerStroke,ICStroke,IsDeleted,Qty,RejQty,ResubQty,TxnCreatedDate,TCV)
SELECT  NEWID(), 'HK' as 'Country', A.TXNID ,  E.CampaignId,  E.CampaignId, E.DivisionId, A.MOCode, A.BadgeNo, B.Status, ISNULL(D.CustomDesc, A.Status) as 'Status', A.StatusDate, A.StatusWEDate, 
A.PackageValue, C.Frequency, CAST(B.SignupDate as date) as 'SignupDate', NewIndoDB_PROD.dbo.GetWeekendingDate(B.MoSubmissionDate),
B.MoSubmissionDate, NewIndoDB_PROD.dbo.GetWeekendingDate(B.MoSubmissionDate), ISNULL(I.CustomDesc, A.PaymentMode) as 'PaymentMode', ISNULL(H.CustomChannel,B.Channel) as 'Channel',
'','', B.MainBirthday, CASE WHEN (CAST(FORMAT(B.SignupDate,'yyyyMMdd') as bigint) - cast(FORMAT(CAST(B.MainBirthday as date),'yyyyMMdd') as bigint))/10000   < 26 THEN 'Y' ELSE 'N' END as 'Underage',
(CAST(FORMAT(B.SignupDate,'yyyyMMdd') as bigint) - cast(FORMAT(CAST(B.MainBirthday as date),'yyyyMMdd') as bigint))/10000 as 'Age', B.DOBO, B.DoboType,
0, A.ICStrokeValue, 'N',NULL, NULL,NULL, A.CreatedDate,A.PackageValue
FROM NewHKDB_PROD..TXN_TRANSACTION_STATUSSUMMARY A LEFT JOIN NewHKDB_PROD..VW_CHR_TXN B ON A.TXNID = B.TXNID 
LEFT JOIN NewHKDB_PROD..Mst_Ch_Package C ON A.packageid = C.PackageID
LEFT JOIN MST_Campaign E ON E.countrycode = 'HK' and A.CampaignCode = E.CampaignName
LEFT JOIN #StatusName D ON A.status = D.StatusCode and D.Country = 'HK'
LEFT JOIN #ChannelName H ON H.Country = 'HK' and B.Channel = H.Channel
LEFT JOIN #PaymentTypeName I ON  I.PaymentType = A.PaymentMode  and I.Country = 'HK'
WHERE A.IsDeleted = 0 and A.TXNID IN (SELECT TXNID FROM #RAWHK) AND A.Status not in ('ClientClawBack60','ClientClawBack90','SGSubDate')
order by A.TXNID
-----------------------------------------------------------------------------------------------------------------
-- HONG KONG (END)
-----------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS #RawKR
SELECT SerialNo INTO #RawKR FROM Appco360_PROD..Maintable WHERE SubType is null and MOsubDate >='2022-01-01'

DROP TABLE IF EXISTS #FinalKR
SELECT  * INTO #FinalKR from Appco360_PROD..Maintable A
WHERE SerialNo in (SELECT SerialNo FROM #RawKR)

DELETE FROM TXN_RegionalSalesSummary WHERE CountryCode = 'KR'
INSERT INTO dbo.TXN_RegionalSalesSummary
(GUID,CountryCode,TxnID,Client,Campaign,Division,MOCode,BadgeNo,LiveStatus,Status,StatusDate,StatusWeDate,DonationAmount
,Frequency,SignUpDate,SignUpWeDate,SubmissionDate,SubmissionWeDate,PaymentMode,Channel,TeritoryCode,EventCode,DateOfBirth,IsUnderAge
,Age,IsDobo,DoboType,OwnerStroke,ICStroke,IsDeleted,Qty,RejQty,ResubQty,TxnCreatedDate,TCV)
SELECT NEWID(), 'KR' as 'Country', SerialNo,  B.CampaignId,  B.CampaignId, B.DivisionId, OfficeID, FRID ,'' as 'LiveStatus',
'SubmissionDate' as 'Status', 
MOSubDate, MOSubWE, Amount, Frequency, SignUpDate, SignUpDate,MOSubDate, MOSubWE, ISNULL(I.CustomDesc, A.PaymentType) as 'PaymentMode', ISNULL(H.CustomChannel,A.Channel), 
CASE WHEN A.Channel = 'STREET' THEN EventCode ELSE '' END, CASE WHEN A.Channel != 'STREET' THEN EventCode ELSE '' END ,  
DOB,
CASE WHEN Age  < 26 THEN 'Y' ELSE 'N' END as 'Underage',
Age, CASE WHEN A.DOBOType is null THEN 'N' ELSE 'YES' END, A.DOBOType, 0.0,  ISNULL(A.FRStroke,0.00 )  +  ISNULL(A.AdditionalFRStroke,0.00 ) ,
'N',NULL, NULL,NULL, A.CreatedDate,Amount FROM #FinalKR A 
LEFT JOIN MST_Campaign B ON  B.IsDeleted = 0 and B.CountryCode = 'KR' and B.CampaignName = A.Campaign  collate SQL_Latin1_General_CP1_CI_AS
LEFT JOIN #ChannelName H ON H.Country = 'KR' and A.Channel = H.Channel collate SQL_Latin1_General_CP1_CI_AS
LEFT JOIN #PaymentTypeName I ON  I.PaymentType = A.PaymentType collate SQL_Latin1_General_CP1_CI_AS and I.Country = 'KR' 
WHERE SubType is null and TimesSubmitted = 1
 and OfficeID <> 'HQ'  and PaidAmount > 0

 
INSERT INTO dbo.TXN_RegionalSalesSummary
(GUID,CountryCode,TxnID,Client,Campaign,Division,MOCode,BadgeNo,LiveStatus,Status,StatusDate,StatusWeDate,DonationAmount
,Frequency,SignUpDate,SignUpWeDate,SubmissionDate,SubmissionWeDate,PaymentMode,Channel,TeritoryCode,EventCode,DateOfBirth,IsUnderAge
,Age,IsDobo,DoboType,OwnerStroke,ICStroke,IsDeleted,Qty,RejQty,ResubQty,TxnCreatedDate,TCV)
SELECT NEWID(), 'KR' as 'Country', SerialNo,  B.CampaignId,  B.CampaignId, B.DivisionId, OfficeID, FRID ,'' as 'LiveStatus',
'ClientRejectDate' as 'Status', 
RejectDate, MORejectWe, Amount, Frequency, SignUpDate, SignUpDate,MOSubDate, MOSubWE, ISNULL(I.CustomDesc, A.PaymentType) as 'PaymentMode', ISNULL(H.CustomChannel,A.Channel), 
CASE WHEN A.Channel = 'STREET' THEN EventCode ELSE '' END, CASE WHEN A.Channel != 'STREET' THEN EventCode ELSE '' END ,  
DOB,
CASE WHEN Age  < 26 THEN 'Y' ELSE 'N' END as 'Underage',
Age, CASE WHEN A.DOBOType is null THEN 'N' ELSE 'YES' END, A.DOBOType, 0.0,  ISNULL(A.FRStroke,0.00 )  +  ISNULL(A.AdditionalFRStroke,0.00 ) ,
'N',NULL, NULL,NULL, A.CreatedDate,Amount FROM #FinalKR A 
LEFT JOIN MST_Campaign B ON  B.IsDeleted = 0 and B.CountryCode = 'KR' and B.CampaignName = A.Campaign  collate SQL_Latin1_General_CP1_CI_AS
LEFT JOIN #ChannelName H ON H.Country = 'KR' and A.Channel = H.Channel collate SQL_Latin1_General_CP1_CI_AS
LEFT JOIN #PaymentTypeName I ON  I.PaymentType = A.PaymentType collate SQL_Latin1_General_CP1_CI_AS and I.Country = 'KR' 
WHERE   PaidAmount > 0 and Appcostatus = 'CLIENTREJECT'
 
 
INSERT INTO dbo.TXN_RegionalSalesSummary
(GUID,CountryCode,TxnID,Client,Campaign,Division,MOCode,BadgeNo,LiveStatus,Status,StatusDate,StatusWeDate,DonationAmount
,Frequency,SignUpDate,SignUpWeDate,SubmissionDate,SubmissionWeDate,PaymentMode,Channel,TeritoryCode,EventCode,DateOfBirth,IsUnderAge
,Age,IsDobo,DoboType,OwnerStroke,ICStroke,IsDeleted,Qty,RejQty,ResubQty,TxnCreatedDate,TCV)
SELECT NEWID(), 'KR' as 'Country', SerialNo,  B.CampaignId,  B.CampaignId, B.DivisionId, OfficeID, FRID ,'' as 'LiveStatus',
'RejectDate' as 'Status', 
RejectDate, MORejectWe, Amount, Frequency, SignUpDate, SignUpDate,MOSubDate, MOSubWE, ISNULL(I.CustomDesc, A.PaymentType) as 'PaymentMode', ISNULL(H.CustomChannel,A.Channel),  
CASE WHEN A.Channel = 'STREET' THEN EventCode ELSE '' END, CASE WHEN A.Channel != 'STREET' THEN EventCode ELSE '' END ,  
DOB,
CASE WHEN Age  < 26 THEN 'Y' ELSE 'N' END as 'Underage',
Age, CASE WHEN A.DOBOType is null THEN 'N' ELSE 'YES' END, A.DOBOType, 0.0,  ISNULL(A.FRStroke,0.00 )  +  ISNULL(A.AdditionalFRStroke,0.00 ) ,
'N',NULL, NULL,NULL, A.CreatedDate,Amount FROM #FinalKR A 
LEFT JOIN MST_Campaign B ON  B.IsDeleted = 0 and B.CountryCode = 'KR' and B.CampaignName = A.Campaign  collate SQL_Latin1_General_CP1_CI_AS
LEFT JOIN #ChannelName H ON H.Country = 'KR' and A.Channel = H.Channel collate SQL_Latin1_General_CP1_CI_AS
LEFT JOIN #PaymentTypeName I ON  I.PaymentType = A.PaymentType collate SQL_Latin1_General_CP1_CI_AS and I.Country = 'KR' 
WHERE  PaidAmount > 0 and Appcostatus = 'APPCOREJECT'
 
 
INSERT INTO dbo.TXN_RegionalSalesSummary
(GUID,CountryCode,TxnID,Client,Campaign,Division,MOCode,BadgeNo,LiveStatus,Status,StatusDate,StatusWeDate,DonationAmount
,Frequency,SignUpDate,SignUpWeDate,SubmissionDate,SubmissionWeDate,PaymentMode,Channel,TeritoryCode,EventCode,DateOfBirth,IsUnderAge
,Age,IsDobo,DoboType,OwnerStroke,ICStroke,IsDeleted,Qty,RejQty,ResubQty,TxnCreatedDate,TCV)
SELECT NEWID(), 'KR' as 'Country', SerialNo,  B.CampaignId,  B.CampaignId, B.DivisionId, OfficeID, FRID ,'' as 'LiveStatus',
'ReSubmissionDate' as 'Status', 
MOSubDate, MOSubWE, Amount, Frequency, SignUpDate, SignUpDate,MOSubDate, MOSubWE, ISNULL(I.CustomDesc, A.PaymentType) as 'PaymentMode', ISNULL(H.CustomChannel,A.Channel),  
CASE WHEN A.Channel = 'STREET' THEN EventCode ELSE '' END, CASE WHEN A.Channel != 'STREET' THEN EventCode ELSE '' END ,  
DOB,
CASE WHEN Age  < 26 THEN 'Y' ELSE 'N' END as 'Underage',
Age, CASE WHEN A.DOBOType is null THEN 'N' ELSE 'YES' END, A.DOBOType, 0.0,  ISNULL(A.FRStroke,0.00 )  +  ISNULL(A.AdditionalFRStroke,0.00 ) ,
'N',NULL, NULL,NULL, A.CreatedDate,Amount FROM #FinalKR A 
LEFT JOIN MST_Campaign B ON  B.IsDeleted = 0 and B.CountryCode = 'KR' and B.CampaignName = A.Campaign  collate SQL_Latin1_General_CP1_CI_AS
LEFT JOIN #ChannelName H ON H.Country = 'KR' and A.Channel = H.Channel collate SQL_Latin1_General_CP1_CI_AS
LEFT JOIN #PaymentTypeName I ON  I.PaymentType = A.PaymentType collate SQL_Latin1_General_CP1_CI_AS and I.Country = 'KR' 
WHERE PaidAmount > 0 and SubType = 'APPCORESUB' 
 
 
INSERT INTO dbo.TXN_RegionalSalesSummary
(GUID,CountryCode,TxnID,Client,Campaign,Division,MOCode,BadgeNo,LiveStatus,Status,StatusDate,StatusWeDate,DonationAmount
,Frequency,SignUpDate,SignUpWeDate,SubmissionDate,SubmissionWeDate,PaymentMode,Channel,TeritoryCode,EventCode,DateOfBirth,IsUnderAge
,Age,IsDobo,DoboType,OwnerStroke,ICStroke,IsDeleted,Qty,RejQty,ResubQty,TxnCreatedDate,TCV)
SELECT NEWID(), 'KR' as 'Country', SerialNo,  B.CampaignId,  B.CampaignId, B.DivisionId, OfficeID, FRID ,'' as 'LiveStatus',
'ClientResubmissionDate' as 'Status', 
MOSubDate, MOSubWE, Amount, Frequency, SignUpDate, SignUpDate,MOSubDate, MOSubWE, ISNULL(I.CustomDesc, A.PaymentType) as 'PaymentMode', ISNULL(H.CustomChannel,A.Channel), 
CASE WHEN A.Channel = 'STREET' THEN EventCode ELSE '' END, CASE WHEN A.Channel != 'STREET' THEN EventCode ELSE '' END ,  
DOB,
CASE WHEN Age  < 26 THEN 'Y' ELSE 'N' END as 'Underage',
Age, CASE WHEN A.DOBOType is null THEN 'N' ELSE 'YES' END, A.DOBOType, 0.0,  ISNULL(A.FRStroke,0.00 )  +  ISNULL(A.AdditionalFRStroke,0.00 ) ,
'N',NULL, NULL,NULL, A.CreatedDate,Amount FROM #FinalKR A 
LEFT JOIN MST_Campaign B ON  B.IsDeleted = 0 and B.CountryCode = 'KR' and B.CampaignName = A.Campaign  collate SQL_Latin1_General_CP1_CI_AS
LEFT JOIN #ChannelName H ON H.Country = 'KR' and A.Channel = H.Channel collate SQL_Latin1_General_CP1_CI_AS
LEFT JOIN #PaymentTypeName I ON  I.PaymentType = A.PaymentType collate SQL_Latin1_General_CP1_CI_AS and I.Country = 'KR' 
WHERE  PaidAmount > 0 and SubType = 'CLIENTRESUB'


 
 
INSERT INTO dbo.TXN_RegionalSalesSummary
(GUID,CountryCode,TxnID,Client,Campaign,Division,MOCode,BadgeNo,LiveStatus,Status,StatusDate,StatusWeDate,DonationAmount
,Frequency,SignUpDate,SignUpWeDate,SubmissionDate,SubmissionWeDate,PaymentMode,Channel,TeritoryCode,EventCode,DateOfBirth,IsUnderAge
,Age,IsDobo,DoboType,OwnerStroke,ICStroke,IsDeleted,Qty,RejQty,ResubQty,TxnCreatedDate,TCV)
SELECT NEWID(), 'KR' as 'Country', SerialNo,  B.CampaignId,  B.CampaignId, B.DivisionId, OfficeID, FRID ,'' as 'LiveStatus',
'ClientApproved' as 'Status', 
BankStatusDate, dbo.GetWeekendingDate(BankStatusDate), Amount, Frequency, SignUpDate, SignUpDate,MOSubDate, MOSubWE, ISNULL(I.CustomDesc, A.PaymentType) as 'PaymentMode', ISNULL(H.CustomChannel,A.Channel), 
CASE WHEN A.Channel = 'STREET' THEN EventCode ELSE '' END, CASE WHEN A.Channel != 'STREET' THEN EventCode ELSE '' END ,  
DOB,
CASE WHEN Age  < 26 THEN 'Y' ELSE 'N' END as 'Underage',
Age, CASE WHEN A.DOBOType is null THEN 'N' ELSE 'YES' END, A.DOBOType, 0.0,  ISNULL(A.FRStroke,0.00 )  +  ISNULL(A.AdditionalFRStroke,0.00 ) ,
'N',NULL, NULL,NULL, A.CreatedDate,Amount FROM #FinalKR A 
LEFT JOIN MST_Campaign B ON  B.IsDeleted = 0 and B.CountryCode = 'KR' and B.CampaignName = A.Campaign  collate SQL_Latin1_General_CP1_CI_AS
LEFT JOIN #ChannelName H ON H.Country = 'KR' and A.Channel = H.Channel collate SQL_Latin1_General_CP1_CI_AS
LEFT JOIN #PaymentTypeName I ON  I.PaymentType = A.PaymentType collate SQL_Latin1_General_CP1_CI_AS and I.Country = 'KR' 
WHERE SubType is null 
 and OfficeID <> 'HQ'  and PaidAmount > 0 and appcostatus = 'APPROVED' and InvoiceDate is not null
  

 --=================================================================== MANUAL SALES

 DROP TABLE IF EXISTS #TempTempSales
SELECT B.CampaignID  ,  A.* INTO #TempTempSales FROM Appco360_PROD..[Txn_SalesImport] A LEFT JOIN 
Appco360_PROD..Mst_ManualCampaign B  ON A.Country = B.Country collate Latin1_General_CI_AI and A.Campaign = B.Campaign collate Latin1_General_CI_AI
WHERE WEDate >='2022-01-01' and IsDeleted = 0
 
INSERT INTO dbo.TXN_RegionalSalesSummary
(GUID,CountryCode,TxnID,Client,Campaign,Division,MOCode,BadgeNo,LiveStatus,Status,StatusDate,StatusWeDate,DonationAmount
,Frequency,SignUpDate,SignUpWeDate,SubmissionDate,SubmissionWeDate,PaymentMode,Channel,TeritoryCode,EventCode,DateOfBirth,IsUnderAge
,Age,IsDobo,DoboType,OwnerStroke,ICStroke,IsDeleted,Qty,RejQty,ResubQty,TxnCreatedDate,TCV)
SELECT NEWID(), A.Country, A.SalesImportTxnId, A.CampaignID, A.CampaignID, B.DivisionId, SUBSTRING(BadgeID,1,2),BadgeID,'AP','SubmissionDate',
WEDate,WEDate,NULL, 0,NULL,NULL,NULL,WEDate, NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL , NetEarning,
'N',SignUpPieces,RejectPieces, ResubPieces, A.CreatedDate,NULL  FROM #TempTempSales A
LEFT JOIN Mst_Campaign B ON A.CampaignID = B.CampaignId



 --=================================================================== Generate bonus only on Friday

IF DATENAME(WEEKDAY, GETDATE()) = 'Friday'
BEGIN
DECLARE @WeDateBonus as date
SELECT TOP 1 @WeDateBonus = Wedate   FROM Mst_Weekending where WEdate < GETDATE()
order by WEdate desc

DELETE FROM TXN_RegionalSalesBonus where Weekending = @WeDateBonus
INSERT INTO TXN_RegionalSalesBonus EXEC SP_RPT_WeeklyHuddleReport_BulletinPoint @WeDateBonus
END
 


END
 

--DELETE FROM TXN_RegionalSalesSummary where   Campaign = '1264'


-- SELECT * FROM MST_campaign where CampaignName like '%futu%'