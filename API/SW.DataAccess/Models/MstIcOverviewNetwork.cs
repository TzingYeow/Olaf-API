using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstIcOverviewNetwork
{
    public int IcOverviewNetworkId { get; set; }

    public int IndependentContractorId { get; set; }

    public int IndependentContractorLevelId { get; set; }

    public string ReportingBadgeNo { get; set; }

    public bool? IsStaybackTeam { get; set; }

    public bool? IsGobackTeam { get; set; }

    public int MarketingCompanyId { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public virtual MstIndependentContractor IndependentContractor { get; set; }

    public virtual MstIndependentContractorLevel IndependentContractorLevel { get; set; }

    public virtual MstMarketingCompany MarketingCompany { get; set; }
}
