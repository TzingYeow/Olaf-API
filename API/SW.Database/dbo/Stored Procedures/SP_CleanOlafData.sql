

-- =============================================
-- Author:		Asyraf Bakar
-- Create date: 03 April 2019
-- Description:	To get next badge No for Independent Contractor
-- =============================================
CREATE PROCEDURE [dbo].[SP_CleanOlafData]
AS
BEGIN
	SET NOCOUNT ON;
		--1. Delete movement that the IC has been deleted but moevemnt is not deleted 
		--SElect a.* from Mst_IndependentContractor_Movement a
		--left join Mst_IndependentContractor b on b.IndependentContractorId = a.IndependentContractorId
		--where b.IsDeleted = 1 and a.IsDeleted = 0

		Update a
		Set a.IsDeleted = 1, UpdatedBy = 'scheduler, IC has been deleted', UpdatedDate = GETDATE()
		from Mst_IndependentContractor_Movement a
		left join Mst_IndependentContractor b on b.IndependentContractorId = a.IndependentContractorId
		where b.IsDeleted = 1 and a.IsDeleted = 0

		--2. Delete assignment that the IC has been deleted but assignment is not deleted 
		--SElect a.* from Mst_IndependentContractor_Assignment a
		--left join Mst_IndependentContractor b on b.IndependentContractorId = a.IndependentContractorId
		--where b.IsDeleted = 1 and a.IsDeleted = 0

		Update a
		Set a.IsDeleted = 1, UpdatedBy = 'scheduler, IC has been deleted', UpdatedDate = GETDATE()
		from Mst_IndependentContractor_Assignment a
		left join Mst_IndependentContractor b on b.IndependentContractorId = a.IndependentContractorId
		where b.IsDeleted = 1 and a.IsDeleted = 0

		--3. Delete compliance that the IC has been deleted but compliance is not deleted 
		--SElect a.* from Mst_IndependentContractor_Compliance a
		--left join Mst_IndependentContractor b on b.IndependentContractorId = a.IndependentContractorId
		--where b.IsDeleted = 1 and a.IsDeleted = 0

		Update a
		Set a.IsDeleted = 1, UpdatedBy = 'scheduler, IC has been deleted', UpdatedDate = GETDATE()
		from Mst_IndependentContractor_Compliance a
		left join Mst_IndependentContractor b on b.IndependentContractorId = a.IndependentContractorId
		where b.IsDeleted = 1 and a.IsDeleted = 0


		--4. Delete duplicate movement movement logs
		;With numberedTable as
		(Select IndependentContractorMovementId, IndependentContractorId, Description, IndependentContractorLevelId, EffectiveDate, CreatedDate, ROW_NUMBER() OVER (PARTITION BY IndependentContractorId, Description, IndependentContractorLevelId, EffectiveDate Order by CreatedDate) as Rn
		from Mst_IndependentContractor_Movement 
		where IsDeleted = 0 and Description not in ('Re-assign','First Assignment'))
		Select * INTO #ToDeleteMovement from numberedTable where rn > 1
		--Select * from #ToDeleteMovement

		Update a
		Set a.IsDeleted = 1, UpdatedBy = 'scheduler, duplicate movement log', UpdatedDate = GETDATE()
		from Mst_IndependentContractor_Movement a
		where  a.IndependentContractorMovementId in (Select IndependentContractorMovementId from #ToDeleteMovement)

		DROP TABLE #ToDeleteMovement
 
		--5. Clean OriginalBadgeNo that have blank space
		Update Mst_IndependentContractor
		Set OriginalBadgeNo = null where OriginalBadgeNo = ''

		--6 Deactivate all user the mc already deactivated
		--Select a.* from Mst_User a
		--left join Mst_MarketingCompany b on b.MarketingCompanyId = a.MarketingCompanyId
		--where a.IsDeleted = 0 and b.IsDeleted = 0 and b.IsActive = 0 and a.IsActive = 1
		Update a
		Set a.IsActive = 0, UpdatedBy = 'scheduler, MC deactivated', UpdatedDate = GETDATE()
		from Mst_User a
		left join Mst_MarketingCompany b on b.MarketingCompanyId = a.MarketingCompanyId
		where a.IsDeleted = 0 and b.IsDeleted = 0 and b.IsActive = 0 and a.IsActive = 1


		--7. Patch Start Date to orginal linked IC startdate
		--Select 
		--a.BadgeNo, a.StartDate,prevA.BadgeNo, prevA.StartDate, 
		--IIF(a.StartDate<prevA.StartDate,a.StartDate,prevA.StartDate) as CorrectDate
		--from Mst_IndependentContractor a
		--left join Mst_MarketingCompany b on b.MarketingCompanyId = a.MarketingCompanyId
		--left join Mst_IndependentContractor prevA on prevA.BadgeNo = a.OriginalBadgeNo and prevA.IsDeleted = 0
		--left join Mst_MarketingCompany prevB on prevB.MarketingCompanyId = prevA.MarketingCompanyId and prevB.IsDeleted = 0
		--where 
		--a.IsDeleted = 0
		--and a.OriginalIndependentContractorId is not null
		--and a.StartDate != prevA.StartDate 
		 
		DECLARE @cnt INT = 0;
		WHILE @cnt < 3
		BEGIN   
			update a
			Set  a.StartDate = IIF(a.StartDate<prevA.StartDate,a.StartDate,prevA.StartDate) 
			from Mst_IndependentContractor a
			left join Mst_MarketingCompany b on b.MarketingCompanyId = a.MarketingCompanyId
			left join Mst_IndependentContractor prevA on prevA.BadgeNo = a.OriginalBadgeNo and prevA.IsDeleted = 0
			left join Mst_MarketingCompany prevB on prevB.MarketingCompanyId = prevA.MarketingCompanyId and prevB.IsDeleted = 0
			where 
			a.IsDeleted = 0
			and a.OriginalIndependentContractorId is not null
			and a.StartDate != prevA.StartDate 
			and b.CountryCode = prevB.CountryCode
		   SET @cnt = @cnt + 1;
		END;

		SET @cnt = 0;
		WHILE @cnt < 3
		BEGIN   
			update prevA
			Set  prevA.StartDate = IIF(a.StartDate<prevA.StartDate,a.StartDate,prevA.StartDate) 
			from Mst_IndependentContractor a
			left join Mst_MarketingCompany b on b.MarketingCompanyId = a.MarketingCompanyId
			left join Mst_IndependentContractor prevA on prevA.BadgeNo = a.OriginalBadgeNo and prevA.IsDeleted = 0
			left join Mst_MarketingCompany prevB on prevB.MarketingCompanyId = prevA.MarketingCompanyId and prevB.IsDeleted = 0
			where 
			a.IsDeleted = 0
			and a.OriginalIndependentContractorId is not null
			and a.StartDate != prevA.StartDate 
			and b.CountryCode = prevB.CountryCode
		   SET @cnt = @cnt + 1;
		END;
		
		-- Fix the Original badgeNo as same as the current record
		update Mst_IndependentContractor
		Set OriginalBadgeNo = null, OriginalIndependentContractorId = null 
		where IndependentContractorId = OriginalIndependentContractorId


		 
		-- 8. Delete duplicate reporting no changes
		;WITH ReportingNoChanges AS  
		(  
			SELECT *,
			ROW_NUMBER() OVER (PARTITION BY  IndependentContractorId,NewReportingBadgeNo,HasChanged,IndependentContractorBranchOutId,EffectiveDate,EndDate ORDER BY IndependentContractorReportingNoChangesId) AS rn  
			FROM Mst_IndependentContractor_ReportingNoChanges where IsDeleted = 0
		)
		Update Mst_IndependentContractor_ReportingNoChanges 
		Set IsDeleted = 1,UpdatedBy = 'scheduler, Duplicate Reporting Changes', UpdatedDate = GETDATE()
		where IndependentContractorReportingNoChangesId in (Select IndependentContractorReportingNoChangesId from ReportingNoChanges where rn > 1);


		-- 9. Stamp null end date that suppose to have end date
		;WITH ReportingNoChanges AS  
		(  
			SELECT *,
			ROW_NUMBER() OVER (PARTITION BY  IndependentContractorId,EndDate ORDER BY IndependentContractorReportingNoChangesId) AS rn  
			FROM Mst_IndependentContractor_ReportingNoChanges where IsDeleted = 0 and EndDate is null
		)
		Update a 
		Set a.EndDate = (Select DATEADD(DD,-1,x.EffectiveDate) from ReportingNoChanges x where x.IndependentContractorId = a.IndependentContractorId and x.rn = (a.rn+1)  ),UpdatedBy = 'scheduler, Stamp End Date', UpdatedDate = GETDATE()
		from ReportingNoChanges a
		where a.IndependentContractorId in 
			(Select x.IndependentContractorId from Mst_IndependentContractor_ReportingNoChanges x
			where x.IsDeleted = 0 and x.EndDate is null
			group by x.IndependentContractorId,EndDate
			having Count(x.IndependentContractorId) > 1
		);


		--10. Clean Takaful license that claim already complied but no exam pass date		
		update a
		Set a.HasComplied = 0
		from Mst_IndependentContractor_Compliance a
		where a.CreatedDate > '2019-06-01'
		and ComplianceChecklistId in (6,13,14) and HasComplied = 1 and ComplianceEffectiveDate is null

END
