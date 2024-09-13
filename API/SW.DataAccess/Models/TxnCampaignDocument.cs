using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class TxnCampaignDocument
{
    public int CampaignDocId { get; set; }

    public int? CampaignId { get; set; }

    public string DocumentName { get; set; }

    public DateOnly? StartDate { get; set; }

    public DateOnly? EndDate { get; set; }

    public string DocPath { get; set; }

    public bool? RequiredReminder { get; set; }

    public int? ReminderDay { get; set; }

    public bool? IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }
}
