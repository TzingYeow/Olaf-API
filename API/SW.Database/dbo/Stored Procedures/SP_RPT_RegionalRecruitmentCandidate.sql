-- ============================================================
-- Author:		Syafiqah Ab Manah
-- Create date: 2020-09-30
-- Description:	Get Regional Recruitment Candidate Information
-- ============================================================
CREATE PROCEDURE [dbo].[SP_RPT_RegionalRecruitmentCandidate]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DISTINCT RecruitmentCandidateId INTO #RC FROM Mst_RecruitmentCandidate_ActivityLog 
	WHERE ScheduleStartDateTime >= '2020-01-01' AND ScheduleStartDateTime <= CAST(GETDATE() AS DATE)
	ORDER BY RecruitmentCandidateId

	SELECT * INTO #SELECTEDIC FROM Mst_RecruitmentCandidate WHERE RecruitmentCandidateId IN (SELECT RecruitmentCandidateId FROM #RC)

	Select
	B.CountryCode AS 'Country', A.FirstName + A.LastName AS 'Fullname', A.Email, B.Name AS 'Marketing Company', A.Status AS 'Progress', 
	(Select Top 1 CONVERT(VARCHAR(10), x.ScheduleStartDateTime, 101) from Mst_RecruitmentCandidate_ActivityLog x where x.RecruitmentCandidateId = A.RecruitmentCandidateId and x.Stage = 'First-Appointment' and x.AppointmentStatus = 'Registered' and x.IsDeleted = 0 order by ScheduleEndDateTime desc) as 'First-Appointment Date & Time',
	(Select Top 1 CONVERT(VARCHAR(10), x.ScheduleStartDateTime, 101) from Mst_RecruitmentCandidate_ActivityLog x where x.RecruitmentCandidateId = A.RecruitmentCandidateId and x.Stage = 'First-Appointment' and x.AppointmentStatus = 'Turned-Up' and x.IsDeleted = 0 order by ScheduleEndDateTime desc) as 'First-Appointment Turned-Up Date & Time',
	(select Top 1 x.REMARK from Mst_RecruitmentCandidate_ActivityLog x where x.stage = 'First-Appointment' and x.AppointmentStatus = 'Cancelled'  AND x.RecruitmentCandidateId = A.RecruitmentCandidateId) AS 'First-Appointment Cancelled Remark',
	(Select Top 1 CONVERT(VARCHAR(10), x.ScheduleStartDateTime, 101) from Mst_RecruitmentCandidate_ActivityLog x where x.RecruitmentCandidateId = A.RecruitmentCandidateId and x.Stage = 'Observation' and x.AppointmentStatus = 'Registered' and x.IsDeleted = 0 order by ScheduleEndDateTime desc) as 'Observation Date & Time',
	(Select Top 1 CONVERT(VARCHAR(10), x.ScheduleStartDateTime, 101) from Mst_RecruitmentCandidate_ActivityLog x where x.RecruitmentCandidateId = A.RecruitmentCandidateId and x.Stage = 'Observation' and x.AppointmentStatus = 'Turned-Up' and x.IsDeleted = 0 order by ScheduleEndDateTime desc) as 'Observation Turned-Up Date & Time',
	(Select Top 1 CONVERT(VARCHAR(10), x.ScheduleStartDateTime, 101) from Mst_RecruitmentCandidate_ActivityLog x where x.RecruitmentCandidateId = A.RecruitmentCandidateId and x.Stage = 'Induction' and x.AppointmentStatus = 'Registered' and x.IsDeleted = 0 order by ScheduleEndDateTime desc) as 'Induction Date & Time',
	(Select Top 1 CONVERT(VARCHAR(10), x.ScheduleStartDateTime, 101) from Mst_RecruitmentCandidate_ActivityLog x where x.RecruitmentCandidateId = A.RecruitmentCandidateId and x.Stage = 'Induction' and x.AppointmentStatus = 'Turned-Up' and x.IsDeleted = 0 order by ScheduleEndDateTime desc) as 'Induction Turned-Up Date & Time',
	(select Top 1 x.REMARK from Mst_RecruitmentCandidate_ActivityLog x where x.stage = 'Induction' and x.AppointmentStatus = 'Cancelled'  AND x.RecruitmentCandidateId = A.RecruitmentCandidateId) AS 'Induction Cancelled Remark',
	A.RecruiterBadgeNoOrName as 'Recruiter Badge No Or Name', A.RecruitmentType as 'Recruitment Type', A.RecruitmentSource as 'Recruitment Source'
	from #SELECTEDIC a
	left join Mst_MarketingCompany b on b.MarketingCompanyId = a.MarketingCompanyId
	where a.IsDeleted = 0 
	ORDER BY CountryCode ASC, B.MarketingCompanyId ASC, Fullname ASC

	DROP TABLE #RC
	DROP TABLE #SELECTEDIC
END
