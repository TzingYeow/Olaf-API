using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstRecruitmentCandidateActivityLog
{
    public int RecruitmentCandidateActivityLogId { get; set; }

    public int RecruitmentCandidateId { get; set; }

    public string Stage { get; set; }

    public string Description { get; set; }

    public string AppointmentStatus { get; set; }

    public string UnsuitableStatus { get; set; }

    public string NotSucceedReason { get; set; }

    public DateTime ScheduleStartDateTime { get; set; }

    public DateTime ScheduleEndDateTime { get; set; }

    public int? MarketingCompanyBranchId { get; set; }

    public string Location { get; set; }

    public string LeaderBadgeNo { get; set; }

    public string Remark { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public string ConductedBy { get; set; }

    public virtual MstMarketingCompanyBranch MarketingCompanyBranch { get; set; }

    public virtual MstRecruitmentCandidate RecruitmentCandidate { get; set; }
}
