using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstIndependentContractorCheckIn
{
    public int CheckInId { get; set; }

    public int IndependentContractorId { get; set; }

    public int CampaignId { get; set; }

    public int ChannelId { get; set; }

    public string Location { get; set; }

    public DateOnly CheckInDate { get; set; }

    public string Session { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public virtual MstCampaign Campaign { get; set; }

    public virtual MstChannel Channel { get; set; }
}
