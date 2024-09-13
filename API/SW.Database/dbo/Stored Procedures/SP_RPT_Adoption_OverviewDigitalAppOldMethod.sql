-- =============================================
-- Author:		Leonard Yong
-- Create date: 2020-08-15
-- Description:	Adoption Rate Report
-- =============================================
--EXEC SP_RPT_Adoption_OverviewDigitalAppOldMethod
CREATE PROCEDURE [dbo].[SP_RPT_Adoption_OverviewDigitalAppOldMethod] 
	 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT * FROM RPT_OverviewDigitalAppOldMethod WHERE YEAR(WEDate) = YEAR(Getdate())
END
