using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstIndependentContractorLevel
{
    public int IndependentContractorLevelId { get; set; }

    public string LevelCode { get; set; }

    public string Level { get; set; }

    public string ParentLevel { get; set; }

    public int LevelOrdinal { get; set; }

    public bool IsActive { get; set; }

    public bool IsDemotionLevel { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public virtual ICollection<MstIcOverviewHeadcount> MstIcOverviewHeadcounts { get; set; } = new List<MstIcOverviewHeadcount>();

    public virtual ICollection<MstIcOverviewNetwork> MstIcOverviewNetworks { get; set; } = new List<MstIcOverviewNetwork>();

    public virtual ICollection<MstIndependentContractorBainfoWeekending> MstIndependentContractorBainfoWeekendings { get; set; } = new List<MstIndependentContractorBainfoWeekending>();

    public virtual ICollection<MstIndependentContractorBranchOut> MstIndependentContractorBranchOuts { get; set; } = new List<MstIndependentContractorBranchOut>();

    public virtual ICollection<MstIndependentContractorEventHistory> MstIndependentContractorEventHistories { get; set; } = new List<MstIndependentContractorEventHistory>();

    public virtual ICollection<MstIndependentContractorMovement> MstIndependentContractorMovements { get; set; } = new List<MstIndependentContractorMovement>();

    public virtual ICollection<MstIndependentContractor> MstIndependentContractors { get; set; } = new List<MstIndependentContractor>();

 





}
