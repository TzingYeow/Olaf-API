 
 -- SP_RPT_WeeklyHuddleReport_SGHeadcount '2023-01-29'
--=============================
CREATE PROCEDURE [dbo].[SP_RPT_WeeklyHuddleReport_SGHeadcount]
	-- Add the parameters for the stored procedure here
	@ReportWE  date 
AS
BEGIN
	 
DECLARE @weDate DATE
DECLARE @CountryWeDate DATE
DECLARE @weFromDate DATE
DECLARE @weToDate DATE
DECLARE @Month as NVARCHAR(10)
DECLARE @Quarter as NVARCHAR(10)
DECLARE @UniqueSCH as INT
DECLARE @UniqueDiv1 as INT
DECLARE @UniqueDiv2 as INT
DECLARE @UniqueDiv3 as INT
DECLARE @UniqueSCH_Charity as INT
DECLARE @UniqueSCH_Commercial as INT

SET @weDate =  @ReportWE
SET @Month = FORMAT(@weDate,'MMM') + '-' + SUBSTRING(CAST(YEAR(@wedate) as nvarchar),3,2)
SET @Quarter = 'Q' + CAST(DATEPART(QUARTER, @Wedate) as nvarchar) + ' FY' + SUBSTRING(CAST(YEAR(@wedate) as nvarchar),3,2)
 

CREATE TABLE #ReportDate (
	Country NVARCHAR(20),
	Division NVARCHAR(20), 
	CampaignID INT,
	Weekending Date, 
	CountryHC INT,
	CountryDivHC INT ,
	CountryCampaignHC INT ,
	CampaignName NVARCHAR(100)
)
 
 --INSERT INTO #ReportDate ( Country, Division, Weekending)
 --SELECT 'Singapore', 'Charity', @weDate
 
 --INSERT INTO #ReportDate ( Country, Division, Weekending)
 --SELECT 'Singapore', 'Commercial',@weDate
   
SELECT @weFromDate = FromDate, @weToDate = ToDate, @CountryWeDate = WEdate  FROM NewOlaf_Prod..MST_Weekending where WEdate = @weDate
 
 INSERT INTO #ReportDate ( Country, Division, CampaignID, Weekending, CampaignName)
 SELECT distinct 'Singapore',DivisionName, A.CampaignId, @weDate, A.CampaignName FROM Mst_Campaign A LEFT JOIN Mst_Division B ON A.DivisionId = B.DivisionId where CountryCode = 'SG'
 and IsActive = 1 and IsTestProduct = 0 and A.IsDeleted = 0 
 
 UPDATE #ReportDate SET Division = 'COMMERCIAL' WHERE CampaignName in ('BELLS','SINGTEL','STARHUB')
  
DROP TABLE IF EXISTS #Mst_IndependentContractor
SELECT CAST(B.CountryCode as NVARCHAR(50)) as 'Country', A.IndependentContractorId, A.BadgeNo, A.LastDeactivateDate INTO #Mst_IndependentContractor FROM Mst_IndependentContractor A 
LEFT JOIN Mst_MarketingCompany B ON A.MarketingCompanyId = B.MarketingCompanyId
where IndependentContractorId not in (SELECT IndependentContractorId FROM Mst_IndependentContractor where  LastDeactivateDate is null and status = 'Inactive')
and 
IndependentContractorId not in (SELECT IndependentContractorId FROM Mst_IndependentContractor where StartDate > @weToDate)
and A.IsDeleted = 0 and B.IsDeleted = 0
AND B.Code not in ('HQ') and B.countryCode = 'SG'
 
 
UPDATE #Mst_IndependentContractor SET Country = 'Hong Kong' where country = 'HK'
UPDATE #Mst_IndependentContractor SET Country = 'Korea' where country = 'KR'
UPDATE #Mst_IndependentContractor SET Country = 'Malaysia' where country = 'MY'
UPDATE #Mst_IndependentContractor SET Country = 'Philippines' where country = 'PH'
UPDATE #Mst_IndependentContractor SET Country = 'Singapore' where country = 'SG'
UPDATE #Mst_IndependentContractor SET Country = 'Thailand' where country = 'TH'
UPDATE #Mst_IndependentContractor SET Country = 'Taiwan' where country = 'TW'

DELETE FROM #Mst_IndependentContractor WHERE ISNULL(LastDeactivateDate,'3000-01-01') < @weFromDate

DROP TABLE IF EXISTS #TempHCDetail
SELECT A.Country, B.CampaignId, A.IndependentContractorId, A.BadgeNo,  D.DivisionName  INTO #TempHCDetail FROM #Mst_IndependentContractor A
LEFT JOIN Mst_IndependentContractor_Assignment B ON A.IndependentContractorId = B.IndependentContractorId 
and B.IsDeleted = 0 and ISNULL(B.EndDate,'4000-01-01') >= @weFromDate and B.StartDate < @weToDate
LEFT JOIN Mst_Campaign C ON B.CampaignId = C.CampaignId
LEFT JOIN Mst_Division D ON C.DivisionId = D.DivisionId
WHERE B.CampaignId is not null
 

 
 UPDATE #TempHCDetail SET DivisionName = 'COMMERCIAL' WHERE CampaignId in (1124,1125,1205)
 
-- Update county Level HC
UPDATE A SET A.CountryHC = B.HC FROM #ReportDate A 
INNER JOIN (SELECT Country, count(distinct BadgeNo) HC FROM #Mst_IndependentContractor   GROUP BY Country)
B ON A.Country = B.Country

UPDATE A SET A.CountryDivHC = B.HC FROM #ReportDate A 
INNER JOIN (SELECT Country, DivisionName, count(distinct BadgeNo) HC FROM #TempHCDetail   GROUP BY Country, DivisionName)
B ON A.Country = B.Country and A.Division =B.DivisionName


UPDATE A SET A.CountryCampaignHC = B.HC FROM #ReportDate A 
INNER JOIN (SELECT Country, CampaignId, count(distinct BadgeNo) HC FROM #TempHCDetail   GROUP BY Country, CampaignId)
B ON A.Country = B.Country and A.CampaignId =B.CampaignId


 
SELECT Country, Division, Weekending,  ISNULL(CountryHC,0) as CountryHC, ISNULL(CountryDivHC,0) as CountryDivHC,ISNULL(CountryCampaignHC,0) as CountryCampaignHC,
CampaignName FROM #ReportDate 
WHERE CountryCampaignHC > 0
ORDER BY Weekending, Division


END


