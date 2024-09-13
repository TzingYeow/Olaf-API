using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class YtUser
{
    public int Id { get; set; }

    public int? CompanyId { get; set; }

    public string Forename { get; set; }

    public string Surname { get; set; }

    public string Email { get; set; }

    public int? ActiveStatusId { get; set; }
}
