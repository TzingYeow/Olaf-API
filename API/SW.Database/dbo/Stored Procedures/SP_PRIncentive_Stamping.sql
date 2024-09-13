 -- SP_PRIncentive_Stamping '2023-12-31'
CREATE PROCEDURE [dbo].[SP_PRIncentive_Stamping] 
	@WeDate  date 
AS
BEGIN 
DECLARE @FromDate as date
DECLARE @ToDate as date
DECLARE @Country as NVARCHAR(100)
SET @Country = 'MY,SG,TW' 
SET @WeDate = @WEDate
SELECT @FromDate = FromDate, @ToDate = ToDate FROM Mst_Weekending where WEdate = @WeDate

DROP TABLE IF EXISTS #TempPoint
SELECT * INTO #TempPoint FROM MST_countryPoint
WHERE '2023-01-22' > = StartWe AND '2023-01-22' <= EndWe  and IsActive = 1


 -- =================================================================================================================
 -- STEP 1 : STAMP New Recruit
 -- =================================================================================================================

	-- INSERT INTO dbo.MST_PR_Master (IndependentContractorID ,StartDate
	--,StartDateWE,RecruiterIndependentContractorID,RecruiterIndependentContractorLevelID
	--,CreatedDate,IsDeleted)
	--SELECT A.IndependentContractorId,A.StartDate, @WeDate as 'StartWeDate', B.IndependentContractorId, B.IndependentContractorLevelId,
	--GETDATE(),0
	--FROM VW_ICDetail A LEFT JOIN VW_ICDetail B ON B.BadgeNo = A.RecruiterBadgeNoOrName and A.CountryCode = B.countryCode 
	--WHERE A.StartDate >= @FromDate and A.StartDate <=@ToDate and A.RecruitmentType = 'Personal Recruitment'
	----and (
	----	(A.CountryCode ='TW' and A.StartDate <= '2024-03-03') OR 
	----	(A.CountryCode ='MY' and A.StartDate <= '2023-12-31') OR
	----	(A.CountryCode ='SG' and A.StartDate <= '2023-12-31')
	----	)

	 

 -- =================================================================================================================
 -- STEP 2 : DETERMINE OP MC
 -- =================================================================================================================

		DROP TABLE IF EXISTS #BALevel
		SELECT A.IndependentContractorID, A.IndependentContractorLevelId INTO #BALevel  FROM Mst_IndependentContractor_Movement A 
		INNER JOIN (
			SELECT IndependentContractorID,  MAX(EffectiveDate) EffectiveDate FROM Mst_IndependentContractor_Movement
			where Description in ('Advance','De-advance','Re-activate','De-advance','Re-activate','Reactivate','New-IC','Re-train','Demote') 
			and IndependentContractorLevelId is not   null and isdeleted = 0 and EffectiveDate < @FromDate
			GROUP BY IndependentContractorID
		) B ON A.IndependentContractorID = B.IndependentContractorID and A.EffectiveDate = B.EffectiveDate
		where A.Description in ('Advance','De-advance','Re-activate','De-advance','Re-activate','Reactivate','New-IC','Re-train','Demote')   and isdeleted = 0
		and A.IndependentContractorLevelId is not   null and A.EffectiveDate < @FromDate
		GROUP BY A.IndependentContractorID, A.IndependentContractorLevelId  

		DROP TABLE IF EXISTS #OPMC
		SELECT CountryCode, Code as 'MOCode' INTO #OPMC FROM (
		SELECT distinct B.CountryCode, B.Code, 
		SUM(CASE WHEN B.IndependentContractorLevelId = 2 THEN 1 ELSE 0 END) as 'LevelOP',
		SUM(CASE WHEN B.IndependentContractorLevelId = 5 THEN 1 ELSE 0 END) as 'LevelO' 
		FROM #BALevel A LEFT JOIN VW_ICDetail B ON A.IndependentContractorId = B.IndependentContractorId
		GROUP BY B.CountryCode, B.Code
		) A WHERE  LevelO = 0 and LevelOP > 0

		 
 -- =================================================================================================================
 -- MALAYSIA
 -- =================================================================================================================

DROP TABLE IF EXISTS #WTBExclude 
 SELECT * INTO #WTBExclude FROM (
 SELECT  'MY' as 'Country',A.MO_Code as 'MOCode', A.IC_Code as 'BadgeNo', SUM(Pieces) as 'Pcs',  SUM(ICStroke) as ActualPay 
