

-- ==========================================================================================
-- Author:		Syafiqah Ab Manah
-- Create date: 2020-11-05
-- Description:	Regional RC Analysis Report 
-- EXEC RPT_AdvancementBADetailReport '2022-04-17' ,'KK0031','TH'
-- ==========================================================================================
--EXEC RPT_AdvancementBADetailReport '2022-03-20','KN00010','2022-03-20' 
CREATE PROCEDURE [dbo].[RPT_AdvancementBADetailReport]
 @Weekending DATE,
 @BadgeNo NVARCHAR(10),
 @CountryCode NVARCHAR(2)
AS
BEGIN 

	DECLARE @WEDate1 as DATE
	DECLARE @WEDate2 as DATE

	SET @WEDate1 = @Weekending
	SET @WEDate2 = (SELECT TOP 1 Weekending1 FROM TXN_AutoAdvancementResult 
			WHERE CountryCode = @CountryCode and  Weekending1 > @Weekending ORDER BY Weekending1 ASC
			)

SELECT CountryCode, Weekending1 as 'Weekending', BadgeNo,BALevel as 'CurrentLevel', BALink as 'BadgeNoLink',
BAPersonalSalesValue as 'PersonalPayable', BAPersonalPoint as 'BulletinPoint' FROM TXN_AutoAdvancementResult
WHERE CountryCode = @CountryCode and weekending1 in (@WEDate1,@WEDate2)
and BALink like '%'  + @BadgeNo + '%' and IsDeleted = 0
Order by Weekending, BALink
 
END
 


