using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstUser
{
    public string UserId { get; set; }

    public string Fullname { get; set; }

    public string Displayname { get; set; }

    public string Email { get; set; }

    public string Username { get; set; }

    public string UserPassword { get; set; }

    public int MarketingCompanyId { get; set; }

    public int UserRoleId { get; set; }

    public string PhoneNumber { get; set; }

    public bool IsActive { get; set; }

    public string CountryAccess { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public string DefaultPath { get; set; }

    public virtual MstMarketingCompany MarketingCompany { get; set; }

    public virtual ICollection<MstUserResetPasswordToken> MstUserResetPasswordTokens { get; set; } = new List<MstUserResetPasswordToken>();

    public virtual MstUserRole UserRole { get; set; }
}
