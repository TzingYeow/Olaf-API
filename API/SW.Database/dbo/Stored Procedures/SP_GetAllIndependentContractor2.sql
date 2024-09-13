   
-- Author:		Tan Siuk Ching
-- Create date: 2021-07-06
-- Description:	GetAllIndependentContractor
-- Execution: Exec [SP_GetAllIndependentContractor2]  null,"HK,ID,KR,MY,PH,TH,TW,SG" ,null  
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetAllIndependentContractor2]
		@MarketingCompanyId int = NULL,
		@CountryCode nvarchar(100) = NULL,
		@Status nvarchar(10) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @Query nvarchar(max);
	--DECLARE @MarketingCompanyId int = NULL;
	--SET @MarketingCompanyId = 3;
	--DECLARE @CountryCode nvarchar(100) = NULL ;
	--SET @CountryCode = 'MY,SG';
	
	SET @Query = N'
	Select 
	--Independent Contractor
	a.IndependentContractorId,a.BadgeNo,a.OriginalBadgeNo,a.FirstName,a.MiddleName,a.LastName,a.LocalFirstName,a.LocalLastName,
	a.PhoneNumber,a.MobileNumber,a.Email,
	a.Status,a.IndependentContractorLevelId,a.IsSuspended,

	CASE WHEN A.BAType = ''1'' THEN ''Hourly Rate'' ELSE ''Normal'' END AS BAType,

	(Select Top 1 PromotionDemotionDate from Mst_IndependentContractor_Movement where Description in (''Advance'') and IsDeleted = 0 and HasExecuted = 1 and IndependentContractorId = a.IndependentContractorId and IndependentContractorLevelId = a.IndependentContractorLevelId order by PromotionDemotionDate desc) AdvancementDate,

	(CASE WHEN a.Status = ''Active''
	THEN 
	(
	Select 
	REVERSE(SUBSTRING(REVERSE
	(SUBSTRING((SELECT  RTRIM(y.CampaignName) + '','' AS ''data()'' FROM Mst_IndependentContractor_Assignment x 
	left join Mst_Campaign y on x.CampaignId = y.CampaignId  where x.IsDeleted = 0 and y.IsDeleted = 0 
	and x.IndependentContractorId = a.IndependentContractorId and (x.EndDate is null or x.EndDate >= GETDATE()) FOR XML PATH('''') ), 0 , 9999)),2,9999))
	)
	ELSE
	(SELECT TOP 1 y.CampaignName  FROM Mst_IndependentContractor_Assignment x  left 
	join Mst_Campaign y on x.CampaignId = y.CampaignId  where x.IsDeleted = 0 
	and y.IsDeleted = 0  and x.EndDate is not null and x.IndependentContractorId = a.IndependentContractorId order by StartDate desc) 
	END)AS Campaigns,

	--Marketing Company
	b.Code,b.Name,b.CountryCode

	-- Level
	,c.IndependentContractorLevelId,c.LevelCode,c.Level,c.LevelOrdinal, A.SalesBranch

	from Mst_IndependentContractor a
	left join Mst_MarketingCompany b on b.MarketingCompanyId = a.MarketingCompanyId
	left join Mst_IndependentContractorLevel c on c.IndependentContractorLevelId = a.IndependentContractorLevelId

	where a.IsDeleted = 0 and b.IsDeleted = 0

	and ' ;
		
	IF @MarketingCompanyId IS NULL
	BEGIN
		SET @Query += ' b.CountryCode in (''' + REPLACE(@CountryCode, ',', ''',''') + ''')';
	END
	ELSE
	BEGIN
		SET @Query += ' a.MarketingCompanyId = ' + CAST(@MarketingCompanyId AS NVARCHAR) ;
	END

	IF @Status IS NOT NULL
	BEGIN
		SET @Query += ' AND a.Status = ''' + @Status + '''';
	END

	--print @Query;
	exec sp_executesql @Query
END

 