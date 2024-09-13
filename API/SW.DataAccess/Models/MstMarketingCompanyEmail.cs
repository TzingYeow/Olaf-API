using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstMarketingCompanyEmail
{
    public int MarketingCompanyEmailId { get; set; }

    public int MarketingCompanyId { get; set; }

    public string Email { get; set; }

    public string Password { get; set; }

    public string EmailProvider { get; set; }

    public int PortNo { get; set; }

    public bool IsActive { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public bool EnableSsl { get; set; }
}
