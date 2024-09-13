using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace SW.DataAccess.Models;

public partial class TXN_SalesSummaryBonus
{
 
    public long ID { get; set; }

    [MaxLength(2)]
    public string CountryCode { get; set; }

    public int? Division { get; set; }

    public int? Campaign { get; set; }

    public DateOnly? StatusWE { get; set; }

    public DateOnly? StatusDate { get; set; }

    [MaxLength(50)]
    public string TxnID { get; set; }

    [MaxLength(2)]
    public string MOCode { get; set; }

    [MaxLength(50)]
    public string BadgeNo { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal? Amount { get; set; }

    [MaxLength(20)]
    public string BonusSource { get; set; }

    [MaxLength(50)]
    public string BonusType { get; set; }

    [MaxLength(10)]
    public string BonusCategory { get; set; }

    [MaxLength(200)]
    public string BonusRemark { get; set; }

    public bool? isClawback { get; set; }

    public bool? isDeleted { get; set; }

    public DateTime? CreatedDate { get; set; }

    [MaxLength(50)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    [MaxLength(50)]
    public string UpdatedBy { get; set; }


}