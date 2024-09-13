using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class TxnTptdetails
{
    public int DetailsId { get; set; }

    public DateOnly? WeDate { get; set; }

    public string CountryCode { get; set; }

    public string Mccode { get; set; }

    public string Mcname { get; set; }

    public string BadgeNo { get; set; }

    public string Baname { get; set; }

    public string CurrentLevel { get; set; }

    public string BadgeNoLink { get; set; }

    public decimal? TeamProduction { get; set; }

    public int? CampaignId { get; set; }

    public decimal? NetValue { get; set; }

    public decimal? Point { get; set; }

    public int? Ranking { get; set; }

    public string Level { get; set; }

    public decimal? Rate { get; set; }

    public string Division { get; set; }


}
