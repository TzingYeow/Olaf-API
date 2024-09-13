CREATE PROCEDURE [dbo].[SP_Commercial_Starhub_UpdateTransactionDetails]
	@TxnID NVARCHAR(50),
	@MOCode NVARCHAR(10),
	@BadgeNo NVARCHAR(10),
	@Reseller NVARCHAR (50),
	@Remarks TEXT,
	@UpdatedBy NVARCHAR(50),
	@ResultCode NVARCHAR(10) OUTPUT

AS
BEGIN
	BEGIN TRY
		BEGIN TRAN

			DECLARE @ResellerBadgeNo NVARCHAR(20)
			SET @ResellerBadgeNo = LEFT(@Reseller, CHARINDEX(' -', @Reseller) - 1)

			IF EXISTS(SELECT 1 FROM VW_MST_ICDivClientAssignment WHERE MOCode = @MOCode AND BadgeNo = @BadgeNo AND CampaignId = '1125' AND ((StartDate <= GETDATE() AND EndDate IS Null) OR (StartDate <= GETDATE() AND EndDate >= GETDATE())) )
				BEGIN
					IF (@BadgeNo = @ResellerBadgeNo)
						BEGIN
							EXEC SP_Commercial_ArchivedTransaction_Starhub @TxnID, 'Transaction Detail Edit', @UpdatedBy
					
							INSERT TXN_Starhub_Transaction_UpdateInfoLog(TxnID, EntityName, Remarks, CreatedDate, CreatedBy)
							VALUES(@TxnID, 'TXN_Starhub_Transaction', @Remarks, GETDATE(), @UpdatedBy)

							DECLARE @BAName NVARCHAR(100)
							SET @BAName = (SELECT ICName FROM VW_MST_IC WHERE BadgeNo = @BadgeNo AND OfficeCode =  @MOCode AND IsActive = 1)

							UPDATE TXN_Starhub_Transaction
							SET MOCode = @MOCode,
								BadgeNo = @BadgeNo,
								BAName = @BAName,
								Reseller = @Reseller,
								UpdatedDate = GETDATE(),
								UpdatedBy = @UpdatedBy
							WHERE TxnID = @TxnID

							IF EXISTS (SELECT 1 FROM TXN_Starhub_Transaction_StatusSummary WHERE TxnID = @TxnID)
								BEGIN

									DECLARE @SummaryID NVARCHAR(100)
									SET @SummaryID = (SELECT TOP 1 SummaryID FROM TXN_Starhub_Transaction_StatusSummary WHERE TxnID = @TxnID ORDER BY SummaryCreatedDate DESC)

									UPDATE TXN_Starhub_Transaction_StatusSummary
									SET MOCode = @MOCode,
										BadgeNo = @BadgeNo,
										BAName = @BAName,
										Reseller = @Reseller,
										UpdatedDate = GETDATE(),
										UpdatedBy = @UpdatedBy
									WHERE TxnID = @TxnID
									AND SummaryID = @SummaryID

									SET @ResultCode = '0001';
								END
						END
					ELSE
						BEGIN
							SET @ResultCode = '0003';
						END
				END
			ELSE
				BEGIN
					SET @ResultCode = '0002';
				END

		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION 

		SET @resultCode = '0000';

		PRINT N'Error Line = ' + CAST(ERROR_LINE() AS nvarchar(100));
		PRINT N'Error Message = ' + CAST(ERROR_MESSAGE() AS nvarchar(100));
	END CATCH
END
