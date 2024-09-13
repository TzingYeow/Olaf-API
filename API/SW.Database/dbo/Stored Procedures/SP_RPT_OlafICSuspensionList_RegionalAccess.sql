
-- =============================================
-- Author:		Syafiqah Ab Manah 
-- Create date: 2020-11-05
-- Description:	Regional RC Analysis Aged Report 
-- EXEC [SP_RPT_OlafICSuspensionList_RegionalAccess] '2023-05-07','2023-05-28','b2a2a1706a0d403598e9115d5846485d','MY','A,AE,AR,AU,CM,EC,IM,NA,TT,UL,UM,UN,LO,HQ,MP,MT,IW,UI,SM,MB,VP,JX,TR,SF,ST,EA,SV,ED,MM,SC,PX,SR,MS,JV,WA,GN,ET,UR,MW,JD,CE,UV,SS,JE,JC'
-- 
-- =============================================
CREATE PROCEDURE [dbo].[SP_RPT_OlafICSuspensionList_RegionalAccess]
 	 @weFromDate Date,
	 @weToDate Date,
	 @userId NVARCHAR(255),
	 @selectedCountry NVARCHAR(255)
AS
BEGIN
--select * from mst_user where USERNAME = 'SYAFIQAH'
--select * from Mst_UserRole

DECLARE @CountryCode NVARCHAR(255);
DECLARE @IsMOAdminRole BIT;
DECLARE @MCId NVARCHAR(10);
DECLARE @FromDate Date;
DECLARE @ToDate Date;

SELECT @FromDate = FromDate FROM Mst_Weekending WHERE WEdate = @weFromDate
SELECT @ToDate = ToDate FROM Mst_Weekending WHERE WEdate = @weToDate

SELECT 
@CountryCode = CountryAccess,
@IsMOAdminRole = CASE WHEN UserRoleId = 3 THEN  1 ELSE 0 END,
@MCId =  MarketingCompanyId
FROM Mst_User WHERE UserId = @userId

IF OBJECT_ID('tempdb..#SelectedCountry') IS NOT NULL DROP TABLE #SelectedCountry
SELECT CAST(VALUE as varchar) as 'Country' INTO #SelectedCountry FROM STRING_SPLIT(@selectedCountry, ',') 

--SELECT * FROM #SelectedCountry
--SELECT * FROM #SelectedMC

DROP TABLE IF EXISTS #DATA
SELECT m.CountryCode, m.Code, m.Name, i.BadgeNo,CONCAT(i.FirstName, i.MiddleName, ' ', i.LastName) AS 'BadgeName',i.Status, 
s.StartDate as StartDate, s.EndDate as EndDate, s.Description, s.Remark, CASE WHEN s.IsReactivate = 1 THEN 'Yes' Else 'No' END AS 'Is Reactivate'
INTO #DATA FROM Mst_IndependentContractor_Suspension s 
INNER JOIN Mst_IndependentContractor i ON s.IndependentContractorId = i.IndependentContractorId
INNER JOIN Mst_MarketingCompany m ON i.MarketingCompanyId = m.MarketingCompanyId
WHERE s.IsDeleted = 0
AND m.CountryCode IN (SELECT Country FROM #SelectedCountry)
ORDER BY m.CountryCode, m.Code, i.BadgeNo, i.Status, s.StartDate asc

DELETE FROM #DATA WHERE EndDate < @FromDate
DELETE FROM #DATA WHERE StartDate > @ToDate

SELECT A.* FROM #DATA A 
--SELECT A.* FROM #DATA A WHERE
--(A.StartDate >= @FromDate AND A.StartDate <= @ToDate) OR
--(A.EndDate >= @FromDate AND A.EndDate <= @ToDate)
--ORDER BY StartDate ASC

END



