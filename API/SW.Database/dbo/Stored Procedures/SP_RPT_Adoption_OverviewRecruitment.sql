-- =============================================
-- Author:		Leonard Yong
-- Create date: 2020-08-15
-- Description:	Adoption Rate Report
-- =============================================
--EXEC SP_RPT_Adoption_OverviewRecruitment
CREATE PROCEDURE [dbo].[SP_RPT_Adoption_OverviewRecruitment] 
	 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT * FROM RPT_OverviewRecruitment WHERE YEAR(WEDate) = YEAR(Getdate())
END
