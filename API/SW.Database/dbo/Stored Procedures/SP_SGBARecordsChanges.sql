-- =====================================================================================================
-- Author:		Syafiqah Ab Manah
-- Create date: 2020-06-24
-- Description:	To retrieve Singapore BA Records (Updated Data on Previous Day)
-- =====================================================================================================
CREATE PROCEDURE [dbo].[SP_SGBARecordsChanges]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT B.CountryCode AS [Country Code],B.Code AS [MC Code],B.Name AS [MC Name],(CASE WHEN B.IsActive = '1' THEN 'Active' ELSE 'Not Active' END) AS [MC Status],
	BadgeNo,FirstName,LastName, A.Status AS [BA Status],
	CONVERT(VARCHAR(10), A.StartDate , 103) AS [Start Date],
	(Select Top 1 CONVERT(VARCHAR(10), EffectiveDate , 103) from Mst_IndependentContractor_Movement where Description in ('Deactivate', 'Terminate') and IsDeleted = 0 and HasExecuted = 1 and IndependentContractorId = A.IndependentContractorId  order by EffectiveDate desc) [Deactivated Date],
	CONVERT(VARCHAR(10), A.DateFirstOnField , 103) AS [Date First On Field],
	CONVERT(VARCHAR(10), A.UpdatedDate , 103) AS [Updated Date],
	(CASE WHEN C.Username IS NULL THEN A.UpdatedBy ELSE C.Username END) AS [Updated By]
	FROM Mst_IndependentContractor_Archive A
	INNER JOIN Mst_MarketingCompany B ON A.MarketingCompanyId = B.MarketingCompanyId
	LEFT JOIN Mst_User C ON A.UpdatedBy = C.UserId
	WHERE B.CountryCode = 'SG' AND B.IsActive = 1 AND CAST(A.UpdatedDate AS DATE)= CAST(DATEADD(DAY, -1, GETDATE()) AS DATE)
	ORDER BY Code ASC, [Updated Date] DESC, BadgeNo ASC
END
