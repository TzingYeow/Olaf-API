using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstRecruiter
{
    public int RecruiterId { get; set; }

    public string FirstName { get; set; }

    public string MiddleName { get; set; }

    public string LastName { get; set; }

    public string LocalFirstName { get; set; }

    public string LocalLastName { get; set; }

    public int MarketingCompanyId { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public virtual MstMarketingCompany MarketingCompany { get; set; }
}
