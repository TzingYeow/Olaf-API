CREATE PROCEDURE [dbo].[SP_Commercial_GetRejectReasonById_Starhub]
	--@CaseType INT,
	--@OpportunityNo NVARCHAR(30),
	--@ServiceID NVARCHAR(50)
	@TxnID NVARCHAR(50)
AS
BEGIN
	
	--declare @casetype int = 2
	--declare @opportunityno nvarchar(30) = 'opp12345'
	--declare @serviceid nvarchar(50) = 'serv1234';
	
	SELECT B.RejectReason, B.CreatedDate, B.CreatedBy 
	FROM TXN_Starhub_RejectCases_Listing AS A
	LEFT JOIN TXN_Starhub_RejectCases_Reasons AS B ON A.Id = B.CaseID
	WHERE A.TxnID = @TxnID
	--WHERE A.OpportunityNo = @OpportunityNo AND A.ServiceID = @ServiceID

	--SELECT D.RejectReason, D.CreatedDate, D.CreatedBy
	--FROM TXN_Starhub_Transaction AS A
	--INNER JOIN TXN_Starhub_Transaction_Product AS B ON A.TxnID = B.TxnID
	--LEFT JOIN TXN_Starhub_RejectCases_Listing AS C ON A.OpportunityNo = C.OpportunityNo AND B.ServiceID = C.ServiceID --AND C.CaseType = @CaseType
	--LEFT JOIN TXN_Starhub_RejectCases_Reasons AS D ON C.Id = D.CaseID
	--WHERE A.OpportunityNo = @OpportunityNo AND B.ServiceID = @ServiceID

END
