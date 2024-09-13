using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class TxnTempStarhubCpq
{
    public long Id { get; set; }

    public Guid? SystemTransactionKey { get; set; }

    public DateOnly? SubmissionDate { get; set; }

    public string Reseller { get; set; }

    public string NewAccountType { get; set; }

    public string TypeOfContract { get; set; }

    public int? RevenueFlag { get; set; }

    public string ProductName { get; set; }

    public string CompanyName { get; set; }

    public string BusinessRegNo { get; set; }

    public string Promotion { get; set; }

    public string Mrccurrency { get; set; }

    public decimal? Mrc { get; set; }

    public int? QuantityPaidMonths { get; set; }

    public string Ccvcurrency { get; set; }

    public decimal? Ccv { get; set; }

    public DateOnly? OrderCreatedDate { get; set; }

    public string OpportunityStatus { get; set; }

    public DateOnly? OrderLastModifiedDate { get; set; }

    public string StarhubServiceId { get; set; }

    public string OpportunityNo { get; set; }

    public string OwnerDivision { get; set; }

    public int? Cpqopportunity { get; set; }

    public DateOnly? OrderAcceptanceDate { get; set; }

    public DateOnly? DateContractSigned { get; set; }

    public DateOnly? DateOrderSubmitted { get; set; }

    public DateOnly? CloseDate { get; set; }

    public string PrimaryContact { get; set; }

    public string ContactEmail { get; set; }

    public string ContactOfficePhone { get; set; }

    public string Contact1 { get; set; }

    public string Contact1Email { get; set; }

    public string NewAccountDate { get; set; }

    public string ExistingAccountDate { get; set; }

    public string Crdate { get; set; }

    public string OpportunityOwner { get; set; }

    public string ChannelPartner { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string CreatedBy { get; set; }
}
