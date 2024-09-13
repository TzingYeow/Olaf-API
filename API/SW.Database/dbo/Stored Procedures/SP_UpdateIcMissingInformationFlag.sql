-- =============================================
-- Author:		Asyraf Bakar
-- Create date: 12 December 2018
-- Description:	To update the flag of missing information for all Independent Contractors
-- =============================================
CREATE PROCEDURE SP_UpdateIcMissingInformationFlag
@BeginIndependentContractorId int, @EndIndependentContractorId int
AS
BEGIN
	SET NOCOUNT ON;

IF OBJECT_ID('tempdb..#AllIcMissingInformationTable') IS NOT NULL DROP TABLE #AllIcMissingInformationTable
IF OBJECT_ID('tempdb..#MissingInforamtionFlagTable') IS NOT NULL DROP TABLE #MissingInforamtionFlagTable

CREATE TABLE #AllIcMissingInformationTable(
	IndependentContractorId int,
    Description varchar(max),
)
DECLARE @CurrentIndependentContractorId int;
DECLARE independentContractorId_Cursor CURSOR FOR 
Select IndependentContractorId from Mst_IndependentContractor
where IsDeleted = 0 and IndependentContractorId >= @BeginIndependentContractorId and IndependentContractorId <= @EndIndependentContractorId;

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

Select IndependentContractorId, CASE WHEN Count(*) > 0 THEN 1 ELSE 0 END as HasMissingInformation
Into #MissingInforamtionFlagTable
from #AllIcMissingInformationTable
group by IndependentContractorId

Update a
SET HasMissingInformation =  CASE WHEN b.HasMissingInformation is null THEN 0 ELSE b.HasMissingInformation END
FROM Mst_IndependentContractor a
left join #MissingInforamtionFlagTable b on b.IndependentContractorId = a.IndependentContractorId
 
Drop table #AllIcMissingInformationTable
Drop table #MissingInforamtionFlagTable

END
