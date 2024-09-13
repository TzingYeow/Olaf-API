using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class TxnValidation
{
    public int TxnId { get; set; }

    public string TxnName { get; set; }

    public DateOnly? TxnDate { get; set; }

    public string Status { get; set; }

    public string CreatedBy { get; set; }

    public DateTime CreatedDate { get; set; }
}
