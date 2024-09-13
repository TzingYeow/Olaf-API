
CREATE PROCEDURE [dbo].[SP_Commercial_Mobile_GetPayout_Starhub]
(
	@CustomerType NVARCHAR(50),
	@OrderType NVARCHAR(50),
	@ProductType NVARCHAR(50)
)
AS 
BEGIN
	SET NOCOUNT ON;

	--DECLARE @CustomerType NVARCHAR(50) = 'NEW',
	--		@OrderType NVARCHAR(50) = 'NEW',
	--		@ProductType NVARCHAR(50) = 'SIMONLY - 12MTH - BIZ+ PREMIUM'

	--select * from Mst_Payout_Starhub as a
	--inner join Mst_Product_Starhub as b on a.ProductId = b.Id
	--where a.CustomerType = @CustomerType and a.OrderType = @OrderType and b.ProductType = @ProductType and (GETDATE() >= StartDate and GETDATE() <= EndDate)
	--select * from Mst_Product_Starhub

	SELECT Payout.RowId, Product.ProductCategory, Payout.BA, Payout.PayoutType
	FROM Mst_Payout_Starhub AS Payout
	INNER JOIN Mst_Product_Starhub AS Product ON Payout.ProductId = Product.Id
	WHERE Payout.CustomerType = @CustomerType AND 
		  Payout.OrderType = @OrderType AND 
		  (GETDATE() >= Payout.StartDate AND GETDATE() <= Payout.EndDate) AND
		  Product.ProductType = @ProductType AND 
		  Product.IsActive = 1
END
