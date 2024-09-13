using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class TxnPrSingapore
{
    public int RowNo { get; set; }

    public DateOnly? ScheduleWeekending { get; set; }

    public string Mocode { get; set; }

    public string BadgeNo { get; set; }

    public string Division { get; set; }

    public int? BasubPcs { get; set; }

    public decimal? BanetEarning { get; set; }

    public decimal? BanetBonus1 { get; set; }

    public decimal? BanetBonus2 { get; set; }
}
