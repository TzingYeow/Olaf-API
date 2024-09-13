using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstAutoAdvancementSalesJenny
{
    public int SalesId { get; set; }

    public DateOnly Weekending { get; set; }

    public string CountryCode { get; set; }

    public string Mocode { get; set; }

    public string BadgeNo { get; set; }

    public decimal? PersonalPayable { get; set; }

    public decimal? TeamPayable { get; set; }

    public decimal? BulletinPoint { get; set; }

    public int? PersonalSalesPieces { get; set; }

    public int? FirstGenLeader { get; set; }

    public int? TotalLeader { get; set; }

    public int? TeamSize { get; set; }

    public int? IndependentContractorLevelId { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }
}
