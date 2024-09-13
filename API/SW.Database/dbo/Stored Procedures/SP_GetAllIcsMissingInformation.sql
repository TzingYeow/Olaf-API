-- =============================================
-- Author:		Asyraf Bakar
-- Create date: 18 October 2018
-- Description:	To get the list of missing information for all Independent Contractors
-- =============================================
CREATE PROCEDURE SP_GetAllIcsMissingInformation
AS
BEGIN
	SET NOCOUNT ON;

IF OBJECT_ID('tempdb..#AllIcMissingInformationTable') IS NOT NULL DROP TABLE #AllIcMissingInformationTable

CREATE TABLE #AllIcMissingInformationTable(
	IndependentContractorId int,
    Description varchar(max),
)
DECLARE @CurrentIndependentContractorId int;
DECLARE independentContractorId_Cursor CURSOR FOR 
Select IndependentContractorId from Mst_IndependentContractor
where IsDeleted = 0;

OPEN independentContractorId_Cursor  
FETCH NEXT FROM independentContractorId_Cursor INTO @CurrentIndependentContractorId
  
WHILE @@FETCH_STATUS = 0  
BEGIN 
	INSERT INTO #AllIcMissingInformationTable 
    EXEC SP_GetIndividualIcMissingInformation @IndependentContractorId = @CurrentIndependentContractorId, @ResultIncludeIndependentContractorId = 1
	FETCH NEXT FROM independentContractorId_Cursor INTO @CurrentIndependentContractorId 
END 

CLOSE independentContractorId_Cursor  
DEALLOCATE independentContractorId_Cursor 

SElect * from #AllIcMissingInformationTable
Drop table #AllIcMissingInformationTable

END
