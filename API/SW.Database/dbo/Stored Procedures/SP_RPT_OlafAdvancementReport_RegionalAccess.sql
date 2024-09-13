
-- =============================================
-- Author:		Syafiqah Ab Manah
-- Create date: 2020-11-05
-- Description:	Regional RC Analysis Aged Report 
-- EXEC [SP_RPT_OlafAdvancementReport_RegionalAccess] '2023-01-01','2023-12-04','b2a2a1706a0d403598e9115d5846485d','KR'

-- =============================================
CREATE PROCEDURE [dbo].[SP_RPT_OlafAdvancementReport_RegionalAccess]
 	 @FromDate Date,
	 @ToDate Date,
	 @userId NVARCHAR(255),
	 @selectedCountry NVARCHAR(255)

AS
BEGIN
--select * from mst_user where USERNAME = 'SYAFIQAH'
--select * from Mst_UserRole

DECLARE @CountryCode NVARCHAR(255);
DECLARE @IsMOAdminRole BIT;
DECLARE @MCId NVARCHAR(10);

DECLARE @SFROMDATE DATE
DECLARE @STODATE DATE

SELECT @SFROMDATE = FromDate FROM Mst_Weekending WHERE WEdate = @FromDate
SELECT @STODATE = ToDate FROM Mst_Weekending WHERE WEdate = @ToDate


SELECT 
@CountryCode = CountryAccess,
@IsMOAdminRole = CASE WHEN UserRoleId = 3 THEN  1 ELSE 0 END,
@MCId =  MarketingCompanyId
FROM Mst_User WHERE UserId = @userId

IF OBJECT_ID('tempdb..#SelectedCountry') IS NOT NULL DROP TABLE #SelectedCountry
SELECT CAST(VALUE as varchar) as 'Country' INTO #SelectedCountry FROM STRING_SPLIT(@selectedCountry, ',') 

DROP TABLE IF EXISTS #Temp

SELECT C.CountryCode, C.Code as 'MCCode', C.Name as 'MCName',  B.BadgeNo, B.Status, 
ISNULL(B.FirstName,'') + ' ' + ISNULL(B.LastName,'') as 'BAName', D.level, D.LevelOrdinal, A.* INTO #Temp  
FROM Mst_IndependentContractor_Movement A 
LEFT JOIN Mst_IndependentContractor B ON A.IndependentContractorId = B.IndependentContractorId
LEFT JOIN Mst_MarketingCompany C ON B.MarketingCompanyId = C.MarketingCompanyId
LEFT JOIN Mst_IndependentContractorLevel D ON A.IndependentContractorLevelId = D.IndependentContractorLevelId
WHERE A.Description in ('Advance','Demote','De-advance')
and A.IndependentContractorId in (
SELECT IndependentContractorId FROM Mst_IndependentContractor_Movement A  WHERE A.Description in ('Advance')
and A.PromotionDemotionDate >=@SFROMDATE
and A.PromotionDemotionDate <=@STODATE and A.IsDeleted = 0
) and A.isdeleted = 0
  
UPDATE A SET A.Level = A.Level + ' R' FROM #Temp A INNER JOIN (
 SELECT IndependentContractorId,Level,MAX(PromotionDemotionDate)PromotionDemotionDate FROM #Temp
 WHERE Description = 'Advance'
 GROUP BY IndependentContractorId, Level
 having count(*)>1
) B ON A.IndependentContractorId = B.IndependentContractorId  and A.Level = B.Level AND CAST(A.PromotionDemotionDate AS DATE) = CAST(B.PromotionDemotionDate AS DATE)

DELETE FROM #Temp WHERE Description in ('Demote','De-advance')

 DROP TABLE IF EXISTS #RawData
 SELECT IndependentContractorId, IndependentContractorLevelId, CountryCode, MCCode,  BadgeNo, BAName,  Status, Level,
 MAX(PromotionDemotionDate) as 'PromotionDemotionDate' INTO #RawData  FROM #Temp 
 GROUP BY IndependentContractorId,IndependentContractorLevelId, CountryCode, MCCode,  BadgeNo, BAName, Status, Level 

	SELECT A.CountryCode 'Country Code', A.MCCode 'MC Code', MarketingCompanyId, A.BadgeNo 'ID Badge', A.BAName 'Full Name', L.Level as 'Current Level', 
	PromotionDemotionDate as 'Advancement Date', D.WEdate as 'WeDate',
	a.level 'Level Advanced', C.Status INTO #RESULT FROM #RawData A 
	LEFT JOIN Mst_IndependentContractor C ON A.IndependentContractorId = C.IndependentContractorId
	LEFT JOIN Mst_IndependentContractorLevel L ON C.IndependentContractorLevelId = L.IndependentContractorLevelId
	LEFT JOIN Mst_Weekending D ON A.PromotionDemotionDate >= D.FromDate and A.PromotionDemotionDate <= D.ToDate 
	order by A.CountryCode, A.BadgeNo, PromotionDemotionDate

	SELECT R.*,M.Name 'MC Name',S.Name 'Owner Name' 
	FROM #RESULT R
	LEFT JOIN Mst_MarketingCompany M ON R.MarketingCompanyId = M.MarketingCompanyId And M.IsDeleted = 0
	LEFT JOIN Mst_MarketingCompany_Staff S ON M.MarketingCompanyId = S.MarketingCompanyId AND S.IsDeleted =0
	WHERE  	CountryCode IN (SELECT Country FROM #SelectedCountry)
	AND [Advancement Date] >=@SFROMDATE and [Advancement Date] <=@STODATE 
	ORDER BY [Country Code], [MC Code] , [Advancement Date] ASC
END



-- EXEC [SP_RPT_OlafAdvancementReport_RegionalAccess] '2022-12-26','2023-06-11','b2a2a1706a0d403598e9115d5846485d','MY','A,AE,AR,AU,CM,EC,IM,NA,TT,UL,UM,UN,LO,HQ,MP,MT,IW,UI,SM,MB,VP,JX,TR,SF,ST,EA,SV,ED,MM,SC,PX,SR,MS,JV,WA,GN,ET,UR,MW,JD,CE,UV,SS,JE,JC'
