
CREATE PROCEDURE [dbo].[SP_GetCPQUploadValidationMessage_StarHUB]
@transKey nvarchar(200)
AS
BEGIN

SET NOCOUNT ON;

	SELECT TSC.OpportunityNo, TSC.ProductName, TSC.Reseller, TSC.OrderLastModifiedDate, TSCV.Result_Message 
	FROM TXN_Starhub_CPQ AS TSC 
	INNER JOIN TXN_Starhub_CPQ_ValidationResult AS TSCV ON TSC.Id = TSCV.Processing_Ref_ID
	WHERE TSC.System_TransactionKey = @transKey
END
