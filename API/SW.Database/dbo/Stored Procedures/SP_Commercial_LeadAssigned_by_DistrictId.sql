CREATE PROCEDURE [dbo].[SP_Commercial_LeadAssigned_by_DistrictId]
(
	@id int,
	@userMOCode nvarchar(50) 
)
AS 
BEGIN
	SELECT DistrictList.Id, DistrictList.DistrictName, DistrictList.LocationType , McAssign.StartDate, McAssign.Id AS 'McAssignId', DistrictList.AreaCode
	FROM Leads_DistrictRequest_StarHub AS DistrictList
	LEFT JOIN Leads_DistrictRequest_MCAssign AS McAssign ON  McAssign.DistrictRequestId = DistrictList.Id AND McAssign.MOCode = DistrictList.userMoCode
	WHERE DistrictList.Id = @id AND DistrictList.userMoCode= @userMOCode  
END
