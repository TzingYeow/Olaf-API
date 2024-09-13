using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstAdvancementCriterion
{
    public int AdvancementId { get; set; }

    public string CountryCode { get; set; }

    public string Province { get; set; }

    public int IndependentContractorLevelId { get; set; }

    public decimal? SalesValue { get; set; }

    public int? SalesPoint { get; set; }

    public int? PersonalSalesPieces { get; set; }

    public int? FirstGenLeader { get; set; }

    public int? TotalLeader { get; set; }

    public int? TeamSize { get; set; }

    public int? TeamSizeLevel { get; set; }

    public string TeamSizeSale { get; set; }

    public DateTime StartDate { get; set; }

    public DateTime? EndDate { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }
}
