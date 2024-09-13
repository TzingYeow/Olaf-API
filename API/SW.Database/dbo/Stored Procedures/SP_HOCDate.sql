

-- =============================================
-- Author:		Asyraf Bakar
-- Create date: 18 October 2018
-- Description:	To get the list of missing information for all Independent Contractors
-- =============================================
--EXEC SP_HOCDate 272
CREATE PROCEDURE [dbo].[SP_HOCDate]
@MarketingCompanyID as int 
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @CountryCode NVARCHAR(2)
	DECLARE @MoCode NVARCHAR(10)
	DECLARE @CDate as DATE
	SET @CDate = GETDATE()
	--SET @CDate = '2022-06-09'
	DROP TABLE IF EXISTS #DayList
	CREATE TABLE #DayList(
		DayDate DATE,
		DayString NVARCHAR(12) 
	)
	
	INSERT INTO #DayList SELECT DATEADD(Day,2,@CDate) ,FORMAT(DATEADD(Day,2,@CDate),'dd-MMM-yyyy')
	INSERT INTO #DayList SELECT DATEADD(Day,1,@CDate) ,FORMAT(DATEADD(Day,1,@CDate),'dd-MMM-yyyy')
	INSERT INTO #DayList SELECT @CDate,FORMAT(@CDate,'dd-MMM-yyyy')
	SELECT @CountryCode = CountryCode, @MoCode = Code 
	FROM Mst_MarketingCompany WHERE MarketingCompanyId = @MarketingCompanyID 
 
	IF @CountryCode = 'TW' 
	BEGIN
		IF (SELECT COUNT(*) FROM NewTWDB_PROD..Txn_WeekendingConfirmation WHERE MoCode = @MoCode and WeDate = (
			SELECT WeDate FROM NewTWDB_PROD..Tbl_Weekending 
			WHERE FromDate <= DATEADD(Day,-1,@CDate)  and ToDate >= DATEADD(Day,-1,@CDate)
		)) = 0
		BEGIN 
			INSERT INTO #DayList SELECT DATEADD(Day,-1,@CDate) ,FORMAT(DATEADD(Day,-1,@CDate),'dd-MMM-yyyy')
		END

		IF (SELECT COUNT(*) FROM NewTWDB_PROD..Txn_WeekendingConfirmation WHERE MoCode = @MoCode and WeDate = (
			SELECT WeDate FROM NewTWDB_PROD..Tbl_Weekending 
			WHERE FromDate <= DATEADD(Day,-2,@CDate)  and ToDate >= DATEADD(Day,-2,@CDate)
		)) = 0
		BEGIN 
			INSERT INTO #DayList SELECT DATEADD(Day,-2,@CDate) ,FORMAT(DATEADD(Day,-2,@CDate),'dd-MMM-yyyy')
		END
	END 
	ELSE
	BEGIN
		
			INSERT INTO #DayList SELECT DATEADD(Day,-1,@CDate) ,FORMAT(DATEADD(Day,-1,@CDate),'dd-MMM-yyyy')
			
			INSERT INTO #DayList SELECT DATEADD(Day,-2,@CDate) ,FORMAT(DATEADD(Day,-2,@CDate),'dd-MMM-yyyy')
	END 

	SELECT * FROM #DayList
END

--EXEC SP_HOCDate 272
 
