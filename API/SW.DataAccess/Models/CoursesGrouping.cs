using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class CoursesGrouping
{
    public int GroupId { get; set; }

    public string GroupDescription { get; set; }

    public string CountryCode { get; set; }

    public string Campaign { get; set; }

    public bool IsAllCampaign { get; set; }

    public bool IsCompulsory { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }
}
