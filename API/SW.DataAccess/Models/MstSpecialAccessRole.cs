using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstSpecialAccessRole
{
    public int AccessId { get; set; }

    public string Route { get; set; }

    public string UserId { get; set; }

    public bool? IsActive { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }
}
