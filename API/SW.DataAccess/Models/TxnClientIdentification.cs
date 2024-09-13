using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class TxnClientIdentification
{
    public int ClientIdentificationId { get; set; }

    public int? MarketingCompanyId { get; set; }

    public int? IndependentContractorId { get; set; }

    public int? CampaignId { get; set; }

    public DateOnly? StartDate { get; set; }

    public DateOnly? EndDate { get; set; }

    public string IdentificationId { get; set; }

    public bool? IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }
}
