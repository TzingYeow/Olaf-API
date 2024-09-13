using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstChannel
{
    public int ChannelId { get; set; }

    public string ChannelCode { get; set; }

    public string ChannelName { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public virtual ICollection<MstIndependentContractorCheckIn> MstIndependentContractorCheckIns { get; set; } = new List<MstIndependentContractorCheckIn>();
}
