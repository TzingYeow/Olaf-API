-- =============================================
-- Author:		Leonard Yong
-- Create date: 2020-08-15
-- Description:	Adoption Rate Report
-- =============================================
--EXEC SP_RPT_Adoption_OverviewCountryDetail
CREATE PROCEDURE [dbo].[SP_RPT_Adoption_OverviewCountryDetail] 
	 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	SELECT * INTO #CountryList FROM(
	SELECT 'HK' as CountryCode , 'Hong Kong' as CountryName UNION ALL
	SELECT 'ID' as CountryCode , 'Indonesia' as CountryName UNION ALL
	SELECT 'IN' as CountryCode , 'India' as CountryName UNION ALL
	SELECT 'KR' as CountryCode , 'Korea' as CountryName UNION ALL
	SELECT 'MY' as CountryCode , 'Malaysia' as CountryName UNION ALL
	SELECT 'PH' as CountryCode , 'Philippines' as CountryName UNION ALL
	SELECT 'SG' as CountryCode , 'Singapore' as CountryName UNION ALL
	SELECT 'TH' as CountryCode , 'Thailand' as CountryName UNION ALL
	SELECT 'TW' as CountryCode , 'Taiwan' as CountryName 
	) A 

	SELECT  B.MoCode, B.MoName, C.*, D.CountryName FROM Mst_Weekending A 
	CROSS JOIN (
	SELECT Code as 'MoCode', Name as 'MoName', CountryCode FROM Mst_MarketingCompany where  IsActive = 1 and IsDeleted =0 and Code not in ('A','HQ'))
	 B 
	 LEFT JOIN RPT_OverviewDetailByCountry C ON A.WEdate = C.WeDate and B.MoCode = C.MoCode and C.Country = B.CountryCode
	 LEFT JOIN #CountryList D ON C.Country = D.CountryCode
	 WHERE   YEAR(A.WEdate) = YEAR(GETDATE())   and A.WEdate is not null and B.MoCode is not null and ISNULL(C.Country,'') <> ''
END
 
  --EXEC SP_RPT_Adoption_OverviewCountryDetail
