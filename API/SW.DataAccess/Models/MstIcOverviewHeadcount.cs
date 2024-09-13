using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstIcOverviewHeadcount
{
    public int IcOverviewHeadcountId { get; set; }

    public int MarketingCompanyId { get; set; }

    public string RecruitmentType { get; set; }

    public int IndependentContractorLevelId { get; set; }

    public string Status { get; set; }

    public int HeadCount { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public virtual MstIndependentContractorLevel IndependentContractorLevel { get; set; }

    public virtual MstMarketingCompany MarketingCompany { get; set; }
}
