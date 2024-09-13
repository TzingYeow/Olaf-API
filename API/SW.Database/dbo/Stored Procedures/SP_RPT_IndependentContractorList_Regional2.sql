 -- =============================================      
-- Author:  Tan Siuk Ching    
-- Create date: 15-07-2021         
-- Description: Report of Independent Contractor 
-- Execution: Exec SP_RPT_IndependentContractorList_Regional 'MY','Active,Inactive'  
-- =============================================       
CREATE PROCEDURE [dbo].[SP_RPT_IndependentContractorList_Regional2]      
(           
 @CountryCode NVARCHAR(255) = NULL,
 @Status NVARCHAR(50) = NULL
)      
AS      
BEGIN  

--DECLARE @CountryCode NVARCHAR(255) = 'ID,IN';
--DECLARE @Status NVARCHAR(50) = 'Active,Inactive';
--DECLARE @StartDate date = '2021-02-01';
--DECLARE @EndDate date = '2021-08-01';

IF OBJECT_ID('tempdb..#SubCountry') IS NOT NULL DROP TABLE #SubCountry
SELECT CAST(VALUE as varchar) as 'Country' INTO #SubCountry FROM STRING_SPLIT(@CountryCode, ',') 

IF CHARINDEX(',',@Status) > 0
   SET @Status = NULL;

-- Prepare the BA list
IF OBJECT_ID('tempdb..#TEMP_IndependentContractor') IS NOT NULL DROP TABLE #TEMP_IndependentContractor
SELECT a.*,
b.CountryCode,B.Code,B.Name,NULL AS BranchId
INTO #TEMP_IndependentContractor
from Mst_IndependentContractor a
left join Mst_MarketingCompany b on b.MarketingCompanyId = a.MarketingCompanyId
WHERE a.IsDeleted = 0 and b.IsDeleted = 0

