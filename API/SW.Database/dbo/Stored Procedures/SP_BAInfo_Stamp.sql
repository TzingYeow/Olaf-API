-- SP_BAInfo_Stamp '2024-05-19','system'
CREATE PROCEDURE SP_BAInfo_Stamp

@WeekendingDate date null,
@CreatedBy nvarchar(100)


as


SELECT @WeekendingDate=WEdate FROM Mst_Weekending
WHERE @WeekendingDate BETWEEN FromDate AND ToDate

DELETE [Mst_IndependentContractor_BAInfo_Weekending]
where [WeekendingDate] = @WeekendingDate

INSERT INTO [Mst_IndependentContractor_BAInfo_Weekending]

( 	[IndependentContractorId],[WeekendingDate],[MarketingCompanyId],
	[IndependentContractorLevelId] ,[BAType],
	[ReportBadgeNo],[Status],
	[IsSuspended],
	[IsDeleted],
	[CreatedBy] ,
	[CreatedDate])

SELECT [IndependentContractorId],@WeekendingDate,[MarketingCompanyId],
	[IndependentContractorLevelId] ,[BAType],
	[ReportBadgeNo],[Status],
	[IsSuspended],0,@CreatedBy,GETDATE()
FROM [Mst_IndependentContractor]
WHERE ISDELETED= 0

 