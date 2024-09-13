
-- =============================================
-- Author:		Syafiqah Ab Manah
-- Create date: 2020-11-05
-- Description:	Regional RC Analysis Aged Report 
-- SP_RPT_SGSuspensionList
-- =============================================
CREATE PROCEDURE [dbo].[SP_RPT_SGSuspensionList]
 
AS
BEGIN
	 SELECT B.Code, A.BadgeNo, C.Description, C.StartDate, C.EndDate FROM Mst_IndependentContractor A 
LEFT JOIN Mst_MarketingCompany B ON A.MarketingCompanyId = B.MarketingCompanyId
LEFT JOIN Mst_IndependentContractor_Suspension C ON A.IndependentContractorId = C.IndependentContractorId
where B.CountryCode ='SG' and A.IsSuspended = 1 AND A.IsDeleted = 0 AND A.Status = 'Active'

END



