using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class EloomiCoursesDatum
{
    public int Id { get; set; }

    public string Name { get; set; }

    public string Description { get; set; }

    public int? Cover { get; set; }

    public int? Active { get; set; }

    public string Points { get; set; }

    public int? Reward { get; set; }

    public string ExpectedDuration { get; set; }

    public string Voluntary { get; set; }

    public int? LockAfterDeadline { get; set; }

    public int? InformLeaderDeadline { get; set; }

    public string ReferenceNumber { get; set; }

    public string CreatedAt { get; set; }

    public string UpdatedAt { get; set; }

    public decimal? Price { get; set; }

    public DateTime? DataInsertedAt { get; set; }
}
