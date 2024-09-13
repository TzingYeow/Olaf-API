-- =============================================
-- Author:		Leonard Yong
-- Create date: 2020-08-15
-- Description:	Adoption Rate Report
-- =============================================
--EXEC SP_RPT_SuspensionOverview
CREATE PROCEDURE [dbo].[SP_RPT_SuspensionOverview] 
	 
AS
BEGIN
	DROP TABLE IF EXISTS #SuspensionMax
	SELECT IndependentContractorId, MAX(StartDate) StartDate, MAX(EndDate) as EndDate INTO #SuspensionMax 
	FROM Mst_IndependentContractor_Suspension A WHERE IsDeleted = 0
	GROUP BY IndependentContractorId

	DROP TABLE IF EXISTS #SUSPENDEDRecord
	SELECT A.* INTO #SUSPENDEDRecord FROM Mst_IndependentContractor_Suspension A 
	INNER JOIN #SuspensionMax B ON A.IndependentContractorId = B.IndependentContractorId
	and A.StartDate = B.StartDate and A.EndDate = B.EndDate

	SELECT B.CountryCode, B.Code, B.Name, A.BadgeNo, A.FirstName, A.LastName, A.LastSalesSubmissionDate, A.DateFirstOnField, 
	DATEDIFF(DAY,ISNULL(A.LastSalesSubmissionDate,A.DateFirstOnField), GETDATE()) as Aging, IIF( A.IsSuspended= 1 ,'Yes','No') as 'IsSuspended', 
	C.StartDate as 'SStartDate', C.EndDate as 'SEndDate', IIF( C.IsReactivate = 1 ,'Yes','No') as 'Reactivate' FROM MST_independentContractor A 
	LEFT JOIN Mst_MarketingCompany B ON A.MarketingCompanyId = B.MarketingCompanyId
	LEFT JOIN #SUSPENDEDRecord C ON A.IndependentContractorId = C.IndependentContractorId
	WHERE A.IsDeleted = 0 and A.Status = 'Active'
	ORDER BY CountryCode, Code, BadgeNo

	DROP TABLE IF EXISTS #SuspensionMax
	DROP TABLE IF EXISTS #SUSPENDEDRecord
END
 
 