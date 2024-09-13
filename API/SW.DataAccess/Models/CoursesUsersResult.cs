using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class CoursesUsersResult
{
    public int Id { get; set; }

    public int? EloomiUserId { get; set; }

    public int? CourseId { get; set; }

    public int? IndependentContractorId { get; set; }

    public int? Status { get; set; }

    public DateTime? DataCreatedAt { get; set; }

    public DateTime? DataUpdatedAt { get; set; }
}
