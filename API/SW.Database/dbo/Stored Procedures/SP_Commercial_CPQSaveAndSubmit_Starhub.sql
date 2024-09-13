CREATE   PROCEDURE [dbo].[SP_Commercial_CPQSaveAndSubmit_Starhub]
	@Id INT,
	@OpportunityNo NVARCHAR(30),
	@Reseller NVARCHAR(50),
	@ProductName NVARCHAR(200),
	@LastModifiedDate DATE,

	@ResultCode NVARCHAR(20) OUTPUT
AS
BEGIN

	DECLARE @RCode NVARCHAR(20),
			@RMessage NVARCHAR(100)

	BEGIN TRY
		BEGIN TRAN

			INSERT INTO TXN_Temp_Starhub_CPQ (System_TransactionKey, SubmissionDate, Reseller, NewAccountType, TypeOfContract, RevenueFlag, ProductName, CompanyName, BusinessRegNo, 
											  Promotion, MRCCurrency, MRC, QuantityPaidMonths, CCVCurrency, CCV, OrderCreatedDate, OpportunityStatus, OrderLastModifiedDate, StarhubServiceID, 
											  OpportunityNo, OwnerDivision, CPQOpportunity, OrderAcceptanceDate, DateContractSigned, DateOrderSubmitted, CloseDate, PrimaryContact, ContactEmail,
											  ContactOfficePhone, Contact1, Contact1Email, NewAccountDate, ExistingAccountDate, CRDate, OpportunityOwner, ChannelPartner, CreatedDate, CreatedBy)
			SELECT System_TransactionKey, SubmissionDate, @Reseller, NewAccountType, TypeOfContract, RevenueFlag, @ProductName, CompanyName, BusinessRegNo, 
				   Promotion, MRCCurrency, MRC, QuantityPaidMonths, CCVCurrency, CCV, OrderCreatedDate, OpportunityStatus, @LastModifiedDate, StarhubServiceID, 
				   @OpportunityNo, OwnerDivision, CPQOpportunity, OrderAcceptanceDate, DateContractSigned, DateOrderSubmitted, CloseDate, PrimaryContact, ContactEmail, 
				   ContactOfficePhone, Contact1, Contact1Email, NewAccountDate, ExistingAccountDate, CRDate, OpportunityOwner, ChannelPartner, CreatedDate, CreatedBy
			FROM TXN_Starhub_CPQ
			WHERE Id = @Id

			DELETE 
			FROM TXN_Starhub_CPQ_ValidationResult 
			WHERE Processing_Ref_ID = @Id

			DELETE 
			FROM TXN_Starhub_CPQ 
			WHERE Id = @Id

			EXEC SP_SaveValidationResult @resultCode = @RCode OUTPUT, 
										 @resultMessage = @RMessage OUTPUT
			
		COMMIT

		SET @ResultCode = CASE WHEN @RCode = '0001' THEN 1
							   ELSE 2
						  END
	END TRY 
	BEGIN CATCH
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRAN
			SET @ResultCode = 3
		END
	END CATCH
	
	RETURN @ResultCode
END	
