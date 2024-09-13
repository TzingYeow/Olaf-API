
-- =============================================
-- Author:		Syafiqah Ab Manah
-- Create date: 2020-11-05
-- Description:	Regional RC Analysis Aged Report 
-- EXEC SP_RPT_OlafSuspensionList
-- 
-- =============================================
CREATE PROCEDURE [dbo].[SP_RPT_OlafSuspensionList]
 
AS
BEGIN

--SELECT m.CountryCode, m.Code, m.Name, i.BadgeNo, CONCAT(i.FirstName, i.MiddleName, ' ', i.LastName) BadgeName, s.StartDate, s.EndDate, s.Description 
--FROM Mst_IndependentContractor_Suspension s INNER JOIN Mst_IndependentContractor i ON s.IndependentContractorId = i.IndependentContractorId
--INNER JOIN Mst_MarketingCompany m ON i.MarketingCompanyId = m.MarketingCompanyId
--WHERE s.IsDeleted = 0 AND i.IsSuspended = 1 AND i.Status = 'Active'
--ORDER BY m.CountryCode, m.Code, i.BadgeNo

SELECT m.CountryCode, m.Code, m.Name, i.BadgeNo,CONCAT(i.FirstName, i.MiddleName, ' ', i.LastName) AS 'BadgeName',i.Status, 
s.StartDate as StartDate, s.EndDate as EndDate, s.Description
FROM Mst_IndependentContractor_Suspension s 
INNER JOIN Mst_IndependentContractor i ON s.IndependentContractorId = i.IndependentContractorId
INNER JOIN Mst_MarketingCompany m ON i.MarketingCompanyId = m.MarketingCompanyId
WHERE s.IsDeleted = 0
ORDER BY m.CountryCode, m.Code, i.BadgeNo, i.Status, s.StartDate asc


END



