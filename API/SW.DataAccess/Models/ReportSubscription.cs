using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class ReportSubscription
{
    public Guid SubscriptionId { get; set; }

    public Guid OwnerId { get; set; }

    public Guid ReportOid { get; set; }

    public string Locale { get; set; }

    public int InactiveFlags { get; set; }

    public string ExtensionSettings { get; set; }

    public Guid ModifiedById { get; set; }

    public DateTime ModifiedDate { get; set; }

    public string Description { get; set; }

    public string LastStatus { get; set; }

    public string EventType { get; set; }

    public string MatchData { get; set; }

    public DateTime? LastRunTime { get; set; }

    public string Parameters { get; set; }

    public string DataSettings { get; set; }

    public string DeliveryExtension { get; set; }

    public int Version { get; set; }

    public int ReportZone { get; set; }
}
