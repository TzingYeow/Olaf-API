 -- SP_PRIncentive_Stamping_Restart '2024-04-28',1
CREATE PROCEDURE [dbo].[SP_PRIncentive_Stamping_Restart] 
	@WeDate  date ,
	@RepopulateData BIT
AS
BEGIN 
DECLARE @CDate as DATETIME = GETDATE()
DECLARE @RestartDate as DATE =  '2024-04-01'
DECLARE @FromDate as date
DECLARE @ToDate as date
DECLARE @Country as NVARCHAR(100)
SET @Country = 'SG' 
SET @WeDate = @WEDate
SELECT @FromDate = FromDate, @ToDate = ToDate FROM Mst_Weekending where WEdate = @WeDate

DROP TABLE IF EXISTS #TempPoint
SELECT * INTO #TempPoint FROM MST_countryPoint
WHERE '2023-01-22' > = StartWe AND '2023-01-22' <= EndWe  and IsActive = 1
 --="INSERT INTO TXN_PR_Incentive_Raw_Temp SELECT '" & TEXT(A2,"yyyy-MM-dd") &"','"&B2& "',(SELECT TOP 1 IndependentContractorID FROM VW_ICDetail WHERE BadgeNo = '"&C2&"' and CountryCode = 'SG')" &",'SG','"&C2&"','"&D2&"',"&E2&","&I2&",0,GETDATE(),GETDATE(),0"
 -- =================================================================================================================
 -- STEP 1 : STAMP New Recruit
 -- =================================================================================================================

	IF @RepopulateData = 1 
	BEGIN
		INSERT INTO dbo.MST_PR_Master (IndependentContractorID ,StartDate
		,StartDateWE,RecruiterIndependentContractorID,RecruiterIndependentContractorLevelID
		,CreatedDate,IsDeleted)
		SELECT A.IndependentContractorId,A.StartDate, @WeDate as 'StartWeDate', B.IndependentContractorId, B.IndependentContractorLevelId,
		GETDATE(),0
		FROM VW_ICDetail A LEFT JOIN VW_ICDetail B ON B.BadgeNo = A.RecruiterBadgeNoOrName and A.CountryCode = B.countryCode 
		WHERE A.StartDate >= @FromDate and A.StartDate <=@ToDate and A.RecruitmentType = 'Personal Recruitment'   
		and  A.CountryCode =@Country  and A.IndependentContractorId not in (SELECT IndependentContractorID FROM MST_PR_Master)
	 END

	 

 -- =================================================================================================================
 -- STEP 2 : DETERMINE OP MC
 -- =================================================================================================================

		DROP TABLE IF EXISTS #BALevel
		SELECT A.IndependentContractorID, A.IndependentContractorLevelId INTO #BALevel  FROM Mst_IndependentContractor_Movement A 
		INNER JOIN (
			SELECT IndependentContractorID,  MAX(EffectiveDate) EffectiveDate FROM Mst_IndependentContractor_Movement
			where Description in ('New-Recruit','Advance','De-advance','Re-activate','De-advance','Re-activate','Reactivate','New-IC','Re-train','Demote') 
			and IndependentContractorLevelId is not   null and isdeleted = 0 and EffectiveDate < @FromDate
			GROUP BY IndependentContractorID
		) B ON A.IndependentContractorID = B.IndependentContractorID and A.EffectiveDate = B.EffectiveDate
		where A.Description in ('New-Recruit','Advance','De-advance','Re-activate','De-advance','Re-activate','Reactivate','New-IC','Re-train','Demote')   and isdeleted = 0
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
 -- SINGAPORE START
 -- =================================================================================================================
  

  	DROP TABLE IF EXISTS #StarHubTempResult
	SELECT A.MOCode, A.BadgeNo, A.BAName, /*B.CustType, B.ContractType,*/ B.Payout_Name, B.TCV, /*B.Payout_MSF,*/
			SUM(CASE WHEN (C.[Status] = 'PENDING') THEN 1 
					 ELSE 0 
				END) AS 'GrossQty',
			SUM(CASE WHEN (C.[Status] = 'PENDING') THEN ISNULL(CAST(B.Total_Payout_BA AS DECIMAL(18,2)), 0) 
					 ELSE 0 
				END) AS 'GrossBAFees',
			--SUM(CASE WHEN (C.[Status] = 'PENDING') THEN ISNULL(1 * (TCV * B.Payout_MSF / 100), 0) ELSE 0 END) AS 'GrossMSF',
			SUM(CASE WHEN (C.[Status] = 'REJECT' OR C.[Status] = 'SALESWORKSREJECT' OR C.[Status] = 'CANCELLATIONREJECT') THEN 1
					 ELSE 0 
				END) AS 'RejectQty',
			SUM(CASE WHEN (C.[Status] = 'REJECT' OR C.[Status] = 'SALESWORKSREJECT' OR C.[Status] = 'CANCELLATIONREJECT') THEN ISNULL(CAST(B.Total_Payout_BA AS DECIMAL(18,2)), 0)
					 ELSE 0 
				END) AS 'RejectBAFees',
			--SUM(CASE WHEN (C.[Status] = 'REJECT' OR C.[Status] = 'SALESWORKSREJECT' OR C.[Status] = 'CANCELLATIONREJECT') THEN ISNULL(1 * (TCV * B.Payout_MSF / 100), 0) ELSE 0 END) AS 'RejectMSF',
			SUM(CASE WHEN (C.[Status] = 'RESUB') THEN 1
					 ELSE 0 
				END) AS 'ResubQty',
			SUM(CASE WHEN (C.[Status] = 'RESUB') THEN ISNULL(CAST(B.Total_Payout_BA AS DECIMAL(18,2)), 0)
					 ELSE 0 
				END) AS 'ResubBAFees'--,
			--SUM(CASE WHEN (C.[Status] = 'RESUB') THEN ISNULL(1 * (TCV * B.Payout_MSF / 100), 0) ELSE 0 END) AS 'ResubMSF'
	INTO #StarHubTempResult
	FROM NewSGDB_PROD..TXN_Starhub_Transaction_StatusSummary AS A
	INNER JOIN NewSGDB_PROD..TXN_Starhub_TransStatusSummary_Product AS B ON A.SummaryID = B.SummaryID AND 
															  A.TxnID = B.TxnID
	INNER JOIN NewSGDB_PROD..TXN_Starhub_TransStatusSummary_Status AS C ON A.SummaryID = C.SummaryID AND 
															 A.TxnID = C.TxnID
	WHERE  
		  C.StatusWEDate = @WeDate AND
		  C.[Status] <> 'INVOICED'
	GROUP BY A.MOCode,A.BadgeNo, A.BAName, /*B.CustType, B.ContractType,*/ B.Payout_Name, /*C.[Status],*/ B.TCV--, B.Payout_MSF;

	DROP TABLE IF EXISTS #StarhubFinal
	SELECT @WeDate as 'WeDate', MOCode, BadgeNo, SUM(GrossQty) Subs, SUM(GrossBAFees - RejectBAFees + ResubBAFees) as Net  INTO #StarhubFinal FROM #StarHubTempResult
	GROUP BY MOCode,BadgeNo

	
	DROP TABLE IF EXISTS #Raw
	SELECT We, MOCode, BadgeNo, SUM(Subs) as 'Subs' INTO #Raw FROM (
	SELECT @WeDate as 'We', MOCode, BadgeNo, 
	SUM(CASE WHEN Status = 'SubmissionDate' then 1 else 0 end) as 'Subs'-- into #Raw
	FROM NewSGDB_PROD..VW_CH_SS WHERE StatusWEDate = @WeDate and IsDeleted = 0 and status = ('SubmissionDate')
	GROUP BY  MOCode, BadgeNo
	UNION ALL
	SELECT WeDate, MOCode, BadgeNo, SUM(Subs) as 'Subs' FROM #StarhubFinal
	GROUP BY  WeDate, MOCode, BadgeNo
	UNION ALL
	SELECT @WeDate as 'WeDate', MOCode, BadgeNo, Subs FROM TXN_PR_Incentive_Raw_Temp WHERE WEDate = @WeDate
	
	) A GROUP BY We, MOCode, BadgeNo
   
	DROP TABLE IF EXISTS #RawCampaign
	SELECT BadgeNo, STRING_AGG(CampaignName,',') as 'Campaign' INTO #RawCampaign  FROM (
	SELECT DISTINCT   MOCode, BadgeNo, B.CampaignName
	FROM NewSGDB_PROD..VW_CH_SS A LEFT JOIN Mst_Campaign B ON A.CampaignCode = B.CampaignId WHERE StatusWEDate = @WeDate and A.IsDeleted = 0
	UNION ALL 
	SELECT MOCode, BadgeNo, 'STARHUB' FROM #StarhubFinal
	UNION ALL
	SELECT MOCode, BadgeNo, Campaign FROM TXN_PR_Incentive_Raw_Temp WHERE WEDate = @WeDate 
	) A  GROUP BY BadgeNo
	 
	DROP TABLE IF EXISTS #FinalEarning
	SELECT BadgeNo, SUM(Net) Net, 0.00 as Bonus INTO #FinalEarning FROM (
		SELECT BadgeNo, Net,0.00 AS BONUS FROM #StarhubFinal
		UNION ALL
		SELECT BadgeNo, NetEarning,0.00 AS BONUS FROM TXN_PR_Incentive_Raw_Temp  WHERE WEDate = @WeDate 
		UNION ALL
		SELECT BadgeNO,SUM(ISNULL(Netearning,0.00) + ISNULL(AppcoBonusNet,0.00))  as 'NetEarning',0.00 as Bonus 
		FROM NewSGDB_PROD..TXN_CH_ICE 
		where WeekendingDate = @WEDate  
		GROUP BY BadgeNO
	) A 
	GROUP BY BadgeNo

 
		
	IF @RepopulateData = 1 
	BEGIN
		UPDATE TXN_PR_Incentive_Raw SET isDeleted = 1, UpdatedDate = @CDate where WEDate = @WeDate and IsDeleted = 0

		INSERT [TXN_PR_Incentive_Raw]([WEDate],[MOCode],[IndependentContractorId],[CountryCode], [BadgeNo],[Campaign]
		,[Subs],[NetEarning],[Bonus],[CreatedDate],[UpdatedDate],[IsDeleted])
		SELECT @WEDate as 'WeDate',   B.Code, B.IndependentContractorId, B.CountryCode, B.BadgeNo, D.Campaign as Campaign, 
		SUM(ISNULL(C.Subs,0.00)) as 'Subs',  SUM(ISNULL(Net,0.00))  as 'NetEarning',0.00 as Bonus, @CDate, @CDate,0 
		FROM #FinalEarning A  LEFT JOIN VW_ICDetail B ON A.BadgeNo = B.BadgeNo and B.CountryCode = 'SG'
		LEFT JOIN #Raw C ON A.BadgeNo = C.BadgeNo
		LEFT JOIN #RawCampaign D ON A.BadgeNo =D.BadgeNo
		GROUP BY  B.CountryCode, D.Campaign, B.Code,B.IndependentContractorId, B.BadgeNo, C.Subs
	END

  
 -- =================================================================================================================
 -- SINGAPORE END
 -- =================================================================================================================
   

	DROP TABLE IF EXISTS #RecruiterDetail
	SELECT * INTO #RecruiterDetail FROM (
		SELECT A.IndependentContractorID, B.BadgeNo, B.CountryCode, C.IndependentContractorId as 'RecruiterID', C.BadgeNo as 'RecruiterBadge', C.CountryCode as 'RecruiterCountryCode' FROM MST_PR_Master A 
		LEFT JOIN VW_ICDetail B ON A.IndependentContractorID = B.IndependentContractorId
		LEFT JOIN VW_ICDetail C ON A.RecruiterIndependentContractorID = C.IndependentContractorId
		WHERE StartDateWE >=@RestartDate
		 UNION
		SELECT A.IndependentContractorID, B.BadgeNo, B.CountryCode, C.IndependentContractorId as 'RecruiterID', C.BadgeNo as 'RecruiterBadge', C.CountryCode as 'RecruiterCountryCode' FROM MST_PR_Master A 
		LEFT JOIN VW_ICDetail B ON A.IndependentContractorID = B.IndependentContractorId
		INNER JOIN VW_ICDetail C ON A.RecruiterIndependentContractorID = C.OriginalIndependentContractorId  
		WHERE StartDateWE >=@RestartDate
	) A

	DROP TABLE IF EXISTS #RecruiterFinalRaw
	SELECT A.IndependentContractorID, A.BadgeNo,SUM(ISNULL(Subs,0.00)) as 'Subs', SUM(ISNULL(NetEarning,0.00) + ISNULL(Bonus,0.00))   as 'Net' INTO #RecruiterFinalRaw FROM #RecruiterDetail A LEFT JOIN TXN_PR_Incentive_Raw B ON A.RecruiterBadge = B.BadgeNo and A.RecruiterCountryCode = B.CountryCode and B.IsDeleted = 0
	and B.WEDate = @WeDate
	GROUP BY A.IndependentContractorID, A.BadgeNo
    ORDER BY A.BadgeNo


	-- MileStone 1-----------------------------------------------------------------------------------------------------

	UPDATE TXN_PR_Detail SET IsDeleted =1 where MilestoneHitWE = @WeDate
	INSERT INTO TXN_PR_Detail
	SELECT   B.PRID, D.IndependentContractorLevelID, B.RecruiterIndependentContractorLevelID,  ISNULL(C.Subs,0.00) as 'RecruiterSubs', 1 as 'MilestonesType',  
	CAST((ISNULL(E.NetEarning,0.00) + ISNULL(E.Bonus,0.00)) / F.PointConversion as decimal(18,2)) as 'MileStonePoint', (ISNULL(E.NetEarning,0.00) + ISNULL(E.Bonus,0.00)) as 'MileStoneValue' ,CAST((ISNULL(E.NetEarning,0.00) + ISNULL(E.Bonus,0.00)) / F.PointConversion as decimal(18,2)) as 'MileStoneData',
	H.PayoutID, @WeDate as 'MileStoneHitWE', CASE WHEN ISNULL(C.Subs,0) > 0 THEN 1 ELSE 0 END as 'MileStonePayable', DATEADD(DAY,7,@WeDate) as 'MileStonePayoutWE',
	@CDate, NULL,0, E.Campaign FROM (
		SELECT IndependentContractorID,Badgeno, MIN(WeDate) WeDate FROM TXN_PR_Incentive_Raw where Subs > 0
		and IndependentContractorID in (SELECT IndependentContractorID FROM MST_PR_Master where StartDateWE >= @RestartDate and isdeleted = 0 )
		GROUP BY IndependentContractorID, Badgeno
	)  A LEFT JOIN MST_PR_Master B ON A.IndependentContractorID = B.IndependentContractorID and B.IsDeleted = 0
	LEFT JOIN #RecruiterFinalRaw C ON A.IndependentContractorId = C.IndependentContractorID
	LEFT JOIN VW_ICDetail D ON A.IndependentContractorId = D.IndependentContractorId
	LEFT JOIN TXN_PR_Incentive_Raw E ON A.IndependentContractorId = E.IndependentContractorId and E.WEDate = @WeDate and E.IsDeleted = 0
	LEFT JOIN #TempPoint F ON D.CountryCode = F.Country and F.StartWE <= @WeDate and F.EndWE > @WeDate
	LEFT JOIN #OPMC G ON D.CountryCode = G.CountryCode and D.Code = G.MOCode
	LEFT JOIN MST_PR_Payout H ON H.Country = D.CountryCode and H.MilestoneType = 1 and H.PayoutType = CASE WHEN RTRIM(ISNULL(G.MOCode,'')) = '' THEN 'Normal' ELSE 'PromotingOwner' END
	WHERE A.WEdate = @WeDate
	AND A.IndependentContractorId NOT IN (
			SELECT IndependentContractorId FROM VW_PR_Master where MilestonesType = 1 and IsDeleted = 0 AND MilestoneHitWE >= @RestartDate and MilestoneHitWE <  @WeDate
	) 
	AND ISNULL(D.OriginalIndependentContractorId,'')  NOT IN (
			SELECT IndependentContractorId FROM VW_PR_Master where MilestonesType = 1 and IsDeleted = 0 AND MilestoneHitWE >= @RestartDate  and MilestoneHitWE <  @WeDate
	) 
	  

	  	SELECT A.IndependentContractorID,A.Badgeno, D.OriginalIndependentContractorId, MIN(A.WeDate) WeDate FROM TXN_PR_Incentive_Raw A 
		LEFT JOIN VW_ICDetail D ON A.IndependentContractorId = D.IndependentContractorId where Subs > 0
		and A.IndependentContractorID in (SELECT IndependentContractorID FROM MST_PR_Master where StartDateWE >= @RestartDate and isdeleted = 0 )
		
		and A.badgeno = 'NT00020'
		AND ISNULL(D.OriginalIndependentContractorId,'')  NOT IN (
			SELECT IndependentContractorId FROM VW_PR_Master where MilestonesType = 1 and IsDeleted = 0 AND MilestoneHitWE >= @RestartDate  and MilestoneHitWE <  @WeDate
	) 
	  
		GROUP BY A.IndependentContractorID, A.Badgeno,D.OriginalIndependentContractorId

	-- MileStone 2-----------------------------------------------------------------------------------------------------
 
	    INSERT INTO TXN_PR_Detail 
		SELECT D.PRID,E.IndependentContractorLevelID,D.RecruiterIndependentContractorLevelID, ISNULL(C.Subs,0.00) as 'RecruiterSubs', 2 as 'MilestonesType',  
		CAST((ISNULL(A.NetEarning,0.00) + ISNULL(A.Bonus,0.00)) / B.PointConversion as decimal(18,2)) as 'MileStonePoint', (ISNULL(A.NetEarning,0.00) + ISNULL(A.Bonus,0.00)) as 'MileStoneValue' ,CAST((ISNULL(A.NetEarning,0.00) + ISNULL(A.Bonus,0.00)) / B.PointConversion as decimal(18,2)) as 'MileStoneData',
		H.PayoutID, @WeDate as 'MileStoneHitWE', CASE WHEN ISNULL(C.Subs,0) > 0 THEN 1 ELSE 0 END as 'MileStonePayable', DATEADD(DAY,7,@WeDate) as 'MileStonePayoutWE',
		@CDate, NULL,0, A.Campaign
		FROM TXN_PR_Incentive_Raw A 
		LEFT JOIN #TempPoint B ON A.CountryCode = B.Country
		LEFT JOIN MST_PR_Master D ON A.IndependentContractorId = D.IndependentContractorId
		LEFT JOIN VW_ICDetail E ON A.IndependentContractorId = E.IndependentContractorId
		LEFT JOIN #RecruiterFinalRaw C ON A.IndependentContractorId = C.IndependentContractorID-- and A.WEDate > C.StartWE and A.WEDate <= C.EndWE
		LEFT JOIN #TempPoint F ON E.CountryCode = F.Country and F.StartWE <= @WeDate and F.EndWE > @WeDate
		LEFT JOIN #OPMC G ON E.CountryCode = G.CountryCode and E.Code = G.MOCode
		LEFT JOIN MST_PR_Payout H ON H.Country = E.CountryCode and H.MilestoneType = 2 and H.PayoutType = CASE WHEN RTRIM(ISNULL(G.MOCode,'')) = '' THEN 'Normal' ELSE 'PromotingOwner' END
	
		WHERE A.IndependentContractorID in (SELECT IndependentContractorID FROM MST_PR_Master where StartDateWE >= @RestartDate and isdeleted = 0 ) 
		AND CAST((ISNULL(A.NetEarning,0.00) + ISNULL(A.Bonus,0.00) ) / B.PointConversion as decimal(18,2)) >= 8.00 and A.WEDate = @WeDate
		AND 
		A.IndependentContractorId not in (
		SELECT IndependentContractorId FROM VW_PR_Master WHERE MilestonesType = 2 and IsDeleted = 0 and MilestoneHitWE > @RestartDate and MilestoneHitWE < @WeDate
		)
		AND 
		ISNULL(E.OriginalIndependentContractorId,'') not in (
		SELECT IndependentContractorId FROM VW_PR_Master WHERE MilestonesType = 2 and IsDeleted = 0 and MilestoneHitWE > @RestartDate and MilestoneHitWE < @WeDate
		)



		-- MileStone 3-----------------------------------------------------------------------------------------------------
 
	    INSERT INTO TXN_PR_Detail 
		SELECT D.PRID,E.IndependentContractorLevelID,D.RecruiterIndependentContractorLevelID, ISNULL(C.Subs,0.00) as 'RecruiterSubs', 4 as 'MilestonesType',  
		CAST((ISNULL(A.NetEarning,0.00) + ISNULL(A.Bonus,0.00)) / B.PointConversion as decimal(18,2)) as 'MileStonePoint', (ISNULL(A.NetEarning,0.00) + ISNULL(A.Bonus,0.00)) as 'MileStoneValue' ,CAST((ISNULL(A.NetEarning,0.00) + ISNULL(A.Bonus,0.00)) / B.PointConversion as decimal(18,2)) as 'MileStoneData',
		H.PayoutID, @WeDate as 'MileStoneHitWE', CASE WHEN ISNULL(C.Subs,0) > 0 THEN 1 ELSE 0 END as 'MileStonePayable', DATEADD(DAY,7,@WeDate) as 'MileStonePayoutWE',
		@CDate, NULL,0, A.Campaign
		FROM TXN_PR_Incentive_Raw A 
		LEFT JOIN #TempPoint B ON A.CountryCode = B.Country
		LEFT JOIN MST_PR_Master D ON A.IndependentContractorId = D.IndependentContractorId
		LEFT JOIN VW_ICDetail E ON A.IndependentContractorId = E.IndependentContractorId
		LEFT JOIN #RecruiterFinalRaw C ON A.IndependentContractorId = C.IndependentContractorID-- and A.WEDate > C.StartWE and A.WEDate <= C.EndWE
		LEFT JOIN #TempPoint F ON E.CountryCode = F.Country and F.StartWE <= @WeDate and F.EndWE > @WeDate
		LEFT JOIN #OPMC G ON E.CountryCode = G.CountryCode and E.Code = G.MOCode
		LEFT JOIN MST_PR_Payout H ON H.Country = E.CountryCode and H.MilestoneType = 4 and H.PayoutType = CASE WHEN RTRIM(ISNULL(G.MOCode,'')) = '' THEN 'Normal' ELSE 'PromotingOwner' END
	
		WHERE A.IndependentContractorID in (SELECT IndependentContractorID FROM MST_PR_Master where StartDateWE >= @RestartDate and isdeleted = 0 ) 
		AND CAST((ISNULL(A.NetEarning,0.00) + ISNULL(A.Bonus,0.00) ) / B.PointConversion as decimal(18,2)) >= 16.00 and A.WEDate = @WeDate
	
		UPDATE B SET B.RecruiterSubPcs = 1, MilestonePayable = 1 FROM MST_PR_Master a left JOIN TXN_PR_Detail B ON A.PRID = B.PRID 
		LEFT JOIN VW_ICDetail C ON A.RecruiterIndependentContractorID = C.IndependentContractorId
		where C.IndependentContractorLevelId in (
		2,5
		) and MilestoneHitWE = @WeDate and RecruiterSubPcs = 0
		 
		 SELECT MOCode as 'Unconfirmed MO' FROM NEWSGDB_PROD..VW_CH_SS WHERE StatusWEDate =@WeDate and MOCode not in (
			SELECT distinct MoCode FROM NEWSGDB_PROD..TXN_CH_ICE where WeekendingDate =@WeDate
		)

END  
	 


	 		 
