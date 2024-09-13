

-- =============================================
-- Author:		Asyraf Bakar
-- Create date: 18 October 2018
-- Description:	To get the list of missing information for all Independent Contractors
-- =============================================
--EXEC SP_HOCLocation 272,'N'
CREATE PROCEDURE [dbo].[SP_HOCLocation]
@MarketingCompanyID as int,
@Code as NVARCHAR(10)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @CountryCode NVARCHAR(2)
	DECLARE @MoCode NVARCHAR(10)
 
	  
	SELECT @CountryCode = CountryCode, @MoCode = Code 
	FROM Mst_MarketingCompany WHERE MarketingCompanyId = @MarketingCompanyID 
 
	IF @CountryCode = 'TW' 
	BEGIN
		 SELECT  Code, CodeName FROM NewTWDB_PROD..Tbl_MasterCode where CodeType = 'CHLocationCode'
		 and IsActive = 1 --and Code like '%' + @Code + '%' Order by Code
	END 

	IF @CountryCode = 'MY' 
	BEGIN
		 SELECT Code, CodeName FROM NewMYDB_PROD..Tbl_MasterCode where CodeType = 'TerritoryCode'
		 and IsActive = 1 --and Code like '%' + @Code + '%' Order by Code
	END  

	IF @CountryCode = 'TH' 
	BEGIN
		 SELECT CodeId as 'Code', CodeName as 'CodeName'  FROM NewTHDB_PROD..Mst_MasterCode where CodeType = 'CHTerritory'
		 and IsActive = 1 --and CodeId like '%' + @Code + '%' Order by Code
	END 
END
  
