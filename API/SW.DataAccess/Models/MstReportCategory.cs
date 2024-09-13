using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstReportCategory
{
    public int ReportCategoryId { get; set; }

    public string ReportCategoryCode { get; set; }

    public int? ReportCategorySeq { get; set; }

    public string Name { get; set; }

    public string Description { get; set; }

    public bool? IsActive { get; set; }
}
