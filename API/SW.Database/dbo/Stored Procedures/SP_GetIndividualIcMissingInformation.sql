
-- =============================================
-- Author:		Asyraf Bakar
-- Create date: 18 October 2018
-- Description:	To get the list of missing information for an Independent Contractor
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetIndividualIcMissingInformation]
	@IndependentContractorId int,
	@ResultIncludeIndependentContractorId int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	 

IF OBJECT_ID('tempdb..#MissingInformationTable') IS NOT NULL DROP TABLE #MissingInformationTable
IF OBJECT_ID('tempdb..#ICAssignments') IS NOT NULL DROP TABLE #ICAssignments
IF OBJECT_ID('tempdb..#DuplicateCampaignIdAssigned') IS NOT NULL DROP TABLE #DuplicateCampaignIdAssigned
IF OBJECT_ID('tempdb..#BadgeCardHistory') IS NOT NULL DROP TABLE #BadgeCardHistory
IF OBJECT_ID('tempdb..#ComplianceCheclist') IS NOT NULL DROP TABLE #ComplianceCheclist
 
CREATE TABLE #MissingInformationTable(
    Description varchar(max),
)

--1. IC Details
Declare @IcCountryCode varchar(10) = (Select b.CountryCode from Mst_IndependentContractor a left join Mst_MarketingCompany b on b.MarketingCompanyId = a.MarketingCompanyId where a.IndependentContractorId = @IndependentContractorId );

--1.1  Profile Picture
if ((Select ProfilePicture from Mst_IndependentContractor where IndependentContractorId = @IndependentContractorId) is null)
INSERT INTO #MissingInformationTable(Description) VALUES('This IC doesnt have a profile picture.')
 
--1.2  Start Date
if ((Select StartDate from Mst_IndependentContractor where IndependentContractorId = @IndependentContractorId) is null)
INSERT INTO #MissingInformationTable(Description) VALUES('This IC doesnt have a start date.')

--1.3  Gender
if ((Select Gender from Mst_IndependentContractor where IndependentContractorId = @IndependentContractorId) is null)
INSERT INTO #MissingInformationTable(Description) VALUES('This IC doesnt have a gender.')

--1.4 NRIC
if ((Select IC from Mst_IndependentContractor where IndependentContractorId = @IndependentContractorId) is null)
INSERT INTO #MissingInformationTable(Description) VALUES('This IC doesnt have an indentification no. (IC).')

--1.5 FirstName
if ((Select FirstName from Mst_IndependentContractor where IndependentContractorId = @IndependentContractorId) is null)
INSERT INTO #MissingInformationTable(Description) VALUES('This IC doesnt have a First Name.')
 
--1.6 ReportBadgeNo
DECLARE @ReportBadgeNo varchar(50) = (Select ReportBadgeNo from Mst_IndependentContractor where IndependentContractorId = @IndependentContractorId );
if (@ReportBadgeNo is null)		
	INSERT INTO #MissingInformationTable(Description) VALUES('This IC doesnt have a Reporting Badge No.');
else if ((Select Count(IndependentContractorId) from Mst_IndependentContractor a left join Mst_MarketingCompany b on b.MarketingCompanyId = a.MarketingCompanyId  where BadgeNo = @ReportBadgeNo and b.CountryCode = @IcCountryCode and a.IsDeleted = 0) = 0)
	INSERT INTO #MissingInformationTable(Description) VALUES('Theres no IC having Badge No. same as the Reporting Badge No.');
else if ((Select Top 1 Status from Mst_IndependentContractor a left join Mst_MarketingCompany b on b.MarketingCompanyId = a.MarketingCompanyId  where BadgeNo = @ReportBadgeNo and b.CountryCode = @IcCountryCode and a.IsDeleted = 0) = 'Inactive') -- Top 1 is only temporay because of branch out bug generate same badge no for different IC
	INSERT INTO #MissingInformationTable(Description) VALUES('Reporting person for this IC is inactive.');
			 	 
