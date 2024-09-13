using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstCountryPostcode
{
    public int Postcode { get; set; }

    public string City { get; set; }

    public string State { get; set; }

    public string Country { get; set; }
}
