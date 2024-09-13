using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstMarketingCompanyBranch
{
    public int MarketingCompanyBranchId { get; set; }

    public string AddressLine1 { get; set; }

    public string AddressLine2 { get; set; }

    public string AddressLine3 { get; set; }

    public string City { get; set; }

    public string Postcode { get; set; }

    public string State { get; set; }

    public string Country { get; set; }

    public string TelephoneNo { get; set; }

    public string FaxNo { get; set; }

    public int MarketingCompanyId { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public virtual MstMarketingCompany MarketingCompany { get; set; }

    public virtual ICollection<MstRecruitmentCandidateActivityLog> MstRecruitmentCandidateActivityLogs { get; set; } = new List<MstRecruitmentCandidateActivityLog>();
}
