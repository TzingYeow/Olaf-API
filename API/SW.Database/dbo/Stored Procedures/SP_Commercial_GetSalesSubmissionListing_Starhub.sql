CREATE   PROCEDURE [dbo].[SP_Commercial_GetSalesSubmissionListing_Starhub]
	@SignupDate DATE,
	@WeekendingDate DATE,
	@MOCode NVARCHAR(20),
	@BadgeNo NVARCHAR(20)
AS
BEGIN
	SELECT A.TxnID, A.SignupDate, A.DateOnField, A.DayOnField, A.WEDate, A.MOCode, A.BadgeNo, A.BAName, A.LeadType, A.LocationCode, A.SubmissionType, A.BAEarning, A.AreaCode, A.UnitNo, A.PostCode, A.StreetName, A.BuildingNo, A.BuildingName, B.OpptyNo, B.ProductCategory, B.ProductPlan, B.TCV, A.CreatedDate, A.CreatedBy 
	FROM TXN_Starhub_Submission AS A
	INNER JOIN TXN_Starhub_Submission_Plan AS B ON A.TxnID = B.TxnID
	WHERE (A.MOCode = @MOCode OR @MOCode = '') AND (A.BadgeNo = @BadgeNo OR @BadgeNo = 'ALL' OR @BadgeNo = '') AND (CAST(A.SignupDate AS DATE) = @SignupDate OR @SignupDate IS NULL ) AND (A.WEDate = @WeekendingDate OR @WeekendingDate IS NULL)
	ORDER BY A.CreatedDate DESC
END
