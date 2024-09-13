CREATE   PROCEDURE [dbo].[SP_Commercial_GetTransactionSearchByID_Starhub]
	@Case INT,
	@TxnID NVARCHAR(50)
AS
BEGIN

	--declare @case int = 2
	--declare @opportunityno nvarchar(30) = 'opp12345'
	--declare @serviceid nvarchar(50) = 'serv1234';

	IF @Case = 1
	BEGIN
		WITH LatestRemarks AS (
		    SELECT R.CaseID, R.Remarks AS RejectCasesRemarks
		    FROM TXN_Starhub_RejectCases_Remarks AS R
		    INNER JOIN (
		        SELECT CaseID, MAX(CreatedDate) AS LatestRemarkDate
		        FROM TXN_Starhub_RejectCases_Remarks
		        GROUP BY CaseID
		    ) AS LatestRemark ON R.CaseID = LatestRemark.CaseID AND R.CreatedDate = LatestRemark.LatestRemarkDate
		)
		SELECT A.TxnID ,A.OpportunityNo, B.ServiceID, B.CustType AS 'CustomerType', '' AS OrderType, B.ProductType AS 'Product', A.BadgeNo AS 'ResellerID', A.BAName, A.CompanyName, A.BRN, C.SalesworksStatus AS 'Status', D.RejectDate, D.EmailDate, D.EmailSubject, A.MOCode, D.Status AS 'CSStatus', E.RejectCasesRemarks AS 'Remarks', D.[Source], D.IssuesCategory, D.Id--, 
		FROM TXN_Starhub_Transaction AS A
		INNER JOIN TXN_Starhub_Transaction_Product AS B ON A.TxnID = B.TxnID
		INNER JOIN TXN_Starhub_Transaction_Status AS C ON A.TxnID = C.TxnID
		LEFT JOIN TXN_Starhub_RejectCases_Listing AS D ON A.OpportunityNo = D.OpportunityNo AND B.ServiceID = D.ServiceID --AND D.CaseType = @CaseType
		LEFT JOIN LatestRemarks AS E ON D.Id = E.CaseID
		WHERE A.TxnID = @TxnID
		--WHERE A.OpportunityNo = @OpportunityNo AND B.ServiceID = @ServiceID
	END
	ELSE IF @Case = 2
	BEGIN
		WITH LatestRemarks AS (
		    SELECT R.CaseID, R.Remarks AS RejectCasesRemarks
		    FROM TXN_Starhub_RejectCases_Remarks AS R
		    INNER JOIN (
		        SELECT CaseID, MAX(CreatedDate) AS LatestRemarkDate
		        FROM TXN_Starhub_RejectCases_Remarks
		        GROUP BY CaseID
		    ) AS LatestRemark ON R.CaseID = LatestRemark.CaseID AND R.CreatedDate = LatestRemark.LatestRemarkDate
		)
		SELECT A.Id, A.OpportunityNo, A.ServiceID, A.[Source], A.IssuesCategory, A.MOCode, A.BadgeNo AS BAName, A.Product, A.CompanyName, A.RejectDate, A.EmailDate, A.EmailSubject, A.[Status] AS 'CSStatus', B.RejectCasesRemarks AS 'Remarks' 
		FROM TXN_Starhub_RejectCases_Listing AS A
		LEFT JOIN LatestRemarks AS B ON A.Id = B.CaseID
		WHERE A.TxnID = @TxnID
		--WHERE A.OpportunityNo = @OpportunityNo AND A.ServiceID = @ServiceID
	END
	
END
