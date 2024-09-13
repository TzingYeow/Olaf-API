﻿CREATE PROCEDURE [dbo].[sp_Job_Send_PR_Wednesday_Hub_Restart]
	-- Add the parameters for the stored procedure here
	  

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	declare @i int,
        @rows int

	DECLARE @WEDate as DATE
	DECLARE @ReportGUID as uniqueidentifier = 'e293f567-a572-423d-b063-d692d2f1c145'
		SET @WEDate = (
			SELECT TOP 1 WEdate FROM (
			SELECT TOP 2 * FROM Mst_Weekending where WEdate <=GETDATE()
			ORDER BY WEdate desc
		) A ORDER BY WEdate 
	)
   
   
	-- SENT ALL SG HUB
	UPDATE ReportServer..Subscriptions SET
	Parameters = '<ParameterValues><ParameterValue><Name>ShowAccount</Name><Value>Y</Value></ParameterValue><ParameterValue><Name>MCCode</Name><Value></Value></ParameterValue><ParameterValue><Name>CountryCode</Name><Value>SG</Value></ParameterValue><ParameterValue><Name>WeDate</Name><Value>' + FORMAT(@WEDate,'M/d/yyyy') + ' 12:00:00 AM</Value></ParameterValue></ParameterValues>', --<ParameterValues><ParameterValue><Name>Owner</Name><Value>All</Value></ParameterValue><ParameterValue><Name>WEDate</Name><Value>' + FORMAT(@WEDate,'M/d/yyyy') + ' 12:00:00 AM</Value></ParameterValue></ParameterValues>',
	ExtensionSettings = '<ParameterValues><ParameterValue><Name>TO</Name><Value>hubs@appcogroup.asia;sg.accounts@appcogroup.asia;</Value></ParameterValue><ParameterValue><Name>CC</Name><Value>adilla.aziz@salesworks.asia;leonard.yong@salesworks.asia</Value></ParameterValue><ParameterValue><Name>IncludeReport</Name><Value>True</Value></ParameterValue><ParameterValue><Name>RenderFormat</Name><Value>EXCELOPENXML</Value></ParameterValue><ParameterValue><Name>Subject</Name><Value>PR Incentives Weekly File : '+'WE' + FORMAT(@WEDate,'ddMMyyyy') +' (Final)</Value></ParameterValue><ParameterValue><Name>Comment</Name><Value>Hi Everyone,&lt;br&gt;  Kindly see attached PR Incentives Report for '+'WE' + FORMAT(@WEDate,'ddMMyyyy') +'.&lt;br&gt; Thank you.&lt;br&gt;&lt;br&gt;</Value></ParameterValue><ParameterValue><Name>IncludeLink</Name><Value>False</Value></ParameterValue><ParameterValue><Name>Priority</Name><Value>NORMAL</Value></ParameterValue></ParameterValues>'
	WHERE SubscriptionID = @ReportGUID

	exec ReportServer.dbo.AddEvent @EventType = 'TimedSubscription', @EventData = @ReportGUID
	waitfor delay '00:00:30'
	 

  
	DROP TABLE IF EXISTS #MCList
	CREATE TABLE #MCList(
		MCCOde NVARCHAR(10),
		Country NVARCHAR(2)
	)

	INSERT INTO #MCList
    SELECT DISTINCT C.Code, C.CountryCode  FROM TXN_PR_Detail A 
	LEFT JOIN MST_PR_Master B ON A.PRID = B.PRID
	LEFT JOIN VW_ICDetail C ON B.IndependentContractorID = C.IndependentContractorId
	where MilestoneHitWE = @WEDate and C.Code not in ('NA') and C.CountryCode = 'SG'
	ORDER BY C.CountryCode

	DECLARE @MCCount AS INT
	DECLARE @LoopMC AS NVARCHAR(2)
	DECLARE @LoopCountry as NVARCHAR(2)
	SET @MCCount = (SELECT COUNT(*) FROM #MCList)

	WHILE @MCCount > 0 
	BEGIN
	SELECT TOP 1 @LoopMC = MCCOde, @LoopCountry = Country  FROM #MCList
	

	-- SENT ALL Individual MC and Admin
		DECLARE @OwnerandAdmin NVARCHAR(MAX)
		SELECT @OwnerandAdmin =  STRING_AGG(Email,';') FROM (
		SELECT STRING_AGG(Email,';') as Email FROM (
		 SELECT distinct A.email FROM Mst_MarketingCompany_Staff A LEFT JOIN Mst_MarketingCompany B ON A.MarketingCompanyId = B.MarketingCompanyId
		 WHERE   B.Code not in ('NA') and  A.Email not in (
		 'NOTApplicable@na.com','123@salesworks.asia','na@na.com','test@sw.my','xxx@ma.com','appco@appcogroup.asia')  and ISNULL(A.Email,'')  <> '' 
		 and B.CountryCode = @LoopCountry and B.IsActive = 1 and B.Code = @LoopMC
		 ) A 
		 UNION
		 SELECT STRING_AGG(Email,';')  as Email FROM(
		 SELECT DISTINCT A.Email FROM Mst_User  A LEFT JOIN Mst_MarketingCompany B ON A.MarketingCompanyId = B.MarketingCompanyId
		 where A.UserRoleId = 3 and A.IsActive = 1 and B.IsActive = 1 and B.CountryCode = @LoopCountry and B.Code = @LoopMC
		 and A.Email not in ('123@salesworks.asia','123@gmail.com','123@saleswork.asia')  and ISNULL(A.Email,'')  <> ''
		 )A
		 ) A
		   
		UPDATE ReportServer..Subscriptions SET
		Parameters = '<ParameterValues><ParameterValue><Name>ShowAccount</Name><Value>Y</Value></ParameterValue><ParameterValue><Name>MCCode</Name><Value>'+@LoopMC+'</Value></ParameterValue><ParameterValue><Name>CountryCode</Name><Value>'+@LoopCountry+'</Value></ParameterValue><ParameterValue><Name>WeDate</Name><Value>' + FORMAT(@WEDate,'M/d/yyyy') + ' 12:00:00 AM</Value></ParameterValue></ParameterValues>', --<ParameterValues><ParameterValue><Name>Owner</Name><Value>All</Value></ParameterValue><ParameterValue><Name>WEDate</Name><Value>' + FORMAT(@WEDate,'M/d/yyyy') + ' 12:00:00 AM</Value></ParameterValue></ParameterValues>',
		ExtensionSettings = '<ParameterValues><ParameterValue><Name>TO</Name><Value>hubs@appcogroup.asia;sg.accounts@appcogroup.asia;</Value></ParameterValue><ParameterValue><Name>CC</Name><Value>adilla.aziz@salesworks.asia;leonard.yong@salesworks.asia</Value></ParameterValue><ParameterValue><Name>IncludeReport</Name><Value>True</Value></ParameterValue><ParameterValue><Name>RenderFormat</Name><Value>EXCELOPENXML</Value></ParameterValue><ParameterValue><Name>Subject</Name><Value>PR Incentives Weekly File. ['+@LoopMC+'] : '+'WE' + FORMAT(@WEDate,'ddMMyyyy') +'</Value></ParameterValue><ParameterValue><Name>Comment</Name><Value>Hi Everyone,&lt;br&gt;  Kindly see attached PR Incentives Report for '+'WE' + FORMAT(@WEDate,'ddMMyyyy') +'.&lt;br&gt; Thank you.</Value></ParameterValue><ParameterValue><Name>IncludeLink</Name><Value>False</Value></ParameterValue><ParameterValue><Name>Priority</Name><Value>NORMAL</Value></ParameterValue></ParameterValues>'
		WHERE SubscriptionID = @ReportGUID
		 
		exec ReportServer.dbo.AddEvent @EventType = 'TimedSubscription', @EventData = @ReportGUID
		waitfor delay '00:01:00' 
		 
		DELETE FROM #MCList where MCCOde = @LoopMC and Country = @LoopCountry
		SET @MCCount = (SELECT COUNT(*) FROM #MCList)
	END
   
    UPDATE ReportServer..Subscriptions SET
	Parameters = '<ParameterValues><ParameterValue><Name>ShowAccount</Name><Value>N</Value></ParameterValue><ParameterValue><Name>MCCode</Name><Value></Value></ParameterValue><ParameterValue><Name>CountryCode</Name><Value>MY</Value></ParameterValue><ParameterValue><Name>WeDate</Name><Value>' + FORMAT(@WEDate,'M/d/yyyy') + ' 12:00:00 AM</Value></ParameterValue></ParameterValues>', --<ParameterValues><ParameterValue><Name>Owner</Name><Value>All</Value></ParameterValue><ParameterValue><Name>WEDate</Name><Value>' + FORMAT(@WEDate,'M/d/yyyy') + ' 12:00:00 AM</Value></ParameterValue></ParameterValues>',
	ExtensionSettings = '<ParameterValues><ParameterValue><Name>TO</Name><Value>leonard.yong@salesworks.asia</Value></ParameterValue><ParameterValue><Name>CC</Name><Value>leonard.yong@salesworks.asia</Value></ParameterValue><ParameterValue><Name>IncludeReport</Name><Value>True</Value></ParameterValue><ParameterValue><Name>RenderFormat</Name><Value>EXCELOPENXML</Value></ParameterValue><ParameterValue><Name>Subject</Name><Value>PR Incentives Weekly File : '+'WE' + FORMAT(@WEDate,'ddMMyyyy') +'</Value></ParameterValue><ParameterValue><Name>Comment</Name><Value>Hi Everyone,&lt;br&gt;  Kindly see attached PR Incentives Report for '+'WE' + FORMAT(@WEDate,'ddMMyyyy') +'.&lt;br&gt; Thank you.&lt;br&gt;&lt;br&gt;</Value></ParameterValue><ParameterValue><Name>IncludeLink</Name><Value>False</Value></ParameterValue><ParameterValue><Name>Priority</Name><Value>NORMAL</Value></ParameterValue></ParameterValues>'
	WHERE SubscriptionID = @ReportGUID

	exec ReportServer.dbo.AddEvent @EventType = 'TimedSubscription', @EventData = @ReportGUID
	waitfor delay '00:00:30'

END

--sp_Job_Send_PR_Monday

 