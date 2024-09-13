CREATE PROCEDURE [dbo].[SP_Commercial_Get_Street_Name_StarHub]
	@AreaCode nvarchar(50)
AS
BEGIN
	SELECT StreetName,COUNT(DISTINCT BuildingNo) AS 'BuildingNumber',COUNT(DISTINCT Unit) AS 'Unit' 
	FROM Mst_InDistrictMaster_StarHub 
	WHERE AreaCode = @AreaCode
	GROUP BY StreetName;
END
