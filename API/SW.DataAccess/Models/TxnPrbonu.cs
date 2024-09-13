using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class TxnPrbonu
{
    public string ScheduleWeekending { get; set; }

    public string CountryCode { get; set; }

    public string Code { get; set; }

    public string Name { get; set; }

    public int IndependentContractorId { get; set; }

    public string BadgeNo { get; set; }

    public string FirstName { get; set; }

    public string LastName { get; set; }

    public DateTime? StartDate { get; set; }

    public DateTime? LastDeactivateDate { get; set; }

    public string RecruiterBadgeNoOrName { get; set; }

    public DateTime? LastSalesSubmissionDate { get; set; }

    public int? RecruiterIndependentContractorId { get; set; }

    public string RecruiterBadgeNo { get; set; }

    public string RecruiterFirstName { get; set; }

    public string RecruiterLastName { get; set; }

    public string RecruiterStatus { get; set; }

    public DateTime CreatedDate { get; set; }

    public DateTime UpdatedDate { get; set; }

    public bool? IsDeleted { get; set; }
}
