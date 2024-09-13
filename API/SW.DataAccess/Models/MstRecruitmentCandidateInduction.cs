using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstRecruitmentCandidateInduction
{
    public int RecruitmentCandidateInductionId { get; set; }

    public int RecruitmentCandidateId { get; set; }

    public int? CampaignId { get; set; }

    public DateTime StartDate { get; set; }

    public DateTime? EndDate { get; set; }

    public string TrainingFee { get; set; }

    public string Remark { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public virtual MstCampaign Campaign { get; set; }

    public virtual MstRecruitmentCandidate RecruitmentCandidate { get; set; }
}
