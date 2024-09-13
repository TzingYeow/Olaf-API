
CREATE PROCEDURE [dbo].[SP_Load_ExistingLocation_ForDistrict]
	@Id int,
	@MoCode nvarchar(10),
	@startDate DATE,
	@endDate DATE
AS
BEGIN
	SET NOCOUNT ON;

	SELECT Id , EndDate FROM Leads_DistrictRequest_StarHub 
	WHERE DistrictId = @Id and userMoCode = @MoCode AND (
			(StartDate <= @startDate AND TentativeEndDate >= @startDate) OR
			(StartDate <= @endDate AND TentativeEndDate >= @endDate)
		  )
	ORDER BY Id DESC;

END
