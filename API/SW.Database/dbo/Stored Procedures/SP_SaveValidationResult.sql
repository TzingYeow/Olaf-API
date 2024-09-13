CREATE   PROCEDURE [dbo].[SP_SaveValidationResult]
	--@Reseller NVARCHAR(100) NULL,
	--@NewAccountType NVARCHAR(100) NULL,
	--@TypeOfContract NVARCHAR(100) NULL,
	--@RevenueFlag INT NULL,
	--@ProductName NVARCHAR(100) NULL,
	--@CompanyName NVARCHAR(100) NULL,
	--@BusinessRegNo NVARCHAR(100) NULL,
	--@Promotion NVARCHAR(100) NULL,
	--@MRCCurrency NVARCHAR(100) NULL,
	--@MRC DECIMAL(18,4) NULL,
	--@QuantityPaidMonths INT NULL,
	--@CCVCurrency NVARCHAR(100) NULL,
	--@CCV DECIMAL(18,4) NULL,
	--@OrderCreatedDate DATE NULL,
	--@OpportunityStatus NVARCHAR(100) NULL,
	--@OrderLastModifiedDate date NULL,
	--@StarhubServiceID NVARCHAR(100) NULL,
	--@OpportunityNo NVARCHAR(100) NULL,
	--@OwnerDivision NVARCHAR(100) NULL,
	--@CPQOpportunity INT NULL,
	--@OrderAcceptanceDate DATE NULL,
	--@DateContractSigned DATE NULL,
	--@DateOrderSubmitted DATE NULL,
	--@CloseDate DATE NULL,
	--@PrimaryContact NVARCHAR(100) NULL,
	--@ContactEmail NVARCHAR(100) NULL,
	--@ContactOfficePhone NVARCHAR(100) NULL,
	--@Contact1 NVARCHAR(100) NULL,
	--@Contact1Email NVARCHAR(100) NULL,
	--@NewAccountDate NVARCHAR(100) NULL,
	--@ExistingAccountDate NVARCHAR(100) NULL,
	--@CRDate NVARCHAR(100) NULL,
	--@OpportunityOwner NVARCHAR(100) NULL,
	--@ChannelPartner NVARCHAR(100) NULL,
	--@CreatedBy NVARCHAR(100) NULL,
	--@CreatedDate DATETIME NULL,
	--@System_TransactionKey NVARCHAR(100) NULL,
	--@SubmissionDate DATE NULL,
	--@ResultStatus INT NULL,
	--@UploadResult NVARCHAR(10) OUTPUT,
	--@CPQOpportunityBlockCount INT OUTPUT
	@resultCode NVARCHAR(20) OUTPUT,
	@resultMessage NVARCHAR(100) OUTPUT
	
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Id INT;

	--Block Import Checking
	--Block if NewAccountType value is not 'Existing', 'New', null or empty
	DECLARE @isNewAccountTypeValid INT = (SELECT COUNT(*)
										  FROM TXN_Temp_Starhub_CPQ
										  WHERE NewAccountType NOT IN ('Existing','New') AND
												(TRIM(NewAccountType) <> '' AND TRIM(NewAccountType) IS NOT NULL))
	IF(@isNewAccountTypeValid > 0)
	BEGIN
		SET @resultCode = '0003';
		SET @resultMessage = 'Please Check "New Account Type" Column, The Value Is In Invalid Format!';

		DELETE FROM TXN_Temp_Starhub_CPQ;
			
		RETURN;
	END

	--Block if	TypeOfContract value is not 'Renewal', 'New'
	DECLARE @isTypeOfContractValid INT = (SELECT COUNT(*)
										  FROM TXN_Temp_Starhub_CPQ
										  WHERE TypeOfContract NOT IN ('Renewal','New'))
	IF(@isTypeOfContractValid > 0)
	BEGIN
		SET @resultCode = '0004';
		SET @resultMessage = 'Please Check "Type Of Contract" Column, The Value Is In Invalid Format!';

		DELETE FROM TXN_Temp_Starhub_CPQ;
			
		RETURN;
	END

	--Block if TypeOfContract value is not valid
	DECLARE @isOpportunityStatusValid INT = (SELECT COUNT(*)
										FROM TXN_Temp_Starhub_CPQ
										WHERE OpportunityStatus NOT IN  ('Credit Risk Check - Approved', 'Credit Risk Check - Pending', 'Credit Risk Check - Rejected',
																		 'Customer Approval - Approved', 'Customer Approval - Pending', 'Customer Approval - Rejected',
																		 'Lost Opportunity', 'Order Cancel', 'Order Closed', 'Order Processing', 'Order Submitted',
																		 'Order Exception', 'Pricing Review - Approved', 'Process Order', 'Process Order: Reply fr AE, Qualified'))
	IF(@isOpportunityStatusValid > 0)
	BEGIN
		SET @resultCode = '0005';
		SET @resultMessage = 'Please Check "Opportunity Status" Column, The Value Is In Invalid Format!';

		DELETE FROM TXN_Temp_Starhub_CPQ;
			
		RETURN;
	END

	--Block if CPQOpportunity value is not in 0 or 1
	DECLARE @isCPQOpportunityValid INT = (SELECT COUNT(*)
										  FROM TXN_Temp_Starhub_CPQ
										  WHERE CPQOpportunity NOT IN (0,1))
	IF(@isCPQOpportunityValid > 0)
	BEGIN
		SET @resultCode = '0006';
		SET @resultMessage = 'Please Check "CPQ Opportunity" Column, The Value Is In Invalid Format!';

		DELETE FROM TXN_Temp_Starhub_CPQ;
			
		RETURN;
	END

	--DECLARE @Id INT
	DECLARE @BadgeValueId NVARCHAR(100) = NULL,
			@transactionID NVARCHAR(50) = NULL,
			@codeValue NVARCHAR(50) = NULL,
			@BadgeNoValue NVARCHAR(50) = NULL,
			@banameValue NVARCHAR(50) = NULL,
			@productidValue INT = NULL,
			@baValue DECIMAL(18, 2) = NULL,
			@clientValue DECIMAL(18, 2) = NULL,
			@msfValue DECIMAL(18, 2) = NULL,
			@productRowId INT = NULL,
			@payoutID INT = 0;

	DECLARE @HQCode NVARCHAR(20) = 'HQ',
			@HQBadgeNo NVARCHAR(20),
			@HQBAName NVARCHAR(200),
			@CampaignName NVARCHAR(20) = 'SHB2BID',
			@CampaignID NVARCHAR(20);

	SELECT @HQBadgeNo = BadgeNo, 
		   @HQBAName = (ISNULL(FirstName, '') + ' ' + ISNULL(LastName, '')) 
	FROM VW_MST_IC 
	WHERE OfficeCode = @HQCode AND 
		  IsActive = 1;

	SELECT @CampaignID = Id 
	FROM VW_MSt_CampaignList 
	WHERE CampaignCode = @CampaignName;

	--DECLARE @Plan250M NVARCHAR(50) = '250 MBPS';
	--DECLARE @Plan350M NVARCHAR(50) = '350 MBPS';
	--DECLARE @Plan500M NVARCHAR(50) = '500 MBPS';
	--DECLARE @Plan750M NVARCHAR(50) = '750 MBPS';
	--DECLARE @Plan1GB NVARCHAR(50) = '1 GBPS';
	--DECLARE @M2M NVARCHAR(20) = 'M2M';
	--SET @Plan250M = '250 MBPS';
	--SET @Plan350M = '350 MBPS';
	--SET @Plan500M = '500 MBPS';
	--SET @Plan750M = '750 MBPS';
	--SET @Plan1GB = '1 GBPS';
	--SET @M2M = 'M2M';

	DECLARE @SubmissionStatus NVARCHAR(30) = 'PENDING',
			@RejectStatus NVARCHAR(30) = 'REJECT';

	DECLARE @Reseller NVARCHAR(100),
			@NewAccountType NVARCHAR(100),
			@TypeOfContract NVARCHAR(100),
			@RevenueFlag INT,
			@ProductName NVARCHAR(100),
			@CompanyName NVARCHAR(100),
			@BusinessRegNo NVARCHAR(100),
			@Promotion NVARCHAR(100),
			@MRCCurrency NVARCHAR(100),
			@MRC DECIMAL(18,4),
			@QuantityPaidMonths INT,
			@CCVCurrency NVARCHAR(100),
			@CCV DECIMAL(18,4),
			@OrderCreatedDate DATE,
			@OpportunityStatus NVARCHAR(100),
			@OrderLastModifiedDate DATE,
			@StarhubServiceID NVARCHAR(100),
			@OpportunityNo NVARCHAR(100),
			@OwnerDivision NVARCHAR(100),
			@CPQOpportunity INT,
			@OrderAcceptanceDate DATE,
			@DateContractSigned DATE,
			@DateOrderSubmitted DATE,
			@CloseDate DATE,
			@PrimaryContact NVARCHAR(100),
			@ContactEmail NVARCHAR(100),
			@ContactOfficePhone NVARCHAR(100),
			@Contact1 NVARCHAR(100),
			@Contact1Email NVARCHAR(100),
			@NewAccountDate NVARCHAR(100),
			@ExistingAccountDate NVARCHAR(100),
			@CRDate NVARCHAR(100),
			@OpportunityOwner NVARCHAR(100),
			@ChannelPartner NVARCHAR(100),
			@CreatedBy NVARCHAR(100),
			@CreatedDate DATETIME,
			@System_TransactionKey NVARCHAR(100),
			@SubmissionDate DATE,
			@ResultStatus INT;

	DECLARE Update_CPQ_Trans CURSOR FOR
	SELECT Id, System_TransactionKey, SubmissionDate, Reseller, NewAccountType, TypeOfContract, RevenueFlag, ProductName, CompanyName, BusinessRegNo, 
		   Promotion, MRCCurrency, MRC, QuantityPaidMonths, CCVCurrency, CCV, OrderCreatedDate, OpportunityStatus, OrderLastModifiedDate, StarhubServiceID, 
		   OpportunityNo, OwnerDivision, CPQOpportunity, OrderAcceptanceDate, DateContractSigned, DateOrderSubmitted, CloseDate, PrimaryContact, ContactEmail, 
		   ContactOfficePhone, Contact1, Contact1Email, NewAccountDate, ExistingAccountDate, CRDate, OpportunityOwner, ChannelPartner, CreatedDate, CreatedBy
	FROM TXN_Temp_Starhub_CPQ

	OPEN Update_CPQ_Trans;
	FETCH NEXT FROM Update_CPQ_Trans INTO @Id, @System_TransactionKey, @SubmissionDate, @Reseller, @NewAccountType, @TypeOfContract, @RevenueFlag, @ProductName, @CompanyName, @BusinessRegNo, 
										  @Promotion, @MRCCurrency, @MRC, @QuantityPaidMonths, @CCVCurrency, @CCV, @OrderCreatedDate, @OpportunityStatus, @OrderLastModifiedDate, @StarhubServiceID, 
										  @OpportunityNo, @OwnerDivision, @CPQOpportunity, @OrderAcceptanceDate, @DateContractSigned, @DateOrderSubmitted, @CloseDate, @PrimaryContact, @ContactEmail, 
										  @ContactOfficePhone, @Contact1, @Contact1Email, @NewAccountDate, @ExistingAccountDate, @CRDate, @OpportunityOwner, @ChannelPartner, @CreatedDate, @CreatedBy
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DROP TABLE IF EXISTS #ErrorValidation;
		CREATE TABLE #ErrorValidation
		(
			ResultCode NVARCHAR(30),
			ResultMessage NVARCHAR(100)
		)

		/**** FRONT END DID NOT HANDLE DATE NULL, NEED TO HANDLE HERE ****/
		IF (@OrderCreatedDate = '1900-01-01')
		BEGIN 
			SET @OrderCreatedDate = NULL
		END

		IF (@OrderLastModifiedDate = '1900-01-01')
		BEGIN 
			SET @OrderLastModifiedDate = NULL
		END

		IF (@OrderAcceptanceDate = '1900-01-01')
		BEGIN 
			SET @OrderAcceptanceDate = NULL
		END

		IF (@DateContractSigned = '1900-01-01')
		BEGIN 
			SET @DateContractSigned = NULL
		END

		IF (@DateOrderSubmitted = '1900-01-01')
		BEGIN 
			SET @DateOrderSubmitted = NULL
		END

		IF (@CloseDate = '1900-01-01')
		BEGIN 
			SET @CloseDate = NULL
		END
		
		/**** SET DEFAULT VALUE IF ANY OF THIS IS NULL OR EMPTY ****/
		IF (TRIM(@NewAccountType) = '' OR @NewAccountType IS NULL)
		BEGIN
			SET @NewAccountType = 'NEW';
		END

		IF (TRIM(@ChannelPartner) = '' OR @ChannelPartner IS NULL)
		BEGIN
			SET @ChannelPartner = 'CP:Salesworks';
		END

		/**** VALIDATION ****/
		IF NOT EXISTS (SELECT * 
					   FROM TXN_Starhub_CPQ  
					   WHERE OpportunityNo = @OpportunityNo AND 
							 StarhubServiceID = @StarhubServiceID AND 
							 @StarhubServiceID <> '' AND
							 ProductName = @ProductName) 
					  AND @CPQOpportunity = '1'
		BEGIN
			SET @Id = 0;

			INSERT INTO TXN_Starhub_CPQ (System_TransactionKey, SubmissionDate, Reseller, NewAccountType, TypeOfContract, RevenueFlag, ProductName, CompanyName, BusinessRegNo, Promotion, MRCCurrency, 
										 MRC, QuantityPaidMonths, CCVCurrency, CCV, OrderCreatedDate, OpportunityStatus, OrderLastModifiedDate, StarhubServiceID, OpportunityNo, OwnerDivision, 
										 CPQOpportunity, OrderAcceptanceDate, DateContractSigned, DateOrderSubmitted, CloseDate, PrimaryContact, ContactEmail, ContactOfficePhone, Contact1, 
										 Contact1Email, NewAccountDate, ExistingAccountDate, CRDate, OpportunityOwner, ChannelPartner, ResultStatus, CreatedDate, CreatedBy, IsTxnUpdated) 
			VALUES (@System_TransactionKey, @SubmissionDate, @Reseller, @NewAccountType, @TypeOfContract, @RevenueFlag, @ProductName, @CompanyName, @BusinessRegNo, @Promotion, @MRCCurrency, 
					@MRC, @QuantityPaidMonths, @CCVCurrency, @CCV, @OrderCreatedDate, @OpportunityStatus, @OrderLastModifiedDate, @StarhubServiceID, @OpportunityNo, @OwnerDivision, 
					@CPQOpportunity, @OrderAcceptanceDate, @DateContractSigned, @DateOrderSubmitted, @CloseDate, @PrimaryContact, @ContactEmail, @ContactOfficePhone, @Contact1, 
					@Contact1Email, @NewAccountDate, @ExistingAccountDate, @CRDate, @OpportunityOwner, @ChannelPartner, 1, @CreatedDate, @CreatedBy, 0);

			SET @Id = SCOPE_IDENTITY()

			IF (@OpportunityNo IS NULL OR LTRIM(RTRIM(@OpportunityNo)) = '')
			BEGIN
				INSERT INTO #ErrorValidation(ResultCode, ResultMessage)
				SELECT 'CPQUPLOAD-0008', Message_Description 
				FROM Mst_SystemMessage 
				WHERE Message_Code = 'CPQUPLOAD-0008' AND 
					  IsActive='1'
			END
			ELSE IF (@OrderLastModifiedDate IS NULL OR LTRIM(RTRIM(@OrderLastModifiedDate)) = '')
			BEGIN
				INSERT INTO #ErrorValidation(ResultCode, ResultMessage)
				SELECT 'CPQUPLOAD-0009', Message_Description 
				FROM Mst_SystemMessage 
				WHERE Message_Code = 'CPQUPLOAD-0009' AND 
					  IsActive='1'
			END
			ELSE IF (@ProductName IS NULL OR  LTRIM(RTRIM(@ProductName)) = '' )
			BEGIN
				INSERT INTO #ErrorValidation(ResultCode, ResultMessage)
				SELECT 'CPQUPLOAD-0002', Message_Description 
				FROM Mst_SystemMessage 
				WHERE Message_Code = 'CPQUPLOAD-0002' AND 
					  IsActive='1'
			END
			ELSE
			BEGIN	
				DECLARE @IsProductExists INT = (SELECT COUNT(*)
												FROM Mst_Payout_Starhub AS A
												INNER JOIN (
													SELECT P.*
													FROM Mst_Starhub_CPQProductPlan_Mapping AS M
													INNER JOIN Mst_Product_Starhub AS P ON P.ProductType = M.ProductType
													WHERE M.ProductName = @ProductName
												) AS B ON B.Id = A.ProductId 
												WHERE (A.StartDate <= @DateContractSigned AND A.EndDate >= @DateContractSigned) AND
													  A.CustomerType = UPPER(@NewAccountType) AND 
													  A.OrderType = UPPER(@TypeOfContract));

				IF (@IsProductExists <= 0)
				BEGIN
					INSERT INTO #ErrorValidation(ResultCode, ResultMessage)
					SELECT 'CPQUPLOAD-0003', Message_Description 
					FROM Mst_SystemMessage 
					WHERE Message_Code = 'CPQUPLOAD-0003' AND 
						  IsActive='1'
				END
			END

			IF (SELECT COUNT(*) FROM #ErrorValidation) > 0
			BEGIN
				INSERT INTO TXN_Starhub_CPQ_ValidationResult (Processing_Ref_ID, Result_Code, Result_Message, CreatedDate, CreatedBy)
				SELECT @Id, ResultCode, ResultMessage, @CreatedDate, @CreatedBy 
				FROM #ErrorValidation;
	
				UPDATE TXN_Starhub_CPQ 
				SET ResultStatus = 2 
				WHERE Id = @Id
			END

			IF (@Id > 0)
			BEGIN
				IF EXISTS(SELECT * 
						  FROM TXN_Starhub_CPQ 
						  WHERE Id = @Id AND 
								ResultStatus = 1 AND 
								IsTxnUpdated = 0)
				BEGIN
					DECLARE @RejectCode NVARCHAR(50) = '',
							@RejectReason NVARCHAR(150) = '',
							@IsRejected INT = 0;

					DECLARE @PayoutName NVARCHAR(200) = '',
							@ProductPlan NVARCHAR(200) = '',
							@PayoutType NVARCHAR(30) = '',
							@TotalPayoutBA DECIMAL(18, 4) = 0,
							@CommissionReceivable DECIMAL(18, 4) = 0;
 
					IF (@Reseller IS NOT NULL AND  LTRIM(RTRIM(@Reseller)) <> '' )
					BEGIN
						IF LEN(REPLACE(@Reseller, ' ', '')) <> 17 AND @CPQOpportunity = 1 
						BEGIN
							SET @BadgeValueId = @HQBadgeNo;

							SET @IsRejected = 1;
							SELECT TOP (1) @RejectCode = Code, 
										   @RejectReason = [Description]
							FROM Mst_Reject_Starhub
							WHERE [Description] = 'INCORRECT FORMAT FOR RESELLER FIELD IN CPQ'
						END
						ELSE
						BEGIN
							DECLARE @splitBAID NVARCHAR(10) = LEFT(@Reseller, CHARINDEX('-', @Reseller) -1);

							IF LEN(@splitBAID) <> 7 AND @CPQOpportunity = 1
							BEGIN
								SET @BadgeValueId = @HQBadgeNo;

								SET @IsRejected = 1;
								SELECT TOP (1) @RejectCode = Code, 
											   @RejectReason = [Description]
								FROM Mst_Reject_Starhub
								WHERE [Description] = 'INVALID BA ID'
							END
							ELSE
							BEGIN
								SET @BadgeValueId = @splitBAID;
							END
						END
					END
					ELSE
					BEGIN
						SET @BadgeValueId = @HQBadgeNo;

						SET @IsRejected = 1;
						SELECT TOP (1) @RejectCode = Code, @RejectReason = [Description]
						FROM Mst_Reject_Starhub
						WHERE [Description] = 'INCORRECT FORMAT FOR RESELLER FIELD IN CPQ'
					END

					--declare @codevalue nvarchar(100),
					--		@badgenovalue nvarchar(100),
					--		@banamevalue nvarchar(100),
					--		@badgevalueid nvarchar(100) = 'hq0001'

					--SET @codeValue =(SELECT TOP (1) A.Code 
					--				 FROM NewOlaf_Prod..Mst_MarketingCompany AS A
					--				 INNER JOIN NewOlaf_Prod..Mst_IndependentContractor B ON A.MarketingCompanyId = B.MarketingCompanyId
					--				 WHERE B.BadgeNo= @BadgeValueId	)

					--SELECT TOP (1) @BadgeNoValue = BadgeNo, @banameValue = ISNULL(NULLIF(FirstName + ' ',''),'')+' '+ ISNULL(NULLIF(MiddleName + ' ',''),'') + ISNULL(NULLIF(LastName + ' ',''),'') 
					--FROM NewOlaf_Prod..Mst_IndependentContractor 
					--WHERE BadgeNo = @BadgeValueId;

					--select @codeValue, @BadgeNoValue, @banameValue
					SELECT TOP (1) @BadgeNoValue = A.BadgeNo, 
								   @banameValue = ISNULL(NULLIF(A.FirstName + ' ',''),'')+' '+ ISNULL(NULLIF(A.MiddleName + ' ',''),'') + ISNULL(NULLIF(A.LastName + ' ',''),''), 
								   @codeValue = B.Code
					FROM NewOlaf_Prod..Mst_IndependentContractor  AS A
					LEFT JOIN NewOlaf_Prod..Mst_MarketingCompany AS B ON A.MarketingCompanyId = B.MarketingCompanyId
					WHERE BadgeNo = @BadgeValueId;

					IF (@BadgeNoValue IS NULL OR LEN(@BadgeNoValue) = 0)
					BEGIN
						SET @BadgeNoValue = @HQBadgeNo;
						SET @banameValue = @HQBAName;
						SET @codeValue = @HQCode;

						SET @IsRejected = 1;
						SELECT TOP (1) @RejectCode = Code, @RejectReason = [Description]
						FROM Mst_Reject_Starhub
						WHERE [Description] = 'MISSING BA ID'
					END

					IF (@TypeOfContract = 'Renewal' AND @ChannelPartner <> 'CP:Salesworks')
					BEGIN
						SET @IsRejected = 1;
						SELECT TOP (1) @RejectCode = Code, @RejectReason = [Description]
						FROM Mst_Reject_Starhub
						WHERE [Description] = 'RECON OTHER CHANNEL PARTNER SALES'
					END

					SELECT @payoutID = A.RowID,
						   @baValue = A.BA,
						   @clientValue = A.Client,
						   @msfValue = A.MSF,
						   @PayoutName = B.ProductType,
						   @ProductPlan =  B.[Plan],
						   @PayoutType = A.PayoutType
					FROM Mst_Payout_Starhub AS A
					INNER JOIN (
						SELECT P.*, M.[Plan]
						FROM Mst_Starhub_CPQProductPlan_Mapping AS M
						INNER JOIN Mst_Product_Starhub AS P ON P.ProductType = M.ProductType
						WHERE M.ProductName = @ProductName
					) AS B ON B.Id = A.ProductId 
					WHERE (A.StartDate <= @DateContractSigned AND A.EndDate >= @DateContractSigned) AND
						  A.CustomerType = UPPER(@NewAccountType) AND 
						  A.OrderType = UPPER(@TypeOfContract);

					/*------ Calculate Payout Value ----*/
					IF (@PayoutType = 'PERCENTAGE')
					BEGIN
						SET @TotalPayoutBA = (@CCV * (@baValue / 100));
					END
					ELSE
					BEGIN
						SET @TotalPayoutBA = @baValue;
					END

					SET @CommissionReceivable = (@CCV * (@clientValue / 100));
					SET @transactionID = UPPER((REPLACE(@Reseller, ' - ', '')) + 'SH' +  format(@SubmissionDate,'yyyyMMddHHmmssffff') + LEFT(CAST(RAND()*1000000000 AS INT),6));

					/*-------- TRANSACTION ---------*/
					INSERT INTO TXN_Starhub_Transaction(TxnID, SignUpDate, OpportunityNo, CampaignCode, MOCode, BadgeNo, BAName, Reseller, CompanyName, BRN,
													   CreatedDate, CreatedBy) 
					VALUES(@transactionID, @OrderCreatedDate, @OpportunityNo, @CampaignID, @codeValue, @BadgeNoValue, @banameValue, @Reseller, @CompanyName, @BusinessRegNo,
						   @CreatedDate,@CreatedBy)

					/*-------- PRODUCT  ---------*/
					INSERT INTO TXN_Starhub_Transaction_Product(TxnID, CustType, ContractType, ProductType, ServiceID, 
																Payout_ID, Payout_BA, Payout_Client, Payout_MSF, TCV, 
																PaidMonths, CreatedDate,CreatedBy, Payout_Name, ProductPlan, 
																PayoutType, Total_Payout_BA, CommissionReceivable) 
					VALUES(@transactionID, @NewAccountType, @TypeOfContract, @ProductName, @StarhubServiceID, 
						   @payoutID, @baValue, @clientValue, @msfValue, @CCV, 
						   @QuantityPaidMonths, @CreatedDate, @CreatedBy, @PayoutName, @ProductPlan, 
						   @PayoutType, @TotalPayoutBA, @CommissionReceivable);

					/*-------- STATUS ----------*/
					IF (@IsRejected = 1)
					BEGIN
						INSERT INTO TXN_Starhub_Transaction_Status(TxnID, SalesworksStatus, SubmissionDate, SubmissionWEDate, CreatedDate, CreatedBy) 
						VALUES(@transactionID, @SubmissionStatus, @SubmissionDate, dbo.WeekedingDate(@SubmissionDate), @CreatedDate, @CreatedBy);

						EXEC SP_Commercial_ArchivedTransaction_Starhub @transactionID, 'Reject Through CPQ Upload', @CreatedBy

						UPDATE TXN_Starhub_Transaction_Status
						SET SalesworksStatus = @RejectStatus, 
							RejectDate = @SubmissionDate, 
							RejectWEDate = dbo.WeekedingDate(@SubmissionDate), 
							RejectReason = @RejectReason, 
							RejectCode = @RejectCode,
							UpdatedDate = CAST(GETDATE() AS DATE), 
							UpdatedBy = @CreatedBy
						WHERE TxnID = @transactionID

						INSERT INTO TXN_Starhub_RejectCases_Listing (CaseType, TxnID, OpportunityNo, ServiceID, RejectDate, RejectWEDate, EmailDate, EmailSubject, [Source], MOCode, BadgeNo, IssuesCategory, [Status], Product, CompanyName, CreatedDate, CreatedBy)
						VALUES (1, @transactionID, @OpportunityNo, @StarhubServiceID, @SubmissionDate, dbo.WeekedingDate(@SubmissionDate), NULL, NULL, NULL, @codeValue, @BadgeNoValue, NULL, NULL, @ProductName, @CompanyName, @CreatedDate, @CreatedBy)

						DECLARE @CaseID INT = SCOPE_IDENTITY()

						INSERT INTO TXN_Starhub_RejectCases_Reasons (CaseID, RejectCodeId, RejectReason, CreatedDate, CreatedBy)
						VALUES (@CaseID, (SELECT Id 
										  FROM Mst_Reject_Starhub 
										  WHERE Code = @RejectCode), 
								@RejectReason, @CreatedDate, @CreatedBy)

						INSERT INTO TXN_Starhub_RejectCases_Remarks (CaseID, Remarks, CreatedDate, CreatedBy)
						VALUES (@CaseID, 'Reject Through CPQ Upload', @CreatedDate, @CreatedBy)
					END
					ELSE
					BEGIN
						INSERT INTO TXN_Starhub_Transaction_Status(TxnID, SalesworksStatus, SubmissionDate, SubmissionWEDate, CreatedDate,CreatedBy)
						VALUES(@transactionID, @SubmissionStatus, @SubmissionDate, dbo.WeekedingDate(@SubmissionDate), @CreatedDate, @CreatedBy);
					END

					UPDATE TXN_Starhub_CPQ SET IsTxnUpdated = 1 WHERE Id = @Id
				END
			END
		END

		/** FETCH NEXT ****/
		FETCH NEXT FROM Update_CPQ_Trans INTO @Id, @System_TransactionKey, @SubmissionDate, @Reseller, @NewAccountType, @TypeOfContract, @RevenueFlag, @ProductName, @CompanyName, @BusinessRegNo, 
											  @Promotion, @MRCCurrency, @MRC, @QuantityPaidMonths, @CCVCurrency, @CCV, @OrderCreatedDate, @OpportunityStatus, @OrderLastModifiedDate, @StarhubServiceID, 
											  @OpportunityNo, @OwnerDivision, @CPQOpportunity, @OrderAcceptanceDate, @DateContractSigned, @DateOrderSubmitted, @CloseDate, @PrimaryContact, @ContactEmail, 
											  @ContactOfficePhone, @Contact1, @Contact1Email, @NewAccountDate, @ExistingAccountDate, @CRDate, @OpportunityOwner, @ChannelPartner, @CreatedDate, @CreatedBy
	END

	CLOSE Update_CPQ_Trans;
	DEALLOCATE Update_CPQ_Trans;

	SELECT @Id = COUNT(*)
	FROM TXN_Starhub_CPQ 
	WHERE System_TransactionKey = @System_TransactionKey

	DECLARE @CPQBlockCount INT = (SELECT COUNT(*) 
								  FROM TXN_Temp_Starhub_CPQ 
								  WHERE System_TransactionKey = @System_TransactionKey AND 
										CPQOpportunity = 0)

	IF (@Id > 0)
	BEGIN
		SET @resultCode = '0001'
		SET @resultMessage = 'Validation based on CPQ Opportunity: Offline sales are not imported into system, total ' + CAST(@CPQBlockCount AS NVARCHAR(20)) + ' records!'
	END
	ELSE 
	BEGIN
		SET @resultMessage = '0002'
		SET @resultMessage = 'Something went wrong, Please contact IT!'
	END

	DELETE FROM TXN_Temp_Starhub_CPQ;
END
