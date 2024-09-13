using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class RptOverviewDetailByCountry
{
    public DateOnly? WeDate { get; set; }

    public string Country { get; set; }

    public string MoCode { get; set; }

    public int? ActiveIc { get; set; }

    public int? FormSubmitted { get; set; }

    public int? FirstAppoinment { get; set; }

    public string Recruitment { get; set; }
}
