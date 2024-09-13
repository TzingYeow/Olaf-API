using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstLocalization
{
    public int LocalizationId { get; set; }

    public string TextTag { get; set; }

    public string TextType { get; set; }

    public string Page { get; set; }

    public string Remark { get; set; }

    public string Endescription { get; set; }

    public string Mydescription { get; set; }

    public string Twdescription { get; set; }

    public string Hkdescription { get; set; }

    public string Krdescription { get; set; }

    public string Thdescription { get; set; }

    public string Phdescription { get; set; }

    public string Iddescription { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }
}
