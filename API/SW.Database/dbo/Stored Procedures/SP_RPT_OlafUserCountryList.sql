
-- =============================================
-- Author:		Syafiqah Ab Manah
-- Create date: 2020-11-05
-- Description:	Regional RC Analysis Aged Report 
-- EXEC SP_RPT_OlafUserCountryList '14fc947b85c64becbaa90b0dab6e5356' 
-- 
-- =============================================
CREATE PROCEDURE [dbo].[SP_RPT_OlafUserCountryList]
	@UserID NVARCHAR(35)
AS
BEGIN
	DECLARE @CountryList NVARCHAR(MAX)
	
	SET @CountryList = (SELECT CountryAccess FROM MST_user where UserId = @UserID)
	 
	SELECT A.id as 'CountryCode', B.CodeName as 'CountryName' FROM dbo.StringSplit(@CountryList) A 
	LEFT JOIN Mst_MasterCode B ON A.id = B.CodeId and B.CodeType = 'CountryCode'
	 
	 

END
 