FROM NewMYDB_PROD..TXN_LS_ICE A  WHERE  SubmissionWE = @WeDate and A.Client ='WTB' 
GROUP BY A.Client, MO_Code, A.IC_Code 
) A WHERE ISNULL(pcs,0) + ISNULL(actualpay,0) > 0


 DROP TABLE IF EXISTS #MasterList
SELECT  C.CountryCode, A.IndependentContractorID, C.BadgeNo, A.RecruiterIndependentContractorID, D.BadgeNo as 'RecruiterBadgeNo', A.StartDateWE, B.*,
CASE WHEN RTRIM(ISNULL(E.MOCode,'')) = '' THEN 'Normal' ELSE 'PromotingOwner' END as 'PayoutType'
INTO #MasterList FROM MST_PR_Master A 
LEFT JOIN TXN_PR_Detail B ON A.PRID = B.PRID 
LEFT JOIN VW_ICDetail C ON A.IndependentContractorID = C.IndependentContractorId 
LEFT JOIN VW_ICDetail D ON A.RecruiterIndependentContractorID = D.IndependentContractorId
 LEFT JOIN #OPMC E ON C.Code = E.MOCode and C.CountryCode = E.CountryCode
  

--DELETE FROM #MasterList WHERE @WEDate >='2023-12-31' and CountryCode = 'MY'
--DELETE FROM #MasterList WHERE @WEDate >='2024-03-03' and CountryCode = 'TW'
--DELETE FROM #MasterList WHERE @WEDate >='2023-12-31' and CountryCode = 'SG'

INSERT INTO TXN_PR_Detail
SELECT distinct A.PRID,  B.IndependentContractorLevelId, C.IndependentContractorLevelId, C.BASubPcs, 
1 as 'MilestoneType', CAST((B.BAPersonalSalesValue - ISNULL(J.ActualPay,0.00)) / F.PointConversion as decimal(18,4))  as 'MilestonePoint', CAST((B.BAPersonalSalesValue - ISNULL(J.ActualPay,0.00))  as decimal(18,2)) as 'MileStonesValue',
 CAST((B.BAPersonalSalesValue - ISNULL(J.ActualPay,0.00)) / F.PointConversion as decimal(18,4))  as 'MilestoneData', E.PayoutID, @WeDate,  CASE WHEN ISNULL(C.BASubPcs,0) - ISNULL(K.Pcs,0) > 0 THEN  1 ELSE 0 END as 'MilestonePayable',
NULL, GETDATE(), NULL, 0 FROM MST_PR_Master A  
LEFT JOIN TXN_AutoAdvancementResult B ON A.IndependentContractorID = B.IndependentContractorID and B.IsDeleted = 0 and B.ScheduleWeekending = @WeDate
LEFT JOIN TXN_AutoAdvancementResult C ON A.RecruiterIndependentContractorID = C.IndependentContractorID and C.IsDeleted = 0  and C.ScheduleWeekending = @WeDate
LEFT JOIN VW_ICDetail D ON A.IndependentContractorID = D.IndependentContractorId
LEFT JOIN VW_ICDetail G ON A.RecruiterIndependentContractorID = G.IndependentContractorId 
LEFT JOIN #OPMC I ON D.CountryCode = I.CountryCode and D.Code = I.MOCode
LEFT JOIN MST_PR_Payout E ON D.CountryCode = E.Country and E.MilestoneType = 1 and E.PayoutType = CASE WHEN RTRIM(ISNULL(I.MOCode,'')) = '' THEN 'Normal' ELSE 'PromotingOwner' END
LEFT JOIN #TempPoint F ON B.CountryCode = F.Country
LEFT JOIN #WTBExclude J ON B.BadgeNo = J.BadgeNo
LEFT JOIN #WTBExclude K ON C.BadgeNo = K.BadgeNo
WHERE A.IsDeleted = 0 and A.Milestone1 is null and ISNULL(B.BASubPcs,0) - ISNULL(J.Pcs,0) > 0
and A.IndependentContractorID not in (

 SELECT independentContractorID FROM #MasterList
 WHERE CountryCode in('MY','TW') and ISNULL(MilestonesType,'') = 1

)
 
INSERT INTO TXN_PR_Detail
SELECT  A.PRID,  B.IndependentContractorLevelId, C.IndependentContractorLevelId, C.BASubPcs, 
2 as 'MilestoneType', CAST((B.BAPersonalSalesValue - ISNULL(J.ActualPay,0.00)) / F.PointConversion as decimal(18,4))  as 'MilestonePoint', CAST((B.BAPersonalSalesValue - ISNULL(J.ActualPay,0.00))  as decimal(18,2)) as 'MileStonesValue',
 CAST((B.BAPersonalSalesValue - ISNULL(J.ActualPay,0.00)) / F.PointConversion as decimal(18,4))  as 'MilestoneData', E.PayoutID, @WeDate,  CASE WHEN ISNULL(C.BASubPcs,0)- ISNULL(K.Pcs,0) > 0 THEN  1 ELSE 0 END as 'MilestonePayable',
