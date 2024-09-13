using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstCountryPoint
{
    public string Country { get; set; }

    public DateOnly? StartWe { get; set; }

    public DateOnly? EndWe { get; set; }

    public decimal? PointConversion { get; set; }

    public bool? IsActive { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }
}
