using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace SW.DataAccess.Models;

public partial class VW_BARelationship
{
    [MaxLength(2)]
    public string CountryCode { get; set; }

    public DateOnly? WEDate { get; set; }

    public int? IndependentContractorId { get; set; }

    [MaxLength(100)]
    public string BadgeNo { get; set; }

    public int? DirectReportIndependentContractor { get; set; }

    [MaxLength(100)]
    public string DirectReportBadgeNumber { get; set; }

    public int? IndependentContractorLevelId { get; set; }

    public int? RelationLevel { get; set; }

     public string BadgeNoLink { get; set; }

    public TXN_SalesSummaryBonus TXN_SalesSummaryBonus { get; set; }

}