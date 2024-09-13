CREATE PROCEDURE [dbo].[SP_GetCPQListing]
	@statusValue INT,
	@submissionDate DATE NULL,			
	@opportunityNumber NVARCHAR(200) NULL
AS
BEGIN
	
	--declare @statusValue int = 1
	--declare @submissiondate date = NULL
	--declare @opportunitynumber nvarchar(200) = ''
	
	SELECT * 
	FROM TXN_Starhub_CPQ 
	WHERE ResultStatus = @statusValue AND (@submissionDate IS NULL OR SubmissionDate = @submissionDate) AND (@opportunityNumber = '' OR OpportunityNo = @opportunityNumber)
END
