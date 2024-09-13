using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstUserResetPasswordToken
{
    public int UserResetPasswordTokenId { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public string UserId { get; set; }

    public string Email { get; set; }

    public string Token { get; set; }

    public bool HasUsed { get; set; }

    public DateTime TokenExpiredDateTime { get; set; }

    public virtual MstUser User { get; set; }
}
