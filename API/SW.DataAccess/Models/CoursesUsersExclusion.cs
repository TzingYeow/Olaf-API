using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class CoursesUsersExclusion
{
    public int Id { get; set; }

    public string UserName { get; set; }

    public string BadgeNo { get; set; }

    public string ExclusionReason { get; set; }

    public DateTime? DateAdded { get; set; }

    public string ExType { get; set; }

    public string Mcid { get; set; }
}
