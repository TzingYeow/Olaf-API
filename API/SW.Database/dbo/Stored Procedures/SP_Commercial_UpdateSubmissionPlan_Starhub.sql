CREATE   PROCEDURE [dbo].[SP_Commercial_UpdateSubmissionPlan_Starhub]
	@ID NVARCHAR(50),
	@TxnID NVARCHAR(50),
	--@OldOpptyNo NVARCHAR(50),
	@OpptyNo NVARCHAR(50),
	@CustomerType NVARCHAR(50),
	@OrderType NVARCHAR(50),
	@ProductType NVARCHAR(200),
	@TCV INT,
	@UpdatedDate DATETIME,
	@UpdatedBy NVARCHAR(50),

	@Return INT OUTPUT
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN

			DECLARE @PayoutID BIGINT,
					@ProductCategory NVARCHAR(50),
					@ProductPlan NVARCHAR(50),
					@BAEarning DECIMAL(18,2)

			SELECT @PayoutID = A.RowID, @ProductCategory = B.ProductCategory, @ProductPlan = @CustomerType + ' ' + @OrderType + ' ' + @ProductType
			FROM Mst_Payout_Starhub AS A
			INNER JOIN Mst_Product_Starhub AS B ON A.ProductId = B.Id
			WHERE A.CustomerType = @CustomerType AND
				  A.OrderType = @OrderType AND
				  (GETDATE() >= A.StartDate AND GETDATE() <= A.EndDate) AND
				  B.ProductType = @ProductType AND
				  B.IsActive = 1

			UPDATE TXN_Starhub_Submission_Plan
			SET OpptyNo = @OpptyNo, PayoutID = @PayoutID, ProductCategory = @ProductCategory, ProductPlan = @ProductPlan, TCV = @TCV
			WHERE ID = @ID

			SET @BAEarning = (SELECT SUM(CASE WHEN B.PayoutType = 'PERCENTAGE' THEN (TCV * BA) / 100
										      WHEN B.PayoutType = 'FIXED VALUE' THEN (TCV * BA)
									     END) 
							  FROM TXN_Starhub_Submission_Plan AS A
							  INNER JOIN Mst_Payout_Starhub AS B ON A.PayoutID = B.RowID
						      WHERE A.TxnID = @TxnID)

			UPDATE TXN_Starhub_Submission
			SET BAEarning = @BAEarning, UpdatedDate = @UpdatedDate, UpdatedBy = @UpdatedBy
			WHERE TxnID = @TxnID
			
		COMMIT
		SET @Return = 1
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK
			SET @Return = 2
	END CATCH

	RETURN @Return
END
