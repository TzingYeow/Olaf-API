CREATE PROCEDURE [dbo].[SP_Commercial_Starhub_GetTransactionDetailsListing]
	@Type INT,
	@Keyword NVARCHAR(50),
	@TableType NVARCHAR(20)
	
AS
BEGIN

	IF @TableType = 'Details'
	BEGIN
	
		SELECT * FROM TXN_Starhub_Transaction A
		INNER JOIN TXN_Starhub_Transaction_Product B ON A.TxnID = B.TxnID
		WHERE ((@Type = 0 AND A.OpportunityNo = @Keyword)
				OR
				(@Type = 1 AND B.ServiceID = @Keyword)
				OR
				(@Type = 2 AND A.CompanyName LIKE '%' + @Keyword + '%'))
		ORDER BY A.TxnID

	END
	ELSE IF @TableType = 'Product'
	BEGIN

		SELECT A.* FROM TXN_Starhub_Transaction_Product A
		INNER JOIN TXN_Starhub_Transaction B ON A.TxnID = B.TxnID
		WHERE ((@Type = 0 AND B.OpportunityNo = @Keyword)
				OR
				(@Type = 1 AND A.ServiceID = @Keyword)
				OR
				(@Type = 2 AND B.CompanyName LIKE '%' + @Keyword + '%'))
		ORDER BY A.TxnID

	END
	ELSE IF @TableType = 'Status' 
	BEGIN 
		
		SELECT A.* FROM TXN_Starhub_Transaction_Status A
		INNER JOIN TXN_Starhub_Transaction B ON A.TxnID = B.TxnID
		INNER JOIN TXN_Starhub_Transaction_Product C ON A.TxnID = C.TxnID
		WHERE ((@Type = 0 AND B.OpportunityNo = @Keyword)
				OR
				(@Type = 1 AND C.ServiceID = @Keyword)
				OR
				(@Type = 2 AND B.CompanyName LIKE '%' + @Keyword + '%'))
		ORDER BY A.TxnID

	END

END
