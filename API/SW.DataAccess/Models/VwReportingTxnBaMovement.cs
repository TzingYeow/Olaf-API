using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class VwReportingTxnBaMovement
{
    public int IndependentContractorMovementId { get; set; }

    public int Baid { get; set; }

    public string BadgeNo { get; set; }

    public string OriginalBadgeNo { get; set; }

    public int? Mcid { get; set; }

    public string Mccode { get; set; }

    public string Mcname { get; set; }

    public string Mccountry { get; set; }

    public string Mcstatus { get; set; }

    public string Description { get; set; }

    public DateTime? PromotionDemotionDate { get; set; }

    public DateTime EffectiveDate { get; set; }

    public string LeavingReasonCategory { get; set; }

    public string LeavingReasonDescription { get; set; }

    public int? MovementDuration { get; set; }

    public string Remark { get; set; }

    public bool HasExecuted { get; set; }

    public int? MovementTypeId { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public int? IndependentContractorLevelId { get; set; }

    public string LevelCode { get; set; }

    public string Level { get; set; }

    public string ParentLevel { get; set; }

    public int LevelOrdinal { get; set; }

    public bool LevelActive { get; set; }

    public bool IsDemotionLevel { get; set; }
}
