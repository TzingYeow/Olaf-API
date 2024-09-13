using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class TxnWeeklyBasummary
{
    public DateOnly? WeDate { get; set; }

    public string CountryCode { get; set; }

    public string Mccode { get; set; }

    public int? IndependentContractorId { get; set; }

    public string BadgeNo { get; set; }

    public string CurrentLevel { get; set; }

    public string Welevel { get; set; }

    public string BadgeNoLink { get; set; }

    public string DirectReportBadgeNo { get; set; }

    public DateOnly? LevelPromotionDate { get; set; }

    public decimal? NetPoint { get; set; }

    public decimal? NetValue { get; set; }

    public int? NetPcs { get; set; }

    public int? SubPcs { get; set; }

    public DateTime? CreatedDate { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public bool? IsDeleted { get; set; }
}
