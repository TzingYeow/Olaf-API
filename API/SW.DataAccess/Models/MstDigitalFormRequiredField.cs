using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstDigitalFormRequiredField
{
    public int FormRequiredId { get; set; }

    public string Field { get; set; }

    public bool? IsActive { get; set; }

    public bool? IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }
}
