using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class TxnTempManualLastSalesDate
{
    public string MoCode { get; set; }

    public string BadgeNo { get; set; }

    public DateOnly? LastSalesDate { get; set; }
}
