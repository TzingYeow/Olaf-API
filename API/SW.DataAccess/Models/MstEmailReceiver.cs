using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstEmailReceiver
{
    public int ReceiverId { get; set; }

    public string CountryCode { get; set; }

    public string EmailType { get; set; }

    public string Email { get; set; }

    public string ReceiverDescription { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }
}
