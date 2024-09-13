

--[SP_RPT_OnfieldHC_ByDateRange]  '2022-12-26','2023-10-18'
CREATE PROCEDURE [dbo].[SP_RPT_OnfieldHC_ByDateRange] 
@OnfieldFromDate DATE ,
@OnfieldToDate DATE 

AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @CDate as DATE
	DECLARE @OnfieldHCID as INT

	SET @CDate =  DATEADD(DAY,-4, CAST(GETDATE() AS DATE))
 

	SELECT A.*, B.Name, B.Code, B.CountryCode, B.IsActive INTO #TXN_OnfieldHeadcountHeader FROM TXN_OnfieldHeadcountHeader A 
	LEFT JOIN Mst_MarketingCompany B ON A.MarketingCompanyId = B.MarketingCompanyId
	WHERE A.OnfieldDate >= @OnfieldFromDate AND A.OnfieldDate <= @OnfieldToDate 

	SELECT @OnfieldHCID = OnfieldHeadcountID FROM #TXN_OnfieldHeadcountHeader

	SELECT * INTO #TXN_OnfieldHeadcountDetail FROM TXN_OnfieldHeadcountDetail WHERE OnfieldHeadcountID in (
	SELECT OnfieldHeadcountID FROM #TXN_OnfieldHeadcountHeader
	) 
  
	SELECT   CAST(ROW_NUMBER() OVER(ORDER BY A.IndependentContractorId,C.CampaignId) as VARCHAR) AS Id, ISNULL(D.DetailID,CAST(-1 as int)) as 'DetailID',  Z.OnfieldHeadcountID, Z.OnfieldDate as 'OnfieldDate', Z.MarketingCompanyId, Z.Code as 'MCCode', Z.Name as 'MCName', A.IndependentContractorId, A.BadgeNo, 
	RTRIM(ISNULL(A.FirstName,'') + ' ' + ISNULL(A.LastName,'')) as 'Name', C.CampaignId, C.CountryCode, C.CampaignName,
	ISNULL(D.Session,'OFF') as 'Session', ISNULL(D.Channel,'') as 'Channel', ISNULL(D.Location,'') as Loc
	INTO #RAW
	FROM #TXN_OnfieldHeadcountHeader Z 
	LEFT JOIN #TXN_OnfieldHeadcountDetail D ON Z.OnfieldHeadcountID = D.OnfieldHeadcountID  
	INNER JOIN Mst_IndependentContractor A ON D.IndependentContractorId = A.IndependentContractorId 
	LEFT JOIN Mst_Campaign C ON D.CampaignId = C.CampaignId
	WHERE A.Status = 'Active' --and B.StartDate <= @CDate and ISNULL(B.EndDate,'3000-01-01') >= @CDate  
	and A.IsSuspended = 0  and ISNULL(session,'') <> ''
	Order by Z.OnfieldDate, C.CampaignId, A.BadgeNo

	SELECT * FROM #RAW
	ORDER BY OnfieldDate, MCName, BadgeNo

END
--SP_GetOnfieldHeadcount 22,'2022-05-23','0edd37b9cfd145eabb8f9131ad5ca34f'
