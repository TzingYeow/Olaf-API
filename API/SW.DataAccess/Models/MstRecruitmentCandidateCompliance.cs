using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstRecruitmentCandidateCompliance
{
    public int RecruitmentCandidateComplianceId { get; set; }

    public int RecruitmentCandidateId { get; set; }

    public int ComplianceChecklistId { get; set; }

    public bool HasComplied { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public virtual MstComplianceChecklist ComplianceChecklist { get; set; }

    public virtual MstRecruitmentCandidate RecruitmentCandidate { get; set; }
}
