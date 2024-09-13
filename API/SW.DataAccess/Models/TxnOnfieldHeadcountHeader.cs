using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class TxnOnfieldHeadcountHeader
{
    public int OnfieldHeadcountId { get; set; }

    public int? MarketingCompanyId { get; set; }

    public DateOnly? OnfieldDate { get; set; }

    public int? TotalHeadcount { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public bool? IsDeleted { get; set; }
}
