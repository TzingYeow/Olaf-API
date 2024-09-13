using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstIndependentContractorBadgeCard
{
    public int IndependentContractorBadgeCardId { get; set; }

    public int IndependentContractorId { get; set; }

    public int? CampaignId { get; set; }

    public string SerialNo { get; set; }

    public string BadgeType { get; set; }

    public DateTime IssueDate { get; set; }

    public DateTime ExpiredDate { get; set; }

    public bool IsActive { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public virtual MstCampaign Campaign { get; set; }

    public virtual MstIndependentContractor IndependentContractor { get; set; }
}
