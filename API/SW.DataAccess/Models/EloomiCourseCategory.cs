using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class EloomiCourseCategory
{
    public int CategoriesId { get; set; }

    public int? ParentId { get; set; }

    public string Name { get; set; }

    public DateTime? DataInsertedAt { get; set; }
}
