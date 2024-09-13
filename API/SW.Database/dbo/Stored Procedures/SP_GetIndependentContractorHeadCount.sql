-- =============================================
-- Author:		Asyraf Bakar
-- Create date: 26 June 2019
-- Description:	To geat headCount for Ic Overview
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetIndependentContractorHeadCount]
@CountryAccess varchar(150)
AS
BEGIN	
	SET NOCOUNT ON;
	IF OBJECT_ID('tempdb..#TempIcCount') IS NOT NULL DROP TABLE #TempIcCount
	IF OBJECT_ID('tempdb..#TempResult') IS NOT NULL DROP TABLE #TempResult

	Select 
	b.Code as McCode,
	b.CountryCode as McCountryCode, c.Level, c.LevelCode,
	IIF(IsStayBackTeam = 1,'Branched-Out',Status ) as Status,ISNULL(IsStayBackTeam,0) as IsStayBackTeam , Count(*) as HeadCount
	INTO #TempIcCount
	from Mst_IndependentContractor a
	left join Mst_MarketingCompany b on b.MarketingCompanyId = a.MarketingCompanyId
	left join Mst_IndependentContractorLevel c on c.IndependentContractorLevelId = a.IndependentContractorLevelId
	where a.IsDeleted = 0
	and @CountryAccess like '%'+b.CountryCode+'%'
	group by Status,IsStayBackTeam, b.Code,b.CountryCode,c.Level,c.LevelCode

	Select 
	McCode,McCountryCode,Level,LevelCode, 
	(Select Sum(HeadCount) from #TempIcCount x where x.Status = 'Active' and x.Level = a.Level and x.McCode = a.McCode)as ActiveHeadCount,
	(Select Sum(HeadCount) from #TempIcCount x where x.Status = 'Inactive' and x.Level = a.Level and x.McCode = a.McCode)as InactiveHeadCount,
	(Select Sum(HeadCount) from #TempIcCount x where x.Status = 'Branched-Out' and x.Level = a.Level and x.McCode = a.McCode)as BranchedOutCount,
	(Select Sum(HeadCount) from #TempIcCount x where x.Status = 'On-Hold' and x.Level = a.Level and x.McCode = a.McCode)as OnHoldOutCount,
	(Select Sum(HeadCount) from #TempIcCount x where x.Status = 'Transferred' and x.Level = a.Level and x.McCode = a.McCode)as TransferredCount
	INTO #TempResult
	from #TempIcCount a	
	group by McCode,McCountryCode,Level,LevelCode
	 
	Select * from #TempResult
	order by McCountryCode, McCode

	DROP TABLE #TempIcCount
	DROP TABLE #TempResult
END
