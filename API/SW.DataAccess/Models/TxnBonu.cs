using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class TxnBonu
{
    public string BonusType { get; set; }

    public string BonusDescription { get; set; }

    public decimal? BonusAmount { get; set; }

    public DateOnly? StartDate { get; set; }

    public DateOnly? EndDate { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public string UpdatedBy { get; set; }
}
