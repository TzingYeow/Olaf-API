CREATE PROCEDURE [dbo].[SP_Starhub_LeadsAssignment_Listing]
(
	@startDate DATETIME,
	@endDate DATETIME,
	@status INT,
	@locationTypeId INT
)
AS 
BEGIN
	SELECT leads.Id, leads.LocationType, location.CodeName as 'LocationTypeName', leads.AreaCode, leads.DistrictName, 
		   leads.SubDistrict, leads.StartDate, leads.EndDate, leads.Status, 
		   leads.McCodeId, CASE 
    WHEN leads.EndDate IS NULL THEN '1'
    WHEN leads.EndDate >=   CAST( GETDATE() AS Date ) THEN '1'
    WHEN leads.EndDate <   CAST( GETDATE() AS Date ) THEN '0'
	--WHEN EndDate IS NULL THEN '1'
    
  END As 'edit'
	FROM Leads_DistrictRequest_StarHub as leads
	Left JOIN (
		SELECT *
		FROM Mst_Mastercode 
		WHERE CodeType='StarhubLocationType' and isActive='1'
	) as location on leads.LocationTypeId = location.id
	
	WHERE leads.StartDate >= @startDate AND leads.StartDate <= @endDate AND (@status = -1 OR leads.Status = @status) AND (@locationTypeId = -1 OR leads.LocationTypeId = @locationTypeId);
	
END
