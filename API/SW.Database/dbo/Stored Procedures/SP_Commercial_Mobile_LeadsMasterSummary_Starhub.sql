CREATE PROCEDURE [dbo].[SP_Commercial_Mobile_LeadsMasterSummary_Starhub]
(
	@UserName NVARCHAR(20),
	@ChannelCode NVARCHAR(10),
	@District NVARCHAR(50)
)
AS 
BEGIN
	SET NOCOUNT ON;

	--DECLARE @UserName NVARCHAR(20);
	--DECLARE @ChannelCode NVARCHAR(10);
	--DECLARE @District NVARCHAR(50);
	--SET @UserName = 'SI00007';
	--SET @ChannelCode = 'b2b';
	--SET @District = '03';

	DECLARE @BAID INT
	SET @BAID = (SELECT IndependentContractorId From VW_MST_IC WHERE BadgeNo=@UserName AND IsActive=1);

	DECLARE @todayDate DATE
	SET @todayDate = GETDATE();

	DROP TABLE IF EXISTS #AssignList
	DROP TABLE IF EXISTS #CountList
	DROP TABLE IF EXISTS #AssignList1
	DROP TABLE IF EXISTS #CountList1

	DECLARE @LocationTypeName NVARCHAR(100);
	SET @LocationTypeName = (SELECT TOP 1 CodeName FROM Mst_MasterCode WHERE CodeType='StarhubLocationType' AND IsActive=1 AND LOWER(CodeId) = @ChannelCode);

	IF (@ChannelCode ='res' OR @ChannelCode = 'b2b')
		BEGIN

			/*--- Get the Assigned List ---*/
			SELECT C.Id, A.Unit, A.[Floor], C.AreaCode, C.DistrictName, A.PostCode, A.StreetName, A.BuildingNo, A.BuildingName
			INTO #AssignList
			FROM Leads_DistrictRequest_Assignments as A
			INNER JOIN Leads_DistrictRequest_MCAssign as B on B.Id = A.MCAssign_Id AND B.IsDeleted = 0
			INNER JOIN Leads_DistrictRequest_Starhub as C on C.Id = B.DistrictRequestId
			WHERE A.AssignedTo = @UserName and C.AreaCode = @District AND A.IsDeleted = 0 AND
				 C.LocationType = @LocationTypeName AND
				 (C.LocationType != 'SalesWorks RS' AND c.LocationType != 'Client RS') AND
				 ((C.EndDate Is Null OR C.EndDate >= @todayDate) AND
				 (C.StartDate <= @todayDate AND C.TentativeEndDate >= @todayDate));

			SELECT R.Id, R.DistrictName, R.StreetName, R.PostCode, 0 as 'total_donotknock', Count(R.BuildingNo) as 'TotalBuilding', Count(R.Unit) as 'TotalUnit'
			FROM #AssignList AS R
			GROUP BY R.Id, R.DistrictName, R.StreetName, R.PostCode
		END
	ELSE
		BEGIN
			/*--- Get the Assigned List ---*/
			SELECT C.Id, A.Unit, A.[Floor], C.AreaCode, C.DistrictName, A.PostCode, A.StreetName, A.BuildingNo, A.BuildingName
			INTO #AssignList1
			FROM Leads_DistrictRequest_Assignments as A
			INNER JOIN Leads_DistrictRequest_MCAssign as B on B.Id = A.MCAssign_Id AND B.IsDeleted = 0
			INNER JOIN Leads_DistrictRequest_Starhub as C on C.Id = B.DistrictRequestId
			WHERE A.AssignedTo = @UserName and C.AreaCode = @District AND A.IsDeleted = 0 AND
				  (C.LocationType = 'SalesWorks RS' OR c.LocationType = 'Client RS') AND
				  (C.StartDate <= @todayDate AND C.TentativeEndDate >= @todayDate);

			SELECT R.Id, R.DistrictName, R.StreetName, R.PostCode, 0 as 'total_donotknock', Count(R.BuildingNo) as 'TotalBuilding', Count(R.Unit) as 'TotalUnit'
			FROM #AssignList1 AS R
			GROUP BY R.Id, R.DistrictName, R.StreetName, R.PostCode
		END
END
