CREATE  PROCEDURE [dbo].[SP_Commercial_TransactionChangeStatus_Starhub]
	--@OpportunityNo NVARCHAR(50),
	--@ServiceID NVARCHAR(50),
	@TxnID NVARCHAR(50),
	@MC NVARCHAR(10) NULL,
	@BadgeNo NVARCHAR(20) NULL,
	@Status NVARCHAR(50),
	@ResubDate DATE,
	@UpdatedDate DATETIME,
	@UpdatedBy NVARCHAR(50),
	@ResultCode INT OUTPUT
	
AS
BEGIN
	
	BEGIN TRY
		BEGIN TRAN

			EXEC SP_Commercial_ArchivedTransaction_Starhub @TxnID, 'RESUB - Transaction Status Changed', @UpdatedBy

			DECLARE @BAName NVARCHAR(150) = (SELECT ICName 
											 FROM VW_MST_ICDivClientAssignment 
											 WHERE BadgeNo = @BadgeNo)

			UPDATE TXN_Starhub_Transaction
			SET MOCode = @MC, BadgeNo = @BadgeNo, BAName = @BAName, UpdatedDate = @UpdatedDate, UpdatedBy = @UpdatedBy
			WHERE TxnID = @TxnID

			UPDATE TXN_Starhub_Transaction_Status
			SET SalesworksStatus = @Status, ResubDate = @ResubDate, ResubWEDate = dbo.WeekedingDate(@ResubDate), UpdatedDate = @UpdatedDate, UpdatedBy = @UpdatedBy
			WHERE TxnID = @TxnID

			--EXEC SP_Commercial_GenerateStatusSummaryByTxnID_Starhub @TxnID, @UpdatedDate, @UpdatedBy

		COMMIT
		SET @ResultCode = 1
	END TRY 
	BEGIN CATCH
		IF @@TRANCOUNT > 0
		ROLLBACK TRAN
		SET @ResultCode = 2
	END CATCH
	RETURN @ResultCode
END	
