using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstIndependentContractorReportingNoChange
{
    public int IndependentContractorReportingNoChangesId { get; set; }

    public int IndependentContractorId { get; set; }

    public string CurrentReportingBadgeNo { get; set; }

    public string NewReportingBadgeNo { get; set; }

    public bool HasChanged { get; set; }

    public int? IndependentContractorBranchOutId { get; set; }

    public DateTime EffectiveDate { get; set; }

    public DateTime? EndDate { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public virtual MstIndependentContractor IndependentContractor { get; set; }

    public virtual MstIndependentContractorBranchOut IndependentContractorBranchOut { get; set; }
}
