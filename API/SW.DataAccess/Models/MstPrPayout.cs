using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstPrPayout
{
    public int PayoutId { get; set; }

    public string Country { get; set; }

    public int? MilestoneType { get; set; }

    public string PayoutType { get; set; }

    public decimal? Sw { get; set; }

    public decimal? Mc { get; set; }

    public decimal? Po { get; set; }
}
