

-- ==========================================================================================
-- Author:		Syafiqah Ab Manah
-- Create date: 2020-11-05
-- Description:	Regional RC Analysis Report 
-- SP_RPT_HOFReport '2022-05-29','099e48863114457e98a08017aaf99344'
-- ==========================================================================================
CREATE PROCEDURE [dbo].[SP_RPT_HOFReport] 
	@WeDate  date,
	@userId varchar(150)
AS
BEGIN 

	DECLARE @CountryList nvarchar(50)
	DECLARE @userRole int
	DECLARE @MoID int
	SELECT @CountryList = CountryAccess, @userRole = UserRoleId, @MoID = MarketingCompanyId from Mst_User where UserId =  @userId
	IF OBJECT_ID('tempdb..#CountryAcess') IS NOT NULL DROP TABLE #CountryAcess
	SELECT * INTO #CountryAcess FROM STRING_SPLIT((@CountryList ),',')  
	 

SELECT DATENAME(WEEKDAY,A.OnfieldDate) as DayNames, D.WEdate, A.OnfieldDate, C.Code as 'MoCode', C.CountryCode, B.Channel, E.CampaignName, 1 as 'Count' FROM TXN_OnfieldHeadcountHeader A
LEFT JOIN TXN_OnfieldHeadcountDetail B ON A.OnfieldHeadcountID = B.OnfieldHeadcountID  
LEFT JOIN Mst_MarketingCompany C on A.MarketingCompanyId = C.MarketingCompanyId
LEFT JOIN MST_weekending D ON A.OnfieldDate >= D.FromDate and A.OnfieldDate <= D.ToDate
LEFT JOIN Mst_Campaign E ON B.CampaignID = E.CampaignID
WHERE ISNULL(B.Session,'') <> '' and C.CountryCode in (SELECT * FROM #CountryAcess)
and (C.MarketingCompanyId = @MoID OR @userRole in (2,4,5)) and D.WEdate = @WeDate


END


