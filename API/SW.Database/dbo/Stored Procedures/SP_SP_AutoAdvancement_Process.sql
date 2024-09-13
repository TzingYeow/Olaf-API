--EXEC SP_SP_AutoAdvancement_Process 1
--=============================
CREATE PROCEDURE [dbo].[SP_SP_AutoAdvancement_Process] 
	@Process as Bit
AS
BEGIN
	DECLARE @WeDate as DATE
	SET @WeDate = (SELECT TOP 1 WEdate FROM Mst_Weekending where wedate < GETDATE() order by WEdate desc)
   
	DROP TABLE IF EXISTS #Result
	SELECT A.* INTO #Result FROM TXN_AutoAdvancementResult A LEFT JOIN Mst_IndependentContractor B ON A.IndependentContractorID = B.IndependentContractorId
	LEFT JOIN Mst_MarketingCompany C ON B.MarketingCompanyId = C.MarketingCompanyId WHERE ScheduleWeekending = @WeDate
	and A.FinalResult = 'YES' and b.BAType = '9999' and C.MarketingCompanyType in ('Standard') and A.badgeNo not like 'PN0001'-- and IndependentContractorID = 41818 --and BAStatus = 'Active'
 
	IF @WeDate = '2022-05-15'
	BEGIN
		INSERT INTO #Result 
		SELECT * FROM TXN_AutoAdvancementResult WHERE ScheduleWeekending = @WeDate and IndependentContractorID = 25556
		  UPDATE #Result SET FinalResult = 'YES', IndependentContractorLevelId = 8 WHERE  IndependentContractorID = 25556
	END
	   
	SELECT A.*, C.LevelOrdinal, D.IndependentContractorLevelId as 'NewIndependentContractorLevelId', ISNULL(B.EffectiveAdvancementDate,B.StartDate) as 'LastAdvanceDate' INTO #ConfirmedAdvanceBA FROM #Result A 
	LEFT JOIN Mst_IndependentContractor B ON A.IndependentContractorID = B.IndependentContractorID
	LEFT JOIN Mst_IndependentContractorLevel C ON A.IndependentContractorLevelId = C.IndependentContractorLevelId
	LEFT JOIN Mst_IndependentContractorLevel D ON C.LevelOrdinal + 1 = D.LevelOrdinal 
	WHERE FinalResult = 'YES' and B.MarketingCompanyId not in (1474)  
	   

	IF @Process = 1
	BEGIN

		--Insert into Movement
		INSERT INTO Mst_IndependentContractor_Movement (IndependentContractorId, Description,IndependentContractorLevelId, PromotionDemotionDate, EffectiveDate, HasExecuted, IsDeleted, CreatedBy, CreatedDate)
		SELECT IndependentContractorId, 'Advance', C.IndependentContractorLevelId as '@ICLevel' , @WeDate, CAST(DATEADD(DAY, 7, @WeDate) as date), 0, 0, 'AutoAdvancement', GETDATE()  
		FROM #ConfirmedAdvanceBA A
		LEFT JOIN Mst_IndependentContractorLevel B ON A.IndependentContractorLevelId = B.IndependentContractorLevelId
		LEFT JOIN Mst_IndependentContractorLevel C ON C.LevelOrdinal  = B.LevelOrdinal  + CASE WHEN B.IndependentContractorLevelId = 7 and A.CountryCode not in ('KR')  THEN 2 ELSE 1 END -- Level 7 Skip STL.
	END

 DECLARE @LOOP as BIT
 DECLARE @IndependentContractor as INT
 DECLARE @CountryCode as NVARCHAR(5)
 DECLARE @CurrentLevel as INT
 DECLARE @AdvancementDate as NVARCHAR(50)
 SET @LOOP = 0

 IF (SELECT COUNT(*) FROM #ConfirmedAdvanceBA) > 0 BEGIN SET @LOOP = 1 END
  

	 SELECT '#ConfirmedAdvanceBA',* FROM #ConfirmedAdvanceBA

	 IF @Process = 0
	 BEGIN
		SET @LOOP = 0
	 END
  
  --Loop to blast Email
 WHILE @LOOP = 1
 BEGIN
	SET @IndependentContractor = (SELECT TOP 1 IndependentContractorID FROM #ConfirmedAdvanceBA order by IndependentContractorID)
	
	SELECT @CountryCode = CountryCode, @CurrentLevel = IndependentContractorLevelId FROM #ConfirmedAdvanceBA WHERE IndependentContractorID = @IndependentContractor
	
	SET @AdvancementDate = CONVERT(NVARCHAR(50),@WeDate,103) 

 
	EXEC SP_PushAutoAdvancement @countryCode, @AdvancementDate, @IndependentContractor,@CurrentLevel
	DELETE FROM #ConfirmedAdvanceBA where IndependentContractorID = @IndependentContractor
	IF (SELECT COUNT(*) FROM #ConfirmedAdvanceBA) > 0 BEGIN SET @LOOP = 1 END ELSE BEGIN SET @LOOP = 0 END
 END
 

END
 --EXEC SP_ProcessOlafAutoAdvancement  0
 --INSERT INTO TXN_EmailQueue
 --SELECT * FROM TXN_EmailQueue2
  
   
    

   --SELECT * FROM Mst_Localization WHERE TextTag = 'EmailAutoAdvancementOP'
    