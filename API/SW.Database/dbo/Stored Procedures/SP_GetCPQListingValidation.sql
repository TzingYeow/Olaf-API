CREATE PROCEDURE [dbo].[SP_GetCPQListingValidation]
	@statusValue INT,
	@submissionDate DATE NULL,			
	@opportunityNumber NVARCHAR(200) NULL
	
AS
BEGIN
	SELECT B.*,A.Id AS 'ProcessingId', A.OpportunityNo, A.ProductName, A.Reseller, A.OrderLastModifiedDate AS LastModifiedDate 
	FROM TXN_Starhub_CPQ AS A
	LEFT JOIN TXN_Starhub_CPQ_ValidationResult B ON A.Id = B.Processing_Ref_ID
	WHERE A.ResultStatus = @statusValue AND (@submissionDate IS NULL OR A.SubmissionDate = @submissionDate) AND (@opportunityNumber = '' OR A.OpportunityNo = @opportunityNumber)
END
