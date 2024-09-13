

--SP_GetOnfieldHeadcount2 1460,'2023-01-03','e7fb1ea493e24dd2bef585d6c099c4b1'
CREATE PROCEDURE [dbo].[SP_GetOnfieldHeadcount2]
	@MarketingCompanyID int,
	@OnfieldDate DATE,
	@UserID NVARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @CDate as DATE
	DECLARE @OnfieldHCID as INT

	SET @CDate = CAST(@OnfieldDate as DATE) 
	--IF (SELECT COUNT(*) FROM TXN_OnfieldHeadcountHeader WHERE MarketingCompanyId = @MarketingCompanyID and OnfieldDate = @CDate) = 0
	--BEGIN 
	--	--INSERT INTO TXN_OnfieldHeadcountHeader
	--	--(MarketingCompanyId,OnfieldDate,TotalHeadcount,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,IsDeleted)
	--	--SELECT @MarketingCompanyID, @CDate, 0, @UserID, GETDATE(), NULL,NULL,0
	--END 

	SELECT A.*, B.Name, B.Code, B.CountryCode, B.IsActive INTO #TXN_OnfieldHeadcountHeader FROM TXN_OnfieldHeadcountHeader A 
	LEFT JOIN Mst_MarketingCompany B ON A.MarketingCompanyId = B.MarketingCompanyId
	WHERE A.OnfieldDate = @CDate and B.MarketingCompanyId = @MarketingCompanyID

	SELECT * FROM #TXN_OnfieldHeadcountHeader
	SELECT @OnfieldHCID = OnfieldHeadcountID FROM #TXN_OnfieldHeadcountHeader

	SELECT * INTO #TXN_OnfieldHeadcountDetail FROM TXN_OnfieldHeadcountDetail WHERE OnfieldHeadcountID = @OnfieldHCID 
  
  
	SELECT   CAST(ROW_NUMBER() OVER(ORDER BY A.IndependentContractorId,C.CampaignId) as VARCHAR) AS Id, ISNULL(D.DetailID,CAST(-1 as int)) as 'DetailID',  Z.OnfieldHeadcountID, @CDate as 'OnfieldDate', Z.MarketingCompanyId, Z.Name as 'MCName', A.IndependentContractorId, A.BadgeNo, 
	RTRIM(ISNULL(A.FirstName,'') + ' ' + ISNULL(A.LastName,'')) as 'Name', C.CampaignId, C.CountryCode, C.CampaignName,
	ISNULL(D.Session,'OFF') as 'Session', ISNULL(D.Channel,'') as 'Channel', ISNULL(D.Location,'') as Loc
	INTO #RAW
	FROM #TXN_OnfieldHeadcountHeader Z 
	INNER JOIN Mst_IndependentContractor A ON Z.MarketingCompanyId = A.MarketingCompanyId
	LEFT JOIN Mst_IndependentContractor_Assignment B ON A.IndependentContractorId = B.IndependentContractorId
	LEFT JOIN Mst_Campaign C ON B.CampaignId = C.CampaignId
	LEFT JOIN #TXN_OnfieldHeadcountDetail D ON Z.OnfieldHeadcountID = D.OnfieldHeadcountID and A.IndependentContractorId = D.IndependentContractorId and B.CampaignId = D.CampaignID
	WHERE A.Status = 'Active' and B.StartDate <= @CDate and ISNULL(B.EndDate,'3000-01-01') >= @CDate and Z.MarketingCompanyId = @MarketingCompanyID
	and A.IsSuspended = 0 and B.IsDeleted = 0
	Order by C.CampaignId, A.BadgeNo

	SELECT * FROM #RAW

END
--SP_GetOnfieldHeadcount 22,'2022-05-23','0edd37b9cfd145eabb8f9131ad5ca34f'
