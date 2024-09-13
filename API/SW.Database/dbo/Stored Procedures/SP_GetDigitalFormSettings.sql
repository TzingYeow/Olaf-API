-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetDigitalFormSettings]
	-- Add the parameters for the stored procedure here
	@MarketingCompanyId int,
	@Createdby nvarchar(100) = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.[dbo].[Mst_IndependentContractor]
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT TOP 1 * FROM Mst_DigitalFormSettings WHERE MarketingCompanyId = @MarketingCompanyId)
	BEGIN
		SELECT a.* FROM Mst_DigitalFormSettings a
		WHERE a.MarketingCompanyId = @MarketingCompanyId order by a.CreatedDate desc
	END
	ELSE
	BEGIN
		INSERT INTO Mst_DigitalFormSettings (MarketingCompanyId,CreatedBy,CreatedDate)
		VALUES (@MarketingCompanyId,@Createdby,GETDATE())

		SELECT a.* FROM Mst_DigitalFormSettings a
		WHERE a.MarketingCompanyId = @MarketingCompanyId order by a.CreatedDate desc
	END
END	