--2. Campaigns
Select IndependentContractorAssigmentId, IndependentContractorId, CampaignId, DATEADD(dd, 0, DATEDIFF(dd, 0, StartDate)) as 'StarDate',
    DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())) as 'TodayDate',
    CASE WHEN EndDate is null THEN DATEADD(year, 50, DATEDIFF(dd, 0, GETDATE())) ELSE DATEDIFF(dd, 0, DATEDIFF(dd, 0, EndDate)) END as 'EndDate',
        CASE WHEN  DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())) between DATEADD(dd, 0, DATEDIFF(dd, 0, StartDate)) and CASE WHEN EndDate is null THEN DATEADD(year, 50, DATEDIFF(dd, 0, GETDATE())) ELSE DATEDIFF(dd, 0, DATEDIFF(dd, 0, EndDate)) END THEN 1 ELSE 0 END as 'IsActive'
INTO #ICAssignments
from Mst_IndependentContractor_Assignment
where IndependentContractorId = @IndependentContractorId and IsDeleted = 0;

--2.1 Active
DECLARE @TotalCampaign int = (SElect Count(*) from #ICAssignments)
DECLARE @ActiveCampaign int = (SElect Count(*) from #ICAssignments where TodayDate between StarDate and EndDate)
if (@TotalCampaign = 0 or @ActiveCampaign = 0)
INSERT INTO #MissingInformationTable(Description) VALUES('This IC doesnt have an active campaign.')

--2.2 Duplicate or overlap
Select CampaignId
INTO #DuplicateCampaignIdAssigned
from #ICAssignments
where IsActive = 1
group by CampaignId, IsActive
having Count(CampaignId) > 1

INSERT INTO #MissingInformationTable
Select CONCAT('This IC has multiple assigments for the same campaign ',b.CampaignName, '.') from #DuplicateCampaignIdAssigned a
left join Mst_Campaign b on b.CampaignId = a.CampaignId

--3. Badge Cards
Select IndependentContractorBadgeCardId, IndependentContractorId, CampaignId, DATEADD(dd, 0, DATEDIFF(dd, 0, IssueDate)) as 'IssueDate',
DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())) as 'TodayDate',
CASE WHEN ExpiredDate is null THEN DATEADD(year, 50, DATEDIFF(dd, 0, GETDATE())) ELSE DATEDIFF(dd, 0, DATEDIFF(dd, 0, ExpiredDate)) END as 'ExpiredDate',
CASE WHEN  DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())) between DATEADD(dd, 0, DATEDIFF(dd, 0, IssueDate)) and CASE WHEN ExpiredDate is null THEN DATEADD(year, 50, DATEDIFF(dd, 0, GETDATE())) ELSE DATEDIFF(dd, 0, DATEDIFF(dd, 0, ExpiredDate)) END THEN 1 ELSE 0 END as 'IsNotExpired',
IsActive
INTO #BadgeCardHistory
from Mst_IndependentContractor_BadgeCard
where IndependentContractorId = @IndependentContractorId and IsDeleted = 0;

--3.1 All active campaign badge card without card
INSERT INTO #MissingInformationTable
Select CONCAT('This IC doesnt has active badge card for campaign ', c.CampaignName, '.') 
from #ICAssignments a 
left join #BadgeCardHistory b on b.CampaignId = a.CampaignId
left join Mst_Campaign c on c.CampaignId = a.CampaignId
where b.IndependentContractorBadgeCardId is null and a.IsActive = 1 and b.IsNotExpired = 1 and b.CampaignId is not null;
 
--3.2 Card without campaign
INSERT INTO #MissingInformationTable
Select CONCAT('Badge Card Issue Date ', FORMAT (a.IssueDate , 'd', 'en-gb' ),' has no campaign.') 
from #BadgeCardHistory a 
where a.CampaignId is null;

--3.2 Duplicate/orverlap badge card
INSERT INTO #MissingInformationTable
Select CONCAT('Badge Card Issue Date ',FORMAT (a.IssueDate , 'd', 'en-gb' ) ,' has overlap active date with Badge Card Issue Date ',FORMAT (b.IssueDate , 'd', 'en-gb' ),'.') 
FROM Mst_IndependentContractor_BadgeCard a
JOIN Mst_IndependentContractor_BadgeCard b
ON a.CampaignId = b.CampaignId
WHERE ((a.IssueDate > b.ExpiredDate AND a.ExpiredDate < b.IssueDate)
OR (a.ExpiredDate > b.IssueDate AND a.IssueDate < b.ExpiredDate)
OR (a.IssueDate = b.IssueDate AND a.ExpiredDate = b.ExpiredDate))
and a.IsDeleted = 0 and b.IsDeleted = 0 and a.IsActive = 1 and b.IsActive = 1
and a.IndependentContractorBadgeCardId != b.IndependentContractorBadgeCardId
and a.IndependentContractorId = @IndependentContractorId and b.IndependentContractorId = @IndependentContractorId

