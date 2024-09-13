
CREATE FUNCTION [dbo].[GetWeekendingDate]
(
	@SubDate datetime
	
)
RETURNS Date
BEGIN
	Declare @WEDate date, @dayName nvarchar(50);

	SET @WEDate = (SELECT TOP 1 WEdate FROM Mst_Weekending where  FromDate <= @SubDate and ToDate >=@SubDate)
	RETURN @WEDate
END
