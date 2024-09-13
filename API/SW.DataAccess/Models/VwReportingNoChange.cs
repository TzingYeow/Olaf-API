using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class VwReportingNoChange
{
    public int TransactionId { get; set; }

    public string BadgeNo { get; set; }

    public string LeaderBadgeNo { get; set; }

    public DateTime StartDate { get; set; }

    public DateTime? EndDate { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }
}