--3.3 Expire but still active
INSERT INTO #MissingInformationTable
Select CONCAT('Badge Card Issue Date ', FORMAT (a.IssueDate , 'd', 'en-gb' ) ,' is already expired but still active.') 
from #BadgeCardHistory a 
where a.IsNotExpired = 0 and IsActive = 1;

--3.4 about to expire
INSERT INTO #MissingInformationTable
Select CONCAT('Badge Card Issue Date ', FORMAT (a.IssueDate , 'd', 'en-gb' ),' is about to expired in ',DATEDIFF(dd,DATEADD(dd, -7, DATEDIFF(dd, 0, GETDATE())),a.ExpiredDate),' days.') 
from #BadgeCardHistory a 
where a.ExpiredDate <  DATEADD(dd, -7, DATEDIFF(dd, 0, GETDATE())) and IsActive = 1;

  
--4. Movement log
--Movement log will be checking in application

--4.1 Missing promotion date

--4.2 Promotion level sequence
 
--4.3 Promotion above current level

--5. Compliance Checlist
Select c.ComplianceChecklistId,c.Description, c.ComplyDuration, c.CreatedDate,DATEADD(dd, -7, DATEDIFF(dd, ComplyDuration, c.CreatedDate)) as 'CompliedBeforeDate', 0 'HasComplied'
INTO #ComplianceCheclist
from (
Select * from Mst_ComplianceChecklist a where IsDeleted = 0 and ForIndependentContractor = 1 and a.ComplyDuration is not null and a.CountryCode is null and a.CampaignId is null 
Union
Select * from Mst_ComplianceChecklist a where IsDeleted = 0 and ForIndependentContractor = 1 and a.ComplyDuration is not null and a.CountryCode = (Select CountryCode from Mst_MarketingCompany a inner join Mst_IndependentContractor b on a.MarketingCompanyId = b.MarketingCompanyId where b.IndependentContractorId = @IndependentContractorId )and a.CampaignId is null
Union
Select * from Mst_ComplianceChecklist a where IsDeleted = 0 and ForIndependentContractor = 1 and a.ComplyDuration is not null and a.CampaignId  in (Select CampaignId from Mst_IndependentContractor_Assignment where IndependentContractorId = @IndependentContractorId)) c
left join Mst_Campaign b on b.CampaignId = c.CampaignId  

update #ComplianceCheclist 
Set HasComplied = 1
where ComplianceChecklistId in (Select ComplianceChecklistId from Mst_IndependentContractor_Compliance where IsDeleted = 0 and HasComplied = 1 and IndependentContractorId = @IndependentContractorId)
 
INSERT INTO #MissingInformationTable
Select CONCAT('Compliance Cheklist ', Description, ' for this IC has passed ',DATEDIFF(dd, CompliedBeforeDate, GETDATE()),' days and still not complied.')
from #ComplianceCheclist
where CompliedBeforeDate < GETDATE() and HasComplied = 0;

--6. Tranings
if ((Select Count(IndependentContractorTrainingId) from Mst_IndependentContractor_Training where IndependentContractorId = @IndependentContractorId and IsDeleted = 0) = 0)
	INSERT INTO #MissingInformationTable(Description) VALUES('This IC doesnt have any induction records.')
		
if(@ResultIncludeIndependentContractorId = 0)
	Select * from #MissingInformationTable
else
	 Select @IndependentContractorId, * from #MissingInformationTable

DROP TABLE #MissingInformationTable
DROP TABLE #ICAssignments
DROP TABLE #DuplicateCampaignIdAssigned
DROP TABLE #BadgeCardHistory
DROP TABLE #ComplianceCheclist


END
