CREATE PROCEDURE [dbo].[SP_Commercial_GetSalesSummaryPlanDetailsById_Starhub]
	@TxnID NVARCHAR(50)
AS
BEGIN
	SELECT A.ID, A.TxnID, A.OpptyNo, A.ProductCategory, A.ProductPlan, A.TCV, B.CustomerType, B.OrderType, C.ProductType
	FROM TXN_Starhub_Submission_Plan AS A
	INNER JOIN Mst_Payout_Starhub AS B ON A.PayoutID = B.RowID
	INNER JOIN Mst_Product_Starhub AS C ON B.ProductId = C.Id
	WHERE A.TxnID = @TxnID
END
