using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstIndependentContractorSaving
{
    public int IndependentContractorSavingId { get; set; }

    public int IndependentContractorId { get; set; }

    public string AmountType { get; set; }

    public decimal Amount { get; set; }

    public decimal MaxLimit { get; set; }

    public DateTime StartDate { get; set; }

    public DateTime? EndDate { get; set; }

    public string SavingType { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public virtual MstIndependentContractor IndependentContractor { get; set; }
}
