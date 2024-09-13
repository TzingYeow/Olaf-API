using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstBank
{
    public int BankId { get; set; }

    public string BankName { get; set; }

    public string LocalBankName { get; set; }

    public string BankCode { get; set; }

    public string CountryCode { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public string HubsBankName { get; set; }
}
