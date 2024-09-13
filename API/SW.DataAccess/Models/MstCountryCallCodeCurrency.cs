using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstCountryCallCodeCurrency
{
    public int CountryId { get; set; }

    public string CountryCode { get; set; }

    public string CountryName { get; set; }

    public string DialCode { get; set; }

    public string CurrencyCode { get; set; }

    public int CurOrdering { get; set; }
}
