using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstPrRoadTripLink
{
    public int? RowNo { get; set; }

    public int? OriginalIndependentContractorId { get; set; }

    public int? RtindependentContractorId { get; set; }

    public bool? IsActive { get; set; }
}