NULL, GETDATE(), NULL, 0 FROM MST_PR_Master A  
LEFT JOIN TXN_AutoAdvancementResult B ON A.IndependentContractorID = B.IndependentContractorID and B.IsDeleted = 0 and B.ScheduleWeekending = @WeDate
LEFT JOIN TXN_AutoAdvancementResult C ON A.RecruiterIndependentContractorID = C.IndependentContractorID and C.IsDeleted = 0  and C.ScheduleWeekending = @WeDate
LEFT JOIN VW_ICDetail D ON A.IndependentContractorID = D.IndependentContractorId
LEFT JOIN VW_ICDetail G ON A.RecruiterIndependentContractorID = G.IndependentContractorId
LEFT JOIN #OPMC I ON D.CountryCode = I.CountryCode and D.Code = I.MOCode
LEFT JOIN MST_PR_Payout E ON D.CountryCode = E.Country and E.MilestoneType = 2 and E.PayoutType = CASE WHEN RTRIM(ISNULL(I.MOCode,'')) = '' THEN 'Normal' ELSE 'PromotingOwner' END
LEFT JOIN #TempPoint F ON D.CountryCode = F.Country
LEFT JOIN #WTBExclude J ON B.BadgeNo = J.BadgeNo
LEFT JOIN #WTBExclude K ON C.BadgeNo = K.BadgeNo
WHERE A.IsDeleted = 0 and A.Milestone2 is null and CAST(((B.BAPersonalSalesValue - ISNULL(J.ActualPay,0)) / F.PointConversion) as decimal(18,2)) >=  CASE WHEN D.CountryCode = 'MY' THEN 6 WHEN D.CountryCode = 'TW' THEN 6.66667 END
and A.IndependentContractorID not in (

 SELECT independentContractorID FROM #MasterList
 WHERE CountryCode in('MY','TW') and ISNULL(MilestonesType,'') = 2

)
 

INSERT INTO TXN_PR_Detail
SELECT A.PRID,  B.IndependentContractorLevelId, C.IndependentContractorLevelId, C.BASubPcs, 
3 as 'MilestoneType', CAST((B.BAPersonalSalesValue - ISNULL(J.ActualPay,0.00)) / F.PointConversion as decimal(18,4))  as 'MilestonePoint', CAST((B.BAPersonalSalesValue - ISNULL(J.ActualPay,0.00))  as decimal(18,2)) as 'MileStonesValue',
 CAST((B.BAPersonalSalesValue - ISNULL(J.ActualPay,0.00)) / F.PointConversion as decimal(18,4))  as 'MilestoneData', E.PayoutID, @WeDate,  CASE WHEN ISNULL(C.BASubPcs,0)- ISNULL(K.Pcs,0) > 0 THEN  1 ELSE 0 END as 'MilestonePayable',
NULL, GETDATE(), NULL, 0 FROM MST_PR_Master A  
LEFT JOIN TXN_AutoAdvancementResult B ON A.IndependentContractorID = B.IndependentContractorID and B.IsDeleted = 0 and B.ScheduleWeekending = @WeDate
LEFT JOIN TXN_AutoAdvancementResult C ON A.RecruiterIndependentContractorID = C.IndependentContractorID and C.IsDeleted = 0  and C.ScheduleWeekending = @WeDate
LEFT JOIN VW_ICDetail D ON A.IndependentContractorID = D.IndependentContractorId
LEFT JOIN VW_ICDetail G ON A.RecruiterIndependentContractorID = G.IndependentContractorId
LEFT JOIN #OPMC I ON D.CountryCode = I.CountryCode and D.Code = I.MOCode
LEFT JOIN MST_PR_Payout E ON D.CountryCode = E.Country and E.MilestoneType = 3 and E.PayoutType = CASE WHEN RTRIM(ISNULL(I.MOCode,'')) = '' THEN 'Normal' ELSE 'PromotingOwner' END
LEFT JOIN #TempPoint F ON D.CountryCode = F.Country 
LEFT JOIN #WTBExclude J ON B.BadgeNo = J.BadgeNo
LEFT JOIN #WTBExclude K ON C.BadgeNo = K.BadgeNo
WHERE A.IsDeleted = 0  and CAST(((B.BAPersonalSalesValue- ISNULL(J.ActualPay,0)) / F.PointConversion) as decimal(18,2)) >= CASE WHEN D.CountryCode = 'MY' THEN 6 WHEN D.CountryCode = 'TW' THEN 6.66667 END
 and B.IndependentContractorID not in (
 SELECT IndependentContractorId FROM #MasterList where CountryCode in('MY','TW') and MilestonesType = 3
 )
 and B.IndependentContractorID in (
  	 SELECT IndependentContractorId FROM VW_PR_Master where MilestoneHitWE = CAST(DATEADD(DAY,-7,@wedate)as date) and MileStonesPoint >=6 and IsDeleted = 0
 )
  

