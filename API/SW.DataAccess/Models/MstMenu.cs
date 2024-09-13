using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstMenu
{
    public int MenuId { get; set; }

    public string MenuCode { get; set; }

    public string MenuName { get; set; }

    public string MenuDescription { get; set; }

    public string ParentMenuCode { get; set; }

    public int? Sequence { get; set; }

    public string Path { get; set; }

    public bool IsVisible { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }
}
