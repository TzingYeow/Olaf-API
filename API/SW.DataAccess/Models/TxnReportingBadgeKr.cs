using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class TxnReportingBadgeKr
{
    public int RowId { get; set; }

    public DateOnly? Wedate { get; set; }

    public string DirectReportBadgeNumber { get; set; }

    public string BadgeNo { get; set; }

    public string CurrentLevel { get; set; }

    public string LevelCode { get; set; }

    public string BadgeNolink { get; set; }
}
