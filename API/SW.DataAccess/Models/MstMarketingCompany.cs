using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstMarketingCompany
{
    public int MarketingCompanyId { get; set; }

    public string Code { get; set; }

    public string Name { get; set; }

    public string Email { get; set; }

    public string CountryCode { get; set; }

    public string BankName { get; set; }

    public string BankAccountNo { get; set; }

    public string CompanyLogo { get; set; }

    public bool IsActive { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public int TempId { get; set; }

    public string ApplicationFormUrl { get; set; }

    public string Banner { get; set; }

    public string BgColor { get; set; }

    public string MarketingCompanyType { get; set; }

    public string Province { get; set; }

    public virtual ICollection<MstIcOverviewHeadcount> MstIcOverviewHeadcounts { get; set; } = new List<MstIcOverviewHeadcount>();

    public virtual ICollection<MstIcOverviewNetwork> MstIcOverviewNetworks { get; set; } = new List<MstIcOverviewNetwork>();

    public virtual ICollection<MstIndependentContractorBranchOut> MstIndependentContractorBranchOuts { get; set; } = new List<MstIndependentContractorBranchOut>();

    public virtual ICollection<MstIndependentContractor> MstIndependentContractors { get; set; } = new List<MstIndependentContractor>();

    public virtual ICollection<MstMarketingCompanyBranch> MstMarketingCompanyBranches { get; set; } = new List<MstMarketingCompanyBranch>();

    public virtual ICollection<MstMarketingCompanyCampaign> MstMarketingCompanyCampaigns { get; set; } = new List<MstMarketingCompanyCampaign>();

    public virtual ICollection<MstMarketingCompanyStaff> MstMarketingCompanyStaffs { get; set; } = new List<MstMarketingCompanyStaff>();

    public virtual ICollection<MstRecruiter> MstRecruiters { get; set; } = new List<MstRecruiter>();

    public virtual ICollection<MstRecruitmentCandidate> MstRecruitmentCandidates { get; set; } = new List<MstRecruitmentCandidate>();

    public virtual ICollection<MstRecruitmentComparisonSummary> MstRecruitmentComparisonSummaries { get; set; } = new List<MstRecruitmentComparisonSummary>();

    public virtual ICollection<MstUser> MstUsers { get; set; } = new List<MstUser>();
}
