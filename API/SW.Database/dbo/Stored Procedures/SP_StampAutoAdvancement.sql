 
	CREATE PROCEDURE [dbo].[SP_StampAutoAdvancement]
		@CustomWEDate as Date	
	AS
	BEGIN
	
		SET NOCOUNT ON;
		DROP TABLE IF EXISTS #CountryWe
		CREATE TABLE #CountryWe
		(
			ScheduleWeekending DATE,
			CountryCode NVARCHAR(2),
			We1 DATE,
			We1Days INT,
			We2 DATE,
			We2Days INT,
			isAuto BIT
		)
 
		DECLARE @WeDate as Date =    (SELECT TOP 1 WEdate  FROM (
		SELECT TOP 1 * FROM MST_Weekending WHERE WEdate < CAST(GETDATE() as date) ORDER BY WEdate desc
		) B ORDER BY B.WEdate ASC)
   
		IF @CustomWEDate is NOT NULL
		SET @WeDate = @CustomWEDate
	
		--Prepare MY
		INSERT INTO #CountryWe (ScheduleWeekending,CountryCode, We1, We1Days)
		SELECT TOP 1 @WeDate,'MY', WeDate, DATEDIFF(DAY, FromDate, ToDate) + 1  FROM NewMYDB_PROD..Tbl_Weekending A WHERE WEdate  = @WeDate 
 
		UPDATE A SET A.We2 = B.WEdate, A.We2Days = B.Total, A.isAuto = CASE WHEN A.We1Days = 7 and B.Total = 7 THEN 1 ELSE 0 END  FROM #CountryWe A LEFT JOIN
		(SELECT TOP 1 'MY' as 'CountryCode', WeDate, DATEDIFF(DAY, FromDate, ToDate) + 1 'Total'  FROM NewMYDB_PROD..Tbl_Weekending A WHERE A.WEdate  < @WeDate ORDER BY A.WEdate DESC)
		B ON A.CountryCode = B.CountryCode
		WHERE A.CountryCode = 'MY'

		--Prepare TW
		INSERT INTO #CountryWe (ScheduleWeekending,CountryCode, We1, We1Days)
		SELECT TOP 1 @WeDate,'TW', WeDate, DATEDIFF(DAY, FromDate, ToDate) + 1  FROM NewTWDB_PROD..Tbl_Weekending A WHERE WEdate  = @WeDate 
 
		UPDATE A SET A.We2 = B.WEdate, A.We2Days = B.Total, A.isAuto = CASE WHEN A.We1Days = 7 and B.Total = 7 THEN 1 ELSE 0 END  FROM #CountryWe A LEFT JOIN
		(SELECT TOP 1 'TW' as 'CountryCode', WeDate, DATEDIFF(DAY, FromDate, ToDate) + 1 'Total'  FROM NewTWDB_PROD..Tbl_Weekending A WHERE A.WEdate  < @WeDate ORDER BY A.WEdate DESC)
		B ON A.CountryCode = B.CountryCode
		WHERE A.CountryCode = 'TW'
	 
		--Prepare HK
		INSERT INTO #CountryWe (ScheduleWeekending,CountryCode, We1, We1Days)
		SELECT TOP 1 @WeDate,'HK', WeDate, DATEDIFF(DAY, FromDate, ToDate) + 1  FROM NewHKDB_PROD..MST_Weekending A WHERE WEdate  = @WeDate 
 
		UPDATE A SET A.We2 = B.WEdate, A.We2Days = B.Total, A.isAuto = CASE WHEN A.We1Days = 7 and B.Total = 7 THEN 1 ELSE 0 END  FROM #CountryWe A LEFT JOIN
		(SELECT TOP 1 'HK' as 'CountryCode', WeDate, DATEDIFF(DAY, FromDate, ToDate) + 1 'Total'  FROM NewHKDB_PROD..MST_Weekending A WHERE A.WEdate  < @WeDate ORDER BY A.WEdate DESC)
		B ON A.CountryCode = B.CountryCode
		WHERE A.CountryCode = 'HK'
	 
		--Prepare HK
		INSERT INTO #CountryWe (ScheduleWeekending,CountryCode, We1, We1Days)
		SELECT TOP 1 @WeDate,'TH', WeDate, DATEDIFF(DAY, FromDate, ToDate) + 1  FROM NewTHDB_PROD..MST_Weekending A WHERE WEdate  = @WeDate 
  
		UPDATE A SET A.We2 = B.WEdate, A.We2Days = B.Total, A.isAuto = CASE WHEN A.We1Days = 7 and B.Total = 7 THEN 1 ELSE 0 END  FROM #CountryWe A LEFT JOIN
		(SELECT TOP 1 'TH' as 'CountryCode', WeDate, DATEDIFF(DAY, FromDate, ToDate) + 1 'Total'  FROM NewTHDB_PROD..MST_Weekending A WHERE A.WEdate  < @WeDate ORDER BY A.WEdate DESC)
		B ON A.CountryCode = B.CountryCode
		WHERE A.CountryCode = 'TH'
	
		--Prepare KR
		INSERT INTO #CountryWe (ScheduleWeekending,CountryCode, We1, We1Days)
		SELECT TOP 1 @WeDate,'KR', WeDate, DATEDIFF(DAY, FromDate, ToDate) + 1  FROM Appco360_PROD..MST_Weekending A WHERE WEdate  = @WeDate 
		and Country = 'KR'

		UPDATE A SET A.We2 = B.WEdate, A.We2Days = B.Total, A.isAuto = 1  FROM #CountryWe A LEFT JOIN
		(SELECT TOP 1 'KR' as 'CountryCode', WeDate, DATEDIFF(DAY, FromDate, ToDate) + 1 'Total'  FROM Appco360_PROD..MST_Weekending A WHERE A.WEdate  < @WeDate ORDER BY A.WEdate DESC)
		B ON A.CountryCode = B.CountryCode
		WHERE A.CountryCode = 'KR'
	   
	   	--Prepare Indonesia
		INSERT INTO #CountryWe (ScheduleWeekending,CountryCode, We1, We1Days)
		SELECT TOP 1 @WeDate,'ID', WeDate, DATEDIFF(DAY, FromDate, ToDate) + 1  FROM NewIndoDB_PROD..Tbl_Weekending A WHERE WEdate  = @WeDate 
 
		UPDATE A SET A.We2 = B.WEdate, A.We2Days = B.Total, A.isAuto = CASE WHEN A.We1Days = 7 and B.Total = 7 THEN 1 ELSE 0 END  FROM #CountryWe A LEFT JOIN
		(SELECT TOP 1 'ID' as 'CountryCode', WeDate, DATEDIFF(DAY, FromDate, ToDate) + 1 'Total'  FROM NewIndoDB_PROD..Tbl_Weekending A WHERE A.WEdate  < @WeDate ORDER BY A.WEdate DESC)
		B ON A.CountryCode = B.CountryCode
		WHERE A.CountryCode = 'ID'


	
		UPDATE TXN_AutoAdvancementResult set Isdeleted = 1, UpdatedDate = GETDATE() WHERE ScheduleWeekending = @WeDate and isdeleted = 0

		SELECT We1 as 'WeDate', A.CountryCode, A.We1, B.BadgeNo, B.DirectReportBadgeNo,REPLACE(REPLACE(ISNULL(B.BadgeNoLink,''),'\','->'),'~','->') as BadgeNoLink , 'Active' as 'Status', 
		IndependentContractorID, C.IndependentContractorLevelId, CurrentLevel, ISNULL(B.NetValue,0.00) as 'personalSales', ISNULL(B.NetPcs,0.00) as 'personalPcs', ISNULL(B.NetPoint,0.00) as 'PersonalPoint', CASE WHEN RTRIM(ISNULL(D.Province,'')) = '' THEN 'Non-Province' ELSE D.Province END as 'CurrentProvince', E.Province as 'CriterialProvince',
		ISNULL(F.Level,'') as 'TeamSizeLevel',	ISNULL(E.SalesValue,0.00) as 'SalesValue',ISNULL(E.PersonalSalesPieces,0.00) as 'SalesPcs', ISNULL(E.TeamSize,0) as 'TeamSize', ISNULL(E.SalesPoint,0) as 'SalesPoint', ISNULL(E.FirstGenLeader,0) as 'FirstGenLeader',CASE WHEN A.isAuto = 0 THEN 'ShortWeek' ELSE '' END as 'Remark', C.IndependentContractorLevelId as 'CurrentIdLevel',
		ISNULL(B.SubPcs,0) as 'SubPcs', E.TeamSizeSale, ISNULL(B.WeLevel, B.CurrentLevel) as 'WeLevel', B.LevelPromotionDate
		INTO #We1Result FROM #CountryWe A 
		LEFT JOIN TXN_WeeklyBASummary B ON A.CountryCode = B.CountryCode and A.We1 = B.WeDate
		LEFT JOIN Mst_IndependentContractorLevel C ON B.CurrentLevel = C.LevelCode
		LEFT JOIN Mst_MarketingCompany D ON B.MCCode = D.Code and D.CountryCode = B.CountryCode
		LEFT JOIN Mst_AdvancementCriteria E ON A.CountryCode = E.CountryCode and E.IndependentContractorLevelId = C.IndependentContractorLevelId 
			and E.Province =  CASE WHEN RTRIM(ISNULL(D.Province,'')) = '' THEN 'Non-Province' ELSE D.Province END and E.IsDeleted = 0
			and E.StartDate <= We1 and E.EndDate >= We1
		LEFT JOIN Mst_IndependentContractorLevel F ON E.TeamSizeLevel = F.IndependentContractorLevelId
		WHERE  B.IsDeleted = 0

		SELECT We2 as 'WeDate', A.CountryCode, A.We2, B.BadgeNo, B.DirectReportBadgeNo, REPLACE(REPLACE(ISNULL(B.BadgeNoLink,''),'\','->'),'~','->') as BadgeNoLink, 'Active' as 'Status', 
		IndependentContractorID, C.IndependentContractorLevelId, CurrentLevel, ISNULL(B.NetValue,0.00) as 'personalSales', ISNULL(B.NetPcs,0.00) as 'personalPcs', ISNULL(B.NetPoint,0.00) as 'PersonalPoint', CASE WHEN RTRIM(ISNULL(D.Province,'')) = '' THEN 'Non-Province' ELSE D.Province END as 'CurrentProvince', E.Province as 'CriterialProvince',
		ISNULL(F.Level,'') as 'TeamSizeLevel',ISNULL(E.SalesValue,0.00) as 'SalesValue',ISNULL(E.PersonalSalesPieces,0.00) as 'SalesPcs', ISNULL(E.TeamSize,0) as 'TeamSize', ISNULL(E.SalesPoint,0) as 'SalesPoint', ISNULL(E.FirstGenLeader,0) as 'FirstGenLeader',CASE WHEN A.isAuto = 0 THEN 'ShortWeek' ELSE '' END as 'Remark', C.IndependentContractorLevelId as 'CurrentIdLevel',
		ISNULL(B.SubPcs,0) as 'SubPcs', E.TeamSizeSale, ISNULL(B.WeLevel, B.CurrentLevel) as 'WeLevel' , B.LevelPromotionDate
		INTO #We2Result FROM #CountryWe A 
		LEFT JOIN TXN_WeeklyBASummary B ON A.CountryCode = B.CountryCode and A.We2 = B.WeDate
		LEFT JOIN Mst_IndependentContractorLevel C ON B.CurrentLevel = C.LevelCode
		LEFT JOIN Mst_MarketingCompany D ON B.MCCode = D.Code and D.CountryCode = B.CountryCode
		LEFT JOIN Mst_AdvancementCriteria E ON A.CountryCode = E.CountryCode and E.IndependentContractorLevelId = C.IndependentContractorLevelId 
			and E.Province =  CASE WHEN RTRIM(ISNULL(D.Province,'')) = '' THEN 'Non-Province' ELSE D.Province END and E.IsDeleted = 0
			and E.StartDate <= We2 and E.EndDate >= We2
		LEFT JOIN Mst_IndependentContractorLevel F ON E.TeamSizeLevel = F.IndependentContractorLevelId
		WHERE B.IsDeleted = 0
		 
	 --return 
		INSERT INTO TXN_AutoAdvancementResult(ScheduleWeekending,CountryCode,Weekending1,BadgeNo, DirectReportBadgeNo, BALink ,BAStatus
			   ,IndependentContractorID,IndependentContractorLevelId,BALevel,WEBALevel, PromotionDate1, BAPersonalSalesValue, BASalesPcs, BAPersonalPoint,BASubPcs,  BAProvince,CriteriaProvince
			   ,CriteriaSalesValue, CriteriaSalesPcs, CriteriaTeamSize,CriteriaBuletinPoint, CriteriaTeamSizeLevel,CriteriaSubPcs,
			   CriterialFirstGenLeader,Remark,ScheduleBALevel, BAStatus2, CreatedDate, IsDeleted) 
		SELECT DISTINCT @WeDate, CountryCode,  We1,  BadgeNo, DirectReportBadgeNo, BadgeNoLink,  Status, 
		IndependentContractorID, IndependentContractorLevelId, CurrentLevel, WELevel, LevelPromotionDate, personalSales,personalPcs, PersonalPoint, SubPcs, CurrentProvince, CriterialProvince,
		SalesValue, SalesPcs,  TeamSize, SalesPoint, TeamSizeLevel, TeamSizeSale, FirstGenLeader, Remark, CurrentIdLevel,'In-Active', GETDATE(), 0
		FROM #We1Result 
		UNION 
		SELECT DISTINCT @WeDate, A.CountryCode,  @WeDate,  A.BadgeNo, '', '',  'In-Active', 
		A.IndependentContractorID, A.IndependentContractorLevelId, A.CurrentLevel,'', NULL, 0.00,0, 0.00, 0,'', '',
		0.00, 0, 0, 0.00 ,'','' , '', '', A.CurrentIdLevel, 'Active', GETDATE(), 0
		FROM #We2Result A LEFT JOIN #We1Result B ON A.BadgeNo = B.BadgeNo and A.CountryCode = B.CountryCode
		WHERE B.BadgeNo is null

	
		PRINT '1'
		UPDATE A SET A.Weekending2 = B.We2, A.DirectReportBadgeNo2 =B.DirectReportBadgeNo, A.BALink2 = B.BadgeNoLink, A.BAStatus2 = B.Status, A.BAProvince2 = B.CurrentProvince, 
		A.BAPersonalSalesValue2 = B.personalSales, A.BASubPcs2 = B.SubPcs, A.BAPersonalPoint2 = B.PersonalPoint, A.BASalesPcs2 = B.personalPcs, A.CriteriaProvince2 = B.CriterialProvince,
		A.CriteriaTeamSizeLevel2 = B.TeamSizeLevel, A.CriteriaSalesValue2 = B.SalesValue, A.CriteriaSalesPcs2 = B.SalesPcs,  A.CriteriaTeamSize2 = B.TeamSize, A.CriteriaBuletinPoint2 = B.SalesPoint, A.CriterialFirstGenLeader2 = B.FirstGenLeader,
		A.WEBALevel2 = ISNULL(B.WELevel, A.BALevel), A.PromotionDate2 = B.LevelPromotionDate, A.BALevel2 = B.CurrentLevel
		FROM TXN_AutoAdvancementResult A 
		LEFT JOIN #We2Result B ON A.BadgeNo = B.BadgeNo and A.CountryCode = B.CountryCode
		WHERE A.ScheduleWeekending = @WeDate and A.IsDeleted = 0

	
		UPDATE TXN_AutoAdvancementResult SET WEBALevel = BALevel where
		ScheduleWeekending = @WeDate and IsDeleted = 0 and ISNULL(webalevel,'') = ''
	 
		UPDATE TXN_AutoAdvancementResult SET WEBALevel2 = BALevel2 where
		ScheduleWeekending = @WeDate and IsDeleted = 0 and ISNULL(webalevel2,'') = ''

		--=========================Begin Loop Calculate sales Value===============================

		--========================================================================================
	
		SELECT A.*, C.LevelOrdinal as 'LevelRequirementOrdinal', B.LevelOrdinal as 'BALevelOrdinal', 
		CASE WHEN CriteriaSubPcs = 'With Submission' THEN 1 WHEN CriteriaSubPcs = 'Without Submission' THEN 0 ELSE 0 END as 'SubPcsMinimum' 
		, D.StartDate INTO #TempResult FROM TXN_AutoAdvancementResult  A
		LEFT JOIN MST_IndependentContractorLevel B ON A.WEBALevel = B.LevelCode  
		LEFT JOIN MST_IndependentContractorLevel C ON A.CriteriaTeamSizeLevel = C.level 
		LEFT JOIN Mst_IndependentContractor D ON A.IndependentContractorID = D.IndependentContractorId
		WHERE ScheduleWeekending = @WeDate and A.IsDeleted = 0 
	  
		DROP TABLE IF EXISTS #BALIST
		SELECT DISTINCT BadgeNo, CountryCode, LevelRequirementOrdinal, SubPcsMinimum INTO #BALIST FROM #TempResult 
		WHERE ScheduleWeekending = @WeDate 
	 
	 --DELETE FROM #BALIST where CountryCode not in ('KR')
		DECLARE @LoopCount  as INT = 0
		DECLARE @BadgeNo as NVARCHAR(20)
		DECLARE @LevelRequirement as INT = 0
		DECLARE @SubPcsMinimum as INT = 0
		DECLARE @CountryCode as NVARCHAR(20)
		DECLARE @LOOP as int
		DECLARE @MaxLoopCount As INT = 0
		SET @MaxLoopCount = (SELECT COUNT(*) FROM #BALIST)
		SET @LOOP = 1
		SELECT TOP 1 @BadgeNo = BadgeNo, @CountryCode = CountryCode,@SubPcsMinimum =SubPcsMinimum, @LevelRequirement = LevelRequirementOrdinal FROM #BALIST  
		IF @BadgeNo IS NULL  SET @LOOP = 0 
	 
		WHILE @LOOP = 1
		BEGIN 

		--IF @BadgeNo = 'NG00319'
		--BEGIN

		--SELECT @SubPcsMinimum, @LevelRequirement
		--SELECT BASubPcs, * FROM #TempResult WHERE CountryCode = @CountryCode
		--	and ISNULL(BALink,'') like '%' + RTRIM(@BadgeNo) + '%' and 
		--	BALevelOrdinal >= @LevelRequirement and BASubPcs >= @SubPcsMinimum and BadgeNo <> @BadgeNo and ScheduleWeekending = @WeDate
		--RETURN

		--END
	 
		UPDATE #TempResult SET BAFirstGenLeader = 
			(SELECT COUNT(*) FROM #TempResult A
				LEFT JOIN Mst_IndependentContractor_BAInfo_Weekending B
			ON A.IndependentContractorID=B.IndependentContractorId AND B.WeekendingDate=@WeDate
			LEFT JOIN Mst_MasterCode C ON B.BAType=C.CodeId AND C.CodeType='BATYPE'
			WHERE CountryCode = @CountryCode
			AND C.CodeName IN ('Standard','Flexer')
			and DirectReportBadgeNo = @BadgeNo and ScheduleWeekending = @WeDate and WEBALevel NOT in ('IC'))
		WHERE ScheduleWeekending = @WeDate and  CountryCode = @CountryCode and BadgeNo = @BadgeNo

		UPDATE #TempResult SET BATeamSize = 
			(SELECT COUNT(*) FROM #TempResult A
			LEFT JOIN Mst_IndependentContractor_BAInfo_Weekending B
			ON A.IndependentContractorID=B.IndependentContractorId AND B.WeekendingDate=@WeDate
			LEFT JOIN Mst_MasterCode C ON B.BAType=C.CodeId AND C.CodeType='BATYPE'
				WHERE CountryCode = @CountryCode
			AND C.CodeName IN ('Standard','Flexer')
			and ISNULL(BALink,'') like '%' + RTRIM(@BadgeNo) + '%' and   StartDate <= DATEADD(day,-7,@WeDate) and
			BALevelOrdinal >= @LevelRequirement and BASubPcs >= @SubPcsMinimum and BadgeNo <> @BadgeNo and ScheduleWeekending = @WeDate)
		WHERE ScheduleWeekending = @WeDate and  CountryCode = @CountryCode and BadgeNo = @BadgeNo
 
 

		UPDATE #TempResult SET BAFirstGenLeader2 = 
			(SELECT COUNT(*) FROM #TempResult A
				LEFT JOIN Mst_IndependentContractor_BAInfo_Weekending B
			ON A.IndependentContractorID=B.IndependentContractorId AND B.WeekendingDate=@WeDate
			LEFT JOIN Mst_MasterCode C ON B.BAType=C.CodeId AND C.CodeType='BATYPE'
			WHERE CountryCode = @CountryCode
			AND C.CodeName IN ('Standard','Flexer')
			and DirectReportBadgeNo2 = @BadgeNo and ScheduleWeekending = @WeDate and WEBALevel2 NOT in ('IC'))
		WHERE ScheduleWeekending = @WeDate and CountryCode = @CountryCode and BadgeNo = @BadgeNo

		UPDATE #TempResult SET BATeamSize2 = 
			(SELECT COUNT(*) FROM #TempResult A
				LEFT JOIN Mst_IndependentContractor_BAInfo_Weekending B
			ON A.IndependentContractorID=B.IndependentContractorId AND B.WeekendingDate=@WeDate
			LEFT JOIN Mst_MasterCode C ON B.BAType=C.CodeId AND C.CodeType='BATYPE'
			WHERE CountryCode = @CountryCode
			AND C.CodeName IN ('Standard','Flexer')
			and ISNULL(BALink2,'') like '%' + RTRIM(@BadgeNo) + '%'  and   StartDate <= DATEADD(day,-14,@WeDate) and 
			BALevelOrdinal >= @LevelRequirement and BASubPcs2 >= @SubPcsMinimum and BadgeNo <> @BadgeNo and ScheduleWeekending = @WeDate)
		WHERE ScheduleWeekending = @WeDate and  CountryCode = @CountryCode and BadgeNo = @BadgeNo
	
		IF @CountryCode <> 'KR'
		BEGIN
				UPDATE A SET A.BABulettinPoint = B.BAPersonalPoint, A.BASalesValue = B.BAPersonalSalesValue FROM #TempResult A INNER JOIN (
				SELECT @BadgeNo as 'BadgeNo', SUM(ISNULL(BAPersonalSalesValue,0.00)) as 'BAPersonalSalesValue',SUM(ISNULL(BAPersonalPoint,0.00)) as 'BAPersonalPoint'
				FROM #TempResult  WHERE BadgeNo in (
					SELECT distinct BadgeNo FROM #TempResult where ScheduleWeekending = @WeDate and CountryCode = @CountryCode and
						BALink like '%' + @BadgeNo + '%' 
				) and BadgeNo <> @BadgeNo and CountryCode = @CountryCode
				) B ON A.BadgeNo = B.BadgeNo  
				WHERE A.BadgeNo = @BadgeNo and A.CountryCode = @CountryCode

				UPDATE A SET A.BABulettinPoint2 = B.BAPersonalPoint, A.BASalesValue2 = B.BAPersonalSalesValue FROM #TempResult A INNER JOIN (
				SELECT @BadgeNo as 'BadgeNo', SUM(ISNULL(BAPersonalSalesValue2,0.00)) as 'BAPersonalSalesValue',SUM(ISNULL(BAPersonalPoint2,0.00)) as 'BAPersonalPoint'
				FROM #TempResult  WHERE BadgeNo in (
					SELECT distinct BadgeNo FROM #TempResult where ScheduleWeekending = @WeDate and CountryCode = @CountryCode and
						BALink2 like '%' + @BadgeNo + '%' 
				) and BadgeNo <> @BadgeNo and CountryCode = @CountryCode
				) B ON A.BadgeNo = B.BadgeNo  
				WHERE A.BadgeNo = @BadgeNo and A.CountryCode = @CountryCode
		END


	
		IF @CountryCode = 'KR'
		BEGIN
				UPDATE A SET A.BABulettinPoint = B.BAPersonalPoint, A.BASalesValue = B.BAPersonalSalesValue FROM #TempResult A INNER JOIN (
				SELECT @BadgeNo as 'BadgeNo', SUM( ISNULL(BAPersonalSalesValue,0.00) ) as 'BAPersonalSalesValue',SUM(ISNULL(BAPersonalPoint,0.00)) as 'BAPersonalPoint'
				FROM #TempResult  WHERE BadgeNo in (
					SELECT distinct BadgeNo FROM #TempResult where ScheduleWeekending = @WeDate and CountryCode = @CountryCode and
						BALink like '%' + @BadgeNo + '%' --and BALevel NOT IN ( 'IC')
				) and BadgeNo <> @BadgeNo and CountryCode = @CountryCode
				) B ON A.BadgeNo = B.BadgeNo  
				WHERE A.BadgeNo = @BadgeNo and A.CountryCode = @CountryCode

				UPDATE A SET A.BABulettinPoint2 = B.BAPersonalPoint, A.BASalesValue2 = B.BAPersonalSalesValue FROM #TempResult A INNER JOIN (
				SELECT @BadgeNo as 'BadgeNo', SUM(  ISNULL(BAPersonalSalesValue2,0.00) ) as 'BAPersonalSalesValue',SUM(ISNULL(BAPersonalPoint2,0.00)) as 'BAPersonalPoint'
				FROM #TempResult  WHERE BadgeNo in (
					SELECT distinct BadgeNo FROM #TempResult where ScheduleWeekending = @WeDate and CountryCode = @CountryCode and
						BALink2 like '%' + @BadgeNo + '%' --  and BALevel NOT IN ( 'IC')
				) and BadgeNo <> @BadgeNo and CountryCode = @CountryCode
				) B ON A.BadgeNo = B.BadgeNo  
				WHERE A.BadgeNo = @BadgeNo and A.CountryCode = @CountryCode


		UPDATE #TempResult SET BAFirstGenLeader = 
			(SELECT COUNT(*) FROM #TempResult A
				LEFT JOIN Mst_IndependentContractor_BAInfo_Weekending B
			ON A.IndependentContractorID=B.IndependentContractorId AND B.WeekendingDate=@WeDate
			LEFT JOIN Mst_MasterCode C ON B.BAType=C.CodeId AND C.CodeType='BATYPE'
			WHERE CountryCode = @CountryCode
			AND C.CodeName IN ('Standard','Flexer')
			AND DirectReportBadgeNo = @BadgeNo and ScheduleWeekending = @WeDate  and BASalesPcs > 0 and WEBALevel NOT in ('IC'))
		WHERE ScheduleWeekending = @WeDate and  CountryCode = @CountryCode and BadgeNo = @BadgeNo


		
		UPDATE #TempResult SET BAFirstGenLeader2 = 
			(SELECT COUNT(*) FROM #TempResult WHERE CountryCode = @CountryCode
			and DirectReportBadgeNo2 = @BadgeNo and ScheduleWeekending = @WeDate  and BASalesPcs2 > 0 and WEBALevel2 NOT in ('IC'))
		WHERE ScheduleWeekending = @WeDate and CountryCode = @CountryCode and BadgeNo = @BadgeNo


		END
	 

			DELETE FROM #BALIST WHERE BadgeNo = @BadgeNo and CountryCode = @CountryCode
				SELECT TOP 1 @BadgeNo = BadgeNo, @CountryCode = CountryCode,@SubPcsMinimum =SubPcsMinimum, @LevelRequirement = LevelRequirementOrdinal FROM #BALIST  
 
			IF @BadgeNo IS NULL  SET @LOOP = 0 

			SET @LoopCount = @LoopCount + 1
			IF @LoopCount = @MaxLoopCount SET @LOOP = 0
		END 
	 
		--=========================End   Loop Calculate sales Value===============================

		--========================================================================================

		PRINT 'End Loop Calculate sales Value ========================================================================================'
		UPDATE A SET A.BATeamSize = B.BATeamSize, A.BATeamSize2 = B.BATeamSize2, A.BAFirstGenLeader = B.BAFirstGenLeader, A.BAFirstGenLeader2 = B.BAFirstGenLeader2, A.BASalesValue = B.BASalesValue, A.BASalesValue2 = B.BASalesValue2, A.BABulettinPoint = B.BABulettinPoint, A.BABulettinPoint2 = B.BABulettinPoint2
		FROM TXN_AutoAdvancementResult A INNER JOIN #TempResult B ON A.ScheduleWeekending = B.ScheduleWeekending
		and a.BadgeNo = B.BadgeNo and A.CountryCode = B.CountryCode WHERE A.ScheduleWeekending = @WeDate
		 and A.IsDeleted = 0
 		PRINT 'A'

		 UPDATE TXN_AutoAdvancementResult SET Week1Result = 'NO', Week2Result = 'NO', FinalResult = 'NO'
		 WHERE ScheduleWeekending = @WeDate  and IsDeleted = 0
  		PRINT 'B'

		UPDATE TXN_AutoAdvancementResult SET Week1Result = 'YES'  WHERE 
		BASalesValue >= CriteriaSalesValue and 
		ISNULL(BASalesPcs,0) >= ISNULL(CriteriaSalesPcs,0) and
		BATeamSize >= CriteriaTeamSize and
		BABulettinPoint >= CriteriaBuletinPoint and
		BAFirstGenLeader >= CriterialFirstGenLeader  
		and ISNULL(Bastatus,'') <> '' and ISNULL(remark,'') = ''
		and ScheduleWeekending = @WeDate  and IsDeleted = 0

  			PRINT 'C'
		UPDATE TXN_AutoAdvancementResult SET Week2Result = 'YES'  WHERE 
		BASalesValue2 >= CriteriaSalesValue2 and 
		ISNULL(BASalesPcs2,0) >= ISNULL(CriteriaSalesPcs2,0) and
		BATeamSize2 >= CriteriaTeamSize2 and	
		BABulettinPoint2 >= CriteriaBuletinPoint2 and
		BAFirstGenLeader2 >= CriterialFirstGenLeader2 
		and ISNULL(Bastatus2,'') <> '' and ISNULL(remark,'') = ''
		and ScheduleWeekending = @WeDate  and  IsDeleted = 0
  		PRINT 'D'

		UPDATE A SET A.ScheduleBALevel = B.level FROM TXN_AutoAdvancementResult A 
		LEFT JOIN MST_independentcontractorLevel B ON A.ScheduleBALevel = B.IndependentContractorLevelId
		WHERE ScheduleWeekending = @WeDate and A.IsDeleted = 0

	
   		PRINT 'E'
		UPDATE TXN_AutoAdvancementResult SET  FinalResult = 'YES'
		WHERE ScheduleWeekending = @WeDate AND Week1Result = 'YES' 
		and Week2Result = 'YES' and ISNULL(remark,'') = ''
		and ScheduleBALevel not in ('Owner','Owner Partner','IC')  and IsDeleted = 0
	
		UPDATE TXN_AutoAdvancementResult SET FinalResult = 'NO', Remark = 'Previous Advancement Within 2 weeks' 
		WHERE ScheduleWeekending = @WeDate
		and IsDeleted = 0 and FinalResult = 'YES' and PromotionDate1 > ( 
		SELECT MIN(weDate) FROM (
		SELECT TOP 2 WEdate FROM Mst_Weekending where WEdate < @WeDate ORDER BY WEdate DESC
		) A
		)

		UPDATE TXN_AutoAdvancementResult SET WEBALevel = NULL WHERE BALevel is null and WEBALevel is not null and ScheduleWeekending = @WeDate and IsDeleted = 0
	UPDATE TXN_AutoAdvancementResult SET WEBALevel2 = NULL  WHERE BALevel2 is null and WEBALevel2 is not null and ScheduleWeekending = @WeDate  and IsDeleted = 0




   		PRINT 'F'
	END

  
 