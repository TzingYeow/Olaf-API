using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstIndependentContractorSuspension
{
    public int IndependentContractorSuspensionId { get; set; }

    public int IndependentContractorId { get; set; }

    public string Description { get; set; }

    public int? IndependentContractorLevelId { get; set; }

    public DateOnly? StartDate { get; set; }

    public DateOnly? EndDate { get; set; }

    public string Remark { get; set; }

    public bool IsReactivate { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }
}
