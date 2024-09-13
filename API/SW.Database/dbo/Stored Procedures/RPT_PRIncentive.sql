-- =============================================
 -- RPT_PRIncentive '2023-11-26', 'SG','EV'
-- =============================================
CREATE PROCEDURE [dbo].[RPT_PRIncentive]
	@WeDate DATE, @Country NVARCHAR(50), @MCCode NVARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT  PY.PayoutID, A.PRID, IC.CountryCode,IC.Code, RC.BadgeNo as 'RC_BadgeNo', RTRIM(LTRIM(ISNULL(RC.FirstName,'') + ' ' + ISNULL(RC.LastName,''))) as 'RC_FullName',
	CASE WHEN B.RecruiterSubPcs > 0 THEN 'YES' ELSE 'NO' END as 'RC_Subs', IC.BadgeNo,RTRIM(LTRIM(ISNULL(IC.FirstName,'') + ' ' + ISNULL(IC.LastName,''))) as 'FullName',
	B.MilestoneHitWE, DATEADD(day, 7 , @WeDate) as 'PayWe', CASE WHEN B.MilestonesType = 1 THEN '' ELSE B.MilestonesData END as 'PRPoint',
	B.MileStonesValue, B.MileStonesPoint,
	CASE WHEN B.MilestonesType = 1 THEN 'PR does 1st sale (net)'
		 WHEN B.MilestonesType = 2 THEN 'PR hits 8 points in a WE '
		 WHEN B.MilestonesType = 3 THEN 'PR achieves 6 points for 2 consec WEs'
		 WHEN B.MilestonesType = 4 THEN 'Achieves 16 points in individual sales'
		 WHEN B.MilestonesType = 5 THEN 'PR advanced to TL'
		 WHEN B.MilestonesType = 6 THEN 'PR advanced to AOP'
		 WHEN B.MilestonesType = 6 THEN 'PR advanced to OP' ELSE '' END as 'PRDetail', 
		 CASE WHEN B.RecruiterSubPcs = 0 OR B.MilestonePayable = 0 THEN 0.00 ELSE  PY.PO END as 'PO', 
		 CASE WHEN B.RecruiterSubPcs = 0 OR B.MilestonePayable = 0 THEN 0.00 ELSE  PY.MC END as 'MC' ,
		 CASE WHEN B.RecruiterSubPcs = 0 OR B.MilestonePayable = 0 THEN 0.00 ELSE  PY.SW END as 'SW',
		 ISNULL(BI.BankAccountName, Rc.BankAccountName) BankAccountName, ISNULL(BI.BankAccountNo, Rc.BankAccountNo) BankAccountNo,
		 ISNULL(BI.BankName, Rc.BankName) BankName, ISNULL(BI.ICNo, RC.Ic) as Ic, UPPER(B.campaign) as 'Campaign'  FROM MST_PR_Master A 
	LEFT JOIN TXN_PR_Detail B ON A.PRID = B.PRID
	LEFT JOIN VW_ICDetail IC ON A.IndependentContractorID = IC.IndependentContractorId
	LEFT JOIN VW_ICDetail RC ON A.RecruiterIndependentContractorID = RC.IndependentContractorId
	LEFT JOIN MST_PR_Payout PY ON B.PayoutID = PY.PayoutID
	LEFT JOIN MST_PR_CustomBankInfo BI ON SUBSTRING(IC.BadgeNo,1,2) = BI.MCCode and IC.CountryCode = BI.CountryCode

	WHERE IC.Code not in ('NA') and B.MilestoneHitWE = @WeDate  and A.IsDeleted = 0 and b.IsDeleted = 0  and B.MileStonesValue is not null
	and ic.IsDeleted = 0 and rc.IsDeleted = 0 and
	(IC.CountryCode in (SELECT * FROM string_split(@Country,',')) OR @Country = '')
	AND
	(IC.Code in (SELECT * FROM string_split(@MCCode,',')) OR @MCCode = '')
	AND B.MilestoneHitWE >='2024-01-01'
END  