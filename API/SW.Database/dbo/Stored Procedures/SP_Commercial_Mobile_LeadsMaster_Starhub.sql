CREATE PROCEDURE [dbo].[SP_Commercial_Mobile_LeadsMaster_Starhub]
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
	--DECLARE @District NVARCHAR(10);
	--SET @UserName = 'SI00007';
	--SET @ChannelCode = 'b2b';
	--SET @District = '01';
	
	DECLARE @BAID INT
	SET @BAID = (SELECT IndependentContractorId From VW_MST_IC WHERE BadgeNo=@UserName AND IsActive=1);

	DECLARE @todayDate DATE
	SET @todayDate = GETDATE();

 	DECLARE @LocationTypeName NVARCHAR(100);
	SET @LocationTypeName = (SELECT TOP 1 CodeName FROM Mst_MasterCode WHERE CodeType='StarhubLocationType' AND IsActive=1 AND LOWER(CodeId) = @ChannelCode);

	IF (@ChannelCode='res' OR @ChannelCode = 'b2b')
		BEGIN
			SELECT A.BuildingNo, A.BuildingName, C.AreaCode, C.DistrictName, A.StreetName, A.PostCode, A.BuildingDesc,
				   B.Id as 'MCAssignmentId',  Count(A.Unit) as 'TotalUnit'
			FROM Leads_DistrictRequest_Assignments as A
			INNER JOIN Leads_DistrictRequest_MCAssign as B on A.MCAssign_Id = B.Id AND B.IsDeleted = 0
			INNER JOIN Leads_DistrictRequest_Starhub as C on C.Id = B.DistrictRequestId
			WHERE A.AssignedTo = @UserName and C.AreaCode = @District 
			AND A.IsDeleted = 0 AND 
				  --(C.LocationType != 'SalesWorks RS' AND C.LocationType != 'Client RS') AND
				   C.LocationType = @LocationTypeName AND
				  ((C.EndDate Is Null OR C.EndDate >= @todayDate) AND
				  (C.StartDate <= @todayDate AND C.TentativeEndDate >= @todayDate))
			GROUP BY A.BuildingNo, A.BuildingName, C.AreaCode, C.DistrictName, A.StreetName, A.PostCode, A.BuildingDesc, B.Id;
		END
	ELSE
		BEGIN

 

			SELECT A.BuildingNo, A.BuildingName, C.AreaCode, C.DistrictName, A.StreetName, A.PostCode, A.BuildingDesc,
				   B.Id as 'MCAssignmentId',  Count(A.Unit) as 'TotalUnit'
			FROM Leads_DistrictRequest_Assignments as A
			INNER JOIN Leads_DistrictRequest_MCAssign as B on A.MCAssign_Id = B.Id AND B.IsDeleted = 0
			INNER JOIN Leads_DistrictRequest_Starhub as C on C.Id = B.DistrictRequestId
			WHERE A.AssignedTo = @UserName and C.AreaCode = @District 
			AND A.IsDeleted= 0 AND
				  --(C.LocationType = 'SalesWorks RS' or C.LocationType = 'Client RS') AND
				  C.LocationType = @LocationTypeName AND
				   (C.StartDate <= @todayDate AND C.TentativeEndDate >= @todayDate)
			GROUP BY A.BuildingNo, A.BuildingName, C.AreaCode, C.DistrictName, A.StreetName, A.PostCode, A.BuildingDesc, B.Id;
		END
END
