using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class TxnRegionalSalesSummaryUat
{
    public Guid? Guid { get; set; }

    public string CountryCode { get; set; }

    public string TxnId { get; set; }

    public string Client { get; set; }

    public string Campaign { get; set; }

    public string Division { get; set; }

    public string Mocode { get; set; }

    public string BadgeNo { get; set; }

    public string LiveStatus { get; set; }

    public string Status { get; set; }

    public DateOnly? StatusDate { get; set; }

    public DateOnly? StatusWeDate { get; set; }

    public decimal? DonationAmount { get; set; }

    public int? Frequency { get; set; }

    public DateOnly? SignUpDate { get; set; }

    public DateOnly? SignUpWeDate { get; set; }

    public DateOnly? SubmissionDate { get; set; }

    public DateOnly? SubmissionWeDate { get; set; }

    public string PaymentMode { get; set; }

    public string Channel { get; set; }

    public string TeritoryCode { get; set; }

    public string EventCode { get; set; }

    public DateOnly? DateOfBirth { get; set; }

    public string IsUnderAge { get; set; }

    public int? Age { get; set; }

    public string IsDobo { get; set; }

    public string DoboType { get; set; }

    public decimal? OwnerStroke { get; set; }

    public decimal? Icstroke { get; set; }

    public string IsDeleted { get; set; }

    public int? Qty { get; set; }

    public int? RejQty { get; set; }

    public int? ResubQty { get; set; }

    public DateTime? TxnCreatedDate { get; set; }
}
