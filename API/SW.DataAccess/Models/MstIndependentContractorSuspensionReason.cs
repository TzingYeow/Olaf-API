using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstIndependentContractorSuspensionReason
{
    public int SuspensionReasonId { get; set; }

    public int UserRoleId { get; set; }

    public string CountryCode { get; set; }

    public string Description { get; set; }

    public int PeriodDuration { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }
}
