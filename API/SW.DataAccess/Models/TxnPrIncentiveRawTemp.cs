using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class TxnPrIncentiveRawTemp
{
    public DateOnly? Wedate { get; set; }

    public string Mocode { get; set; }

    public long? IndependentContractorId { get; set; }

    public string CountryCode { get; set; }

    public string BadgeNo { get; set; }

    public string Campaign { get; set; }

    public int? Subs { get; set; }

    public decimal? NetEarning { get; set; }

    public decimal? Bonus { get; set; }

    public DateTime? CreatedDate { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public bool? IsDeleted { get; set; }
}
