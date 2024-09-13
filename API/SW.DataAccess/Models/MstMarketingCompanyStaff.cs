using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstMarketingCompanyStaff
{
    public int MarketingCompanyStaffId { get; set; }

    public string Name { get; set; }

    public string Email { get; set; }

    public string PhoneNumber { get; set; }

    public string Postion { get; set; }

    public int MarketingCompanyId { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public virtual MstMarketingCompany MarketingCompany { get; set; }
}
