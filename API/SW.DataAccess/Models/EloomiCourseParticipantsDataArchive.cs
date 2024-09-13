using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class EloomiCourseParticipantsDataArchive
{
    public int Id { get; set; }

    public int CourseParticipantId { get; set; }

    public int CourseId { get; set; }

    public int UserId { get; set; }

    public int? CompanyId { get; set; }

    public string Name { get; set; }

    public int? ImageId { get; set; }

    public int? Progress { get; set; }

    public string Status { get; set; }

    public string TimeSpentString { get; set; }

    public decimal? Score { get; set; }

    public string CompletedAt { get; set; }

    public string StartedAt { get; set; }

    public int? Attempts { get; set; }

    public string Deadline { get; set; }

    public string CompletedBy { get; set; }

    public string AssignedAt { get; set; }

    public string ParticipantType { get; set; }

    public int? DoNotify { get; set; }

    public string RenewalType { get; set; }

    public string RenewalFromDate { get; set; }

    public string RenewalFromInterval { get; set; }

    public string RenewalFromFunction { get; set; }

    public string RenewalPeriod { get; set; }

    public string RenewalApplyFrom { get; set; }

    public string ExpiredAt { get; set; }

    public string RenewalPeriodStart { get; set; }

    public int? TotalRenewals { get; set; }

    public int? TotalRenewed { get; set; }

    public string RenewalAt { get; set; }

    public string CourseDescription { get; set; }

    public string CourseName { get; set; }

    public string CourseType { get; set; }

    public DateTime? DataInsertedAt { get; set; }

    public DateTime? DataArchivedAt { get; set; }
}
