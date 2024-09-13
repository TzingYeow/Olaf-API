using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class TxnPrDetail
{
    public int RowId { get; set; }

    public int Prid { get; set; }

    public int? IndependentContractorLevelId { get; set; }

    public int? RecruiterIndependentContractorLevelId { get; set; }

    public int? RecruiterSubPcs { get; set; }

    public int? MilestonesType { get; set; }

    public decimal? MileStonesPoint { get; set; }

    public decimal? MileStonesValue { get; set; }

    public string MilestonesData { get; set; }

    public int? PayoutId { get; set; }

    public DateOnly? MilestoneHitWe { get; set; }

    public bool? MilestonePayable { get; set; }

    public DateOnly? MilestonePayoutWe { get; set; }

    public DateTime? CreatedDate { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public string IsDeleted { get; set; }

    public string Campaign { get; set; }
}
