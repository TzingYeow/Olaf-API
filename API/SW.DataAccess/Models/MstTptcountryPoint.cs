using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstTptcountryPoint
{
    public string Country { get; set; }

    public DateOnly? StartWe { get; set; }

    public DateOnly? EndWe { get; set; }

    public string Balevel { get; set; }

    public decimal? PointConversion { get; set; }

    public bool? IsActive { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public  MstIndependentContractorLevel MstIndependentContractorLevel { get; set; }




}
