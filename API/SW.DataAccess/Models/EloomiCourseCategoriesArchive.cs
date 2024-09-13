using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class EloomiCourseCategoriesArchive
{
    public int Id { get; set; }

    public int CategoriesId { get; set; }

    public int? ParentId { get; set; }

    public string Name { get; set; }

    public DateTime? DataInsertedAt { get; set; }

    public DateTime? DataArchivedAt { get; set; }
}
