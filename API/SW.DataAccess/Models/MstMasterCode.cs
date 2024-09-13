using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstMasterCode
{
    public int Id { get; set; }

    public string CodeType { get; set; }

    public string CodeId { get; set; }

    public string CodeName { get; set; }

    public string CodeDescription { get; set; }

    public byte[] CodeIcon { get; set; }

    public int? ParentId { get; set; }

    public bool IsActive { get; set; }

    public string CreatedBy { get; set; }

    public DateTime CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public bool HasLocale { get; set; }

    public string RefMessage { get; set; }

    public string RefString1 { get; set; }

    public string RefString1Description { get; set; }

    public string RefString2 { get; set; }

    public string RefString2Description { get; set; }

    public decimal? RefDecimal { get; set; }

    public string RefDecimalDescription { get; set; }

    public bool? RefBoolean { get; set; }

    public string RefBooleanDescription { get; set; }
}
