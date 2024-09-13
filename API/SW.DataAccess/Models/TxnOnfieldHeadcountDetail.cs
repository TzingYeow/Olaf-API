using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class TxnOnfieldHeadcountDetail
{
    public int DetailId { get; set; }

    public int? OnfieldHeadcountId { get; set; }

    public int? IndependentContractorId { get; set; }

    public int? CampaignId { get; set; }

    public bool? Status { get; set; }

    public string Session { get; set; }

    public string Channel { get; set; }

    public string Location { get; set; }
}
