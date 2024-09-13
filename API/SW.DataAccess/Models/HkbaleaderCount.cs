using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class HkbaleaderCount
{
    public string Badgeno { get; set; }

    public string Country { get; set; }

    public DateOnly? Weekending { get; set; }

    public string Mccode { get; set; }

    public int? FirstGenLeaderCount { get; set; }
}
