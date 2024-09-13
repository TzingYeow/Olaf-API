using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstReport
{
    public int ReportId { get; set; }

    public string ReportRdl { get; set; }

    public int ReportSeq { get; set; }

    public string ReportCategoryCode { get; set; }

    public string ServerPath { get; set; }

    public string Name { get; set; }

    public string Description { get; set; }

    public bool? IsActive { get; set; }
}
