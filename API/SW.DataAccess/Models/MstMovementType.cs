using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstMovementType
{
    public int MovementTypeId { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public string MovementCode { get; set; }

    public string Type { get; set; }

    public virtual ICollection<MstIndependentContractorMovement> MstIndependentContractorMovements { get; set; } = new List<MstIndependentContractorMovement>();
}
