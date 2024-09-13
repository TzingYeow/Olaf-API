using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstMcexclusion
{
    public int Id { get; set; }

    public int? MarketingCompanyId { get; set; }

    public string ExclusionCode { get; set; }
}
