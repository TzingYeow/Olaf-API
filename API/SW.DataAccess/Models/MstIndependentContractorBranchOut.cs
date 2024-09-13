using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstIndependentContractorBranchOut
{
    public int IndependentContractorBranchOutId { get; set; }

    public int IndependentContractorId { get; set; }

    public int MarketingCompanyId { get; set; }

    public int IndependentContractorLevelId { get; set; }

    public string NewBadgeNo { get; set; }

    public DateTime NewCompanyStartDate { get; set; }

    public DateTime DeactivateDate { get; set; }

    public DateTime? CurrentCompanyReactivateDate { get; set; }

    public string GroupRefId { get; set; }

    public bool HasBranchedOut { get; set; }

    public bool HasReactivated { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public virtual MstIndependentContractor IndependentContractor { get; set; }

    public virtual MstIndependentContractorLevel IndependentContractorLevel { get; set; }

    public virtual MstMarketingCompany MarketingCompany { get; set; }

    public virtual ICollection<MstIndependentContractorReportingNoChange> MstIndependentContractorReportingNoChanges { get; set; } = new List<MstIndependentContractorReportingNoChange>();
}