IF((SELECT COUNT(*) FROM #SubCountry WHERE country <>'')>0)
BEGIN

	DELETE A
	FROM #TEMP_IndependentContractor A
	LEFT OUTER JOIN #SubCountry B on A.CountryCode = B.Country
	WHERE B.Country IS NULL
END

IF @Status IS NOT NULL
BEGIN
	IF @Status = 'Active'
	BEGIN
		DELETE A
		FROM #TEMP_IndependentContractor A	
		WHERE A.Status != @Status or a.IsSuspended = 1
	END
	ELSE IF @Status = 'Suspend'
	BEGIN
		DELETE A
		FROM #TEMP_IndependentContractor A	
		WHERE a.IsSuspended = 0
	END

	ELSE
	BEGIN
		DELETE A
		FROM #TEMP_IndependentContractor A	
		WHERE A.Status != @Status
	END
END

IF OBJECT_ID('tempdb..#TxnDeactiveTerminate') IS NOT NULL DROP TABLE #TxnDeactiveTerminate
Select IndependentContractorId,MAX(EffectiveDate) as 'EffectiveDate' INTO #TxnDeactiveTerminate from Mst_IndependentContractor_Movement where Description in ('Deactivate', 'Terminate') and IsDeleted = 0 and HasExecuted = 1
GROUP BY IndependentContractorId

IF OBJECT_ID('tempdb..#TxnPromotionDemotion') IS NOT NULL DROP TABLE #TxnPromotionDemotion
Select IndependentContractorId,IndependentContractorLevelId ,MAX(PromotionDemotionDate) as 'PromotionDemotionDate' INTO #TxnPromotionDemotion from Mst_IndependentContractor_Movement where Description in ('Advance') and IsDeleted = 0 and HasExecuted = 1 
GROUP by IndependentContractorId,IndependentContractorLevelId

IF OBJECT_ID('tempdb..#TxnAdvance') IS NOT NULL DROP TABLE #TxnAdvance
Select IndependentContractorId,IndependentContractorLevelId,MAX(EffectiveDate) as 'EffectiveDate' INTO #TxnAdvance from Mst_IndependentContractor_Movement where Description in ('Advance') and IsDeleted = 0 and HasExecuted = 1 
GROUP by IndependentContractorId,IndependentContractorLevelId

IF OBJECT_ID('tempdb..#TxnReactivation') IS NOT NULL DROP TABLE #TxnReactivation
Select IndependentContractorId,MAX(EffectiveDate) as 'EffectiveDate' INTO #TxnReactivation from Mst_IndependentContractor_Movement where Description in ('Re-activate','Reactivate') and IsDeleted = 0
GROUP by IndependentContractorId

IF OBJECT_ID('tempdb..#TxnReactivationMax') IS NOT NULL DROP TABLE #TxnReactivationMax
SELECT A.IndependentContractorId,MAX(IndependentContractorMovementID) as 'IndependentContractorMovementID' INTO #TxnReactivationMax
FROM Mst_IndependentContractor_Movement A
INNER JOIN (
Select IndependentContractorId,MAX(EffectiveDate) as 'EffectiveDate'  from Mst_IndependentContractor_Movement where Description in ('Re-activate','Reactivate')  and IsDeleted = 0
GROUP by IndependentContractorId) AS C ON A.IndependentContractorId = C.IndependentContractorId AND A.EffectiveDate = C.EffectiveDate
where A.Description in ('Re-activate','Reactivate')  and A.IsDeleted = 0
GROUP BY A.IndependentContractorId


IF OBJECT_ID('tempdb..#TxnReactivationRemark') IS NOT NULL DROP TABLE #TxnReactivationRemark
SELECT A.IndependentContractorId,Remark INTO #TxnReactivationRemark FROM Mst_IndependentContractor_Movement A
INNER JOIN #TxnReactivationMax B on A.IndependentContractorId = B.IndependentContractorId AND  A.IndependentContractorMovementID = B.IndependentContractorMovementID
where A.Description in ('Re-activate','Reactivate')  and A.IsDeleted = 0

IF OBJECT_ID('tempdb..#TxnLeavingCategoryMAX') IS NOT NULL DROP TABLE #TxnLeavingCategoryMAX
SELECT  A.IndependentContractorId,MAX(IndependentContractorMovementID) as 'IndependentContractorMovementID' INTO #TxnLeavingCategoryMAX FROM Mst_IndependentContractor_Movement A
INNER JOIN
(Select IndependentContractorId,MAX(EffectiveDate) as 'EffectiveDate' from Mst_IndependentContractor_Movement where IsDeleted = 0 and HasExecuted = 1  and Description in ('Deactivate', 'Terminate') 
GROUP BY IndependentContractorId) AS C on A.IndependentContractorId = C.IndependentContractorId AND A.EffectiveDate = C.EffectiveDate
WHERE A.IsDeleted = 0 and A.HasExecuted = 1  and A.Description in ('Deactivate', 'Terminate') 
group by A.IndependentContractorId

IF OBJECT_ID('tempdb..#TxnLeavingCategory') IS NOT NULL DROP TABLE #TxnLeavingCategory
SELECT A.IndependentContractorId,LeavingReasonCategory,LeavingReasonDescription INTO #TxnLeavingCategory FROM Mst_IndependentContractor_Movement A
INNER JOIN #TxnLeavingCategoryMAX B on A.IndependentContractorId = B.IndependentContractorId AND  A.IndependentContractorMovementID = B.IndependentContractorMovementID
WHERE A.IsDeleted = 0 and A.HasExecuted = 1  and A.Description in ('Deactivate', 'Terminate') 

IF OBJECT_ID('tempdb..#TxnBranchOut') IS NOT NULL DROP TABLE #TxnBranchOut
select IndependentContractorId,COUNT(*) as 'BranchOutCount' INTO #TxnBranchOut from Mst_IndependentContractor_BranchOut where IsDeleted = 0 and HasBranchedOut = 1 and HasReactivated = 0
GROUP BY IndependentContractorId

IF OBJECT_ID('tempdb..#TEMP_Movement') IS NOT NULL DROP TABLE #TEMP_Movement
SELECT IndependentContractorId,IndependentContractorLevelId,Description,IndependentContractorMovementId,PromotionDemotionDate,EffectiveDate INTO #TEMP_Movement FROM Mst_IndependentContractor_Movement
WHERE Description ='Advance'
and isdeleted = 0

-- UPDATE SALESBRANCH
UPDATE A SET A.SalesBranch = C.City  FROM #TEMP_IndependentContractor A 
INNER JOIN Mst_MarketingCompany B ON A.MarketingCompanyId = B.MarketingCompanyId
INNER JOIN Mst_MarketingCompany_Branch C ON SalesBranch = c.MarketingCompanyBranchId
WHERE ISNUMERIC(SalesBranch) = 1 

SELECT DISTINCT SALESBRANCH FROM #TEMP_IndependentContractor WHERE ISNUMERIC(SALESBRANCH) = 1

SELECT A.SalesBranch,C.City  FROM #TEMP_IndependentContractor A 
INNER JOIN Mst_MarketingCompany B ON A.MarketingCompanyId = B.MarketingCompanyId
INNER JOIN Mst_MarketingCompany_Branch C ON A.MarketingCompanyId = C.MarketingCompanyId and SalesBranch = c.MarketingCompanyBranchId
WHERE ISNUMERIC(SalesBranch) = 1 
 
IF OBJECT_ID('tempdb..#BRANCH') IS NOT NULL DROP TABLE #BRANCH
SELECT SalesBranch,A.MarketingCompanyId,B.MarketingCompanyBranchId,B.City, IndependentContractorId INTO #BRANCH FROM #TEMP_IndependentContractor A
INNER JOIN Mst_MarketingCompany_Branch B ON A.MarketingCompanyId = B.MarketingCompanyId AND A.SalesBranch = B.City 
PRINT '1'

SELECT * FROM #BRANCH WHERE ISNUMERIC(SalesBranch) = 1
 -- Exec SP_RPT_IndependentContractorList_Regional2 'MY','Active,Inactive'  

--SELECT MarketingCompanyId, BranchId,SalesBranch,   * FROM #TEMP_IndependentContractor
--WHERE IndependentContractorId NOT IN (SELECT IndependentContractorId FROM #BRANCH) AND SalesBranch IS NOT NULL

--UPDATE #TEMP_IndependentContractor SET BranchId = SalesBranch WHERE IndependentContractorId NOT IN (SELECT IndependentContractorId FROM #BRANCH) AND SalesBranch IS NOT NULL
--and SalesBranch Not in ('KLN')
--PRINT '1'
--UPDATE A SET BranchId = B.MarketingCompanyBranchId FROM  #TEMP_IndependentContractor A INNER JOIN #BRANCH B ON A.IndependentContractorId = B.IndependentContractorId 


--IF OBJECT_ID('tempdb..#TEMP_ICList') IS NOT NULL DROP TABLE #TEMP_ICList
Select
a.IndependentContractorId,a.BadgeNo,a.OriginalBadgeNo,a.FirstName,a.MiddleName,a.LastName,a.LocalFirstName,a.LocalLastName,
a.Nickname,a.Gender,a.Ic,a.PassportNo,a.Dob,a.PhoneNumber,a.MobileNumber,a.Email,a.Nationality,a.BondPercentage,a.ReportBadgeNo,
a.BankCountryCode,a.BankName,a.BankBranch,a.BankAccountNo,a.BankAccountName,a.BankSwiftCode,a.TaxNumber,a.StartDate,a.AgreementSignedDate,a.DateFirstOnField,a.LastSalesSubmissionDate,
a.Status,a.HasMissingInformation,a.IndependentContractorLevelId,
a.ReturnMaterialRemarks,a.RecruitmentType,a.RecruiterBadgeNoOrName,a.RecruitmentSource,a.RecruitmentSubSource,
a.AddressLine1, a.AddressLine2, a.AddressLine3, a.AddressCity, a.AddressState, a.AddressPostCode, a.AddressCountry,
a.AdvertisementTitle,a.CreatedBy,a.CreatedDate,a.UpdatedBy,a.UpdatedDate,a.IsSuspended, -- a.LastDeactivateDate,

CASE WHEN A.BAType = '1' THEN 'Hourly Rate' ELSE 'Normal' END AS BAType,


E.EffectiveDate as  LastDeactivateDate,
F.PromotionDemotionDate as  AdvancementDate,
G.EffectiveDate as  EffectiveAdvancementDate,

lAdv.PromotionDemotionDate as LeaderAdvancementDate,  lAdv.EffectiveDate as LeaderEffectiveDate,
tlAdv.PromotionDemotionDate as TeamLeaderAdvancementDate,  tlAdv.EffectiveDate as TeamLeaderEffectiveDate,
stlAdv.PromotionDemotionDate as SeniorTeamLeaderAdvancementDate,  stlAdv.EffectiveDate as SeniorTeamLeaderEffectiveDate,
aoAdv.PromotionDemotionDate as AsstOwnerAdvancementDate,  aoAdv.EffectiveDate as  AsstOwnerEffectiveDate,
opAdv.PromotionDemotionDate as OwnerPartnerAdvancementDate,  opAdv.EffectiveDate as OwnerPartnerEffectiveDate,
oAdv.PromotionDemotionDate as OwnerAdvancementDate,  oAdv.EffectiveDate as OwnerEffectiveDate,


H.EffectiveDate as 'ReactivationDate',
I.Remark 'ReactivationDateRemark',

(CASE WHEN a.Status != 'Active' and a.IsStayBackTeam = 1 and ISNULL(a.IsGoBackTeam,0) = 0 THEN 'Branched-Out' ELSE
J.LeavingReasonCategory END) as 'ReasonforLeaving',
J.LeavingReasonDescription as 'ReasonforLeavingDescription',
K.BranchOutCount as 'HasBranchedOut', 
--added on 11/02
(CASE WHEN a.Status = 'Active' 
THEN 
(Select SUBSTRING((SELECT ',' + y.CampaignName AS 'data()' FROM Mst_IndependentContractor_Assignment x 
left join Mst_Campaign y on x.CampaignId = y.CampaignId  where x.IsDeleted = 0 and y.IsDeleted = 0 
and x.IndependentContractorId = a.IndependentContractorId and (x.EndDate is null or x.EndDate >= GETDATE()) FOR XML PATH('') ), 2 , 9999))
ELSE
(SELECT TOP 1 y.CampaignName  FROM Mst_IndependentContractor_Assignment x  left 
join Mst_Campaign y on x.CampaignId = y.CampaignId  where x.IsDeleted = 0 
and y.IsDeleted = 0  and x.EndDate is not null and x.IndependentContractorId = a.IndependentContractorId order by StartDate desc) 
END)AS Campaigns

--Marketing Company
,a.Code,a.Name,a.CountryCode

-- Level
,c.IndependentContractorLevelId as newIClevel,c.LevelCode,c.Level,c.LevelOrdinal, brch.City AS SalesBranch -- into #TEMP_ICList
from #TEMP_IndependentContractor a
left join Mst_MarketingCompany_Branch brch on a.BranchId = brch.MarketingCompanyBranchId
left join Mst_IndependentContractorLevel c on c.IndependentContractorLevelId = a.IndependentContractorLevelId
left join #TEMP_Movement lAdv on lAdv.IndependentContractorId = a.IndependentContractorId and lAdv.IndependentContractorLevelId = 4 
left join #TEMP_Movement tlAdv on tlAdv.IndependentContractorId = a.IndependentContractorId and tlAdv.IndependentContractorLevelId = 7
left join #TEMP_Movement stlAdv on stlAdv.IndependentContractorId = a.IndependentContractorId and stlAdv.IndependentContractorLevelId = 8
left join #TEMP_Movement aoAdv on aoAdv.IndependentContractorId = a.IndependentContractorId and aoAdv.IndependentContractorLevelId = 1
left join #TEMP_Movement opAdv on opAdv.IndependentContractorId = a.IndependentContractorId and opAdv.IndependentContractorLevelId = 2
left join #TEMP_Movement oAdv on oAdv.IndependentContractorId = a.IndependentContractorId and oAdv.IndependentContractorLevelId = 5

left join Mst_IndependentContractor_BranchOut d on d.IndependentContractorId = a.IndependentContractorId and d.IsDeleted = 0 and d.HasBranchedOut = 1

left outer join #TxnDeactiveTerminate  E on E.IndependentContractorId = a.IndependentContractorId 
LEFT OUTER JOIN #TxnPromotionDemotion F on F.IndependentContractorId = a.IndependentContractorId AND F.IndependentContractorLevelId = a.IndependentContractorLevelId
LEFT OUTER JOIN #TxnAdvance G on G.IndependentContractorId = a.IndependentContractorId AND G.IndependentContractorLevelId = a.IndependentContractorLevelId
LEFT OUTER JOIN #TxnReactivation H ON H.IndependentContractorId = a.IndependentContractorId
LEFT OUTER JOIN #TxnReactivationRemark I on I.IndependentContractorId = a.IndependentContractorId
LEFT OUTER JOIN #TxnLeavingCategory J on J.IndependentContractorId = A.IndependentContractorId
LEFT OUTER JOIN #TxnBranchOut K on K.IndependentContractorId = A.IndependentContractorId
where 
(lAdv.IndependentContractorMovementId is null or lAdv.IndependentContractorMovementId = (SELECT MAX(IndependentContractorMovementId) FROM #TEMP_Movement x WHERE x.IndependentContractorId = lAdv.IndependentContractorId AND x.IndependentContractorLevelId = lAdv.IndependentContractorLevelId ))
and
(tlAdv.IndependentContractorMovementId is null or tlAdv.IndependentContractorMovementId = (SELECT MAX(IndependentContractorMovementId) FROM #TEMP_Movement x WHERE x.IndependentContractorId = tlAdv.IndependentContractorId AND x.IndependentContractorLevelId = tlAdv.IndependentContractorLevelId))
and
(stlAdv.IndependentContractorMovementId is null or stlAdv.IndependentContractorMovementId = (SELECT MAX(IndependentContractorMovementId) FROM #TEMP_Movement x WHERE x.IndependentContractorId = stlAdv.IndependentContractorId AND x.IndependentContractorLevelId = stlAdv.IndependentContractorLevelId))
and
(aoAdv.IndependentContractorMovementId is null or aoAdv.IndependentContractorMovementId = (SELECT MAX(IndependentContractorMovementId) FROM #TEMP_Movement x WHERE x.IndependentContractorId = aoAdv.IndependentContractorId AND x.IndependentContractorLevelId = aoAdv.IndependentContractorLevelId))
and
(opAdv.IndependentContractorMovementId is null or opAdv.IndependentContractorMovementId = (SELECT MAX(IndependentContractorMovementId) FROM #TEMP_Movement x WHERE x.IndependentContractorId = opAdv.IndependentContractorId AND x.IndependentContractorLevelId = opAdv.IndependentContractorLevelId))
and
(oAdv.IndependentContractorMovementId is null or oAdv.IndependentContractorMovementId = (SELECT MAX(IndependentContractorMovementId) FROM #TEMP_Movement x WHERE x.IndependentContractorId = oAdv.IndependentContractorId AND x.IndependentContractorLevelId = oAdv.IndependentContractorLevelId))

order by IndependentContractorId

END 


 

