using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class VwIndependentContractorsPreview
{
    public int IndependentContractorId { get; set; }

    public string OriginalBadgeNo { get; set; }

    public string BadgeNo { get; set; }

    public string ReportBadgeNo { get; set; }

    public string Fullname { get; set; }

    public DateTime? DateFirstOnField { get; set; }

    public DateTime? StartDate { get; set; }

    public string Status { get; set; }

    public string Level { get; set; }

    public int? MarketingCompanyId { get; set; }

    public string McCode { get; set; }

    public string McName { get; set; }

    public string CountryCode { get; set; }
}