INSERT INTO TXN_PR_Detail
SELECT  A.PRID,  B.IndependentContractorLevelId, C.IndependentContractorLevelId, C.BASubPcs, 
4 as 'MilestoneType',   CAST(B.BAPersonalSalesValue / F.PointConversion as decimal(18,4))  as 'MilestonePoint', CAST((B.BAPersonalSalesValue - ISNULL(J.ActualPay,0.00)) as decimal(18,2)) as 'MileStonesValue',
 CAST((B.BAPersonalSalesValue - ISNULL(J.ActualPay,0.00)) / F.PointConversion as decimal(18,4))  as 'MilestoneData', E.PayoutID, @WeDate,  CASE WHEN ISNULL(C.BASubPcs,0)- ISNULL(K.Pcs,0) > 0 THEN  1 ELSE 0 END as 'MilestonePayable',
NULL, GETDATE(), NULL, 0 FROM MST_PR_Master A  
LEFT JOIN TXN_AutoAdvancementResult B ON A.IndependentContractorID = B.IndependentContractorID and B.IsDeleted = 0 and B.ScheduleWeekending = @WeDate
LEFT JOIN TXN_AutoAdvancementResult C ON A.RecruiterIndependentContractorID = C.IndependentContractorID and C.IsDeleted = 0  and C.ScheduleWeekending = @WeDate
LEFT JOIN VW_ICDetail D ON A.IndependentContractorID = D.IndependentContractorId
LEFT JOIN VW_ICDetail G ON A.RecruiterIndependentContractorID = G.IndependentContractorId
LEFT JOIN #OPMC I ON D.CountryCode = I.CountryCode and D.Code = I.MOCode
LEFT JOIN MST_PR_Payout E ON D.CountryCode = E.Country and E.MilestoneType = 4 and E.PayoutType = CASE WHEN RTRIM(ISNULL(I.MOCode,'')) = '' THEN 'Normal' ELSE 'PromotingOwner' END
LEFT JOIN #TempPoint F ON D.CountryCode = F.Country
LEFT JOIN #WTBExclude J ON B.BadgeNo = J.BadgeNo
LEFT JOIN #WTBExclude K ON C.BadgeNo = K.BadgeNo
WHERE A.IsDeleted = 0 and A.Milestone2 is null and CAST(((B.BAPersonalSalesValue- ISNULL(J.ActualPay,0)) / F.PointConversion) as decimal(18,2)) >= CASE WHEN D.CountryCode = 'MY' THEN 16 WHEN D.CountryCode = 'TW' THEN 13.3333334 END
 
