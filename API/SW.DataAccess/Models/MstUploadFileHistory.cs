using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstUploadFileHistory
{
    public int UploadFileHistoryId { get; set; }

    public string FullPath { get; set; }

    public string FileName { get; set; }

    public string Action { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }
}
