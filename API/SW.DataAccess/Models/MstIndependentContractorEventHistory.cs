using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstIndependentContractorEventHistory
{
    public int IndependentContractorEventHistoryId { get; set; }

    public int IndependentContractorId { get; set; }

    public string EventName { get; set; }

    public string Month { get; set; }

    public int Year { get; set; }

    public int IndependentContractorLevelId { get; set; }

    public double? SubsidyAmount { get; set; }

    public string TimeWithHods { get; set; }

    public string StarRisingMeetingLevel { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public virtual MstIndependentContractor IndependentContractor { get; set; }

    public virtual MstIndependentContractorLevel IndependentContractorLevel { get; set; }
}
