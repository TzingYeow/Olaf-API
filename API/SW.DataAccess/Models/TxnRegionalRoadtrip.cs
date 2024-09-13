using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace SW.DataAccess.Models;

public partial class TxnRegionalRoadtrip
{
    public DateOnly? Weekending { get; set; }

    [MaxLength(2)]
    public string RTCountryCode { get; set; }

    [MaxLength(10)]
    public string RTBadgeNo { get; set; }

    [MaxLength(2)]
    public string OriginalCountryCode { get; set; }

    [MaxLength(10)]
    public string OriginalBadgeNo { get; set; }
     
}