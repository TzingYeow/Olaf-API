 -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- =============================================
-- Author:		Tan Siuk Ching
-- Create date: 2021-07-06
-- Description:	GetAllIndependentContractor
-- Execution: Exec [SP_GetAllIndependentContractor]  null,'HK,KR,MY,TH,TW,SG',null
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetAllIndependentContractor]
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


Select MAX(PromotionDemotionDate)PromotionDemotionDate,IndependentContractorId,IndependentContractorLevelId
into #Movement
from Mst_IndependentContractor_Movement  A
where Description in (''Advance'') and IsDeleted = 0 and HasExecuted = 1 
GROUP BY independentContractorId,IndependentContractorLevelId
 

 SELECT A.IndependentContractorId,max(x.StartDate) StartDate   into #Inactive  FROM Mst_IndependentContractor_Assignment x 
 LEFT JOIN Mst_IndependentContractor A ON A.IndependentContractorId=X.IndependentContractorAssigmentId
 left join Mst_Campaign y on x.CampaignId = y.CampaignId  where x.IsDeleted = 0 
	and y.IsDeleted = 0  and x.EndDate is not null  AND A.Status=''Inactive'' group by A.IndependentContractorId
	 
SELECT A.IndependentContractorId,Y.CampaignName
INTO #InactiveCampaign
FROM #Inactive A
LEFT JOIN
Mst_IndependentContractor_Assignment X ON A.IndependentContractorId=X.CampaignId AND A.StartDate=X.StartDate
 left join Mst_Campaign y on x.CampaignId = y.CampaignId  where x.IsDeleted = 0 

Select
 STRING_AGG(CampaignName, '','') CampangName
 ,A.IndependentContractorId into #Campaign 
 FROM Mst_IndependentContractor_Assignment x 
 LEFT JOIN Mst_IndependentContractor A
 ON A.IndependentContractorId=X.IndependentContractorId
	left join Mst_Campaign y on x.CampaignId = y.CampaignId  where x.IsDeleted = 0 and y.IsDeleted = 0 
	 and (x.EndDate is null or x.EndDate >= GETDATE())
	 and A.Status =''Active''
	 group by A.IndependentContractorId

	Select 
	--Independent Contractor
	a.IndependentContractorId,a.BadgeNo,a.OriginalBadgeNo,a.FirstName,a.MiddleName,a.LastName,a.LocalFirstName,a.LocalLastName,
	a.PhoneNumber,a.MobileNumber,a.Email,
	a.Status,a.IndependentContractorLevelId,a.IsSuspended,

	CASE WHEN A.BAType = ''1'' THEN ''Hourly Rate'' ELSE ''Normal'' END AS BAType,

	d.PromotionDemotionDate AdvancementDate,

	CASE WHEN a.Status = ''Active''
	THEN 
	 e.CampangName
	ELSE
	f.CampaignName end    Campaigns,

	--Marketing Company
	b.Code,b.Name,b.CountryCode

	-- Level
	,c.IndependentContractorLevelId,c.LevelCode,c.Level,c.LevelOrdinal, A.SalesBranch

	from Mst_IndependentContractor a
	left join Mst_MarketingCompany b on b.MarketingCompanyId = a.MarketingCompanyId
	left join Mst_IndependentContractorLevel c on c.IndependentContractorLevelId = a.IndependentContractorLevelId

	left join #Movement d on a.IndependentContractorId=d.IndependentContractorId and a.IndependentContractorLevelId=d.IndependentContractorLevelId
	left join #Campaign e on a.IndependentContractorId=e.IndependentContractorId
	left join #InactiveCampaign f on a.IndependentContractorId=f.IndependentContractorId
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

	print @Query;
	exec sp_executesql @Query
END
 