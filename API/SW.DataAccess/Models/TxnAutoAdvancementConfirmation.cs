using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class TxnAutoAdvancementConfirmation
{
    public int AdvancementId { get; set; }

    public int? MarketingCompanyId { get; set; }

    public int? IndependentContractorId { get; set; }

    public DateOnly? WeekendingDate { get; set; }

    public bool? Mta { get; set; }

    public bool? Incoperation { get; set; }

    public bool? Mcagreement { get; set; }

    public string Remark { get; set; }

    public string Status { get; set; }

    public DateOnly? StatusDate { get; set; }

    public bool? IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }
}
