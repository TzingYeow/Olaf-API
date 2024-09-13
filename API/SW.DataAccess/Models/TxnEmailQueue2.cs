using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class TxnEmailQueue2
{
    public string TxnId { get; set; }

    public string Description { get; set; }

    public string Recipient { get; set; }

    public string Cc { get; set; }

    public string Bcc { get; set; }

    public string Subject { get; set; }

    public string Body { get; set; }

    public string Attachment { get; set; }

    public DateTime? CreateDate { get; set; }

    public string CreateBy { get; set; }
}
