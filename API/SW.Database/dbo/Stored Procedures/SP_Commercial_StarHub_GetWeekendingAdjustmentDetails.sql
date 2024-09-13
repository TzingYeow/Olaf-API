CREATE PROCEDURE [dbo].[SP_Commercial_StarHub_GetWeekendingAdjustmentDetails]
	@MOCode NVARCHAR(20),
	@WEDate DATE
AS
BEGIN
	
	--DECLARE @MOCode NVARCHAR(20);
	--DECLARE @WEDate DATE;
	--SET @MOCode = 'SI';
	--SET @WEDate = '2023-12-10';
	
	DROP TABLE IF EXISTS #TempResult;
	DROP TABLE IF EXISTS #TempResultOfWk;
	DROP TABLE IF EXISTS #TempMainResult;
	DROP TABLE IF EXISTS #TempExisting;

	DECLARE @DivisionCode NVARCHAR(10);
	SET @DivisionCode='CO';

	CREATE TABLE #TempResult
	(
		GroupSeq INT,
		DivisionCode NVARCHAR(10),
		SeqOrder INT,
		WeekendingDate DATE,
		MOCode NVARCHAR(20),
		BadgeNo NVARCHAR(20),
		BAName NVARCHAR(100),
		CampaignID INT,
		ProductType NVARCHAR(100),
		TCV INT,
		GrossQty INT,
		GrossBAFees Decimal(18, 2),
		GrossQty_AddTS INT,
		GrossBAFees_AddTS Decimal(18, 2),
		RejectQty INT,
		RejectBAFees Decimal(18, 2),
		RejectQty_AddTS INT,
		RejectBAFees_AddTS Decimal(18, 2),
		ResubQty INT,
		ResubBAFees Decimal(18, 2),
		ResubQty_AddTS INT,
		ResubBAFees_AddTS Decimal(18, 2),
		NetQty INT,
		NetBAFees Decimal(18, 2),
		NetQty_AddTS INT,
		NetBAFees_AddTS Decimal(18, 2),
		RetainerFee Decimal(18, 2),
		TotalBAEarnings Decimal(18, 2),
		CashBonus Decimal(18, 2),
		Remarks NVARCHAR(100),
		CBBackToFieldBonus Decimal(18, 2),
		SalesworksBonusGross Decimal(18, 2),
		Remarks1 NVARCHAR(100),
		SalesworksBonusReject Decimal(18, 2),
		Remarks2 NVARCHAR(100),
		SalesworksBonusResub Decimal(18, 2),
		Remarks3 NVARCHAR(100),
		SalesworksBonusNet Decimal(18, 2),
		Remarks4 NVARCHAR(100),
		MOBonus Decimal(18, 2),
		Remarks5 NVARCHAR(100),
		OtherBonus Decimal(18, 2),
		Remarks6 NVARCHAR(100),
		IPADBonus Decimal(18, 2),
		Remarks7 NVARCHAR(100),
		BondsInHand Decimal(18, 2),
		Remarks8 NVARCHAR(100),
		OtherBonds Decimal(18, 2),
		Remarks9 NVARCHAR(100),
		BondsRelease Decimal(18, 2),
		Remarks10 NVARCHAR(100),
		BondsDeduction Decimal(18, 2),
		Remarks11 NVARCHAR(100),
		OtherDeduction Decimal(18, 2),
		Remarks12 NVARCHAR(100),
		Savings Decimal(18, 2),
		TeamLeaderOverrides Decimal(18, 2),
		ActualPaid Decimal(18, 2),
		ConfirmPayment NVARCHAR(100),
		AccountNo NVARCHAR(50),
	)

	SELECT *
	INTO #TempExisting
	FROM TXN_Starhub_ICE
	WHERE WeekendingDate = @WEDate AND MOCode = @MOCode;

	SELECT TSS.StatusWEDate, TS.MOCode, TS.BadgeNo, TS.BAName, TS.CampaignCode, TSP.Payout_ID, TSP.ProductType, TSP.Payout_BA, TSP.TCV,
	   SUM(CASE WHEN (TSS.[Status] = 'PENDING' AND IsNull(TSP.Payout_ID, 0) >= 0) THEN 1 
		   ELSE 0 END) as 'GrossQty',
	   SUM(CASE WHEN (TSS.[Status] = 'PENDING' AND IsNull(TSP.Payout_ID, 0) >= 0) THEN IsNull(TSP.Payout_BA, 0) 
		   ELSE 0 END) as 'GrossBAFees',
	   SUM(CASE WHEN (TSS.[Status] = 'REJECT' OR TSS.[Status] = 'SALESWORKSREJECT' OR TSS.[Status] = 'CANCELLATIONREJECT' AND IsNull(TSP.Payout_ID, 0) >= 0) THEN 1 
		   ELSE 0 END) as 'RejectQty',
	   SUM(CASE WHEN (TSS.[Status] = 'REJECT' OR TSS.[Status] = 'SALESWORKSREJECT' OR TSS.[Status] = 'CANCELLATIONREJECT' AND IsNull(TSP.Payout_ID, 0) >= 0) THEN IsNull(TSP.Payout_BA, 0) 
		   ELSE 0 END) as 'RejectBAFees',
	   SUM(CASE WHEN (TSS.[Status] = 'RESUB' AND IsNull(TSP.Payout_ID, 0) >= 0) THEN 1 
		   ELSE 0 END) as 'ResubQty',
	   SUM(CASE WHEN (TSS.[Status] = 'RESUB' AND IsNull(TSP.Payout_ID, 0) >= 0) THEN IsNull(TSP.Payout_BA, 0) 
		   ELSE 0 END) as 'ResubBAFees'
	INTO #TempResultOfWk
	FROM TXN_Starhub_TransStatusSummary_Status as TSS
	INNER JOIN TXN_Starhub_TransStatusSummary_Product as TSP on TSP.SummaryId = TSS.SummaryId  AND TSP.TxnID = TSS.TxnID
	INNER JOIN TXN_Starhub_Transaction_StatusSummary as TS on TS.SummaryId = TSP.SummaryId AND TS.TxnID = TSP.TxnID
	WHERE TSS.StatusWEDate = @WEDate AND TS.MOCode = @MOCode --AND TSS.Status <> 'PENDING'
	GROUP BY TSS.StatusWEDate, TS.MOCode, TS.BadgeNo, TS.BAName, TS.CampaignCode, TSP.Payout_ID, TSP.ProductType, TSP.Payout_BA, TSP.TCV;


	SELECT MainList.StatusWEDate, MainList.MOCode, MainList.CampaignCode, MainList.BadgeNo, MainList.BAName,
		   MainList.Payout_ID, MainList.ProductType, MainList.TCV,
		   IsNull(GrossList.GrossQty, 0) as 'GrossQty',
		   IsNull(GrossList.GrossBAFees, 0) as 'GrossBAFees',
		   IsNull(GrossList.RejectQty, 0) as 'RejectQty',
		   IsNull(GrossList.RejectBAFees, 0) as 'RejectBAFees',
		   IsNull(GrossList.ResubQty, 0) as 'ResubQty',
		   IsNull(GrossList.ResubBAFees, 0) as 'ResubBAFees'
	INTO #TempMainResult
	FROM (
		SELECT A.StatusWEDate, A.MOCode, A.CampaignCode, A.BadgeNo, A.BAName, A.Payout_ID, A.ProductType, A.TCV
		FROM #TempResultOfWk AS A
		CROSS APPLY (
			SELECT Distinct Payout_ID, ProductType FROM #TempResultOfWk
		) AS B
		GROUP BY A.StatusWEDate, A.MOCode, A.CampaignCode, A.BadgeNo, A.BAName, A.Payout_ID, A.ProductType, A.TCV
	) as MainList
	LEFT JOIN #TempResultOfWk as GrossList on GrossList.StatusWEDate = MainList.StatusWEDate AND
											  GrossList.MOCode = MainList.MOCode AND
											  GrossList.BadgeNo = Mainlist.BadgeNo AND
											  GrossList.BAName = MainList.BAName AND
											  GrossList.Payout_ID = MainList.Payout_ID AND
											  GrossList.TCV = MainList.TCV;

	INSERT INTO #TempResult(GroupSeq, DivisionCode, SeqOrder, WeekendingDate, MOCode, BadgeNo, BAName, CampaignID, ProductType, TCV,
							GrossQty, GrossBAFees, GrossQty_AddTS, GrossBAFees_AddTS, RejectQty, RejectBAFees, RejectQty_AddTS, RejectBAFees_AddTS,
							ResubQty, ResubBAFees, ResubQty_AddTS, ResubBAFees_AddTS, NetQty, NetBAFees, NetQty_AddTS, NetBAFees_AddTS)
	SELECT 0, @DivisionCode, 1, T.StatusWEDate, T.MOCode, T.BadgeNo, T.BAName, T.CampaignCode, T.ProductType, T.TCV,
		   T.GrossQty, T.GrossBAFees, 0, 0, T.RejectQty, T.RejectBAFees, 0, 0, T.ResubQty, T.ResubBAFees, 0, 0,
		   (T.GrossQty - T.RejectQty + T.ResubQty) as 'NetQty',
		   (T.GrossBAFees - T.RejectBAFees + T.ResubBAFees) as 'NetBAFees', 0, 0
	FROM #TempMainResult AS T;

	/*----- SUM UP Each BA ------*/
	INSERT INTO #TempResult(GroupSeq, DivisionCode, SeqOrder, WeekendingDate, MOCode, BadgeNo, BAName, CampaignID, ProductType, TCV,
							GrossQty, GrossBAFees, GrossQty_AddTS, GrossBAFees_AddTS, RejectQty, RejectBAFees, RejectQty_AddTS, RejectBAFees_AddTS,
							ResubQty, ResubBAFees, ResubQty_AddTS, ResubBAFees_AddTS, NetQty, NetBAFees, NetQty_AddTS, NetBAFees_AddTS)
	SELECT 0, @DivisionCode, 2, TT.WeekendingDate, TT.MOCode, TT.BadgeNo, TT.BAName, TT.CampaignID, 'ALL', 
		   SUM(TT.TCV) as 'TCV',
		   SUM(TT.GrossQty) as 'GrossQty', 
		   SUM(TT.GrossBAFees) as 'GrossBAFees', 
		   SUM(TT.GrossQty_AddTS) as 'GrossQty_AddTS', 
		   SUM(TT.GrossBAFees_AddTS) as 'GrossBAFees_AddTS', 
		   SUM(TT.RejectQty) as 'RejectQty', 
		   SUM(TT.RejectBAFees) as 'RejectBAFees', 
		   SUM(TT.RejectQty_AddTS) as 'RejectQty_AddTS', 
		   SUM(TT.RejectBAFees_AddTS) as 'RejectBAFees_AddTS', 
		   SUM(TT.ResubQty) as 'ResubQty', 
		   SUM(TT.ResubBAFees) as 'ResubBAFees', 
		   SUM(TT.ResubQty_AddTS) as 'ResubQty_AddTS', 
		   SUM(TT.ResubBAFees_AddTS) as 'ResubBAFees_AddTS',
		   SUM(TT.NetQty) as 'NetQty',
		   SUM(TT.NetBAFees) as 'NetBAFees',
		   SUM(TT.NetQty_AddTS) as 'NetQty_AddTS',
		   SUM(TT.NetBAFees_AddTS) as 'NetBAFees_AddTS'
	FROM #TempResult AS TT
	GROUP BY TT.WeekendingDate, TT.MOCode, TT.BadgeNo, TT.BAName, TT.CampaignID;

	/*----- Grand Total ------*/
	/*
	INSERT INTO #TempResult(GroupSeq, DivisionCode, SeqOrder, WeekendingDate, MOCode, BadgeNo, BAName, CampaignID, ProductType, TCV,
							GrossQty, GrossBAFees, GrossQty_AddTS, GrossBAFees_AddTS, RejectQty, RejectBAFees, RejectQty_AddTS, RejectBAFees_AddTS,
							ResubQty, ResubBAFees, ResubQty_AddTS, ResubBAFees_AddTS, NetQty, NetBAFees, NetQty_AddTS, NetBAFees_AddTS)
	SELECT 1, @DivisionCode, 1, T2.WeekendingDate, T2.MOCode, 'ALL', 'ALL', T2.CampaignID, 'ALL', 
		   SUM(T2.TCV) as 'TCV',
		   SUM(T2.GrossQty) as 'GrossQty', 
		   SUM(T2.GrossBAFees) as 'GrossBAFees', 
		   SUM(T2.GrossQty_AddTS) as 'GrossQty_AddTS', 
		   SUM(T2.GrossBAFees_AddTS) as 'GrossBAFees_AddTS', 
		   SUM(T2.RejectQty) as 'RejectQty', 
		   SUM(T2.RejectBAFees) as 'RejectBAFees', 
		   SUM(T2.RejectQty_AddTS) as 'RejectQty_AddTS', 
		   SUM(T2.RejectBAFees_AddTS) as 'RejectBAFees_AddTS', 
		   SUM(T2.ResubQty) as 'ResubQty', 
		   SUM(T2.ResubBAFees) as 'ResubBAFees', 
		   SUM(T2.ResubQty_AddTS) as 'ResubQty_AddTS', 
		   SUM(T2.ResubBAFees_AddTS) as 'ResubBAFees_AddTS',
		   SUM(T2.NetQty) as 'NetQty',
		   SUM(T2.NetBAFees) as 'NetBAFees',
		   SUM(T2.NetQty_AddTS) as 'NetQty_AddTS',
		   SUM(T2.NetBAFees_AddTS) as 'NetBAFees_AddTS'
	FROM #TempResult AS T2
	GROUP BY T2.WeekendingDate, T2.MOCode, T2.CampaignID;
	*/
	UPDATE S
	SET S.ActualPaid = ((S.NetBAFees + IsNull(S.SalesworksBonusGross, 0) + IsNull(S.SalesworksBonusReject, 0) + 
						 IsNull(S.SalesworksBonusResub, 0) + IsNull(S.SalesworksBonusNet, 0) +
						 IsNull(S.MOBonus, 0) + IsNull(S.OtherBonus, 0) + IsNull(S.IPadBonus, 0) + 
						 IsNull(S.BondsInHand, 0) + IsNull(S.OtherBonds, 0) + IsNull(S.BondsRelease, 0) + IsNull(S.Savings, 0) + 
						 IsNull(S.TeamLeaderOverrides, 0)) 
					     - IsNull(S.BondsDeduction, 0) - IsNull(S.OtherDeduction, 0))
	FROM #TempResult as S
	WHERE S.SeqOrder = 2 AND S.ProductType='ALL' AND S.ActualPaid Is Null;

	UPDATE A
	SET A.CashBonus = B.CashBonus,
		A.TotalBAEarnings = B.TotalBAEarnings,
		A.RetainerFee = B.RetainerFee,
		A.Remarks = B.Remarks,
		A.CBBackToFieldBonus = B.CBBackToFieldBonus,
		A.SalesworksBonusGross = B.SalesworksBonusGross,
		A.Remarks1 = B.Remarks1,
		A.SalesworksBonusReject = B.SalesworksBonusReject,
		A.Remarks2 = B.Remarks2,
		A.SalesworksBonusResub = B.SalesworksBonusResub,
		A.Remarks3 = B.Remarks3,
		A.SalesworksBonusNet = B.SalesworksBonusNet,
		A.Remarks4 = B.Remarks4,
		A.MOBonus = B.MOBonus,
		A.Remarks5 = B.Remarks5,
		A.OtherBonus = B.OtherBonus,
		A.Remarks6 = B.Remarks6,
		A.IPADBonus = B.IPADBonus,
		A.Remarks7 = B.Remarks7,
		A.BondsInHand = B.BondsInHand,
		A.Remarks8 = B.Remarks8,
		A.OtherBonds = B.OtherBonds,
		A.Remarks9 = B.Remarks9,
		A.BondsRelease = B.BondsRelease,
		A.Remarks10 = B.Remarks10,
		A.BondsDeduction = B.BondsDeduction,
		A.Remarks11 = B.Remarks11,
		A.OtherDeduction = B.OtherDeduction,
		A.Remarks12 = B.Remarks12,
		A.Savings = B.Savings,
		A.TeamLeaderOverrides = B.TeamLeaderOverrides,
		A.ActualPaid = B.ActualPaid,
		A.ConfirmPayment = B.ConfirmPayment,
		A.AccountNo = B.AccountNo
	FROM #TempResult as A
	LEFT JOIN #TempExisting as B on B.BadgeNo = A.BadgeNo
	WHERE A.SeqOrder = 2 AND A.ProductType='ALL';

	SELECT ROW_NUMBER() OVER (ORDER BY GroupSeq, BadgeNo, BAName, SeqOrder, ProductType) AS 'Row_Number', A.*
	FROM #TempResult as A
	ORDER BY GroupSeq, BadgeNo, BAName, SeqOrder, ProductType;
END
