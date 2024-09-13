using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class CoursesModuleSetting
{
    public int CourseModuleSettingId { get; set; }

    public int GroupId { get; set; }

    public string CourseName { get; set; }

    public string CourseDescription { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public int? EloomiCourseId { get; set; }

    public int? EloomiCategoryId { get; set; }
}
