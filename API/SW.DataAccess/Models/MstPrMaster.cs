using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstPrMaster
{
    public int Prid { get; set; }

    public int? IndependentContractorId { get; set; }

    public DateOnly? StartDate { get; set; }

    public DateOnly? StartDateWe { get; set; }

    public int? RecruiterIndependentContractorId { get; set; }

    public int? RecruiterIndependentContractorLevelId { get; set; }

    public DateOnly? MileStone1 { get; set; }

    public DateOnly? MileStone2 { get; set; }

    public DateOnly? MileStone3 { get; set; }

    public int? MileStone4 { get; set; }

    public DateOnly? MileStone5 { get; set; }

    public DateOnly? MileStone6 { get; set; }

    public DateOnly? MileStone7 { get; set; }

    public DateTime? CreatedDate { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public bool? IsDeleted { get; set; }
}
