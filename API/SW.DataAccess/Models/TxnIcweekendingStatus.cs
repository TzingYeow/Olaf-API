using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class TxnIcweekendingStatus
{
    public int Baid { get; set; }

    public string BadgeNo { get; set; }

    public int? Mcid { get; set; }

    public string Mcname { get; set; }

    public DateTime? StartDate { get; set; }

    public DateOnly? StartDateWeekending { get; set; }

    public DateTime? LastDeactivateDate { get; set; }

    public DateOnly? LastDeactivateWeekending { get; set; }

    public string Status { get; set; }

    public string RecruitmentType { get; set; }

    public DateOnly? ActivityGroupWeekending { get; set; }

    public string CountryCode { get; set; }

    public string Balevel { get; set; }

    public DateOnly? Westatus { get; set; }

    public bool? ActiveStatus { get; set; }

    public string Westage { get; set; }

    public string Mccode { get; set; }
}
