using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstBatype
{
    public int Id { get; set; }

    public int? MasterId { get; set; }

    public int? MarketingCompanyId { get; set; }
}
