using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstComplianceChecklist
{
    public int ComplianceChecklistId { get; set; }

    public string Description { get; set; }

    public string CountryCode { get; set; }

    public int? CampaignId { get; set; }

    public int? ComplyDuration { get; set; }

    public bool ForRecruitmentCandidate { get; set; }

    public bool ForIndependentContractor { get; set; }

    public bool IsRequiredUponCandidateConfirmation { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public bool IsAttachmentRequired { get; set; }

    public virtual MstCampaign Campaign { get; set; }

    public virtual ICollection<MstIndependentContractorCompliance> MstIndependentContractorCompliances { get; set; } = new List<MstIndependentContractorCompliance>();

    public virtual ICollection<MstRecruitmentCandidateCompliance> MstRecruitmentCandidateCompliances { get; set; } = new List<MstRecruitmentCandidateCompliance>();
}
