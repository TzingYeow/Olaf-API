 

-- ==========================================================================================
 
-- ==========================================================================================
--EXEC RPT_AdvancementReport '2024-05-12'
CREATE PROCEDURE [dbo].[RPT_AdvancementReport]
	@WeDate as Date	
AS
BEGIN

IF @WeDate = '2000-01-01'
BEGIN

SET @WeDate = (SELECT MAX(ScheduleWeekending) FROM TXN_AutoAdvancementResult WHERE ScheduleWeekending <= GETDATE() )
END
SELECT A.*, B.StartDate, B.Code as 'MCCode', D.CodeName FROM TXN_AutoAdvancementResult A LEFT JOIN VW_ICDetail B ON A.IndependentContractorID = B.IndependentContractorId 
LEFT JOIN Mst_IndependentContractor_BAInfo_Weekending BI on a.IndependentContractorID=BI.IndependentContractorId and bi.WeekendingDate=@WeDate
LEFT JOIN Mst_MarketingCompany C ON B.MarketingCompanyId = C.MarketingCompanyId
LEFT JOIN Mst_MasterCode D ON D.CodeType = 'BAType' and B.BAType = D.CodeId
WHERE ScheduleWeekending = @WeDate  
and A.IsDeleted = 0 and C.MarketingCompanyType ='Standard' and ISNULL(BI.BAType,B.BAType) in ('9999','6')
 
END
 
  

   