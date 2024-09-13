using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstWeekending
{
    public string Id { get; set; }

    public DateOnly? Wedate { get; set; }

    public DateOnly? FromDate { get; set; }

    public DateOnly? ToDate { get; set; }

    public bool? Status { get; set; }

    public string CreatedBy { get; set; }

    public DateTime CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public DateOnly? MonthEnd { get; set; }

    public bool? IsMonthEnd { get; set; }

    public static IEnumerable<object> Where(Func<object, bool> value)
    {
        throw new NotImplementedException();
    }
}
