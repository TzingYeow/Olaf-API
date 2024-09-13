CREATE   PROCEDURE [dbo].[SP_Commercial_GetTransactionSearchListing_Starhub]
	@Searchby INT,
	@Keyword NVARCHAR(100)
AS
BEGIN
	--DECLARE @SearchBy INT = 0,
	--		@Keyword NVARCHAR(100) = 'OPP'

	CREATE TABLE #TempTXN (
		TxnID NVARCHAR(50),
		OpportunityNo NVARCHAR(100),
		CompanyName NVARCHAR(100),
		BRN NVARCHAR(100),
		CreatedDate DATE
	)

	IF @Searchby = 0
	BEGIN
		INSERT INTO #TempTXN
		SELECT TxnID, OpportunityNo, CompanyName, BRN, CreatedDate
		FROM TXN_Starhub_Transaction
		WHERE OpportunityNo LIKE '%' + @Keyword + '%'
	END
	ELSE
	BEGIN
		INSERT INTO #TempTXN
		SELECT TxnID, OpportunityNo, CompanyName, BRN, CreatedDate
		FROM TXN_Starhub_Transaction
	END

	SELECT A.TxnID, A.OpportunityNo, B.ServiceID, B.CustType AS 'CustomerType', B.ContractType, B.ProductType AS 'Product', C.SalesworksStatus AS 'Status', A.CompanyName, A.BRN
	FROM #TempTXN AS A
	INNER JOIN TXN_Starhub_Transaction_Product AS B ON A.TxnID = B.TxnID 
	INNER JOIN TXN_Starhub_Transaction_Status AS C ON A.TxnID = C.TxnID
	WHERE ((@Searchby = 0 AND A.OpportunityNo LIKE '%' + @Keyword + '%') OR
		   (@Searchby = 1 AND B.ServiceID LIKE '%' + @Keyword + '%'))
	ORDER BY A.CreatedDate
	--SELECT A.TxnID, A.OpportunityNo, B.ServiceID, B.CustType AS CustomerType, B.ContractType, B.ProductType AS Product, C.SalesworksStatus AS Status, A.CompanyName, A.BRN
	--FROM TXN_Starhub_Transaction AS A
	--INNER JOIN TXN_Starhub_Transaction_Product AS B ON A.TxnID = B.TxnID
	--INNER JOIN TXN_Starhub_Transaction_Status AS C ON A.TxnID = C.TxnID
	--WHERE
	--((@Searchby = 0 AND A.OpportunityNo LIKE '%' + @Keyword + '%')
 --      OR
 --      (@Searchby = 1 AND B.ServiceID LIKE '%' + @Keyword + '%'))
	--ORDER BY A.CreatedDate
END
