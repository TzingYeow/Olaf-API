using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstDivision
{
    public int DivisionId { get; set; }

    public string DivisionCode { get; set; }

    public string DivisionName { get; set; }

    public string ParentDivision { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public virtual ICollection<MstCampaign> MstCampaigns { get; set; } = new List<MstCampaign>();
}
