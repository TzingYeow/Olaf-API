using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class RptOverviewRecruitment
{
    public DateOnly WeDate { get; set; }

    public int? RHongkong { get; set; }

    public int? RIndonesia { get; set; }

    public int? RIndia { get; set; }

    public int? RKorea { get; set; }

    public int? RMalaysia { get; set; }

    public int? RPhilippines { get; set; }

    public int? RSingapore { get; set; }

    public int? RThailand { get; set; }

    public int? RTaiwan { get; set; }

    public int? McHongkong { get; set; }

    public int? McIndonesia { get; set; }

    public int? McIndia { get; set; }

    public int? McKorea { get; set; }

    public int? McMalaysia { get; set; }

    public int? McPhilippines { get; set; }

    public int? McSingapore { get; set; }

    public int? McThailand { get; set; }

    public int? McTaiwan { get; set; }

    public int? TotalMcactive { get; set; }

    public int? TotalMc { get; set; }

    public decimal? AverageMcactive { get; set; }
}
