using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class TxnHuddleRpt
{
    public string Country { get; set; }

    public string Division { get; set; }

    public string Customer { get; set; }

    public DateOnly? Weekending { get; set; }

    public string Rmonth { get; set; }

    public string Rquarter { get; set; }

    public int GrossPiece { get; set; }

    public int OneTimePieces { get; set; }

    public int RejectPieces { get; set; }

    public int ResubPieces { get; set; }

    public int NetPiece { get; set; }

    public int? CountryUshc { get; set; }

    public int? DivUsch { get; set; }

    public int? Usch { get; set; }

    public decimal? GrossSales { get; set; }

    public int? NewStarter { get; set; }

    public int? Leaver { get; set; }

    public int CountryHc { get; set; }

    public int CountryDivHc { get; set; }

    public int CountryCampaignHc { get; set; }

    public decimal GrossBaearning { get; set; }

    public decimal NetBaearning { get; set; }

    public decimal Swbonus { get; set; }

    public decimal BuletinPoint { get; set; }

    public int RejectPieceOt { get; set; }

    public int RejectPieceRec { get; set; }

    public int ResubPieceOt { get; set; }

    public int ResubPieceRec { get; set; }
}