order by A.IndependentContractorID
 

  
 -- =================================================================================================================
 -- SINGAPORE
 -- =================================================================================================================

 
 
 DROP TABLE IF EXISTS #TempSG
 SELECT B.BadgeNo, C.BadgeNo as 'RecruiterBadgeNo', A.IndependentContractorID, A.RecruiterIndependentContractorID, CAST(null as int) as 'RecruiterSubPcs', CAST('' as nvarchar(100)) as 'MileStone1'
 , CAST( '' as nvarchar(100)) as 'MileStone2', CAST('' as nvarchar(100)) as 'MileStone3', CAST('' as nvarchar(100)) as 'MileStone4'
 , CAST('' as nvarchar(100)) as 'MileStone5', CAST('' as nvarchar(100)) as 'MileStone6', CAST(0.00 as decimal(18,2)) as 'MilestoneValue', CAST(0.00 as decimal(18,2)) as 'MilestoneData'  INTO #TempSG 
 FROM MST_PR_Master A INNER JOIN VW_ICDetail B ON A.IndependentContractorID = B.IndependentContractorId 
 LEFT JOIN VW_ICDetail C ON A.RecruiterIndependentContractorID = C.IndependentContractorId 
 WHERE A.IsDeleted = 0 and B.CountryCode = 'SG'-- and StartDateWE = @WEDate
 
 UPDATE A SET A.MileStone1 = 'YES' FROM #TempSG A LEFT JOIN #MasterList B ON A.IndependentContractorID = B.IndependentContractorID
 WHERE B.MilestonesType = 1 and B.IsDeleted = 0

 UPDATE A SET A.MileStone2 = 'YES' FROM #TempSG A LEFT JOIN #MasterList B ON A.IndependentContractorID = B.IndependentContractorID
 WHERE B.MilestonesType = 2 and B.IsDeleted = 0

 UPDATE A SET A.MileStone3 = 'YES' FROM #TempSG A LEFT JOIN #MasterList B ON A.IndependentContractorID = B.IndependentContractorID
 WHERE B.MilestonesType = 3 and B.IsDeleted = 0

 UPDATE A SET A.MileStone4 = 'YES' FROM #TempSG A LEFT JOIN #MasterList B ON A.IndependentContractorID = B.IndependentContractorID
 WHERE B.MilestonesType = 4 and B.IsDeleted = 0

 UPDATE A SET A.MileStone5 = 'YES' FROM #TempSG A LEFT JOIN #MasterList B ON A.IndependentContractorID = B.IndependentContractorID
 WHERE B.MilestonesType = 5 and B.IsDeleted = 0

 UPDATE A SET A.MileStone6 = 'YES' FROM #TempSG A LEFT JOIN #MasterList B ON A.IndependentContractorID = B.IndependentContractorID
 WHERE B.MilestonesType = 6 and B.IsDeleted = 0 
 
 SELECT * FROM #TempSG WHERE LEN(ISNULL(MileStone1,'')) > 3


 -- MILESTONE 1=================================================================================================================
  UPDATE A SET A.MileStone1 = CAST(B.signupdate as date) FROM #TempSG A INNER JOIN (
 SELECT B.IndependentContractorID, MIN(C.signupdate) 'signupdate' FROM NewSGDB_PROD..VW_CH_SS A INNER JOIN #TempSG B ON A.BadgeNo = B.BadgeNo
 LEFT JOIN NewSGDB_PROD..VW_CHR_TXN C ON A.TxnId =C.TXNID  
 WHERE StatusWEDate = @WEDate and   A.status = 'SubmissionDate' and B.MileStone1 =''
 GROUP BY B.IndependentContractorID 
 ) B ON A.IndependentContractorID = B.IndependentContractorID

 UPDATE A SET A.RecruiterSubPcs = B.RecruiterSubPcs FROM #TempSG A INNER JOIN (
 SELECT B.IndependentContractorID, COUNT(*) as 'RecruiterSubPcs' FROM NewSGDB_PROD..VW_CH_SS A INNER JOIN #TempSG B ON A.BadgeNo = B.RecruiterBadgeNo
 LEFT JOIN NewSGDB_PROD..VW_CHR_TXN C ON A.TxnId =C.TXNID 
 WHERE StatusWEDate = @WEDate and   A.status = 'SubmissionDate' and LEN(ISNULL(B.MileStone1,'')) > 3
 GROUP BY B.IndependentContractorID
 ) B ON A.IndependentContractorID = B.IndependentContractorID

  
