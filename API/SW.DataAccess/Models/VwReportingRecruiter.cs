using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class VwReportingRecruiter
{
    public int RecruiterId { get; set; }

    public string FirstName { get; set; }

    public string MiddleName { get; set; }

    public string LastName { get; set; }

    public string LocalFirstName { get; set; }

    public string LocalLastName { get; set; }

    public string Status { get; set; }

    public int? Mcid { get; set; }

    public string Name { get; set; }

    public string Code { get; set; }

    public string CountryCode { get; set; }
}
