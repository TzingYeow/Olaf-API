
-- =============================================
-- Author:		Syafiqah Ab Manah
-- Create date: 2020-11-05
-- Description:	Regional RC Analysis Aged Report 
-- EXEC SP_RPT_OlafUserMCList '12046e8e0480455cb787b28ffbca92c6' ,'MY'
-- 
-- =============================================
CREATE PROCEDURE [dbo].[SP_RPT_OlafUserMCList]
	@UserID NVARCHAR(35),
	@CountryCode NVARCHAR(100)
AS
BEGIN
	DECLARE @CountryList NVARCHAR(MAX)
	DECLARE @UserRoleCode NVARCHAR(1)

	DROP TABLE IF EXISTS #MCResult
	CREATE TABLE #MCResult(
		MarketingCompanyID INT,
		MCName NVARCHAR(100),
		CountryCode NVARCHAR(20),
		MCCode NVARCHAR(10)
	)

	SET @UserRoleCode = (SELECT UserRoleCode FROM MST_user A LEFT JOIN Mst_UserRole B ON A.UserRoleId = B.UserRoleId where UserId = @UserID)
	 
	SET @CountryList = (SELECT CountryAccess FROM MST_user where UserId = @UserID)
	
		
	IF @UserRoleCode = 'M'
	BEGIN
		INSERT INTO #MCResult
		SELECT A.MarketingCompanyId,  B.Code + ': ' +  B.Name + ' ( ' + B.CountryCode + ' )' as 'Description', B.CountryCode, B.Code FROM MST_user A LEFT JOIN Mst_MarketingCompany B ON A.MarketingCompanyId = B.MarketingCompanyId
		where UserId = @UserID  and B.CountryCode IN (SELECT Id FROM dbo.StringSplit( @CountryCode))
		Order by B.Code
	END
	ELSE
	BEGIN
		INSERT INTO #MCResult
		 SELECT B.MarketingCompanyId,  B.Code + ': ' +  B.Name + ' ( ' + B.CountryCode + ' )' as 'Description', B.CountryCode, B.Code FROM  Mst_MarketingCompany B  
		where CountryCode in (SELECT Id FROM dbo.StringSplit(@CountryList)) and B.CountryCode IN (SELECT Id FROM dbo.StringSplit( @CountryCode))
		Order by B.Code
	END

	SELECT * FROM #MCResult
	order by Countrycode, MCCode
 
	


	 

END
 