UPDATE A SET A.MileStone1 = CAST(@WEDate as DATE) FROM #TempSG A LEFT JOIN (
SELECT A.*  FROM TXN_PR_Singapore A  
) B ON A.BadgeNo = B.BadgeNo
WHERE ISNULL(B.BASubPcs,0) > 0 and A.MileStone1 = '' 

 -- MILESTONE 1=================================================================================================================




 -- MILESTONE 2 =================================================================================================================


 SELECT * FROM #TempSG WHERE ISNULL(MileStone2,'') not in ('YES','')


 UPDATE A SET A.milestone2 = CAST((ISNULL(B.BANetEarning,0.00) + ISNULL(B.BANetBonus2,0.00)+ ISNULL(B.BANetBonus2,0.00) + ISNULL(C.NetEarning,0.00) + ISNULL(C.AppcoBonusNET,0.00)) / PointConversion as decimal(18,2)) 
 FROM #TempSG A 
 LEFT JOIN TXN_PR_Singapore B ON A.BadgeNo = B.BadgeNo  and B.ScheduleWeekending = @WEDate
 LEFT JOIN NewSGDB_PROD..TXN_CH_ICE C ON A.BadgeNo = C.BadgeNo and C.WeekendingDate = @WEDate
 LEFT JOIN #TempPoint D ON D.Country = 'SG'
 WHERE CAST((ISNULL(B.BANetEarning,0.00) + ISNULL(C.NetEarning,0.00) + ISNULL(C.AppcoBonusNET,0.00)) / PointConversion as decimal(18,2)) >= 6
 and A.MileStone2 = ''  
  
  -- MILESTONE 3 =================================================================================================================
   
 SELECT * FROM #TempSG WHERE ISNULL(MileStone3,'') not in ('YES','')

  --SELECT E.MileStonesPoint, CAST((ISNULL(B.BANetEarning,0.00) + ISNULL(B.BANetBonus2,0.00)+ ISNULL(B.BANetBonus2,0.00) + ISNULL(C.NetEarning,0.00) + ISNULL(C.AppcoBonusNET,0.00)) / PointConversion as decimal(18,2)) ,
  --* 
  UPDATE A SET A.milestone3 = CAST((ISNULL(B.BANetEarning,0.00) + ISNULL(B.BANetBonus2,0.00)+ ISNULL(B.BANetBonus2,0.00) + ISNULL(C.NetEarning,0.00) + ISNULL(C.AppcoBonusNET,0.00)) / PointConversion as decimal(18,2)) 
   FROM #TempSG A 
 LEFT JOIN TXN_PR_Singapore B ON A.BadgeNo = B.BadgeNo and B.ScheduleWeekending = @WEDate
 LEFT JOIN NewSGDB_PROD..TXN_CH_ICE C ON A.BadgeNo = C.BadgeNo and C.WeekendingDate = @WEDate
 LEFT JOIN #TempPoint D ON D.Country = 'SG'
 LEFT JOIN (
 SELECT A.IndependentContractorID, B.* FROM MST_PR_Master A LEFT JOIN TXN_PR_Detail B ON A.PRID = B.PRID
  LEFT JOIN VW_ICDetail C ON A.IndependentContractorID = C.IndependentContractorId 
  WHERE C.CountryCode ='SG' and B.MilestoneHitWE < @Wedate and MilestonesType = 2
  ) E ON A.IndependentContractorID = E.IndependentContractorID
 WHERE CAST((ISNULL(B.BANetEarning,0.00) + ISNULL(C.NetEarning,0.00) + ISNULL(C.AppcoBonusNET,0.00)) / PointConversion as decimal(18,2)) >= 6
 and A.MileStone3 = '' and ISNULL(E.MileStonesPoint,0) > 6





   -- MILESTONE 4 =================================================================================================================

 UPDATE A SET A.milestone4 = CAST((ISNULL(B.BANetEarning,0.00)  + ISNULL(B.BANetBonus2,0.00)+ ISNULL(B.BANetBonus2,0.00) + ISNULL(C.NetEarning,0.00) + ISNULL(C.AppcoBonusNET,0.00)) / PointConversion as decimal(18,2)) FROM #TempSG A 
 LEFT JOIN TXN_PR_Singapore B ON A.BadgeNo = B.BadgeNo  and B.ScheduleWeekending = @WEDate
 LEFT JOIN NewSGDB_PROD..TXN_CH_ICE C ON A.BadgeNo = C.BadgeNo and C.WeekendingDate = @WEDate
 LEFT JOIN #TempPoint D ON D.Country = 'SG'
 WHERE CAST((ISNULL(B.BANetEarning,0.00) + ISNULL(C.NetEarning,0.00) + ISNULL(C.AppcoBonusNET,0.00)) / PointConversion as decimal(18,2)) >= 16
 
  
  
UPDATE A SET A.RecruiterSubPcs = B.BASubPcs FROM #TempSG A INNER JOIN (
SELECT B.IndependentContractorId, A.* FROM TXN_PR_Singapore A LEFT JOIN VW_ICDetail B ON A.BadgeNo = B.BadgeNo and B.CountryCode = 'SG'
where ScheduleWeekending= @WEDate 
)  B ON A.RecruiterIndependentContractorID = B.IndependentContractorId
WHERE A.RecruiterSubPcs is null 

UPDATE A SET A.RecruiterSubPcs = B.RecruiterSubPcs FROM #TempSG A INNER JOIN (
 SELECT B.IndependentContractorId , COUNT(*) as 'RecruiterSubPcs' FROM NewSGDB_PROD..VW_CH_SS A   
 LEFT JOIN VW_ICDetail B ON A.BadgeNo = B.BadgeNo and B.CountryCode = 'SG'
 WHERE StatusWEDate = @WEDate and   A.status = 'SubmissionDate'
 GROUP BY B.IndependentContractorId 
)  B ON A.RecruiterIndependentContractorID = B.IndependentContractorId
WHERE A.RecruiterSubPcs is null 

