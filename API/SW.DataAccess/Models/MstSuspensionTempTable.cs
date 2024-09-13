using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstSuspensionTempTable
{
    public int Id { get; set; }

    public string Type { get; set; }

    public DateTime? SuspensionRunDate { get; set; }

    public string CountryCode { get; set; }

    public string Mccode { get; set; }

    public string BadgeNo { get; set; }

    public DateTime? LastSalesDate { get; set; }

    public DateTime? LastSalesSubmissionDate { get; set; }

    public DateTime? Correctedlastdate { get; set; }

    public string IndependentContractorId { get; set; }

    public string Description { get; set; }

    public string LeavingReasonCategory { get; set; }

    public string LeavingReasonDescription { get; set; }

    public string IndependentContractorLevelId { get; set; }

    public DateTime? StartDate { get; set; }

    public DateTime? EndDate { get; set; }

    public DateTime? EffectiveDate { get; set; }

    public bool? IsReactivate { get; set; }

    public bool? IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }
}
