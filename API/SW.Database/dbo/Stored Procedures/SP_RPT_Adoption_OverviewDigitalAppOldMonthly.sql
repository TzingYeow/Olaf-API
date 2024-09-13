-- =============================================
-- Author:		Leonard Yong
-- Create date: 2020-08-15
-- Description:	Adoption Rate Report
-- =============================================
--EXEC SP_RPT_Adoption_OverviewDigitalAppOldMonthly
CREATE PROCEDURE [dbo].[SP_RPT_Adoption_OverviewDigitalAppOldMonthly] 
	 
AS
BEGIN

	CREATE TABLE #TempRaw (
		WEOrder int,
		WEDate NVARCHAR(10),
		AvgMCACtive INT,
		AvgMC int,
		Perc decimal(18,2)
	)

	INSERT INTO #TempRaw 
	SELECT MONTH(Wedate),CONVERT(nvarchar(3), WEDate,109) + '-' + CONVERT(nvarchar(2), WEDate,2),0,0,0 FROM Mst_Weekending WHERE YEAR(WEDate) = YEAR(GETDATE())
	GROUP BY CONVERT(nvarchar(3), WEDate,109) + '-' + CONVERT(nvarchar(2), WEDate,2), MONTH(Wedate)
	ORDER BY  MONTH(Wedate)

	UPDATE A SET A.AvgMCACtive = B.AvgMCActive, A.AvgMC = B.AvgMc  FROM #TempRaw A INNER JOIN 
	(SELECT CONVERT(nvarchar(3), WEDate,109) + '-' + CONVERT(nvarchar(2), WEDate,102) as 'WeDate' , SUM(TotalJotForm) / COUNT(*) as 'AvgMCActive', SUM(TotalMC) / COUNT(*)  as 'AvgMc'
	FROM RPT_OverviewDigitalAppOldMethod
	GROUP BY CONVERT(nvarchar(3), WEDate,109) + '-' + CONVERT(nvarchar(2), WEDate,102), MONTH(Wedate) 
	) B ON A.WEDate = B.WeDate

	
	UPDATE #TempRaw SET Perc = CAST(CAST(AvgMCACtive as decimal(18,2)) / CAST(AvgMC as decimal(18,2)) as decimal(18,2)) where AvgMC <> 0

	SELECT * FROM #TempRaw WHERE WEOrder < 4
	order by WEOrder

END