DROP TABLE IF EXISTS #Earning
SELECT A.IndependentContractorId, SUM(A.NetEarning) as 'NetEarning' INTO #Earning FROM(
SELECT B.IndependentContractorId, SUM( ISNULL(A.BANetEarning,0.00)+ ISNULL(A.BANetBonus1,0.00) + ISNULL(A.BANetBonus2,0.00)) as 'NetEarning' FROM TXN_PR_Singapore A LEFT JOIN VW_ICDetail B ON A.BadgeNo = B.BadgeNo and B.CountryCode = 'SG'
where ScheduleWeekending= @WEDate  GROUP BY B.IndependentContractorId
UNION 
SELECT B.IndependentContractorId, SUM(ISNULL(Netearning,0.00) + ISNULL(AppcoBonusNet,0.00))  as 'NetEarning' FROM NewSGDB_PROD..TXN_CH_ICE A  LEFT JOIN VW_ICDetail B ON A.BadgeNo = B.BadgeNo and B.CountryCode = 'SG'
where WeekendingDate = @WEDate    GROUP BY B.IndependentContractorId
) A GROUP BY A.IndependentContractorId


 INSERT INTO TXN_PR_Detail
 SELECT B.PRID, C.IndependentContractorLevelId,  D.IndependentContractorLevelId, ISNULL(A.RecruiterSubPcs,0) as 'RecruiterSubPcs', 
 1 as 'MileStonesType', CAST(F.NetEarning / CAST(G.PointConversion as decimal(18,2)) as decimal(18,2)),  F.NetEarning, A.MileStone1,  E.PayoutID,
 @WEDate, CASE WHEN ISNULL(A.RecruiterSubPcs,0) > 0 THEN CAST( 1 as bit) ELSE CAST(0 as BIT) END,  @WEDate,GETDATE(),null,0  FROM #TempSG A 
 LEFT JOIN MST_PR_Master B ON A.IndependentContractorID = B.IndependentContractorID
 LEFT JOIN VW_ICDetail C ON A.IndependentContractorID = C.IndependentContractorId
 LEFT JOIN VW_ICDetail D ON B.RecruiterIndependentContractorID = D.IndependentContractorId
 LEFT JOIN #OPMC I ON I.MOCode = C.Code and C.CountryCode = I.CountryCode
 LEFT JOIN MST_PR_Payout E ON E.Country = 'SG' and E.MilestoneType = 1  and E.PayoutType = CASE WHEN RTRIM(ISNULL(I.MOCode,'')) = '' THEN 'Normal' ELSE 'PromotingOwner' END
 LEFT JOIN #Earning F ON A.IndependentContractorID = F.IndependentContractorId
 LEFT JOIN #temppoint G ON C.CountryCode = G.Country
 WHERE A.MileStone1 not in ('YES','') and B.IsDeleted = 0  order by MileStone1

 INSERT INTO TXN_PR_Detail
 SELECT B.PRID, C.IndependentContractorLevelId,  D.IndependentContractorLevelId, ISNULL(A.RecruiterSubPcs,0) as 'RecruiterSubPcs', 
 2 as 'MileStonesType', CAST(F.NetEarning / CAST(G.PointConversion as decimal(18,2)) as decimal(18,2)),  F.NetEarning, CAST(F.NetEarning / CAST(G.PointConversion as decimal(18,2)) as decimal(18,2)),  E.PayoutID,
 @WEDate, CASE WHEN ISNULL(A.RecruiterSubPcs,0) > 0 THEN CAST( 1 as bit) ELSE CAST(0 as BIT) END,  @WEDate,GETDATE(),null,0  FROM #TempSG A 
 LEFT JOIN MST_PR_Master B ON A.IndependentContractorID = B.IndependentContractorID
 LEFT JOIN VW_ICDetail C ON A.IndependentContractorID = C.IndependentContractorId
 LEFT JOIN VW_ICDetail D ON B.RecruiterIndependentContractorID = D.IndependentContractorId
 LEFT JOIN #OPMC I ON I.MOCode = C.Code and C.CountryCode = I.CountryCode
 LEFT JOIN MST_PR_Payout E ON E.Country = 'SG' and E.MilestoneType = 2 and E.PayoutType = CASE WHEN RTRIM(ISNULL(I.MOCode,'')) = '' THEN 'Normal' ELSE 'PromotingOwner' END
 LEFT JOIN #Earning F ON A.IndependentContractorID = F.IndependentContractorId
 LEFT JOIN #temppoint G ON C.CountryCode = G.Country
 WHERE A.MileStone2 not in ('YES','') and B.IsDeleted = 0  


  INSERT INTO TXN_PR_Detail
  SELECT B.PRID, C.IndependentContractorLevelId,  D.IndependentContractorLevelId, ISNULL(A.RecruiterSubPcs,0) as 'RecruiterSubPcs', 
 3 as 'MileStonesType', CAST(F.NetEarning / CAST(G.PointConversion as decimal(18,2)) as decimal(18,2)),  F.NetEarning, CAST(F.NetEarning / CAST(G.PointConversion as decimal(18,2)) as decimal(18,2)),  E.PayoutID,
 @WEDate, CASE WHEN ISNULL(A.RecruiterSubPcs,0) > 0 THEN CAST( 1 as bit) ELSE CAST(0 as BIT) END,  @WEDate,GETDATE(),null,0  FROM #TempSG A 
 LEFT JOIN MST_PR_Master B ON A.IndependentContractorID = B.IndependentContractorID
 LEFT JOIN VW_ICDetail C ON A.IndependentContractorID = C.IndependentContractorId
 LEFT JOIN VW_ICDetail D ON B.RecruiterIndependentContractorID = D.IndependentContractorId
 LEFT JOIN #OPMC I ON I.MOCode = C.Code and C.CountryCode = I.CountryCode
 LEFT JOIN MST_PR_Payout E ON E.Country = 'SG' and E.MilestoneType = 3 and E.PayoutType = CASE WHEN RTRIM(ISNULL(I.MOCode,'')) = '' THEN 'Normal' ELSE 'PromotingOwner' END
 LEFT JOIN #Earning F ON A.IndependentContractorID = F.IndependentContractorId
 LEFT JOIN #temppoint G ON C.CountryCode = G.Country
 WHERE A.MileStone3 not in ('YES','') and B.IsDeleted = 0  

 INSERT INTO TXN_PR_Detail
  SELECT B.PRID, C.IndependentContractorLevelId,  D.IndependentContractorLevelId, ISNULL(A.RecruiterSubPcs,0) as 'RecruiterSubPcs', 
 4 as 'MileStonesType', CAST(F.NetEarning / CAST(G.PointConversion as decimal(18,2)) as decimal(18,2)),  F.NetEarning, CAST(F.NetEarning / CAST(G.PointConversion as decimal(18,2)) as decimal(18,2)),  E.PayoutID,
 @WEDate, CASE WHEN ISNULL(A.RecruiterSubPcs,0) > 0 THEN CAST( 1 as bit) ELSE CAST(0 as BIT) END,  @WEDate,GETDATE(),null,0  FROM #TempSG A 
 LEFT JOIN MST_PR_Master B ON A.IndependentContractorID = B.IndependentContractorID
 LEFT JOIN VW_ICDetail C ON A.IndependentContractorID = C.IndependentContractorId
 LEFT JOIN VW_ICDetail D ON B.RecruiterIndependentContractorID = D.IndependentContractorId
 LEFT JOIN #OPMC I ON I.MOCode = C.Code and C.CountryCode = I.CountryCode
 LEFT JOIN MST_PR_Payout E ON E.Country = 'SG' and E.MilestoneType = 4 and E.PayoutType = CASE WHEN RTRIM(ISNULL(I.MOCode,'')) = '' THEN 'Normal' ELSE 'PromotingOwner' END
 LEFT JOIN #Earning F ON A.IndependentContractorID = F.IndependentContractorId
 LEFT JOIN #temppoint G ON C.CountryCode = G.Country
 WHERE A.MileStone4 not in ('YES','') and B.IsDeleted = 0  
  

    UPDATE B SET B.RecruiterSubPcs = 1, MilestonePayable = 1 FROM MST_PR_Master a left JOIN TXN_PR_Detail B ON A.PRID = B.PRID 
 LEFT JOIN VW_ICDetail C ON A.RecruiterIndependentContractorID = C.IndependentContractorId
 where C.IndependentContractorLevelId in (
 2,5
 ) and MilestoneHitWE = @WeDate and RecruiterSubPcs = 0


 

		DROP TABLE IF EXISTS #BALevel
		DROP TABLE IF EXISTS #OPMC
		DROP TABLE IF EXISTS #WTBExclude

 
END


 