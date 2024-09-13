using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstIndependentContractorMovement
{
    public int IndependentContractorMovementId { get; set; }

    public int IndependentContractorId { get; set; }

    public string Description { get; set; }

    public int? IndependentContractorLevelId { get; set; }

    public DateTime? PromotionDemotionDate { get; set; }

    public DateTime EffectiveDate { get; set; }

    public string LeavingReasonCategory { get; set; }

    public string LeavingReasonDescription { get; set; }

    public int? MovementDuration { get; set; }

    public string Remark { get; set; }

    public bool HasExecuted { get; set; }

    public int? MovementTypeId { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public virtual MstIndependentContractor IndependentContractor { get; set; }

    public virtual MstIndependentContractorLevel IndependentContractorLevel { get; set; }

    public virtual MstMovementType MovementType { get; set; }
}
