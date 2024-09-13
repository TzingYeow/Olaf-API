using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class TxnRegionalSalesBonu
{
    public string Country { get; set; }

    public string Mocode { get; set; }

    public string Moname { get; set; }

    public DateOnly? Weekending { get; set; }

    public string Rmonth { get; set; }

    public string Rquarter { get; set; }

    public decimal? GrossBaearning { get; set; }

    public decimal? NetBaearning { get; set; }

    public decimal? Swbonus { get; set; }

    public decimal? ConversionRate { get; set; }

    public decimal? BuletinPoint { get; set; }
}
