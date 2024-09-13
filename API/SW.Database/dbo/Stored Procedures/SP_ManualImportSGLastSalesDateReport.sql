
-- =============================================
-- Author:		Tan Siuk Ching
-- Create date: 05/03/2021
-- Description:	IC Suspend Reminder Email
--EXEC SP_ManualImportSGLastSalesDateReport
-- =============================================
CREATE PROCEDURE [dbo].[SP_ManualImportSGLastSalesDateReport]  
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
--	SELECT C.BadgeNo as 'BadgeNo', C.LastSalesDate as 'LastSalesDate',D.Description as 'Suspension Description', D.StartDate as 'SuspendStartDate',  D.EndDate as 'SuspendEndDate'  FROM Mst_IndependentContractor A LEFT JOIN Mst_MarketingCompany B ON A.MarketingCompanyId = B.MarketingCompanyId
--INNER JOIN txn_Temp_ManualLastSalesDate C ON A.BadgeNo = C.BadgeNo
--LEFT JOIN Mst_IndependentContractor_Suspension D ON A.IndependentContractorId = D.IndependentContractorId
--WHERE B.CountryCode = 'SG' and D.IndependentContractorId is not null and D.IsDeleted = 0
--and ((C.LastSalesDate >= D.StartDate and C.LastSalesDate <= D.EndDate ) OR (A.LastDeactivateDate < C.LastSalesDate))


--SELECT C.BadgeNo as 'BadgeNo', C.LastSalesDate as 'LastSalesDate' , A.LastDeactivateDate  FROM Mst_IndependentContractor A LEFT JOIN Mst_MarketingCompany B ON A.MarketingCompanyId = B.MarketingCompanyId
--INNER JOIN txn_Temp_ManualLastSalesDate C ON A.BadgeNo = C.BadgeNo 
--WHERE B.CountryCode = 'SG' 
-- and A.LastDeactivateDate < C.LastSalesDate
--SELECT A.LastSalesSubmissionDate , C.LastSalesDate  FROM Mst_IndependentContractor A LEFT JOIN Mst_MarketingCompany B ON A.MarketingCompanyId = B.MarketingCompanyId
--INNER JOIN txn_Temp_ManualLastSalesDate C ON A.BadgeNo = C.BadgeNo 
--WHERE B.CountryCode = 'SG' and ISNULL(A.LastDeactivateDate,'3000-01-01') >= C.LastSalesDate and A.LastSalesSubmissionDate < C.LastSalesDate


UPDATE A SET A.LastSalesSubmissionDate = C.LastSalesDate  FROM Mst_IndependentContractor A LEFT JOIN Mst_MarketingCompany B ON A.MarketingCompanyId = B.MarketingCompanyId
INNER JOIN txn_Temp_ManualLastSalesDate C ON A.BadgeNo = C.BadgeNo 
WHERE B.CountryCode = 'SG' 
 and A.Status = 'Active' and ISNULL(A.LastSalesSubmissionDate,'2000-01-01') < C.LastSalesDate
 
 --EXEC SP_ManualImportSGLastSalesDateReport
END

