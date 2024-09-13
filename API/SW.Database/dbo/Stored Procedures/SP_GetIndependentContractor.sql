-- =============================================
-- Author:		Asyraf Bakar
-- Create date: 26 June 2019
-- Description:	To geat IndependentContractorList
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetIndependentContractor]
@CountryAccess varchar(150)
AS
BEGIN	
	SET NOCOUNT ON;

	IF OBJECT_ID('tempdb..#MovementLvlId1') IS NOT NULL DROP TABLE #MovementLvlId1
	IF OBJECT_ID('tempdb..#MovementLvlId2') IS NOT NULL DROP TABLE #MovementLvlId2
	IF OBJECT_ID('tempdb..#MovementLvlId4') IS NOT NULL DROP TABLE #MovementLvlId4
	IF OBJECT_ID('tempdb..#MovementLvlId5') IS NOT NULL DROP TABLE #MovementLvlId5
	IF OBJECT_ID('tempdb..#MovementLvlId7') IS NOT NULL DROP TABLE #MovementLvlId7
	IF OBJECT_ID('tempdb..#MovementLvlId8') IS NOT NULL DROP TABLE #MovementLvlId8
	IF OBJECT_ID('tempdb..#LeavingReason') IS NOT NULL DROP TABLE #LeavingReason
	IF OBJECT_ID('tempdb..#Campaigns') IS NOT NULL DROP TABLE #Campaigns
 
	SELECT B.*, C.PromotionDemotionDate, C.EffectiveDate 
	INTO #MovementLvlId1
	FROM (
	SELECT A.IndependentContractorId, MAX(A.IndependentContractorMovementId) as IndependentContractorMovementId FROM Mst_IndependentContractor_Movement A
	WHERE A.IsDeleted = 0
	AND A.IndependentContractorLevelId  = 1
	group by A.IndependentContractorId ) B
	INNER JOIN Mst_IndependentContractor_Movement C ON B.IndependentContractorMovementId = C.IndependentContractorMovementId

	SELECT B.*, C.PromotionDemotionDate, C.EffectiveDate 
	INTO #MovementLvlId2
	FROM (
	SELECT A.IndependentContractorId, MAX(A.IndependentContractorMovementId) as IndependentContractorMovementId FROM Mst_IndependentContractor_Movement A
	WHERE A.IsDeleted = 0
	AND A.IndependentContractorLevelId  = 2
	group by A.IndependentContractorId ) B
	INNER JOIN Mst_IndependentContractor_Movement C ON B.IndependentContractorMovementId = C.IndependentContractorMovementId

	SELECT B.*, C.PromotionDemotionDate, C.EffectiveDate 
	INTO #MovementLvlId4
	FROM (
	SELECT A.IndependentContractorId, MAX(A.IndependentContractorMovementId) as IndependentContractorMovementId FROM Mst_IndependentContractor_Movement A
	WHERE A.IsDeleted = 0
	AND A.IndependentContractorLevelId  = 4
	group by A.IndependentContractorId ) B
	INNER JOIN Mst_IndependentContractor_Movement C ON B.IndependentContractorMovementId = C.IndependentContractorMovementId

	SELECT B.*, C.PromotionDemotionDate, C.EffectiveDate 
	INTO #MovementLvlId5
	FROM (
	SELECT A.IndependentContractorId, MAX(A.IndependentContractorMovementId) as IndependentContractorMovementId FROM Mst_IndependentContractor_Movement A
	WHERE A.IsDeleted = 0
	AND A.IndependentContractorLevelId  = 5
	group by A.IndependentContractorId ) B
	INNER JOIN Mst_IndependentContractor_Movement C ON B.IndependentContractorMovementId = C.IndependentContractorMovementId

	SELECT B.*, C.PromotionDemotionDate, C.EffectiveDate 
	INTO #MovementLvlId7
	FROM (
	SELECT A.IndependentContractorId, MAX(A.IndependentContractorMovementId) as IndependentContractorMovementId FROM Mst_IndependentContractor_Movement A
	WHERE A.IsDeleted = 0
	AND A.IndependentContractorLevelId  = 7
	group by A.IndependentContractorId ) B
	INNER JOIN Mst_IndependentContractor_Movement C ON B.IndependentContractorMovementId = C.IndependentContractorMovementId

	SELECT B.*, C.PromotionDemotionDate, C.EffectiveDate 
	INTO #MovementLvlId8
	FROM (
	SELECT A.IndependentContractorId, MAX(A.IndependentContractorMovementId) as IndependentContractorMovementId FROM Mst_IndependentContractor_Movement A
	WHERE A.IsDeleted = 0
	AND A.IndependentContractorLevelId  = 8
	group by A.IndependentContractorId ) B
	INNER JOIN Mst_IndependentContractor_Movement C ON B.IndependentContractorMovementId = C.IndependentContractorMovementId

	SELECT A.*, B.LeavingReasonCategory
	INTO #LeavingReason
	FROM (
	Select IndependentContractorId, MAX(IndependentContractorMovementId) IndependentContractorMovementId
	from Mst_IndependentContractor_Movement where IsDeleted = 0 and HasExecuted = 1 and Description in ('Deactivate', 'Terminate')
	GROUP BY IndependentContractorId ) A
	INNER JOIN Mst_IndependentContractor_Movement B ON A.IndependentContractorMovementId = B.IndependentContractorMovementId

	Select DISTINCT(IndependentContractorId), (Select SUBSTRING(
		(SELECT ',' + y.CampaignName AS 'data()'
		FROM Mst_IndependentContractor_Assignment x left join Mst_Campaign y on x.CampaignId = y.CampaignId
		where x.IsDeleted = 0 and y.IsDeleted = 0 and x.IndependentContractorId = a.IndependentContractorId
		and (x.EndDate is null or x.EndDate >= GETDATE()) FOR XML PATH('') ), 2 , 9999)) As Campaigns
	INTO #Campaigns
	from Mst_IndependentContractor_Assignment a where a.IsDeleted = 0
	
	Select
	--Independent Contractor
	--lAdv.IndependentContractorMovementId,
	a.IndependentContractorId,a.BadgeNo,a.OriginalBadgeNo,a.FirstName,a.MiddleName,a.LastName,a.LocalFirstName,a.LocalLastName,
	a.Nickname,a.Gender,a.Ic,a.PassportNo,a.Dob,a.PhoneNumber,a.MobileNumber,a.Email,a.Nationality,a.BondPercentage,a.ReportBadgeNo,
	a.BankName,a.BankBranch,a.BankAccountNo,a.BankAccountName,a.BankSwiftCode,a.TaxNumber,a.StartDate,a.DateFirstOnField,a.LastSalesSubmissionDate,
	a.Status,a.LastDeactivateDate,a.HasMissingInformation,a.IndependentContractorLevelId,
	a.ReturnMaterialRemarks,a.RecruitmentType,a.RecruiterBadgeNoOrName,a.RecruitmentSource,
	a.AddressLine1, a.AddressLine2, a.AddressLine3, a.AddressCity, a.AddressState, a.AddressPostCode, a.AddressCountry,
	a.AdvertisementTitle,a.CreatedBy,a.CreatedDate,a.UpdatedBy,a.UpdatedDate,
     
	CAST(null as datetime) as AdvancementDate,
	CAST(null as datetime) as EffectiveAdvancementDate,
	--	(Select Top 1 Max(PromotionDemotionDate) from Mst_IndependentContractor_Movement where Description in ('Advance','Demote') and IsDeleted = 0 and HasExecuted = 1 and IndependentContractorId = a.IndependentContractorId and IndependentContractorLevelId = a.IndependentContractorLevelId ) AdvancementDate,
	--(Select Top 1 Max(EffectiveDate) from Mst_IndependentContractor_Movement where Description in ('Advance','Demote') and IsDeleted = 0 and HasExecuted = 1 and IndependentContractorId = a.IndependentContractorId and IndependentContractorLevelId = a.IndependentContractorLevelId ) EffectiveAdvancementDate,
	lAdv.PromotionDemotionDate as LeaderAdvancementDate,  lAdv.EffectiveDate as LeaderEffectiveDate,
	tlAdv.PromotionDemotionDate as TeamLeaderAdvancementDate,  tlAdv.EffectiveDate as TeamLeaderEffectiveDate,
	stlAdv.PromotionDemotionDate as SeniorTeamLeaderAdvancementDate,  stlAdv.EffectiveDate as SeniorTeamLeaderEffectiveDate,
	aoAdv.PromotionDemotionDate as AsstOwnerAdvancementDate,  aoAdv.EffectiveDate as  AsstOwnerEffectiveDate,
	opAdv.PromotionDemotionDate as OwnerPartnerAdvancementDate,  opAdv.EffectiveDate as OwnerPartnerEffectiveDate,
	oAdv.PromotionDemotionDate as OwnerAdvancementDate,  oAdv.EffectiveDate as OwnerEffectiveDate, 

	(CASE WHEN a.IsStayBackTeam = 1 THEN 'Branched-Out' ELSE leavingReason.LeavingReasonCategory END) as 'ReasonforLeaving',
	(Select CASE WHEN Count(*) > 0 THEN 1 ELSE 0 END from Mst_IndependentContractor_BranchOut where IsDeleted = 0 and HasBranchedOut = 1 and HasReactivated = 0 and IndependentContractorId = a.IndependentContractorId ) as 'HasBranchedOut',
	d.Campaigns,

	--Marketing Company
	b.Code,b.Name,b.CountryCode,
								
	-- Level
	--,c.IndependentContractorLevelId,
	c.LevelCode,c.Level,c.LevelOrdinal

	INTO #ICListResult
	from Mst_IndependentContractor a
	inner join Mst_MarketingCompany b on b.MarketingCompanyId = a.MarketingCompanyId AND b.IsDeleted = 0
	inner join Mst_IndependentContractorLevel c on c.IndependentContractorLevelId = a.IndependentContractorLevelId

	left join #MovementLvlId4 lAdv on lAdv.IndependentContractorId = a.IndependentContractorId
	left join #MovementLvlId7 tlAdv on tlAdv.IndependentContractorId = a.IndependentContractorId
	left join #MovementLvlId8 stlAdv on stlAdv.IndependentContractorId = a.IndependentContractorId
	left join #MovementLvlId1 aoAdv on aoAdv.IndependentContractorId = a.IndependentContractorId
	left join #MovementLvlId2 opAdv on opAdv.IndependentContractorId = a.IndependentContractorId
	left join #MovementLvlId5 oAdv on oAdv.IndependentContractorId = a.IndependentContractorId
	left join #LeavingReason leavingReason on a.IndependentContractorId = leavingReason.IndependentContractorId
	left join #Campaigns d on d.IndependentContractorId = a.IndependentContractorId
	
	where a.IsDeleted = 0 and @CountryAccess like '%'+b.CountryCode+'%'

	Update #ICListResult
	Set AdvancementDate = CASE
							WHEN IndependentContractorLevelId = 1 THEN AsstOwnerAdvancementDate
							WHEN IndependentContractorLevelId = 2 THEN OwnerPartnerAdvancementDate
							WHEN IndependentContractorLevelId = 4 THEN LeaderAdvancementDate
							WHEN IndependentContractorLevelId = 5 THEN OwnerAdvancementDate
							WHEN IndependentContractorLevelId = 7 THEN TeamLeaderAdvancementDate
							WHEN IndependentContractorLevelId = 8 THEN SeniorTeamLeaderAdvancementDate
							ELSE null
						END,
		EffectiveAdvancementDate = CASE
							WHEN IndependentContractorLevelId = 1 THEN AsstOwnerEffectiveDate
							WHEN IndependentContractorLevelId = 2 THEN OwnerPartnerEffectiveDate
							WHEN IndependentContractorLevelId = 4 THEN LeaderEffectiveDate
							WHEN IndependentContractorLevelId = 5 THEN OwnerEffectiveDate
							WHEN IndependentContractorLevelId = 7 THEN TeamLeaderEffectiveDate
							WHEN IndependentContractorLevelId = 8 THEN SeniorTeamLeaderEffectiveDate
							ELSE null
						END
						 
	Select * from #ICListResult order by IndependentContractorId
	
	DROP TABLE #MovementLvlId1
	DROP TABLE #MovementLvlId2
	DROP TABLE #MovementLvlId4
	DROP TABLE #MovementLvlId5
	DROP TABLE #MovementLvlId7
	DROP TABLE #MovementLvlId8
	DROP TABLE #LeavingReason
	DROP TABLE #Campaigns
	DROP TABLE #ICListResult
END; 