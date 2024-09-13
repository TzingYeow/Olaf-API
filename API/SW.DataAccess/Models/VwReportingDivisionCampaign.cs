using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class VwReportingDivisionCampaign
{
    public int DivisionId { get; set; }

    public string DivisionCode { get; set; }

    public string DivisionName { get; set; }

    public int? CampaignId { get; set; }

    public string CampaignCode { get; set; }

    public string CampaignName { get; set; }

    public string CountryCode { get; set; }

    public bool? IsTestProduct { get; set; }

    public bool? CampaignIsActive { get; set; }
}
