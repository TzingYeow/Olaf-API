using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstIndependentContractorBainfoWeekending
{
    public int IndependentContractorBainfoId { get; set; }

    public int? IndependentContractorId { get; set; }

    public DateOnly? WeekendingDate { get; set; }

    public int MarketingCompanyId { get; set; }

    public int? IndependentContractorLevelId { get; set; }

    public string Batype { get; set; }

    public string ReportBadgeNo { get; set; }

    public string Status { get; set; }

    public bool? IsSuspended { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public virtual MstIndependentContractor IndependentContractor { get; set; }

    public virtual MstIndependentContractorLevel IndependentContractorLevel { get; set; }
}
