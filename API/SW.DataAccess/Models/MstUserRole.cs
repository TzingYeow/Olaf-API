using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstUserRole
{
    public int UserRoleId { get; set; }

    public string UserRoleCode { get; set; }

    public string Description { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public virtual ICollection<MstUser> MstUsers { get; set; } = new List<MstUser>();
}
