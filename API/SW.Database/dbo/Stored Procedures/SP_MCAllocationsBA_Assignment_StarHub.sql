CREATE PROCEDURE [dbo].[SP_MCAllocationsBA_Assignment_StarHub]
	--select * from Leads_DistrictRequest_StarHub
	@mocode nvarchar(100) null
AS
BEGIN

SET NOCOUNT ON;

SELECT  *, CASE 
    WHEN EndDate IS NULL THEN '1'
    WHEN EndDate >=   CAST( GETDATE() AS Date ) THEN '1'
    WHEN EndDate <   CAST( GETDATE() AS Date ) THEN '0'
	--WHEN EndDate IS NULL THEN '1'
    
  END As 'edit' FROM Leads_DistrictRequest_StarHub where Status != 0 and userMoCode = @mocode

END
