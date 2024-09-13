-- =============================================
-- Author:		Leonard Yong
-- Create date: 2020-08-15
-- Description:	Adoption Rate Report
-- =============================================
--EXEC SP_RPT_Adoption_OverviewRecruitmentQuater
CREATE PROCEDURE [dbo].[SP_RPT_Adoption_OverviewDigitalAppOldQuater]
	 
AS
BEGIN

	CREATE TABLE #TempRaw (
		WEOrder int,
		WEDate NVARCHAR(20),
		AvgMCACtive INT,
		AvgMC int,
		Perc decimal(18,2)
	)

	INSERT INTO #TempRaw 
	SELECT DATEPART(QUARTER, WeDate) as 'WeDate', 'Q' + CAST(DATEPART(QUARTER, WeDate) as nvarchar) + ' ' +  CAST(YEAR(WEdate) as nvarchar) as 'Desc' , SUM(TotalJotForm) / COUNT(*) as 'AvgMCActive', SUM(TotalMC) / COUNT(*)  as 'AvgMc',0
	 FROM RPT_OverviewDigitalAppOldMethod WHERE YEAR(WeDate) = YEAR(GETDATE())
	 GROUP BY DATEPART(QUARTER, WeDate),YEAR(WEdate)
	 ORDER BY  DATEPART(QUARTER, WeDate)

	UPDATE #TempRaw SET Perc = CAST(CAST(AvgMCACtive as decimal(18,2)) / CAST(AvgMC as decimal(18,2)) as decimal(18,2)) where AvgMC <> 0


	SELECT * FROM #TempRaw 
	order by WEOrder

END
