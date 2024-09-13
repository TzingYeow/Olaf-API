




CREATE VIEW [dbo].[VW_Reporting_TXN_BA_Movement]
AS
SELECT A.IndependentContractorMovementId, A.IndependentContractorId AS 'BAId', D.BadgeNo, D.OriginalBadgeNo, C.MarketingCompanyId as 'MCId', C.Code as 'MCCode', C.Name as 'MCName', C.CountryCode as 'MCCountry', CAST(CASE WHEN C.IsActive = 1 THEN 'Active' Else 'Inactive' END as nvarchar(10)) as  'MCStatus', A.Description,A.PromotionDemotionDate, A.EffectiveDate, A.LeavingReasonCategory, A.LeavingReasonDescription, A.MovementDuration, A.Remark, A.HasExecuted, A.MovementTypeId, A.CreatedBy, A.CreatedDate, A.UpdatedBy, A.UpdatedDate, A.IndependentContractorLevelId, B.LevelCode, B.Level, B.ParentLevel, B.LevelOrdinal, B.IsActive as 'LevelActive', B.IsDemotionLevel 
FROM Mst_IndependentContractor_Movement A
INNER JOIN Mst_IndependentContractorLevel B ON A.IndependentContractorLevelId = B.IndependentContractorLevelId 
LEFT JOIN Mst_IndependentContractor D ON A.IndependentContractorId = D.IndependentContractorId
LEFT JOIN  Mst_MarketingCompany C ON D.MarketingCompanyId = C.MarketingCompanyId
WHERE A.IsDeleted = 0 AND B.IsDeleted = 0  
