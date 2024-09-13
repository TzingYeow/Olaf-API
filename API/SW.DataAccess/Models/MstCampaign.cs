using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstCampaign
{
    public int CampaignId { get; set; }

    public string CampaignCode { get; set; }

    public string CampaignName { get; set; }

    public int DivisionId { get; set; }

    public string CountryCode { get; set; }

    public string SerialPrefix { get; set; }

    public bool IsTestProduct { get; set; }

    public int TempId { get; set; }

    public string ClientCode { get; set; }

    public bool IsActive { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public virtual MstDivision Division { get; set; }

    public virtual ICollection<MstComplianceChecklist> MstComplianceChecklists { get; set; } = new List<MstComplianceChecklist>();

    public virtual ICollection<MstIndependentContractorAssignment> MstIndependentContractorAssignments { get; set; } = new List<MstIndependentContractorAssignment>();

    public virtual ICollection<MstIndependentContractorBadgeCard> MstIndependentContractorBadgeCards { get; set; } = new List<MstIndependentContractorBadgeCard>();

    public virtual ICollection<MstIndependentContractorCheckIn> MstIndependentContractorCheckIns { get; set; } = new List<MstIndependentContractorCheckIn>();

    public virtual ICollection<MstIndependentContractorPayableTraining> MstIndependentContractorPayableTrainings { get; set; } = new List<MstIndependentContractorPayableTraining>();

    public virtual ICollection<MstIndependentContractorTraining> MstIndependentContractorTrainings { get; set; } = new List<MstIndependentContractorTraining>();

    public virtual ICollection<MstMarketingCompanyCampaign> MstMarketingCompanyCampaigns { get; set; } = new List<MstMarketingCompanyCampaign>();

    public virtual ICollection<MstRecruitmentCandidateAssignment> MstRecruitmentCandidateAssignments { get; set; } = new List<MstRecruitmentCandidateAssignment>();

    public virtual ICollection<MstRecruitmentCandidateInduction> MstRecruitmentCandidateInductions { get; set; } = new List<MstRecruitmentCandidateInduction>();
}
