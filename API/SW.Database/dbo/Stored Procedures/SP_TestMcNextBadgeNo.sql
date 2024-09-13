-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_TestMcNextBadgeNo]
AS
BEGIN
	DECLARE @MarketingCompanyId int;
	DECLARE independentContractorId_Cursor CURSOR FOR 
	Select MarketingCompanyId from Mst_MarketingCompany
	where IsDeleted = 0 and IsActive = 1

	OPEN independentContractorId_Cursor  
	FETCH NEXT FROM independentContractorId_Cursor INTO @MarketingCompanyId
 
	CREATE TABLE #tempTestbadge (MarketingCompanyId int,MarketingCompanyCode varchar(10), NextbadgeNo VARCHAR(MAX));
	WHILE @@FETCH_STATUS = 0  
	BEGIN  		
		CREATE TABLE #tempResultSP (OUTPUT VARCHAR(MAX));
		INSERT INTO #tempResultSP EXEC SP_GetNextBadgeNo @MarketingCompanyId = @MarketingCompanyId
	 
		INSERT INTO #tempTestbadge	VALUES	(@MarketingCompanyId,(Select Top 1 Code from Mst_MarketingCompany where MarketingCompanyId = @MarketingCompanyId),(Select Top 1 *  from #tempResultSP) )
	 
		Drop TABLE #tempResultSP 
		FETCH NEXT FROM independentContractorId_Cursor INTO @MarketingCompanyId 
	END 
	Select * from #tempTestbadge;
	Drop TABLE #tempTestbadge;
	CLOSE independentContractorId_Cursor  
	DEALLOCATE independentContractorId_Cursor 


 
END
