-- =============================================
-- Author:		Syafiqah Ab Manah
-- Create date: 2023-02-13
-- Description:	This Report list out Campaign Start and End Dates of BAs (SG)
-- EXEC [SP_RPT_CampaignAssignment]'2023-01-08','2023-01-29','b2a2a1706a0d403598e9115d5846485d','IN,HK,ID,KR,MY,PH,TH,TW,SG'-- REGIONAL Syafiqah
-- EXEC [SP_RPT_CampaignAssignment]'2023-01-08','2023-01-29','b2a2a1706a0d403598e9115d5846485d'-- REGIONAL Syafiqah
-- EXEC [SP_RPT_CampaignAssignment]'2023-01-08','2023-01-29','fc2f284ceaa34320b6b89796be0af6e7'-- MOADMIN mymolo03
-- =============================================
CREATE PROCEDURE [dbo].[SP_RPT_CampaignAssignment]
	 @weFromDate Date,
	 @weToDate Date,
	 @userId NVARCHAR(255)
	 --@selectedCountry NVARCHAR(255)

AS
BEGIN
--select * from mst_user where ROLEID = 3

DECLARE @CountryCode NVARCHAR(255);
DECLARE @IsMOAdminRole BIT;
DECLARE @MCId NVARCHAR(10);
DECLARE @MinDeactivateDate DATE
DECLARE @MinNewStarterDate DATE

SELECT @CountryCode = CountryAccess, @IsMOAdminRole = CASE WHEN UserRoleId = 3 THEN  1 ELSE 0 END,@MCId =  MarketingCompanyId FROM Mst_User WHERE UserId = @userId


IF OBJECT_ID('tempdb..#SubCountry') IS NOT NULL DROP TABLE #SubCountry
SELECT CAST(VALUE as varchar) as 'Country' INTO #SubCountry FROM STRING_SPLIT(@CountryCode, ',') 

--IF OBJECT_ID('tempdb..#SelectedCountry') IS NOT NULL DROP TABLE #SelectedCountry
--SELECT CAST(VALUE as varchar) as 'Country' INTO #SelectedCountry FROM STRING_SPLIT(@selectedCountry, ',') 

IF OBJECT_ID('tempdb..#SelectedCountry') IS NOT NULL DROP TABLE #SelectedCountry
SELECT CAST(VALUE as varchar) as 'Country' INTO #SelectedCountry FROM STRING_SPLIT(@CountryCode, ',') 

CREATE TABLE #BALIST (
	CountryCode NVARCHAR(20),
	MOCode NVARCHAR(5),
	IndependentContractorId INT,
	BadgeNo NVARCHAR(20),
	MarketingCompanyId INT,
	BAStatus NVARCHAR(50),
	StartDate DATE,
	LastDeactivateDate DATE
)

SELECT @MinDeactivateDate = FROMDATE FROM Mst_Weekending WHERE @weFromDate >= FromDate  AND @weFromDate <= ToDate
SELECT @MinNewStarterDate = TODATE FROM Mst_Weekending WHERE @weToDate >= FromDate  AND @weToDate <= ToDate

---- -- TESTING PART
--SELECT @CountryCode CountryCode,@IsMOAdminRole IsMOAdminRole,@MCId MCId
--SELECT @MinDeactivateDate MinDeactivateDate, @MinNewStarterDate MinNewStarterDate

IF OBJECT_ID('tempdb..#INACTIVEBA') IS NOT NULL DROP TABLE #INACTIVEBA
SELECT IndependentContractorId INTO #INACTIVEBA FROM Mst_IndependentContractor  A WHERE STATUS = 'INACTIVE' AND LastDeactivateDate IS NOT NULL AND LastDeactivateDate < @MinDeactivateDate

IF OBJECT_ID('tempdb..#NULLLASTDEACTIVATE') IS NOT NULL DROP TABLE #NULLLASTDEACTIVATE
SELECT IndependentContractorId INTO #NULLLASTDEACTIVATE FROM Mst_IndependentContractor  A WHERE STATUS = 'INACTIVE' AND LastDeactivateDate IS NULL

IF OBJECT_ID('tempdb..#NEWSTARTER') IS NOT NULL DROP TABLE #NEWSTARTER
SELECT IndependentContractorId INTO #NEWSTARTER FROM Mst_IndependentContractor  A WHERE STATUS = 'ACTIVE' AND StartDate > @MinNewStarterDate

INSERT INTO #BALIST (CountryCode,MOCode,IndependentContractorId,BadgeNo,MarketingCompanyId,BAStatus,LastDeactivateDate,StartDate)
SELECT B.CountryCode,B.Code,A.IndependentContractorId,A.BadgeNo,A.MarketingCompanyId,A.Status,LastDeactivateDate,StartDate FROM Mst_IndependentContractor A 
INNER JOIN Mst_MarketingCompany B ON A.MarketingCompanyId = B.MarketingCompanyId AND B.IsActive = 1 AND B.IsDeleted = 0
WHERE A.IndependentContractorId NOT IN (SELECT IndependentContractorId FROM #INACTIVEBA)
AND A.IndependentContractorId NOT IN (SELECT IndependentContractorId FROM #NULLLASTDEACTIVATE)
AND A.IndependentContractorId NOT IN (SELECT IndependentContractorId FROM #NEWSTARTER)
AND B.CountryCode IN (SELECT Country FROM #SelectedCountry)

-- Filter BA list by Role
IF @IsMOAdminRole = 1
BEGIN
	BEGIN
		DELETE A		
		FROM #BALIST A	
		WHERE A.MarketingCompanyId NOT IN (@MCId)
	END
END

IF OBJECT_ID('tempdb..#FINALLIST') IS NOT NULL DROP TABLE #FINALLIST
SELECT A.CountryCode,A.MOCode, A.IndependentContractorId ,A.BadgeNo, A.BAStatus, D.CampaignName AS Campaign, C.StartDate CampaignStartDate, C.EndDate CampaignEndDate, A.StartDate AS BAStartDate, LastDeactivateDate  
INTO #FINALLIST FROM #BALIST A
INNER JOIN Mst_IndependentContractor_Assignment C ON A.IndependentContractorId = C.IndependentContractorId AND C.IsDeleted = 0
INNER JOIN Mst_Campaign D ON C.CampaignId = D.CampaignId
WHERE 
(C.StartDate <= @MinDeactivateDate AND EndDate IS NULL)
OR (C.StartDate <= @MinDeactivateDate AND EndDate >= @MinDeactivateDate)
OR ((C.StartDate >= @MinDeactivateDate AND C.StartDate <= @MinNewStarterDate) AND EndDate IS NULL)
OR ((C.StartDate >= @MinDeactivateDate AND C.StartDate <= @MinNewStarterDate) AND EndDate >= @MinNewStarterDate)
OR ((C.StartDate >= @MinDeactivateDate AND C.StartDate <= @MinNewStarterDate) AND EndDate >= @MinDeactivateDate)
order by A.CountryCode,A.MOCode,A.BadgeNo ASC

SELECT * FROM #FINALLIST WHERE (CAST(CampaignEndDate AS DATE) >= @MinDeactivateDate) OR CampaignEndDate IS NULL

END

-- EXEC [SP_RPT_CampaignAssignment]'2023-01-08','2023-01-29','b2a2a1706a0d403598e9115d5846485d'-- REGIONAL Syafiqah


